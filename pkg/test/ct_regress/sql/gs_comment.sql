--TEST SYNONYM
create table t1 (fd1 int, fd2 varchar(20));
create user user_123 identified by 'a2345678#$_';
create view user_123.v1 as select * from t1;
create public synonym s_t1 for t1;

comment on table user_123.t1 is 'this is table user_123.t1 comment';
comment on table t3 is 'this is table t3 comment';

comment on table t1 is 'this is table t1 comment';
comment on table user_123.v1 is 'this is view user_123.v1 comment';
alter table t1 rename to t1_new;
comment on table t1_new is '';
drop table t1_new;
drop view user_123.v1;

create table user_123.t2 (fd1 int, fd2 varchar(20));
create view  v2 as select * from user_123.t2;
comment on COLUMN user_123.t4.fd1 is 'this is column user_123.t4.fd1 comment';
comment on COLUMN user_123.t2.fd3 is 'this is column user_123.t2.fd3 comment';

comment on COLUMN user_123.t2.fd1 is 'this is column user_123.t2.fd1 comment';
comment on COLUMN user_123.t2.fd2 is 'this is column user_123.t2.fd2 comment';
comment on COLUMN v2.fd1 is 'this is column v2.fd1 comment';
comment on COLUMN v2.fd2 is 'this is column v2.fd2 comment';
alter table user_123.t2 rename column fd1 to fd3;
alter table user_123.t2 add fd1 int;

alter table user_123.t2 drop column fd3;

drop table user_123.t2;
drop view v2;

drop public SYNONYM if exists s_t1 FORCE;
drop user user_123 CASCADE;

drop user user_1 CASCADE;
create user user_1 identified by 'a2345678#$_';
create table user_1.t1 (fd1 int, fd2 varchar(20));
create view user_1.v1 as select * from user_1.t1;
create public synonym s_t1 for user_1.t1;
comment on table user_1.t1 is 'this is table t1 comment';
comment on table user_1.v1 is 'this is table v1 comment';
comment on COLUMN user_1.t1.fd1 is 'this is column t1.fd1 comment';
comment on COLUMN user_1.v1.fd2 is 'this is column v1.fd2 comment';
select * from DBA_SYNONYMS WHERE OWNER = 'PUBLIC' AND SYNONYM_NAME = 'S_T1';
drop user user_1 CASCADE;
drop public SYNONYM if exists s_t1 FORCE;
select * from DBA_SYNONYMS WHERE OWNER = 'PUBLIC' AND SYNONYM_NAME = 'S_T1';

@@comment.txt