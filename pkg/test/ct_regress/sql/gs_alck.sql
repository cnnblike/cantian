set serveroutput on;
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists gs_alck cascade;
create user gs_alck identified by Lh00420062;
grant all privileges to gs_alck;

conn gs_alck/Lh00420062@127.0.0.1:1611

--this file cannot execute PARALLEL in ct_regress!!!
--FAIL in parsing period
alter database convert to readonly;
select get_lock('alck_test');
select release_lock('alck_test');
select try_get_lock('alck_test');
select release_lock('alck_test');

select get_shared_lock('alck_test');
select release_shared_lock('alck_test');
select try_get_shared_lock('alck_test');
select release_shared_lock('alck_test');

select get_xact_lock('alck_test');
select get_xact_shared_lock('alck_test');
select try_get_xact_lock('alck_test');
select try_get_xact_shared_lock('alck_test');

alter database convert to readwrite;
--success for get soft parse
select get_lock('alck_test');
select release_lock('alck_test');
select try_get_lock('alck_test');
select release_lock('alck_test');

select get_shared_lock('alck_test');
select release_shared_lock('alck_test');
select try_get_shared_lock('alck_test');
select release_shared_lock('alck_test');

select get_xact_lock('alck_test');
select get_xact_shared_lock('alck_test');
select try_get_xact_lock('alck_test');
select try_get_xact_shared_lock('alck_test');

select NAME,type,x_locks,total_locks,ix_setted from dv_all_alocks where name like 'alck%' order by 1,2,3;
select name,type,x_locks,my_locks,total_locks, ix_setted from dv_user_alocks where name like 'alck%' order by 1,2,3;
alter database convert to readonly;
select NAME,type,x_locks,total_locks,ix_setted from dv_all_alocks where name like 'alck%' order by 1,2,3;
select name,type,x_locks,my_locks,total_locks, ix_setted from dv_user_alocks where name like 'alck%' order by 1,2,3;
--FAIL in executing period
select get_lock('alck_test');
select release_lock('alck_test');
select try_get_lock('alck_test');
select release_lock('alck_test');

select get_shared_lock('alck_test');
select release_shared_lock('alck_test');
select try_get_shared_lock('alck_test');
select release_shared_lock('alck_test');

select get_xact_lock('alck_test');
select get_xact_shared_lock('alck_test');
select try_get_xact_lock('alck_test');
select try_get_xact_shared_lock('alck_test');

--restore!!!
alter database convert to readwrite;

create or replace function get_my_locktimes(lock_detail varchar) return int
is
idx int;
pos int :=1;
pos_right int :=0;
pos_space int;
tmp varchar(128); 
res int := 0;
p_idx int :=0;
begin
select sid into idx from dv_me;
loop
pos_right := instr(lock_detail,':',pos);
exit when pos_right = 0;
tmp := substr(lock_detail,pos,pos_right-pos);
if(instr(tmp,'(')>0) then
   tmp :=substr(tmp,1,instr(tmp,')')-1);
   tmp :=substr(tmp,instr(tmp,'(')+1);
end if;
pos := pos_right+1;
pos_right := instr(lock_detail,' ',pos);
if(idx = to_int(tmp)) then
    if(pos_right=0) then
        res := to_int(substr(lock_detail,pos,length(lock_detail)-pos + 1));
    else 
        res := to_int(substr(lock_detail,pos,pos_right-pos));
    end if;
    return res;
end if;
pos := pos_right+1;
end loop;
return res;
end;
/

--test name length
declare
sql1 varchar(200);
tmp int;
begin
for i in 1..129 loop
sql1 := sql1||'a';
end loop;
select get_xact_shared_lock(sql1) into tmp from sys_dummy;
dbe_output.print(tmp);
end;
/

declare
sql1 varchar(200);
tmp int;
begin
for i in 1..129 loop
sql1 := sql1||'a';
end loop;
select get_lock(sql1) into tmp from sys_dummy;
dbe_output.print(tmp);
end;
/

declare
sql1 varchar(200);
tmp int;
begin
for i in 1..129 loop
sql1 := sql1||'a';
end loop;
select get_shared_lock(sql1) into tmp from sys_dummy;
dbe_output.print(tmp);
end;
/

--test dynamic views
declare
sql1 varchar(200);
tmp int;
begin
for i in 1..128 loop
sql1 := sql1||'a';
end loop;
select get_xact_shared_lock(sql1) into tmp from sys_dummy;
dbe_output.print(tmp);
end;
/

select name,type,x_locks,total_locks,get_my_locktimes(lock_detail) from dv_all_alocks where name like 'a%' and get_my_locktimes(lock_detail)>0 order by 1;
select name,type,x_locks,my_locks, total_locks from dv_user_alocks where name like 'a%' order by 1;
rollback;
select name,type,x_locks,total_locks,get_my_locktimes(lock_detail) from dv_all_alocks where name like 'a%' and get_my_locktimes(lock_detail)>0 order by 1;
select name,type,x_locks,my_locks, total_locks from dv_user_alocks where name like 'a%' order by 1;

--test session alck interface
select get_lock('gs_lock_name') from sys_dummy;
select try_get_lock('gs_lock_name') from sys_dummy;
select get_shared_lock('gs_lock_name') from sys_dummy;
select try_get_shared_lock('gs_lock_name') from sys_dummy;

select name,type,x_locks,total_locks,get_my_locktimes(lock_detail) from dv_all_alocks where name like 'gs%' order by 1; 
select name,type,x_locks,my_locks, total_locks from dv_user_alocks where name like 'gs%' order by 1;

select release_lock('gs_lock_name') from sys_dummy;
select name,type,x_locks,total_locks,get_my_locktimes(lock_detail) from dv_all_alocks where name like 'gs%' order by 1;
select name,type,x_locks,my_locks, total_locks from dv_user_alocks where name like 'gs%' order by 1;

select release_lock('gs_lock_name') from sys_dummy;
select name,type,x_locks,total_locks,get_my_locktimes(lock_detail) from dv_all_alocks where name like 'gs%' order by 1;
select name,type,x_locks,my_locks, total_locks from dv_user_alocks where name like 'gs%' order by 1;

select release_lock('gs_lock_name') from sys_dummy;
select release_shared_lock('gs_lock_name') from sys_dummy;
select name,type,x_locks,total_locks,get_my_locktimes(lock_detail) from dv_all_alocks where name like 'gs%' order by 1;
select name,type,x_locks,my_locks, total_locks from dv_user_alocks where name like 'gs%' order by 1;

select release_shared_lock('gs_lock_name') from sys_dummy;
select name,type,x_locks,total_locks,get_my_locktimes(lock_detail) from dv_all_alocks where name like 'gs%' order by 1;
select name,type,x_locks,my_locks, total_locks from dv_user_alocks where name like 'gs%' order by 1;

--test tx alck
select get_xact_lock('gs_lock_name') from sys_dummy;
select try_get_xact_lock('gs_lock_name') from sys_dummy;
select get_xact_shared_lock('gs_lock_name') from sys_dummy;
select try_get_xact_shared_lock('gs_lock_name') from sys_dummy;

select name,type,x_locks,total_locks,get_my_locktimes(lock_detail) from dv_all_alocks where name like 'gs%' order by 1;
select name,type,x_locks,my_locks, total_locks from dv_user_alocks where name like 'gs%' order by 1;

select get_xact_lock('gs_lock_name') from sys_dummy;
select try_get_xact_lock('gs_lock_name') from sys_dummy;
select get_xact_shared_lock('gs_lock_name') from sys_dummy;
select try_get_xact_shared_lock('gs_lock_name') from sys_dummy;

select name,type,x_locks,total_locks,get_my_locktimes(lock_detail) from dv_all_alocks where name like 'gs%' order by 1;
select name,type,x_locks,my_locks, total_locks from dv_user_alocks where name like 'gs%' order by 1;

commit;
select name,type,x_locks,total_locks,get_my_locktimes(lock_detail) from dv_all_alocks where name like 'gs%' order by 1;
select name,type,x_locks,my_locks, total_locks from dv_user_alocks where name like 'gs%' order by 1;

--test maximum specifiction
declare
tmp int;
begin
for i in 1..2000 loop
select get_xact_lock('gs_lock_name1') into tmp from sys_dummy;
select get_xact_shared_lock('gs_lock_name1') into tmp from sys_dummy;
select get_xact_lock('gs_lock_name2') into tmp from sys_dummy;
select get_xact_shared_lock('gs_lock_name2') into tmp from sys_dummy;

select get_lock('gs_lock_name3') into tmp from sys_dummy;
select get_shared_lock('gs_lock_name3') into tmp from sys_dummy;
select get_lock('gs_lock_name4') into tmp from sys_dummy;
select get_shared_lock('gs_lock_name4') into tmp from sys_dummy;
end loop;
end;
/

select name,type,x_locks,total_locks,get_my_locktimes(lock_detail) from dv_all_alocks where name like 'gs%' order by 1;
select name,type,x_locks,my_locks, total_locks from dv_user_alocks where name like 'gs%' order by 1;
commit;
select name,type,x_locks,total_locks,get_my_locktimes(lock_detail) from dv_all_alocks where name like 'gs%' order by 1;
select name,type,x_locks,my_locks, total_locks from dv_user_alocks where name like 'gs%' order by 1;

declare
tmp int;
begin
for i in 1..2000 loop
select release_lock('gs_lock_name3') into tmp from sys_dummy;
select release_shared_lock('gs_lock_name3') into tmp from sys_dummy;
select release_lock('gs_lock_name4') into tmp from sys_dummy;
select release_shared_lock('gs_lock_name4') into tmp from sys_dummy;
end loop;
end;
/

select name,type,x_locks,total_locks,get_my_locktimes(lock_detail) from dv_all_alocks where name like 'gs%' order by 1;
select name,type,x_locks,my_locks, total_locks from dv_user_alocks where name like 'gs%' order by 1;


--test maximum specifiction
declare
tmp int;
str varchar(500);
begin
for i in 1..65536 loop
str := 'gs_lock'||i;
select get_lock(str) into tmp from sys_dummy;
end loop;
end;
/

select count(*) from dv_user_alocks where name like 'gs%';

declare
tmp int;
str varchar(500);
begin
for i in 1..65536 loop
str := 'gs_lock'||i;
select release_lock(str) into tmp from sys_dummy;
end loop;
end;
/

select count(*) from dv_user_alocks where name like 'gs%';

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists gs_alck cascade;

