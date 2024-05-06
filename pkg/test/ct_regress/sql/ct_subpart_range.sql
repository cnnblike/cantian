create tablespace partrange_tablespace1 datafile 'tablespace_partrange_001' size 32M AUTOEXTEND on next 16M extent autoallocate;
create tablespace partrange_tablespace2 datafile 'tablespace_partrange_002' size 32M AUTOEXTEND on next 16M extent autoallocate;
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
	insert into NEBULA.STRG_RANGE_DML_MUL_TBL_000 values(j, j, j, c_part || j ||'Cabdg', c_subpart || 'OE', c_part || j ||'Bdbed','bki'|| part_no || subpart_no ||'fdger','pwo'|| j ||'vedef', c_part || j ||'Yed3f','uq',4801|| j ,940|| j ,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANdfdffdfRB'|| j ,'QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF'|| j ,'1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323');
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

--range-range
drop table if exists NEBULA.STRG_RANGE_DDL_MUL_TBL_001;
CREATE TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_ID INT,C_D_ID INT NOT NULL,C_W_ID INT NOT NULL,C_FIRST VARCHAR(64) NOT NULL,C_MIDDLE CHAR(3),C_LAST VARCHAR(64) NOT NULL,C_STREET_1 VARCHAR(20) NOT NULL,C_STREET_2 VARCHAR(20),C_CITY VARCHAR(64) NOT NULL,C_STATE CHAR(2) NOT NULL,C_ZIP CHAR(9) NOT NULL,C_PHONE CHAR(16) NOT NULL,C_SINCE TIMESTAMP,C_CREDIT CHAR(2) NOT NULL,C_CREDIT_LIM NUMERIC(12,2),C_DISCOUNT NUMERIC(4,4),C_BALANCE NUMERIC(12,2),C_YTD_PAYMENT REAL NOT NULL,C_PAYMENT_CNT NUMBER NOT NULL,C_DELIVERY_CNT BOOLEAN NOT NULL,C_END DATE NOT NULL,C_VCHAR VARCHAR(1000),C_DATA CLOB,C_TEXT BLOB ) PARTITION BY RANGE(C_ID,C_CITY,C_FIRST,C_LAST) SUBPARTITION BY RANGE(C_D_ID, C_MIDDLE) (
PARTITION PART_1 VALUES LESS THAN (201,'B','B','B')tablespace partrange_tablespace1
(
 SUBPARTITION PART_11 VALUES LESS THAN(41, 'B'),
 SUBPARTITION PART_12 VALUES LESS THAN(81, 'C'),
 SUBPARTITION PART_13 VALUES LESS THAN(121, 'D'),
 SUBPARTITION PART_14 VALUES LESS THAN(161, 'E'),
 SUBPARTITION PART_15 VALUES LESS THAN(201, 'F')
),
PARTITION PART_2 VALUES LESS THAN (401,'C','C','C')tablespace partrange_tablespace1
(
 SUBPARTITION PART_21 VALUES LESS THAN(241, 'B'),
 SUBPARTITION PART_22 VALUES LESS THAN(281, 'C'),
 SUBPARTITION PART_23 VALUES LESS THAN(321, 'D'),
 SUBPARTITION PART_24 VALUES LESS THAN(361, 'E'),
 SUBPARTITION PART_25 VALUES LESS THAN(401, 'F')
),
PARTITION PART_3 VALUES LESS THAN (601,'D','D','D')tablespace partrange_tablespace1
(
 SUBPARTITION PART_31 VALUES LESS THAN(441, 'B'),
 SUBPARTITION PART_32 VALUES LESS THAN(481, 'C'),
 SUBPARTITION PART_33 VALUES LESS THAN(521, 'D'),
 SUBPARTITION PART_34 VALUES LESS THAN(561, 'E'),
 SUBPARTITION PART_35 VALUES LESS THAN(601, 'F')
),
PARTITION PART_4 VALUES LESS THAN (801,'E','E','E')tablespace partrange_tablespace1
(
 SUBPARTITION PART_41 VALUES LESS THAN(641, 'B'),
 SUBPARTITION PART_42 VALUES LESS THAN(681, 'C'),
 SUBPARTITION PART_43 VALUES LESS THAN(721, 'D'),
 SUBPARTITION PART_44 VALUES LESS THAN(761, 'E'),
 SUBPARTITION PART_45 VALUES LESS THAN(801, 'F')
),
PARTITION PART_5 VALUES LESS THAN (1001,'F','F','F')tablespace partrange_tablespace1
(
 SUBPARTITION PART_51 VALUES LESS THAN(841, 'B'),
 SUBPARTITION PART_52 VALUES LESS THAN(881, 'C'),
 SUBPARTITION PART_53 VALUES LESS THAN(921, 'D'),
 SUBPARTITION PART_54 VALUES LESS THAN(961, 'E'),
 SUBPARTITION PART_55 VALUES LESS THAN(1001, 'F')
),
PARTITION PART_6 VALUES LESS THAN (1201,'G','G','G')tablespace partrange_tablespace1
(
 SUBPARTITION PART_61 VALUES LESS THAN(1041, 'B'),
 SUBPARTITION PART_62 VALUES LESS THAN(1081, 'C'),
 SUBPARTITION PART_63 VALUES LESS THAN(1121, 'D'),
 SUBPARTITION PART_64 VALUES LESS THAN(1161, 'E'),
 SUBPARTITION PART_65 VALUES LESS THAN(1201, 'F')
),
PARTITION PART_7 VALUES LESS THAN (1401,'H','H','H')tablespace partrange_tablespace1
(
 SUBPARTITION PART_71 VALUES LESS THAN(1241, 'B'),
 SUBPARTITION PART_72 VALUES LESS THAN(1281, 'C'),
 SUBPARTITION PART_73 VALUES LESS THAN(1321, 'D'),
 SUBPARTITION PART_74 VALUES LESS THAN(1361, 'E'),
 SUBPARTITION PART_75 VALUES LESS THAN(1401, 'F')
),
PARTITION PART_8 VALUES LESS THAN (1601,'I','I','I')tablespace partrange_tablespace1
(
 SUBPARTITION PART_81 VALUES LESS THAN(1441, 'B'),
 SUBPARTITION PART_82 VALUES LESS THAN(1481, 'C'),
 SUBPARTITION PART_83 VALUES LESS THAN(1521, 'D'),
 SUBPARTITION PART_84 VALUES LESS THAN(1561, 'E'),
 SUBPARTITION PART_85 VALUES LESS THAN(1601, 'F')
),
PARTITION PART_9 VALUES LESS THAN (1801,'J','J','J')tablespace partrange_tablespace1
(
 SUBPARTITION PART_91 VALUES LESS THAN(1641, 'B'),
 SUBPARTITION PART_92 VALUES LESS THAN(1681, 'C'),
 SUBPARTITION PART_93 VALUES LESS THAN(1721, 'D'),
 SUBPARTITION PART_94 VALUES LESS THAN(1761, 'E'),
 SUBPARTITION PART_95 VALUES LESS THAN(1801, 'F')
),
PARTITION PART_10 VALUES LESS THAN (MAXVALUE,MAXVALUE,MAXVALUE,MAXVALUE) tablespace partrange_tablespace1);
CREATE  UNIQUE INDEX  NEBULA.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_ID,C_CITY,C_FIRST,C_LAST) parallel 2  tablespace partrange_tablespace2;
CREATE UNIQUE INDEX NEBULA.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_CITY,C_LAST,C_STREET_2) parallel 5 tablespace partrange_tablespace2;
CREATE UNIQUE INDEX NEBULA.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_STREET_2,C_D_ID) parallel 6 tablespace partrange_tablespace2;
CREATE INDEX NEBULA.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_CITY,C_FIRST) parallel 1 LOCAL tablespace partrange_tablespace2;
CREATE INDEX NEBULA.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_STREET_1,C_W_ID) parallel 3 LOCAL tablespace partrange_tablespace2;
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
update NEBULA.STRG_RANGE_DDL_MUL_TBL_001 set c_id = c_id - 200, c_d_id = c_d_id - 300 where c_id >= 201 and c_id < 241;
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_11);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_21);
rollback to savepoint aa;
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_11);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_12);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_21);

ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop subpartition part_91;
flashback table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition part_91 to before drop;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop PARTITION PART_10;
insert into NEBULA.STRG_RANGE_DDL_MUL_TBL_001 values(2000, 2000, 2000, 'J' || 2000 ||'Cabdg', 'EOE', 'J' || 2000 ||'Bdbed','bki'|| 2000 ||'fdger','pwo'|| 2000 ||'vedef', 'J' || 2000 ||'Yed3f','uq',4801|| 2000 ,940|| 2000 ,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANdfdffdfRB'|| 2000 ,'QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF'|| 2000 ,'1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323');

--测试两种添加分区的方案，一种指定子分区定义;一种不指定，按照默认子分区
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 ADD PARTITION P11 VALUES LESS THAN (2001,'K','K','K') tablespace partrange_tablespace1;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
insert into NEBULA.STRG_RANGE_DDL_MUL_TBL_001 values(2000, 2000, 2000, 'J' || 2000 ||'Cabdg', 'EOE', 'J' || 2000 ||'Bdbed','bki'|| 2000 ||'fdger','pwo'|| 2000 ||'vedef', 'J' || 2000 ||'Yed3f','uq',4801|| 2000 ,940|| 2000 ,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANdfdffdfRB'|| 2000 ,'QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF'|| 2000 ,'1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323');
SELECT count(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 PARTITION(P11);
COMMIT;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 DROP PARTITION P11;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 ADD PARTITION P11 VALUES LESS THAN (2001,'K','K','K') tablespace partrange_tablespace1
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
insert into NEBULA.STRG_RANGE_DDL_MUL_TBL_001 values(2000, 2000, 2000, 'J' || 2000 ||'Cabdg', 'EOE', 'J' || 2000 ||'Bdbed','bki'|| 2000 ||'fdger','pwo'|| 2000 ||'vedef', 'J' || 2000 ||'Yed3f','uq',4801|| 2000 ,940|| 2000 ,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANdfdffdfRB'|| 2000 ,'QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF'|| 2000 ,'1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323');
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

alter table nebula.strg_range_ddl_mul_tbl_001 split partition part_8 at(1500, 'J', 'J', 'J') into (partition part_10 tablespace partrange_tablespace1 storage(initial 2m maxsize 8m),partition part_12 tablespace partrange_tablespace2 storage(initial 2m maxsize 8m));
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_10);
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_12);
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
delete from nebula.strg_range_ddl_mul_tbl_001 where c_id >= 1401 and c_id < 1601;
insert into nebula.strg_range_ddl_mul_tbl_001 SELECT * FROM NEBULA.STRG_RANGE_DML_MUL_TBL_000 where c_id >= 1401 and c_id < 1601;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_10);
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_12);
commit;

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

--range-list
drop table if exists NEBULA.STRG_RANGE_DDL_MUL_TBL_001;
CREATE TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_ID INT,C_D_ID INT NOT NULL,C_W_ID INT NOT NULL,C_FIRST VARCHAR(64) NOT NULL,C_MIDDLE CHAR(3),C_LAST VARCHAR(64) NOT NULL,C_STREET_1 VARCHAR(20) NOT NULL,C_STREET_2 VARCHAR(20),C_CITY VARCHAR(64) NOT NULL,C_STATE CHAR(2) NOT NULL,C_ZIP CHAR(9) NOT NULL,C_PHONE CHAR(16) NOT NULL,C_SINCE TIMESTAMP,C_CREDIT CHAR(2) NOT NULL,C_CREDIT_LIM NUMERIC(12,2),C_DISCOUNT NUMERIC(4,4),C_BALANCE NUMERIC(12,2),C_YTD_PAYMENT REAL NOT NULL,C_PAYMENT_CNT NUMBER NOT NULL,C_DELIVERY_CNT BOOLEAN NOT NULL,C_END DATE NOT NULL,C_VCHAR VARCHAR(1000),C_DATA CLOB,C_TEXT BLOB ) PARTITION BY RANGE(C_ID,C_CITY,C_FIRST,C_LAST) SUBPARTITION BY LIST(C_STREET_1) (
PARTITION PART_1 VALUES LESS THAN (201,'B','B','B')tablespace partrange_tablespace1
(
 SUBPARTITION PART_11 VALUES('bki00fdger'),
 SUBPARTITION PART_12 VALUES('bki01fdger'),
 SUBPARTITION PART_13 VALUES('bki02fdger'),
 SUBPARTITION PART_14 VALUES('bki03fdger'),
 SUBPARTITION PART_15 VALUES('bki04fdger')
),
PARTITION PART_2 VALUES LESS THAN (401,'C','C','C')tablespace partrange_tablespace1
(
 SUBPARTITION PART_21 VALUES('bki10fdger'),
 SUBPARTITION PART_22 VALUES('bki11fdger'),
 SUBPARTITION PART_23 VALUES('bki12fdger'),
 SUBPARTITION PART_24 VALUES('bki13fdger'),
 SUBPARTITION PART_25 VALUES('bki14fdger')
),
PARTITION PART_3 VALUES LESS THAN (601,'D','D','D')tablespace partrange_tablespace1
(
 SUBPARTITION PART_31 VALUES('bki20fdger'),
 SUBPARTITION PART_32 VALUES('bki21fdger'),
 SUBPARTITION PART_33 VALUES('bki22fdger'),
 SUBPARTITION PART_34 VALUES('bki23fdger'),
 SUBPARTITION PART_35 VALUES('bki24fdger')
),
PARTITION PART_4 VALUES LESS THAN (801,'E','E','E')tablespace partrange_tablespace1
(
 SUBPARTITION PART_41 VALUES('bki30fdger'),
 SUBPARTITION PART_42 VALUES('bki31fdger'),
 SUBPARTITION PART_43 VALUES('bki32fdger'),
 SUBPARTITION PART_44 VALUES('bki33fdger'),
 SUBPARTITION PART_45 VALUES('bki34fdger')
),
PARTITION PART_5 VALUES LESS THAN (1001,'F','F','F')tablespace partrange_tablespace1
(
 SUBPARTITION PART_51 VALUES('bki40fdger'),
 SUBPARTITION PART_52 VALUES('bki41fdger'),
 SUBPARTITION PART_53 VALUES('bki42fdger'),
 SUBPARTITION PART_54 VALUES('bki43fdger'),
 SUBPARTITION PART_55 VALUES('bki44fdger')
),
PARTITION PART_6 VALUES LESS THAN (1201,'G','G','G')tablespace partrange_tablespace1
(
 SUBPARTITION PART_61 VALUES('bki50fdger'),
 SUBPARTITION PART_62 VALUES('bki51fdger'),
 SUBPARTITION PART_63 VALUES('bki52fdger'),
 SUBPARTITION PART_64 VALUES('bki53fdger'),
 SUBPARTITION PART_65 VALUES('bki54fdger')
),
PARTITION PART_7 VALUES LESS THAN (1401,'H','H','H')tablespace partrange_tablespace1
(
 SUBPARTITION PART_71 VALUES('bki60fdger'),
 SUBPARTITION PART_72 VALUES('bki61fdger'),
 SUBPARTITION PART_73 VALUES('bki62fdger'),
 SUBPARTITION PART_74 VALUES('bki63fdger'),
 SUBPARTITION PART_75 VALUES('bki64fdger')
),
PARTITION PART_8 VALUES LESS THAN (1601,'I','I','I')tablespace partrange_tablespace1
(
 SUBPARTITION PART_81 VALUES('bki70fdger'),
 SUBPARTITION PART_82 VALUES('bki71fdger'),
 SUBPARTITION PART_83 VALUES('bki72fdger'),
 SUBPARTITION PART_84 VALUES('bki73fdger'),
 SUBPARTITION PART_85 VALUES('bki74fdger')
),
PARTITION PART_9 VALUES LESS THAN (1801,'J','J','J')tablespace partrange_tablespace1
(
 SUBPARTITION PART_91 VALUES('bki80fdger'),
 SUBPARTITION PART_92 VALUES('bki81fdger'),
 SUBPARTITION PART_93 VALUES('bki82fdger'),
 SUBPARTITION PART_94 VALUES('bki83fdger'),
 SUBPARTITION PART_95 VALUES('bki84fdger')
),
PARTITION PART_10 VALUES LESS THAN (MAXVALUE,MAXVALUE,MAXVALUE,MAXVALUE) tablespace partrange_tablespace1);
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
update NEBULA.STRG_RANGE_DDL_MUL_TBL_001 set c_street_1 = 'bki00fdger' where c_street_1 = 'bki01fdger';
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_11);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_12);
update NEBULA.STRG_RANGE_DDL_MUL_TBL_001 set c_id = c_id - 240, c_street_1 = 'bki00fdger' where c_street_1 = 'bki10fdger';
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_11);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_21);
rollback to savepoint aa;
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_11);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_12);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_21);

ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop subpartition part_91;
flashback table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition part_91 to before drop;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop PARTITION PART_10;
insert into NEBULA.STRG_RANGE_DDL_MUL_TBL_001 values(2000, 2000, 2000, 'J' || 2000 ||'Cabdg', 'EOE', 'J' || 2000 ||'Bdbed','bki'|| 2000 ||'fdger','pwo'|| 2000 ||'vedef', 'J' || 2000 ||'Yed3f','uq',4801|| 2000 ,940|| 2000 ,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANdfdffdfRB'|| 2000 ,'QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF'|| 2000 ,'1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323');

--测试两种添加分区的方案，一种指定子分区定义;一种不指定，按照默认子分区
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 ADD PARTITION P11 VALUES LESS THAN (2001,'K','K','K') tablespace partrange_tablespace1;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
insert into NEBULA.STRG_RANGE_DDL_MUL_TBL_001 values(2000, 2000, 2000, 'J' || 2000 ||'Cabdg', 'EOE', 'J' || 2000 ||'Bdbed','bki'|| 92 ||'fdger','pwo'|| 2000 ||'vedef', 'J' || 2000 ||'Yed3f','uq',4801|| 2000 ,940|| 2000 ,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANdfdffdfRB'|| 2000 ,'QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF'|| 2000 ,'1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323');
SELECT count(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 PARTITION(P11);
COMMIT;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 DROP PARTITION P11;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 ADD PARTITION P11 VALUES LESS THAN (2001,'K','K','K') tablespace partrange_tablespace1
(
 SUBPARTITION P11_1 VALUES('bki90fdger') tablespace partrange_tablespace1,
 SUBPARTITION P11_2 VALUES('bki91fdger') tablespace partrange_tablespace2,
 SUBPARTITION P11_3 VALUES('bki92fdger') tablespace partrange_tablespace1,
 SUBPARTITION P11_4 VALUES('bki93fdger') tablespace partrange_tablespace2,
 SUBPARTITION P11_5 VALUES('bki94fdger') tablespace partrange_tablespace1
);
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
insert into NEBULA.STRG_RANGE_DDL_MUL_TBL_001 values(2000, 2000, 2000, 'J' || 2000 ||'Cabdg', 'EOE', 'J' || 2000 ||'Bdbed','bki'|| 92 ||'fdger','pwo'|| 2000 ||'vedef', 'J' || 2000 ||'Yed3f','uq',4801|| 2000 ,940|| 2000 ,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANdfdffdfRB'|| 2000 ,'QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF'|| 2000 ,'1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323');
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

alter table nebula.strg_range_ddl_mul_tbl_001 split partition part_8 at(1500, 'J', 'J', 'J') into (partition part_10 tablespace partrange_tablespace1 storage(initial 2m maxsize 8m),partition part_12 tablespace partrange_tablespace2 storage(initial 2m maxsize 8m));
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_10);
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_12);
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
delete from nebula.strg_range_ddl_mul_tbl_001 where c_id >= 1401 and c_id < 1601;
insert into nebula.strg_range_ddl_mul_tbl_001 SELECT * FROM NEBULA.STRG_RANGE_DML_MUL_TBL_000 where c_id >= 1401 and c_id < 1601;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_10);
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_12);
commit;

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

--range-hash
drop table if exists NEBULA.STRG_RANGE_DDL_MUL_TBL_001;
CREATE TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_ID INT,C_D_ID INT NOT NULL,C_W_ID INT NOT NULL,C_FIRST VARCHAR(64) NOT NULL,C_MIDDLE CHAR(3),C_LAST VARCHAR(64) NOT NULL,C_STREET_1 VARCHAR(20) NOT NULL,C_STREET_2 VARCHAR(20),C_CITY VARCHAR(64) NOT NULL,C_STATE CHAR(2) NOT NULL,C_ZIP CHAR(9) NOT NULL,C_PHONE CHAR(16) NOT NULL,C_SINCE TIMESTAMP,C_CREDIT CHAR(2) NOT NULL,C_CREDIT_LIM NUMERIC(12,2),C_DISCOUNT NUMERIC(4,4),C_BALANCE NUMERIC(12,2),C_YTD_PAYMENT REAL NOT NULL,C_PAYMENT_CNT NUMBER NOT NULL,C_DELIVERY_CNT BOOLEAN NOT NULL,C_END DATE NOT NULL,C_VCHAR VARCHAR(1000),C_DATA CLOB,C_TEXT BLOB ) PARTITION BY RANGE(C_ID,C_CITY,C_FIRST,C_LAST) SUBPARTITION BY HASH(C_STREET_1, C_STREET_2) (
PARTITION PART_1 VALUES LESS THAN (201,'B','B','B')tablespace partrange_tablespace1
(
 SUBPARTITION PART_11,
 SUBPARTITION PART_12,
 SUBPARTITION PART_13,
 SUBPARTITION PART_14
),
PARTITION PART_2 VALUES LESS THAN (401,'C','C','C')tablespace partrange_tablespace1
(
 SUBPARTITION PART_21,
 SUBPARTITION PART_22,
 SUBPARTITION PART_23,
 SUBPARTITION PART_24
),
PARTITION PART_3 VALUES LESS THAN (601,'D','D','D')tablespace partrange_tablespace1
(
 SUBPARTITION PART_31,
 SUBPARTITION PART_32,
 SUBPARTITION PART_33,
 SUBPARTITION PART_34
),
PARTITION PART_4 VALUES LESS THAN (801,'E','E','E')tablespace partrange_tablespace1
(
 SUBPARTITION PART_41,
 SUBPARTITION PART_42,
 SUBPARTITION PART_43,
 SUBPARTITION PART_44
),
PARTITION PART_5 VALUES LESS THAN (1001,'F','F','F')tablespace partrange_tablespace1
(
 SUBPARTITION PART_51,
 SUBPARTITION PART_52,
 SUBPARTITION PART_53,
 SUBPARTITION PART_54
),
PARTITION PART_6 VALUES LESS THAN (1201,'G','G','G')tablespace partrange_tablespace1
(
 SUBPARTITION PART_61,
 SUBPARTITION PART_62,
 SUBPARTITION PART_63,
 SUBPARTITION PART_64
),
PARTITION PART_7 VALUES LESS THAN (1401,'H','H','H')tablespace partrange_tablespace1
(
 SUBPARTITION PART_71,
 SUBPARTITION PART_72,
 SUBPARTITION PART_73,
 SUBPARTITION PART_74
),
PARTITION PART_8 VALUES LESS THAN (1601,'I','I','I')tablespace partrange_tablespace1
(
 SUBPARTITION PART_81,
 SUBPARTITION PART_82,
 SUBPARTITION PART_83,
 SUBPARTITION PART_84
),
PARTITION PART_9 VALUES LESS THAN (1801,'J','J','J')tablespace partrange_tablespace1
(
 SUBPARTITION PART_91,
 SUBPARTITION PART_92,
 SUBPARTITION PART_93,
 SUBPARTITION PART_94
),
PARTITION PART_10 VALUES LESS THAN (MAXVALUE,MAXVALUE,MAXVALUE,MAXVALUE) tablespace partrange_tablespace1);
CREATE  UNIQUE INDEX  NEBULA.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_ID,C_CITY,C_FIRST,C_LAST)   tablespace partrange_tablespace2;
CREATE UNIQUE INDEX NEBULA.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_CITY,C_LAST,C_STREET_2) parallel 4 tablespace partrange_tablespace2;
CREATE UNIQUE INDEX NEBULA.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_STREET_2,C_D_ID)  tablespace partrange_tablespace2;
CREATE INDEX NEBULA.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_CITY,C_FIRST) parallel 4 LOCAL tablespace partrange_tablespace2;
CREATE INDEX NEBULA.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001(C_STREET_1,C_W_ID)  LOCAL tablespace partrange_tablespace2;
INSERT INTO NEBULA.STRG_RANGE_DDL_MUL_TBL_001 SELECT * FROM NEBULA.STRG_RANGE_DML_MUL_TBL_000;
COMMIT;

--测试基础DML操作
savepoint aa;
delete from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 where mod(c_id, 2) = 1;
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_11);
update NEBULA.STRG_RANGE_DDL_MUL_TBL_001 set c_w_id = c_w_id + 100 where c_id < 41;
select c_w_id from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 where c_id < 41;
update NEBULA.STRG_RANGE_DDL_MUL_TBL_001 set c_street_1 = 'bki00fdger' where c_street_1 = 'bki01fdger';
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_11);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_12);
update NEBULA.STRG_RANGE_DDL_MUL_TBL_001 set c_id = c_id - 240, c_street_1 = 'bki00fdger' where c_street_1 = 'bki10fdger';
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_11);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_21);
rollback to savepoint aa;
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_11);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_12);
select count(*) from NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition(part_21);

ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop subpartition part_91;
flashback table NEBULA.STRG_RANGE_DDL_MUL_TBL_001 subpartition part_91 to before drop;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 drop PARTITION PART_10;
insert into NEBULA.STRG_RANGE_DDL_MUL_TBL_001 values(2000, 2000, 2000, 'J' || 2000 ||'Cabdg', 'EOE', 'J' || 2000 ||'Bdbed','bki'|| 2000 ||'fdger','pwo'|| 2000 ||'vedef', 'J' || 2000 ||'Yed3f','uq',4801|| 2000 ,940|| 2000 ,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANdfdffdfRB'|| 2000 ,'QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF'|| 2000 ,'1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323');

--测试两种添加分区的方案，一种指定子分区定义;一种不指定，按照默认子分区
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 ADD PARTITION P11 VALUES LESS THAN (2001,'K','K','K') tablespace partrange_tablespace1;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
insert into NEBULA.STRG_RANGE_DDL_MUL_TBL_001 values(2000, 2000, 2000, 'J' || 2000 ||'Cabdg', 'EOE', 'J' || 2000 ||'Bdbed','bki'|| 92 ||'fdger','pwo'|| 2000 ||'vedef', 'J' || 2000 ||'Yed3f','uq',4801|| 2000 ,940|| 2000 ,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANdfdffdfRB'|| 2000 ,'QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF'|| 2000 ,'1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323');
SELECT count(*) FROM NEBULA.STRG_RANGE_DDL_MUL_TBL_001 PARTITION(P11);
COMMIT;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 DROP PARTITION P11;
ALTER TABLE NEBULA.STRG_RANGE_DDL_MUL_TBL_001 ADD PARTITION P11 VALUES LESS THAN (2001,'K','K','K') tablespace partrange_tablespace1
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
insert into NEBULA.STRG_RANGE_DDL_MUL_TBL_001 values(2000, 2000, 2000, 'J' || 2000 ||'Cabdg', 'EOE', 'J' || 2000 ||'Bdbed','bki'|| 92 ||'fdger','pwo'|| 2000 ||'vedef', 'J' || 2000 ||'Yed3f','uq',4801|| 2000 ,940|| 2000 ,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'GC',50000.0,0.4361328,-10.0,10.0,1,true,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),'QVLDETANdfdffdfRB'|| 2000 ,'QVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSFQVLDETANRBRBUflnfufscHOQNGGSMjjjjgfvmgfvdfcmkgvNPFZCSYKXXYSCDSF'|| 2000 ,'1234354587643123455213445656723123424554566776763221132454566768767433242323445453565654542323');
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

alter table nebula.strg_range_ddl_mul_tbl_001 split partition part_8 at(1500, 'J', 'J', 'J') into (partition part_10 tablespace partrange_tablespace1 storage(initial 2m maxsize 8m),partition part_12 tablespace partrange_tablespace2 storage(initial 2m maxsize 8m));
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_10);
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_12);
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_1 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_2 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_3 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_4 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
alter index nebula.STRG_RANGE_DDL_MUL_IDX_001_5 ON NEBULA.STRG_RANGE_DDL_MUL_TBL_001 rebuild;
delete from nebula.strg_range_ddl_mul_tbl_001 where c_id >= 1401 and c_id < 1601;
insert into nebula.strg_range_ddl_mul_tbl_001 SELECT * FROM NEBULA.STRG_RANGE_DML_MUL_TBL_000 where c_id >= 1401 and c_id < 1601;
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_10);
select count(*) from nebula.strg_range_ddl_mul_tbl_001 partition(part_12);
commit;

--hash子分区的收缩添加
select count(*) from nebula.strg_range_ddl_mul_tbl_001 subpartition(part_72);
select count(*) from nebula.strg_range_ddl_mul_tbl_001 subpartition(part_74);
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

drop table if exists test_foreign_key;
create table test_foreign_key(id int, c_id int) partition by range(id) subpartition by range(c_id)
(
partition p1 values less than(50)
(
subpartition p11 values less than(50),
subpartition p12 values less than(100)
),
partition p2 values less than(100)
(
subpartition p21 values less than(50),
subpartition p22 values less than(100)
)
);

create index test_index on test_foreign_key(id) parallel 4;
insert into test_foreign_key values(10, 10);
insert into test_foreign_key values(20, 60);
insert into test_foreign_key values(60, 30);
insert into test_foreign_key values(70, 80);
commit;

drop table if exists test_foreign_key_1;
create table test_foreign_key_1(id int primary key, c_id int);
insert into test_foreign_key_1 values(10, 10);
insert into test_foreign_key_1 values(20, 60);
insert into test_foreign_key_1 values(60, 30);
insert into test_foreign_key_1 values(70, 80);
commit;

alter table test_foreign_key add constraint test_foreign_key_constraint foreign key(id) references test_foreign_key_1(id);
delete from test_foreign_key_1 where id > 60;
drop table test_foreign_key;
drop table test_foreign_key_1;

drop table if exists test_subpart_index;
create table test_subpart_index(id int, c_id int) partition by range(id) subpartition by range(c_id)
(
partition p1 values less than(50)
(
subpartition p11 values less than(50),
subpartition p12 values less than(100)
),
partition p2 values less than(100)
(
subpartition p21 values less than(50),
subpartition p22 values less than(100)
)
);

create index index_test_subpart_1 on test_subpart_index(id) local;
drop table test_subpart_index;