conn sys/Huawei@123@127.0.0.1:1611

drop user if exists encrypt;
create user encrypt identified by 'Changeme_123';
grant dba to encrypt;

conn encrypt/Changeme_123@127.0.0.1:1611

drop table if exists encrypt_big_data;
create table encrypt_big_data (f1 clob, f2 clob, f3 int, f4 varchar(20));
insert into encrypt_big_data values('abcdefghijklmn','abcdefghijklmn',1,'test1');
insert into encrypt_big_data values('abcdefghijmn','abcdefghijkln',2,'test2');

create or replace procedure gen_cry_data(size in int )
as
begin 
    for i in 1..size loop
        update encrypt_big_data set f1=f1||f1;
		update encrypt_big_data set f2=f2||f2;
    end loop;
end;
/
call gen_cry_data(16);
commit;

select length(f1),length(f2) from encrypt_big_data order by f3;
dump table encrypt_big_data INTO FILE 'encrypt_big_data.dmp' fields ENCLOSED BY '`' fields TERMINATED BY ',' lines TERMINATED BY '\n' file size '10M' encrypt by 'Changeme_123';
truncate table encrypt_big_data;
load data infile "encrypt_big_data.dmp" into table encrypt_big_data  fields ENCLOSED BY '`' fields TERMINATED BY ',' lines TERMINATED BY '\n' decrypt by 'Changeme_123';
select length(f1),length(f2) from encrypt_big_data order by f3;

drop table if exists encrypt_test;
create table encrypt_test (f1 int, f2 varchar(50));
insert into encrypt_test values (1,'sfs'),(2,'yyy'),(3,'wee');
commit;
drop index if exists encrypt_test_1 ON encrypt_test;
CREATE INDEX encrypt_test_1 ON encrypt_test(f1);

select * from encrypt_test order by f1;
dump table encrypt_test INTO FILE 'encrypt_test.dmp' fields ENCLOSED BY '`' fields TERMINATED BY ',' lines TERMINATED BY '\n' encrypt by '123456789';
dump table encrypt_test INTO FILE 'encrypt_test.dmp' fields ENCLOSED BY '`' fields TERMINATED BY ',' lines TERMINATED BY '\n' encrypt by 'Changeme_123';
truncate table encrypt_test;
load data infile "encrypt_test.dmp" into table encrypt_test  fields ENCLOSED BY '`' fields TERMINATED BY ',' lines TERMINATED BY '\n' decrypt by 'sfasdfdsf';
load data infile "encrypt_test.dmp" into table encrypt_test  fields ENCLOSED BY '`' fields TERMINATED BY ',' lines TERMINATED BY '\n' decrypt by 'Changeme_123';
load data infile "encrypt_test.dmp" into table encrypt_test  fields ENCLOSED BY '`' fields TERMINATED BY ',' lines TERMINATED BY '\n' decrypt by 'Changeme_222';
select * from encrypt_test order by f1;

dump table encrypt_big_data INTO FILE 'encrypt_parallel.dmp' fields ENCLOSED BY '`' fields TERMINATED BY ',' lines TERMINATED BY '\n' encrypt by 'Changeme_123';
truncate table encrypt_big_data;
load data infile "encrypt_parallel.dmp" into table encrypt_big_data  fields ENCLOSED BY '`' fields TERMINATED BY ',' lines TERMINATED BY '\n' decrypt by 'Changeme_123';
select length(f1),length(f2) from encrypt_big_data order by f3;

exp users=encrypt file="encrypt_user.dmp" FILETYPE=bin parallel = 4 encrypt= 'Changeme_123';
truncate table encrypt_big_data;
truncate table encrypt_test;
imp users=encrypt file="encrypt_user.dmp" FILETYPE=bin parallel = 8 decrypt= 'Changeme_123';
select * from encrypt_test order by f1;
select length(f1),length(f2) from encrypt_big_data order by f3;

exp tables=% file="encrypt_tableall.dmp" FILETYPE=bin parallel = 4 encrypt= 'Changeme_123';
truncate table encrypt_big_data;
truncate table encrypt_test;
imp tables=% file="encrypt_tableall.dmp" FILETYPE=bin parallel = 8 decrypt= 'Changeme_123';
select * from encrypt_test order by f1;
select length(f1),length(f2) from encrypt_big_data order by f3;

exp tables=encrypt_test file="encrypt_test_exp.dmp" FILETYPE=txt encrypt= 'Changeme_123';
imp tables=encrypt_test file="encrypt_test_exp.dmp" FILETYPE=txt decrypt= 'Changeme_123';
select * from encrypt_test order by f1;

exp tables=encrypt_big_data file="encrypt_exp.dmp" FILETYPE=bin encrypt= 'Changeme_123';
imp tables=encrypt_big_data file="encrypt_exp.dmp" FILETYPE=bin decrypt= 'Changeme_123';
select length(f1),length(f2) from encrypt_big_data order by f3;

exp tables=encrypt_test file="encrypt_compress.dmp" FILETYPE=bin encrypt= 'Changeme_123' compress = 2;
imp tables=encrypt_test file="encrypt_compress.dmp" FILETYPE=bin decrypt= 'Changeme_123';
select * from encrypt_test order by f1;

exp tables=encrypt_test file="encrypt_test_exp.dmp" FILETYPE=txt parallel = 4 encrypt= 'Changeme_123';
imp tables=encrypt_test file="encrypt_test_exp.dmp" FILETYPE=txt parallel = 8 decrypt= 'Changeme_123';
select * from encrypt_test order by f1;

exp tables=encrypt_big_data file="encrypt_exp.dmp" FILETYPE=bin parallel = 4 encrypt= 'Changeme_123';
imp tables=encrypt_big_data file="encrypt_exp.dmp" FILETYPE=bin parallel = 8 decrypt= 'Changeme_123';
select length(f1),length(f2) from encrypt_big_data order by f3;

drop table if exists encrypt_big_data;
drop index if exists encrypt_test_1 ON encrypt_test;
drop table if exists encrypt_test;

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists encrypt cascade;
drop user if exists encrypt_empty cascade;
create user encrypt_empty identified by 'Changeme_123';
grant dba to encrypt_empty;

conn encrypt_empty/Changeme_123@127.0.0.1:1611
exp users=encrypt_empty file="empty_user.dmp";
imp users=encrypt_empty file="empty_user.dmp";
exp users=encrypt_empty file="empty_database.dmp" encrypt='sdfsfsfdsf';
exp users=encrypt_empty file="empty_database.dmp" encrypt='Changeme_123';
imp users=encrypt_empty file="empty_database.dmp" decrypt='Changeme_123';
imp users=encrypt_empty file="empty_database.dmp" decrypt='Changeme_222';
imp users=encrypt_empty file="empty_database.dmp" decrypt='12345678';
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists encrypt_empty cascade;

--DTS2019092111582;DTS2019092011413
drop user if exists smaller cascade;
Create user smaller identified by Changme_123;

drop user if exists greater cascade;
Create user greater identified by Changme_123;

drop user if exists hanson cascade;
Create user hanson identified by Changme_123;
grant dba to smaller,greater,hanson;

conn smaller/Changme_123@127.0.0.1:1611
DROP TABLE IF EXISTS smaller1;
DROP TABLE IF EXISTS smaller2;
CREATE TABLE smaller1(ID INT,POSTCODE BIGINT,NAME VARCHAR2(10),SEX CHAR(6),COMMENT VARCHAR(20),IDCARD NUMBER(20),BIRTHDAY DATE,ACTIVE BOOLEAN,MY_BLOB BLOB,MY_CLOB CLOB,MY_BINARY BINARY(5),MY_VARBINARY VARBINARY(5),MY_REAL REAL(5));
ALTER TABLE smaller1 MODIFY ID INT AUTO_INCREMENT;
CREATE TABLE smaller2(ID INT,POSTCODE BIGINT,NAME VARCHAR2(10),SEX CHAR(6),COMMENT VARCHAR(20),IDCARD NUMBER(20),BIRTHDAY DATE,ACTIVE BOOLEAN,MY_BLOB BLOB,MY_CLOB CLOB,MY_BINARY BINARY(5),MY_VARBINARY VARBINARY(5),MY_REAL REAL(5));
ALTER TABLE smaller2 MODIFY ID INT AUTO_INCREMENT;

create or replace procedure smaller(size in int )
as
begin 
    for i in 1..size loop
        INSERT INTO smaller1 VALUES(0,710100,'ANNIE','MALE','this Is@3!','610111199003064490','2019-02-28 23:01:59',TRUE,'0XE87F1','CLOB',131,101,100.6);
				INSERT INTO smaller2 VALUES(0,710100,'ANNIE','MALE','this Is@3!','610111199003064490','2019-02-28 23:01:59',TRUE,'0XE87F1','CLOB',131,101,100.6);
    end loop;
end;
/

call smaller(55);
COMMIT;

conn greater/Changme_123@127.0.0.1:1611
DROP TABLE IF EXISTS greater1;
DROP TABLE IF EXISTS greater2;
CREATE TABLE greater1(ID INT,POSTCODE BIGINT,NAME VARCHAR2(10),SEX CHAR(6),COMMENT VARCHAR(20),IDCARD NUMBER(20),BIRTHDAY DATE,ACTIVE BOOLEAN,MY_BLOB BLOB,MY_CLOB CLOB,MY_BINARY BINARY(5),MY_VARBINARY VARBINARY(5),MY_REAL REAL(5));
ALTER TABLE greater1 MODIFY ID INT AUTO_INCREMENT;
CREATE TABLE greater2(ID INT,POSTCODE BIGINT,NAME VARCHAR2(10),SEX CHAR(6),COMMENT VARCHAR(20),IDCARD NUMBER(20),BIRTHDAY DATE,ACTIVE BOOLEAN,MY_BLOB BLOB,MY_CLOB CLOB,MY_BINARY BINARY(5),MY_VARBINARY VARBINARY(5),MY_REAL REAL(5));
ALTER TABLE greater2 MODIFY ID INT AUTO_INCREMENT;

create or replace procedure greater(size in int )
as
begin 
    for i in 1..size loop
        INSERT INTO greater1 VALUES(0,710077,'ANNIE','MALE','THIS IS TABLE TEST@','610111199003064490','2019-02-28 22:00:00',TRUE,'0XE87F1','CLOB',131,101,100.6);
				INSERT INTO greater2 VALUES(0,710077,'leo','MALE','THIS IS TABLE TEST@','610111199003064490','2019-02-28 22:00:00',TRUE,'0XE87F1','CLOB',131,101,100.6);
    end loop;
end;
/
call greater(136);
COMMIT;


conn hanson/Changme_123@127.0.0.1:1611
DROP TABLE IF EXISTS mytable1;
DROP TABLE IF EXISTS mytable2;
CREATE TABLE mytable1(ID INT,POSTCODE BIGINT,NAME VARCHAR2(10),SEX CHAR(6),COMMENT VARCHAR(20),IDCARD NUMBER(20),BIRTHDAY DATE,ACTIVE BOOLEAN,MY_BLOB BLOB,MY_CLOB CLOB,MY_BINARY BINARY(5),MY_VARBINARY VARBINARY(5),MY_REAL REAL(5));
ALTER TABLE mytable1 MODIFY ID INT AUTO_INCREMENT;

CREATE TABLE mytable2(ID INT,POSTCODE BIGINT,NAME VARCHAR2(10),SEX CHAR(6),COMMENT VARCHAR(20),IDCARD NUMBER(20),BIRTHDAY DATE,ACTIVE BOOLEAN,MY_BLOB BLOB,MY_CLOB CLOB,MY_BINARY BINARY(5),MY_VARBINARY VARBINARY(5),MY_REAL REAL(5));
ALTER TABLE mytable2 MODIFY ID INT AUTO_INCREMENT;

create or replace procedure hanson(size in int )
as
begin 
    for i in 1..size loop
        INSERT INTO mytable1 VALUES(0,710077,'mark','MALE','THIS IS TABLE TEST@','610111199003064490','2019-02-28 22:00:00',TRUE,'0XE87F1','CLOB',131,101,99.56);
				INSERT INTO mytable2 VALUES(0,710077,'mark','MALE','THIS IS TABLE TEST@','610111199003064490','2019-02-28 22:00:00',TRUE,'0XE87F1','CLOB',131,101,99.56);
    end loop;
end;
/
call hanson(999);
COMMIT;

conn sys/Huawei@123@127.0.0.1:1611
exp users=smaller,greater,hanson file="dum11.dmp" parallel=2 filetype=bin consistent=Y encrypt='Cantian_234';
imp users=smaller,greater,hanson file="dum11.dmp" parallel=2 filetype=bin decrypt='Cantian_234';
exp users=smaller,greater,hanson file="dum11.dmp" parallel=2 filetype=bin consistent=Y encrypt='Cantian_234';
imp users=smaller,greater,hanson file="dum11.dmp" parallel=2 filetype=bin decrypt='Cantian_234';

exp users=smaller,greater,hanson file="dum11.dmp" filetype=bin consistent=Y encrypt='Cantian_234';
imp users=smaller,greater,hanson file="dum11.dmp" filetype=bin decrypt='Cantian_234';

exp users=smaller,greater,hanson file="dum11.dmp" parallel=2 filetype=txt consistent=Y encrypt='Cantian_234';
imp users=smaller,greater,hanson file="dum11.dmp" parallel=2 filetype=txt decrypt='Cantian_234';
exp users=smaller,greater,hanson file="dum11.dmp" filetype=txt consistent=Y encrypt='Cantian_234';
imp users=smaller,greater,hanson file="dum11.dmp" filetype=txt decrypt='Cantian_234';

conn smaller/Changme_123@127.0.0.1:1611
dump table smaller1 into file 'smaller1.txt' charset = GBK;
load data infile "smaller1.txt" into table smaller1 charset = GBK;
dump table smaller1 into file 'smaller1.txt' charset GBK;
load data infile "smaller1.txt" into table smaller1 charset GBK;

exp tables=% file="smaller.dmp" filetype=txt;
exp tables=% filetype=sdd file="smaller.dmp";
exp tables=% file="smaller.dmp" filetype=sdd;

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists smaller cascade;
drop user if exists greater cascade;
drop user if exists hanson cascade;

drop user if exists compress4 cascade;
create user compress4 identified by 'cantian@123';
grant dba to compress4;
conn compress4/cantian@123@127.0.0.1:1611

drop table if exists lobtest1;
create table lobtest1(aa nvarchar(8000),bb blob);
drop table if exists lobtest2;
create table lobtest2(aa nvarchar(8000),cc clob);
insert into lobtest1 values('sdsdsd',LPAD('10',8000,'1') || LPAD('10',8000,'1'));
insert into lobtest2 values('sdsdd',LPAD('ab',8000,'a') || LPAD('cd',8000,'c'));
commit;

exp users=compress4 file='exp_compress4_bin.dmp' filetype=bin encrypt = 'Chanmge_123' compress=4;
imp users=compress4 file='exp_compress4_bin.dmp' filetype=bin decrypt = 'Chanmge_123';

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists compress4 cascade;