DROP TABLE IF EXISTS T_DISTINCT_1;
CREATE TABLE T_DISTINCT_1 (F_INT1 INT, F_INT2 INT, F_CHAR VARCHAR(16), F_DATE DATE);

--test empty record
select distinct a.f_int1,count(b.f_int2) from T_DISTINCT_1 a, T_DISTINCT_1 b group by a.f_int1;

INSERT INTO T_DISTINCT_1 VALUES(1,2,'A','2017-12-11 14:08:00');
INSERT INTO T_DISTINCT_1 VALUES(1,3,'b','2017-12-11 14:18:00');
INSERT INTO T_DISTINCT_1 VALUES(3,4,'C','2017-12-12 16:08:00');
INSERT INTO T_DISTINCT_1 VALUES(2,3,'D','2017-12-11 16:08:00');
INSERT INTO T_DISTINCT_1 VALUES(2,3,'E','2017-12-11 16:08:00');
INSERT INTO T_DISTINCT_1 VALUES(1,3,'F','2017-12-11 14:18:00');
INSERT INTO T_DISTINCT_1 VALUES(3,4,'G','2017-12-12 16:08:00');

DROP TABLE IF EXISTS T_DISTINCT_2;
CREATE TABLE T_DISTINCT_2 (F_INT1 INT, F_INT2 INT, F_CHAR VARCHAR(16), F_DATE DATE);
INSERT INTO T_DISTINCT_2 VALUES(1,2,'A','2017-12-11 14:08:00');
INSERT INTO T_DISTINCT_2 VALUES(1,3,'b','2017-12-11 14:18:00');
INSERT INTO T_DISTINCT_2 VALUES(3,4,'C','2017-12-12 16:08:00');
INSERT INTO T_DISTINCT_2 VALUES(2,3,'D','2017-12-11 16:08:00');
INSERT INTO T_DISTINCT_2 VALUES(2,3,'E','2017-12-11 16:08:00');
INSERT INTO T_DISTINCT_2 VALUES(1,3,'F','2017-12-11 14:18:00');
INSERT INTO T_DISTINCT_2 VALUES(3,4,'G1','2017-12-12 16:08:00');
INSERT INTO T_DISTINCT_2 VALUES(NULL,4,'G2','2017-12-12 16:08:00');
INSERT INTO T_DISTINCT_2 VALUES(NULL,4,'G1','2017-12-12 16:08:00');

COMMIT;

--ERROR
SELECT DISTINCT();
SELECT DISTINCT F_INT2,MAX(F_INT1) FROM T_DISTINCT_1;
SELECT DISTINCT F_INT2,COUNT(1) FROM T_DISTINCT_1;

SELECT DISTINCT * FROM T_DISTINCT_1 ORDER BY 1,2,3,4;
SELECT DISTINCT F_INT2,F_INT1 FROM T_DISTINCT_1 ORDER BY 1,2;
SELECT DISTINCT F_INT2,F_INT1 FROM T_DISTINCT_1 ORDER BY 1 DESC,2 DESC;
SELECT DISTINCT F_INT2,F_INT1 FROM T_DISTINCT_1 GROUP BY F_INT1,F_INT2 ORDER BY 1,2;
SELECT DISTINCT F_INT2,F_INT1 FROM T_DISTINCT_1 GROUP BY F_INT1,F_INT2 ORDER BY F_INT2 DESC,F_INT1;
SELECT DISTINCT F_INT2,F_INT1 FROM T_DISTINCT_1 GROUP BY F_INT1,F_INT2 ORDER BY 1 DESC,2;
SELECT DISTINCT F_INT2,MAX(F_INT1) FROM T_DISTINCT_1 GROUP BY F_INT2 ORDER BY F_INT2 DESC;
SELECT COUNT(*) FROM (SELECT DISTINCT F_INT2,MAX(F_INT1) FROM T_DISTINCT_1 GROUP BY F_INT2);
SELECT COUNT(*) FROM (SELECT DISTINCT F_INT2,MAX(F_INT1) FROM T_DISTINCT_1 GROUP BY F_INT2),T_DISTINCT_2 WHERE T_DISTINCT_2.F_INT2=3;
SELECT DISTINCT F_INT1 FROM T_DISTINCT_2 ORDER BY 1;
SELECT DISTINCT F_CHAR,COUNT(*) FROM T_DISTINCT_2 GROUP BY F_CHAR HAVING F_CHAR LIKE '%' ORDER BY 1,2;
SELECT DISTINCT LENGTH(F_CHAR) F1,COUNT(*) FROM T_DISTINCT_2 GROUP BY F_CHAR HAVING F_CHAR LIKE '%' ORDER BY 1,2;

select distinct lnnvl(F_INT1)  from T_DISTINCT_1 order by lnnvl(F_INT2);
select distinct F_INT1 ,F_CHAR from T_DISTINCT_1 order by if(F_INT1 > F_INT2, F_INT1, F_CHAR);
select distinct lnnvl(F_INT1)  from T_DISTINCT_1 group by lnnvl(F_INT2);
--TEST INDEX DISTINCT
DROP TABLE IF EXISTS T_DISTINCT_3;
CREATE TABLE T_DISTINCT_3 (F_INT1 INT, F_INT2 INT, F_CHAR VARCHAR(16), F_DATE DATE);
CREATE INDEX IDX_T_DISTINCT_3_1 ON T_DISTINCT_3(F_INT1, F_CHAR, F_DATE);
CREATE INDEX IDX_T_DISTINCT_3_2 ON T_DISTINCT_3(F_INT1, F_INT2);
INSERT INTO T_DISTINCT_3 VALUES(1,2,'A','2017-12-11 14:08:00');
INSERT INTO T_DISTINCT_3 VALUES(1,3,'b','2017-12-11 14:18:00');
INSERT INTO T_DISTINCT_3 VALUES(3,4,'C','2017-12-12 16:08:00');
INSERT INTO T_DISTINCT_3 VALUES(2,3,'D','2017-12-11 16:08:00');
INSERT INTO T_DISTINCT_3 VALUES(2,3,'E','2017-12-11 16:08:00');
INSERT INTO T_DISTINCT_3 VALUES(1,3,'F','2017-12-11 14:18:00');
INSERT INTO T_DISTINCT_3 VALUES(3,4,'G1','2017-12-12 16:08:00');
INSERT INTO T_DISTINCT_3 VALUES(NULL,4,'G2','2017-12-12 16:08:00');
INSERT INTO T_DISTINCT_3 VALUES(NULL,4,'G1','2017-12-12 16:08:00');
COMMIT;
SELECT DISTINCT * FROM T_DISTINCT_3 ORDER BY 1,2,3,4;
SELECT DISTINCT F_INT1,F_CHAR,F_DATE FROM T_DISTINCT_3;
SELECT DISTINCT F_INT1,F_CHAR FROM T_DISTINCT_3;
SELECT DISTINCT F_CHAR,F_DATE FROM T_DISTINCT_3 ORDER BY 1,2;
SELECT DISTINCT F_INT1,F_INT2 FROM T_DISTINCT_3;
SELECT DISTINCT 10,F_INT1,F_INT2,18 FROM T_DISTINCT_3;
DROP TABLE IF EXISTS STORAGE_ACID_ATOM_TABLE_000_1;
CREATE TABLE STORAGE_ACID_ATOM_TABLE_000_1 (c_id int,
                        c_d_id int NOT NULL,
                        c_w_id int NOT NULL,
                        c_first varchar(16) NOT NULL,
                        c_middle char(2),
                        c_last varchar(16) NOT NULL,
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
                        c_ytd_payment numeric(12,2) NOT NULL,
                        c_payment_cnt int NOT NULL,
                        c_delivery_cnt int NOT NULL,
                        c_data varchar(500) NOT NULL);

CREATE INDEX STORAGE_ACID_ATOM_INDEX_000_4 ON STORAGE_ACID_ATOM_TABLE_000_1(c_first,c_state,c_w_id);
insert into STORAGE_ACID_ATOM_TABLE_000_1 values (1,1,1,'iscmvlstpn','OE','BARBARBAR','bkilipzfcxcle','pmbwodmpvhvpafbj','dyfaoptppzjcgjrvyqa','uq','480211111','9400872216162535','2013-01-04 11:26:41','GC',50000.0,0.4361328,-10.0,10.0,1,0,'qvldetanrbrburbmzqujshoqnggsmnteccipriirdhirwiynpfzcsykxxyscdsfqafhatdokmjogfgslucunvwbtbfsqzjeclbacpjqdhjchvgbnrkjrgjrycsgppsocnevautzfeosviaxbvobffnjuqhlvnwuqhtgjqsbfacwjpbvpgthpyxcpmnutcjxrbxxbmrmwwxcepwiixvvleyajautcesljhrsfsmsnmzjcxvcuxdwmyijbwywiirsgocwktedbbokhynznceaesuifkgoaafagugetfhbcylksrjukvbufqcvbffaxnzssyquidvwefktknrchyxfphunqktwnipnsrvqswsymocnoexbabwnpmnxsvshdsjhazcauvqjgvqjfkjjgqrceyjmbumkapmcbxeashybpgekjkfezthnjbhfqiwbutbxtkjkndyylrvrhsazhijvmkmhdgvuyvyayiavdmypqomgobo');
UPDATE STORAGE_ACID_ATOM_TABLE_000_1 SET c_first='aaaaaaaaaaaaaaa';
SELECT distinct c_first FROM STORAGE_ACID_ATOM_TABLE_000_1 where c_d_id=1;

drop table if exists eliminate_distinct_lnnvl;
create table eliminate_distinct_lnnvl(
    c1 INT,
    c2 INT
);
insert into eliminate_distinct_lnnvl values(1,0);
insert into eliminate_distinct_lnnvl values(2,1);
commit;
select distinct lnnvl(c1), lnnvl(c2) from eliminate_distinct_lnnvl;
drop table eliminate_distinct_lnnvl;