-- begin exp imp compress
-- create user & table
drop user if exists exp_imp_compress cascade;
create user exp_imp_compress identified by Test_123456;
grant dba to exp_imp_compress;
conn exp_imp_compress/Test_123456@127.0.0.1:1611
create table ts (c int primary key,c1 clob);
insert into ts values (1,'abcd123456');
insert into ts values (2,'abcd654321');
commit;
create or replace procedure gen_big_data(size in int )
as
begin 
    for i in 1..size loop
        update ts set c1=c1||c1;
    end loop;
end;
/
call gen_big_data(20);
insert into ts values (3, 'abcd654321');
commit;
select * from ts where length(c1) < 8000;
select c,length(c1) from ts where length(c1) > 8000;

-- exp tables
exp tables=ts file="./data/test_exp_compress.dmp" filetype=bin log="./data/test_exp_compress_exp.log" compress=9;
exp tables=ts file="./data/test_exp_compress_parallel.dmp" filetype=bin parallel=5 log="./data/test_exp_compress_exp_parallel.log" compress=9;

--imp tables
drop table ts;
imp tables=% file="./data/test_exp_compress.dmp" filetype=bin log="./data/test_exp_compress_imp.log";
select * from ts where length(c1) < 8000;
select c,length(c1) from ts where length(c1) > 8000;

drop table ts;
imp tables=% file="./data/test_exp_compress_parallel.dmp" filetype=bin log="./data/test_exp_compress_imp_parallel.log";
select * from ts where length(c1) < 8000;
select c,length(c1) from ts where length(c1) > 8000;
conn sys/Huawei@123@127.0.0.1:1611
-- end exp imp compress

-- support export and import compress attribution of table or partition table
CREATE TABLESPACE TABLE_COMPRESS_ATTRIBUTE DATAFILE 'normal_object_no_compress' size 128M AUTOEXTEND on extent autoallocate; -- only support bitmap tablespace
alter tablespace TABLE_COMPRESS_ATTRIBUTE add datafile 'TABLE_COMPRESS_ATTRIBUTE' size 128M compress autoextend on next 1M;

drop user if exists wanggang_compress;
create user wanggang_compress identified by Changeme_123;
grant dba to wanggang_compress;
conn wanggang_compress/Changeme_123@127.0.0.1:1611

drop table  if exists t_parT_CSF_COMPRESS_N;
create table t_parT_CSF_COMPRESS_N(id int, name varchar2(100)) PARTITION BY list(id) 
(
partition p10 values (1) format csf compress,
partition p20 values (2),
partition p30 values (3) format csf compress
)format csf tablespace TABLE_COMPRESS_ATTRIBUTE;
alter table t_parT_CSF_COMPRESS_N add partition p40 values(4) format csf compress;
alter table t_parT_CSF_COMPRESS_N add partition p50 values(5);

drop table  if exists t_parT_CSF_COMPRESS_Y;
create table t_parT_CSF_COMPRESS_Y(id int, name varchar2(100)) PARTITION BY list(id) 
(
partition p11 values (1),
partition p21 values (2),
partition p31 values (3) format csf compress
)format csf compress tablespace TABLE_COMPRESS_ATTRIBUTE;
alter table t_parT_CSF_COMPRESS_Y add partition p41 values(4) format csf compress;
alter table t_parT_CSF_COMPRESS_Y add partition p51 values(5);

drop table  if exists t_parT_ASF_COMPRESS_N;
create table t_parT_ASF_COMPRESS_N(id int, name varchar2(100)) PARTITION BY list(id) 
(
partition p10 values (1) format csf compress,
partition p20 values (2),
partition p30 values (3) format csf compress
)tablespace TABLE_COMPRESS_ATTRIBUTE;
alter table t_parT_ASF_COMPRESS_N add partition p40 values(4) format csf compress;
alter table t_parT_ASF_COMPRESS_N add partition p50 values(5);

drop table  if exists t_parT_ASF_COMPRESS_Y;
create table t_parT_ASF_COMPRESS_Y(id int, name varchar2(100)) PARTITION BY list(id) 
(
partition p11 values (1),
partition p21 values (2),
partition p31 values (3) compress
)compress tablespace TABLE_COMPRESS_ATTRIBUTE;
alter table t_parT_ASF_COMPRESS_Y add partition p41 values(4) format csf compress;
alter table t_parT_ASF_COMPRESS_Y add partition p51 values(5);

drop table  if exists T_CSF_COMPRESS_Y;
create table T_CSF_COMPRESS_Y(f int) format csf compress tablespace TABLE_COMPRESS_ATTRIBUTE;

drop table  if exists T_CSF_COMPRESS_N;
create table T_CSF_COMPRESS_N(f int) format csf tablespace TABLE_COMPRESS_ATTRIBUTE;

drop table  if exists T_ASF_COMPRESS_Y;
create table T_ASF_COMPRESS_Y(f int) compress tablespace TABLE_COMPRESS_ATTRIBUTE;

drop table  if exists T_ASF_COMPRESS_N;
create table T_ASF_COMPRESS_N(f int) tablespace TABLE_COMPRESS_ATTRIBUTE;

select TABLE_NAME,COMPRESS_ALGO from db_tables where table_name = 'T_PART_CSF_COMPRESS_Y' or table_name = 'T_PART_CSF_COMPRESS_N' or table_name = 'T_PART_ASF_COMPRESS_Y' or table_name = 'T_PART_ASF_COMPRESS_N' or table_name = 'T_CSF_COMPRESS_Y' or table_name = 'T_CSF_COMPRESS_N' or table_name = 'T_ASF_COMPRESS_Y' or table_name = 'T_ASF_COMPRESS_N' order by table_name;
select TABLE_NAME,COMPRESS_ALGO from my_tables where table_name = 'T_PART_CSF_COMPRESS_Y' or table_name = 'T_PART_CSF_COMPRESS_N' or table_name = 'T_PART_ASF_COMPRESS_Y' or table_name = 'T_PART_ASF_COMPRESS_N' or table_name = 'T_CSF_COMPRESS_Y' or table_name = 'T_CSF_COMPRESS_N' or table_name = 'T_ASF_COMPRESS_Y' or table_name = 'T_ASF_COMPRESS_N' order by table_name;
select TABLE_NAME,COMPRESS_ALGO from adm_tables where table_name = 'T_PART_CSF_COMPRESS_Y' or table_name = 'T_PART_CSF_COMPRESS_N' or table_name = 'T_PART_ASF_COMPRESS_Y' or table_name = 'T_PART_ASF_COMPRESS_N' or table_name = 'T_CSF_COMPRESS_Y' or table_name = 'T_CSF_COMPRESS_N' or table_name = 'T_ASF_COMPRESS_Y' or table_name = 'T_ASF_COMPRESS_N' order by table_name;
select table_name,partition_name,compress_algo from db_tab_partitions where table_name = 'T_PART_CSF_COMPRESS_Y' or table_name = 'T_PART_CSF_COMPRESS_N' or table_name = 'T_PART_ASF_COMPRESS_Y' or table_name = 'T_PART_ASF_COMPRESS_N' or table_name = 'T_CSF_COMPRESS_Y' or table_name = 'T_CSF_COMPRESS_N' or table_name = 'T_ASF_COMPRESS_Y' or table_name = 'T_ASF_COMPRESS_N' order by table_name,PARTITION_NAME;
select table_name,partition_name,compress_algo from my_tab_partitions where table_name = 'T_PART_CSF_COMPRESS_Y' or table_name = 'T_PART_CSF_COMPRESS_N' or table_name = 'T_PART_ASF_COMPRESS_Y' or table_name = 'T_PART_ASF_COMPRESS_N' or table_name = 'T_CSF_COMPRESS_Y' or table_name = 'T_CSF_COMPRESS_N' or table_name = 'T_ASF_COMPRESS_Y' or table_name = 'T_ASF_COMPRESS_N' order by table_name,PARTITION_NAME;
select table_name,partition_name,compress_algo from adm_tab_partitions where table_name = 'T_PART_CSF_COMPRESS_Y' or table_name = 'T_PART_CSF_COMPRESS_N' or table_name = 'T_PART_ASF_COMPRESS_Y' or table_name = 'T_PART_ASF_COMPRESS_N' or table_name = 'T_CSF_COMPRESS_Y' or table_name = 'T_CSF_COMPRESS_N' or table_name = 'T_ASF_COMPRESS_Y' or table_name = 'T_ASF_COMPRESS_N' order by table_name,PARTITION_NAME;
show create table T_PART_CSF_COMPRESS_Y;
show create table T_PART_CSF_COMPRESS_N;
show create table T_PART_ASF_COMPRESS_Y;
show create table T_PART_ASF_COMPRESS_N;
show create table T_CSF_COMPRESS_Y;
show create table T_CSF_COMPRESS_N;
show create table T_ASF_COMPRESS_Y;
show create table T_ASF_COMPRESS_N;

exp tables=T_PART_CSF_COMPRESS_Y,T_PART_CSF_COMPRESS_N,T_PART_ASF_COMPRESS_Y,T_PART_ASF_COMPRESS_N,T_CSF_COMPRESS_Y,T_CSF_COMPRESS_N,T_ASF_COMPRESS_Y,T_ASF_COMPRESS_N filetype=txt file="txt";
imp tables=t_parT_CSF_COMPRESS_Y,t_parT_CSF_COMPRESS_N,t_parT_ASF_COMPRESS_Y,t_parT_ASF_COMPRESS_N,T_CSF_COMPRESS_Y,T_CSF_COMPRESS_N,T_ASF_COMPRESS_Y,T_ASF_COMPRESS_N filetype=txt file="txt";
select TABLE_NAME,COMPRESS_ALGO from db_tables where table_name = 'T_PART_CSF_COMPRESS_Y' or table_name = 'T_PART_CSF_COMPRESS_N' or table_name = 'T_PART_ASF_COMPRESS_Y' or table_name = 'T_PART_ASF_COMPRESS_N' or table_name = 'T_CSF_COMPRESS_Y' or table_name = 'T_CSF_COMPRESS_N' or table_name = 'T_ASF_COMPRESS_Y' or table_name = 'T_ASF_COMPRESS_N' order by table_name;
select TABLE_NAME,COMPRESS_ALGO from my_tables where table_name = 'T_PART_CSF_COMPRESS_Y' or table_name = 'T_PART_CSF_COMPRESS_N' or table_name = 'T_PART_ASF_COMPRESS_Y' or table_name = 'T_PART_ASF_COMPRESS_N' or table_name = 'T_CSF_COMPRESS_Y' or table_name = 'T_CSF_COMPRESS_N' or table_name = 'T_ASF_COMPRESS_Y' or table_name = 'T_ASF_COMPRESS_N' order by table_name;
select TABLE_NAME,COMPRESS_ALGO from adm_tables where table_name = 'T_PART_CSF_COMPRESS_Y' or table_name = 'T_PART_CSF_COMPRESS_N' or table_name = 'T_PART_ASF_COMPRESS_Y' or table_name = 'T_PART_ASF_COMPRESS_N' or table_name = 'T_CSF_COMPRESS_Y' or table_name = 'T_CSF_COMPRESS_N' or table_name = 'T_ASF_COMPRESS_Y' or table_name = 'T_ASF_COMPRESS_N' order by table_name;
select table_name,partition_name,compress_algo from db_tab_partitions where table_name = 'T_PART_CSF_COMPRESS_Y' or table_name = 'T_PART_CSF_COMPRESS_N' or table_name = 'T_PART_ASF_COMPRESS_Y' or table_name = 'T_PART_ASF_COMPRESS_N' or table_name = 'T_CSF_COMPRESS_Y' or table_name = 'T_CSF_COMPRESS_N' or table_name = 'T_ASF_COMPRESS_Y' or table_name = 'T_ASF_COMPRESS_N' order by table_name,PARTITION_NAME;
select table_name,partition_name,compress_algo from my_tab_partitions where table_name = 'T_PART_CSF_COMPRESS_Y' or table_name = 'T_PART_CSF_COMPRESS_N' or table_name = 'T_PART_ASF_COMPRESS_Y' or table_name = 'T_PART_ASF_COMPRESS_N' or table_name = 'T_CSF_COMPRESS_Y' or table_name = 'T_CSF_COMPRESS_N' or table_name = 'T_ASF_COMPRESS_Y' or table_name = 'T_ASF_COMPRESS_N' order by table_name,PARTITION_NAME;
select table_name,partition_name,compress_algo from adm_tab_partitions where table_name = 'T_PART_CSF_COMPRESS_Y' or table_name = 'T_PART_CSF_COMPRESS_N' or table_name = 'T_PART_ASF_COMPRESS_Y' or table_name = 'T_PART_ASF_COMPRESS_N' or table_name = 'T_CSF_COMPRESS_Y' or table_name = 'T_CSF_COMPRESS_N' or table_name = 'T_ASF_COMPRESS_Y' or table_name = 'T_ASF_COMPRESS_N' order by table_name,PARTITION_NAME;
show create table T_PART_CSF_COMPRESS_Y;
show create table T_PART_CSF_COMPRESS_N;
show create table T_PART_ASF_COMPRESS_Y;
show create table T_PART_ASF_COMPRESS_N;
show create table T_CSF_COMPRESS_Y;
show create table T_CSF_COMPRESS_N;
show create table T_ASF_COMPRESS_Y;
show create table T_ASF_COMPRESS_N;

exp tables=t_parT_CSF_COMPRESS_Y,t_parT_CSF_COMPRESS_N,t_parT_ASF_COMPRESS_Y,t_parT_ASF_COMPRESS_N,T_CSF_COMPRESS_Y,T_CSF_COMPRESS_N,T_ASF_COMPRESS_Y,T_ASF_COMPRESS_N filetype=bin file="bin";
imp tables=t_parT_CSF_COMPRESS_Y,t_parT_CSF_COMPRESS_N,t_parT_ASF_COMPRESS_Y,t_parT_ASF_COMPRESS_N,T_CSF_COMPRESS_Y,T_CSF_COMPRESS_N,T_ASF_COMPRESS_Y,T_ASF_COMPRESS_N filetype=bin file="bin";
select TABLE_NAME,COMPRESS_ALGO from db_tables where table_name = 'T_PART_CSF_COMPRESS_Y' or table_name = 'T_PART_CSF_COMPRESS_N' or table_name = 'T_PART_ASF_COMPRESS_Y' or table_name = 'T_PART_ASF_COMPRESS_N' or table_name = 'T_CSF_COMPRESS_Y' or table_name = 'T_CSF_COMPRESS_N' or table_name = 'T_ASF_COMPRESS_Y' or table_name = 'T_ASF_COMPRESS_N' order by table_name;
select TABLE_NAME,COMPRESS_ALGO from my_tables where table_name = 'T_PART_CSF_COMPRESS_Y' or table_name = 'T_PART_CSF_COMPRESS_N' or table_name = 'T_PART_ASF_COMPRESS_Y' or table_name = 'T_PART_ASF_COMPRESS_N' or table_name = 'T_CSF_COMPRESS_Y' or table_name = 'T_CSF_COMPRESS_N' or table_name = 'T_ASF_COMPRESS_Y' or table_name = 'T_ASF_COMPRESS_N' order by table_name;
select TABLE_NAME,COMPRESS_ALGO from adm_tables where table_name = 'T_PART_CSF_COMPRESS_Y' or table_name = 'T_PART_CSF_COMPRESS_N' or table_name = 'T_PART_ASF_COMPRESS_Y' or table_name = 'T_PART_ASF_COMPRESS_N' or table_name = 'T_CSF_COMPRESS_Y' or table_name = 'T_CSF_COMPRESS_N' or table_name = 'T_ASF_COMPRESS_Y' or table_name = 'T_ASF_COMPRESS_N' order by table_name;
select table_name,partition_name,compress_algo from db_tab_partitions where table_name = 'T_PART_CSF_COMPRESS_Y' or table_name = 'T_PART_CSF_COMPRESS_N' or table_name = 'T_PART_ASF_COMPRESS_Y' or table_name = 'T_PART_ASF_COMPRESS_N' or table_name = 'T_CSF_COMPRESS_Y' or table_name = 'T_CSF_COMPRESS_N' or table_name = 'T_ASF_COMPRESS_Y' or table_name = 'T_ASF_COMPRESS_N' order by table_name,PARTITION_NAME;
select table_name,partition_name,compress_algo from my_tab_partitions where table_name = 'T_PART_CSF_COMPRESS_Y' or table_name = 'T_PART_CSF_COMPRESS_N' or table_name = 'T_PART_ASF_COMPRESS_Y' or table_name = 'T_PART_ASF_COMPRESS_N' or table_name = 'T_CSF_COMPRESS_Y' or table_name = 'T_CSF_COMPRESS_N' or table_name = 'T_ASF_COMPRESS_Y' or table_name = 'T_ASF_COMPRESS_N' order by table_name,PARTITION_NAME;
select table_name,partition_name,compress_algo from adm_tab_partitions where table_name = 'T_PART_CSF_COMPRESS_Y' or table_name = 'T_PART_CSF_COMPRESS_N' or table_name = 'T_PART_ASF_COMPRESS_Y' or table_name = 'T_PART_ASF_COMPRESS_N' or table_name = 'T_CSF_COMPRESS_Y' or table_name = 'T_CSF_COMPRESS_N' or table_name = 'T_ASF_COMPRESS_Y' or table_name = 'T_ASF_COMPRESS_N' order by table_name,PARTITION_NAME;
show create table T_PART_CSF_COMPRESS_Y;
show create table T_PART_CSF_COMPRESS_N;
show create table T_PART_ASF_COMPRESS_Y;
show create table T_PART_ASF_COMPRESS_N;
show create table T_CSF_COMPRESS_Y;
show create table T_CSF_COMPRESS_N;
show create table T_ASF_COMPRESS_Y;
show create table T_ASF_COMPRESS_N;

exp -v;

drop user if exists test_csf_compress cascade;
create user test_csf_compress identified by 'Changeme_123';
grant dba to test_csf_compress;
conn test_csf_compress/Changeme_123@127.0.0.1:1611
drop table  if exists t_csf_compress;
create table t_csf_compress(a int) format csf compress tablespace TABLE_COMPRESS_ATTRIBUTE INITRANS 3 PCTFREE 7;
drop table  if exists part_csf_compress_y;
create table part_csf_compress_y(id int, name varchar2(100)) PARTITION BY list(id) 
(
partition p11 values (1),
partition p21 values (2),
partition p31 values (3) format csf compress
)format csf compress tablespace TABLE_COMPRESS_ATTRIBUTE INITRANS 3 PCTFREE 7;
drop table  if exists part_asf_compress_n;
create table part_asf_compress_n(id int, name varchar2(100)) PARTITION BY list(id) 
(
partition p11 values (1),
partition p21 values (2),
partition p31 values (3) format csf compress tablespace TABLE_COMPRESS_ATTRIBUTE INITRANS 3 PCTFREE 7
);
show create table t_csf_compress;
show create table part_csf_compress_y;
show create table part_asf_compress_n;

exp tables=t_csf_compress,part_csf_compress_y,part_asf_compress_n filetype=txt file="test_csf_compress.txt";
imp tables=t_csf_compress,part_csf_compress_y,part_asf_compress_n filetype=txt file="test_csf_compress.txt";
show create table t_csf_compress;
show create table part_csf_compress_y;
show create table part_asf_compress_n;

exp tables=t_csf_compress,part_csf_compress_y,part_asf_compress_n filetype=bin file="test_csf_compress.bin";
imp tables=t_csf_compress,part_csf_compress_y,part_asf_compress_n filetype=bin file="test_csf_compress.bin";
show create table t_csf_compress;
show create table part_csf_compress_y;
show create table part_asf_compress_n;

exp tables=t_csf_compress,part_csf_compress_y,part_asf_compress_n filetype=txt file="test_csf_compress.txt" WITH_CR_MODE=Y;
imp tables=t_csf_compress,part_csf_compress_y,part_asf_compress_n filetype=txt file="test_csf_compress.txt";
show create table t_csf_compress;
show create table part_csf_compress_y;
show create table part_asf_compress_n;

exp tables=t_csf_compress,part_csf_compress_y,part_asf_compress_n filetype=bin file="test_csf_compress.bin" WITH_CR_MODE=Y;
imp tables=t_csf_compress,part_csf_compress_y,part_asf_compress_n filetype=bin file="test_csf_compress.bin";
show create table t_csf_compress;
show create table part_csf_compress_y;
show create table part_asf_compress_n;

exp tables=t_csf_compress,part_csf_compress_y,part_asf_compress_n filetype=txt file="test_csf_compress.txt" WITH_FORMAT_CSF=N;
imp tables=t_csf_compress,part_csf_compress_y,part_asf_compress_n filetype=txt file="test_csf_compress.txt";
show create table t_csf_compress;
show create table part_csf_compress_y;
show create table part_asf_compress_n;

exp tables=t_csf_compress,part_csf_compress_y,part_asf_compress_n filetype=bin file="test_csf_compress.bin" WITH_FORMAT_CSF=N;
imp tables=t_csf_compress,part_csf_compress_y,part_asf_compress_n filetype=bin file="test_csf_compress.bin";
show create table t_csf_compress;
show create table part_csf_compress_y;
show create table part_asf_compress_n;