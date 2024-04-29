--- the command `exit`, etc. can be used as column names
DROP TABLE IF EXISTS PFA_CMDER_TB1;
CREATE TABLE PFA_CMDER_TB1(
EXIT VARCHAR(100),
LOAD VARCHAR(100),
DUMP VARCHAR(100),
SHOW VARCHAR(100),
spool VARCHAR(100),
conn VARCHAR(100)
);

--- the command `desc` can not be a column name
DROP TABLE IF EXISTS PFA_CMDER_TB2;
CREATE TABLE PFA_CMDER_TB2(
EXIT VARCHAR(100),
DESC NUMBER(20)
);

--- the `semicolon` and `/` will execute the command in SQL buffer
select '12345' as "123" from dual
;
select '12345' as "123" from dual
/
--- after each execution, the SQL buffer is cleaned, then input for `;` and `/`
--- will return an Error with empty buffer
;
/

--- Multi-commands that are serapated by `;` can be executed in one line
--- NOTE: the enclosed `;` will be ignored
desc SYS_TABLES; select 1||';'||1 from dual; select * from dual;
select 'Hello; World!' as "123;" from dual;
desc SYS_TABLES; select * from dual; select cast(systimestamp as number) from dual
/

--- In-line comment `--` is supported, but not for enclosed `--`
DROP TABLE IF EXISTS PFA_CMDER_TB3;
CREATE TABLE PFA_CMDER_TB3( ---123123
inline VARCHAR(100)   --- 123123
);  --123123

select 'Hello world' as "123;--hhggffddss" from dual -- hello
/

select '--Hello world' as "--hhggffddss" from dual -- hello
;

select 'Hello World!'  -- comment from dual;  
from
dual
/

desc
desc a.b
desc a.b.c
desc a.b.c.d
desc a.b.c.d.e

desc dual
desc -o dual
desc DUAL

-- invalid desc case
desc abc123.dual
desc abc123  .  dual
desc abc%sdgsdfgsdgasfdasfdafdsafgdsafdsafdsafdsagdsafdasfdsasfdasfdasdffsdgfsdfg123  .  dual
desc .SYS_TABLES
desc sys.SYS_TABLES.dual
desc  sys.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
desc  sys.
desc -o sys.

-- desc -q
desc -q select trunc(systimestamp(2)), trunc('123') from dual;
desc -q select * from dual;

desc -q with cte1 as (select * from  all_tables) select count(*) from cte1;
desc -q with1 cte1 as (select * from  all_tables) select count(*) from cte1;
desc -q select* from dual;
desc -q selectx * from dual;

desc -q commit;
desc -q create table OMyGod as select * from all_tables;

drop table if exists t1;
drop view  if exists v1;
drop view  if exists v2;
create table t1(a int not null);
create view v1 as select * from t1;
desc v1
drop table t1;
create table t1(a char(8));
desc v1
create view v2 as select * from v1;
desc v2

drop table if exists t1;
drop view  if exists v1;
drop view  if exists v2;
create table t1(a int);
create view v1 as select * from t1;
desc v1
drop table t1;
create table t1(a char(8));
desc v1
create view v2 as select * from v1;
desc v2

drop user if exists desc_user1;
create user desc_user1 IDENTIFIED by 'desc_user123';
grant create session to desc_user1;
grant create table to desc_user1;
grant create sequence to desc_user1;

drop user if exists desc_user2;
create user desc_user2 IDENTIFIED by 'desc_user123';
grant create session to desc_user2;
grant create table to desc_user2;
grant create sequence to desc_user2;

CREATE TABLE desc_user1.mytab1 
( 
  dusr1_id  NUMBER NOT NULL, 
  dusr1_name  CHAR(50) NOT NULL,
  dusr1_info  varchar(2000)
);

CREATE TABLE desc_user2.mytab1 
( 
  dusr2_id    NUMBER NOT NULL, 
  dusr2_name  CHAR(50) NOT NULL,
  dusr2_pic   clob
);

desc desc_user1.mytab1;
desc desc_user2.mytab1;

conn desc_user1/desc_user123@127.0.0.1:1611
desc desc_user1.mytab1;
desc mytab1;
desc desc_user2.mytab1;

-- test synonym
desc all_users
desc sys.all_users
desc desc_user1.user_tables;
desc -q select * from all_users;

conn sys/Huawei@123@127.0.0.1:1611

DROP TABLE IF EXISTS `db_test`;
DROP TABLE IF EXISTS "dbtable";

create table `db_test`(a int);
create table "dbtable"(a int);

desc `db_test`;
desc "dbtable"

DROP TABLE IF EXISTS `db_test`;
DROP TABLE IF EXISTS "dbtable";

start ;
@;
@@;

set invalid;
show invalid;
show autocommit;
set autocommit on;
show autocommit;
set autocommit off;
show autocommit;
set autocommit on off;
show autocommit;
show exitcommit;
set exitcommit on;
show exitcommit;
set exitcommit off;
show exitcommit;
set exitcommit on off;
show exitcommit;
set autotrace on;
show autotrace;
set autotrace off;
show autotrace;
set autotrace on off;
show autotrace;
