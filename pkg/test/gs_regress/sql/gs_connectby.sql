DROP TABLE IF EXISTS T_CONNECTBY_1;
DROP TABLE IF EXISTS T_CONNECTBY_2;
DROP TABLE IF EXISTS T_CONNECTBY_3;
CREATE TABLE T_CONNECTBY_1 (F_INT1 INT, F_INT2 INT, F_CHAR CHAR(16), F_DATE DATE);
CREATE TABLE T_CONNECTBY_2 (F_INT1 INT, F_INT2 INT, F_CHAR CHAR(16), F_DATE DATE);
CREATE TABLE T_CONNECTBY_3 (F_INT1 INT, F_INT2 INT, F_CHAR CHAR(16), F_DATE DATE);

--ERROR
select f_int1, f_int2, f_char, level  from T_CONNECTBY_1;
select f_int1, f_int2, f_char, connect_by_isleaf from T_CONNECTBY_1;
select f_int1, f_int2, f_char, connect_by_iscycle from T_CONNECTBY_1;
select f_int1, f_int2, f_char, connect_by_iscycle from T_CONNECTBY_1 connect by prior f_int2 = f_int1;
select f_int1 from T_CONNECTBY_1 where prior f_int1 = 1;
select f_int1 from T_CONNECTBY_1 group by f_int1 having prior f_int1 = 1;
select f_int1, f_int2, f_char, level, connect_by_isleaf, connect_by_iscycle from T_CONNECTBY_1 start with f_char = 'A';
select f_int1, f_int2, f_char, level, connect_by_isleaf, connect_by_iscycle from T_CONNECTBY_1 start with prior f_char = 'A' connect by nocycle prior f_int2 = f_int1 and f_date = prior f_date;

--EMPTY RECORD
select f_int1, f_int2, f_char, level, connect_by_isleaf, connect_by_iscycle from T_CONNECTBY_1 start with f_char = 'A' connect by nocycle prior f_int2 = f_int1 and f_date = prior f_date;
select T_CONNECTBY_1.F_INT1,T_CONNECTBY_1.F_INT2 from T_CONNECTBY_1,T_CONNECTBY_2,T_CONNECTBY_3 where T_CONNECTBY_1.F_INT1 in (T_CONNECTBY_2.F_INT1,T_CONNECTBY_2.F_INT1) connect by T_CONNECTBY_1.F_INT1 = T_CONNECTBY_1.F_INT2;

INSERT INTO T_CONNECTBY_1 VALUES(1,2,'A','2018-01-11 14:08:00');
INSERT INTO T_CONNECTBY_1 VALUES(2,3,'B','2018-01-11 14:08:00');
INSERT INTO T_CONNECTBY_1 VALUES(3,2,'C','2018-01-11 14:08:00');
INSERT INTO T_CONNECTBY_1 VALUES(3,1,'D','2018-01-11 14:08:00');
INSERT INTO T_CONNECTBY_1 VALUES(1,6,'E','2018-01-11 14:08:00');
COMMIT;


--ERROR
select f_int1, f_int2, f_char, level, connect_by_isleaf, connect_by_iscycle from T_CONNECTBY_1 start with f_char = 'A' connect by prior f_int2 = f_int1;


select f_int1, f_int2, f_char, level, connect_by_isleaf from T_CONNECTBY_1 start with f_char = 'A' connect by nocycle prior f_int2 = f_int1 and f_date = prior f_date;
select f_int1, f_int2, f_char, level, connect_by_isleaf,rownum from T_CONNECTBY_1 where rownum < 3 start with f_char = 'A' connect by nocycle prior f_int2 = f_int1 and f_date = prior f_date;
select f_int1, f_int2, f_char, level, connect_by_isleaf, connect_by_iscycle from T_CONNECTBY_1 start with f_char = 'A' connect by nocycle prior f_int2 = f_int1 and f_date = prior f_date;
select level, connect_by_isleaf, connect_by_iscycle,f_int1, f_int2, f_char  from T_CONNECTBY_1 start with f_char = 'A' connect by nocycle prior f_int2 = f_int1 and f_date = prior f_date;

select f_int1, f_int2, f_char, level, connect_by_isleaf, connect_by_iscycle from T_CONNECTBY_1 where f_int1 = 1 start with f_char = 'A' connect by nocycle prior f_int2 = f_int1;
select f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle from T_CONNECTBY_1 connect by nocycle prior f_int2 = f_int1 order by f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle;
select f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle from T_CONNECTBY_1 connect by nocycle prior f_int2 = f_int1 and level < 3 order by f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle;
select f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle from T_CONNECTBY_1 where f_int2 > 2 connect by nocycle prior f_int2 = f_int1 order by f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle;
select distinct f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle from T_CONNECTBY_1 connect by nocycle prior f_int2 = f_int1;
select f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle from T_CONNECTBY_1 connect by nocycle prior f_int2 = f_int1 group by f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle order by 1,2,3,4,5,6;
select f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle from T_CONNECTBY_1 connect by nocycle prior f_int2 = f_int1 group by f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle order by f_int1 desc, f_int2, f_char, level, connect_by_isleaf, connect_by_iscycle;
select f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle from T_CONNECTBY_1 connect by nocycle prior f_int2 = f_int1 group by f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle order by connect_by_iscycle,f_int1 desc, f_int2, f_char, level, connect_by_isleaf;
select f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle from T_CONNECTBY_1 connect by nocycle prior f_int2 = f_int1 start with f_char = 'A' or f_char = 'B' or f_char= 'C' group by f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle order by connect_by_iscycle,f_int1 desc, f_int2, f_char, level, connect_by_isleaf;
select f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle from T_CONNECTBY_1 connect by nocycle prior f_int2 = f_int1 start with f_char = 'A' or f_char = 'B' or f_char= 'C' group by f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle order by connect_by_iscycle,f_int1 desc, f_int2, f_char, level, connect_by_isleaf limit 2,2;
select f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle from T_CONNECTBY_1 where f_int1 > 1 connect by nocycle prior f_int2 = f_int1 start with f_char = 'A' or f_char = 'B' or f_char= 'C' group by f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle order by connect_by_iscycle,f_int1 desc, f_int2, f_char, level, connect_by_isleaf;

(select f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle from T_CONNECTBY_1 where f_int1 = 1 start with  f_char = 'A' connect by nocycle prior f_int2 = f_int1) union all (select f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle from T_CONNECTBY_1 start with  f_char = 'B' connect by nocycle prior f_int2 = f_int1) order by f_int2,f_char,level;
(select f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle from T_CONNECTBY_1 where f_int1 = 1 start with  f_char = 'A' connect by nocycle prior f_int2 = f_int1) union (select f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle from T_CONNECTBY_1 start with  f_char = 'A' connect by nocycle prior f_int2 = f_int1) order by f_int2,f_char,level;
(select f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle from T_CONNECTBY_1 where f_int1 = 1 start with  f_char = 'A' connect by nocycle prior f_int2 = f_int1) union all (select f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle from T_CONNECTBY_1 start with  f_char = 'B' connect by nocycle prior f_int2 = f_int1) order by f_int2,f_char,level limit 1,1;
(select f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle from T_CONNECTBY_1 where f_int1 = 1 start with  f_char = 'A' connect by nocycle prior f_int2 = f_int1) union (select f_int1,f_int2,f_char,level,connect_by_isleaf,connect_by_iscycle from T_CONNECTBY_1 start with  f_char = 'A' connect by nocycle prior f_int2 = f_int1) order by f_int2,f_char,level limit 1,1;

select A.f_int1, A.f_int2, A.f_char,B.f_int1, B.f_int2, B.f_char,level,connect_by_isleaf,connect_by_iscycle from T_CONNECTBY_1 A inner join T_CONNECTBY_1 B on A.F_INT1 = B.F_INT1 start with A.f_char = 'A' connect by nocycle prior A.f_int2 = A.f_int1 order by level, connect_by_isleaf, connect_by_iscycle, B.f_char;
select A.f_int1, A.f_int2, A.f_char from T_CONNECTBY_1 A, T_CONNECTBY_1 B where A.F_INT1 = B.F_INT1 AND A.f_int1 = 1 start with A.f_char = 'A' connect by nocycle prior A.f_int2 = A.f_int1;
select A.f_int1, A.f_int2, A.f_char from T_CONNECTBY_1 A inner join T_CONNECTBY_1 B on A.F_INT1 = B.F_INT1 where A.f_int1 = 1 start with A.f_char = 'A' connect by nocycle prior A.f_int2 = A.f_int1;
select A.f_int1, A.f_int2, A.f_char from T_CONNECTBY_1 A inner join T_CONNECTBY_1 B on A.F_INT1 = B.F_INT1 where A.f_int1 = 1 and rownum < 2 start with A.f_char = 'A' connect by nocycle prior A.f_int2 = A.f_int1;
select A.f_int1, A.f_int2, A.f_char from T_CONNECTBY_1 A inner join T_CONNECTBY_1 B on A.F_INT1 = B.F_INT1 where A.f_int1 = 1 start with A.f_char = 'A' connect by nocycle prior A.f_int2 = B.f_int1;

(select A.f_int1 AS F1, A.f_int2 AS F2, A.f_char AS F3 from T_CONNECTBY_1 A inner join T_CONNECTBY_1 B on A.F_INT1 = B.F_INT1 where A.f_int1 = 1 start with A.f_char = 'A' connect by nocycle prior A.f_int2 = A.f_int1) union (select A.f_int1, A.f_int2, A.f_char from T_CONNECTBY_1 A inner join T_CONNECTBY_1 B on A.F_INT1 = B.F_INT1 where A.f_int1 = 1 start with A.f_char = 'A' connect by nocycle prior A.f_int2 = A.f_int1) order by F1,F2,F3;
(select A.f_int1 AS F1, A.f_int2 AS F2, A.f_char AS F3 from T_CONNECTBY_1 A inner join T_CONNECTBY_1 B on A.F_INT1 = B.F_INT1 where A.f_int1 = 1 start with A.f_char = 'A' connect by nocycle prior A.f_int2 = A.f_int1) union all (select A.f_int1, A.f_int2, A.f_char from T_CONNECTBY_1 A inner join T_CONNECTBY_1 B on A.F_INT1 = B.F_INT1 where A.f_int1 = 1 start with A.f_char = 'A' connect by nocycle prior A.f_int2 = A.f_int1) order by F1,F2,F3;

--TEST EXCLUDE PRIOR
select f_char,level from T_CONNECTBY_1 connect by level < 1 order by f_char,level;
select f_char,level from T_CONNECTBY_1 connect by level < 2 order by f_char,level;
select f_char,level from T_CONNECTBY_1 connect by level < 3 order by f_char,level;
select f_char,level,connect_by_isleaf,connect_by_iscycle from T_CONNECTBY_1 connect by nocycle level < 3 order by f_char,level;

select level from dual where level > 250 connect by level <= 257;
select level from dual where level > 250 connect by level <= 256;

--TEST SEQ
create sequence seq_connect_by minvalue 1 maxvalue 256 start with 1 increment by 1;
select seq_connect_by.nextval  from dual connect by level < 10;
drop sequence seq_connect_by;

update T_CONNECTBY_1 set f_int1 = connect_by_iscycle;
update T_CONNECTBY_1 set f_int1 = connect_by_isleaf;

--the test case is right in oracle 12c, but it is wrong in oracle 11g
DELETE FROM T_CONNECTBY_1;
insert into T_CONNECTBY_1 values (1, 0, 'A', '2018-01-11 14:08:00');
insert into T_CONNECTBY_1 values (2, 1, 'AA', '2018-01-11 14:08:00');
SELECT * FROM T_CONNECTBY_1 t, (SELECT F_INT2 FROM T_CONNECTBY_1) t1 START WITH t.f_int2 = 0 CONNECT BY PRIOR t.f_int1 = t.f_int2 order by t.f_int1,t.f_int2,t.f_char,t1.f_int2;
commit;

-------------------------------------------------------------------------
--------------------------  CONNECT_BY_ROOT  ----------------------------
-------------------------------------------------------------------------
-- CONNECT_BY_ROOT USAGE��o
-- 1. Unary operator, only used in connect by statment
-- 2. Cannot used in TART WITH, CONNECT BY condition
-- 3. Nest usage should not allowed later
-- 4. Reference: https://docs.oracle.com/cd/B19306_01/server.102/b14200/operators004.htm#i1035022   
-------------------------------------------------------------------------
create table t (
    id   int,
    des  varchar(10),
    pid  int
);   
create index idx_t_pid on t (pid);
truncate table t;
insert into t values (1, 'A', 0);
insert into t values (2, 'AA', 1);
insert into t values (3, 'AAA', 2);
insert into t values (4, 'AAAA', 3);
commit;   

----------------------------------------------------
-- case 1
--   1. unary operator, only used in connect by statment
--   2. Cannot used in TART WITH, CONNECT BY condition
----------------------------------------------------
SELECT CONNECT_BY_ROOT 1 FROM t;

SELECT abs(CONNECT_BY_ROOT 1) FROM t;

SELECT 1 FROM t where abs(CONNECT_BY_ROOT 1) > 1;

SELECT 1 FROM t group by abs(CONNECT_BY_ROOT 1);

SELECT 
    *
FROM t
START WITH CONNECT_BY_ROOT pid = 0
CONNECT BY pid = PRIOR id; 

SELECT 
    *
FROM t
START WITH pid = 0
CONNECT BY CONNECT_BY_ROOT pid = id; 

SELECT
    CONNECT_BY_ROOT c
FROM
(
    SELECT 
        CONNECT_BY_ROOT pid c
    FROM t
    START WITH pid = 0
    CONNECT BY PRIOR id = pid
) t1;

SELECT 
    (RPAD(' ', 2*(LEVEL-1), '  ' ) || des) des_tree 
    , LEVEL
    , id
    , pid
    , nvl(CONNECT_BY_ROOT NULL, 'NULL')    TEST1
    , CONNECT_BY_ROOT 1                    TEST2
    , CONNECT_BY_ROOT 1 + id               TEST3
    , CONNECT_BY_ROOT id                   TEST4
    , CONNECT_BY_ROOT id + 1               TEST5
    , CONNECT_BY_ROOT abs(id + pid + 1)    TEST6
    , CONNECT_BY_ROOT abs(id) + pid + 1    TEST7
    , abs(CONNECT_BY_ROOT id + pid + 1)    TEST8
    , abs(CONNECT_BY_ROOT (id + pid + 1))  TEST9
    , CONNECT_BY_ROOT (pid + id - pid) + CONNECT_BY_ROOT(id) * 10 + CONNECT_BY_ROOT id * 100  TEST10
    , CONNECT_BY_ROOT (pid + id - pid + id * 10 + id * 100)                                   TEST11
    , pid + CONNECT_BY_ROOT id - CONNECT_BY_ROOT pid + id * 10 + CONNECT_BY_ROOT id * 100     TEST12
FROM t
START WITH pid = 0
CONNECT BY PRIOR id = pid; 

SELECT 
    CONNECT_BY_ROOT id                     TEST4
FROM t
START WITH pid = 0
CONNECT BY PRIOR id = pid; 

SELECT 
    (RPAD(' ', 2*(LEVEL-1), '  ' ) || des) des_tree 
    , LEVEL
    , id
    , pid
    , nvl(CONNECT_BY_ROOT NULL, 'NULL')    TEST1
    , CONNECT_BY_ROOT 1                    TEST2
    , CONNECT_BY_ROOT 1 + id               TEST3
    , CONNECT_BY_ROOT id                   TEST4
    , CONNECT_BY_ROOT id + 1               TEST5
    , CONNECT_BY_ROOT abs(id + pid + 1)    TEST6
    , CONNECT_BY_ROOT abs(id) + pid + 1    TEST7
    , abs(CONNECT_BY_ROOT id + pid + 1)    TEST8
    , abs(CONNECT_BY_ROOT (id + pid + 1))  TEST9
    , CONNECT_BY_ROOT (pid + id - pid) + CONNECT_BY_ROOT(id) * 10 + CONNECT_BY_ROOT id * 100  TEST10
    , CONNECT_BY_ROOT (pid + id - pid + id * 10 + id * 100)                                   TEST11
    , pid + CONNECT_BY_ROOT id - CONNECT_BY_ROOT pid + id * 10 + CONNECT_BY_ROOT id * 100     TEST12
FROM t
CONNECT BY 1 = -1;

-- CONNECT_BY_ROOT used in WHERE condition
insert into t values (5, 'B',    0);
insert into t values (6, 'BB',   5);
insert into t values (7, 'BBB',  6);
insert into t values (8, 'BBBB', 7);
commit; 

SELECT
    id,
    des,
    pid, 
    CONNECT_BY_ROOT (pid + id - pid) + CONNECT_BY_ROOT(id) * 10 + CONNECT_BY_ROOT id * 100 TEST
FROM t
WHERE CONNECT_BY_ROOT id > 1  -- Choose B
START WITH pid = 0
CONNECT BY PRIOR id = pid;

SELECT
    id,
    des,
    pid, 
    CONNECT_BY_ROOT (pid + id - pid) + CONNECT_BY_ROOT(id) * 10 + CONNECT_BY_ROOT id * 100 TEST
FROM t
WHERE CONNECT_BY_ROOT id > 1  -- Choose B
START WITH pid = 0
CONNECT BY PRIOR id = pid
ORDER BY mod(CONNECT_BY_ROOT id, pid), pid desc;

SELECT
    id,
    des,
    pid, 
    CONNECT_BY_ROOT (pid + id - pid) + CONNECT_BY_ROOT(id) * 10 + CONNECT_BY_ROOT id * 100 TEST
FROM t
WHERE CONNECT_BY_ROOT id > 1  -- Choose B
START WITH pid = 0
CONNECT BY PRIOR id = pid
ORDER BY mod(CONNECT_BY_ROOT id, CONNECT_BY_ROOT pid), pid desc;

SELECT
    id,
    des,
    pid, 
    CONNECT_BY_ROOT (pid + id - pid) + CONNECT_BY_ROOT(id) * 10 + CONNECT_BY_ROOT id * 100 TEST
FROM t
WHERE CONNECT_BY_ROOT id > 1  -- Choose B
START WITH pid = 0
CONNECT BY PRIOR id = pid
ORDER BY CONNECT_BY_ROOT (id + pid), pid desc;

delete from t where id > 4;
commit;

----------------------------------------------------
-- case 2: Nest CONNECT_BY_ROOT
--   1. Oracle nest CONNECT_BY_ROOT works ambiguous,
--   2. Zenith support nest CONNECT_BY_ROOT at present,
--      and will not support later.
----------------------------------------------------
SELECT
    CONNECT_BY_ROOT CONNECT_BY_ROOT id
FROM t
CONNECT BY 1 = -1;  

-- Oracle crash... 
--   ERROR at line 1:
--   ORA-03113: end-of-file on communication channel
--   Process ID: 22597
--   Session ID: 233 Serial number: 9431
-- Zenith works.
SELECT
    -- CONNECT_BY_ROOT (CONNECT_BY_ROOT (id) )
    CONNECT_BY_ROOT (CONNECT_BY_ROOT id) 
FROM t
CONNECT BY 1 = -1;  

-- Oracle:ORA-00932: inconsistent datatypes: expected NUMBER got - 
-- Zenith works.
SELECT
    CONNECT_BY_ROOT (1 + CONNECT_BY_ROOT id) TEST
FROM t
CONNECT BY 1 = -1; 

-- Oracle: ORA-00932: inconsistent datatypes: expected NUMBER got -
-- Zenith works.
SELECT
    id, 
    CONNECT_BY_ROOT abs(CONNECT_BY_ROOT id) TEST
FROM t
CONNECT BY 1 = -1; 

-- Oracle: crash...
-- Zenith works.
SELECT
    CONNECT_BY_ROOT id,
    CONNECT_BY_ROOT (CONNECT_BY_ROOT (CONNECT_BY_ROOT(CONNECT_BY_ROOT(id + 1) + 1) + 1) + 1) + 1 TEST
FROM t
CONNECT BY 1 = -1; 

-- Oracle: ORA-00932: inconsistent datatypes: expected NUMBER got -
-- Zenith works.
SELECT
    CONNECT_BY_ROOT (1 + CONNECT_BY_ROOT id) TEST
FROM t
START WITH pid = 0
CONNECT BY PRIOR id = pid;

-- Oracle: ORA-00932: inconsistent datatypes: expected NUMBER got -
-- Zenith works.
SELECT
    CONNECT_BY_ROOT (1 + abs(CONNECT_BY_ROOT id)) TEST
FROM t
START WITH pid = 0
CONNECT BY PRIOR id = pid;

-- Oracle: ORA-00932: inconsistent datatypes: expected NUMBER got -
-- Zenith works.
SELECT
    CONNECT_BY_ROOT abs(CONNECT_BY_ROOT id) TEST
FROM t
START WITH pid = 0
CONNECT BY PRIOR id = pid;


----------------------------------------------------
-- case 3: Used in DDL or DML
----------------------------------------------------
create view v as SELECT CONNECT_BY_ROOT abs(id) TEST FROM t START WITH pid = 0 CONNECT BY PRIOR id = pid ORDER BY CONNECT_BY_ROOT id;
drop view v;

create view v as SELECT CONNECT_BY_ROOT abs(id) TEST FROM t;

create view v as select 1 a from t where CONNECT_BY_ROOT 1 < 2;

create table t1 as select CONNECT_BY_ROOT 1 a from t;

update t set id  = 
(
    SELECT
            CONNECT_BY_ROOT abs(id) TEST
    FROM t
    where rownum = 1
    START WITH pid = 0
    CONNECT BY PRIOR id = pid
);
select * from t;
rollback;

update t set id = CONNECT_BY_ROOT 1;

create table t1 (c1 int, c2 int default CONNECT_BY_ROOT 1);

declare
    i int;
begin
    i := CONNECT_BY_ROOT 1;
end;
/

declare
    i int;
begin
    i := CONNECT_BY_ROOT 1 + 1;
end;
/

set serveroutput on;
declare
    i int;
begin
    SELECT CONNECT_BY_ROOT pid INTO i FROM t WHERE ROWNUM = 1 START WITH pid = 0 CONNECT BY PRIOR id = pid;
    dbe_output.print_line('CONNECT_BY_ROOT pid: ' || i);
end;
/

----------------------------------------------------
-- case 4: more cases about CONNECT_BY_ROOT unary operator.
----------------------------------------------------
SELECT
    CONNECT_BY_ROOT id TEST
FROM t
START WITH pid = 0
CONNECT BY PRIOR id = pid;

SELECT
    CONNECT_BY_ROOT -id TEST
FROM t
START WITH pid = 0
CONNECT BY PRIOR id = pid;

SELECT
    - CONNECT_BY_ROOT id TEST
FROM t
START WITH pid = 0
CONNECT BY PRIOR id = pid;

SELECT
    - (CONNECT_BY_ROOT id)    TEST
FROM t
START WITH pid = 0
CONNECT BY PRIOR id = pid;

SELECT
    CONNECT_BY_ROOT (- id) TEST
FROM t
START WITH pid = 0
CONNECT BY PRIOR id =   pid;

SELECT
    (-(CONNECT_BY_ROOT (- id))) TEST
FROM t
START WITH pid = 0
CONNECT BY PRIOR id = pid;

SELECT
    id, 
    (-(CONNECT_BY_ROOT (id) + id)) TEST
FROM t
START WITH pid = 0
CONNECT BY PRIOR id = pid;

SELECT
    id, 
    CONNECT_BY_ROOT(-(-(CONNECT_BY_ROOT (id))))  + id   TEST1,
    CONNECT_BY_ROOT(-(-(CONNECT_BY_ROOT (id) + id )))   TEST2,
    CONNECT_BY_ROOT (-(-(2+3)))                         TEST3,
    -(-(2+3))                                           TEST4
FROM t
START WITH pid = 0
CONNECT BY PRIOR id = pid;

----------------------------------------------------
-- case 5: other cases
----------------------------------------------------
SELECT
    CONNECT_BY_ROOT(CONNECT_BY_ROOT id) TEST
FROM t
START WITH pid = 0
CONNECT BY PRIOR id = pid;

SELECT
    CONNECT_BY_ROOT(CONNECT_BY_ROOT id + CONNECT_BY_ROOT pid) TEST
FROM t
START WITH pid = 0
CONNECT BY PRIOR id = pid;

SELECT
    *
FROM t, (SELECT CONNECT_BY_ROOT pid FROM t) t1
START WITH t.pid = 0
CONNECT BY PRIOR t.id = t.pid;

select 
    CONNECT_BY_ROOT pid  
from 
(
    SELECT
        *
    FROM t
    START WITH t.pid = 0
    CONNECT BY PRIOR t.id = t.pid
);

SELECT
    c
FROM
(
    SELECT 
        CONNECT_BY_ROOT pid c
    FROM t
    START WITH pid = 0
    CONNECT BY PRIOR id = pid
) t1;

SELECT
    CONNECT_BY_ROOT (1 + CONNECT_BY_ROOT id)  TEST
FROM t
CONNECT BY 1 = -1;

drop table t;

--DTS2018091103096
drop table if exists T_CONNECTBY_A;
create table T_CONNECTBY_A(a int, b char(2));

insert into T_CONNECTBY_A
with
s1 as (select rownum c1 from dual connect by rownum <= 10),
s2 as (select rownum c2 from dual connect by rownum <= 10)
select a.c1, b.c2 from s1 a, s2 b;
select * from T_CONNECTBY_A order by a,b;

select rownum c1 from dual connect by level <= 10;
select rownum c1 from dual connect by rownum <= 10;

drop table if exists T_CONNECTBY_B;
create table T_CONNECTBY_B(id char) ;
insert into T_CONNECTBY_B values ('a'),('b'),('c') ;

select id , 
 connect_by_root (id) ROOT, 
 level l, 
 rownum r
from T_CONNECTBY_B
connect by level <=2;

select id , 
 connect_by_root (id) ROOT, 
 level l, 
 rownum r
from T_CONNECTBY_B
connect by rownum <=2;

drop table T_CONNECTBY_A;
drop table T_CONNECTBY_B;
-------------------------------------------------------------------------
--DTS202101130DZ8T2P1N00
alter system set _MAX_CONNECT_BY_LEVEL = 7001;

drop table if exists proc_seq_conn_by_06_t; 
create table proc_seq_conn_by_06_t (
  id int not null,
  account int default null,
  money int default null,
  num int default null,
  primary key (id)
);

drop sequence if exists proc_seq_conn_by_06_seq;
create sequence proc_seq_conn_by_06_seq start with 100 increment by 2;
insert into proc_seq_conn_by_06_t
    select proc_seq_conn_by_06_seq.nextval "a", proc_seq_conn_by_06_seq.nextval + 1 "a+1", proc_seq_conn_by_06_seq.nextval + 2 "a+2", rownum "b" from dual
    connect by rownum < 7001;  -- report error

alter system set _MAX_CONNECT_BY_LEVEL = 256;
drop table proc_seq_conn_by_06_t purge;
drop sequence proc_seq_conn_by_06_seq;

--sys_connect_by_path
drop table if exists employee_test;
create table employee_test(
       emp_id number(18),
       lead_id number(18),
       emp_name varchar2(200)
);
insert into employee_test values('1',0,'king');
insert into employee_test values('2',1,'arise');
insert into employee_test values('3',1,'jack');
insert into employee_test values('4',2,'wudde');
insert into employee_test values('5',2,'joker');
insert into employee_test values('6',3,'annie');
insert into employee_test values('7',3,'tony');
insert into employee_test values('8',4,'juddy');
insert into employee_test values('9',6,'tom');
commit;

select sys_connect_by_path(emp_name,'>') tree from employee_test start with emp_id=1 connect by prior emp_id = lead_id; 
select sys_connect_by_path(emp_name,'>') tree from employee_test start with emp_id=1 connect by emp_id = prior lead_id;
select sys_connect_by_path(1,'>') tree from employee_test start with emp_id=1 connect by prior emp_id = lead_id; 
select emp_name, sys_connect_by_path(level,'/') tree from employee_test start with emp_id=1 connect by prior emp_id = lead_id;
select lead_id, sys_connect_by_path(concat(emp_name, emp_id),'/') from employee_test start with emp_id=1 connect by prior emp_id =  lead_id;
SELECT LPAD(' ', 2*level-1)||SYS_CONNECT_BY_PATH(emp_name, '/') "Path" FROM employee_test  start with emp_id=1 connect by prior emp_id =  lead_id;
SELECT substr(SYS_CONNECT_BY_PATH(emp_name, '/'), 4, 10) "Path" FROM employee_test  start with emp_id=1 connect by prior emp_id =  lead_id;
select sys_connect_by_path(emp_name, ' ') tree from employee_test start with emp_id=1 connect by prior emp_id = lead_id;

select sys_connect_by_path(emp_name,'>') tree from employee_test; 
select lead_id, sys_connect_by_path(emp_name) from employee_test connect by prior emp_id =  lead_id;
select lead_id, sys_connect_by_path(emp_name, emp_id) from employee_test connect by prior emp_id =  lead_id;
select sys_connect_by_path(emp_name, null) tree from employee_test start with emp_id=1 connect by prior emp_id = lead_id;
select sys_connect_by_path(emp_name, '') tree from employee_test start with emp_id=1 connect by prior emp_id = lead_id;
select lead_id, sys_connect_by_path(emp_name, 'a') from employee_test connect by prior emp_id = lead_id;
--DTS2019111413664
select emp_id from employee_test where sys_connect_by_path(emp_name,'>') IS NOT NULL start with emp_id=1 connect by prior emp_id = lead_id;
select 1 from employee_test start with emp_id=1 connect by prior emp_id = lead_id group by sys_connect_by_path(emp_name,'>');
select 1 from employee_test start with emp_id=1 connect by prior emp_id = lead_id group by lead_id having sys_connect_by_path(lead_id,'>')< 'aa';
select emp_id, sys_connect_by_path(emp_name,'>'), sys_connect_by_path(emp_id,'/') from employee_test start with emp_id=1 connect by prior emp_id = lead_id order by sys_connect_by_path(emp_name,'>');
drop table employee_test;


--PMS201910177718
DROP VIEW IF EXISTS PBI_EDITION_dync_view_CB;
DROP TABLE IF EXISTS PBI_EDITION_PMS201910177718;
DROP TABLE IF EXISTS PBI_OFFERING;
DROP TABLE IF EXISTS PBI_DYNAMIC_ATTRIBUTE_VALUE;

CREATE TABLE "PBI_EDITION_PMS201910177718"
(
  "EDITION_ID" NUMBER(20) NOT NULL,
  "OFFERING_ID" NUMBER(20),
  "PARENT_ID" NUMBER(20),
  "NO" VARCHAR(45 BYTE) NOT NULL,
  "EDITION_CODE" VARCHAR(75 BYTE),
  "CATEGORY" VARCHAR(30 BYTE) NOT NULL,
  "STATUS" NUMBER(1) NOT NULL,
  "OFFERING_NAME" VARCHAR(768 BYTE),
  "ALIAS" VARCHAR(768 BYTE),
  "FOR_FINACE" NUMBER(1) NOT NULL,
  "LIFECYCLE_ID" VARCHAR(45 BYTE),
  "OLD_NO" VARCHAR(150 BYTE),
  "VERSION" VARCHAR(15 BYTE) NOT NULL,
  "CREATED_BY" VARCHAR(768 BYTE),
  "CREATION_DATE" DATE,
  "LAST_UPDATED_BY" VARCHAR(768 BYTE),
  "LAST_UPDATE_DATE" DATE,
  "DIFFICULTY_COEFFICIENT" VARCHAR(45 BYTE),
  "SPLIMIT" NUMBER(1),
  "SPNUM" NUMBER(5),
  "IFHISTORYCOA" NUMBER(1),
  "RESERVE11" VARCHAR(375 BYTE),
  "RESERVE12" VARCHAR(375 BYTE),
  "RESERVE13" VARCHAR(375 BYTE),
  "RESERVE14" VARCHAR(375 BYTE),
  "RESERVE15" VARCHAR(375 BYTE)
);

ALTER TABLE PBI_EDITION_PMS201910177718 ADD CONSTRAINT PK_PBI_EDITION PRIMARY KEY(EDITION_ID);
CREATE INDEX IN_PBI_EDITIONPARENT ON PBI_EDITION_PMS201910177718(PARENT_ID);
CREATE INDEX IN_PBI_EDITIONOFFER ON PBI_EDITION_PMS201910177718(OFFERING_ID);

CREATE TABLE PBI_DYNAMIC_ATTRIBUTE_VALUE(
  OBJECTID NUMBER NOT NULL,
  PBITYPE VARCHAR(1500) NOT NULL,
  MAPPINGID NUMBER,
  ATTRIBUTENAME VARCHAR(1500),
  VALUE VARCHAR(6000),
  CREATION_DATE DATE,
  LAST_UPDATE_DATE DATE
);
ALTER TABLE PBI_DYNAMIC_ATTRIBUTE_VALUE ADD CONSTRAINT PK_PBI_DYN_ATTR_VALUE PRIMARY KEY(OBJECTID, PBITYPE, ATTRIBUTENAME);

CREATE TABLE PBI_OFFERING(
  OFFERING_ID NUMBER(20) NOT NULL,
  ORG_ID NUMBER(20) NOT NULL,
  TYPE_ID VARCHAR(45),
  NO VARCHAR(45),
  NAME VARCHAR(384),
  STATUS VARCHAR(1),
  CATEGORY VARCHAR(30)
);
ALTER TABLE PBI_OFFERING ADD CONSTRAINT PK_PBI_OFFERING PRIMARY KEY(OFFERING_ID);

CREATE VIEW PBI_EDITION_dync_view_CB AS
select o."EDITION_ID",
       o."OFFERING_ID",
       o."PARENT_ID",
       o."NO",
       o."EDITION_CODE",
       o."CATEGORY",
       o."STATUS",
       o."OFFERING_NAME",
       o."ALIAS",
       o."FOR_FINACE",
       o."LIFECYCLE_ID",
       o."OLD_NO",
       o."VERSION",
       o."CREATED_BY",
       o."CREATION_DATE",
       o."LAST_UPDATED_BY",
       o."LAST_UPDATE_DATE",
       o."DIFFICULTY_COEFFICIENT",
       o."SPLIMIT",
       o."SPNUM",
       o."IFHISTORYCOA",
       o."RESERVE11",
       o."RESERVE12",
       o."RESERVE13",
       o."RESERVE14",
       o."RESERVE15",
       (SELECT VALUE
          FROM pbi_dynamic_attribute_value dync
         WHERE o.edition_id = dync.objectId
           AND dync.attributename = 'VERSION_CHARACTERISTIC') "VERSION_CHARACTERISTIC"
  from PBI_EDITION_PMS201910177718 o;

DROP VIEW IF EXISTS PBI_EDITION_dync_view_CB;
DROP TABLE IF EXISTS PBI_EDITION_PMS201910177718;
DROP TABLE IF EXISTS PBI_OFFERING;
DROP TABLE IF EXISTS PBI_DYNAMIC_ATTRIBUTE_VALUE;
--DTS2020010910887
drop table if exists t_con_by_optimize_101;
create table t_con_by_optimize_101(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(10) not null,c_vchar2 varchar2(100),c_clob clob,
c_long varchar(200),c_blob blob,c_raw raw(100),c_date date,c_timestamp timestamp);
insert into t_con_by_optimize_101 values(1,1000,100.123,100.456,100.789,100.123,'abc123','abcdefg',lpad('123abc',50,'abc'),lpad('123abc',50,'abc'),lpad('11100000',50,'1100'),lpad('11100001',50,'1100'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),to_timestamp(to_char('1800-03-05 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_con_by_optimize_101 values(-1,null,null,null,null,null,null,'M',null,null,null,null,null,null,null);	
commit;
drop table if exists t_con_by_optimize_001;
create table t_con_by_optimize_001(
id int,c_int int,c_real real,c_float float,c_decimal decimal,c_number number,
c_char char(10),c_vchar varchar(10) not null,c_vchar2 varchar2(100),c_clob clob,
c_long varchar(200),c_blob blob,c_raw raw(100),c_date date,c_timestamp timestamp);
insert into t_con_by_optimize_001 values(1,1000,100.123,100.456,100.789,100.123,'abc123','abcdefg',lpad('123abc',50,'abc'),lpad('123abc',50,'abc'),lpad('11100000',50,'1100'),lpad('11100001',50,'1100'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),to_timestamp(to_char('1800-03-05 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_con_by_optimize_001 values(-1,null,null,null,null,null,null,'M',null,null,null,null,null,null,null);	
commit;
select SYS_CONNECT_BY_PATH(t1.id||prior t2.id ||CONNECT_BY_ISCYCLE||max(t2.id+1),'/') c from t_con_by_optimize_101 t1 join t_con_by_optimize_101 t2 on t1.id=t2.id connect by nocycle prior t2.id=t1.id group by rollup(t1.id,prior t2.id,CONNECT_BY_ISCYCLE);
select SYS_CONNECT_BY_PATH('a'||max(t2.id+1) over(),'/') c from t_con_by_optimize_001 t1 join t_con_by_optimize_001 t2 on t1.id=t2.id connect by nocycle prior t2.id=t1.id;
drop table t_con_by_optimize_001;
drop table t_con_by_optimize_101;
--connect by pushdown
drop table if exists t_connectby_1;
drop table if exists t_connectby_2;
create table t_connectby_1(f1 int, f2 int, f3 int);
create table t_connectby_2(f1 int, f2 int, f3 int);
insert into t_connectby_1 values(1,5,3);
insert into t_connectby_1 values(2,4,6);
insert into t_connectby_1 values(3,3,3);
insert into t_connectby_1 values(5,2,8);
insert into t_connectby_1 values(5,1,3);
insert into t_connectby_2 values(1,2,3);
insert into t_connectby_2 values(3,4,5);
insert into t_connectby_2 values(4,5,6);
insert into t_connectby_2 values(2,4,1);
insert into t_connectby_2 values(5,6,3);
commit;
drop view if exists v_connectby_1;
drop view if exists v_connectby_2;
create view v_connectby_1 as select f1, f2 ,(select count(f3) from t_connectby_2 t2 WHERE t1.f1 = t2.f1) f3 from t_connectby_1 t1;
create view v_connectby_2 as select f1, f2 ,rowid f3 from t_connectby_1 t1;
---can not push down
select count(*) from (select f1, f2  from t_connectby_1 t1) t start with CONNECT_BY_ISLEAF = 1 connect by nocycle prior f2 = f1 ;
select count(*) from (select f1, f2 ,(select count(f3) from t_connectby_2 t2 WHERE t1.f1 = t2.f1) f3 from t_connectby_1 t1) t  
    START WITH rowid=1 connect by nocycle rowid=3;
SELECT ARRAY[SYS_CONNECT_BY_PATH(f1,'/'),f2] C FROM v_connectby_1 START WITH f1=1 CONNECT BY nocycle PRIOR f1 = f2 ;
SELECT * FROM (select array[f1,f2] as C ,f1,f2 from t_connectby_1 t1) START WITH C[1] is not null  CONNECT BY nocycle PRIOR f1 = f2 order by f1,f2;
SELECT * FROM (select array[f1,f2] as C ,f1,f2 from t_connectby_1 t1) START WITH f1 is not null  CONNECT BY nocycle PRIOR f1 = f2 order siblings by C[1];
SELECT ARRAY[level] C FROM v_connectby_1 START WITH f1=1 CONNECT BY nocycle PRIOR f1 = f2 ;
---can be pushed down
select f1, f2 from v_connectby_2 t start with f1 = 1 connect by nocycle prior f2 = f1 group by f1,f2 for update of f1;
select count(*) from v_connectby_2 where NVL(to_char(f1), case f2 when 1007 then to_char(f1) else '1' end)=to_char(f3) and SUBSTR(f3,2,3)='1' 
    start with f2=3 connect by nocycle length(to_char(prior f1))=f1 order siblings by 1;
SELECT * FROM (select array[f1,f2] as C ,f1,f2 from t_connectby_1 t1) START WITH f1 is not null  CONNECT BY nocycle PRIOR f1 = f2 order by C[1];
SELECT * FROM v_connectby_1 where rownum < 5 START WITH exists(select * from v_connectby_1 start with f1 = 1 connect by nocycle f1 = f2 limit 1)  CONNECT BY nocycle PRIOR f1 = f2 ;
select f1,f2 from v_connectby_2 where 1 =1 start with f2=3 connect by nocycle length(to_char(prior f1))=f1 order siblings by level limit 3;
select f1,f2 from (select a.f1, (select count(f3) from t_connectby_2 t2 WHERE a.f1 = t2.f1) f2, b.f3 from t_connectby_1 a left join v_connectby_2 b on a.f1 = b.f1) 
    where f1 = f2 start with f3 is not null connect by nocycle length(to_char(prior f1))=f1 order siblings by f1 DESC limit 3;
select rownum, f1,f2 from (select a.f1, a.f2, b.f3 from t_connectby_1 a left join v_connectby_2 b on a.f1 = b.f1) where 1 =1 
    start with f2=3 connect by nocycle length(to_char(prior f1))=f1 order siblings by f1 DESC;

drop table t_connectby_1;
drop table t_connectby_2;
drop view v_connectby_1;
drop view v_connectby_2;
---PBI
DROP TABLE IF EXISTS "PBI_EDITION";
CREATE TABLE "PBI_EDITION"
(
  "EDITION_ID" NUMBER(20) NOT NULL,
  "OFFERING_ID" NUMBER(20),
  "PARENT_ID" NUMBER(20),
  "CATEGORY" VARCHAR(30 BYTE) NOT NULL,
  "LIFECYCLE_ID" VARCHAR(45 BYTE),
  "RESERVE11" VARCHAR(375 BYTE)
);
DROP TABLE IF EXISTS "HWF_DD_ITEM";
CREATE TABLE "HWF_DD_ITEM"
(
  "ITEM_ID" VARCHAR(75 BYTE) NOT NULL,
  "ITEM_NAME" VARCHAR(150 BYTE) NOT NULL,
  "NLS_LANG" VARCHAR(15 BYTE) NOT NULL,
  "CLASSIFY_ID" VARCHAR(75 BYTE) NOT NULL,
  "PARENT_ITEM_ID" VARCHAR(75 BYTE),
  "ITEM_STATUS" NUMBER(38) NOT NULL
);
DROP TABLE IF EXISTS "PBI_DYNAMIC_ATTRIBUTE_VALUE";
CREATE TABLE "PBI_DYNAMIC_ATTRIBUTE_VALUE"
(
   "OBJECTID" NUMBER(20) NOT NULL,
   "VALUE" NUMBER(20),
   "ATTRIBUTENAME" VARCHAR(768 BYTE)
);
DROP TABLE IF EXISTS "PBI_OFFERING";
CREATE TABLE "PBI_OFFERING"
(
   "OFFERING_ID" NUMBER(20) NOT NULL,
   "CATEGORY" VARCHAR(30 BYTE) NOT NULL
);

ALTER TABLE "PBI_EDITION" ADD CONSTRAINT "PK_PBI_EDITION" PRIMARY KEY("EDITION_ID");
ALTER TABLE "PBI_OFFERING" ADD CONSTRAINT "PK_PBI_OFFERING" PRIMARY KEY("OFFERING_ID");
create index IN_PBI_EDITIONPARENT on PBI_EDITION(PARENT_ID);
create index IN_PBI_EDITIONOFFER on PBI_EDITION(OFFERING_ID);

CREATE OR REPLACE VIEW PBI_EDITION_dync_view AS 
select 
    o."EDITION_ID",
	o."OFFERING_ID",
    o."PARENT_ID",
    o."CATEGORY",
    o."LIFECYCLE_ID",
    (SELECT VALUE
        FROM pbi_dynamic_attribute_value dync
        WHERE o.edition_id = dync.objectId
        AND dync.attributename = 'VERSION_CHARACTERISTIC') "VERSION_CHARACTERISTIC"
 from pbi_edition o;

DROP TABLE "PBI_EDITION";
DROP TABLE "HWF_DD_ITEM";
DROP TABLE "PBI_DYNAMIC_ATTRIBUTE_VALUE";
DROP TABLE "PBI_OFFERING";
DROP VIEW PBI_EDITION_dync_view;

-- prior node datatype = prior node->right datatype and no need to be numeric
drop table if exists prior_type_t;
create table prior_type_t(id number(8), c_binary varbinary(100), c_raw raw(100));

select * from prior_type_t as t1  start with t1.id > 1 connect by prior t1.c_binary = t1.c_raw;

drop table prior_type_t;

-- core:union all connect by 
drop table if exists union_all_connect_by_t1;
drop table if exists union_all_connect_by_t2;
drop table if exists union_all_connect_by_t3;

create table union_all_connect_by_t1(id number(8), c_int number(8), c_str varchar(20));
create table union_all_connect_by_t2(id number(8), c_int number(8), c_str varchar(20));
create table union_all_connect_by_t3(id number(8), c_int number(8), c_str varchar(20));
insert into union_all_connect_by_t1 values(1,2,'test1');
insert into union_all_connect_by_t1 values(2,3,'test2');
insert into union_all_connect_by_t2 values(1,5,'test3');
insert into union_all_connect_by_t2 values(1,4,'test2');
insert into union_all_connect_by_t3 values(1,2,'test1');
commit;

(
select 
    (select subq_0.c0 from union_all_connect_by_t2 ref_0 limit 1) as c0
from 
    (select 
        c_str as c0
     from
        union_all_connect_by_t1 ref_1
     limit 10
    ) as subq_0
connect by true
limit 2
)
union all
(
select c_str
from union_all_connect_by_t3 ref_2
);

drop table union_all_connect_by_t1;
drop table union_all_connect_by_t2;
drop table union_all_connect_by_t3;

drop table if exists SECTIONS_1;
drop table if exists SALARIES_1;
drop table if exists EMPLOYEES_1;
CREATE TABLE "SECTIONS_1"
(
  "SECTION_ID" NUMBER(4) NOT NULL,
  "SECTION_NAME" VARCHAR(30 BYTE),
  "MANAGER_ID" NUMBER(6),
  "PLACE_ID" NUMBER(4)
);
create table SALARIES_1(TO_DATE date, FROM_DATE date);
create table EMPLOYEES_1(HIRE_DATE date);
INSERT INTO "SECTIONS_1"  values(10,'Administration',200,1700);
INSERT INTO "SECTIONS_1"  values(20,'Marketing',201,1800);
INSERT INTO "SECTIONS_1"  values(30,'Purchasing',114,1700);
INSERT INTO "SECTIONS_1"  values(40,'Human Resources',203,2400);
INSERT INTO "SECTIONS_1"  values(50,'Shipping',121,1500);
INSERT INTO "SECTIONS_1"  values(60,'IT',103,1400);
INSERT INTO "SECTIONS_1"  values(70,'Public Relations',204,2700);
INSERT INTO "SECTIONS_1"  values(80,'Sales',145,2500);
INSERT INTO "SECTIONS_1"  values(90,'Executive',100,1700);
INSERT INTO "SECTIONS_1"  values(100,'Finance',108,1700);
INSERT INTO "SECTIONS_1"  values(110,'Accounting',205,1700);
INSERT INTO "EMPLOYEES_1" values('1986-06-26 00:00:00');
INSERT INTO "EMPLOYEES_1" values('1985-11-21 00:00:00');
INSERT INTO "EMPLOYEES_1" values('1986-08-28 00:00:00');
INSERT INTO "EMPLOYEES_1" values('1986-12-01 00:00:00');
INSERT INTO "EMPLOYEES_1" values('1989-09-12 00:00:00');
INSERT INTO "EMPLOYEES_1" values('1989-06-02 00:00:00');
INSERT INTO "EMPLOYEES_1" values('1989-02-10 00:00:00');
INSERT INTO "EMPLOYEES_1" values('1994-09-15 00:00:00');
INSERT INTO "EMPLOYEES_1" values('1985-02-18 00:00:00');
INSERT INTO "EMPLOYEES_1" values('1989-08-24 00:00:00');
INSERT INTO "SALARIES_1" values('1986-06-26 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES_1" values('1996-08-03 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES_1" values('1995-12-03 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES_1" values('1986-12-01 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES_1" values('1989-09-12 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES_1" values('1990-08-05 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES_1" values('1989-02-10 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES_1" values('1998-03-11 00:00:00','2000-07-31 00:00:00');
INSERT INTO "SALARIES_1" values('1985-02-18 00:00:00','9999-01-01 00:00:00');
INSERT INTO "SALARIES_1" values('1996-11-24 00:00:00','2000-06-26 00:00:00');
INSERT INTO "SALARIES_1" values('2000-06-26 00:00:00','9999-01-01 00:00:00');
COMMIT;

SELECT
  NULL AS C5
FROM
  (SELECT
        CASE WHEN
            (
            CAST('154-1' AS INTERVAL YEAR(4) TO MONTH)) IN (
            SELECT
                CAST('2246-8' AS INTERVAL YEAR(4) TO MONTH) AS C3
              FROM
                 SALARIES_1 AS REF_1
              START WITH EXISTS (
                  SELECT
                      1
                    FROM
                       SECTIONS_1 PIVOT(MAX(CAST(REF_1.FROM_DATE AS DATE)) AS AGGR_0
                         FOR (MANAGER_ID, SECTION_ID)
                        IN ((203, 40) AS PEXPR_0)) AS REF_2
                  )
                CONNECT BY REF_1.TO_DATE = PRIOR REF_1.FROM_DATE )
          THEN
            NULL
          ELSE
            NULL
          END AS C2,
        CAST('679531 12:37:31' AS INTERVAL DAY(7) TO SECOND(6)) AS C4,
        REF_0.HIRE_DATE AS C5,
        CAST('701191 13:30:21' AS INTERVAL DAY TO SECOND) AS C10
      FROM
         EMPLOYEES_1 AS REF_0
      GROUP BY
        GROUPING SETS( 
            ROLLUP(
                REF_0.HIRE_DATE))
    ) AS SUBQ_0
  CONNECT BY SUBQ_0.C5 = PRIOR SUBQ_0.C2  OR SUBQ_0.C10 = PRIOR SUBQ_0.C4;
  
drop table SECTIONS_1;
drop table SALARIES_1;
drop table EMPLOYEES_1;

-- DTS202012150EPWFRP1D00
drop table if exists connect_by_loop_error_t1;
drop table if exists connect_by_loop_error_t2;
drop table if exists connect_by_loop_error_t3;

create table connect_by_loop_error_t1(id number(8), c_int number(10));
create table connect_by_loop_error_t2(id number(8), c_int number(10));
create table connect_by_loop_error_t3(id number(8), c_str varchar(20));

insert into connect_by_loop_error_t1 values(1,1);
insert into connect_by_loop_error_t2 values(1,1);
insert into connect_by_loop_error_t3 values(1,'test');
commit;

SELECT
    NULL AS C0
FROM
    (SELECT
        (SELECT REF_1.c_int AS C1 FROM connect_by_loop_error_t1 AS REF_1 CONNECT BY  PRIOR REF_1.id = REF_1.id limit 1) AS C0,
        (SELECT MAX(c_int) FROM connect_by_loop_error_t2) AS C1,
        REF_0.c_str AS C2
    FROM
        connect_by_loop_error_t3 AS REF_0
    ) AS SUBQ_0
CONNECT BY SUBQ_0.C1 = PRIOR SUBQ_0.C0 OR PRIOR SUBQ_0.C1 = SUBQ_0.C0;

drop table connect_by_loop_error_t1;
drop table connect_by_loop_error_t2;
drop table connect_by_loop_error_t3;

--bugfix: DTS202012070FD9PXP1L00
drop table if exists t_siblings_base_123;
drop table if exists t_ct_sub_110 ;

create table t_siblings_base_123(EMPNO NUMBER(4),ENAME VARCHAR2(10),MGR NUMBER(4));
insert into t_siblings_base_123 values (1,'M',NULL);
insert into t_siblings_base_123 values (2,'N',NULL);
insert into t_siblings_base_123 values (3,'A',NULL);
insert into t_siblings_base_123 values (4,'C',3);
insert into t_siblings_base_123 values (null,'C',3);
insert into t_siblings_base_123 values (5,'B',3);
insert into t_siblings_base_123 values (6,'F',4);
insert into t_siblings_base_123 values (7,'E',4);
insert into t_siblings_base_123 values (8,'D',5);
insert into t_siblings_base_123 values (9,'G',5);
commit;

create table t_ct_sub_110 as 
select count(*) c
  from (select /*+ FULL +*/
         level c1,
         case
           when t1.ENAME = 'E' then
            null
           else
            t1.ename
         end c,
         PRIOR t1.ENAME PRIORENAME,
         t1.EMPNO,
         PRIOR t1.EMPNO PRIOREMPNO,
         t1.MGR
          from t_siblings_base_123 as of timestamp current_timestamp t1
          join t_siblings_base_123 t2
            on t1.ename != t2.ename
         start with exists (select *
                       from t_siblings_base_123
                      where t1.empno != t2.mgr)
                and exists
         (select *
                       from t_siblings_base_123
                      where t1.empno != t2.empno)
        connect by nocycle PRIOR t1.empno = t2.mgr
         order siblings by c nulls last);
SELECT * FROM t_ct_sub_110;

drop table t_siblings_base_123;
drop table t_ct_sub_110 ;

DROP TABLE IF EXISTS "SALARIES";
DROP TABLE IF EXISTS "STATES";
CREATE TABLE "SALARIES"
(
  "EMP_NO" BINARY_INTEGER NOT NULL,
  "SALARY" BINARY_INTEGER NOT NULL,
  "FROM_DATE" DATE NOT NULL,
  "TO_DATE" DATE NOT NULL,
  "COL_12" INTERVAL DAY(2) TO SECOND(6)
);
CREATE TABLE "STATES"
(
  "STATE_ID" CHAR(2 BYTE) NOT NULL,
  "STATE_NAME" VARCHAR(40 BYTE),
  "AREA_ID" NUMBER
);

DROP TABLE "SALARIES";
DROP TABLE "STATES";

DROP TABLE IF EXISTS "EMPLOYEES";
DROP TABLE IF EXISTS "SECTIONS";
DROP TABLE IF EXISTS "AREAS";
DROP TABLE IF EXISTS TBL_SUBPARTITION_RANGE2_25;
CREATE TABLE "EMPLOYEES"
(
  "EMP_NO" BINARY_INTEGER NOT NULL,
  "BIRTH_DATE" DATE NOT NULL,
  "FIRST_NAME" VARCHAR(50 BYTE) NOT NULL,
  "LAST_NAME" VARCHAR(50 BYTE) NOT NULL,
  "GENDER" CHAR(1 BYTE) NOT NULL,
  "HIRE_DATE" DATE NOT NULL
);
CREATE TABLE "AREAS"
(
  "AREA_ID" NUMBER,
  "AREA_NAME" VARCHAR(25 BYTE)
);
CREATE TABLE "SECTIONS"
(
  "SECTION_ID" NUMBER(4) NOT NULL,
  "SECTION_NAME" VARCHAR(30 BYTE),
  "MANAGER_ID" NUMBER(6),
  "PLACE_ID" NUMBER(4)
);
create table TBL_SUBPARTITION_RANGE2_25(C_DATE date, C_NUMERIC NUMBER(20, 10));
INSERT INTO EMPLOYEES values(10001,'1953-09-02 00:00:00','Georgi','Facello','M','1986-06-26 00:00:00');
INSERT INTO AREAS values(1,'Europe');
INSERT INTO SECTIONS values(10,'Administration',200,1700);
COMMIT;

SELECT 
  1
FROM 
  (SELECT 
        (SELECT SECTION_ID FROM SECTIONS LIMIT 1 OFFSET 3) AS C4, 
        CORR(
          CAST(REF_0.AREA_ID AS NUMBER),
          CAST((SELECT SECTION_ID FROM SECTIONS ) AS NUMBER(4,0))) AS C6
      FROM 
        AREAS AS REF_0
      WHERE TRUE
      START WITH CAST('2020-12-15 02:37:41' AS TIMESTAMP(6) WITH LOCAL TIME ZONE) <> ALL(
          SELECT 
              1
            FROM 
              SECTIONS AS REF_5
            OFFSET 87)
        CONNECT BY REF_0.AREA_NAME IS NULL
    ) AS SUBQ_0 ;

SELECT 
  1
FROM 
  (SELECT 
      (SELECT SECTION_ID FROM SECTIONS LIMIT 1 OFFSET 3) AS C4, 
        CORR(
      CAST((SELECT SECTION_ID FROM SECTIONS LIMIT 1 OFFSET 4) AS NUMBER(20,0)),
      CAST(NULL AS NUMBER)) OVER (PARTITION BY REF_0.AREA_NAME ORDER BY REF_0.AREA_NAME DESC) AS C5
      FROM 
        AREAS AS REF_0
      WHERE TRUE
      START WITH CAST('2020-12-15 02:37:41' AS TIMESTAMP(6) WITH LOCAL TIME ZONE) <> ALL(
          SELECT 
              1
            FROM 
              SECTIONS AS REF_5
            OFFSET 87)
        CONNECT BY REF_0.AREA_NAME IS NULL
    ) AS SUBQ_0;

SELECT DISTINCT 
  CASE WHEN
      CAST('638799 2:20:31' AS INTERVAL DAY TO SECOND(6)) > SOME(
      SELECT 
          CAST('30512 18:19:39' AS INTERVAL DAY TO SECOND(6)) AS C1
        FROM 
          TBL_SUBPARTITION_RANGE2_25 AS REF_2
        WHERE REGEXP_LIKE(REF_2.C_NUMERIC,'.*')
        LIMIT 30 OFFSET 13)
    THEN
      (SELECT C_DATE FROM TBL_SUBPARTITION_RANGE2_25 LIMIT 1 OFFSET 6)
    ELSE
      (SELECT C_DATE FROM TBL_SUBPARTITION_RANGE2_25 LIMIT 1 OFFSET 6)
    END AS C1
FROM 
  EMPLOYEES AS REF_1
START WITH REF_1.BIRTH_DATE < SOME(
     (SELECT C_DATE FROM TBL_SUBPARTITION_RANGE2_25 LIMIT 1 OFFSET 5), CURRENT_TIMESTAMP())
  CONNECT BY REF_1.BIRTH_DATE = PRIOR REF_1.HIRE_DATE  AND REF_1.FIRST_NAME = PRIOR REF_1.LAST_NAME 
GROUP BY 
  REF_1.HIRE_DATE, 
  CUBE(
        REF_1.FIRST_NAME, 
        REF_1.HIRE_DATE);
        
-- DTS202012260G0L9GP0F00
SELECT 
  1 AS C1, 
  REF_1.EMP_NO AS C2
FROM 
  (EMPLOYEES AS REF_0) INNER JOIN 
  (EMPLOYEES AS REF_1)
  ON (REF_1.EMP_NO <> ALL(
        SELECT 
            45 AS C1
        FROM 
            SECTIONS AS REF_2
        CONNECT BY PRIOR REF_2.SECTION_ID = REF_2.MANAGER_ID)
     )

CONNECT BY PRIOR REF_0.BIRTH_DATE = REF_1.HIRE_DATE 
GROUP BY REF_1.EMP_NO;

DROP TABLE "EMPLOYEES";
DROP TABLE "SECTIONS";
DROP TABLE "AREAS";
DROP TABLE "TBL_SUBPARTITION_RANGE2_25";

-- DTS202012260720QYP1F00
DROP TABLE IF EXISTS CONNECT_BY_TEST_T1;
DROP TABLE IF EXISTS CONNECT_BY_TEST_T2;
DROP TABLE IF EXISTS CONNECT_BY_TEST_T3;
DROP TABLE IF EXISTS CONNECT_BY_TEST_T4;
DROP TABLE IF EXISTS CONNECT_BY_TEST_T5;

CREATE TABLE CONNECT_BY_TEST_T1(OBJECT_NAME VARCHAR(20));
CREATE TABLE CONNECT_BY_TEST_T2(USER_ID BINARY_INTEGER NOT NULL );
CREATE TABLE CONNECT_BY_TEST_T3(USER# BINARY_INTEGER NOT NULL, ID BINARY_INTEGER NOT NULL, NAME VARCHAR(64 BYTE) NOT NULL);
CREATE UNIQUE INDEX CONNECT_BY_TEST_T3_IDX1 ON CONNECT_BY_TEST_T3(USER#, NAME);
CREATE UNIQUE INDEX CONNECT_BY_TEST_T3_IDX2 ON CONNECT_BY_TEST_T3(USER#, ID);

CREATE TABLE CONNECT_BY_TEST_T4
(
  USER# BINARY_INTEGER NOT NULL,
  TABLE# BINARY_INTEGER NOT NULL,
  ID BINARY_INTEGER NOT NULL,
  NAME VARCHAR(64 BYTE) NOT NULL,
  HIGH_VALUE VARCHAR(64 BYTE)
);
CREATE UNIQUE INDEX CONNECT_BY_TEST_T4_IDX1 ON CONNECT_BY_TEST_T4(USER#, TABLE#, ID);

CREATE TABLE CONNECT_BY_TEST_T5(USER# BINARY_INTEGER, TAB# BINARY_INTEGER, COL# BINARY_INTEGER);
CREATE UNIQUE INDEX CONNECT_BY_TEST_T5_IDX1 ON CONNECT_BY_TEST_T5(USER#, TAB#, COL#);

INSERT INTO CONNECT_BY_TEST_T1 VALUES('TEST1');
INSERT INTO CONNECT_BY_TEST_T1 VALUES('TEST2');
INSERT INTO CONNECT_BY_TEST_T2 VALUES(0);
INSERT INTO CONNECT_BY_TEST_T2 VALUES(1);
INSERT INTO CONNECT_BY_TEST_T3 VALUES(0,1,'MY_TABLE');
INSERT INTO CONNECT_BY_TEST_T3 VALUES(1,1,'MY_TABLE2');
INSERT INTO CONNECT_BY_TEST_T4 VALUES(0,1,1,'COL_1','HIGH');
INSERT INTO CONNECT_BY_TEST_T4 VALUES(1,1,1,'COL_1','HIGH');
INSERT INTO CONNECT_BY_TEST_T5 VALUES(0, 1, 1);
INSERT INTO CONNECT_BY_TEST_T5 VALUES(1, 1, 1);
COMMIT;

CREATE OR REPLACE VIEW CONNECT_BY_TEST_VIEW
(
  TABLE_NAME,
  COLUMN_NAME,
  HIGH_VALUE
)
AS
  SELECT T.NAME, C.NAME, C.HIGH_VALUE
  FROM CONNECT_BY_TEST_T2 M JOIN CONNECT_BY_TEST_T3 T ON T.USER# = M.USER_ID
  JOIN CONNECT_BY_TEST_T4 C ON T.ID = C.TABLE# AND T.USER# = C.USER#
  LEFT JOIN CONNECT_BY_TEST_T5 HH ON C.USER# = HH.USER# AND C.TABLE# = HH.TAB# AND C.ID = HH.COL#
/

DECLARE
    v1 int;
BEGIN
    FOR i in 1..10 LOOP
        BEGIN
            SELECT
                C1 into v1
            FROM 
                ((SELECT
                    2 AS C1
                 FROM
                    connect_by_test_view AS REF_1
                 START WITH 
                    REF_1.TABLE_NAME BETWEEN (SELECT MAX(OBJECT_NAME) FROM connect_by_test_t1) AND REF_1.HIGH_VALUE
                 CONNECT BY REF_1.COLUMN_NAME = PRIOR REF_1.TABLE_NAME
                 ) AS SUBQ_0
                );
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN v1 := 1;
        END;
    END LOOP;
END;
/

DROP VIEW CONNECT_BY_TEST_VIEW;
DROP TABLE CONNECT_BY_TEST_T1;
DROP TABLE CONNECT_BY_TEST_T2;
DROP TABLE CONNECT_BY_TEST_T3;
DROP TABLE CONNECT_BY_TEST_T4;
DROP TABLE CONNECT_BY_TEST_T5;

--AR.SR.IREQ02518205.001.004
--prior condition is null && multiple prior conditions
drop table if exists employee_null;
create table employee_null(
       emp_id number(18),
       lead_id number(18),
       emp_name varchar2(200),
       a number(18),
       b number(18)
);
insert into employee_null values(1,0,'king', 3, NULL);
insert into employee_null values(2,1,'arise', 3, NULL);
insert into employee_null values(4,2,'bb', 3, NULL);
insert into employee_null values(1,4,'aa', 4, NULL);
insert into employee_null values(3,4,'cc', 3, NULL);
insert into employee_null values(2,0,'king2', 3, NULL);
commit;

select CONNECT_BY_ISCYCLE, CONNECT_BY_ISLEAF, emp_name, level, sys_connect_by_path(emp_name,'->') tree from employee_null start with lead_id=0 connect by NOCYCLE prior emp_id = prior lead_id;

select CONNECT_BY_ISCYCLE, CONNECT_BY_ISLEAF, emp_name, level, sys_connect_by_path(emp_name,'->') tree from employee_null start with lead_id=0 connect by NOCYCLE prior emp_id = lead_id and  prior a is not NULL;

delete from employee_null where a = 4;
insert into employee_null values(1,4,'aa', 3, NULL);
commit;
select CONNECT_BY_ISCYCLE, CONNECT_BY_ISLEAF, emp_name, level, sys_connect_by_path(emp_name,'->') tree from employee_null start with lead_id=0 connect by NOCYCLE prior emp_id = lead_id and  prior a is not NULL;

delete from employee_null;
insert into employee_null values(1,0,'king', NULL, NULL);
insert into employee_null values(2,1,'arise', NULL, NULL);
insert into employee_null values(4,2,'bb', NULL, NULL);
insert into employee_null values(1,4,'aa', NULL, NULL);
insert into employee_null values(3,4,'cc', 4, NULL);
insert into employee_null values(5,3,'dd', NULL, NULL);
insert into employee_null values(2,0,'king2', NULL, NULL);
commit;
select CONNECT_BY_ISCYCLE, CONNECT_BY_ISLEAF, emp_name, level, sys_connect_by_path(emp_name,'->') tree from employee_null start with lead_id=0 connect by NOCYCLE prior emp_id = lead_id and  prior a is NULL;

delete from employee_null;
insert into employee_null values(2,1,'arise',null, 1);
insert into employee_null values(5,2,'joker',5, null);
commit;
select emp_name, sys_connect_by_path(emp_name,'->') tree from employee_null start with lead_id = 1 connect by nocycle prior emp_id = lead_id and prior a = b;

delete from employee_null;
insert into employee_null values(5,2,'joker', NULL, NULL);
insert into employee_null values(1,0,'king', NULL, NULL);
insert into employee_null values(2,1,'arise', NULL, NULL);
insert into employee_null values(NULL,5,'adc', NULL, NULL);
insert into employee_null values(2,NULL,'ppl', NULL, NULL);
commit;
select emp_name, sys_connect_by_path(emp_name,'->') tree, connect_by_isleaf from employee_null start with emp_id = 1 connect by nocycle prior emp_id = lead_id;

delete from employee_null;
insert into employee_null values(1,0,'king', 9, NULL);
insert into employee_null values(2,1,'arise', 8, NULL);
insert into employee_null values(5,2,'joker', 3, NULL);
insert into employee_null values(4,2,'adc', 7, NULL);
insert into employee_null values(7,4,'ppl', 6, NULL);
insert into employee_null values(8,5,'tyu', 2, NULL);
insert into employee_null values(3,1,'iop', 2, NULL);
insert into employee_null values(6,3,'ght', 1, NULL);
commit;
select a, prior emp_id, connect_by_isleaf, connect_by_iscycle, sys_connect_by_path(emp_name,'/') tree from employee_null start with emp_id = 1 connect by nocycle prior emp_id = lead_id and prior emp_id < a order siblings by emp_id;
select prior emp_id, level, sys_connect_by_path(emp_name,'/') tree from employee_null start with emp_id = 1 connect by nocycle prior emp_id = lead_id and level < 4 order siblings by emp_id;
select rownum, level, CONNECT_BY_ROOT(emp_id), sys_connect_by_path(emp_name,'/') tree from employee_null start with emp_id < 3 and rownum < 3 connect by nocycle prior emp_id = lead_id and rownum < 10 order siblings by emp_id;
select emp_name, sys_connect_by_path(emp_name,'/') tree from employee_null start with emp_id < 3 connect by nocycle prior emp_id = lead_id and prior emp_id = (select emp_id from employee_null where emp_name='king') order siblings by emp_id;
drop table employee_null;

drop table if exists t_lob_conn;
create table t_lob_conn(f1 clob, f2 clob);
insert into t_lob_conn values('clob1234567890987654321clob', '11111111112222222222');
insert into t_lob_conn values('clob88721837182611clob123', 'clob1234567890987654321clob');
commit;
select f1, f2, level from t_lob_conn start with f2='11111111112222222222' connect by NOCYCLE prior f1 = f2;
drop table t_lob_conn;


ALTER SYSTEM SET _MAX_CONNECT_BY_LEVEL=9200;
drop table if exists employee_depth;
create table employee_depth(emp_id number(18), lead_id number(18));

begin
for i in 0 .. 9200 loop
  insert into employee_depth values(i+1, i);
end loop;
for i in 1 .. 9 loop
  insert into employee_depth values(i*10000, i*1000);
end loop;
end;
/
commit;

select emp_id, level, connect_by_isleaf from employee_depth where connect_by_isleaf = 1 start with emp_id = 1 connect by nocycle prior emp_id = lead_id and level < 9201;

--DTS202101070EMA6IP0K00-cycle check error
ALTER SYSTEM SET _MAX_CONNECT_BY_LEVEL=10000;
delete from employee_depth;
begin
for i in 0 .. 10000 loop
  insert into employee_depth values(i+1, i);
end loop;
for i in 1 .. 20 loop
  insert into employee_depth values(i*10000, i*500);
end loop;
end;
/
commit;
select emp_id, level, connect_by_iscycle, connect_by_isleaf, CONNECT_BY_ROOT(EMP_ID) from employee_depth where connect_by_iscycle = 1 or level = 4096 start with emp_id <=3 connect by nocycle prior emp_id = lead_id and level < 10001 order by 5;
drop table employee_depth;
ALTER SYSTEM SET _MAX_CONNECT_BY_LEVEL=256;

--DTS202101070JCQ0EP1I00-PLAN_NODE_CONNECT union all PLAN_NODE_CONNECT_HASH
drop table if exists dept_manager;
create table dept_manager( emp_no integer not null, a integer not null, b integer not null);
insert into dept_manager values(10017,1,0);
insert into dept_manager values(10020,2,1);
insert into dept_manager values(10024,3,2);
commit;
(SELECT emp_no, sys_connect_by_path(emp_no,'/') cpath FROM DEPT_MANAGER START WITH emp_no = 10017 CONNECT BY PRIOR a = b)
UNION ALL
(SELECT emp_no, sys_connect_by_path(emp_no,'/') cpath FROM DEPT_MANAGER START WITH emp_no = 10020 CONNECT BY PRIOR a = b)
UNION ALL
(SELECT emp_no, sys_connect_by_path(emp_no,'/') cpath FROM DEPT_MANAGER START WITH emp_no = 10017 CONNECT BY level < 3)
UNION ALL
(SELECT emp_no, sys_connect_by_path(emp_no,'/') cpath FROM DEPT_MANAGER START WITH emp_no = 10024 CONNECT BY PRIOR a = b);

(SELECT emp_no, sys_connect_by_path(emp_no,'/') cpath FROM DEPT_MANAGER START WITH emp_no = 10017 CONNECT BY level < 2)
UNION ALL
(SELECT emp_no, sys_connect_by_path(emp_no,'/') cpath FROM DEPT_MANAGER START WITH emp_no = 10020 CONNECT BY level < 2)
UNION ALL
(SELECT emp_no, sys_connect_by_path(emp_no,'/') cpath FROM DEPT_MANAGER START WITH emp_no = 10020 CONNECT BY PRIOR a = b)
UNION ALL
(SELECT emp_no, sys_connect_by_path(emp_no,'/') cpath FROM DEPT_MANAGER START WITH emp_no = 10024 CONNECT BY level < 2);

(SELECT emp_no FROM DEPT_MANAGER START WITH emp_no = 10017 CONNECT BY PRIOR a = b)
UNION
(SELECT emp_no FROM DEPT_MANAGER START WITH emp_no = 10020 CONNECT BY PRIOR a = b)
UNION ALL
(SELECT emp_no FROM DEPT_MANAGER START WITH emp_no = 10017 CONNECT BY level < 3)
UNION
(SELECT emp_no FROM DEPT_MANAGER START WITH emp_no = 10024 CONNECT BY PRIOR a = b);
drop table dept_manager;

--DTS202101050NGNP8P1100: prior nest
drop table if exists t_siblings_base;
create table t_siblings_base(EMPNO NUMBER(4),ENAME VARCHAR2(10),MGR NUMBER(4));
insert into t_siblings_base values (1,'M',NULL);
insert into t_siblings_base values (4,'C',3);
insert into t_siblings_base values (3,'A',NULL);
insert into t_siblings_base values (null,'R',3);
insert into t_siblings_base values (5,'B',3);
insert into t_siblings_base values (6,'F',4);
insert into t_siblings_base values (7,'E',4);
insert into t_siblings_base values (8,'D',5);
insert into t_siblings_base values (9,'G',5);
commit;
select prior (3 + prior empno) from t_siblings_base connect by PRIOR empno = mgr;
select prior 3 + (prior empno), empno from t_siblings_base start with ENAME = 'A' connect by PRIOR empno = mgr;
select prior case when empno+prior empno+prior empno *  prior (empno+empno) >empno then empno else empno end c2 from t_siblings_base connect by PRIOR empno = mgr order by 1,2;
select case when empno+prior empno+prior empno *  prior (empno+empno) >empno then empno else prior empno end c, sys_connect_by_path(ENAME,'->'), level from t_siblings_base start with ENAME = 'A' connect by PRIOR empno = mgr order by 3,1;
drop table t_siblings_base;
--20210115
drop table if exists temp20210115;
create table temp20210115(f1 int, f2 int);
insert into temp20210115 values(1,2),(1,1);
commit;
select sys_connect_by_path(1,'/') from temp20210115 connect by nocycle prior f2= f1 order by f1,f2;
select sys_connect_by_path(1,'/') from temp20210115 connect by nocycle prior f2= f1 group by f1,f2;
select 1 from temp20210115 connect by nocycle prior f2= f1 group by f1,f2 order by sys_connect_by_path(1,'/');
select count(*) from temp20210115 connect by nocycle prior f2= f1 order by sys_connect_by_path(1,'/');
select count(*),sys_connect_by_path(1,'/') from temp20210115 connect by nocycle prior f2= f1;
drop table temp20210115;

drop table if exists t_or_expansion_1;
drop table if exists t_or_expansion_2;
drop table if exists "TBL_USER_GROUP";
CREATE TABLE "TBL_USER_GROUP"
(
  "USER_ID" VARCHAR(36 BYTE) NOT NULL,
  "AUTH_GROUP_ID" VARCHAR(36 BYTE) NOT NULL
);
INSERT INTO "TBL_USER_GROUP" ("USER_ID","AUTH_GROUP_ID") values ('20','9140679012041439197');
INSERT INTO "TBL_USER_GROUP" ("USER_ID","AUTH_GROUP_ID") values ('20','8925031671308011985');
INSERT INTO "TBL_USER_GROUP" ("USER_ID","AUTH_GROUP_ID") values ('20','7618566365643065757');
INSERT INTO "TBL_USER_GROUP" ("USER_ID","AUTH_GROUP_ID") values ('20','2367038580984590784');
INSERT INTO "TBL_USER_GROUP" ("USER_ID","AUTH_GROUP_ID") values ('111','1329901465855408487');
INSERT INTO "TBL_USER_GROUP" ("USER_ID","AUTH_GROUP_ID") values ('111','9140679012041439197');
INSERT INTO "TBL_USER_GROUP" ("USER_ID","AUTH_GROUP_ID") values ('111','8925031671308011985');
INSERT INTO "TBL_USER_GROUP" ("USER_ID","AUTH_GROUP_ID") values ('112','9140679012041439197');
INSERT INTO "TBL_USER_GROUP" ("USER_ID","AUTH_GROUP_ID") values ('112','8925031671308011985');
INSERT INTO "TBL_USER_GROUP" ("USER_ID","AUTH_GROUP_ID") values ('113','9140679012041439197');
INSERT INTO "TBL_USER_GROUP" ("USER_ID","AUTH_GROUP_ID") values ('113','8925031671308011985');
COMMIT;
create table t_or_expansion_1(f1 int,f2 int,f3 number,f4 varchar(40) not null,f5 timestamp);
insert into t_or_expansion_1 values(1,1,100.123,'abc',to_timestamp(to_char('1800-03-05 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
insert into t_or_expansion_1 values(10,null,null,'M',null);
create table t_or_expansion_2(f1 int,f2 int,f3 number,f4 varchar(10) not null,f5 timestamp);
insert into t_or_expansion_2 values(1,1,100.123,'abc',to_timestamp(to_char('1801-03-05 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
Declare
i int;
j int;
k timestamp;
begin
 i := 1;
loop
 j := 1;
 loop
	k := ADD_MONTHS(to_timestamp(to_char('1800-03-05 10:51:47'),'yyyy-mm-dd hh24:mi:ss'), j);
	insert into t_or_expansion_1 values(i, j, 100.123 + j, 'abc' || j, k);
	j := j + 1;
 exit when j > 10;
 end loop;
i := i+1;
 exit when i>5;
end loop;
 commit;
 end;
/

create index ind_or_expand_11 on t_or_expansion_1(f1, f2);
analyze table t_or_expansion_1 compute statistics;

SELECT
  1
FROM
  (TBL_USER_GROUP AS REF_0)
    INNER JOIN (T_OR_EXPANSION_1 AS REF_1)
    ON (REF_1.F5 <= REF_1.F5)
START WITH ((SELECT MAX(F5) FROM T_OR_EXPANSION_2) != CASE WHEN
          CAST('397CE349D5F58FC1' AS VARBINARY(100)) BETWEEN
          '0' AND
          NULL
        THEN
          REF_1.F5
        ELSE
          REF_1.F5
        END)
  CONNECT BY  PRIOR REF_1.F1 = REF_1.F2   ;
drop table t_or_expansion_1;
drop table t_or_expansion_2;
drop table "TBL_USER_GROUP";

drop table if exists connect_by_mtrl_t;
create table connect_by_mtrl_t(c_id int, c_d_id int, c_first varchar(20), c_balance number(12,3));
insert into connect_by_mtrl_t values(1,2,'test1',123.456);
insert into connect_by_mtrl_t values(2,4,'test2',345.123);
insert into connect_by_mtrl_t values(3,6,'test3',9.201);
insert into connect_by_mtrl_t values(4,8,'test4',33.333);
insert into connect_by_mtrl_t values(5,10,'test5',22.222);
commit;

select
  subq_0.c1 as c0
from
  (select
        cast('2021-05-08 23:29:54' as timestamp(6) with local time zone) as c0,
        case when ref_0.c_balance < 20 then null else null end as c1
      from
        (select c_id, c_d_id, c_balance from connect_by_mtrl_t order by 1 limit 5) as ref_0
      where true
    ) as subq_0
connect by subq_0.c1 = prior subq_0.c0
order by 1 desc;
drop table connect_by_mtrl_t;

drop table if exists t_con_by_strength_base;
create table t_con_by_strength_base(EMPNO NUMBER(4),ENAME VARCHAR2(10),MGR NUMBER(4));
insert into t_con_by_strength_base values (1,'M',NULL);
insert into t_con_by_strength_base values (2,'N',NULL);
insert into t_con_by_strength_base values (3,'A',NULL);
insert into t_con_by_strength_base values (4,'C',3);
insert into t_con_by_strength_base values (null,'C',3);
insert into t_con_by_strength_base values (5,'B',3);
insert into t_con_by_strength_base values (6,'F',4);
insert into t_con_by_strength_base values (7,'E',4);
insert into t_con_by_strength_base values (8,'D',5);
insert into t_con_by_strength_base values (9,'G',5);
insert into t_con_by_strength_base values (10,'H',5);
insert into t_con_by_strength_base values (12,'I',2);
insert into t_con_by_strength_base values (13,'I',2);
insert into t_con_by_strength_base values (14,'J',15);
commit;
create index idx_con_by_strength_base_01 on t_con_by_strength_base(EMPNO);
create index idx_con_by_strength_base_02 on t_con_by_strength_base(EMPNO,ENAME);
create index idx_con_by_strength_base_03 on t_con_by_strength_base(MGR);

select t2.EMPNO,t3.EMPNO from t_con_by_strength_base t1 left join t_con_by_strength_base t2 on t1.EMPNO=t2.EMPNO full join t_con_by_strength_base t3 on to_char(t1.EMPNO)=to_char(t3.EMPNO) inner join t_con_by_strength_base t4 on t2.EMPNO>t4.MGR+4
start with t2.EMPNO=14 connect by nocycle t1.MGR not in(select t3.EMPNO+1 from dual) order by 1;
drop table t_con_by_strength_base;