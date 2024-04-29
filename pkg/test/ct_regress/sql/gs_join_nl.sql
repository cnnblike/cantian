DROP TABLE IF EXISTS T_NL_1;
DROP TABLE IF EXISTS T_NL_2;
CREATE TABLE T_NL_1 (F_INT1 INT, F_INT2 INT);
CREATE TABLE T_NL_2 (F_INT1 INT, F_INT2 INT);

--ERROR
SELECT A.F_INT1 FROM T_NL_1 A, T_NL_2 B ON A.F_INT1=B.F_INT1;
SELECT A.F_INT1 FROM T_NL_1 A JOIN T_NL_2 B;
SELECT A.F_INT1 FROM T_NL_1 A LEFT JOIN T_NL_2 B ON A.F_INT1 = B.F_INT1;
SELECT A.F_INT1 FROM T_NL_1 A LEFT OUTER JOIN T_NL_2 B ON A.F_INT1 = B.F_INT1;
SELECT T_NL_1.F_INT1 FROM T_NL_1 LEFT JOIN T_NL_2 B ON T_NL_1.F_INT1 = B.F_INT1;
SELECT T_NL_1.F_INT1 FROM T_NL_1 LEFT OUTER JOIN T_NL_2 B ON T_NL_1.F_INT1 = B.F_INT1;
SELECT A.F_INT1 FROM T_NL_1 A RIGHT JOIN T_NL_2 B ON A.F_INT1 = B.F_INT1;
SELECT A.F_INT1 FROM T_NL_1 A RIGHT OUTER JOIN T_NL_2 B ON A.F_INT1 = B.F_INT1;
SELECT T_NL_1.F_INT1 FROM T_NL_1 RIGHT JOIN T_NL_2 B ON T_NL_1.F_INT1 = B.F_INT1;
SELECT T_NL_1.F_INT1 FROM T_NL_1 RIGHT OUTER JOIN T_NL_2 B ON T_NL_1.F_INT1 = B.F_INT1;
SELECT A.F_INT1 FROM T_NL_1 A FULL JOIN T_NL_2 B ON A.F_INT1 = B.F_INT1;
SELECT A.F_INT1 FROM T_NL_1 A FULL OUTER JOIN T_NL_2 B ON A.F_INT1 = B.F_INT1;
SELECT T_NL_1.F_INT1 FROM T_NL_1 FULL JOIN T_NL_2 B ON T_NL_1.F_INT1 = B.F_INT1;
SELECT T_NL_1.F_INT1 FROM T_NL_1 FULL OUTER JOIN T_NL_2 B ON T_NL_1.F_INT1 = B.F_INT1;
SELECT A.F_INT1 FROM T_NL_1 A ,T_NL_2 B WHERE A.F_INT1(+) = B.F_INT1;
SELECT A.F_INT1 FROM T_NL_1 A ,T_NL_2 B WHERE A.F_INT1 = B.F_INT1(+);
--NOT SUPPORT :appear column of select in subselect
SELECT F_INT1 FROM T_NL_1 WHERE F_INT1 IN (SELECT F_INT2 FROM T_NL_1 TT WHERE TT.F_INT2 = T_NL_1.F_INT1);

--EMPTY RECORD
SELECT * FROM T_NL_1 JOIN T_NL_2 ON T_NL_1.F_INT1 = T_NL_2.F_INT1;
SELECT * FROM T_NL_1 T1,T_NL_2 T2 WHERE T1.F_INT1 = T2.F_INT1 ORDER BY T1.F_INT1;
SELECT * FROM T_NL_1 T1,T_NL_2 T2 WHERE T1.F_INT1 = T2.F_INT1 ORDER BY T1.F_INT1 DESC;
SELECT * FROM T_NL_1 JOIN (SELECT * FROM T_NL_2) T2 ON T_NL_1.F_INT1 = T2.F_INT1 INNER JOIN (SELECT * FROM T_NL_2) T3 ON T_NL_1.F_INT1 = T3.F_INT1;
SELECT * FROM T_NL_1 WHERE F_INT1 IN (SELECT F_INT2 FROM T_NL_2) AND F_INT2 IN  (SELECT F_INT2 FROM T_NL_2);

INSERT INTO T_NL_1 VALUES(1,2);
INSERT INTO T_NL_1 VALUES(2,3);
INSERT INTO T_NL_2 VALUES(2,1);
INSERT INTO T_NL_2 VALUES(3,2);

SELECT * FROM T_NL_1 JOIN T_NL_2 ON T_NL_1.F_INT1 = T_NL_2.F_INT1;
--test continuous join,first join is alias
SELECT * FROM T_NL_1 JOIN JOIN T_NL_2 ON JOIN.F_INT1 = T_NL_2.F_INT1;
SELECT * FROM T_NL_1 INNER JOIN T_NL_2 ON T_NL_1.F_INT1 = T_NL_2.F_INT1;

INSERT INTO T_NL_1 VALUES(3,4);

SELECT * FROM T_NL_1 T1,T_NL_2 T2 WHERE T1.F_INT1 = T2.F_INT1 ORDER BY T1.F_INT1;
SELECT * FROM T_NL_1 T1,T_NL_2 T2 WHERE T1.F_INT1 = T2.F_INT1 ORDER BY T1.F_INT1 DESC;

SELECT t1.F_INT1 AS F1, T2.F_INT2 AS F2 FROM T_NL_1 T1,T_NL_2 T2 WHERE T1.F_INT1 = T2.F_INT1 ORDER BY F1 DESC;


--TEST ALIAS
SELECT T.F_INT1 COL1 FROM T_NL_1, T_NL_1 T GROUP BY T.F_INT1 ORDER BY COL1;

--TEST MULTI TABLE JOIN
ROLLBACK;
INSERT INTO T_NL_1 VALUES(1,2);
INSERT INTO T_NL_1 VALUES(1,3);
INSERT INTO T_NL_1 VALUES(2,4);
INSERT INTO T_NL_1 VALUES(2,5);
INSERT INTO T_NL_1 VALUES(3,6);
INSERT INTO T_NL_1 VALUES(3,7);
INSERT INTO T_NL_1 VALUES(4,8);
INSERT INTO T_NL_1 VALUES(4,9);
INSERT INTO T_NL_2 VALUES(1,2);
INSERT INTO T_NL_2 VALUES(2,3);
INSERT INTO T_NL_2 VALUES(3,4);
INSERT INTO T_NL_2 VALUES(4,5);
INSERT INTO T_NL_2 VALUES(5,6);
INSERT INTO T_NL_2 VALUES(6,7);
INSERT INTO T_NL_2 VALUES(7,8);
INSERT INTO T_NL_2 VALUES(8,9);

--ERROR
SELECT A.F_INT1,B.F_INT1,C.F_INT1,C.F_INT2 FROM T_NL_1 A JOIN T_NL_1 B ON A.F_INT1 = C.F_INT1 JOIN T_NL_2 C ON B.F_INT1 = C.F_INT1 JOIN T_NL_2 D ON D.F_INT1 = C.F_INT1 WHERE C.F_INT2 = 5;

SELECT A.F_INT1,B.F_INT1,C.F_INT1,C.F_INT2 FROM T_NL_1 A JOIN T_NL_1 B ON A.F_INT1 = B.F_INT1 JOIN T_NL_2 C ON B.F_INT1 = C.F_INT1 JOIN T_NL_2 D ON D.F_INT1 = C.F_INT1 WHERE C.F_INT2 = 5;
SELECT A.F_INT1,B.F_INT1,C.F_INT1,C.F_INT2 FROM T_NL_1 A JOIN T_NL_1 B ON A.F_INT1 = B.F_INT1 JOIN T_NL_2 C ON B.F_INT2 = C.F_INT2 JOIN T_NL_2 D ON D.F_INT2 = C.F_INT1 WHERE C.F_INT2 = 6;
SELECT A.F_INT1,B.F_INT1,C.F_INT1,C.F_INT2 FROM T_NL_1 A JOIN T_NL_1 B ON A.F_INT1 = B.F_INT1 JOIN T_NL_2 C ON B.F_INT2 = C.F_INT2 JOIN T_NL_2 D ON D.F_INT2 = C.F_INT1 ORDER BY A.F_INT1,B.F_INT1,C.F_INT1,C.F_INT2;
SELECT * FROM T_NL_1 T1,T_NL_2 T2,T_NL_2 T3 WHERE T1.F_INT1 = T2.F_INT1 AND T3.F_INT2 = T2.F_INT1 ORDER BY T1.F_INT1,T1.F_INT2;

SELECT l.a_1, l.a_2, r.a_1, r.a_2 
FROM 
(SELECT t1.f_int1, t1.f_int2 FROM T_NL_1 t1 WHERE true) l(a_1, a_2) 
JOIN 
(SELECT t2.f_int1, t2.f_int2 FROM T_NL_1 t2 WHERE true) r(a_1, a_2) 
ON true WHERE l.a_1 = r.a_1 order by l.a_1, l.a_2, r.a_1, r.a_2;

SELECT l.a_1, r.a_1 
FROM 
(SELECT t1.f_int1 FROM T_NL_1 t1 WHERE true) l(a_1) 
JOIN 
(SELECT t2.f_int1 FROM T_NL_1 t2 WHERE true) r(a_1) 
ON true WHERE l.a_1 = r.a_1 order by l.a_1,  r.a_1;

--EXPECT EEROR
SELECT l.a_1, l.a_2, r.a_1, r.a_2 
FROM 
(SELECT t1.f_int1 a_1, t1.f_int2 FROM T_NL_1 t1 WHERE true) l(a_1, a_2) 
JOIN 
(SELECT t2.f_int1, t2.f_int2 FROM T_NL_1 t2 WHERE true) r(a_1, a_2) 
ON true WHERE l.a_1 = r.a_1 order by l.a_1, l.a_2, r.a_1, r.a_2;

SELECT l.a_1, l.a_2, r.a_1, r.a_2 
FROM 
(SELECT t1.f_int1, t1.f_int2 a_2 FROM T_NL_1 t1 WHERE true) l(a_1, a_2) 
JOIN 
(SELECT t2.f_int1, t2.f_int2 FROM T_NL_1 t2 WHERE true) r(a_1, a_2) 
ON true WHERE l.a_1 = r.a_1 order by l.a_1, l.a_2, r.a_1, r.a_2;


COMMIT;
drop table if exists PFA_TBL_A;
create table PFA_TBL_A
( 
	A_NUM     number(10),
	A_NAME    varchar(100)     
);
drop table if exists PFA_TBL_B;
create table PFA_TBL_B
( 
	B_NUM        number(10),
	B_INT_CHAR   number(3),
	B_CHAR       char(1),
	B_NAME       varchar(100),
	B_TIMESTAMP  timestamp
);

insert into PFA_TBL_A values(1, 'ABCDEFG');
insert into PFA_TBL_A values(2, 'ABC');
insert into PFA_TBL_A values(3, 'PFA');
insert into PFA_TBL_A values(4, 'HELLO');
insert into PFA_TBL_A values(5, 'WORLD');
insert into PFA_TBL_A values(6, 'ZENITH');

insert into PFA_TBL_B values(1, 6 , 'M', 'UFO TIGER DHJ Script Shell', to_timestamp('2017-02-03 04:05:06.789123', 'YYYY-MM-DD HH24:MI:SS.FF'));
insert into PFA_TBL_B values(2, 7 , 'B', 'TIGER DHJ Script Shell', to_timestamp('2017-02-03 04:05:06.789123', 'YYYY-MM-DD HH24:MI:SS.FF'));
insert into PFA_TBL_B values(3, 70 , 'M', 'DHJ Script Shell', to_timestamp('2017-02-03 04:05:06.789123', 'YYYY-MM-DD HH24:MI:SS.FF'));
insert into PFA_TBL_B values(4, 79 , 'M', 'cript Shell', to_timestamp('2017-02-03 04:05:06.789123', 'YYYY-MM-DD HH24:MI:SS.FF'));
insert into PFA_TBL_B values(5, 85, 'F', 'Shell', to_timestamp('2017-02-03 04:05:06.789123', 'YYYY-MM-DD HH24:MI:SS.FF'));
insert into PFA_TBL_B values(6, 81, 'E', 'UFO, LeiJun: Are You OK?', to_timestamp('2017-02-03 04:05:06.789123', 'YYYY-MM-DD HH24:MI:SS.FF'));
insert into PFA_TBL_B values(1, 7, 'F', 'Fine! Thank you!', to_timestamp('2017-02-03 04:05:06.789123', 'YYYY-MM-DD HH24:MI:SS.FF'));
insert into PFA_TBL_B values(2, 93, null, 'Fine! Thank you!', to_timestamp('2017-02-03 04:05:06.789123', 'YYYY-MM-DD HH24:MI:SS.FF'));
insert into PFA_TBL_B values(3, null, 3, 'Fine! Thank you!', to_timestamp('2017-02-03 04:05:06.789123', 'YYYY-MM-DD HH24:MI:SS.FF'));

select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where PFA_TBL_B.B_NUM < 3 order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where PFA_TBL_B.B_NUM in (1,2,3,4,5,6) order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where PFA_TBL_B.B_NUM in (1,2,3,4,5,B_INT_CHAR) order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where PFA_TBL_B.B_NUM not in (1,2,3,4,5,B_INT_CHAR) order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where PFA_TBL_B.B_NUM + 1 < 4 order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where PFA_TBL_B.B_NUM + 3 < PFA_TBL_A.A_NUM * 2 order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where (PFA_TBL_B.B_NUM + 1) * 12 < 4 order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where PFA_TBL_B.B_NUM + PFA_TBL_A.A_NUM < 7 order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where PFA_TBL_A.A_NUM + PFA_TBL_B.B_NUM > 7 order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where cast(PFA_TBL_B.B_NUM as bigint) < 4 order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where to_char(PFA_TBL_B.B_TIMESTAMP + A_NUM, 'YYYY-MM-DD') > to_char(PFA_TBL_B.B_TIMESTAMP, 'YYYY-MM-DD') order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where to_char(PFA_TBL_B.B_TIMESTAMP + A_NUM, 'YYYY-MM-DD') < to_char(PFA_TBL_B.B_TIMESTAMP, 'YYYY-MM-DD') order by a_num, b_num, b_int_char;
select a_num, b_num, substr(B_NAME, 0, 3), chr(85)||chr(70)||chr(79) as "UFO" from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where substr(B_NAME, 0, 3) = chr(85)||chr(70)||chr(79) order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where chr(B_INT_CHAR) = 'U' order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where chr(B_INT_CHAR) like 'U' order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where chr(B_INT_CHAR) not like B_NAME order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where chr(B_INT_CHAR) not like B_CHAR order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where chr(B_INT_CHAR) >= B_CHAR order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where B_INT_CHAR between B_NUM and 30 order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where B_INT_CHAR not between B_NUM and 30 order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where B_INT_CHAR is null order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where B_INT_CHAR is not null order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where B_INT_CHAR + null is null order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where B_INT_CHAR + null is not null order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where B_INT_CHAR + null = null order by a_num, b_num, b_int_char;
select a_num, b_num, (B_INT_CHAR | A_NUM) as bit_or from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where B_INT_CHAR | A_NUM > 0 order by a_num, b_num, b_int_char;
select a_num, b_num, (B_INT_CHAR & A_NUM) as bit_or from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where B_INT_CHAR & A_NUM = 0 order by a_num, b_num, b_int_char;
select a_num, b_num, (B_INT_CHAR ^ A_NUM) as bit_or from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where B_INT_CHAR ^ A_NUM <> 0 order by a_num, b_num, b_int_char;
select a_num, b_num, floor(B_INT_CHAR) from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where floor(B_INT_CHAR) < 10 order by a_num, b_num, b_int_char;
select a_num, B_CHAR, decode(B_CHAR, 'M', B_INT_CHAR, 'F', 111) from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where decode(B_CHAR, 'M', B_INT_CHAR, 'F', 111) + 5 > 80 order by a_num, b_num, b_int_char;
select a_num, b_num, decode(B_CHAR, 'M', 3, 5) from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where PFA_TBL_B.B_NUM < any(5, decode(B_CHAR, 'M', 3, 5)) order by a_num, b_num, b_int_char;
select a_num, b_num, decode(B_CHAR, 'M', 3, 5) from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where PFA_TBL_B.B_NUM > any(5, decode(B_CHAR, 'M', 3, 5)) order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where PFA_TBL_B.B_NUM <> any(5,B_INT_CHAR) order by a_num, b_num, b_int_char;
select a_num, b_num, b_int_char from PFA_TBL_A inner join PFA_TBL_B on PFA_TBL_A.A_NUM = PFA_TBL_B.B_NUM where PFA_TBL_B.B_NUM <> any(5,B_INT_CHAR) order by a_num, b_num, b_int_char nulls first;
-- outer join
delete from T_NL_1;
delete from T_NL_2;
insert into T_NL_1 values(1, 11);
insert into T_NL_1 values(2, 22);
insert into T_NL_1 values(null, 22);
insert into T_NL_2 values(1, 11);
insert into T_NL_2 values(1, 11);
insert into T_NL_2 values(null, 22);
insert into T_NL_2 values(3, 33);
insert into T_NL_2 values(3, 33);
commit;
select T_NL_1.F_INT1, T_NL_2.F_INT1 from T_NL_1 left join T_NL_2 on T_NL_1.F_INT1 = T_NL_2.F_INT1 order by T_NL_1.F_INT1, T_NL_2.F_INT1;
select T_NL_1.F_INT1, T_NL_2.F_INT1 from T_NL_2 right join T_NL_1 on T_NL_1.F_INT1 = T_NL_2.F_INT1 order by T_NL_1.F_INT1, T_NL_2.F_INT1;
select T_NL_1.F_INT1, T_NL_2.F_INT1 from T_NL_2 right join T_NL_1 on T_NL_1.F_INT1 = T_NL_2.F_INT1 order by T_NL_2.F_INT1 NULLS FIRST, T_NL_1.F_INT1;
select T_NL_1.F_INT1, T_NL_2.F_INT1 from T_NL_1 right join T_NL_2 on T_NL_1.F_INT1 = T_NL_2.F_INT1 order by T_NL_1.F_INT1, T_NL_2.F_INT1;
select T_NL_1.F_INT1, T_NL_2.F_INT1 from T_NL_2 left join T_NL_1 on T_NL_1.F_INT1 = T_NL_2.F_INT1 order by T_NL_1.F_INT1, T_NL_2.F_INT1;
select T_NL_1.F_INT1, T_NL_2.F_INT1 from T_NL_2 left join T_NL_1 on T_NL_1.F_INT1 = T_NL_2.F_INT1 order by T_NL_1.F_INT1 NULLS FIRST, T_NL_2.F_INT1;
select T_NL_1.F_INT1, TT.F_INT1 from T_NL_1 left join (select F_INT1 from T_NL_2 minus select F_INT1 from T_NL_2) TT on T_NL_1.F_INT1 = TT.F_INT1 order by T_NL_1.F_INT1, TT.F_INT1;
select T_NL_1.F_INT1, TT.F_INT1 from T_NL_1 left join (select F_INT1 from T_NL_2 minus select 1 from dual) TT on T_NL_1.F_INT1 = TT.F_INT1 order by T_NL_1.F_INT1, TT.F_INT1;
select T_NL_1.F_INT1, TT.F_INT1 from T_NL_1 left join (select F_INT1 from T_NL_2 minus select 3 from dual) TT on T_NL_1.F_INT1 = TT.F_INT1 order by T_NL_1.F_INT1, TT.F_INT1;
select T_NL_1.F_INT1, T_NL_2.F_INT1 from T_NL_1 full join T_NL_2 on T_NL_1.F_INT1 = T_NL_2.F_INT1 order by T_NL_1.F_INT1, T_NL_2.F_INT1;
select T_NL_1.F_INT1, T_NL_2.F_INT1 from T_NL_1 full join T_NL_2 on T_NL_1.F_INT1 = T_NL_2.F_INT1 order by T_NL_1.F_INT1 nulls first, T_NL_2.F_INT1 nulls first;
select T_NL_1.F_INT1, T_NL_2.F_INT1 from T_NL_2 full join T_NL_1 on T_NL_1.F_INT1 = T_NL_2.F_INT1 order by T_NL_1.F_INT1, T_NL_2.F_INT1;
select T_NL_1.F_INT1, T_NL_2.F_INT1 from T_NL_1 full join T_NL_2 on 1 = 1 order by T_NL_1.F_INT1, T_NL_2.F_INT1;
select T_NL_1.F_INT1, T_NL_2.F_INT1 from T_NL_1 full join T_NL_2 on 1 = 1 order by T_NL_1.F_INT1, T_NL_2.F_INT1 NULLS FIRST;
select T_NL_1.F_INT1, T_NL_2.F_INT1 from T_NL_1 full join T_NL_2 on 1 = 1 order by T_NL_1.F_INT1 NULLS FIRST, T_NL_2.F_INT1;
select T_NL_1.F_INT1, T_NL_2.F_INT1 from T_NL_1 full join T_NL_2 on 1 = 1 order by T_NL_1.F_INT1 DESC NULLS FIRST, T_NL_2.F_INT1;
select T_NL_1.F_INT1, T_NL_2.F_INT1 from T_NL_1 full join T_NL_2 on 1 = 1 order by T_NL_1.F_INT1 DESC NULLS LAST, T_NL_2.F_INT1;
select T_NL_1.F_INT1, TT.F_INT1 from T_NL_1 full join (select F_INT1 from T_NL_2 minus select F_INT1 from T_NL_2) TT on T_NL_1.F_INT1 = TT.F_INT1 order by T_NL_1.F_INT1, TT.F_INT1;
select T_NL_1.F_INT1, TT.F_INT1 from T_NL_1 full join (select F_INT1 from T_NL_2 minus select 1 from dual) TT on T_NL_1.F_INT1 = TT.F_INT1 order by T_NL_1.F_INT1, TT.F_INT1;
select T_NL_1.F_INT1, TT.F_INT1 from T_NL_1 full join (select F_INT1 from T_NL_2 minus select 3 from dual) TT on T_NL_1.F_INT1 = TT.F_INT1 order by T_NL_1.F_INT1, TT.F_INT1;
select * from T_NL_1 left join T_NL_2 on T_NL_1.F_INT1=T_NL_2.F_INT1 where exists (select 1 from dual);
--as alias
SELECT * FROM T_NL_1 AS T1 WHERE T1.F_INT1=10;
SELECT * FROM T_NL_1 AS T1 JOIN T_NL_2 AS T2 ON T1.F_INT1=T2.F_INT1 WHERE T1.F_INT1=10;
SELECT * FROM T_NL_1 AS;
SELECT * FROM T_NL_1 AS AS;
-- contain index
--DTS2019122604117，DTS2019122512986
drop table if exists tableDTS2019122604117_1;
drop table if exists tableDTS2019122604117_2;
drop table if exists tableDTS2019122604117_3;
drop table if exists tableDTS2019122604117_4;
drop table if exists tableDTS2019122604117_5;
drop table if exists tableDTS2019122604117_6;
drop table if exists tableDTS2019122604117_7;
drop table if exists tableDTS2019122604117_8;
drop table if exists tableDTS2019122604117_9;
drop table if exists tableDTS2019122604117_10;
drop table if exists tableDTS2019122604117_11;
drop table if exists tableDTS2019122604117_12;
drop table if exists tableDTS2019122604117_13;
drop table if exists tableDTS2019122604117_14;
drop table if exists tableDTS2019122604117_15;
drop table if exists tableDTS2019122604117_16;
drop table if exists tableDTS2019122604117_17;
drop table if exists tableDTS2019122604117_18;
drop table if exists tableDTS2019122604117_19;
drop table if exists tableDTS2019122604117_20;
drop table if exists tableDTS2019122604117_21;
drop table if exists tableDTS2019122604117_22;
drop table if exists tableDTS2019122604117_23;
drop table if exists tableDTS2019122604117_24;
drop table if exists tableDTS2019122604117_25;
drop table if exists tableDTS2019122604117_26;
drop table if exists tableDTS2019122604117_27;
drop table if exists tableDTS2019122604117_28;
drop table if exists tableDTS2019122604117_29;
drop table if exists tableDTS2019122604117_30;
drop table if exists tableDTS2019122604117_31;
drop table if exists tableDTS2019122604117_32;
drop table if exists tableDTS2019122604117_33;
drop table if exists tableDTS2019122604117_34;
drop table if exists tableDTS2019122604117_35;
drop table if exists tableDTS2019122604117_36;
drop table if exists tableDTS2019122604117_37;
drop table if exists tableDTS2019122604117_38;
drop table if exists tableDTS2019122604117_39;
drop table if exists tableDTS2019122604117_40;
drop table if exists tableDTS2019122604117_41;
drop table if exists tableDTS2019122604117_42;
drop table if exists tableDTS2019122604117_43;
drop table if exists tableDTS2019122604117_44;
drop table if exists tableDTS2019122604117_45;
drop table if exists tableDTS2019122604117_46;
drop table if exists tableDTS2019122604117_47;
drop table if exists tableDTS2019122604117_48;
drop table if exists tableDTS2019122604117_49;
drop table if exists tableDTS2019122604117_50;
drop table if exists tableDTS2019122604117_51;
drop table if exists tableDTS2019122604117_52;
drop table if exists tableDTS2019122604117_53;
drop table if exists tableDTS2019122604117_54;
drop table if exists tableDTS2019122604117_55;
drop table if exists tableDTS2019122604117_56;
drop table if exists tableDTS2019122604117_57;
drop table if exists tableDTS2019122604117_58;
drop table if exists tableDTS2019122604117_59;
drop table if exists tableDTS2019122604117_60;
drop table if exists tableDTS2019122604117_61;
drop table if exists tableDTS2019122604117_62;
drop table if exists tableDTS2019122604117_63;
drop table if exists tableDTS2019122604117_64;
drop table if exists tableDTS2019122604117_65;
drop table if exists tableDTS2019122604117_66;
drop table if exists tableDTS2019122604117_67;
drop table if exists tableDTS2019122604117_68;
drop table if exists tableDTS2019122604117_69;
drop table if exists tableDTS2019122604117_70;
drop table if exists tableDTS2019122604117_71;
drop table if exists tableDTS2019122604117_72;
drop table if exists tableDTS2019122604117_73;
drop table if exists tableDTS2019122604117_74;
drop table if exists tableDTS2019122604117_75;
drop table if exists tableDTS2019122604117_76;
drop table if exists tableDTS2019122604117_77;
drop table if exists tableDTS2019122604117_78;
drop table if exists tableDTS2019122604117_79;
drop table if exists tableDTS2019122604117_80;
drop table if exists tableDTS2019122604117_81;
drop table if exists tableDTS2019122604117_82;
drop table if exists tableDTS2019122604117_83;
drop table if exists tableDTS2019122604117_84;
drop table if exists tableDTS2019122604117_85;
drop table if exists tableDTS2019122604117_86;
drop table if exists tableDTS2019122604117_87;
drop table if exists tableDTS2019122604117_88;
drop table if exists tableDTS2019122604117_89;
drop table if exists tableDTS2019122604117_90;
drop table if exists tableDTS2019122604117_91;
drop table if exists tableDTS2019122604117_92;
drop table if exists tableDTS2019122604117_93;
drop table if exists tableDTS2019122604117_94;
drop table if exists tableDTS2019122604117_95;
drop table if exists tableDTS2019122604117_96;
drop table if exists tableDTS2019122604117_97;
drop table if exists tableDTS2019122604117_98;
drop table if exists tableDTS2019122604117_99;
drop table if exists tableDTS2019122604117_100;
drop table if exists tableDTS2019122604117_101;
drop table if exists tableDTS2019122604117_102;
drop table if exists tableDTS2019122604117_103;
drop table if exists tableDTS2019122604117_104;
drop table if exists tableDTS2019122604117_105;
drop table if exists tableDTS2019122604117_106;
drop table if exists tableDTS2019122604117_107;
drop table if exists tableDTS2019122604117_108;
drop table if exists tableDTS2019122604117_109;
drop table if exists tableDTS2019122604117_110;
drop table if exists tableDTS2019122604117_111;
drop table if exists tableDTS2019122604117_112;
drop table if exists tableDTS2019122604117_113;
drop table if exists tableDTS2019122604117_114;
drop table if exists tableDTS2019122604117_115;
drop table if exists tableDTS2019122604117_116;
drop table if exists tableDTS2019122604117_117;
drop table if exists tableDTS2019122604117_118;
drop table if exists tableDTS2019122604117_119;
drop table if exists tableDTS2019122604117_120;
drop table if exists tableDTS2019122604117_121;
drop table if exists tableDTS2019122604117_122;
drop table if exists tableDTS2019122604117_123;
drop table if exists tableDTS2019122604117_124;
drop table if exists tableDTS2019122604117_125;
drop table if exists tableDTS2019122604117_126;
drop table if exists tableDTS2019122604117_127;
drop table if exists tableDTS2019122604117_128;
create table tableDTS2019122604117_1(id number);
create table tableDTS2019122604117_2(id number);
create table tableDTS2019122604117_3(id number);
create table tableDTS2019122604117_4(id number);
create table tableDTS2019122604117_5(id number);
create table tableDTS2019122604117_6(id number);
create table tableDTS2019122604117_7(id number);
create table tableDTS2019122604117_8(id number);
create table tableDTS2019122604117_9(id number);
create table tableDTS2019122604117_10(id number);
create table tableDTS2019122604117_11(id number);
create table tableDTS2019122604117_12(id number);
create table tableDTS2019122604117_13(id number);
create table tableDTS2019122604117_14(id number);
create table tableDTS2019122604117_15(id number);
create table tableDTS2019122604117_16(id number);
create table tableDTS2019122604117_17(id number);
create table tableDTS2019122604117_18(id number);
create table tableDTS2019122604117_19(id number);
create table tableDTS2019122604117_20(id number);
create table tableDTS2019122604117_21(id number);
create table tableDTS2019122604117_22(id number);
create table tableDTS2019122604117_23(id number);
create table tableDTS2019122604117_24(id number);
create table tableDTS2019122604117_25(id number);
create table tableDTS2019122604117_26(id number);
create table tableDTS2019122604117_27(id number);
create table tableDTS2019122604117_28(id number);
create table tableDTS2019122604117_29(id number);
create table tableDTS2019122604117_30(id number);
create table tableDTS2019122604117_31(id number);
create table tableDTS2019122604117_32(id number);
create table tableDTS2019122604117_33(id number);
create table tableDTS2019122604117_34(id number);
create table tableDTS2019122604117_35(id number);
create table tableDTS2019122604117_36(id number);
create table tableDTS2019122604117_37(id number);
create table tableDTS2019122604117_38(id number);
create table tableDTS2019122604117_39(id number);
create table tableDTS2019122604117_40(id number);
create table tableDTS2019122604117_41(id number);
create table tableDTS2019122604117_42(id number);
create table tableDTS2019122604117_43(id number);
create table tableDTS2019122604117_44(id number);
create table tableDTS2019122604117_45(id number);
create table tableDTS2019122604117_46(id number);
create table tableDTS2019122604117_47(id number);
create table tableDTS2019122604117_48(id number);
create table tableDTS2019122604117_49(id number);
create table tableDTS2019122604117_50(id number);
create table tableDTS2019122604117_51(id number);
create table tableDTS2019122604117_52(id number);
create table tableDTS2019122604117_53(id number);
create table tableDTS2019122604117_54(id number);
create table tableDTS2019122604117_55(id number);
create table tableDTS2019122604117_56(id number);
create table tableDTS2019122604117_57(id number);
create table tableDTS2019122604117_58(id number);
create table tableDTS2019122604117_59(id number);
create table tableDTS2019122604117_60(id number);
create table tableDTS2019122604117_61(id number);
create table tableDTS2019122604117_62(id number);
create table tableDTS2019122604117_63(id number);
create table tableDTS2019122604117_64(id number);
create table tableDTS2019122604117_65(id number);
create table tableDTS2019122604117_66(id number);
create table tableDTS2019122604117_67(id number);
create table tableDTS2019122604117_68(id number);
create table tableDTS2019122604117_69(id number);
create table tableDTS2019122604117_70(id number);
create table tableDTS2019122604117_71(id number);
create table tableDTS2019122604117_72(id number);
create table tableDTS2019122604117_73(id number);
create table tableDTS2019122604117_74(id number);
create table tableDTS2019122604117_75(id number);
create table tableDTS2019122604117_76(id number);
create table tableDTS2019122604117_77(id number);
create table tableDTS2019122604117_78(id number);
create table tableDTS2019122604117_79(id number);
create table tableDTS2019122604117_80(id number);
create table tableDTS2019122604117_81(id number);
create table tableDTS2019122604117_82(id number);
create table tableDTS2019122604117_83(id number);
create table tableDTS2019122604117_84(id number);
create table tableDTS2019122604117_85(id number);
create table tableDTS2019122604117_86(id number);
create table tableDTS2019122604117_87(id number);
create table tableDTS2019122604117_88(id number);
create table tableDTS2019122604117_89(id number);
create table tableDTS2019122604117_90(id number);
create table tableDTS2019122604117_91(id number);
create table tableDTS2019122604117_92(id number);
create table tableDTS2019122604117_93(id number);
create table tableDTS2019122604117_94(id number);
create table tableDTS2019122604117_95(id number);
create table tableDTS2019122604117_96(id number);
create table tableDTS2019122604117_97(id number);
create table tableDTS2019122604117_98(id number);
create table tableDTS2019122604117_99(id number);
create table tableDTS2019122604117_100(id number);
create table tableDTS2019122604117_101(id number);
create table tableDTS2019122604117_102(id number);
create table tableDTS2019122604117_103(id number);
create table tableDTS2019122604117_104(id number);
create table tableDTS2019122604117_105(id number);
create table tableDTS2019122604117_106(id number);
create table tableDTS2019122604117_107(id number);
create table tableDTS2019122604117_108(id number);
create table tableDTS2019122604117_109(id number);
create table tableDTS2019122604117_110(id number);
create table tableDTS2019122604117_111(id number);
create table tableDTS2019122604117_112(id number);
create table tableDTS2019122604117_113(id number);
create table tableDTS2019122604117_114(id number);
create table tableDTS2019122604117_115(id number);
create table tableDTS2019122604117_116(id number);
create table tableDTS2019122604117_117(id number);
create table tableDTS2019122604117_118(id number);
create table tableDTS2019122604117_119(id number);
create table tableDTS2019122604117_120(id number);
create table tableDTS2019122604117_121(id number);
create table tableDTS2019122604117_122(id number);
create table tableDTS2019122604117_123(id number);
create table tableDTS2019122604117_124(id number);
create table tableDTS2019122604117_125(id number);
create table tableDTS2019122604117_126(id number);
create table tableDTS2019122604117_127(id number);
create table tableDTS2019122604117_128(id number);
select  1 from tableDTS2019122604117_1 join tableDTS2019122604117_2 join tableDTS2019122604117_3 join tableDTS2019122604117_4 join tableDTS2019122604117_5 join tableDTS2019122604117_6 join tableDTS2019122604117_7 
join tableDTS2019122604117_8 join tableDTS2019122604117_9 join tableDTS2019122604117_10 join tableDTS2019122604117_11 join tableDTS2019122604117_12 join tableDTS2019122604117_13 join tableDTS2019122604117_14 
join tableDTS2019122604117_15 join tableDTS2019122604117_16 join tableDTS2019122604117_17 join tableDTS2019122604117_18 join tableDTS2019122604117_19 join tableDTS2019122604117_20 join tableDTS2019122604117_21 
join tableDTS2019122604117_22 join tableDTS2019122604117_23 join tableDTS2019122604117_24 join tableDTS2019122604117_25 join tableDTS2019122604117_26 join tableDTS2019122604117_27 join tableDTS2019122604117_28 
join tableDTS2019122604117_29 join tableDTS2019122604117_30 join tableDTS2019122604117_31 join tableDTS2019122604117_32 join tableDTS2019122604117_33 join tableDTS2019122604117_34 join tableDTS2019122604117_35 
join tableDTS2019122604117_36 join tableDTS2019122604117_37 join tableDTS2019122604117_38 join tableDTS2019122604117_39 join tableDTS2019122604117_40 join tableDTS2019122604117_41 join tableDTS2019122604117_42 
join tableDTS2019122604117_43 join tableDTS2019122604117_44 join tableDTS2019122604117_45 join tableDTS2019122604117_46 join tableDTS2019122604117_47 join tableDTS2019122604117_48 join tableDTS2019122604117_49 
join tableDTS2019122604117_50 join tableDTS2019122604117_51 join tableDTS2019122604117_52 join tableDTS2019122604117_53 join tableDTS2019122604117_54 join tableDTS2019122604117_55 join tableDTS2019122604117_56 
join tableDTS2019122604117_57 join tableDTS2019122604117_58 join tableDTS2019122604117_59 join tableDTS2019122604117_60 join tableDTS2019122604117_61 join tableDTS2019122604117_62 join tableDTS2019122604117_63 
join tableDTS2019122604117_64 join tableDTS2019122604117_65 join tableDTS2019122604117_66 join tableDTS2019122604117_67 join tableDTS2019122604117_68 join tableDTS2019122604117_69 join tableDTS2019122604117_70 
join tableDTS2019122604117_71 join tableDTS2019122604117_72 join tableDTS2019122604117_73 join tableDTS2019122604117_74 join tableDTS2019122604117_75 join tableDTS2019122604117_76 join tableDTS2019122604117_77 
join tableDTS2019122604117_78 join tableDTS2019122604117_79 join tableDTS2019122604117_80 join tableDTS2019122604117_81 join tableDTS2019122604117_82 join tableDTS2019122604117_83 join tableDTS2019122604117_84 
join tableDTS2019122604117_85 join tableDTS2019122604117_86 join tableDTS2019122604117_87 join tableDTS2019122604117_88 join tableDTS2019122604117_89 join tableDTS2019122604117_90 join tableDTS2019122604117_91 
join tableDTS2019122604117_92 join tableDTS2019122604117_93 join tableDTS2019122604117_94 join tableDTS2019122604117_95 join tableDTS2019122604117_96 join tableDTS2019122604117_97 join tableDTS2019122604117_98 
join tableDTS2019122604117_99 join tableDTS2019122604117_100 join tableDTS2019122604117_101 join tableDTS2019122604117_102 join tableDTS2019122604117_103 join tableDTS2019122604117_104 join tableDTS2019122604117_105 
join tableDTS2019122604117_106 join tableDTS2019122604117_107 join tableDTS2019122604117_108 join tableDTS2019122604117_109 join tableDTS2019122604117_110 join tableDTS2019122604117_111 join tableDTS2019122604117_112 
join tableDTS2019122604117_113 join tableDTS2019122604117_114 join tableDTS2019122604117_115 join tableDTS2019122604117_116 join tableDTS2019122604117_117 join tableDTS2019122604117_118 join tableDTS2019122604117_119 
join tableDTS2019122604117_120 join tableDTS2019122604117_121 join tableDTS2019122604117_122 join tableDTS2019122604117_123 join tableDTS2019122604117_124 join tableDTS2019122604117_125 join tableDTS2019122604117_126 
join tableDTS2019122604117_127 join tableDTS2019122604117_128;
select 1 from (select  1 from tableDTS2019122604117_1 join tableDTS2019122604117_2 join tableDTS2019122604117_3 join tableDTS2019122604117_4 join tableDTS2019122604117_5 join tableDTS2019122604117_6 join tableDTS2019122604117_7 
join tableDTS2019122604117_8 join tableDTS2019122604117_9 join tableDTS2019122604117_10 join tableDTS2019122604117_11 join tableDTS2019122604117_12 join tableDTS2019122604117_13 join tableDTS2019122604117_14 
join tableDTS2019122604117_15 join tableDTS2019122604117_16 join tableDTS2019122604117_17 join tableDTS2019122604117_18 join tableDTS2019122604117_19 join tableDTS2019122604117_20 join tableDTS2019122604117_21 
join tableDTS2019122604117_22 join tableDTS2019122604117_23 join tableDTS2019122604117_24 join tableDTS2019122604117_25 join tableDTS2019122604117_26 join tableDTS2019122604117_27 join tableDTS2019122604117_28 
join tableDTS2019122604117_29 join tableDTS2019122604117_30 join tableDTS2019122604117_31 join tableDTS2019122604117_32 join tableDTS2019122604117_33 join tableDTS2019122604117_34 join tableDTS2019122604117_35 
join tableDTS2019122604117_36 join tableDTS2019122604117_37 join tableDTS2019122604117_38 join tableDTS2019122604117_39 join tableDTS2019122604117_40 join tableDTS2019122604117_41 join tableDTS2019122604117_42 
join tableDTS2019122604117_43 join tableDTS2019122604117_44 join tableDTS2019122604117_45 join tableDTS2019122604117_46 join tableDTS2019122604117_47 join tableDTS2019122604117_48 join tableDTS2019122604117_49 
join tableDTS2019122604117_50 join tableDTS2019122604117_51 join tableDTS2019122604117_52 join tableDTS2019122604117_53 join tableDTS2019122604117_54 join tableDTS2019122604117_55 join tableDTS2019122604117_56 
join tableDTS2019122604117_57 join tableDTS2019122604117_58 join tableDTS2019122604117_59 join tableDTS2019122604117_60 join tableDTS2019122604117_61 join tableDTS2019122604117_62 join tableDTS2019122604117_63 
join tableDTS2019122604117_64 join tableDTS2019122604117_65 join tableDTS2019122604117_66 join tableDTS2019122604117_67 join tableDTS2019122604117_68 join tableDTS2019122604117_69 join tableDTS2019122604117_70 
join tableDTS2019122604117_71 join tableDTS2019122604117_72 join tableDTS2019122604117_73 join tableDTS2019122604117_74 join tableDTS2019122604117_75 join tableDTS2019122604117_76 join tableDTS2019122604117_77 
join tableDTS2019122604117_78 join tableDTS2019122604117_79 join tableDTS2019122604117_80 join tableDTS2019122604117_81 join tableDTS2019122604117_82 join tableDTS2019122604117_83 join tableDTS2019122604117_84 
join tableDTS2019122604117_85 join tableDTS2019122604117_86 join tableDTS2019122604117_87 join tableDTS2019122604117_88 join tableDTS2019122604117_89 join tableDTS2019122604117_90 join tableDTS2019122604117_91 
join tableDTS2019122604117_92 join tableDTS2019122604117_93 join tableDTS2019122604117_94 join tableDTS2019122604117_95 join tableDTS2019122604117_96 join tableDTS2019122604117_97 join tableDTS2019122604117_98 
join tableDTS2019122604117_99 join tableDTS2019122604117_100 join tableDTS2019122604117_101 join tableDTS2019122604117_102 join tableDTS2019122604117_103 join tableDTS2019122604117_104 join tableDTS2019122604117_105 
join tableDTS2019122604117_106 join tableDTS2019122604117_107 join tableDTS2019122604117_108 join tableDTS2019122604117_109 join tableDTS2019122604117_110 join tableDTS2019122604117_111 join tableDTS2019122604117_112 
join tableDTS2019122604117_113 join tableDTS2019122604117_114 join tableDTS2019122604117_115 join tableDTS2019122604117_116 join tableDTS2019122604117_117 join tableDTS2019122604117_118 join tableDTS2019122604117_119 
join tableDTS2019122604117_120 join tableDTS2019122604117_121 join tableDTS2019122604117_122 join tableDTS2019122604117_123 join tableDTS2019122604117_124 join tableDTS2019122604117_125 join tableDTS2019122604117_126 
join tableDTS2019122604117_127 join tableDTS2019122604117_128)tableDTS20200117102001,(select  1 from tableDTS2019122604117_1 join tableDTS2019122604117_2 join tableDTS2019122604117_3 join tableDTS2019122604117_4 join tableDTS2019122604117_5 join tableDTS2019122604117_6 join tableDTS2019122604117_7 
join tableDTS2019122604117_8 join tableDTS2019122604117_9 join tableDTS2019122604117_10 join tableDTS2019122604117_11 join tableDTS2019122604117_12 join tableDTS2019122604117_13 join tableDTS2019122604117_14 
join tableDTS2019122604117_15 join tableDTS2019122604117_16 join tableDTS2019122604117_17 join tableDTS2019122604117_18 join tableDTS2019122604117_19 join tableDTS2019122604117_20 join tableDTS2019122604117_21 
join tableDTS2019122604117_22 join tableDTS2019122604117_23 join tableDTS2019122604117_24 join tableDTS2019122604117_25 join tableDTS2019122604117_26 join tableDTS2019122604117_27 join tableDTS2019122604117_28 
join tableDTS2019122604117_29 join tableDTS2019122604117_30 join tableDTS2019122604117_31 join tableDTS2019122604117_32 join tableDTS2019122604117_33 join tableDTS2019122604117_34 join tableDTS2019122604117_35 
join tableDTS2019122604117_36 join tableDTS2019122604117_37 join tableDTS2019122604117_38 join tableDTS2019122604117_39 join tableDTS2019122604117_40 join tableDTS2019122604117_41 join tableDTS2019122604117_42 
join tableDTS2019122604117_43 join tableDTS2019122604117_44 join tableDTS2019122604117_45 join tableDTS2019122604117_46 join tableDTS2019122604117_47 join tableDTS2019122604117_48 join tableDTS2019122604117_49 
join tableDTS2019122604117_50 join tableDTS2019122604117_51 join tableDTS2019122604117_52 join tableDTS2019122604117_53 join tableDTS2019122604117_54 join tableDTS2019122604117_55 join tableDTS2019122604117_56 
join tableDTS2019122604117_57 join tableDTS2019122604117_58 join tableDTS2019122604117_59 join tableDTS2019122604117_60 join tableDTS2019122604117_61 join tableDTS2019122604117_62 join tableDTS2019122604117_63 
join tableDTS2019122604117_64 join tableDTS2019122604117_65 join tableDTS2019122604117_66 join tableDTS2019122604117_67 join tableDTS2019122604117_68 join tableDTS2019122604117_69 join tableDTS2019122604117_70 
join tableDTS2019122604117_71 join tableDTS2019122604117_72 join tableDTS2019122604117_73 join tableDTS2019122604117_74 join tableDTS2019122604117_75 join tableDTS2019122604117_76 join tableDTS2019122604117_77 
join tableDTS2019122604117_78 join tableDTS2019122604117_79 join tableDTS2019122604117_80 join tableDTS2019122604117_81 join tableDTS2019122604117_82 join tableDTS2019122604117_83 join tableDTS2019122604117_84 
join tableDTS2019122604117_85 join tableDTS2019122604117_86 join tableDTS2019122604117_87 join tableDTS2019122604117_88 join tableDTS2019122604117_89 join tableDTS2019122604117_90 join tableDTS2019122604117_91 
join tableDTS2019122604117_92 join tableDTS2019122604117_93 join tableDTS2019122604117_94 join tableDTS2019122604117_95 join tableDTS2019122604117_96 join tableDTS2019122604117_97 join tableDTS2019122604117_98 
join tableDTS2019122604117_99 join tableDTS2019122604117_100 join tableDTS2019122604117_101 join tableDTS2019122604117_102 join tableDTS2019122604117_103 join tableDTS2019122604117_104 join tableDTS2019122604117_105 
join tableDTS2019122604117_106 join tableDTS2019122604117_107 join tableDTS2019122604117_108 join tableDTS2019122604117_109 join tableDTS2019122604117_110 join tableDTS2019122604117_111 join tableDTS2019122604117_112 
join tableDTS2019122604117_113 join tableDTS2019122604117_114 join tableDTS2019122604117_115 join tableDTS2019122604117_116 join tableDTS2019122604117_117 join tableDTS2019122604117_118 join tableDTS2019122604117_119 
join tableDTS2019122604117_120 join tableDTS2019122604117_121 join tableDTS2019122604117_122 join tableDTS2019122604117_123 join tableDTS2019122604117_124 join tableDTS2019122604117_125 join tableDTS2019122604117_126 
join tableDTS2019122604117_127 join tableDTS2019122604117_128)tableDTS20200117102002,(select  1 from tableDTS2019122604117_1 join tableDTS2019122604117_2 join tableDTS2019122604117_3 join tableDTS2019122604117_4 join tableDTS2019122604117_5 join tableDTS2019122604117_6 join tableDTS2019122604117_7 
join tableDTS2019122604117_8 join tableDTS2019122604117_9 join tableDTS2019122604117_10 join tableDTS2019122604117_11 join tableDTS2019122604117_12 join tableDTS2019122604117_13 join tableDTS2019122604117_14 
join tableDTS2019122604117_15 join tableDTS2019122604117_16 join tableDTS2019122604117_17 join tableDTS2019122604117_18 join tableDTS2019122604117_19 join tableDTS2019122604117_20 join tableDTS2019122604117_21 
join tableDTS2019122604117_22 join tableDTS2019122604117_23 join tableDTS2019122604117_24 join tableDTS2019122604117_25 join tableDTS2019122604117_26 join tableDTS2019122604117_27 join tableDTS2019122604117_28 
join tableDTS2019122604117_29 join tableDTS2019122604117_30 join tableDTS2019122604117_31 join tableDTS2019122604117_32 join tableDTS2019122604117_33 join tableDTS2019122604117_34 join tableDTS2019122604117_35 
join tableDTS2019122604117_36 join tableDTS2019122604117_37 join tableDTS2019122604117_38 join tableDTS2019122604117_39 join tableDTS2019122604117_40 join tableDTS2019122604117_41 join tableDTS2019122604117_42 
join tableDTS2019122604117_43 join tableDTS2019122604117_44 join tableDTS2019122604117_45 join tableDTS2019122604117_46 join tableDTS2019122604117_47 join tableDTS2019122604117_48 join tableDTS2019122604117_49 
join tableDTS2019122604117_50 join tableDTS2019122604117_51 join tableDTS2019122604117_52 join tableDTS2019122604117_53 join tableDTS2019122604117_54 join tableDTS2019122604117_55 join tableDTS2019122604117_56 
join tableDTS2019122604117_57 join tableDTS2019122604117_58 join tableDTS2019122604117_59 join tableDTS2019122604117_60 join tableDTS2019122604117_61 join tableDTS2019122604117_62 join tableDTS2019122604117_63 
join tableDTS2019122604117_64 join tableDTS2019122604117_65 join tableDTS2019122604117_66 join tableDTS2019122604117_67 join tableDTS2019122604117_68 join tableDTS2019122604117_69 join tableDTS2019122604117_70 
join tableDTS2019122604117_71 join tableDTS2019122604117_72 join tableDTS2019122604117_73 join tableDTS2019122604117_74 join tableDTS2019122604117_75 join tableDTS2019122604117_76 join tableDTS2019122604117_77 
join tableDTS2019122604117_78 join tableDTS2019122604117_79 join tableDTS2019122604117_80 join tableDTS2019122604117_81 join tableDTS2019122604117_82 join tableDTS2019122604117_83 join tableDTS2019122604117_84 
join tableDTS2019122604117_85 join tableDTS2019122604117_86 join tableDTS2019122604117_87 join tableDTS2019122604117_88 join tableDTS2019122604117_89 join tableDTS2019122604117_90 join tableDTS2019122604117_91 
join tableDTS2019122604117_92 join tableDTS2019122604117_93 join tableDTS2019122604117_94 join tableDTS2019122604117_95 join tableDTS2019122604117_96 join tableDTS2019122604117_97 join tableDTS2019122604117_98 
join tableDTS2019122604117_99 join tableDTS2019122604117_100 join tableDTS2019122604117_101 join tableDTS2019122604117_102 join tableDTS2019122604117_103 join tableDTS2019122604117_104 join tableDTS2019122604117_105 
join tableDTS2019122604117_106 join tableDTS2019122604117_107 join tableDTS2019122604117_108 join tableDTS2019122604117_109 join tableDTS2019122604117_110 join tableDTS2019122604117_111 join tableDTS2019122604117_112 
join tableDTS2019122604117_113 join tableDTS2019122604117_114 join tableDTS2019122604117_115 join tableDTS2019122604117_116 join tableDTS2019122604117_117 join tableDTS2019122604117_118 join tableDTS2019122604117_119 
join tableDTS2019122604117_120 join tableDTS2019122604117_121 join tableDTS2019122604117_122 join tableDTS2019122604117_123 join tableDTS2019122604117_124 join tableDTS2019122604117_125 join tableDTS2019122604117_126 
join tableDTS2019122604117_127 join tableDTS2019122604117_128)tableDTS20200117102003,(select  1 from tableDTS2019122604117_1 join tableDTS2019122604117_2 join tableDTS2019122604117_3 join tableDTS2019122604117_4 join tableDTS2019122604117_5 join tableDTS2019122604117_6 join tableDTS2019122604117_7 
join tableDTS2019122604117_8 join tableDTS2019122604117_9 join tableDTS2019122604117_10 join tableDTS2019122604117_11 join tableDTS2019122604117_12 join tableDTS2019122604117_13 join tableDTS2019122604117_14 
join tableDTS2019122604117_15 join tableDTS2019122604117_16 join tableDTS2019122604117_17 join tableDTS2019122604117_18 join tableDTS2019122604117_19 join tableDTS2019122604117_20 join tableDTS2019122604117_21 
join tableDTS2019122604117_22 join tableDTS2019122604117_23 join tableDTS2019122604117_24 join tableDTS2019122604117_25 join tableDTS2019122604117_26 join tableDTS2019122604117_27 join tableDTS2019122604117_28 
join tableDTS2019122604117_29 join tableDTS2019122604117_30 join tableDTS2019122604117_31 join tableDTS2019122604117_32 join tableDTS2019122604117_33 join tableDTS2019122604117_34 join tableDTS2019122604117_35 
join tableDTS2019122604117_36 join tableDTS2019122604117_37 join tableDTS2019122604117_38 join tableDTS2019122604117_39 join tableDTS2019122604117_40 join tableDTS2019122604117_41 join tableDTS2019122604117_42 
join tableDTS2019122604117_43 join tableDTS2019122604117_44 join tableDTS2019122604117_45 join tableDTS2019122604117_46 join tableDTS2019122604117_47 join tableDTS2019122604117_48 join tableDTS2019122604117_49 
join tableDTS2019122604117_50 join tableDTS2019122604117_51 join tableDTS2019122604117_52 join tableDTS2019122604117_53 join tableDTS2019122604117_54 join tableDTS2019122604117_55 join tableDTS2019122604117_56 
join tableDTS2019122604117_57 join tableDTS2019122604117_58 join tableDTS2019122604117_59 join tableDTS2019122604117_60 join tableDTS2019122604117_61 join tableDTS2019122604117_62 join tableDTS2019122604117_63 
join tableDTS2019122604117_64 join tableDTS2019122604117_65 join tableDTS2019122604117_66 join tableDTS2019122604117_67 join tableDTS2019122604117_68 join tableDTS2019122604117_69 join tableDTS2019122604117_70 
join tableDTS2019122604117_71 join tableDTS2019122604117_72 join tableDTS2019122604117_73 join tableDTS2019122604117_74 join tableDTS2019122604117_75 join tableDTS2019122604117_76 join tableDTS2019122604117_77 
join tableDTS2019122604117_78 join tableDTS2019122604117_79 join tableDTS2019122604117_80 join tableDTS2019122604117_81 join tableDTS2019122604117_82 join tableDTS2019122604117_83 join tableDTS2019122604117_84 
join tableDTS2019122604117_85 join tableDTS2019122604117_86 join tableDTS2019122604117_87 join tableDTS2019122604117_88 join tableDTS2019122604117_89 join tableDTS2019122604117_90 join tableDTS2019122604117_91 
join tableDTS2019122604117_92 join tableDTS2019122604117_93 join tableDTS2019122604117_94 join tableDTS2019122604117_95 join tableDTS2019122604117_96 join tableDTS2019122604117_97 join tableDTS2019122604117_98 
join tableDTS2019122604117_99 join tableDTS2019122604117_100 join tableDTS2019122604117_101 join tableDTS2019122604117_102 join tableDTS2019122604117_103 join tableDTS2019122604117_104 join tableDTS2019122604117_105 
join tableDTS2019122604117_106 join tableDTS2019122604117_107 join tableDTS2019122604117_108 join tableDTS2019122604117_109 join tableDTS2019122604117_110 join tableDTS2019122604117_111 join tableDTS2019122604117_112 
join tableDTS2019122604117_113 join tableDTS2019122604117_114 join tableDTS2019122604117_115 join tableDTS2019122604117_116 join tableDTS2019122604117_117 join tableDTS2019122604117_118 join tableDTS2019122604117_119 
join tableDTS2019122604117_120 join tableDTS2019122604117_121 join tableDTS2019122604117_122 join tableDTS2019122604117_123 join tableDTS2019122604117_124 join tableDTS2019122604117_125 join tableDTS2019122604117_126 
join tableDTS2019122604117_127 join tableDTS2019122604117_128)tableDTS20200117102004,(select  1 from tableDTS2019122604117_1 join tableDTS2019122604117_2 join tableDTS2019122604117_3 join tableDTS2019122604117_4 join tableDTS2019122604117_5 join tableDTS2019122604117_6 join tableDTS2019122604117_7 
join tableDTS2019122604117_8 join tableDTS2019122604117_9 join tableDTS2019122604117_10 join tableDTS2019122604117_11 join tableDTS2019122604117_12 join tableDTS2019122604117_13 join tableDTS2019122604117_14 
join tableDTS2019122604117_15 join tableDTS2019122604117_16 join tableDTS2019122604117_17 join tableDTS2019122604117_18 join tableDTS2019122604117_19 join tableDTS2019122604117_20 join tableDTS2019122604117_21 
join tableDTS2019122604117_22 join tableDTS2019122604117_23 join tableDTS2019122604117_24 join tableDTS2019122604117_25 join tableDTS2019122604117_26 join tableDTS2019122604117_27 join tableDTS2019122604117_28 
join tableDTS2019122604117_29 join tableDTS2019122604117_30 join tableDTS2019122604117_31 join tableDTS2019122604117_32 join tableDTS2019122604117_33 join tableDTS2019122604117_34 join tableDTS2019122604117_35 
join tableDTS2019122604117_36 join tableDTS2019122604117_37 join tableDTS2019122604117_38 join tableDTS2019122604117_39 join tableDTS2019122604117_40 join tableDTS2019122604117_41 join tableDTS2019122604117_42 
join tableDTS2019122604117_43 join tableDTS2019122604117_44 join tableDTS2019122604117_45 join tableDTS2019122604117_46 join tableDTS2019122604117_47 join tableDTS2019122604117_48 join tableDTS2019122604117_49 
join tableDTS2019122604117_50 join tableDTS2019122604117_51 join tableDTS2019122604117_52 join tableDTS2019122604117_53 join tableDTS2019122604117_54 join tableDTS2019122604117_55 join tableDTS2019122604117_56 
join tableDTS2019122604117_57 join tableDTS2019122604117_58 join tableDTS2019122604117_59 join tableDTS2019122604117_60 join tableDTS2019122604117_61 join tableDTS2019122604117_62 join tableDTS2019122604117_63 
join tableDTS2019122604117_64 join tableDTS2019122604117_65 join tableDTS2019122604117_66 join tableDTS2019122604117_67 join tableDTS2019122604117_68 join tableDTS2019122604117_69 join tableDTS2019122604117_70 
join tableDTS2019122604117_71 join tableDTS2019122604117_72 join tableDTS2019122604117_73 join tableDTS2019122604117_74 join tableDTS2019122604117_75 join tableDTS2019122604117_76 join tableDTS2019122604117_77 
join tableDTS2019122604117_78 join tableDTS2019122604117_79 join tableDTS2019122604117_80 join tableDTS2019122604117_81 join tableDTS2019122604117_82 join tableDTS2019122604117_83 join tableDTS2019122604117_84 
join tableDTS2019122604117_85 join tableDTS2019122604117_86 join tableDTS2019122604117_87 join tableDTS2019122604117_88 join tableDTS2019122604117_89 join tableDTS2019122604117_90 join tableDTS2019122604117_91 
join tableDTS2019122604117_92 join tableDTS2019122604117_93 join tableDTS2019122604117_94 join tableDTS2019122604117_95 join tableDTS2019122604117_96 join tableDTS2019122604117_97 join tableDTS2019122604117_98 
join tableDTS2019122604117_99 join tableDTS2019122604117_100 join tableDTS2019122604117_101 join tableDTS2019122604117_102 join tableDTS2019122604117_103 join tableDTS2019122604117_104 join tableDTS2019122604117_105 
join tableDTS2019122604117_106 join tableDTS2019122604117_107 join tableDTS2019122604117_108 join tableDTS2019122604117_109 join tableDTS2019122604117_110 join tableDTS2019122604117_111 join tableDTS2019122604117_112 
join tableDTS2019122604117_113 join tableDTS2019122604117_114 join tableDTS2019122604117_115 join tableDTS2019122604117_116 join tableDTS2019122604117_117 join tableDTS2019122604117_118 join tableDTS2019122604117_119 
join tableDTS2019122604117_120 join tableDTS2019122604117_121 join tableDTS2019122604117_122 join tableDTS2019122604117_123 join tableDTS2019122604117_124 join tableDTS2019122604117_125 join tableDTS2019122604117_126 
join tableDTS2019122604117_127 join tableDTS2019122604117_128)tableDTS20200117102005,(select  1 from tableDTS2019122604117_1 join tableDTS2019122604117_2 join tableDTS2019122604117_3 join tableDTS2019122604117_4 join tableDTS2019122604117_5 join tableDTS2019122604117_6 join tableDTS2019122604117_7 
join tableDTS2019122604117_8 join tableDTS2019122604117_9 join tableDTS2019122604117_10 join tableDTS2019122604117_11 join tableDTS2019122604117_12 join tableDTS2019122604117_13 join tableDTS2019122604117_14 
join tableDTS2019122604117_15 join tableDTS2019122604117_16 join tableDTS2019122604117_17 join tableDTS2019122604117_18 join tableDTS2019122604117_19 join tableDTS2019122604117_20 join tableDTS2019122604117_21 
join tableDTS2019122604117_22 join tableDTS2019122604117_23 join tableDTS2019122604117_24 join tableDTS2019122604117_25 join tableDTS2019122604117_26 join tableDTS2019122604117_27 join tableDTS2019122604117_28 
join tableDTS2019122604117_29 join tableDTS2019122604117_30 join tableDTS2019122604117_31 join tableDTS2019122604117_32 join tableDTS2019122604117_33 join tableDTS2019122604117_34 join tableDTS2019122604117_35 
join tableDTS2019122604117_36 join tableDTS2019122604117_37 join tableDTS2019122604117_38 join tableDTS2019122604117_39 join tableDTS2019122604117_40 join tableDTS2019122604117_41 join tableDTS2019122604117_42 
join tableDTS2019122604117_43 join tableDTS2019122604117_44 join tableDTS2019122604117_45 join tableDTS2019122604117_46 join tableDTS2019122604117_47 join tableDTS2019122604117_48 join tableDTS2019122604117_49 
join tableDTS2019122604117_50 join tableDTS2019122604117_51 join tableDTS2019122604117_52 join tableDTS2019122604117_53 join tableDTS2019122604117_54 join tableDTS2019122604117_55 join tableDTS2019122604117_56 
join tableDTS2019122604117_57 join tableDTS2019122604117_58 join tableDTS2019122604117_59 join tableDTS2019122604117_60 join tableDTS2019122604117_61 join tableDTS2019122604117_62 join tableDTS2019122604117_63 
join tableDTS2019122604117_64 join tableDTS2019122604117_65 join tableDTS2019122604117_66 join tableDTS2019122604117_67 join tableDTS2019122604117_68 join tableDTS2019122604117_69 join tableDTS2019122604117_70 
join tableDTS2019122604117_71 join tableDTS2019122604117_72 join tableDTS2019122604117_73 join tableDTS2019122604117_74 join tableDTS2019122604117_75 join tableDTS2019122604117_76 join tableDTS2019122604117_77 
join tableDTS2019122604117_78 join tableDTS2019122604117_79 join tableDTS2019122604117_80 join tableDTS2019122604117_81 join tableDTS2019122604117_82 join tableDTS2019122604117_83 join tableDTS2019122604117_84 
join tableDTS2019122604117_85 join tableDTS2019122604117_86 join tableDTS2019122604117_87 join tableDTS2019122604117_88 join tableDTS2019122604117_89 join tableDTS2019122604117_90 join tableDTS2019122604117_91 
join tableDTS2019122604117_92 join tableDTS2019122604117_93 join tableDTS2019122604117_94 join tableDTS2019122604117_95 join tableDTS2019122604117_96 join tableDTS2019122604117_97 join tableDTS2019122604117_98 
join tableDTS2019122604117_99 join tableDTS2019122604117_100 join tableDTS2019122604117_101 join tableDTS2019122604117_102 join tableDTS2019122604117_103 join tableDTS2019122604117_104 join tableDTS2019122604117_105 
join tableDTS2019122604117_106 join tableDTS2019122604117_107 join tableDTS2019122604117_108 join tableDTS2019122604117_109 join tableDTS2019122604117_110 join tableDTS2019122604117_111 join tableDTS2019122604117_112 
join tableDTS2019122604117_113 join tableDTS2019122604117_114 join tableDTS2019122604117_115 join tableDTS2019122604117_116 join tableDTS2019122604117_117 join tableDTS2019122604117_118 join tableDTS2019122604117_119 
join tableDTS2019122604117_120 join tableDTS2019122604117_121 join tableDTS2019122604117_122 join tableDTS2019122604117_123 join tableDTS2019122604117_124 join tableDTS2019122604117_125 join tableDTS2019122604117_126 
join tableDTS2019122604117_127 join tableDTS2019122604117_128)tableDTS20200117102006,(select  1 from tableDTS2019122604117_1 join tableDTS2019122604117_2 join tableDTS2019122604117_3 join tableDTS2019122604117_4 join tableDTS2019122604117_5 join tableDTS2019122604117_6 join tableDTS2019122604117_7 
join tableDTS2019122604117_8 join tableDTS2019122604117_9 join tableDTS2019122604117_10 join tableDTS2019122604117_11 join tableDTS2019122604117_12 join tableDTS2019122604117_13 join tableDTS2019122604117_14 
join tableDTS2019122604117_15 join tableDTS2019122604117_16 join tableDTS2019122604117_17 join tableDTS2019122604117_18 join tableDTS2019122604117_19 join tableDTS2019122604117_20 join tableDTS2019122604117_21 
join tableDTS2019122604117_22 join tableDTS2019122604117_23 join tableDTS2019122604117_24 join tableDTS2019122604117_25 join tableDTS2019122604117_26 join tableDTS2019122604117_27 join tableDTS2019122604117_28 
join tableDTS2019122604117_29 join tableDTS2019122604117_30 join tableDTS2019122604117_31 join tableDTS2019122604117_32 join tableDTS2019122604117_33 join tableDTS2019122604117_34 join tableDTS2019122604117_35 
join tableDTS2019122604117_36 join tableDTS2019122604117_37 join tableDTS2019122604117_38 join tableDTS2019122604117_39 join tableDTS2019122604117_40 join tableDTS2019122604117_41 join tableDTS2019122604117_42 
join tableDTS2019122604117_43 join tableDTS2019122604117_44 join tableDTS2019122604117_45 join tableDTS2019122604117_46 join tableDTS2019122604117_47 join tableDTS2019122604117_48 join tableDTS2019122604117_49 
join tableDTS2019122604117_50 join tableDTS2019122604117_51 join tableDTS2019122604117_52 join tableDTS2019122604117_53 join tableDTS2019122604117_54 join tableDTS2019122604117_55 join tableDTS2019122604117_56 
join tableDTS2019122604117_57 join tableDTS2019122604117_58 join tableDTS2019122604117_59 join tableDTS2019122604117_60 join tableDTS2019122604117_61 join tableDTS2019122604117_62 join tableDTS2019122604117_63 
join tableDTS2019122604117_64 join tableDTS2019122604117_65 join tableDTS2019122604117_66 join tableDTS2019122604117_67 join tableDTS2019122604117_68 join tableDTS2019122604117_69 join tableDTS2019122604117_70 
join tableDTS2019122604117_71 join tableDTS2019122604117_72 join tableDTS2019122604117_73 join tableDTS2019122604117_74 join tableDTS2019122604117_75 join tableDTS2019122604117_76 join tableDTS2019122604117_77 
join tableDTS2019122604117_78 join tableDTS2019122604117_79 join tableDTS2019122604117_80 join tableDTS2019122604117_81 join tableDTS2019122604117_82 join tableDTS2019122604117_83 join tableDTS2019122604117_84 
join tableDTS2019122604117_85 join tableDTS2019122604117_86 join tableDTS2019122604117_87 join tableDTS2019122604117_88 join tableDTS2019122604117_89 join tableDTS2019122604117_90 join tableDTS2019122604117_91 
join tableDTS2019122604117_92 join tableDTS2019122604117_93 join tableDTS2019122604117_94 join tableDTS2019122604117_95 join tableDTS2019122604117_96 join tableDTS2019122604117_97 join tableDTS2019122604117_98 
join tableDTS2019122604117_99 join tableDTS2019122604117_100 join tableDTS2019122604117_101 join tableDTS2019122604117_102 join tableDTS2019122604117_103 join tableDTS2019122604117_104 join tableDTS2019122604117_105 
join tableDTS2019122604117_106 join tableDTS2019122604117_107 join tableDTS2019122604117_108 join tableDTS2019122604117_109 join tableDTS2019122604117_110 join tableDTS2019122604117_111 join tableDTS2019122604117_112 
join tableDTS2019122604117_113 join tableDTS2019122604117_114 join tableDTS2019122604117_115 join tableDTS2019122604117_116 join tableDTS2019122604117_117 join tableDTS2019122604117_118 join tableDTS2019122604117_119 
join tableDTS2019122604117_120 join tableDTS2019122604117_121 join tableDTS2019122604117_122 join tableDTS2019122604117_123 join tableDTS2019122604117_124 join tableDTS2019122604117_125 join tableDTS2019122604117_126 
join tableDTS2019122604117_127 join tableDTS2019122604117_128)tableDTS20200117102007,(select  1 from tableDTS2019122604117_1 join tableDTS2019122604117_2 join tableDTS2019122604117_3 join tableDTS2019122604117_4 join tableDTS2019122604117_5 join tableDTS2019122604117_6 join tableDTS2019122604117_7 
join tableDTS2019122604117_8 join tableDTS2019122604117_9 join tableDTS2019122604117_10 join tableDTS2019122604117_11 join tableDTS2019122604117_12 join tableDTS2019122604117_13 join tableDTS2019122604117_14 
join tableDTS2019122604117_15 join tableDTS2019122604117_16 join tableDTS2019122604117_17 join tableDTS2019122604117_18 join tableDTS2019122604117_19 join tableDTS2019122604117_20 join tableDTS2019122604117_21 
join tableDTS2019122604117_22 join tableDTS2019122604117_23 join tableDTS2019122604117_24 join tableDTS2019122604117_25 join tableDTS2019122604117_26 join tableDTS2019122604117_27 join tableDTS2019122604117_28 
join tableDTS2019122604117_29 join tableDTS2019122604117_30 join tableDTS2019122604117_31 join tableDTS2019122604117_32 join tableDTS2019122604117_33 join tableDTS2019122604117_34 join tableDTS2019122604117_35 
join tableDTS2019122604117_36 join tableDTS2019122604117_37 join tableDTS2019122604117_38 join tableDTS2019122604117_39 join tableDTS2019122604117_40 join tableDTS2019122604117_41 join tableDTS2019122604117_42 
join tableDTS2019122604117_43 join tableDTS2019122604117_44 join tableDTS2019122604117_45 join tableDTS2019122604117_46 join tableDTS2019122604117_47 join tableDTS2019122604117_48 join tableDTS2019122604117_49 
join tableDTS2019122604117_50 join tableDTS2019122604117_51 join tableDTS2019122604117_52 join tableDTS2019122604117_53 join tableDTS2019122604117_54 join tableDTS2019122604117_55 join tableDTS2019122604117_56 
join tableDTS2019122604117_57 join tableDTS2019122604117_58 join tableDTS2019122604117_59 join tableDTS2019122604117_60 join tableDTS2019122604117_61 join tableDTS2019122604117_62 join tableDTS2019122604117_63 
join tableDTS2019122604117_64 join tableDTS2019122604117_65 join tableDTS2019122604117_66 join tableDTS2019122604117_67 join tableDTS2019122604117_68 join tableDTS2019122604117_69 join tableDTS2019122604117_70 
join tableDTS2019122604117_71 join tableDTS2019122604117_72 join tableDTS2019122604117_73 join tableDTS2019122604117_74 join tableDTS2019122604117_75 join tableDTS2019122604117_76 join tableDTS2019122604117_77 
join tableDTS2019122604117_78 join tableDTS2019122604117_79 join tableDTS2019122604117_80 join tableDTS2019122604117_81 join tableDTS2019122604117_82 join tableDTS2019122604117_83 join tableDTS2019122604117_84 
join tableDTS2019122604117_85 join tableDTS2019122604117_86 join tableDTS2019122604117_87 join tableDTS2019122604117_88 join tableDTS2019122604117_89 join tableDTS2019122604117_90 join tableDTS2019122604117_91 
join tableDTS2019122604117_92 join tableDTS2019122604117_93 join tableDTS2019122604117_94 join tableDTS2019122604117_95 join tableDTS2019122604117_96 join tableDTS2019122604117_97 join tableDTS2019122604117_98 
join tableDTS2019122604117_99 join tableDTS2019122604117_100 join tableDTS2019122604117_101 join tableDTS2019122604117_102 join tableDTS2019122604117_103 join tableDTS2019122604117_104 join tableDTS2019122604117_105 
join tableDTS2019122604117_106 join tableDTS2019122604117_107 join tableDTS2019122604117_108 join tableDTS2019122604117_109 join tableDTS2019122604117_110 join tableDTS2019122604117_111 join tableDTS2019122604117_112 
join tableDTS2019122604117_113 join tableDTS2019122604117_114 join tableDTS2019122604117_115 join tableDTS2019122604117_116 join tableDTS2019122604117_117 join tableDTS2019122604117_118 join tableDTS2019122604117_119 
join tableDTS2019122604117_120 join tableDTS2019122604117_121 join tableDTS2019122604117_122 join tableDTS2019122604117_123 join tableDTS2019122604117_124 join tableDTS2019122604117_125 join tableDTS2019122604117_126 
join tableDTS2019122604117_127 join tableDTS2019122604117_128)tableDTS20200117102008,(select  1 from tableDTS2019122604117_1 join tableDTS2019122604117_2 join tableDTS2019122604117_3 join tableDTS2019122604117_4 join tableDTS2019122604117_5 join tableDTS2019122604117_6 join tableDTS2019122604117_7 
join tableDTS2019122604117_8 join tableDTS2019122604117_9 join tableDTS2019122604117_10 join tableDTS2019122604117_11 join tableDTS2019122604117_12 join tableDTS2019122604117_13 join tableDTS2019122604117_14 
join tableDTS2019122604117_15 join tableDTS2019122604117_16 join tableDTS2019122604117_17 join tableDTS2019122604117_18 join tableDTS2019122604117_19 join tableDTS2019122604117_20 join tableDTS2019122604117_21 
join tableDTS2019122604117_22 join tableDTS2019122604117_23 join tableDTS2019122604117_24 join tableDTS2019122604117_25 join tableDTS2019122604117_26 join tableDTS2019122604117_27 join tableDTS2019122604117_28 
join tableDTS2019122604117_29 join tableDTS2019122604117_30 join tableDTS2019122604117_31 join tableDTS2019122604117_32 join tableDTS2019122604117_33 join tableDTS2019122604117_34 join tableDTS2019122604117_35 
join tableDTS2019122604117_36 join tableDTS2019122604117_37 join tableDTS2019122604117_38 join tableDTS2019122604117_39 join tableDTS2019122604117_40 join tableDTS2019122604117_41 join tableDTS2019122604117_42 
join tableDTS2019122604117_43 join tableDTS2019122604117_44 join tableDTS2019122604117_45 join tableDTS2019122604117_46 join tableDTS2019122604117_47 join tableDTS2019122604117_48 join tableDTS2019122604117_49 
join tableDTS2019122604117_50 join tableDTS2019122604117_51 join tableDTS2019122604117_52 join tableDTS2019122604117_53 join tableDTS2019122604117_54 join tableDTS2019122604117_55 join tableDTS2019122604117_56 
join tableDTS2019122604117_57 join tableDTS2019122604117_58 join tableDTS2019122604117_59 join tableDTS2019122604117_60 join tableDTS2019122604117_61 join tableDTS2019122604117_62 join tableDTS2019122604117_63 
join tableDTS2019122604117_64 join tableDTS2019122604117_65 join tableDTS2019122604117_66 join tableDTS2019122604117_67 join tableDTS2019122604117_68 join tableDTS2019122604117_69 join tableDTS2019122604117_70 
join tableDTS2019122604117_71 join tableDTS2019122604117_72 join tableDTS2019122604117_73 join tableDTS2019122604117_74 join tableDTS2019122604117_75 join tableDTS2019122604117_76 join tableDTS2019122604117_77 
join tableDTS2019122604117_78 join tableDTS2019122604117_79 join tableDTS2019122604117_80 join tableDTS2019122604117_81 join tableDTS2019122604117_82 join tableDTS2019122604117_83 join tableDTS2019122604117_84 
join tableDTS2019122604117_85 join tableDTS2019122604117_86 join tableDTS2019122604117_87 join tableDTS2019122604117_88 join tableDTS2019122604117_89 join tableDTS2019122604117_90 join tableDTS2019122604117_91 
join tableDTS2019122604117_92 join tableDTS2019122604117_93 join tableDTS2019122604117_94 join tableDTS2019122604117_95 join tableDTS2019122604117_96 join tableDTS2019122604117_97 join tableDTS2019122604117_98 
join tableDTS2019122604117_99 join tableDTS2019122604117_100 join tableDTS2019122604117_101 join tableDTS2019122604117_102 join tableDTS2019122604117_103 join tableDTS2019122604117_104 join tableDTS2019122604117_105 
join tableDTS2019122604117_106 join tableDTS2019122604117_107 join tableDTS2019122604117_108 join tableDTS2019122604117_109 join tableDTS2019122604117_110 join tableDTS2019122604117_111 join tableDTS2019122604117_112 
join tableDTS2019122604117_113 join tableDTS2019122604117_114 join tableDTS2019122604117_115 join tableDTS2019122604117_116 join tableDTS2019122604117_117 join tableDTS2019122604117_118 join tableDTS2019122604117_119 
join tableDTS2019122604117_120 join tableDTS2019122604117_121 join tableDTS2019122604117_122 join tableDTS2019122604117_123 join tableDTS2019122604117_124 join tableDTS2019122604117_125 join tableDTS2019122604117_126 
join tableDTS2019122604117_127 join tableDTS2019122604117_128)tableDTS20200117102009,(select  1 from tableDTS2019122604117_1 join tableDTS2019122604117_2 join tableDTS2019122604117_3 join tableDTS2019122604117_4 join tableDTS2019122604117_5 join tableDTS2019122604117_6 join tableDTS2019122604117_7 
join tableDTS2019122604117_8 join tableDTS2019122604117_9 join tableDTS2019122604117_10 join tableDTS2019122604117_11 join tableDTS2019122604117_12 join tableDTS2019122604117_13 join tableDTS2019122604117_14 
join tableDTS2019122604117_15 join tableDTS2019122604117_16 join tableDTS2019122604117_17 join tableDTS2019122604117_18 join tableDTS2019122604117_19 join tableDTS2019122604117_20 join tableDTS2019122604117_21 
join tableDTS2019122604117_22 join tableDTS2019122604117_23 join tableDTS2019122604117_24 join tableDTS2019122604117_25 join tableDTS2019122604117_26 join tableDTS2019122604117_27 join tableDTS2019122604117_28 
join tableDTS2019122604117_29 join tableDTS2019122604117_30 join tableDTS2019122604117_31 join tableDTS2019122604117_32 join tableDTS2019122604117_33 join tableDTS2019122604117_34 join tableDTS2019122604117_35 
join tableDTS2019122604117_36 join tableDTS2019122604117_37 join tableDTS2019122604117_38 join tableDTS2019122604117_39 join tableDTS2019122604117_40 join tableDTS2019122604117_41 join tableDTS2019122604117_42 
join tableDTS2019122604117_43 join tableDTS2019122604117_44 join tableDTS2019122604117_45 join tableDTS2019122604117_46 join tableDTS2019122604117_47 join tableDTS2019122604117_48 join tableDTS2019122604117_49 
join tableDTS2019122604117_50 join tableDTS2019122604117_51 join tableDTS2019122604117_52 join tableDTS2019122604117_53 join tableDTS2019122604117_54 join tableDTS2019122604117_55 join tableDTS2019122604117_56 
join tableDTS2019122604117_57 join tableDTS2019122604117_58 join tableDTS2019122604117_59 join tableDTS2019122604117_60 join tableDTS2019122604117_61 join tableDTS2019122604117_62 join tableDTS2019122604117_63 
join tableDTS2019122604117_64 join tableDTS2019122604117_65 join tableDTS2019122604117_66 join tableDTS2019122604117_67 join tableDTS2019122604117_68 join tableDTS2019122604117_69 join tableDTS2019122604117_70 
join tableDTS2019122604117_71 join tableDTS2019122604117_72 join tableDTS2019122604117_73 join tableDTS2019122604117_74 join tableDTS2019122604117_75 join tableDTS2019122604117_76 join tableDTS2019122604117_77 
join tableDTS2019122604117_78 join tableDTS2019122604117_79 join tableDTS2019122604117_80 join tableDTS2019122604117_81 join tableDTS2019122604117_82 join tableDTS2019122604117_83 join tableDTS2019122604117_84 
join tableDTS2019122604117_85 join tableDTS2019122604117_86 join tableDTS2019122604117_87 join tableDTS2019122604117_88 join tableDTS2019122604117_89 join tableDTS2019122604117_90 join tableDTS2019122604117_91 
join tableDTS2019122604117_92 join tableDTS2019122604117_93 join tableDTS2019122604117_94 join tableDTS2019122604117_95 join tableDTS2019122604117_96 join tableDTS2019122604117_97 join tableDTS2019122604117_98 
join tableDTS2019122604117_99 join tableDTS2019122604117_100 join tableDTS2019122604117_101 join tableDTS2019122604117_102 join tableDTS2019122604117_103 join tableDTS2019122604117_104 join tableDTS2019122604117_105 
join tableDTS2019122604117_106 join tableDTS2019122604117_107 join tableDTS2019122604117_108 join tableDTS2019122604117_109 join tableDTS2019122604117_110 join tableDTS2019122604117_111 join tableDTS2019122604117_112 
join tableDTS2019122604117_113 join tableDTS2019122604117_114 join tableDTS2019122604117_115 join tableDTS2019122604117_116 join tableDTS2019122604117_117 join tableDTS2019122604117_118 join tableDTS2019122604117_119 
join tableDTS2019122604117_120 join tableDTS2019122604117_121 join tableDTS2019122604117_122 join tableDTS2019122604117_123 join tableDTS2019122604117_124 join tableDTS2019122604117_125 join tableDTS2019122604117_126 
join tableDTS2019122604117_127 join tableDTS2019122604117_128)tableDTS202001171020010,(select  1 from tableDTS2019122604117_1 join tableDTS2019122604117_2 join tableDTS2019122604117_3 join tableDTS2019122604117_4 join tableDTS2019122604117_5 join tableDTS2019122604117_6 join tableDTS2019122604117_7 
join tableDTS2019122604117_8 join tableDTS2019122604117_9 join tableDTS2019122604117_10 join tableDTS2019122604117_11 join tableDTS2019122604117_12 join tableDTS2019122604117_13 join tableDTS2019122604117_14 
join tableDTS2019122604117_15 join tableDTS2019122604117_16 join tableDTS2019122604117_17 join tableDTS2019122604117_18 join tableDTS2019122604117_19 join tableDTS2019122604117_20 join tableDTS2019122604117_21 
join tableDTS2019122604117_22 join tableDTS2019122604117_23 join tableDTS2019122604117_24 join tableDTS2019122604117_25 join tableDTS2019122604117_26 join tableDTS2019122604117_27 join tableDTS2019122604117_28 
join tableDTS2019122604117_29 join tableDTS2019122604117_30 join tableDTS2019122604117_31 join tableDTS2019122604117_32 join tableDTS2019122604117_33 join tableDTS2019122604117_34 join tableDTS2019122604117_35 
join tableDTS2019122604117_36 join tableDTS2019122604117_37 join tableDTS2019122604117_38 join tableDTS2019122604117_39 join tableDTS2019122604117_40 join tableDTS2019122604117_41 join tableDTS2019122604117_42 
join tableDTS2019122604117_43 join tableDTS2019122604117_44 join tableDTS2019122604117_45 join tableDTS2019122604117_46 join tableDTS2019122604117_47 join tableDTS2019122604117_48 join tableDTS2019122604117_49 
join tableDTS2019122604117_50 join tableDTS2019122604117_51 join tableDTS2019122604117_52 join tableDTS2019122604117_53 join tableDTS2019122604117_54 join tableDTS2019122604117_55 join tableDTS2019122604117_56 
join tableDTS2019122604117_57 join tableDTS2019122604117_58 join tableDTS2019122604117_59 join tableDTS2019122604117_60 join tableDTS2019122604117_61 join tableDTS2019122604117_62 join tableDTS2019122604117_63 
join tableDTS2019122604117_64 join tableDTS2019122604117_65 join tableDTS2019122604117_66 join tableDTS2019122604117_67 join tableDTS2019122604117_68 join tableDTS2019122604117_69 join tableDTS2019122604117_70 
join tableDTS2019122604117_71 join tableDTS2019122604117_72 join tableDTS2019122604117_73 join tableDTS2019122604117_74 join tableDTS2019122604117_75 join tableDTS2019122604117_76 join tableDTS2019122604117_77 
join tableDTS2019122604117_78 join tableDTS2019122604117_79 join tableDTS2019122604117_80 join tableDTS2019122604117_81 join tableDTS2019122604117_82 join tableDTS2019122604117_83 join tableDTS2019122604117_84 
join tableDTS2019122604117_85 join tableDTS2019122604117_86 join tableDTS2019122604117_87 join tableDTS2019122604117_88 join tableDTS2019122604117_89 join tableDTS2019122604117_90 join tableDTS2019122604117_91 
join tableDTS2019122604117_92 join tableDTS2019122604117_93 join tableDTS2019122604117_94 join tableDTS2019122604117_95 join tableDTS2019122604117_96 join tableDTS2019122604117_97 join tableDTS2019122604117_98 
join tableDTS2019122604117_99 join tableDTS2019122604117_100 join tableDTS2019122604117_101 join tableDTS2019122604117_102 join tableDTS2019122604117_103 join tableDTS2019122604117_104 join tableDTS2019122604117_105 
join tableDTS2019122604117_106 join tableDTS2019122604117_107 join tableDTS2019122604117_108 join tableDTS2019122604117_109 join tableDTS2019122604117_110 join tableDTS2019122604117_111 join tableDTS2019122604117_112 
join tableDTS2019122604117_113 join tableDTS2019122604117_114 join tableDTS2019122604117_115 join tableDTS2019122604117_116 join tableDTS2019122604117_117 join tableDTS2019122604117_118 join tableDTS2019122604117_119 
join tableDTS2019122604117_120 join tableDTS2019122604117_121 join tableDTS2019122604117_122 join tableDTS2019122604117_123 join tableDTS2019122604117_124 join tableDTS2019122604117_125 join tableDTS2019122604117_126 
join tableDTS2019122604117_127 join tableDTS2019122604117_128)tableDTS202001171020011,(select  1 from tableDTS2019122604117_1 join tableDTS2019122604117_2 join tableDTS2019122604117_3 join tableDTS2019122604117_4 join tableDTS2019122604117_5 join tableDTS2019122604117_6 join tableDTS2019122604117_7 
join tableDTS2019122604117_8 join tableDTS2019122604117_9 join tableDTS2019122604117_10 join tableDTS2019122604117_11 join tableDTS2019122604117_12 join tableDTS2019122604117_13 join tableDTS2019122604117_14 
join tableDTS2019122604117_15 join tableDTS2019122604117_16 join tableDTS2019122604117_17 join tableDTS2019122604117_18 join tableDTS2019122604117_19 join tableDTS2019122604117_20 join tableDTS2019122604117_21 
join tableDTS2019122604117_22 join tableDTS2019122604117_23 join tableDTS2019122604117_24 join tableDTS2019122604117_25 join tableDTS2019122604117_26 join tableDTS2019122604117_27 join tableDTS2019122604117_28 
join tableDTS2019122604117_29 join tableDTS2019122604117_30 join tableDTS2019122604117_31 join tableDTS2019122604117_32 join tableDTS2019122604117_33 join tableDTS2019122604117_34 join tableDTS2019122604117_35 
join tableDTS2019122604117_36 join tableDTS2019122604117_37 join tableDTS2019122604117_38 join tableDTS2019122604117_39 join tableDTS2019122604117_40 join tableDTS2019122604117_41 join tableDTS2019122604117_42 
join tableDTS2019122604117_43 join tableDTS2019122604117_44 join tableDTS2019122604117_45 join tableDTS2019122604117_46 join tableDTS2019122604117_47 join tableDTS2019122604117_48 join tableDTS2019122604117_49 
join tableDTS2019122604117_50 join tableDTS2019122604117_51 join tableDTS2019122604117_52 join tableDTS2019122604117_53 join tableDTS2019122604117_54 join tableDTS2019122604117_55 join tableDTS2019122604117_56 
join tableDTS2019122604117_57 join tableDTS2019122604117_58 join tableDTS2019122604117_59 join tableDTS2019122604117_60 join tableDTS2019122604117_61 join tableDTS2019122604117_62 join tableDTS2019122604117_63 
join tableDTS2019122604117_64 join tableDTS2019122604117_65 join tableDTS2019122604117_66 join tableDTS2019122604117_67 join tableDTS2019122604117_68 join tableDTS2019122604117_69 join tableDTS2019122604117_70 
join tableDTS2019122604117_71 join tableDTS2019122604117_72 join tableDTS2019122604117_73 join tableDTS2019122604117_74 join tableDTS2019122604117_75 join tableDTS2019122604117_76 join tableDTS2019122604117_77 
join tableDTS2019122604117_78 join tableDTS2019122604117_79 join tableDTS2019122604117_80 join tableDTS2019122604117_81 join tableDTS2019122604117_82 join tableDTS2019122604117_83 join tableDTS2019122604117_84 
join tableDTS2019122604117_85 join tableDTS2019122604117_86 join tableDTS2019122604117_87 join tableDTS2019122604117_88 join tableDTS2019122604117_89 join tableDTS2019122604117_90 join tableDTS2019122604117_91 
join tableDTS2019122604117_92 join tableDTS2019122604117_93 join tableDTS2019122604117_94 join tableDTS2019122604117_95 join tableDTS2019122604117_96 join tableDTS2019122604117_97 join tableDTS2019122604117_98 
join tableDTS2019122604117_99 join tableDTS2019122604117_100 join tableDTS2019122604117_101 join tableDTS2019122604117_102 join tableDTS2019122604117_103 join tableDTS2019122604117_104 join tableDTS2019122604117_105 
join tableDTS2019122604117_106 join tableDTS2019122604117_107 join tableDTS2019122604117_108 join tableDTS2019122604117_109 join tableDTS2019122604117_110 join tableDTS2019122604117_111 join tableDTS2019122604117_112 
join tableDTS2019122604117_113 join tableDTS2019122604117_114 join tableDTS2019122604117_115 join tableDTS2019122604117_116 join tableDTS2019122604117_117 join tableDTS2019122604117_118 join tableDTS2019122604117_119 
join tableDTS2019122604117_120 join tableDTS2019122604117_121 join tableDTS2019122604117_122 join tableDTS2019122604117_123 join tableDTS2019122604117_124 join tableDTS2019122604117_125 join tableDTS2019122604117_126 
join tableDTS2019122604117_127 join tableDTS2019122604117_128)tableDTS202001171020012,(select  1 from tableDTS2019122604117_1 join tableDTS2019122604117_2 join tableDTS2019122604117_3 join tableDTS2019122604117_4 join tableDTS2019122604117_5 join tableDTS2019122604117_6 join tableDTS2019122604117_7 
join tableDTS2019122604117_8 join tableDTS2019122604117_9 join tableDTS2019122604117_10 join tableDTS2019122604117_11 join tableDTS2019122604117_12 join tableDTS2019122604117_13 join tableDTS2019122604117_14 
join tableDTS2019122604117_15 join tableDTS2019122604117_16 join tableDTS2019122604117_17 join tableDTS2019122604117_18 join tableDTS2019122604117_19 join tableDTS2019122604117_20 join tableDTS2019122604117_21 
join tableDTS2019122604117_22 join tableDTS2019122604117_23 join tableDTS2019122604117_24 join tableDTS2019122604117_25 join tableDTS2019122604117_26 join tableDTS2019122604117_27 join tableDTS2019122604117_28 
join tableDTS2019122604117_29 join tableDTS2019122604117_30 join tableDTS2019122604117_31 join tableDTS2019122604117_32 join tableDTS2019122604117_33 join tableDTS2019122604117_34 join tableDTS2019122604117_35 
join tableDTS2019122604117_36 join tableDTS2019122604117_37 join tableDTS2019122604117_38 join tableDTS2019122604117_39 join tableDTS2019122604117_40 join tableDTS2019122604117_41 join tableDTS2019122604117_42 
join tableDTS2019122604117_43 join tableDTS2019122604117_44 join tableDTS2019122604117_45 join tableDTS2019122604117_46 join tableDTS2019122604117_47 join tableDTS2019122604117_48 join tableDTS2019122604117_49 
join tableDTS2019122604117_50 join tableDTS2019122604117_51 join tableDTS2019122604117_52 join tableDTS2019122604117_53 join tableDTS2019122604117_54 join tableDTS2019122604117_55 join tableDTS2019122604117_56 
join tableDTS2019122604117_57 join tableDTS2019122604117_58 join tableDTS2019122604117_59 join tableDTS2019122604117_60 join tableDTS2019122604117_61 join tableDTS2019122604117_62 join tableDTS2019122604117_63 
join tableDTS2019122604117_64 join tableDTS2019122604117_65 join tableDTS2019122604117_66 join tableDTS2019122604117_67 join tableDTS2019122604117_68 join tableDTS2019122604117_69 join tableDTS2019122604117_70 
join tableDTS2019122604117_71 join tableDTS2019122604117_72 join tableDTS2019122604117_73 join tableDTS2019122604117_74 join tableDTS2019122604117_75 join tableDTS2019122604117_76 join tableDTS2019122604117_77 
join tableDTS2019122604117_78 join tableDTS2019122604117_79 join tableDTS2019122604117_80 join tableDTS2019122604117_81 join tableDTS2019122604117_82 join tableDTS2019122604117_83 join tableDTS2019122604117_84 
join tableDTS2019122604117_85 join tableDTS2019122604117_86 join tableDTS2019122604117_87 join tableDTS2019122604117_88 join tableDTS2019122604117_89 join tableDTS2019122604117_90 join tableDTS2019122604117_91 
join tableDTS2019122604117_92 join tableDTS2019122604117_93 join tableDTS2019122604117_94 join tableDTS2019122604117_95 join tableDTS2019122604117_96 join tableDTS2019122604117_97 join tableDTS2019122604117_98 
join tableDTS2019122604117_99 join tableDTS2019122604117_100 join tableDTS2019122604117_101 join tableDTS2019122604117_102 join tableDTS2019122604117_103 join tableDTS2019122604117_104 join tableDTS2019122604117_105 
join tableDTS2019122604117_106 join tableDTS2019122604117_107 join tableDTS2019122604117_108 join tableDTS2019122604117_109 join tableDTS2019122604117_110 join tableDTS2019122604117_111 join tableDTS2019122604117_112 
join tableDTS2019122604117_113 join tableDTS2019122604117_114 join tableDTS2019122604117_115 join tableDTS2019122604117_116 join tableDTS2019122604117_117 join tableDTS2019122604117_118 join tableDTS2019122604117_119 
join tableDTS2019122604117_120 join tableDTS2019122604117_121 join tableDTS2019122604117_122 join tableDTS2019122604117_123 join tableDTS2019122604117_124 join tableDTS2019122604117_125 join tableDTS2019122604117_126 
join tableDTS2019122604117_127 join tableDTS2019122604117_128)tableDTS202001171020013,(select  1 from tableDTS2019122604117_1 join tableDTS2019122604117_2 join tableDTS2019122604117_3 join tableDTS2019122604117_4 join tableDTS2019122604117_5 join tableDTS2019122604117_6 join tableDTS2019122604117_7 
join tableDTS2019122604117_8 join tableDTS2019122604117_9 join tableDTS2019122604117_10 join tableDTS2019122604117_11 join tableDTS2019122604117_12 join tableDTS2019122604117_13 join tableDTS2019122604117_14 
join tableDTS2019122604117_15 join tableDTS2019122604117_16 join tableDTS2019122604117_17 join tableDTS2019122604117_18 join tableDTS2019122604117_19 join tableDTS2019122604117_20 join tableDTS2019122604117_21 
join tableDTS2019122604117_22 join tableDTS2019122604117_23 join tableDTS2019122604117_24 join tableDTS2019122604117_25 join tableDTS2019122604117_26 join tableDTS2019122604117_27 join tableDTS2019122604117_28 
join tableDTS2019122604117_29 join tableDTS2019122604117_30 join tableDTS2019122604117_31 join tableDTS2019122604117_32 join tableDTS2019122604117_33 join tableDTS2019122604117_34 join tableDTS2019122604117_35 
join tableDTS2019122604117_36 join tableDTS2019122604117_37 join tableDTS2019122604117_38 join tableDTS2019122604117_39 join tableDTS2019122604117_40 join tableDTS2019122604117_41 join tableDTS2019122604117_42 
join tableDTS2019122604117_43 join tableDTS2019122604117_44 join tableDTS2019122604117_45 join tableDTS2019122604117_46 join tableDTS2019122604117_47 join tableDTS2019122604117_48 join tableDTS2019122604117_49 
join tableDTS2019122604117_50 join tableDTS2019122604117_51 join tableDTS2019122604117_52 join tableDTS2019122604117_53 join tableDTS2019122604117_54 join tableDTS2019122604117_55 join tableDTS2019122604117_56 
join tableDTS2019122604117_57 join tableDTS2019122604117_58 join tableDTS2019122604117_59 join tableDTS2019122604117_60 join tableDTS2019122604117_61 join tableDTS2019122604117_62 join tableDTS2019122604117_63 
join tableDTS2019122604117_64 join tableDTS2019122604117_65 join tableDTS2019122604117_66 join tableDTS2019122604117_67 join tableDTS2019122604117_68 join tableDTS2019122604117_69 join tableDTS2019122604117_70 
join tableDTS2019122604117_71 join tableDTS2019122604117_72 join tableDTS2019122604117_73 join tableDTS2019122604117_74 join tableDTS2019122604117_75 join tableDTS2019122604117_76 join tableDTS2019122604117_77 
join tableDTS2019122604117_78 join tableDTS2019122604117_79 join tableDTS2019122604117_80 join tableDTS2019122604117_81 join tableDTS2019122604117_82 join tableDTS2019122604117_83 join tableDTS2019122604117_84 
join tableDTS2019122604117_85 join tableDTS2019122604117_86 join tableDTS2019122604117_87 join tableDTS2019122604117_88 join tableDTS2019122604117_89 join tableDTS2019122604117_90 join tableDTS2019122604117_91 
join tableDTS2019122604117_92 join tableDTS2019122604117_93 join tableDTS2019122604117_94 join tableDTS2019122604117_95 join tableDTS2019122604117_96 join tableDTS2019122604117_97 join tableDTS2019122604117_98 
join tableDTS2019122604117_99 join tableDTS2019122604117_100 join tableDTS2019122604117_101 join tableDTS2019122604117_102 join tableDTS2019122604117_103 join tableDTS2019122604117_104 join tableDTS2019122604117_105 
join tableDTS2019122604117_106 join tableDTS2019122604117_107 join tableDTS2019122604117_108 join tableDTS2019122604117_109 join tableDTS2019122604117_110 join tableDTS2019122604117_111 join tableDTS2019122604117_112 
join tableDTS2019122604117_113 join tableDTS2019122604117_114 join tableDTS2019122604117_115 join tableDTS2019122604117_116 join tableDTS2019122604117_117 join tableDTS2019122604117_118 join tableDTS2019122604117_119 
join tableDTS2019122604117_120 join tableDTS2019122604117_121 join tableDTS2019122604117_122 join tableDTS2019122604117_123 join tableDTS2019122604117_124 join tableDTS2019122604117_125 join tableDTS2019122604117_126 
join tableDTS2019122604117_127 join tableDTS2019122604117_128)tableDTS202001171020014,(select  1 from tableDTS2019122604117_1 join tableDTS2019122604117_2 join tableDTS2019122604117_3 join tableDTS2019122604117_4 join tableDTS2019122604117_5 join tableDTS2019122604117_6 join tableDTS2019122604117_7 
join tableDTS2019122604117_8 join tableDTS2019122604117_9 join tableDTS2019122604117_10 join tableDTS2019122604117_11 join tableDTS2019122604117_12 join tableDTS2019122604117_13 join tableDTS2019122604117_14 
join tableDTS2019122604117_15 join tableDTS2019122604117_16 join tableDTS2019122604117_17 join tableDTS2019122604117_18 join tableDTS2019122604117_19 join tableDTS2019122604117_20 join tableDTS2019122604117_21 
join tableDTS2019122604117_22 join tableDTS2019122604117_23 join tableDTS2019122604117_24 join tableDTS2019122604117_25 join tableDTS2019122604117_26 join tableDTS2019122604117_27 join tableDTS2019122604117_28 
join tableDTS2019122604117_29 join tableDTS2019122604117_30 join tableDTS2019122604117_31 join tableDTS2019122604117_32 join tableDTS2019122604117_33 join tableDTS2019122604117_34 join tableDTS2019122604117_35 
join tableDTS2019122604117_36 join tableDTS2019122604117_37 join tableDTS2019122604117_38 join tableDTS2019122604117_39 join tableDTS2019122604117_40 join tableDTS2019122604117_41 join tableDTS2019122604117_42 
join tableDTS2019122604117_43 join tableDTS2019122604117_44 join tableDTS2019122604117_45 join tableDTS2019122604117_46 join tableDTS2019122604117_47 join tableDTS2019122604117_48 join tableDTS2019122604117_49 
join tableDTS2019122604117_50 join tableDTS2019122604117_51 join tableDTS2019122604117_52 join tableDTS2019122604117_53 join tableDTS2019122604117_54 join tableDTS2019122604117_55 join tableDTS2019122604117_56 
join tableDTS2019122604117_57 join tableDTS2019122604117_58 join tableDTS2019122604117_59 join tableDTS2019122604117_60 join tableDTS2019122604117_61 join tableDTS2019122604117_62 join tableDTS2019122604117_63 
join tableDTS2019122604117_64 join tableDTS2019122604117_65 join tableDTS2019122604117_66 join tableDTS2019122604117_67 join tableDTS2019122604117_68 join tableDTS2019122604117_69 join tableDTS2019122604117_70 
join tableDTS2019122604117_71 join tableDTS2019122604117_72 join tableDTS2019122604117_73 join tableDTS2019122604117_74 join tableDTS2019122604117_75 join tableDTS2019122604117_76 join tableDTS2019122604117_77 
join tableDTS2019122604117_78 join tableDTS2019122604117_79 join tableDTS2019122604117_80 join tableDTS2019122604117_81 join tableDTS2019122604117_82 join tableDTS2019122604117_83 join tableDTS2019122604117_84 
join tableDTS2019122604117_85 join tableDTS2019122604117_86 join tableDTS2019122604117_87 join tableDTS2019122604117_88 join tableDTS2019122604117_89 join tableDTS2019122604117_90 join tableDTS2019122604117_91 
join tableDTS2019122604117_92 join tableDTS2019122604117_93 join tableDTS2019122604117_94 join tableDTS2019122604117_95 join tableDTS2019122604117_96 join tableDTS2019122604117_97 join tableDTS2019122604117_98 
join tableDTS2019122604117_99 join tableDTS2019122604117_100 join tableDTS2019122604117_101 join tableDTS2019122604117_102 join tableDTS2019122604117_103 join tableDTS2019122604117_104 join tableDTS2019122604117_105 
join tableDTS2019122604117_106 join tableDTS2019122604117_107 join tableDTS2019122604117_108 join tableDTS2019122604117_109 join tableDTS2019122604117_110 join tableDTS2019122604117_111 join tableDTS2019122604117_112 
join tableDTS2019122604117_113 join tableDTS2019122604117_114 join tableDTS2019122604117_115 join tableDTS2019122604117_116 join tableDTS2019122604117_117 join tableDTS2019122604117_118 join tableDTS2019122604117_119 
join tableDTS2019122604117_120 join tableDTS2019122604117_121 join tableDTS2019122604117_122 join tableDTS2019122604117_123 join tableDTS2019122604117_124 join tableDTS2019122604117_125 join tableDTS2019122604117_126 
join tableDTS2019122604117_127 join tableDTS2019122604117_128)tableDTS202001171020015,(select  1 from tableDTS2019122604117_1 join tableDTS2019122604117_2 join tableDTS2019122604117_3 join tableDTS2019122604117_4 join tableDTS2019122604117_5 join tableDTS2019122604117_6 join tableDTS2019122604117_7 
join tableDTS2019122604117_8 join tableDTS2019122604117_9 join tableDTS2019122604117_10 join tableDTS2019122604117_11 join tableDTS2019122604117_12 join tableDTS2019122604117_13 join tableDTS2019122604117_14 
join tableDTS2019122604117_15 join tableDTS2019122604117_16 join tableDTS2019122604117_17 join tableDTS2019122604117_18 join tableDTS2019122604117_19 join tableDTS2019122604117_20 join tableDTS2019122604117_21 
join tableDTS2019122604117_22 join tableDTS2019122604117_23 join tableDTS2019122604117_24 join tableDTS2019122604117_25 join tableDTS2019122604117_26 join tableDTS2019122604117_27 join tableDTS2019122604117_28 
join tableDTS2019122604117_29 join tableDTS2019122604117_30 join tableDTS2019122604117_31 join tableDTS2019122604117_32 join tableDTS2019122604117_33 join tableDTS2019122604117_34 join tableDTS2019122604117_35 
join tableDTS2019122604117_36 join tableDTS2019122604117_37 join tableDTS2019122604117_38 join tableDTS2019122604117_39 join tableDTS2019122604117_40 join tableDTS2019122604117_41 join tableDTS2019122604117_42 
join tableDTS2019122604117_43 join tableDTS2019122604117_44 join tableDTS2019122604117_45 join tableDTS2019122604117_46 join tableDTS2019122604117_47 join tableDTS2019122604117_48 join tableDTS2019122604117_49 
join tableDTS2019122604117_50 join tableDTS2019122604117_51 join tableDTS2019122604117_52 join tableDTS2019122604117_53 join tableDTS2019122604117_54 join tableDTS2019122604117_55 join tableDTS2019122604117_56 
join tableDTS2019122604117_57 join tableDTS2019122604117_58 join tableDTS2019122604117_59 join tableDTS2019122604117_60 join tableDTS2019122604117_61 join tableDTS2019122604117_62 join tableDTS2019122604117_63 
join tableDTS2019122604117_64 join tableDTS2019122604117_65 join tableDTS2019122604117_66 join tableDTS2019122604117_67 join tableDTS2019122604117_68 join tableDTS2019122604117_69 join tableDTS2019122604117_70 
join tableDTS2019122604117_71 join tableDTS2019122604117_72 join tableDTS2019122604117_73 join tableDTS2019122604117_74 join tableDTS2019122604117_75 join tableDTS2019122604117_76 join tableDTS2019122604117_77 
join tableDTS2019122604117_78 join tableDTS2019122604117_79 join tableDTS2019122604117_80 join tableDTS2019122604117_81 join tableDTS2019122604117_82 join tableDTS2019122604117_83 join tableDTS2019122604117_84 
join tableDTS2019122604117_85 join tableDTS2019122604117_86 join tableDTS2019122604117_87 join tableDTS2019122604117_88 join tableDTS2019122604117_89 join tableDTS2019122604117_90 join tableDTS2019122604117_91 
join tableDTS2019122604117_92 join tableDTS2019122604117_93 join tableDTS2019122604117_94 join tableDTS2019122604117_95 join tableDTS2019122604117_96 join tableDTS2019122604117_97 join tableDTS2019122604117_98 
join tableDTS2019122604117_99 join tableDTS2019122604117_100 join tableDTS2019122604117_101 join tableDTS2019122604117_102 join tableDTS2019122604117_103 join tableDTS2019122604117_104 join tableDTS2019122604117_105 
join tableDTS2019122604117_106 join tableDTS2019122604117_107 join tableDTS2019122604117_108 join tableDTS2019122604117_109 join tableDTS2019122604117_110 join tableDTS2019122604117_111 join tableDTS2019122604117_112 
join tableDTS2019122604117_113 join tableDTS2019122604117_114 join tableDTS2019122604117_115 join tableDTS2019122604117_116 join tableDTS2019122604117_117 join tableDTS2019122604117_118 join tableDTS2019122604117_119 
join tableDTS2019122604117_120 join tableDTS2019122604117_121 join tableDTS2019122604117_122 join tableDTS2019122604117_123 join tableDTS2019122604117_124 join tableDTS2019122604117_125 join tableDTS2019122604117_126 
join tableDTS2019122604117_127 join tableDTS2019122604117_128)tableDTS202001171020016;
drop table tableDTS2019122604117_1;
drop table tableDTS2019122604117_2;
drop table tableDTS2019122604117_3;
drop table tableDTS2019122604117_4;
drop table tableDTS2019122604117_5;
drop table tableDTS2019122604117_6;
drop table tableDTS2019122604117_7;
drop table tableDTS2019122604117_8;
drop table tableDTS2019122604117_9;
drop table tableDTS2019122604117_10;
drop table tableDTS2019122604117_11;
drop table tableDTS2019122604117_12;
drop table tableDTS2019122604117_13;
drop table tableDTS2019122604117_14;
drop table tableDTS2019122604117_15;
drop table tableDTS2019122604117_16;
drop table tableDTS2019122604117_17;
drop table tableDTS2019122604117_18;
drop table tableDTS2019122604117_19;
drop table tableDTS2019122604117_20;
drop table tableDTS2019122604117_21;
drop table tableDTS2019122604117_22;
drop table tableDTS2019122604117_23;
drop table tableDTS2019122604117_24;
drop table tableDTS2019122604117_25;
drop table tableDTS2019122604117_26;
drop table tableDTS2019122604117_27;
drop table tableDTS2019122604117_28;
drop table tableDTS2019122604117_29;
drop table tableDTS2019122604117_30;
drop table tableDTS2019122604117_31;
drop table tableDTS2019122604117_32;
drop table tableDTS2019122604117_33;
drop table tableDTS2019122604117_34;
drop table tableDTS2019122604117_35;
drop table tableDTS2019122604117_36;
drop table tableDTS2019122604117_37;
drop table tableDTS2019122604117_38;
drop table tableDTS2019122604117_39;
drop table tableDTS2019122604117_40;
drop table tableDTS2019122604117_41;
drop table tableDTS2019122604117_42;
drop table tableDTS2019122604117_43;
drop table tableDTS2019122604117_44;
drop table tableDTS2019122604117_45;
drop table tableDTS2019122604117_46;
drop table tableDTS2019122604117_47;
drop table tableDTS2019122604117_48;
drop table tableDTS2019122604117_49;
drop table tableDTS2019122604117_50;
drop table tableDTS2019122604117_51;
drop table tableDTS2019122604117_52;
drop table tableDTS2019122604117_53;
drop table tableDTS2019122604117_54;
drop table tableDTS2019122604117_55;
drop table tableDTS2019122604117_56;
drop table tableDTS2019122604117_57;
drop table tableDTS2019122604117_58;
drop table tableDTS2019122604117_59;
drop table tableDTS2019122604117_60;
drop table tableDTS2019122604117_61;
drop table tableDTS2019122604117_62;
drop table tableDTS2019122604117_63;
drop table tableDTS2019122604117_64;
drop table tableDTS2019122604117_65;
drop table tableDTS2019122604117_66;
drop table tableDTS2019122604117_67;
drop table tableDTS2019122604117_68;
drop table tableDTS2019122604117_69;
drop table tableDTS2019122604117_70;
drop table tableDTS2019122604117_71;
drop table tableDTS2019122604117_72;
drop table tableDTS2019122604117_73;
drop table tableDTS2019122604117_74;
drop table tableDTS2019122604117_75;
drop table tableDTS2019122604117_76;
drop table tableDTS2019122604117_77;
drop table tableDTS2019122604117_78;
drop table tableDTS2019122604117_79;
drop table tableDTS2019122604117_80;
drop table tableDTS2019122604117_81;
drop table tableDTS2019122604117_82;
drop table tableDTS2019122604117_83;
drop table tableDTS2019122604117_84;
drop table tableDTS2019122604117_85;
drop table tableDTS2019122604117_86;
drop table tableDTS2019122604117_87;
drop table tableDTS2019122604117_88;
drop table tableDTS2019122604117_89;
drop table tableDTS2019122604117_90;
drop table tableDTS2019122604117_91;
drop table tableDTS2019122604117_92;
drop table tableDTS2019122604117_93;
drop table tableDTS2019122604117_94;
drop table tableDTS2019122604117_95;
drop table tableDTS2019122604117_96;
drop table tableDTS2019122604117_97;
drop table tableDTS2019122604117_98;
drop table tableDTS2019122604117_99;
drop table tableDTS2019122604117_100;
drop table tableDTS2019122604117_101;
drop table tableDTS2019122604117_102;
drop table tableDTS2019122604117_103;
drop table tableDTS2019122604117_104;
drop table tableDTS2019122604117_105;
drop table tableDTS2019122604117_106;
drop table tableDTS2019122604117_107;
drop table tableDTS2019122604117_108;
drop table tableDTS2019122604117_109;
drop table tableDTS2019122604117_110;
drop table tableDTS2019122604117_111;
drop table tableDTS2019122604117_112;
drop table tableDTS2019122604117_113;
drop table tableDTS2019122604117_114;
drop table tableDTS2019122604117_115;
drop table tableDTS2019122604117_116;
drop table tableDTS2019122604117_117;
drop table tableDTS2019122604117_118;
drop table tableDTS2019122604117_119;
drop table tableDTS2019122604117_120;
drop table tableDTS2019122604117_121;
drop table tableDTS2019122604117_122;
drop table tableDTS2019122604117_123;
drop table tableDTS2019122604117_124;
drop table tableDTS2019122604117_125;
drop table tableDTS2019122604117_126;
drop table tableDTS2019122604117_127;
drop table tableDTS2019122604117_128;
-- DTS2019012907740 : join condition table visible
drop table if exists t_join_base_001;

create table t_join_base_001(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(10),c_vchar2 varchar2(100),c_clob clob,
c_long clob,c_blob blob,c_raw raw(100),c_date date,c_timestamp timestamp)
PARTITION BY RANGE(id)
(
PARTITION id1 VALUES LESS than(10),
PARTITION id2 VALUES LESS than(100),
PARTITION id3 VALUES LESS than(1000),
PARTITION id4 VALUES LESS than(MAXVALUE)
);

SELECT COUNT(*)
FROM t_join_base_001 t1
	JOIN t_join_base_001 t2
	ON t1.id = t2.id
		AND EXISTS (
			SELECT t3.id
			FROM t_join_base_001
		)
	JOIN t_join_base_001 t3 ON t3.id = t2.id;
	
	
DROP TABLE IF EXISTS "T_D_BTSBRD_C2" CASCADE CONSTRAINTS;
CREATE TABLE "T_D_BTSBRD_C2"
(
  "SAVEPOINTID" BINARY_INTEGER NOT NULL,
  "OPERTYPE" BINARY_INTEGER NOT NULL,
  "PLANID" BINARY_INTEGER NOT NULL,
  "CMENEID" BINARY_INTEGER NOT NULL,
  "BTSID" BINARY_INTEGER NOT NULL,
  "CN" BINARY_INTEGER NOT NULL,
  "SRN" BINARY_INTEGER NOT NULL,
  "SN" BINARY_INTEGER NOT NULL,
  "BT" BINARY_INTEGER,
  "CABINETNO" BINARY_INTEGER,
  "ACTSTATUS" BINARY_INTEGER,
  "UCBOARDCATEGORY" BINARY_INTEGER,
  "UCBTSCARDSTATE" BINARY_INTEGER,
  "CARDFREATTR" BINARY_INTEGER,
  "BOARDNO" BINARY_INTEGER,
  "DEFAULTADDED" BINARY_INTEGER,
  "ACTSTATUSFORUPGRADE" BINARY_INTEGER,
  "SBT" BINARY_INTEGER,
  "BLKSTATUS" BINARY_INTEGER,
  "LOGUPTID" VARCHAR(383 BYTE),
  "NBI_RECID" BINARY_INTEGER,
  "ISGENMML" BINARY_INTEGER,
  PRIMARY KEY("PLANID", "CMENEID", "BTSID", "CN", "SRN", "SN", "OPERTYPE", "SAVEPOINTID")
)
INITRANS 2
MAXTRANS 255
PCTFREE 8;

DROP TABLE IF EXISTS "T_P_BTS_C2" CASCADE CONSTRAINTS;
CREATE TABLE "T_P_BTS_C2"
(
  "PLANID" BINARY_INTEGER NOT NULL,
  "CMENEID" BINARY_INTEGER NOT NULL,
  "BTSID" BINARY_INTEGER NOT NULL,
  "BTSNAME" VARCHAR(96 BYTE),
  "BTSTYPE" BINARY_INTEGER,
  "SEPERATEMODE" BINARY_INTEGER,
  "SERVICEMODE" BINARY_INTEGER,
  "FLEXABISMODE" BINARY_INTEGER,
  "ABISBYPASSMODE" BINARY_INTEGER,
  "ISCONFIGEDRING" BINARY_INTEGER,
  "MPMODE" BINARY_INTEGER,
  "ACTSTATUS" BINARY_INTEGER,
  "E1CONNREL" VARCHAR(27 BYTE),
  "FATHERSITEINDEX" BINARY_INTEGER,
  "ABISMODE" BINARY_INTEGER,
  "LOWERSITEID" BINARY_INTEGER,
  "WORKMODE" BINARY_INTEGER,
  "SITENOINHUB" BINARY_INTEGER,
  "UPOMLINPORTNO" BINARY_INTEGER,
  "UPOMLINTSNO" BINARY_INTEGER,
  "UPESLINPORTNO" BINARY_INTEGER,
  "UPESLINTSNO" BINARY_INTEGER,
  "TEI" BINARY_INTEGER,
  "OMLINHDLCINDEX" BINARY_INTEGER,
  "REVOMLINHDLCINDEX" BINARY_INTEGER,
  "OMLINHUBHDLCINDEX" BINARY_INTEGER,
  "OMLLOGICNO" BINARY_INTEGER,
  "REVOMLLOGICNO" BINARY_INTEGER,
  "CURE1INPORTNUM" NUMBER(17),
  "OBTAINDATAFLAG" BINARY_INTEGER,
  "BLKSTATUS" BINARY_INTEGER,
  "TSTURNINGOFFENABLE" BINARY_INTEGER,
  "BTSDESC" VARCHAR(96 BYTE),
  "MAINPORTNO" BINARY_INTEGER,
  "RESETBTSFLAG" BINARY_INTEGER,
  "MAINCTRLTRANBRDSYNFLAG" BINARY_INTEGER,
  "UPOMLOUTBSCSUBRACKNO" BINARY_INTEGER,
  "UPOMLOUTBSCSLOTNO" BINARY_INTEGER,
  "UPOMLOUTBSCE1PORTNO" BINARY_INTEGER,
  "UPOMLOUTBSCTSNO" BINARY_INTEGER,
  "NEWNAME" VARCHAR(96 BYTE),
  "HYBRIDGRPTAG" BINARY_INTEGER,
  "HYBRIDCABINETTYPE" VARCHAR(122 BYTE),
  "CTRLSRN" BINARY_INTEGER,
  "CTRLSN" BINARY_INTEGER,
  "CPUNO" BINARY_INTEGER,
  "REVINBTSPORTNO" BINARY_INTEGER,
  "REVINBTSTSNO" BINARY_INTEGER,
  "REVOUTBSCSUBRACKNO" BINARY_INTEGER,
  "REVOUTBSCSLOTNO" BINARY_INTEGER,
  "REVOUTBSCE1PORTNO" BINARY_INTEGER,
  "REVOUTBSCTSNO" BINARY_INTEGER,
  "TSPROPFLAG" BINARY_INTEGER,
  "TSASSIGNFLAG" BINARY_INTEGER,
  "MUTECHECKALLOWED" BINARY_INTEGER,
  "BACKUPUPESLINPORTNO" BINARY_INTEGER,
  "BACKUPUPESLINTSNO" BINARY_INTEGER,
  "BACKUPOUTBSCSUBRACKNO" BINARY_INTEGER,
  "BACKUPOUTBSCSLOTNO" BINARY_INTEGER,
  "BACKUPOUTBSCE1PORTNO" BINARY_INTEGER,
  "BACKUPOUTBSCTSNO" BINARY_INTEGER,
  "BACKUPHDLCINDEX" BINARY_INTEGER,
  "BACKUPHUBHDLCINDEX" BINARY_INTEGER,
  "BACKUPHDLCPIUINDEX" BINARY_INTEGER,
  "IPPHYTRANSTYPE" BINARY_INTEGER,
  "SRANMODE" BINARY_INTEGER,
  "CPUID" NUMBER(17),
  "FATHERDXXINDEX" BINARY_INTEGER,
  "SRANUPGRADEFLAG" BINARY_INTEGER,
  "RFUCFGBYSLOT" BINARY_INTEGER,
  "ACTSTATUSFORUPGRADE" BINARY_INTEGER,
  "SUPPORTDML" BINARY_INTEGER,
  "TSASSIGNOPTISW" BINARY_INTEGER,
  "TRANSRULE" BINARY_INTEGER,
  "MASTERTMUFLAG" BINARY_INTEGER,
  "BTS3012SRANMODE" BINARY_INTEGER,
  "MAINBMPMODE" BINARY_INTEGER,
  "RXUSERIESCAPACITY" BINARY_INTEGER,
  "INTRABBPOOLSWITCH" BINARY_INTEGER,
  "INNBBULICSHAEN" BINARY_INTEGER,
  "INNBBULICNUM" BINARY_INTEGER,
  "ISSUPPORTRFULOCGRP" BINARY_INTEGER,
  "TRANDETSWITCH" BINARY_INTEGER,
  "HOSTTYPE" BINARY_INTEGER,
  "LOCGRPCELLTYPE" BINARY_INTEGER,
  "SIGNALCREATETYPE" BINARY_INTEGER,
  "RSLLINKTYPE" BINARY_INTEGER,
  "CTRLSRNLAST" BINARY_INTEGER,
  "CTRLSNLAST" BINARY_INTEGER,
  "CPUNOLAST" BINARY_INTEGER,
  "HASCFGANTGRP" BINARY_INTEGER,
  "HASCFG4T4R" BINARY_INTEGER,
  "TSOFFSETGRP" BINARY_INTEGER,
  "ACTCELLLIST" VARCHAR(300 BYTE),
  "ACTTRXLIST" VARCHAR(1500 BYTE),
  "ACTTRXNAMELIST" CLOB,
  PRIMARY KEY("PLANID", "CMENEID", "BTSID")
)
INITRANS 2
MAXTRANS 255
PCTFREE 8;

DROP TABLE IF EXISTS "T_P_BTSCABINET_C2" CASCADE CONSTRAINTS;
CREATE TABLE "T_P_BTSCABINET_C2"
(
  "PLANID" BINARY_INTEGER NOT NULL,
  "CMENEID" BINARY_INTEGER NOT NULL,
  "CN" BINARY_INTEGER NOT NULL,
  "BTSID" BINARY_INTEGER NOT NULL,
  "TYPE" BINARY_INTEGER,
  "CABINETGRPNO" BINARY_INTEGER,
  "ACTSTATUS" BINARY_INTEGER,
  "DEFAULTADDED" BINARY_INTEGER,
  "CABINETDESC" VARCHAR(300 BYTE),
  "SRANMODE" BINARY_INTEGER,
  "ACTSTATUSFORUPGRADE" BINARY_INTEGER,
  "ISMAINCABINET" BINARY_INTEGER,
  "MAINCABINETSRN" BINARY_INTEGER,
  "ISFAKECABINET" BINARY_INTEGER,
  "BBUSUBRACKTYPE" BINARY_INTEGER,
  PRIMARY KEY("PLANID", "CMENEID", "CN", "BTSID")
)
INITRANS 2
MAXTRANS 255
PCTFREE 8;

DROP TABLE IF EXISTS "T_BSCBTS_TRXBOARDLST" CASCADE CONSTRAINTS;
CREATE TABLE "T_BSCBTS_TRXBOARDLST"
(
  "VERSION" VARCHAR(48 BYTE) NOT NULL,
  "BT" BINARY_INTEGER NOT NULL,
  "NAME" VARCHAR(96 BYTE),
  "CMEUID" BINARY_INTEGER NOT NULL,
  PRIMARY KEY("VERSION", "CMEUID")
)
INITRANS 2
MAXTRANS 255
PCTFREE 8;
CREATE INDEX "IDX_BSCBTS_TRXBOARDLST" ON "T_BSCBTS_TRXBOARDLST"("VERSION", "BT")
INITRANS 2
PCTFREE 8;

create global temporary table t_TEsp_Chk_DeleteBTSBRD_C21
as (
            select  distinct 'C2' as Version, a.PlanID, a.CMENEID, 'CMENEID:' || to_char(a.CMENEID) || ',BTSID:' || to_char(a.BTSID) || ',CN:' || to_char(a.CN) || ',SRN:' || to_char(a.SRN) || ',SN:' || to_char(a.SN) as MoID, 'BTSBRD' as MoName, 'GEN_CM_MML_SITE_MML_TRX_BOARD_CANNOT_DELETE_ERROR' as ErrInfo, b.BTSNAME as ErrPara, b.BTSTYPE, a.BT, q.CN
            , c.BT as BT_C from t_D_BTSBRD_C2 a
             join t_P_BTS_C2 b on a.PlanID = b.PlanID and a.CMENEID = b.CMENEID and a.BTSID = b.BTSID
             left join t_P_BTSCABINET_C2 q on a.PlanID = q.PlanID and a.CMENEID = q.CMENEID and a.BTSID = q.BTSID
                 and a.CN = q.CN
             left join t_BSCBTS_TRXBoardLst c on c.VERSION = 'C2' and a.BT = c.BT where 1 = 0
);

desc t_TEsp_Chk_DeleteBTSBRD_C21
DROP TABLE IF EXISTS t_TEsp_Chk_DeleteBTSBRD_C21;
DROP TABLE IF EXISTS "T_D_BTSBRD_C2" CASCADE CONSTRAINTS;
DROP TABLE IF EXISTS "T_P_BTS_C2" CASCADE CONSTRAINTS;
DROP TABLE IF EXISTS "T_P_BTSCABINET_C2" CASCADE CONSTRAINTS;
DROP TABLE IF EXISTS "T_BSCBTS_TRXBOARDLST" CASCADE CONSTRAINTS;

--DTS2020051406073
create or replace function json_arry(a int) return clob
as 
s1 clob;
s2 clob;
i int :=1;
begin
for i in 1..a loop
s1 := '"' || 'nice' || i || '"';
s2 := s2 || ',' || s1;
end loop;
--dbe_output.print_line(s2);

return s2;
end json_arry;
/
select right(cast(json_arry(2) as varchar(8000)),length(cast(json_arry(2) as varchar(8000))) -1);
select right(cast(json_arry(2) as varchar(8000)),15);

SELECT
  1
FROM
  ((SYS.SYS_TABLE_PARTS AS ref_0)
      FULL JOIN (SYS.DB_HISTOGRAMS AS ref_1 )
      ON (ref_0.AVGRLN = ref_1.ENDPOINT_VALUE ))
    INNER JOIN ((((SELECT
              (SELECT MAX(AUTO_COMMIT) FROM SYS.ADM_HIST_SESSION_SQL) AS C13
            FROM
              SYS.WSR_EXCEPTION_LOG AS ref_2) AS subq_1)
        FULL JOIN ((SYS.ADM_HIST_SQLAREA AS ref_6)
            LEFT JOIN (SYS.MY_IND_STATISTICS AS ref_11)
            ON (ref_6.IS_FREE <> ref_6.IS_FREE)
          )
        ON ( (false )))
      INNER JOIN (SYS.DV_ME AS ref_15)
      ON (ref_11.PARTITION_POSITION IS NOT NULL))
    ON ((true))
WHERE ref_6.CLEANED < subq_1.C13;

SELECT
  1
FROM
  ((SYS.SYS_TABLE_PARTS AS ref_0)
      FULL JOIN (SYS.DB_HISTOGRAMS AS ref_1 )
      ON (ref_0.AVGRLN = ref_1.ENDPOINT_VALUE ))
    INNER JOIN ((
        ((SYS.ADM_HIST_SQLAREA AS ref_6)
             inner JOIN (SYS.MY_IND_STATISTICS AS ref_11)
            ON (ref_6.IS_FREE <> ref_6.IS_FREE)
          ) full join ((SELECT
              (SELECT MAX(AUTO_COMMIT) FROM SYS.ADM_HIST_SESSION_SQL) AS C13
            FROM
              SYS.WSR_EXCEPTION_LOG AS ref_2) AS subq_1)
        ON ( (false )))
      INNER JOIN (SYS.DV_ME AS ref_15)
      ON (true))
    ON ((true))
WHERE subq_1.C13 is null;

-- parse error
drop table if exists parse_error;
create table parse_error(id number(8));
select *
from parse_error
    LEFT OUTER JOIN (
        (
            (parse_error AS REF_6)
            JOIN (parse_error AS REF_7) 
            ON (REF_6.id = REF_7.id)
        )
        RIGHT OUTER JOIN (parse_error AS REF_8) ON TRUE
    ) ON true;
    
-- package pending
drop table if exists dbe_diagnose_pending_t1;
drop table if exists dbe_diagnose_pending_t2;
create table dbe_diagnose_pending_t1
(
    id number(8),
    c_int number(10)
);
insert into dbe_diagnose_pending_t1 values(1,10);
commit;

create table dbe_diagnose_pending_t2
(
    id number(8),
    c_int number(10),
    c_tab_name varchar(50),
    c_index_name varchar(50),
    c_lob clob
)
partition by range(id)
(
    partition p1 values less than(10),
    partition p2 values less than(20),
    partition p3 values less than(MAXVALUE)
);
create index dbe_diagnose_pending_t2_idx on dbe_diagnose_pending_t2(c_int);

insert into dbe_diagnose_pending_t2 values(1, 10, 'dbe_diagnose_pending_t2', 'dbe_diagnose_pending_t2_idx', 'yyyy');
insert into dbe_diagnose_pending_t2 values(10, 20, 'dbe_diagnose_pending_t2', 'dbe_diagnose_pending_t2_idx', 'ssss');
insert into dbe_diagnose_pending_t2 values(20, 30, 'dbe_diagnose_pending_t2', 'dbe_diagnose_pending_t2_idx', 'dddd');
commit;

-- sql_func_partitioned_indsize pending
select 
  ref_0.c_int as c1
from 
    (dbe_diagnose_pending_t1 as ref_0)
    inner join (dbe_diagnose_pending_t2 as ref_1)
where dbe_diagnose.dba_partitioned_indsize(0, 'sys', ref_1.c_tab_name, ref_1.c_index_name) is not null;

-- sql_func_partitioned_lobsize pending
select 
  ref_0.c_int as c1
from 
    (dbe_diagnose_pending_t1 as ref_0)
    inner join (dbe_diagnose_pending_t2 as ref_1)
where dbe_diagnose.dba_partitioned_lobsize(0, 'sys', ref_1.c_tab_name) is not null;

-- sql_func_partitioned_tabsize pending
select 
  ref_0.c_int as c1
from 
    (dbe_diagnose_pending_t1 as ref_0)
    inner join (dbe_diagnose_pending_t2 as ref_1)
where dbe_diagnose.dba_partitioned_tabsize(0, 'sys', ref_1.c_tab_name) is not null;

-- sql_func_table_partsize pending
select 
  ref_0.c_int as c1
from 
    (dbe_diagnose_pending_t1 as ref_0)
    inner join (dbe_diagnose_pending_t2 as ref_1)
where dbe_diagnose.dba_table_partsize(0, 'sys', ref_1.c_tab_name, 'p1') is not null;

-- sql_func_table_size pending
select 
  ref_0.c_int as c1
from 
    (dbe_diagnose_pending_t1 as ref_0)
    inner join (dbe_diagnose_pending_t2 as ref_1)
where dbe_diagnose.dba_table_size(0, 'sys', ref_1.c_tab_name) is not null;

drop table dbe_diagnose_pending_t1;
drop table dbe_diagnose_pending_t2;

-- empty join testcases
drop table if exists empty_mix_join_t1;
drop table if exists empty_mix_join_t2;
drop table if exists empty_mix_join_t3;

create table empty_mix_join_t1(col_1 number(8), col_2 number(8), col_3 varchar(10));
create index empty_mix_join_t1_idx1 on empty_mix_join_t1(col_1);

create table empty_mix_join_t2(col_1 number(8), col_2 number(8), col_3 varchar(10));
create index empty_mix_join_t2_idx2 on empty_mix_join_t2(col_1);
insert into empty_mix_join_t2 values(1,2,'test_1');
insert into empty_mix_join_t2 values(2,4,'test_2');
insert into empty_mix_join_t2 values(3,6,'test_3');
commit;

create table empty_mix_join_t3(col_1 number(8), col_2 number(8), col_3 varchar(10));
create index empty_mix_join_t3_idx3 on empty_mix_join_t3(col_1);
insert into empty_mix_join_t3 values(1,2,'test_1');
insert into empty_mix_join_t3 values(2,4,'test_2');
insert into empty_mix_join_t3 values(3,8,'test_3');
insert into empty_mix_join_t3 values(4,16,'test_4');
commit;
-- NL + NL_FULL
select /*+rule*/ t1.col_3 from empty_mix_join_t2 t2 inner join (empty_mix_join_t3 t3 full join empty_mix_join_t1 t1 on 1 = 1) on t1.col_1 = t3.col_1;
-- NL_LEFT + NL_FULL
select /*+rule*/ t1.col_3 from (empty_mix_join_t1 t1 full join empty_mix_join_t2 t2 on t1.col_1 != t2.col_1) left join empty_mix_join_t3 t3 on t1.col_1 = t3.col_1;
select /*+rule*/ t1.col_3 from (empty_mix_join_t2 t2 full join empty_mix_join_t3 t3 on t2.col_1 != t3.col_1) left join empty_mix_join_t1 t1 on t1.col_1 = t2.col_1;
-- NL_FULL + NL
select /*+rule*/ t1.col_3 from (empty_mix_join_t2 t2 inner join empty_mix_join_t1 t1 on t1.col_1 = t2.col_1) full join empty_mix_join_t3 t3 on t2.col_1 != t3.col_1;
select /*+rule*/ t1.col_3 from empty_mix_join_t1 t1 full join (empty_mix_join_t2 t2 inner join empty_mix_join_t3 t3 on t2.col_1 = t3.col_1) on t1.col_1 != t2.col_1;
-- NL_FULL + NL_LEFT
select /*+rule*/ t1.col_3 from (empty_mix_join_t1 t1 left join empty_mix_join_t2 t2 on t1.col_1 = t2.col_1) full join empty_mix_join_t3 t3 on t1.col_1 != t3.col_1;
select /*+rule*/ t1.col_3 from (empty_mix_join_t2 t2 left join empty_mix_join_t1 t1 on t1.col_1 = t2.col_1) full join empty_mix_join_t3 t3 on t2.col_1 != t3.col_1;
select /*+rule*/ t1.col_3 from empty_mix_join_t1 t1 full join (empty_mix_join_t2 t2 left join empty_mix_join_t3 t3 on t2.col_1 = t3.col_1) on t1.col_1 != t2.col_1;
select /*+rule*/ t1.col_3 from empty_mix_join_t2 t2 full join (empty_mix_join_t3 t3 left join empty_mix_join_t1 t1 on t1.col_1 = t3.col_1) on t2.col_1 != t3.col_1;
-- NL_FULL + NL_FULL
select /*+rule*/ t1.col_3 from (empty_mix_join_t1 t1 full join empty_mix_join_t2 t2 on t1.col_1 != t2.col_1) full join empty_mix_join_t3 t3 on t1.col_1 != t3.col_1;
select /*+rule*/ t1.col_3 from (empty_mix_join_t2 t2 full join empty_mix_join_t1 t1 on t1.col_1 != t2.col_1) full join empty_mix_join_t3 t3 on t2.col_1 != t3.col_1;
select /*+rule*/ t1.col_3 from (empty_mix_join_t2 t2 full join empty_mix_join_t3 t3 on t2.col_1 != t3.col_1) full join empty_mix_join_t1 t1 on t1.col_1 != t2.col_1;
select /*+rule*/ t1.col_3 from empty_mix_join_t1 t1 full join (empty_mix_join_t2 t2 full join empty_mix_join_t3 t3 on t2.col_1 != t3.col_1) on t1.col_1 != t2.col_1;
select /*+rule*/ t1.col_3 from empty_mix_join_t2 t2 full join (empty_mix_join_t1 t1 full join empty_mix_join_t3 t3 on t1.col_1 != t3.col_1) on t1.col_1 != t2.col_1;
select /*+rule*/ t1.col_3 from empty_mix_join_t2 t2 full join (empty_mix_join_t3 t3 full join empty_mix_join_t1 t1 on t1.col_1 != t3.col_1) on t2.col_1 != t3.col_1;
-- NL_FULL + HASH
select /*+rule*/ t1.col_3 from (empty_mix_join_t1 t1 inner join empty_mix_join_t2 t2 on t1.col_2 = t2.col_2) full join empty_mix_join_t3 t3 on t2.col_1 != t3.col_1;
select /*+rule*/ t1.col_3 from (empty_mix_join_t2 t2 inner join empty_mix_join_t1 t1 on t1.col_2 = t2.col_2) full join empty_mix_join_t3 t3 on t2.col_1 != t3.col_1;
-- NL_FULL + HASH_LEFT
select /*+rule*/ t1.col_3 from (empty_mix_join_t1 t1 left join empty_mix_join_t2 t2 on t1.col_2 = t2.col_2) full join empty_mix_join_t3 t3 on t2.col_1 != t3.col_1;
select /*+rule*/ t1.col_3 from (empty_mix_join_t2 t2 left join empty_mix_join_t1 t1 on t1.col_2 = t2.col_2) full join empty_mix_join_t3 t3 on t2.col_1 != t3.col_1;
select /*+rule*/ t1.col_3 from empty_mix_join_t1 t1 full join (empty_mix_join_t2 t2 left join empty_mix_join_t3 t3 on t2.col_2 = t3.col_2) on t1.col_1 != t2.col_1;
select /*+rule*/ t1.col_3 from empty_mix_join_t2 t2 full join (empty_mix_join_t3 t3 left join empty_mix_join_t1 t1 on t1.col_2 = t3.col_2) on t2.col_1 != t3.col_1;
-- HASH_LEFT + NL_FULL
select /*+rule*/ t1.col_3 from (empty_mix_join_t1 t1 full join empty_mix_join_t2 t2 on t1.col_1 != t2.col_1) left join empty_mix_join_t3 t3 on t1.col_2 = t3.col_2;
select /*+rule*/ t1.col_3 from (empty_mix_join_t2 t2 full join empty_mix_join_t3 t3 on t2.col_1 != t3.col_1) left join empty_mix_join_t1 t1 on t1.col_2 = t2.col_2;
-- HASH_SEMI + NL_FULL
select /*+rule*/ t1.col_3 from (empty_mix_join_t1 t1 full join empty_mix_join_t3 t3 on t1.col_1 != t3.col_1) where exists(select * from empty_mix_join_t2 t2);
-- HASH_ANTI + NL_FULL
select /*+rule*/ t2.col_3 from (empty_mix_join_t2 t2 full join empty_mix_join_t3 t3 on t2.col_1 != t3.col_1) where not exists(select * from empty_mix_join_t1 t1);
-- HASH_FULL + NL
select /*+rule*/ t1.col_3 from empty_mix_join_t2 t2 full join (empty_mix_join_t1 t1 inner join empty_mix_join_t3 t3 on t1.col_1 = t3.col_1) on t1.col_2 = t2.col_2;
-- HASH_FULL + MERGE_JOIN
select /*+rule*/ t1.col_3 from empty_mix_join_t2 t2 full join (empty_mix_join_t1 t1 inner join empty_mix_join_t3 t3 on t1.col_2 > t3.col_2) on t1.col_2 = t2.col_2;
select /*+rule*/ t1.col_3 from empty_mix_join_t2 t2 full join (empty_mix_join_t3 t3 inner join empty_mix_join_t1 t1 on t1.col_2 > t3.col_2) on t1.col_2 = t2.col_2;
-- NL_FULL + NL
select /*+rule*/ t1.col_3 from (empty_mix_join_t1 t1 inner join empty_mix_join_t2 t2 on t1.col_1 = t2.col_1) full join empty_mix_join_t3 t3 on t2.col_1 != t3.col_1;
-- NL_FULL + MERGE_JOIN
select /*+rule*/ t1.col_3 from (empty_mix_join_t1 t1 inner join empty_mix_join_t2 t2 on t1.col_2 > t2.col_2) full join empty_mix_join_t3 t3 on t2.col_1 != t3.col_1;
select /*+rule*/ t1.col_3 from (empty_mix_join_t2 t2 inner join empty_mix_join_t1 t1 on t1.col_2 > t2.col_2) full join empty_mix_join_t3 t3 on t2.col_1 != t3.col_1;

drop table empty_mix_join_t1;
drop table empty_mix_join_t2;
drop table empty_mix_join_t3;

DROP TABLE IF EXISTS "T_DBLINK_001";
CREATE TABLE "T_DBLINK_001"
(
  "COL_10" CHAR(30 BYTE),
  "COL_16" TIMESTAMP(6),
  "COL_18" TIMESTAMP(6) WITH LOCAL TIME ZONE
);
DROP TABLE IF EXISTS "HASH_CSF_TABLE_001";
CREATE TABLE "HASH_CSF_TABLE_001"
(
  "C_FIRST" VARCHAR(16 BYTE) NOT NULL,
  "C_STREET_1" VARCHAR(20 BYTE) NOT NULL,
  "C_STREET_2" VARCHAR(20 BYTE),
  "C_START" DATE NOT NULL,
  "C_YTD_PAYMENT" BINARY_DOUBLE NOT NULL,
  "C_END" DATE NOT NULL
);
DROP TABLE IF EXISTS "SP_OUT_PARAM_INSTANCE_HIS";
CREATE TABLE "SP_OUT_PARAM_INSTANCE_HIS"
(
  "SEQ_ID" NUMBER(20) NOT NULL
);
INSERT INTO "T_DBLINK_001" values('@@@@@@@abc                    ','2019-01-03 14:58:54.000000','2019-08-18 15:36:00.000000');
INSERT INTO "T_DBLINK_001" values('@@@@@@@abc                    ','2019-01-03 14:58:54.000000','2019-08-19 15:36:00.000000');
INSERT INTO "T_DBLINK_001" values('@@@@@@@abc                    ','2019-01-03 14:58:54.000000','2019-08-20 15:36:00.000000');
INSERT INTO "T_DBLINK_001" values('@@@@@@@abc                    ','2019-01-03 14:58:54.000000','2019-08-21 15:36:00.000000');
INSERT INTO "T_DBLINK_001" values('@@@@@@@abc                    ','2019-01-03 14:58:54.000000','2019-08-18 15:36:00.000000');
INSERT INTO "T_DBLINK_001" values('@@@@@@@abc                    ','2019-01-03 14:58:54.000000','2019-08-19 15:36:00.000000');
INSERT INTO "T_DBLINK_001" values('@@@@@@@abc                    ','2019-01-03 14:58:54.000000','2019-08-20 15:36:00.000000');
INSERT INTO "T_DBLINK_001" values('@@@@@@@abc                    ','2019-01-03 14:58:54.000000','2019-08-21 15:36:00.000000');
INSERT INTO "T_DBLINK_001" values('@@@@@@@abc                    ','2019-01-03 14:58:54.000000','2019-08-18 15:36:00.000000');
INSERT INTO "T_DBLINK_001" values('@@@@@@@abc                    ','2019-01-03 14:58:54.000000','2019-08-19 15:36:00.000000');
INSERT INTO "T_DBLINK_001" values('@@@@@@@abc                    ','2019-01-03 14:58:54.000000','2019-08-20 15:36:00.000000');
INSERT INTO "T_DBLINK_001" values('@@@@@@@abc                    ','2019-01-03 14:58:54.000000','2019-08-21 15:36:00.000000');
INSERT INTO "T_DBLINK_001" values('@@@@@@@abc                    ','2019-01-03 14:58:54.000000','2019-08-18 15:36:00.000000');
INSERT INTO "T_DBLINK_001" values('@@@@@@@abc                    ','2019-01-03 14:58:54.000000','2019-08-19 15:36:00.000000');
INSERT INTO "T_DBLINK_001" values('@@@@@@@abc                    ','2019-01-03 14:58:54.000000','2019-08-20 15:36:00.000000');
INSERT INTO "T_DBLINK_001" values('@@@@@@@abc                    ','2019-01-03 14:58:54.000000','2019-08-21 15:36:00.000000');
declare
i int;
begin
 i := 1;
loop
 insert into HASH_CSF_TABLE_001 values('iscmRDs83aa','RGF1AB','RGF3ABC','2018-01-03 10:51:47',i,'2018-01-03 10:51:47');
i := i+1;
 exit when i>800;
end loop;
 commit;
 end;
/
INSERT INTO "SP_OUT_PARAM_INSTANCE_HIS" values(6689837152733186);
COMMIT;

alter system set HASH_AREA_SIZE = 0;
SELECT 
  REF_0.NEWCOL_1 AS C1
  FROM((HASH_CSF_TABLE_001 UNPIVOT ((NEWCOL_0, NEWCOL_1, NEWCOL_2)
  FOR (FORCOL_0)
  IN ((C_YTD_PAYMENT, C_START, C_STREET_2) AS ('UNPIVOT_VALUE_0'), (C_YTD_PAYMENT, C_END, C_STREET_1), (C_YTD_PAYMENT, C_START, C_STREET_1), (C_YTD_PAYMENT, C_START, C_STREET_2) AS ('UNPIVOT_VALUE_0'), (C_YTD_PAYMENT, C_END, C_STREET_2), (C_YTD_PAYMENT, C_END, C_STREET_1))) AS REF_0) 
  FULL OUTER JOIN(SP_OUT_PARAM_INSTANCE_HIS AS REF_1) 
  ON(TRUE)) 
  RIGHT JOIN(T_DBLINK_001 UNPIVOT INCLUDE NULLS ((NEWCOL_0, NEWCOL_1)
  FOR (FORCOL_0, FORCOL_1, FORCOL_2)
  IN ((COL_18, COL_16) AS ('UNPIVOT_VALUE_0', 'UNPIVOT_VALUE_1', 'UNPIVOT_VALUE_2'))) AS REF_2) 
  ON(REF_0.C_FIRST = REF_2.COL_10);
alter system set HASH_AREA_SIZE = 4M;
DROP TABLE "T_DBLINK_001";
DROP TABLE "HASH_CSF_TABLE_001";
DROP TABLE "SP_OUT_PARAM_INSTANCE_HIS";