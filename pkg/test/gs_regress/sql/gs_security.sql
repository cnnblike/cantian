connect sys/Huawei@123@127.0.0.1:1611
create user user_security_1 identified by Test1234 account lock password expire;
grant dba to user_security_1;
select name, astatus from SYS_USERS where name = 'USER_SECURITY_1';

connect user_security_1/Test1234@127.0.0.1:1611
connect sys/Huawei@123@127.0.0.1:1611
alter user user_security_1  account unlock;
select name, astatus from SYS_USERS where name = 'USER_SECURITY_1';

connect sys/Huawei@123@127.0.0.1:1611
alter user user_security_1  identified by Cantian12345 replace Test12345;
alter user user_security_1  identified by Cantian12345 replace Test1234;
select name, astatus from SYS_USERS where name = 'USER_SECURITY_1';
connect user_security_1/Cantian12345@127.0.0.1:1611

connect user_security_1/Test123456@127.0.0.1:1611
connect user_security_3/Test123456@127.0.0.1:1611
connect user_security_1/Cantian12345@127.0.0.1:1611
connect sys/Huawei@123@127.0.0.1:1611
select name, astatus from SYS_USERS where name = 'USER_SECURITY_1';

connect sys/Huawei@123@127.0.0.1:1611
create user user_security_2 identified by Test1234 account lock;
grant dba to user_security_2;
select name, astatus from SYS_USERS where name = 'USER_SECURITY_2';
connect user_security_2/Test1234@127.0.0.1:1611

connect sys/Huawei@123@127.0.0.1:1611
revoke dba from user_security_1;
revoke dba from user_security_2;
select sleep(2) from dual;
drop user if exists user_security_1 cascade;
drop user if exists user_security_2 cascade;
create user user_lock_1 identified by Test1234 account lock;
grant dba to user_lock_1;

connect user_lock_1/Test1234@127.0.0.1:1611
connect user_lock_1/Cantian12345@127.0.0.1:1611
connect sys/Huawei@123@127.0.0.1:1611
revoke dba from user_lock_1;
select sleep(2) from dual;
drop user if exists user_lock_1 cascade;
conn / as sysdba
alter system set NORMAL_USER_RESERVED_SESSIONS_FACTOR = 1;
alter system set NORMAL_USER_RESERVED_SESSIONS_FACTOR = -1;
alter system set NORMAL_USER_RESERVED_SESSIONS_FACTOR = 0.001;
alter system set NORMAL_USER_RESERVED_SESSIONS_FACTOR = 1.1;
alter system set NORMAL_USER_RESERVED_SESSIONS_FACTOR = 100;
alter system set NORMAL_USER_RESERVED_SESSIONS_FACTOR = 0.999;
alter system set NORMAL_USER_RESERVED_SESSIONS_FACTOR = 1.111;
alter system set NORMAL_USER_RESERVED_SESSIONS_FACTOR = (1 - 0.11);
alter system set NORMAL_USER_RESERVED_SESSIONS_FACTOR = 0;
alter system set NORMAL_USER_RESERVED_SESSIONS_FACTOR = 1;

