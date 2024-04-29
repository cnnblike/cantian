-- DTS2018011101030 

conn sys/sys@127.0.0.1:1611
drop user if exists user_a;
drop user if exists user_b;
create user user_a identified by password_a;
create user user_b identified by password_b;

-- user_a.t1 has 1 row
conn user_a/password_a@127.0.0.1:1611
drop table if exists t1;
create table t1 (f_int1 int);
delete from t1;
insert into t1 (f_int1) values (9999);
commit;

-- user_b.t1 has 0 row
conn user_b/password_b@127.0.0.1:1611
drop table if exists t1;
create table t1 (f_int1 int);
delete from t1;
commit;

-- execute same SQL in different user
conn user_a/password_a@127.0.0.1:1611

-- expect 9999
select f_int1 from t1;
-- expect 1
select 1 from dual;


conn user_b/password_b@127.0.0.1:1611
select f_int1 from t1;
select 1 from dual;

conn sys/sys@127.0.0.1:1611
