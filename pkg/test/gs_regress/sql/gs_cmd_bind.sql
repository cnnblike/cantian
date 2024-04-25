spool ./results/gs_cmd_bind.out

drop table if exists tc;
create table tc(i char(10) not null);
insert into tc values('a');
insert into tc values('a ');
insert into tc values('a  ');
insert into tc values('a   ');
insert into tc values('a    ');
insert into tc values('a     ');
commit;
select count(*) from tc where i = ?;
in
string
a         
drop table tc;

-- Error case
select ? from dual;
in
INTEGER UNSIGNED
1

select 1+?;
in
int
2147483648

select ?;
in
double
1.79769313486232E+308

select ?;
in
bigint
9223372036854775808

select * from dual where 1=:p;
in
invalid_datatype

select * from dual where 1=:p;
in
int
1

select * from dual where 1=:p;
in
int
na

select * from dual where 1=:p;
in
double
nan

select cast(:p as number) from dual;
in
double
nan

select cast(:p as number) from dual;
in
double
inf

select cast(:p as number) from dual;
in
double
-inf

select :p * 0.3323 from dual;
in
double
nan

select * from dual where 1=:p;
in
real
1.0

select * from dual where 1=:p;
in
real
100.0E-2

select * from dual where 1 < :p;
in
real
100.000010E-2

select * from dual where 1 < :p;
in
real
100.000010E-2.0

select * from dual where 1 < :p;
in
decimal
100.000010E-2


select * from dual where 1 < :p;
in
decimal
100.00001.0E-2

select * from dual where :1 < :2;
in
number
100.000010E-2
in
number
1000.001E-3

select * from dual where :1 < :2;
in
number2
100.000010E-2
in
number2
1000.001E-3

select * from dual where 1 < :p;
in
string
100.000010E-2

select * from dual where :p = true;
in
bool
1

select * from dual where :p = true;
in
bool
0

select * from dual where :p = true;
in
bool
1

select * from dual where :1||:2 > 100;
in
int
2
in
string
00

select * from dual where :1||:2 > 100;
in
int
2
in
int
00

select * from dual where :1 > 100;
in
int
2.00

select * from dual where :1 > 100;
in
bigint
2.00

select * from dual where :1 > 100;
in
bigint
20000000000

select * from dual where :1 > 100;
in
bigint
-2000000000000000000000

select * from dual where :1||:2 > 100;
in
decimal
0.333333333333333333333333333333333
in
string
E+99

select * from dual where :1 > 100;
in
decimal
1E3

select * from dual where rowid = :1;
in
int
100000

select * from dual where rowid = :1;
in
string
000333444555666

select * from dual where rowid::decimal < 123||:1;
in
string
E100

select * from dual where systimestamp < :1;
in
timestamp
2000-01-01

select * from dual where systimestamp > :1;
in
timestamp
2000-01-01 13:12:16.2323

select * from dual where systimestamp > :1;
in
timestamp
'2000-01-01 13:12:16.2323'

select * from dual where systimestamp > :1;
in
string
2000-01-01 13:12:16.2323

select * from dual where systimestamp > :1;
in
string
'2000-01-01 13:12:16.2323'


alter session set nls_date_format = 'YYYY/MM/DD HH24:MI:SS';
select * from dual where sysdate > :1;
in
string
2012/12/13 15:16:17

select * from dual where sysdate > :1;
in
date
2012/12/13 15:16:17

-- format error
select * from dual where sysdate > :1;
in
string
2012-12-13 15:16:17

select * from dual where sysdate > :1;
in
date
2012-12-13 15:16:17


alter session set nls_timestamp_format = 'YYYY/MM/DD HH24:MI:SS.FF';
select * from dual where cast(systimestamp as timestamp) > :1;
in
string
2012/12/13 15:16:17

select * from dual where systimestamp > :1;
in
timestamp
2012/12/13 15:16:17

-- format error
select * from dual where cast(systimestamp as timestamp) > :1;
in
string
2012-12-13 15:16:17

select * from dual where systimestamp > :1;
in
timestamp
2012-12-13 15:16:17


alter session set nls_timestamp_tz_format = 'YYYY/MM/DD HH24:MI:SS.FF TZH:TZM';
select * from dual where systimestamp > :1;
in
string
2012/12/13 15:16:17.636363 -3:00

-- format error
select * from dual where systimestamp > :1;
in
string
2012-12-13 15:16:17.636363 -3:00

alter session set nls_timestamp_tz_format = 'YYYY-MM-DD HH24:MI:SS.FF TZH:TZM';
select * from dual where systimestamp > :1;
in
string
2012/12/13 15:16:17.636363 -3:00

-- format right
select * from dual where systimestamp > :1;
in
string
2012-12-13 15:16:17.636363 -3:00


select '123123:1' from dual where ? = 1;
in
real
1.0000000000000000000000000000000001

select '123123:1' from dual where ? = 1;
in
decimal
1.0000000000000000000000000000000001

select '123123:1' from dual where ? = 1;
in
number2
1.0000000000000000000000000000000001

alter session set nls_timestamp_format = 'YYYY-MM-DD HH24:MI:SS.FF';
SELECT 1 from dual where UNIX_TIMESTAMP(:1) > 1000000000;
in
string
2017-01-01 00:00:00

select '123123:1' -- comment 1
-- comment 2
from dual 
-- comment 3
where ? = 1;
in
number
1.0000000000000000000000000000000001


select '123123:1' from dual where : = :;
in
bigint
2
in
real
2.0000000000000000000000000E+00000000000000000000

select '123123:1' as "PARAM:1" /* comment begin
-- comment 2

commeent end */
from dual 
-- comment 3
where ? >= 1::decimal;
in
number
1.0000000000000000000000000000000001

-- error datatype or unsupported type
select * from dual where :p = true;
in
boolaen

select * from dual where systimestamp > :1;
in
binary

-- the binding paramters are not allowed in select list
select :1 from dual;

select '123123:1' from dual where ?11 = :;

-- invalid case, value is too long
select * from dual where :p = true;
in
int
0000000000000000000000000000000000000000000000000000000000000000000000000000000000001

/

select * from dual where :p = true;
in
string
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000001

/

select * from dual where :p = 1;
in
string
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001

/

-- test select clause bind
select abs(:p1 + :p2 + :p3 + :p4 + :p5) from dual;
in
int
111
in
bigint
222
in
real
333
in
string
444
in
decimal
555

alter session set nls_timestamp_format='yyyy-mm-dd hh24:mi:ss.ff3';
select :p1, :p2, :p3, :p4, :p5 from dual;
in
clob
wjltest1234
in
blob
11155778822901
in
string
zenithbindselet
in
date
2018/07/11 15:02:59
in
timestamp
2018-07-11 15:02:59.539

drop function if exists getoffset;
create or replace function getoffset(v int) return int
is
begin
return 10;
end;
/
select 1 from sys_dummy order by 1 limit getoffset(?);
in
int
1

drop function if exists getoffset;
-- right join + like escape
drop table if exists T_PRIMARY_TERMINAL;
create table T_PRIMARY_TERMINAL
(
	DN int, 
	EIMSI number(10,0), 
	SN number(10,0), 
	PRODUCTMODEL varchar(20), 
	VERSION varchar(20), 
	STATUS varchar(20), 
	ENODEBID int, 
	IP varchar(20)
);
drop table if exists T_MOI_DEVICE_ELTEIOT;
create table T_MOI_DEVICE_ELTEIOT
(
	DN int, 
	EIMSI number(10,0), 
	KIVALUE varchar(20), 
	LOCKSTATUS varchar(20),  
	ALMSTATUS varchar(20),  
	SERIALNUMBER int, 
	DESCRIPTION varchar(20), 
	ARPFID int, 
	IPALLOCTYPE varchar(20),  
	TAUTIMERLEN int,
	IDLE2PSMTIMERLEN number(10,0), 
	PSM2IDLETIMERLEN number(10,0), 
	OFFLINETIMERLEN number(10,0), 
	INACTIVITYTIMERLEN number(10,0), 
	ASSOCIATEDIP varchar(20)
);
insert into T_PRIMARY_TERMINAL values(101, 102, 103, 'PRODUCTMODEL', 'V6R1C00', 'PASSED', 104, '127.0.0.1');
insert into T_PRIMARY_TERMINAL values(111, 112, 113, 'PRODUCTMODEL', 'V6R1C10', 'PASSED', 114, '127.0.0.2');
insert into T_MOI_DEVICE_ELTEIOT values(101, 102, 'KIVALUE', 'OK', 'OK', 123, 'DESCRIPTION', 124, 'IPALLOCTYPE', 125, 125, 125, 125, 125, '127.0.0.1');
commit;
SELECT * FROM ( 
SELECT B.DN, B.EIMSI, B.KIVALUE, B.LOCKSTATUS, B.ALMSTATUS, B.SERIALNUMBER, B.DESCRIPTION, 
B.ARPFID, B.IPALLOCTYPE, B.TAUTIMERLEN, B.IDLE2PSMTIMERLEN, B.PSM2IDLETIMERLEN, B.OFFLINETIMERLEN, 
B.INACTIVITYTIMERLEN, B.ASSOCIATEDIP, A.SN, A.PRODUCTMODEL, A.VERSION, A.STATUS, A.ENODEBID, A.IP 
FROM SYS.T_PRIMARY_TERMINAL A 
RIGHT JOIN 
SYS.T_MOI_DEVICE_ELTEIOT B 
ON A.EIMSI = B.EIMSI AND A.DN = B.DN ) C 
WHERE C.DN = :dn 
AND LOWER(C.VERSION) LIKE LOWER(:version) ESCAPE '\' 
AND LOWER(C.EIMSI) LIKE LOWER(:eimsi) ESCAPE '\' 
AND LOWER(C.PRODUCTMODEL) LIKE LOWER(:productmodel) ESCAPE '\' 
AND LOWER(C.SN) LIKE LOWER(:sn) ESCAPE '\' 
ORDER BY C.EIMSI ASC;
in
int
101
in
string
V6R1C00
in
int
102
in
string
PRODUCTMODEL
in
int
103

-- test bind param char
drop table if exists t_cmd_bind_char;
create table t_cmd_bind_char(f1 char(10));
insert into t_cmd_bind_char values('abc');
select * from t_cmd_bind_char where f1=:p1;
in
char
abc
select * from t_cmd_bind_char where f1=:p1;
in
string
abc
drop table t_cmd_bind_char;

select 1 from sys_dummy where decode('1', '1', ?) = 'aaa ';
in
char
aaa

--20210627
select array_agg(c) from (select ? c from sys_dummy limit 1) ;
in
number
1.23

--DTS2021081013169
drop table if exists test_bindvalue;
create table test_bindvalue(f1 int, f2 clob);
insert into test_bindvalue values(?,?);
in
int
1
in
clob
1234567890aaaaaaaaaa1234567890aaaaaaaaaa1234567890aaaaaaaaaa1234567890aaaaaaaaaa1234567890aaaaaaaaaa1234567890aaaaaaaaaa123456
select lengthb(f2), f2 from test_bindvalue;
insert into test_bindvalue values(?,?);
in
int
1
in
clob
1234567890aaaaaaaaaa1234567890aaaaaaaaaa1234567890aaaaaaaaaa1234567890aaaaaaaaaa1234567890aaaaaaaaaa1234567890aaaaaaaaaa123456789000
;
drop table if exists test_bindvalue;

spool off
