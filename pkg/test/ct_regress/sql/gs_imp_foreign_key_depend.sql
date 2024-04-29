-- foreign key dependencies cascade, multi threads oper may cause dead lock 'DTS2020081207Y1POP0G00' 
drop user if exists imp_foreign_key cascade;
create user imp_foreign_key identified by Test_123456;
grant dba to imp_foreign_key;
conn imp_foreign_key/Test_123456@127.0.0.1:1611

create table t1(c int primary key, c1 int);
create table t2(c int primary key, c1 int);
create table t3(c int primary key, c1 int);
alter table t2 add foreign key(c1) references t1(c);
alter table t3 add foreign key(c1) references t2(c);

exp users=imp_foreign_key filetype=bin file="./data/imp_foreign_key.dmp";
-- try 10 times, do not have dead lock
imp users=imp_foreign_key filetype=bin file="./data/imp_foreign_key.dmp" ddl_parallel=10  log="./data/imp_foreign_key.log";
imp users=imp_foreign_key filetype=bin file="./data/imp_foreign_key.dmp" ddl_parallel=10  log="./data/imp_foreign_key.log";
imp users=imp_foreign_key filetype=bin file="./data/imp_foreign_key.dmp" ddl_parallel=10  log="./data/imp_foreign_key.log";
imp users=imp_foreign_key filetype=bin file="./data/imp_foreign_key.dmp" ddl_parallel=10  log="./data/imp_foreign_key.log";
imp users=imp_foreign_key filetype=bin file="./data/imp_foreign_key.dmp" ddl_parallel=10  log="./data/imp_foreign_key.log";
imp users=imp_foreign_key filetype=bin file="./data/imp_foreign_key.dmp" ddl_parallel=10  log="./data/imp_foreign_key.log";
imp users=imp_foreign_key filetype=bin file="./data/imp_foreign_key.dmp" ddl_parallel=10  log="./data/imp_foreign_key.log";
imp users=imp_foreign_key filetype=bin file="./data/imp_foreign_key.dmp" ddl_parallel=10  log="./data/imp_foreign_key.log";
imp users=imp_foreign_key filetype=bin file="./data/imp_foreign_key.dmp" ddl_parallel=10  log="./data/imp_foreign_key.log";
imp users=imp_foreign_key filetype=bin file="./data/imp_foreign_key.dmp" ddl_parallel=10  log="./data/imp_foreign_key.log";
