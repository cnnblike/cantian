set serveroutput on;
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists gs_plsql_insteadof cascade;
create user gs_plsql_insteadof identified by Lh00420062;
grant dba to gs_plsql_insteadof;

conn gs_plsql_insteadof/Lh00420062@127.0.0.1:1611

--case from oracle
drop table if exists customers;
CREATE TABLE customers
(
customer_id      number,
cust_last_name   varchar2(32),
cust_first_name  varchar2(32)
);
drop table if exists orders;
CREATE TABLE orders
(
order_id         number,
customer_id      number,
order_date       date,
order_status     int
);

CREATE OR REPLACE VIEW order_info AS
SELECT c.customer_id, c.cust_last_name, c.cust_first_name,
o.order_id, o.order_date, o.order_status
FROM customers c, orders o
WHERE c.customer_id = o.customer_id;

CREATE OR REPLACE TRIGGER order_info_insert INSTEAD OF INSERT ON order_info
DECLARE
duplicate_info EXCEPTION;
PRAGMA EXCEPTION_INIT(duplicate_info, -20001);
BEGIN
INSERT INTO customers(customer_id, cust_last_name, cust_first_name) VALUES (:new.customer_id, :new.cust_last_name, :new.cust_first_name);
INSERT INTO orders (order_id, order_date, customer_id) VALUES (:new.order_id, :new.order_date, :new.customer_id);
END order_info_insert;
/
INSERT INTO order_info VALUES (999, 'Smith', 'John', 2500, to_date('13-01-2001','dd-mm-yyyy'), 0);
select * from order_info;
select * from customers;
select * from orders;

--expect wrong
drop table if exists tt1;
create table tt1(a int,b int);
drop view if exists ttv;
create view ttv as select * from tt1;
drop trigger if exists ttv_trig;
create or replace trigger ttv_trig instead of insert on ttv_notexists for each row
begin
 :new.a := :new.a+1;
end;
/
create or replace trigger ttv_trig instead of insert on ttv for each row
begin
 :new.a := :new.a+1;
end;
/
drop view if exists ttv;
create view ttv as select a+1 as a_new from tt1;
drop trigger if exists ttv_trig;
create or replace trigger ttv_trig instead of insert on ttv for each row
begin
dbe_output.print_line(:new.a_new);
end;
/

--view from one table, case insert
drop view if exists ttv;
create view ttv as select a as a_new from tt1;
drop trigger if exists ttv_trig;
create or replace trigger ttv_trig instead of insert on ttv for each row
begin
 insert into tt1(a) values(:new.a_new);
end;
/
insert into ttv values (10);
select * from tt1;

--view from one table, case insert
drop table if exists tt1;
create table tt1(a int, b int);
drop view if exists ttv;
create view ttv as select a as a_new, b from tt1;
drop trigger if exists ttv_trig;
create or replace trigger ttv_trig instead of insert on ttv for each row
begin
dbe_output.print_line('insert a= '||:new.a_new||' b= '||:new.b);
 insert into tt1 values(:new.a_new,:new.b);
end;
/
insert into ttv values(10,20);
select * from ttv;

--view from one table, case update
drop table if exists tt1;
create table tt1(a int, b int);
insert into tt1 values(10,20);
insert into tt1 values(11,21);
drop view if exists ttv;
create view ttv as select a as a_new, b from tt1;
drop trigger if exists ttv_trig;
create or replace trigger ttv_trig instead of update on ttv for each row
begin
dbe_output.print_line('update old a= '||:old.a_new||' b= '||:old.b);
dbe_output.print_line('update new a= '||:new.a_new||' b= '||:new.b);
 update tt1 set a=:new.a_new, b=:new.b;
end;
/
update ttv set a_new=a_new+10;
select * from tt1;

--view from one table, case delete
drop table if exists tt1;
create table tt1(a int, b int);
insert into tt1 values(10,20);
insert into tt1 values(11,21);
drop view if exists ttv;
create view ttv as select a as a_new, b from tt1;
drop trigger if exists ttv_trig;
create or replace trigger ttv_trig instead of delete on ttv for each row
begin
dbe_output.print_line('delete a= '||:old.a_new||' b= '||:old.b);
 delete from tt1 where a= :old.a_new and b=:old.b;
end;
/
delete from ttv where a_new=10;
select * from tt1;

--view from two table, case insert
drop table if exists tt1;
create table tt1(a1 int,b1 int);
drop table if exists tt2;
create table tt2(a2 int,b2 int);
insert into tt1 values(10,20);
insert into tt1 values(11,30);
insert into tt2 values(10,200);
insert into tt2 values(11,300);
drop view if exists ttv;
create view ttv as select tt1.a1 as a_new, tt1.b1, tt2.b2 from tt1,tt2 where tt1.a1=tt2.a2;
drop trigger if exists ttv_trig;
create or replace trigger ttv_trig instead of insert on ttv for each row
begin
dbe_output.print_line('insert a1=a2 '||:new.a_new||' b1= '||:new.b1||' b2= '||:new.b2);
insert into tt1 values(:new.a_new,:new.b1);
insert into tt2 values(:new.a_new,:new.b2);
end;
/
insert into ttv values(1,2,3);
select * from ttv order 1,2;

--view from two table, case update
drop table if exists tt1;
create table tt1(a1 int,b1 int);
drop table if exists tt2;
create table tt2(a2 int,b2 int);
insert into tt1 values(10,20);
insert into tt1 values(11,30);
insert into tt2 values(10,200);
insert into tt2 values(11,300);
drop view if exists ttv;
create view ttv as select tt1.a1 as a_new, tt1.b1, tt2.b2 from tt1,tt2 where tt1.a1=tt2.a2;
drop trigger if exists ttv_trig;
create or replace trigger ttv_trig instead of update on ttv for each row
begin
dbe_output.print_line('update old a= '||:old.a_new||' b1= '||:old.b1);
dbe_output.print_line('update new a= '||:new.a_new||' b1= '||:new.b1);
 update tt1 set a1=:new.a_new, b1=:new.b1;
 update tt2 set a2=:new.a_new;
end;
/
update ttv set a_new=a_new+10,b1=b1+20;
select * from ttv order by 1,2;

--view from two table, case delete
drop table if exists tt1;
create table tt1(a1 int,b1 int);
drop table if exists tt2;
create table tt2(a2 int,b2 int);
insert into tt1 values(10,20);
insert into tt1 values(11,30);
insert into tt2 values(10,200);
insert into tt2 values(11,300);
drop view if exists ttv;
create view ttv as select tt1.a1 as a_new, tt1.b1, tt2.b2 from tt1,tt2 where tt1.a1=tt2.a2;
drop trigger if exists ttv_trig;
create or replace trigger ttv_trig instead of delete on ttv for each row
begin
dbe_output.print_line('delete a= '||:old.a_new||' b1= '||:old.b1);
 delete from tt1 where a1= :old.a_new and b1 = :old.b1;
 delete from tt2 where a2=:old.a_new;
end;
/
delete from ttv where a_new=10 and b1 > 1;
select * from ttv order by 1,2;
delete from ttv where a_new=11 and b1 > 1;
select * from ttv order by 1,2;


conn sys/Huawei@123@127.0.0.1:1611
drop user IF EXISTS sec cascade;
CREATE USER sec identified BY 'Sec$123456';

drop TABLE IF EXISTS sec.test;
CREATE TABLE IF NOT EXISTS sec.test(id INTEGER auto_increment PRIMARY KEY
                     ,name VARCHAR(10)
                     ,addr VARCHAR(10)
                     );
delete sec.test;
INSERT INTO sec.test(name,addr) values('n1','a1');
INSERT INTO sec.test(name,addr) values('n1','a1');
INSERT INTO sec.test(id,name,addr) values(22,'n1','a1');
INSERT INTO sec.test(id,name,addr) values(25,'n1','a1');
SELECT * FROM sec.test order by 1;
commit;

CREATE or replace function IF NOT EXISTS sec.enc(
  v_varchar varchar2
)
return varchar2 AS
  o_varchar varchar2(200);
BEGIN
  o_varchar:= v_varchar||'enc';
  RETURN o_varchar;
END;
/

CREATE or replace function IF NOT EXISTS sec.dec(
  v_varchar varchar2
)
return varchar2
AS
  o_varchar varchar2(200);
BEGIN
  o_varchar:= substr(v_varchar,1,length(v_varchar)-3);
  RETURN o_varchar;
END;
/

grant execute on sec.dec to public;
grant execute on sec.enc to public;

SELECT sec.dec('xxxenc');
SELECT sec.enc('xxxenc');

ALTER TABLE sec.test RENAME TO SBDC_3CF2C888EFF911E99577D9C70700FFFE;
ALTER TABLE sec.SBDC_3CF2C888EFF911E99577D9C70700FFFE ADD COLUMN name_ text;
UPDATE sec.SBDC_3CF2C888EFF911E99577D9C70700FFFE SET name_=name||'enc',name=NULL;

CREATE OR REPLACE VIEW sec.test_inner AS
SELECT id,
       sec.DEC(name_) AS name,
       addr
  FROM sec.SBDC_3CF2C888EFF911E99577D9C70700FFFE;

CREATE OR REPLACE VIEW sec.test AS
    SELECT id,
           name,
           addr
      FROM sec.test_inner;

select * from sec.SBDC_3CF2C888EFF911E99577D9C70700FFFE order by 1;
select * from sec.test order by 1;

create or replace trigger sec.tri_ins_sbdc_3cf2c888eff911e99577d9c70700fffe
instead of insert on sec.test for each row
begin
  insert into sec.sbdc_3cf2c888eff911e99577d9c70700fffe(id,name,addr,name_)
  values (:new.id,:new.name,:new.addr,sec.enc(:new.name));
   update sec.sbdc_3cf2c888eff911e99577d9c70700fffe
      set name=null
    where id=:old.id;
end;
/

create or replace trigger sec.tri_upd_sbdc_3cf2c888eff911e99577d9c70700fffe
instead of update on sec.test for each row
begin
  update sec.sbdc_3cf2c888eff911e99577d9c70700fffe
     set id =:new.id,name=:new.name,addr=:new.addr,name_=sec.enc(:new.name)
   where id =:old.id;

  update sec.sbdc_3cf2c888eff911e99577d9c70700fffe
     set name=null
   where id  =:old.id;
end;
/

create or replace trigger sec.tri_del_sbdc_3cf2c888eff911e99577d9c70700fffe
instead of delete on sec.test for each row
begin
  delete from sec.sbdc_3cf2c888eff911e99577d9c70700fffe where id=:old.id;
end;
/

delete sec.test where id = 1;
select * from sec.sbdc_3cf2c888eff911e99577d9c70700fffe order by 1;
rollback;

update sec.test set name='oracle' where id = 22;
select * from sec.sbdc_3cf2c888eff911e99577d9c70700fffe order by 1;
rollback;

INSERT INTO sec.test(name,addr) values('n1','a1');
select * from sec.sbdc_3cf2c888eff911e99577d9c70700fffe order by 1;

drop table if exists cus_rowid;
drop view if exists cus_view;
CREATE TABLE cus_rowid(customer_id number);
insert into cus_rowid values(10);
create view cus_view as select * from cus_rowid;
create or replace trigger rowid_instead instead of delete on cus_view
begin
    delete from cus_rowid where rowid = :old.rowid;
end;
/
delete from cus_view where rowid  = (select rowid  from cus_view where customer_id=10);
select count(*) from cus_view;

drop table if exists fvt_format_csf_table_05_02;
create table fvt_format_csf_table_05_02
(
c_int number,
c_number number,
c_varchar number default 0,
c_date number not null
);

create unique index fvt_format_csf_table_05_02_idx1 on fvt_format_csf_table_05_02(c_int,c_number,c_varchar,c_date);
create or replace view fvt_format_csf_table_05_02_v as select * from fvt_format_csf_table_05_02;

create or replace trigger fvt_format_csf_tri_01  instead of insert on fvt_format_csf_table_05_02_v
begin
       insert into fvt_format_csf_table_05_02 values(:new.c_Int,:new.c_number,:new.c_varchar,:new.c_date);
end;
/

insert into fvt_format_csf_table_05_02_v values(1,3.25,0,0);
replace into fvt_format_csf_table_05_02_v values(1,3.25,0,0);

drop user sec cascade;
set serveroutput off;