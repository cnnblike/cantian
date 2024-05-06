alter system set UNDO_RETENTION_TIME=1;
alter system set DB_ISOLEVEL=CC;
drop table if exists table_1;
drop table if exists table_2;
drop table if exists table_3;
drop table if exists table_4;
create table table_1(c1 int, c2 int, c3 varchar(20)) CRMODE PAGE;
create index x_1 on table_1(c2,c3) CRMODE PAGE;
create table table_2(c1 int, c2 int, c3 varchar(20)) CRMODE ROW;
create index x_2 on table_2(c2,c3) CRMODE ROW;
create table table_3(c1 int);
create table table_4(c1 int);

CREATE or replace procedure tmp_1(startnum int,endall int) is
i INT :=1;
BEGIN
  FOR i IN startnum..endall LOOP
   execute immediate 'insert into table_1 values('||i||','||i||',''dwsds'')';
   execute immediate 'insert into table_1 values('||i||','||i||',''dwsds'')';
  END LOOP;
END;
/
call tmp_1(0,6);

CREATE or replace procedure tmp_2(startnum int,endall int) is
i INT :=1;
BEGIN
  FOR i IN startnum..endall LOOP
   execute immediate 'insert into table_2 values('||i||','||i||',''dwsds'')';
   execute immediate 'insert into table_2 values('||i||','||i||',''dwsds'')';
  END LOOP;
END;
/
call tmp_2(0,6);

declare
pval int;
cursor hash_cursor is select c1 from table_1 where c2 < 5;
begin
   open hash_cursor;
   fetch hash_cursor into pval;
   while hash_cursor%found loop
   sleep(1);
   execute immediate 'update table_1 set c2=c2+1 where c2 < 10';
   execute immediate 'insert into table_3 values('||pval||')';
   fetch hash_cursor into pval;
   end loop;
   close hash_cursor;
 end;
/

select * from table_3;

declare
pval int;
cursor hash_cursor is select c1 from table_1 limit 5;
begin
   open hash_cursor;
   fetch hash_cursor into pval;
   while hash_cursor%found loop
   sleep(1);
   execute immediate 'insert into table_4 values('||pval||')';
   fetch hash_cursor into pval;
   end loop;
   close hash_cursor;
 end;
/

select *from table_4;

declare
pval int;
cursor hash_cursor is select c1 from table_2 where c2 < 5;
begin
   open hash_cursor;
   fetch hash_cursor into pval;
   while hash_cursor%found loop
   sleep(1);
   execute immediate 'update table_1 set c2=c2+1 where c2 < 10';
   execute immediate 'insert into table_3 values('||pval||')';
   fetch hash_cursor into pval;
   end loop;
   close hash_cursor;
 end;
/

select * from table_3;

declare
pval int;
cursor hash_cursor is select c1 from table_2 limit 5;
begin
   open hash_cursor;
   fetch hash_cursor into pval;
   while hash_cursor%found loop
   sleep(1);
   execute immediate 'insert into table_4 values('||pval||')';
   fetch hash_cursor into pval;
   end loop;
   close hash_cursor;
 end;
/

select *from table_4;

alter system set UNDO_RETENTION_TIME=100;
alter system set DB_ISOLEVEL=RC;
