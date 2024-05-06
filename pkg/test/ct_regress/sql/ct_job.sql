--
-- gs_job
-- testing job
--

set serveroutput on;

show parameter JOB_QUEUE_PROCESSES;
alter system set JOB_QUEUE_PROCESSES=201 scope = both;
alter system set JOB_QUEUE_PROCESSES=0   scope = both;
alter system set JOB_QUEUE_PROCESSES=200 scope = both;
show parameter JOB_QUEUE_PROCESSES;
alter system set JOB_QUEUE_PROCESSES=1 scope = both;
show parameter JOB_QUEUE_PROCESSES;
alter system set JOB_QUEUE_PROCESSES=100 scope = both;
show parameter JOB_QUEUE_PROCESSES;
alter system set JOB_QUEUE_PROCESSES=' ' scope = both;


drop user if exists gs_job cascade;
drop user if exists gs_job1 cascade;
create user gs_job identified by gs_job123;
grant execute on dbe_task to gs_job;
grant dba to gs_job;
create user gs_job1 identified by gs_job123;
grant execute on dbe_task to gs_job1;
grant dba to gs_job1;
conn gs_job/gs_job123@127.0.0.1:1611

select JOB,LOG_USER,INTERVAL_TIME,WHAT,BROKEN from user_jobs order by job;

drop table if exists test_job;

create table test_job(
 id varchar2(30),
 dt varchar2(30)
);

create or replace procedure job_proce_t is
begin
 insert into test_job(id, dt) values('1', to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
 commit;
end job_proce_t;
/


declare
 jobno number;
begin
 DBE_TASK.SUBMIT(jobno,'begin job_proce_t();end;', sysdate, 'sysdate+0.2/24/60');
 commit;
end;
/

select LOG_USER,INTERVAL_TIME,WHAT,BROKEN from user_jobs order by job;

select sleep(8);
select count(*) from test_job;

select sleep(10);
select count(*) from test_job;
conn sys/Huawei@123@127.0.0.1:1611
grant select on sys.SYS_JOBS to gs_job;
conn gs_job/gs_job123@127.0.0.1:1611

declare
jobno int;
begin
 select job into jobno from sys.SYS_JOBS where what='begin job_proce_t();end;';
--expect success 
 DBE_TASK.CANCEL(jobno);
 commit;
end;
/

declare
 jobno number;
begin
 DBE_TASK.SUBMIT(jobno,'proce_t();', sysdate);
 commit;
end;
/

declare
 jobno number;
begin
 DBE_TASK.SUBMIT(jobno,'', sysdate);
 commit;
end;
/


declare
 jobno number;
begin
 DBE_TASK.SUBMIT(jobno,'job_proce_t();', sysdate, , false);
 commit;
end;
/

declare
 jobno number;
begin
 DBE_TASK.SUBMIT(jobno,'job_proce_t()', sysdate, 'sysdate+1/24/60');
 commit;
end;
/

declare
 jobno number;
begin
 DBE_TASK.SUBMIT(jobno,'job_proce_t();', sysdate, 'sysdate+1/24/60');
 commit;
end;
/

conn sys/Huawei@123@127.0.0.1:1611
grant select on sys.SYS_JOBS to gs_job1;
conn gs_job1/gs_job123@127.0.0.1:1611
declare
jobno int;
begin
 select job into jobno from sys.SYS_JOBS where what='job_proce_t();';
 DBE_TASK.SUSPEND(jobno, true, sysdate);
 commit;
end;
/

conn sys/Huawei@123@127.0.0.1:1611
declare
jobno int;
begin
 select job into jobno from sys.SYS_JOBS where what='job_proce_t();';
 DBE_TASK.SUSPEND(jobno, true, sysdate);
 commit;
end;
/

conn gs_job/gs_job123@127.0.0.1:1611
declare
jobno int;
begin
 select job into jobno from sys.SYS_JOBS where what='job_proce_t();';
 DBE_TASK.SUSPEND(jobno, true, sysdate);
 commit;
end;
/

--expect error
begin
 DBE_TASK.SUSPEND(2000, true, sysdate);
 commit;
end;
/


select LOG_USER,INTERVAL_TIME,WHAT,BROKEN from user_jobs order by job;
declare
jobno int;
begin
 select job into jobno from sys.SYS_JOBS where what='job_proce_t();';
 DBE_TASK.SUSPEND(jobno, false, sysdate);
 commit;
end;
/

select LOG_USER,INTERVAL_TIME,WHAT,BROKEN from user_jobs order by job;

conn gs_job1/gs_job123@127.0.0.1:1611
declare
jobno int;
begin
 select job into jobno from sys.SYS_JOBS where what='job_proce_t();';
 DBE_TASK.run(jobno);
 commit;
end;
/

conn gs_job/gs_job123@127.0.0.1:1611
declare
jobno int;
begin
 select job into jobno from sys.SYS_JOBS where what='job_proce_t();';
 DBE_TASK.run(jobno);
 commit;
end;
/

begin
 DBE_TASK.run(2000);
 commit;
end;
/
select LOG_USER,INTERVAL_TIME,WHAT,BROKEN from user_jobs order by job;

declare
 jobno number;
begin
 DBE_TASK.SUBMIT(jobno,'job_proce_t();', to_date('2016-12-11','YYYY-MM-DD'), 'to_date(''2016-12-11'',''YYYY-MM-DD'')');
 commit;
end;
/


conn gs_job/gs_job123@127.0.0.1:1611
declare
jobno int;
begin
 select job into jobno from sys.SYS_JOBS where what='job_proce_t();';
--expect success 
 DBE_TASK.CANCEL(jobno);
 commit;
end;
/

declare
 jobno number;
begin
 DBE_TASK.SUBMIT(jobno,'job_proce_t();', sysdate, 'sysdate+0.5/24/60');
 commit;
end;
/

conn gs_job1/gs_job123@127.0.0.1:1611
declare
jobno int;
begin
 select job into jobno from sys.SYS_JOBS where what='job_proce_t();';
 DBE_TASK.CANCEL(jobno);
 commit;
end;
/

conn sys/Huawei@123@127.0.0.1:1611
declare
jobno int;
begin
 select job into jobno from sys.SYS_JOBS where what='job_proce_t();';
 DBE_TASK.CANCEL(jobno);
 commit;
end;
/


begin
 DBE_TASK.CANCEL(2000);
 commit;
end;
/

select LOG_USER,INTERVAL_TIME,WHAT,BROKEN from dba_jobs order by 1,2,3;

--test drop user and job
--begin
drop table if exists test_job;
create table test_job(
 id varchar2(30),
 dt varchar2(30)
);

create or replace procedure job_proce_t is
begin
 insert into test_job(id, dt) values('1', to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
 commit;
end job_proce_t;
/
grant EXECUTE on job_proce_t to gs_job;
conn gs_job/gs_job123@127.0.0.1:1611

declare
 jobno number;
begin
 DBE_TASK.SUBMIT(jobno,'begin sys.job_proce_t();end;', sysdate+1/24, 'sysdate+0.5/24/60');
 commit;
end;
/

--expect 1
select LOG_USER,INTERVAL_TIME,WHAT,BROKEN from dba_jobs WHERE LOG_USER='GS_JOB';
conn sys/Huawei@123@127.0.0.1:1611
select sleep(3);
drop user if exists gs_job cascade;
--expect 0
select LOG_USER,INTERVAL_TIME,WHAT,BROKEN from dba_jobs WHERE LOG_USER='GS_JOB';
--end


--test use other user to access objects
--begin
DROP USER IF EXISTS JOB_USER_1 CASCADE;
DROP USER IF EXISTS JOB_USER_2 CASCADE;

create  user JOB_USER_1 IDENTIFIED BY DATABASE_123 PASSWORD EXPIRE;
create  user JOB_USER_2 IDENTIFIED BY DATABASE_123 PASSWORD EXPIRE;
grant dba to JOB_USER_1;
grant dba to JOB_USER_2;
drop table if exists JOB_USER_1.JOB_TAB_1;
drop table if exists JOB_USER_2.JOB_TAB_2;

create table JOB_USER_1.JOB_TAB_1 
(
c_int int,
c_number number,
c_varchar varchar(4000),
c_date date
);
insert into JOB_USER_1.JOB_TAB_1 values (1,1.25,'abcd','2015-5-5');
insert into JOB_USER_1.JOB_TAB_1 values (2,2.25,'hello','2016-6-6');
insert into JOB_USER_1.JOB_TAB_1 values (2,2.25,lpad('ab',75,'c'),'2017-7-7');
commit;

create table JOB_USER_2.JOB_TAB_2 
(
c_int int,
c_number number,
c_varchar varchar(4000),
c_date date
);
insert into  JOB_USER_2.JOB_TAB_2 values (1,1.12345,'aaa','2015-5-5');
insert into  JOB_USER_2.JOB_TAB_2 values (2,2.12345,'shengming','2016-6-6');
insert into  JOB_USER_2.JOB_TAB_2 values (2,2.25,lpad('ab',8,'c'),'2017-7-7');
commit;

CREATE OR REPLACE PROCEDURE  JOB_USER_1.JOB_PROC_1(b_int in int,b_date  in date )
IS
b_bigint bigint:=0;
c_cur1 date :='2016-6-6';
v_refcur1 sys_refcursor;
type tcur IS REF CURSOR;
v_refcur2 tcur;
b_temp int :=15;
b_sql varchar(2000);
cursor c_data(d_id int) is  select a.c_int from JOB_USER_1.JOB_TAB_1 as a  join  JOB_USER_2.JOB_TAB_2 as b  where a.c_int =b.c_int and a.c_int<=d_id;
c_row c_data%rowtype;
BEGIN  
OPEN c_data(3);      
   FETCH c_data INTO c_row;  
   if c_data%found then
			execute immediate 'insert into  JOB_USER_2.JOB_TAB_2 values(:1,1.12345,''aaa'',:3) ' using  b_int,b_date;	
    end if; 
	close c_data;
	commit;
END;
/


CREATE OR REPLACE PROCEDURE  JOB_USER_2.JOB_PROC_2()
IS
b_temp int :=1;
m int :=-3;
k int :=-3;
b_varchar varchar(45);
BEGIN  
	JOB_USER_1.JOB_PROC_1(14,'2000-2-2');
   insert into  JOB_USER_2.JOB_TAB_2 values(11,1.12345,'loop','2015-5-5');
   update JOB_USER_1.JOB_TAB_1  set c_varchar='for loop';
   commit;
END;
/


declare
JOBNO number;
begin
 DBE_TASK.SUBMIT(JOBNO,'JOB_USER_2.JOB_PROC_2();', SYSDATE);
 COMMIT;
end;
/

select sleep(10);
select * from JOB_USER_1.JOB_TAB_1 order by 1,2,3,4 ;
select * from JOB_USER_2.JOB_TAB_2  order by 1,2,3,4 ;
--end

--begin
CREATE OR  REPLACE PROCEDURE test_sleep_job(a int) 
IS
BEGIN
	for i in 1..10000 loop
		sleep(1);
	end loop;
EXCEPTION
	WHEN OTHERS THEN
	  NULL;
END;
/


declare
 jobno number;
begin
 DBE_TASK.SUBMIT(jobno,'begin test_sleep_job(1);end;', sysdate);
 commit;
end;
/

select sleep(3);

--expect JOB
select type from v$session a, dba_jobs_running b, sys.SYS_JOBS c where b.sid=a.sid and b.serial#=a.serial# and c.job = b.job 
and c.what = 'begin test_sleep_job(1);end;';

declare
jobno int;
sid1   int;
serial_id int;
sql    varchar(256);
begin
 select job into jobno from sys.SYS_JOBS where what='begin test_sleep_job(1);end;';
 DBE_TASK.CANCEL(jobno);
 commit;
 
 select sid, serial# into sid1, serial_id from dba_jobs_running where job=jobno;
 sql := 'alter system kill session '''||sid1||','||serial_id||'''';
 --dbe_output.print_line(sql);
 execute immediate sql;
end;
/

select sleep(5);
select count(*) from dba_jobs_running where failures is null;
--end


--test job datatype DTS2019011602741
--begin
declare 
jobno int;
begin 
DBE_TASK.SUBMIT(jobno,' begin sleep(1);end;',sysdate);
end;
/

declare 
jobno double;
begin 
DBE_TASK.SUBMIT(jobno,' begin sleep(1);end;',sysdate);
end;
/

declare 
jobno number;
begin 
DBE_TASK.SUBMIT(jobno,' begin sleep(1);end;',sysdate);
end;
/

declare 
jobno real;
begin 
DBE_TASK.SUBMIT(jobno,' begin sleep(1);end;',sysdate);
end;
/

declare 
jobno float;
begin 
DBE_TASK.SUBMIT(jobno,' begin sleep(1);end;',sysdate);
end;
/

declare 
jobno char;
begin 
DBE_TASK.SUBMIT(jobno,' begin sleep(1);end;',sysdate);
end;
/

declare 
jobno varchar(10);
begin 
DBE_TASK.SUBMIT(jobno,' begin sleep(1);end;',sysdate);
end;
/

declare 
jobno clob;
begin 
DBE_TASK.SUBMIT(jobno,' begin sleep(1);end;',sysdate);
end;
/

declare 
jobno number(2);
begin 
DBE_TASK.SUBMIT(jobno,' begin sleep(1);end;',sysdate);
end;
/

declare 
jobno nchar(10) 
begin 
DBE_TASK.SUBMIT(jobno,' begin sleep(1);end;',sysdate);
end;
/

declare 
jobno IMAGE;
begin 
DBE_TASK.SUBMIT(jobno,' begin sleep(1);end;',sysdate);
end;
/
--end

--begin DTS2019012207187
create or replace procedure abc
as
b_number number;
begin
select 1 into b_number from dual;
end;
/

declare
jobno1 number;
begin
DBE_TASK.SUBMIT(jobno1,'abc();',sysdate,'sysdate+1/24');
commit;
end;
/

declare
jobno int;
begin
 select job into jobno from sys.SYS_JOBS where what='abc();';
 DBE_TASK.CANCEL(jobno);
 commit; 
end;
/
--end

--begin
--expect success
declare 
  I_L_JOBNO integer;
  i_x integer := 30;
begin
  DBE_TASK.SUBMIT(I_L_JOBNO, 'begin sleep(1);end;', SYSDATE+10/24, 'SYSDATE + ' || i_x || '/1440');
end;
/
--end

--begin
--expect error
declare
I_L_JOBNO number;
begin
  DBE_TASK.SUBMIT(I_L_JOBNO, ' ', SYSDATE+10/24, 'SYSDATE + 1/1440');
  commit;
end;
/

--expect error
declare
I_L_JOBNO number;
begin
  DBE_TASK.SUBMIT(I_L_JOBNO, 'begin test_sleep(2);end;', SYSDATE+10/24, ' ');
  commit;
end;
/
--end

--test case: fuzz test
--step1:DBE_TASK.SUBMIT
declare
I_L_JOBNO number;
begin
  DBE_TASK.SUBMIT(I_L_JOBNO, 'begin sleep(2);end;', SYSDATE+10/24, null, null);
  rollback;
end;
/

declare
I_L_JOBNO number;
begin
  DBE_TASK.SUBMIT(I_L_JOBNO, 'begin sleep(2);end;', SYSDATE+10/24, null, '');
  rollback;
end;
/

declare
I_L_JOBNO number;
begin
  DBE_TASK.SUBMIT(I_L_JOBNO, 'begin sleep(2);end;', SYSDATE+10/24, null, null);
  rollback;
end;
/

declare
I_L_JOBNO number;
begin
  DBE_TASK.SUBMIT(I_L_JOBNO, 'begin sleep(2);end;', SYSDATE+10/24, '');
  rollback;
end;
/

declare
I_L_JOBNO number;
begin
  DBE_TASK.SUBMIT(I_L_JOBNO, 'begin sleep(2);end;', SYSDATE+10/24, null);
  rollback;
end;
/

declare
I_L_JOBNO number;
begin
  DBE_TASK.SUBMIT(I_L_JOBNO, 'begin sleep(2);end;', SYSDATE+10/24);
  rollback;
end;
/

declare
I_L_JOBNO number;
begin
  DBE_TASK.SUBMIT(I_L_JOBNO, 'begin sleep(2);end;', SYSDATE+10/24,);
  rollback;
end;
/


declare
I_L_JOBNO number;
begin
  DBE_TASK.SUBMIT(I_L_JOBNO, 'begin sleep(2);end;', null, ' SYSDATE + 1/1440');
  rollback;
end;
/


declare
I_L_JOBNO number;
begin
  DBE_TASK.SUBMIT(I_L_JOBNO, 'begin sleep(2);end;', '', ' SYSDATE + 1/1440');
  rollback;
end;
/

declare
I_L_JOBNO number;
begin
  DBE_TASK.SUBMIT(I_L_JOBNO, '', sysdate, ' SYSDATE + 1/1440');
  rollback;
end;
/

declare
I_L_JOBNO number;
begin
  DBE_TASK.SUBMIT(I_L_JOBNO, null, sysdate, ' SYSDATE + 1/1440');
  rollback;
end;
/

declare
I_L_JOBNO number;
begin
  DBE_TASK.SUBMIT(null, 'begin sleep(2);end;', sysdate, ' SYSDATE + 1/1440');
  rollback;
end;
/

declare
I_L_JOBNO number;
begin
  DBE_TASK.SUBMIT('', 'begin sleep(2);end;', sysdate, ' SYSDATE + 1/1440');
  rollback;
end;
/

declare
I_L_JOBNO char;
begin
  DBE_TASK.SUBMIT(I_L_JOBNO, 'begin sleep(2);end;', sysdate, ' SYSDATE + 1/1440');
  rollback;
end;
/

declare
I_L_JOBNO char;
begin
  DBE_TASK.SUBMIT(upper(I_L_JOBNO), 'begin sleep(2);end;', sysdate, ' SYSDATE + 1/1440');
  rollback;
end;
/

declare
I_L_JOBNO char;
begin
  DBE_TASK.SUBMIT(to_number(I_L_JOBNO), 'begin sleep(2);end;', sysdate, ' SYSDATE + 1/1440');
  rollback;
end;
/

--step2:DBE_TASK.SUSPEND
begin
 DBE_TASK.SUSPEND(1001, null);
 rollback;
end;
/

begin
 DBE_TASK.SUSPEND(1001, '');
 rollback;
end;
/

begin
 DBE_TASK.SUSPEND(null, true);
 rollback;
end;
/

begin
 DBE_TASK.SUSPEND('', true);
 rollback;
end;
/

begin
 DBE_TASK.SUSPEND("", true);
 rollback;
end;
/
begin
 DBE_TASK.SUSPEND(1001, true,null);
 rollback;
end;
/
begin
 DBE_TASK.SUSPEND(1001, true,'');
 rollback;
end;
/
--step3:DBE_TASK.run
begin
 DBE_TASK.run(1001, '');
 rollback;
end;
/
begin
 DBE_TASK.run(1001, null);
 rollback;
end;
/
begin
 DBE_TASK.run(null, '');
 rollback;
end;
/
declare
jobno number := null;
begin
 DBE_TASK.run(jobno, '');
 rollback;
end;
/
declare
jobno number;
begin
 DBE_TASK.run(jobno, '');
 rollback;
end;
/
--step4: remove
declare
jobno number;
begin
 DBE_TASK.CANCEL(jobno);
 rollback;
end;
/

declare
jobno number:=null;
begin
 DBE_TASK.CANCEL(jobno);
 rollback;
end;
/

drop table if exists job_t111;
create table job_t111(a int);
insert into job_t111 values(100);
commit;

create or replace procedure job_p11 is
h1 int;
h2 int := 100;
begin
 select * into h1 from job_t111 where a = h2;
 execute immediate 'drop table job_t111';
 execute immediate 'create table job_t111(a int)';
 insert into job_t111 values(200);
 h2 := 200;
 select * into h1 from job_t111 where a = h2;
end;
/

declare
JOBNO int;
begin
DBE_TASK.SUBMIT(JOBNO,'job_p11();', SYSDATE, 'sysdate + 1/24');
commit;
sleep(1);
DBE_TASK.SUSPEND(jobno, true, sysdate);
DBE_TASK.CANCEL(JOBNO);
commit;
end;
/

create or replace procedure job_test_core is
h1 int;
h2 int := 100;
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE IF EXISTS job_tt1';
    EXECUTE IMMEDIATE 'CREATE job_tt1(a int)';
    EXECUTE IMMEDIATE 'insert into job_tt1 values(10),(20)';
    EXECUTE IMMEDIATE 'DROP TABLE IF EXISTS job_tt2';
    EXECUTE IMMEDIATE 'CREATE TABLE job_tt2 AS SELECT * FROM job_tt1';
    EXECUTE IMMEDIATE 'ALTER SESSION SET TIME_ZONE = ''8:00''';
END;
/

declare
JOBNO int;
begin
DBE_TASK.SUBMIT(JOBNO,'job_test_core();', SYSDATE, 'sysdate + 1/24');
commit;
sleep(1);
DBE_TASK.SUSPEND(jobno, true, sysdate);
DBE_TASK.CANCEL(JOBNO);
commit;
end;
/

--job upper zh
set charset gbk;
drop table if exists t_job_upper;
create table t_job_upper(id int,name varchar(20));
insert into t_job_upper values(1,'你好');
insert into t_job_upper values(1,'hello');
insert into t_job_upper values(1,'你好');
insert into t_job_upper values(1,'你好');
insert into t_job_upper values(1,'中国');
insert into t_job_upper values(1,'你好');
commit;

drop index if exists t_job_upper_idx on t_job_upper;
create index t_job_upper_idx on t_job_upper (upper(name));

create or replace procedure pl_t_job_upper()
as
begin
	dbe_stats.collect_table_stats('sys',('t_job_upper'),sample_ratio=>100);
	
end;
/

declare
jobno number;
begin
	DBE_TASK.SUBMIT(jobno, 'pl_t_job_upper();', sysdate, null);
end;
/

drop procedure pl_t_job_upper;
drop index t_job_upper_idx on t_job_upper;
drop table t_job_upper;
set charset utf8;

--DTS2020022814368
DROP TABLE if exists t16941;
create table t16941 (f1 int, f2 VARCHAR2(10), f3 VARCHAR2(10));
insert into t16941 values (1,'aa','aa');
create or replace procedure test_job16941
is
c1 sys_refcursor;
type rec is record(a int);
v1 rec;
v2 VARCHAR2(10);
begin
v1.a:=1;
open c1 for 'select f2 from t16941 where f1 = :1' using  v1.a;
fetch c1 into v2;
close c1;
end;
/
declare
 jobno number;
begin
 DBE_TASK.SUBMIT(jobno,'test_job16941();', sysdate, 'sysdate+1/24/60');
 commit;
end;
/
select sleep(10);
declare
jobno int;
begin
 select job into jobno from user_jobs where what='test_job16941();';
 DBE_TASK.CANCEL(jobno);
 commit;
end;
/
drop procedure test_job16941;
drop table t16941;


drop sequence if exists job_myseq;
create sequence job_myseq start with 1;

drop table if exists job_tt1;
create table job_tt1(id int primary key, t date);

create or replace procedure test_dml(name varchar)
is
tmp int;
begin
insert into job_tt1 values(job_myseq.nextval,sysdate);
end;
/

declare
jobno int;
begin
 DBE_TASK.submit(jobno,'test_dml(1);',sysdate+1/24/60/60/10,'sysdate+1/24/60/60/10');
 commit;
end;
/

drop procedure test_dml;
drop table job_tt1;


--execute in the end.
declare
jobid int;
begin
for i in (select job from user_jobs) loop
    dbe_task.cancel(i.job);
end loop;
commit;
end;
/
