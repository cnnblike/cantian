-- imp too short file
drop user if exists imp_empty_file cascade;
create user imp_empty_file identified by Test_123456;
grant dba to imp_empty_file;
conn imp_empty_file/Test_123456@127.0.0.1:1611
create table ts (c int);
insert into ts values (1);
dump table ts into file './data/imp_empty_file.dmp';
conn sys/Huawei@123@127.0.0.1:1611
-- imp bin file include 120B filehead , this file is too short.
imp users=imp_empty_file file="./data/imp_empty_file.dmp" filetype=bin;

-- imp use different CONTENT with exp
drop user if exists imp_diff_content cascade;
create user imp_diff_content identified by Test_123456;
grant dba to imp_diff_content;
conn imp_diff_content/Test_123456@127.0.0.1:1611
create table ts (c int);
insert into ts values (1);
commit;
conn sys/Huawei@123@127.0.0.1:1611
exp users = imp_diff_content filetype=bin file = "./data/imp_diff_content.dmp";
imp users = imp_diff_content filetype=bin file = "./data/imp_diff_content.dmp" CONTENT=METADATA_ONLY;
drop user if exists imp_diff_content cascade;