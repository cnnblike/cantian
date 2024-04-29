--- test lob inline normal
drop table if exists lob_inline_t1;
create table lob_inline_t1(a int,b VARCHAR(4000),c clob);
insert into lob_inline_t1 values(1,LPAD('a',3300,'a'),LPAD('b',3999,'b'));
insert into lob_inline_t1 values(2,LPAD('c',3300,'c'),LPAD('d',3999,'d'));
insert into lob_inline_t1 values(3,LPAD('e',3300,'e'),LPAD('f',3999,'f'));
insert into lob_inline_t1 values(4,LPAD('g',3300,'g'),LPAD('h',3999,'h'));
insert into lob_inline_t1 values(5,LPAD('i',3300,'i'),LPAD('j',3999,'j'));
commit;
select length(b),length(c) from lob_inline_t1;
delete from lob_inline_t1;
commit;
select * from lob_inline_t1;

drop table if exists lob_inline_t1;
create table lob_inline_t1(a int,b VARCHAR(4000),c clob);
insert into lob_inline_t1 values(1,LPAD('a',3300,'a'),LPAD('b',3999,'b'));
insert into lob_inline_t1 values(2,LPAD('c',3300,'c'),LPAD('d',3999,'d'));
insert into lob_inline_t1 values(3,LPAD('e',3300,'e'),LPAD('f',3999,'f'));
insert into lob_inline_t1 values(4,LPAD('g',3300,'g'),LPAD('h',3999,'h'));
insert into lob_inline_t1 values(5,LPAD('i',3300,'i'),LPAD('j',3999,'j'));
rollback;
select length(b),length(c) from lob_inline_t1;
delete from lob_inline_t1;
rollback;
select length(b),length(c) from lob_inline_t1;

---commit to inline to inline
drop table if exists lob_inline_t1;
create table lob_inline_t1(a int,b VARCHAR(4000),c clob);
insert into lob_inline_t1 values(1,LPAD('a',3300,'a'),LPAD('b',3999,'b'));
commit;
select * from lob_inline_t1 where a = 1;
update lob_inline_t1 set c = LPAD('a',3999,'a') where a = 1;
commit;
select * from lob_inline_t1 where a = 1;

---commit to inline to outline
drop table if exists lob_inline_t1;
create table lob_inline_t1(a int,b VARCHAR(4000),c clob);
insert into lob_inline_t1 values(1,LPAD('a',3300,'a'),LPAD('b',3999,'b'));
commit;
select * from lob_inline_t1 where a = 1;
update lob_inline_t1 set c = LPAD('a',5999,'a') where a = 1;
commit;
select * from lob_inline_t1 where a = 1;

---commit to outline to inline
drop table if exists lob_inline_t1;
create table lob_inline_t1(a int,b VARCHAR(4000),c clob);
insert into lob_inline_t1 values(1,LPAD('a',3300,'a'),LPAD('b',8999,'b'));
commit;
select * from lob_inline_t1 where a = 1;
update lob_inline_t1 set c = LPAD('a',3999,'a') where a = 1;
commit;
select * from lob_inline_t1 where a = 1;

---rollback to inline to inline
drop table if exists lob_inline_t1;
create table lob_inline_t1(a int,b VARCHAR(4000),c clob);
insert into lob_inline_t1 values(1,LPAD('a',3300,'a'),LPAD('b',3999,'b'));
commit;
select * from lob_inline_t1 where a = 1;
update lob_inline_t1 set c = LPAD('a',3999,'a') where a = 1;
select * from lob_inline_t1 where a = 1;
rollback;
select * from lob_inline_t1 where a = 1;

---rollback to inline to outline
drop table if exists lob_inline_t1;
create table lob_inline_t1(a int,b VARCHAR(4000),c clob);
insert into lob_inline_t1 values(1,LPAD('a',3300,'a'),LPAD('b',3999,'b'));
commit;
select * from lob_inline_t1 where a = 1;
update lob_inline_t1 set c = LPAD('a',5999,'a') where a = 1;
select * from lob_inline_t1 where a = 1;
rollback;
select * from lob_inline_t1 where a = 1;

---rollback to outline to inline
drop table if exists lob_inline_t1;
create table lob_inline_t1(a int,b VARCHAR(4000),c clob);
insert into lob_inline_t1 values(1,LPAD('a',3300,'a'),LPAD('b',8999,'b'));
commit;
select * from lob_inline_t1 where a = 1;
update lob_inline_t1 set c = LPAD('a',3999,'a') where a = 1;
select * from lob_inline_t1 where a = 1;
rollback;
select * from lob_inline_t1 where a = 1;

--- test try lob inline,after lob outline
drop table if exists lob_inline_t2;
create table lob_inline_t2(
id int,
var1 VARCHAR(8000),
var2 VARCHAR(8000),
var3 VARCHAR(8000),
var4 VARCHAR(8000),
lob1 clob,
var5 VARCHAR(8000),
lob2 clob,
var6 VARCHAR(8000),
var7 VARCHAR(8000),
lob3 clob,
lob4 clob,
lob5 clob
);

insert into lob_inline_t2 values(1,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(2,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(3,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(4,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(5,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(6,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(7,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(8,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(9,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 


--- test try lob inline,after lob outline dml
drop table if exists lob_inline_t2;
create table lob_inline_t2(
id int,
var1 VARCHAR(8000),
var2 VARCHAR(8000),
var3 VARCHAR(8000),
var4 VARCHAR(8000),
lob1 clob,
var5 VARCHAR(8000),
lob2 clob,
var6 VARCHAR(8000),
var7 VARCHAR(8000),
lob3 clob,
lob4 clob,
lob5 clob
);

insert into lob_inline_t2 values(1,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(2,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(3,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(4,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
rollback;
insert into lob_inline_t2 values(5,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(6,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(7,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(8,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(9,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
commit;
delete from lob_inline_t2;
select * from lob_inline_t2;
rollback;

delete from lob_inline_t2;
commit;

--- test try lob inline,after lob outline error
drop table if exists lob_inline_t2;
create table lob_inline_t2(
id int,
var1 VARCHAR(8000),
var2 VARCHAR(8000),
var3 VARCHAR(8000),
var4 VARCHAR(8000),
var5  VARCHAR(8000),
var6 VARCHAR(8000),
lob1 clob,
var7 VARCHAR(8000),
var8 VARCHAR(7990),
lob2 clob,
lob3 clob
);

insert into lob_inline_t2 values(1,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',7950,'a'),LPAD('2',3940,'2'),LPAD('2',3940,'2')); 

--- test try lob inline,after lob outline
drop table if exists lob_inline_t2;
create table lob_inline_t2(
id int,
var1 VARCHAR(8000),
var2 VARCHAR(8000),
var3 VARCHAR(8000),
var4 VARCHAR(8000),
lob1 clob,
var5 VARCHAR(8000),
lob2 clob,
var6 VARCHAR(8000),
var7 VARCHAR(8000),
lob3 clob,
lob4 clob,
lob5 clob
);

insert into lob_inline_t2 values(1,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(2,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(3,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(4,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(5,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(6,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(7,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(8,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
insert into lob_inline_t2 values(9,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('1',340,'1'),LPAD('a',8000,'a'),LPAD('2',3940,'2'), LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',3940,'3'),LPAD('4',3940,'4'),LPAD('5',340,'5')); 
commit;

update lob_inline_t2 set lob1 =  LPAD('1',400,'1');
update lob_inline_t2 set lob5 =  LPAD('1',8400,'1');
rollback;
delete from lob_inline_t2;
commit;

--test update inline to online
drop table if exists lob_inline_t1;
create table lob_inline_t1(a int,b VARCHAR(4000),c clob);
insert into lob_inline_t1 values(1,LPAD('a',3300,'a'),LPAD('b',3900,'b'));
insert into lob_inline_t1 values(2,LPAD('c',3300,'c'),LPAD('d',3900,'d'));
insert into lob_inline_t1 values(3,LPAD('e',3300,'e'),LPAD('f',3900,'f'));
insert into lob_inline_t1 values(1,LPAD('a',3300,'a'),LPAD('b',3900,'b'));
insert into lob_inline_t1 values(2,LPAD('c',3300,'c'),LPAD('d',3900,'d'));
insert into lob_inline_t1 values(3,LPAD('e',3300,'e'),LPAD('f',3900,'f'));
commit;
update lob_inline_t1 set c = LPAD('b',4900,'b');
commit;
select length(c) from lob_inline_t1;

--test update outline to inline
drop table if exists lob_inline_t1;
create table lob_inline_t1(a int,b VARCHAR(4000),c clob);
insert into lob_inline_t1 values(1,LPAD('a',3300,'a'),LPAD('b',4900,'b'));
insert into lob_inline_t1 values(2,LPAD('c',3300,'c'),LPAD('d',4900,'d'));
insert into lob_inline_t1 values(3,LPAD('e',3300,'e'),LPAD('f',4900,'f'));
commit;
update lob_inline_t1 set c = LPAD('b',3800,'b');
commit;
select length(c) from lob_inline_t1;

--test update info size inline to outline
drop table if exists lob_inline_t2;
create table lob_inline_t2(
var1 VARCHAR(8000),
var2 VARCHAR(8000),
var3 VARCHAR(8000),
var4 VARCHAR(8000),
lob1 clob,
var5 VARCHAR(8000),
lob2 clob,
var6 VARCHAR(8000),
var7 VARCHAR(8000),
lob3 clob,
lob4 clob,
lob5 clob
);
insert into lob_inline_t2 values(null,null,null,null,null,null,null,null,null,null,null,null);
commit;

update lob_inline_t2 set 
var1 = LPAD('a',8000,'a'),
var2 = LPAD('b',8000,'b'),
var3 = LPAD('c',8000,'c'),
var4 = LPAD('d',8000,'d'),
lob1 = LPAD('1',340,'1'),
var5 = LPAD('e',8000,'e'),
lob2 = LPAD('2',3940,'2'),
var6 = LPAD('f',8000,'f'),
var7 = LPAD('g',8000,'g'),
lob3 = LPAD('3',3940,'3'),
lob4 = LPAD('4',3940,'4'),
lob5 = LPAD('5',340,'5');
commit;
 
select length(var1) from lob_inline_t2;
select length(var2) from lob_inline_t2;
select length(var3) from lob_inline_t2;
select length(var4) from lob_inline_t2;
select length(lob1) from lob_inline_t2;
select length(var5) from lob_inline_t2;
select length(lob2) from lob_inline_t2;
select length(var6) from lob_inline_t2;
select length(var7) from lob_inline_t2;
select length(lob3) from lob_inline_t2;
select length(lob4) from lob_inline_t2;
select length(lob5) from lob_inline_t2;

delete from lob_inline_t2;
commit;

insert into lob_inline_t2 values(null,null,null,null,'hzy',null,null,null,null,null,null,null);
commit;

update lob_inline_t2 set 
var1 = LPAD('a',8000,'a'),
var2 = LPAD('b',8000,'b'),
var3 = LPAD('c',8000,'c'),
var4 = LPAD('d',8000,'d'),
lob1 = null,
var5 = LPAD('e',8000,'e'),
lob2 = LPAD('2',3940,'2'),
var6 = LPAD('f',8000,'f'),
var7 = LPAD('g',8000,'g'),
lob3 = LPAD('3',3940,'3'),
lob4 = LPAD('4',3940,'4'),
lob5 = LPAD('5',340,'5');
commit;

select length(var1) from lob_inline_t2;
select length(var2) from lob_inline_t2;
select length(var3) from lob_inline_t2;
select length(var4) from lob_inline_t2;
select length(lob1) from lob_inline_t2;
select length(var5) from lob_inline_t2;
select length(lob2) from lob_inline_t2;
select length(var6) from lob_inline_t2;
select length(var7) from lob_inline_t2;
select length(lob3) from lob_inline_t2;
select length(lob4) from lob_inline_t2;
select length(lob5) from lob_inline_t2;

--- test try update lob inline,after lob outline error
drop table if exists lob_inline_t2;
create table lob_inline_t2(
id int,
var1 VARCHAR(8000),
var2 VARCHAR(8000),
var3 VARCHAR(8000),
var4 VARCHAR(8000),
var5 VARCHAR(8000),
var6 VARCHAR(8000),
lob1 clob,
var7 VARCHAR(8000),
var8 VARCHAR(7990),
lob2 clob,
lob3 clob
);
insert into lob_inline_t2 values(null,null,null,null,'hzy',null,null,null,null,null,null,null);
commit;

update lob_inline_t2 set 
var1 = LPAD('a',8000,'a'),
var2 = LPAD('a',8000,'a'),
var3 = LPAD('a',8000,'a'),
var4 = LPAD('a',8000,'a'),
var5 = LPAD('a',8000,'a'),
var6 = LPAD('a',8000,'a'),
lob1 = LPAD('2',3940,'2'),
var7 = LPAD('a',8000,'a'),
var8 = LPAD('a',7950,'a'),
lob2 = LPAD('3',3940,'3'),
lob3 = LPAD('3',3940,'3');
commit;

--- test try update lob inline,after lob outline normal with null
update lob_inline_t2 set 
var1 = LPAD('a',8000,'a'),
var2 = LPAD('a',8000,'a'),
var3 = LPAD('a',8000,'a'),
var4 = LPAD('a',8000,'a'),
var5 = LPAD('a',8000,'a'),
var6 = LPAD('a',8000,'a'),
lob1 = LPAD('2',3940,'2'),
var7 = LPAD('a',8000,'a'),
var8 = LPAD('a',6000,'a'),
lob2 = LPAD('3',940,'3'),
lob3 = LPAD('3',940,'3');
commit;

update lob_inline_t2 set 
var1 = LPAD('a',8000,'a'),
var2 = LPAD('a',8000,'a'),
var3 = LPAD('a',8000,'a'),
var4 = LPAD('a',8000,'a'),
var5 = LPAD('a',8000,'a'),
var6 = null,
lob1 = LPAD('2',3940,'2'),
var7 = null,
var8 = LPAD('a',7000,'a'),
lob2 = LPAD('3',3940,'3'),
lob3 = LPAD('3',3940,'3');
commit;

--- test try update no-lob column,after lob outline normal
update lob_inline_t2 set 
var6 = LPAD('a',8000,'a'),
var7 = LPAD('a',8000,'a');
commit;

select length(var1) from lob_inline_t2;
select length(var2) from lob_inline_t2;
select length(var3) from lob_inline_t2;
select length(var4) from lob_inline_t2;
select length(lob1) from lob_inline_t2;
select length(var5) from lob_inline_t2;
select length(lob2) from lob_inline_t2;
select length(var6) from lob_inline_t2;
select length(var7) from lob_inline_t2;
select length(lob3) from lob_inline_t2;


create user hzy_inline1 identified by Cantian_234;
GRANT CREATE SESSION TO hzy_inline1;
grant create table to hzy_inline1;
grant dba to hzy_inline1;
drop table if exists hzy_inline1.STORAGE_LOB_INLINE_TBL_000;
CREATE TABLE hzy_inline1.STORAGE_LOB_INLINE_TBL_000(C_ID INT,
C_D_ID int NOT NULL,
C_W_ID int NOT NULL,
C_FIRST1 VARCHAR(100) NOT NULL,
C_FIRST2 VARCHAR(100) NOT NULL,
C_FIRST3 VARCHAR(100) NOT NULL,
C_FIRST4 VARCHAR(100) NOT NULL,
C_FIRST5 VARCHAR(100) NOT NULL,
C_FIRST6 VARCHAR(100) NOT NULL,
C_FIRST7 VARCHAR(100) NOT NULL,
C_FIRST8 VARCHAR(100) NOT NULL,
C_DATA LONG,
C_TEXT BLOB,
C_CLOB CLOB);
insert into  hzy_inline1.STORAGE_LOB_INLINE_TBL_000 values(0,0,0,'AA','BB','CC','DD','EE','FF','GG','HH','LONG','111','CLOB');
commit;
CREATE or replace procedure hzy_inline1_lob_inline_proc_001(startall int,endall int) as
i INT;
BEGIN
 if startall <= endall then
  FOR i IN startall..endall LOOP
        insert into hzy_inline1.STORAGE_LOB_INLINE_TBL_000 select c_id+i,c_d_id+i,c_w_id+i,'AA'||i,'BB'||i,'CC'||i,'DD'||i,'EE'||i,'FF'||i,'GG'||i,'HH'||i,c_data,c_text,c_clob from hzy_inline1.STORAGE_LOB_INLINE_TBL_000 where c_id=0;commit;
  END LOOP;
 end if;
END;
/
call hzy_inline1_lob_inline_proc_001(1,10);
delete from hzy_inline1.STORAGE_LOB_INLINE_TBL_000 where c_id=0;
commit;
select count(*) from hzy_inline1.STORAGE_LOB_INLINE_TBL_000;

drop table if exists hzy_inline1.STORAGE_LOB_INLINE_TBL_003;
CREATE TABLE hzy_inline1.STORAGE_LOB_INLINE_TBL_003(C_ID INT,C_D_ID int NOT NULL,C_W_ID int NOT NULL,C_FIRST1 VARCHAR(8000) NOT NULL,C_FIRST2 VARCHAR(8000) NOT NULL,C_FIRST3 VARCHAR(8000) NOT NULL,C_FIRST4 VARCHAR(8000) NOT NULL,C_FIRST5 VARCHAR(8000) NOT NULL,C_FIRST6 VARCHAR(8000) NOT NULL,C_FIRST7 VARCHAR(8000) NOT NULL,C_FIRST8 VARCHAR(8000) NOT NULL,C_DATA LONG,C_TEXT BLOB,C_CLOB CLOB);
insert into hzy_inline1.STORAGE_LOB_INLINE_TBL_003 select C_ID,C_D_ID,C_W_ID,C_FIRST1,C_FIRST2,C_FIRST3,C_FIRST4,C_FIRST5,C_FIRST6,C_FIRST7,C_FIRST8,C_DATA,C_TEXT,C_CLOB from hzy_inline1.STORAGE_LOB_INLINE_TBL_000 where mod(c_id,3)=0;
insert into hzy_inline1.STORAGE_LOB_INLINE_TBL_003 select C_ID,C_D_ID,C_W_ID,lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),C_DATA,C_TEXT,C_CLOB from hzy_inline1.STORAGE_LOB_INLINE_TBL_000 where mod(c_id,3)=1;
insert into hzy_inline1.STORAGE_LOB_INLINE_TBL_003 select C_ID,C_D_ID,C_W_ID,C_FIRST1,C_FIRST2,C_FIRST3,C_FIRST4,C_FIRST5,C_FIRST6,C_FIRST7,C_FIRST8,lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',4000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('123456656565767',4000,'565656576768787'),C_CLOB from hzy_inline1.STORAGE_LOB_INLINE_TBL_000 where mod(c_id,3)=2;

commit;
alter table hzy_inline1.STORAGE_LOB_INLINE_TBL_003  add column C_LAST1 varchar(8000) default lpad('c_last1acwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm');
alter table hzy_inline1.STORAGE_LOB_INLINE_TBL_003  add column C_LAST1 long default lpad('c_last1acwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm');

drop table if exists lob_inline_10250;
CREATE TABLE lob_inline_10250(C_ID INT,
C_D_ID int NOT NULL,
C_W_ID int NOT NULL,
C_FIRST1 VARCHAR(100) NOT NULL,
C_FIRST2 VARCHAR(100) NOT NULL,
C_FIRST3 VARCHAR(100) NOT NULL,
C_FIRST4 VARCHAR(100) NOT NULL,
C_FIRST5 VARCHAR(100) NOT NULL,
C_FIRST6 VARCHAR(100) NOT NULL,
C_FIRST7 VARCHAR(100) NOT NULL,
C_FIRST8 VARCHAR(100) NOT NULL,
C_DATA LONG,
C_TEXT BLOB,
C_CLOB CLOB);
insert into  lob_inline_10250 values(0,0,0,'AA','BB','CC','DD','EE','FF','GG','HH','LONG','111','CLOB');
commit;
CREATE or replace procedure nebula_lob_inline_proc_001(startall int,endall int) as
i INT;
BEGIN
 if startall <= endall then
  FOR i IN startall..endall LOOP
        insert into lob_inline_10250 select c_id+i,c_d_id+i,c_w_id+i,'AA'||i,'BB'||i,'CC'||i,'DD'||i,'EE'||i,'FF'||i,'GG'||i,'HH'||i,c_data,c_text,c_clob from lob_inline_10250 where c_id=0;commit;
  END LOOP;
 end if;
END;
/
call nebula_lob_inline_proc_001(1,3);
delete from lob_inline_10250 where c_id=0;
commit;
select count(*) from lob_inline_10250;

drop table if exists lob_inline_10254;
CREATE TABLE lob_inline_10254(C_ID INT,C_D_ID int NOT NULL,C_W_ID int NOT NULL,C_FIRST1 VARCHAR(8000) NOT NULL,C_FIRST2 VARCHAR(8000) NOT NULL,C_FIRST3 VARCHAR(8000) NOT NULL,C_FIRST4 VARCHAR(8000) NOT NULL,C_FIRST5 VARCHAR(8000) NOT NULL,C_FIRST6 VARCHAR(8000) NOT NULL,C_FIRST7 VARCHAR(8000) NOT NULL,C_FIRST8 VARCHAR(8000) NOT NULL,C_DATA LONG,C_TEXT BLOB,C_CLOB CLOB);
insert into lob_inline_10254 select C_ID,C_D_ID,C_W_ID,C_FIRST1,C_FIRST2,C_FIRST3,C_FIRST4,C_FIRST5,C_FIRST6,C_FIRST7,C_FIRST8,C_DATA,C_TEXT,C_CLOB from lob_inline_10250 where mod(c_id,3)=0;
insert into lob_inline_10254 select C_ID,C_D_ID,C_W_ID,lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),C_DATA,C_TEXT,C_CLOB from lob_inline_10250 where mod(c_id,3)=1;
insert into lob_inline_10254 select C_ID,C_D_ID,C_W_ID,C_FIRST1,C_FIRST2,C_FIRST3,C_FIRST4,C_FIRST5,C_FIRST6,C_FIRST7,C_FIRST8,lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',4000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('123456656565767',4000,'565656576768787'),C_CLOB from lob_inline_10250 where mod(c_id,3)=2;
commit;

alter table lob_inline_10254  add column  v_long1 long default lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',3900,'yxcfgdsgtcsdsjxrbxxbm');

alter table lob_inline_10254  add column  v_long2 long default lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',3900,'yxcfgdsgtcsdsjxrbxxbm');

drop table if exists lob_inline_10250;
CREATE TABLE lob_inline_10250(C_ID INT,
C_D_ID int NOT NULL,
C_W_ID int NOT NULL,
C_FIRST1 VARCHAR(100) NOT NULL,
C_FIRST2 VARCHAR(100) NOT NULL,
C_FIRST3 VARCHAR(100) NOT NULL,
C_FIRST4 VARCHAR(100) NOT NULL,
C_FIRST5 VARCHAR(100) NOT NULL,
C_FIRST6 VARCHAR(100) NOT NULL,
C_FIRST7 VARCHAR(100) NOT NULL,
C_FIRST8 VARCHAR(100) NOT NULL,
C_DATA LONG,
C_TEXT BLOB,
C_CLOB CLOB);
insert into  lob_inline_10250 values(0,0,0,'AA','BB','CC','DD','EE','FF','GG','HH','LONG','111','CLOB');
commit;
CREATE or replace procedure nebula_lob_inline_proc_001(startall int,endall int) as
i INT;
BEGIN
 if startall <= endall then
  FOR i IN startall..endall LOOP
        insert into lob_inline_10250 select c_id+i,c_d_id+i,c_w_id+i,'AA'||i,'BB'||i,'CC'||i,'DD'||i,'EE'||i,'FF'||i,'GG'||i,'HH'||i,c_data,c_text,c_clob from lob_inline_10250 where c_id=0;commit;
  END LOOP;
 end if;
END;
/
call nebula_lob_inline_proc_001(1,10);
delete from lob_inline_10250 where c_id=0;
commit;
select count(*) from lob_inline_10250;

drop table if exists lob_inline_10252;
CREATE TABLE lob_inline_10252(C_ID INT,C_D_ID int NOT NULL,C_W_ID int NOT NULL,C_FIRST1 VARCHAR(8000) NOT NULL,C_FIRST2 VARCHAR(8000) NOT NULL,C_FIRST3 VARCHAR(8000) NOT NULL,C_FIRST4 VARCHAR(8000) NOT NULL,C_FIRST5 VARCHAR(8000) NOT NULL,C_FIRST6 VARCHAR(8000) NOT NULL,C_FIRST7 VARCHAR(8000) NOT NULL,C_FIRST8 VARCHAR(8000) NOT NULL,C_DATA LONG,C_TEXT BLOB,C_CLOB CLOB);
insert into lob_inline_10252 select C_ID,C_D_ID,C_W_ID,C_FIRST1,C_FIRST2,C_FIRST3,C_FIRST4,C_FIRST5,C_FIRST6,C_FIRST7,C_FIRST8,C_DATA,C_TEXT,C_CLOB from lob_inline_10250 where mod(c_id,3)=0;
insert into lob_inline_10252 select C_ID,C_D_ID,C_W_ID,lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),C_DATA,C_TEXT,C_CLOB from lob_inline_10250 where mod(c_id,3)=1;
insert into lob_inline_10252 select C_ID,C_D_ID,C_W_ID,C_FIRST1,C_FIRST2,C_FIRST3,C_FIRST4,C_FIRST5,C_FIRST6,C_FIRST7,C_FIRST8,lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',4000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('123456656565767',4000,'565656576768787'),C_CLOB from lob_inline_10250 where mod(c_id,3)=2;
commit;
update lob_inline_10252 set C_DATA=lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),C_CLOB=lpad('c_datajhfpyxcpmnutcjxrbfgxxbm',4000,'yxcfgdsgtcsdsjxrbxxbm'), C_TEXT=lpad('45454545454545454565656767676',5000,'676878787879898989898');

--- DTS2018103107930
drop table if exists lob_11050;
create table lob_11050(c_id int,c_d_id bigint NOT NULL,c_w_id tinyint unsigned NOT NULL,c_first varchar(16) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data1 varchar(8000),c_data2 varchar(8000),c_data3 varchar(8000),c_data4 varchar(8000),c_data5 varchar(8000),c_data6 varchar(8000),c_data7 varchar(8000),c_data8 varchar(8000),c_data9 varchar(4000),c_data10 varchar(4000),c_clob clob,c_text blob);
CREATE or replace procedure lob_proc_000(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    select cast(i as varchar(10)) into j from dual;
    insert into lob_11050 select 1,i,i,'iscmRDs1','OE','BARBar'||j,'bkilifcrRGF'||j,'pmbwovhSDGj'||j,'dyfrDa'||j,'uq','4801'||j,'940215'||j,sysdate,'GC',50000.0,0.4361328,-10.0,10.0,1,true,sysdate,lpad('QVBRfSCC3484942ZCSfjvCF',4000,'QVLDBURhlhfrc484ZCSfjF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',3000,'1435764ABC7890abcdef'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',4000,'1435764ABC7890abcdef') from dual;
     insert into lob_11050 select 2,i+100,i+100,'iscmRDs2','OE','BARBar'||j,'bkilifcrRGF'||j,'pmbwovhSDGj'||j,'dyfrDa'||j,'uq','4801'||j,'940215'||j,sysdate,'GC',50000.0,0.4361328,-10.0,10.0,1,true,sysdate,lpad('QVBRfSCC3484942ZCSfjvCF',4000,'QVLDBURhlhfrc484ZCSfjF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',3000,'1435764ABC7890abcdef'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',4000,'1435764ABC7890abcdef') from dual;
    insert into lob_11050 select 3,i+200,i+200,'iscmRDs3','OE','BARBar'||j,'bkilifcrRGF'||j,'pmbwovhSDGj'||j,'dyfrDa'||j,'uq','4801'||j,'940215'||j,sysdate,'GC',50000.0,0.4361328,-10.0,10.0,1,true,sysdate,lpad('QVBRfSCC3484942ZCSfjvCF',4000,'QVLDBURhlhfrc484ZCSfjF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',3000,'1435764ABC7890abcdef'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',4000,'1435764ABC7890abcdef') from dual;
    insert into lob_11050 select 4,i+300,i+300,'iscmRDs4','OE','BARBar'||j,'bkilifcrRGF'||j,'pmbwovhSDGj'||j,'dyfrDa'||j,'uq','4801'||j,'940215'||j,sysdate,'GC',50000.0,0.4361328,-10.0,10.0,1,true,sysdate,lpad('QVBRfSCC3484942ZCSfjvCF',4000,'QVLDBURhlhfrc484ZCSfjF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',3000,'1435764ABC7890abcdef'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',4000,'1435764ABC7890abcdef') from dual;
    insert into lob_11050 select 5,i+400,i+400,'iscmRDs5','OE','BARBar'||j,'bkilifcrRGF'||j,'pmbwovhSDGj'||j,'dyfrDa'||j,'uq','4801'||j,'940215'||j,sysdate,'GC',50000.0,0.4361328,-10.0,10.0,1,true,sysdate,lpad('QVBRfSCC3484942ZCSfjvCF',4000,'QVLDBURhlhfrc484ZCSfjF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',3000,'1435764ABC7890abcdef'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',4000,'1435764ABC7890abcdef') from dual;
    insert into lob_11050 select 6,i+500,i+500,'iscmRDs6','OE','BARBar'||j,'bkilifcrRGF'||j,'pmbwovhSDGj'||j,'dyfrDa'||j,'uq','4801'||j,'940215'||j,sysdate,'GC',50000.0,0.4361328,-10.0,10.0,1,true,sysdate,lpad('QVBRfSCC3484942ZCSfjvCF',4000,'QVLDBURhlhfrc484ZCSfjF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',3000,'1435764ABC7890abcdef'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',4000,'1435764ABC7890abcdef') from dual;
    insert into lob_11050 select 7,i+600,i+600,'iscmRDs7','OE','BARBar'||j,'bkilifcrRGF'||j,'pmbwovhSDGj'||j,'dyfrDa'||j,'uq','4801'||j,'940215'||j,sysdate,'GC',50000.0,0.4361328,-10.0,10.0,1,true,sysdate,lpad('QVBRfSCC3484942ZCSfjvCF',4000,'QVLDBURhlhfrc484ZCSfjF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',3000,'1435764ABC7890abcdef'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',4000,'1435764ABC7890abcdef') from dual;
    insert into lob_11050 select 8,i+700,i+700,'iscmRDs8','OE','BARBar'||j,'bkilifcrRGF'||j,'pmbwovhSDGj'||j,'dyfrDa'||j,'uq','4801'||j,'940215'||j,sysdate,'GC',50000.0,0.4361328,-10.0,10.0,1,true,sysdate,lpad('QVBRfSCC3484942ZCSfjvCF',4000,'QVLDBURhlhfrc484ZCSfjF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',3000,'1435764ABC7890abcdef'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',4000,'1435764ABC7890abcdef') from dual;
    insert into lob_11050 select 9,i+800,i+800,'iscmRDs9','OE','BARBar'||j,'bkilifcrRGF'||j,'pmbwovhSDGj'||j,'dyfrDa'||j,'uq','4801'||j,'940215'||j,sysdate,'GC',50000.0,0.4361328,-10.0,10.0,1,true,sysdate,lpad('QVBRfSCC3484942ZCSfjvCF',4000,'QVLDBURhlhfrc484ZCSfjF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',3000,'1435764ABC7890abcdef'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',4000,'1435764ABC7890abcdef') from dual;
    insert into lob_11050 select 10,i+900,i+900,'iscmRDs10','OE','BARBar'||j,'bkilifcrRGF'||j,'pmbwovhSDGj'||j,'dyfrDa'||j,'uq','4801'||j,'940215'||j,sysdate,'GC',50000.0,0.4361328,-10.0,10.0,1,true,sysdate,lpad('QVBRfSCC3484942ZCSfjvCF',4000,'QVLDBURhlhfrc484ZCSfjF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',3000,'1435764ABC7890abcdef'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',4000,'1435764ABC7890abcdef') from dual;
  END LOOP;
END;
/
call lob_proc_000(1,10);
commit;

drop table if exists lob_11051;
create table lob_11051(c_id int,c_d_id bigint NOT NULL,c_w_id tinyint unsigned NOT NULL,c_first varchar(16) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data1 varchar(8000),c_data2 varchar(8000),c_data3 varchar(8000),c_data4 varchar(8000),c_data5 varchar(8000),c_data6 varchar(8000),c_data7 varchar(8000),c_data8 varchar(8000),c_data9 varchar(4000),c_data10 varchar(4000),c_clob clob,c_text blob) partition by list(c_id,c_first) (PARTITION PART_1 VALUES ((1,'iscmRDs1'),(2,'iscmRDs2'),(1,'iscmRDs1aa'),(2,'iscmRDs2aa'),(1,'iscmRDs1aaaa'),(2,'iscmRDs2aaaa'),(1,'ISCMRDS1'),(2,'ISCMRDS2'),(1,'ISCMRDS1AA'),(2,'ISCMRDS2AA'),(1,'ISCMRDS1AAAA'),(2,'ISCMRDS2AAAA')),PARTITION PART_2 VALUES ((3,'iscmRDs3'),(4,'iscmRDs4'),(3,'iscmRDs3aa'),(4,'iscmRDs4aa'),(3,'iscmRDs3aaaa'),(4,'iscmRDs4aaaa'),(3,'ISCMRDS3'),(4,'ISCMRDS4'),(3,'ISCMRDS3AA'),(4,'ISCMRDS4AA'),(3,'ISCMRDS3AAAA'),(4,'ISCMRDS4AAAA')),PARTITION PART_3 VALUES ((5,'iscmRDs5'),(6,'iscmRDs6'),(5,'iscmRDs5aa'),(6,'iscmRDs6aa'),(5,'iscmRDs5aaaa'),(6,'iscmRDs6aaaa'),(5,'ISCMRDS5'),(6,'ISCMRDS6'),(5,'ISCMRDS5AA'),(6,'ISCMRDS6AA'),(5,'ISCMRDS5AAAA'),(6,'ISCMRDS6AAAA')),PARTITION PART_4 VALUES ((7,'iscmRDs7'),(8,'iscmRDs8'),(7,'iscmRDs7aa'),(8,'iscmRDs8aa'),(7,'iscmRDs7aaaa'),(8,'iscmRDs8aaaa'),(7,'ISCMRDS7'),(8,'ISCMRDS8'),(7,'ISCMRDS7AA'),(8,'ISCMRDS8AA'),(7,'ISCMRDS7AAAA'),(8,'ISCMRDS8AAAA')),PARTITION PART_5 VALUES ((9,'iscmRDs9'),(10,'iscmRDs10'),(9,'iscmRDs9aa'),(10,'iscmRDs10aa'),(9,'iscmRDs9aaaa'),(10,'iscmRDs10aaaa'),(10,'iscmRDs10a'),(9,'ISCMRDS9'),(10,'ISCMRDS10'),(9,'ISCMRDS9AA'),(10,'ISCMRDS10AA'),(9,'ISCMRDS9AAAA'),(10,'ISCMRDS10AAAA'),(10,'ISCMRDS10A')),PARTITION PART_6 VALUES (default));
insert into lob_11051 select * from lob_11050;
commit;
CREATE UNIQUE INDEX lob_11051_201_1 ON lob_11051(c_id,c_d_id);
CREATE INDEX lob_11051_201_2 ON lob_11051(c_id) local;
CREATE INDEX lob_11051_201_3 ON lob_11051(c_city);
select distinct substr(c_first,1,7),c_data1,count(*) c1 from lob_11051 group by substr(c_first,1,7),c_data1 order by c1;
savepoint aa;
update lob_11051 set c_d_id=c_d_id+1000,c_w_id=c_w_id+1000,c_since=sysdate,c_first=c_first||'aa',c_data1=c_data1||'aaaaa',c_data2=c_data2||'aaaaa',c_data3=c_data3||'aaaaa',c_data4=c_data4||'aaaaa',c_data5=c_data5||'aaaaa',c_data6=c_data6||'aaaaa',c_data7=c_data7||'aaaaa',c_data8=c_data8||'aaaaa',c_clob=lpad('423rsgsgfeGH',4000,'1435764ABC7def'),c_text=lpad('1234567890',4000,'2354abc') where mod(c_id,3)=0;
select distinct substr(c_first,1,7),c_data1,count(*) c1 from lob_11051 group by substr(c_first,1,7),c_data1 order by c1;
savepoint aa;
update lob_11051 set c_d_id=c_d_id+1000,c_w_id=c_w_id+1000,c_since=sysdate,c_first=c_first||'aa',c_data1=c_data1||'aaaaa',c_data2=c_data2||'aaaaa',c_data3=c_data3||'aaaaa',c_data4=c_data4||'aaaaa',c_data5=c_data5||'aaaaa',c_data6=c_data6||'aaaaa',c_data7=c_data7||'aaaaa',c_data8=c_data8||'aaaaa',c_clob=lpad('423rsgsgfeGH',3000,'1435764ABC7def'),c_text=lpad('1234567890',3000,'2354abc');
select distinct substr(c_first,1,7),c_data1,count(*) c1 from lob_11051 group by substr(c_first,1,7),c_data1 order by c1;
rollback to savepoint aa;
rollback;
select distinct substr(c_first,1,7),c_data1,count(*) c1 from lob_11051 group by substr(c_first,1,7),c_data1 order by c1;

drop table if exists lob_hzy_1115;
create table lob_hzy_1115(c_id int,c_d_id bigint NOT NULL,c_w_id tinyint unsigned NOT NULL,c_first varchar(16) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data1 varchar(4000),c_data2 varchar(4000),c_data3 varchar(4000),c_data4 varchar(4000),c_data5 varchar(4000),c_data6 varchar(4000),c_data7 varchar(4000),c_data8 varchar(4000),c_clob clob,c_blob blob);
CREATE or replace procedure lob_hzy_proc_1115(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    select cast(i as varchar(10)) into j from dual;
    insert into lob_hzy_1115 select i,i,i,'iscmRDs'||j,'OE','BARBar'||j,'bkilifcrRGF'||j,'pmbwovhSDGj'||j,'dyfrDa'||j,'uq','4801'||j,'940215'||j,sysdate,'GC',50000.0,0.4361328,-10.0,10.0,1,true,sysdate,lpad('QVBRfSCC3484942ZCSfjvCF',1500,'QVLDBURhlhfrc484ZCSfjF'),lpad('QVBUflcHOQNvmgfvdPFZSF',1500,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',1500,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',1500,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',1500,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',1500,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',1500,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',1500,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',1500,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',2000,'1435764ABC7890abcdef') from dual;
  END LOOP;
END;
/
call lob_hzy_proc_1115(1,100);
commit;

---DTS2018111401327

drop table if exists lob_hzy_111501;
create table lob_hzy_111501(c_id int,c_d_id bigint NOT NULL,c_w_id tinyint unsigned NOT NULL,c_first varchar(16) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data1 varchar(8000),c_data2 varchar(8000),c_data3 varchar(8000),c_data4 varchar(8000),c_data5 varchar(8000),c_data6 varchar(8000),c_data7 varchar(8000),c_data8 varchar(8000),c_clob clob,c_blob blob);
insert into lob_hzy_111501 select c_id,c_d_id,c_w_id,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,lpad('QVBRfSCC3484942ZCSfjvCF',8000,'QVLDBURhlhfrc484ZCSfjF'),lpad('QVBUflcHOQNvmgfvdPFZSF',8000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',8000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',8000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',8000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',8000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',8000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',5000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',5000,'1435764ABC7890abcdef') from lob_hzy_1115;
commit;

drop table if exists lob_hzy_111501;
create table lob_hzy_111501(c_id int,c_d_id bigint NOT NULL,c_w_id tinyint unsigned NOT NULL,c_first varchar(16) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data1 varchar(8000),c_data2 varchar(8000),c_data3 varchar(8000),c_data4 varchar(8000),c_data5 varchar(8000),c_data6 varchar(8000),c_data7 varchar(8000),c_data8 varchar(8000),c_clob clob,c_blob blob);
insert into lob_hzy_111501 select c_id,c_d_id,c_w_id,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,lpad('QVBRfSCC3484942ZCSfjvCF',8000,'QVLDBURhlhfrc484ZCSfjF'),lpad('QVBUflcHOQNvmgfvdPFZSF',8000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',8000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',8000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',8000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',8000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',8000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',2000,'1435764ABC7890abcdef') from lob_hzy_1115;
commit;
savepoint aa;
insert into lob_hzy_111501 select c_id+100,c_d_id,c_w_id,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,c_data1,c_data2,c_data3,c_data4,c_data5,c_data6,c_data7,c_data8,c_clob,c_blob from lob_hzy_111501;
update lob_hzy_111501 set c_w_id=c_w_id+1,c_since=sysdate,c_data1=upper(c_data1),c_data2=upper(c_data2),c_data3=upper(c_data3),c_data4=upper(c_data4),c_data5=upper(c_data5),c_data6=upper(c_data6),c_data7=upper(c_data7),c_data8=upper(c_data8),c_clob=lpad('234567890adgjklRHKG',4000,'ftiun95'),c_blob=lpad('1112222',5000,'333') where mod(c_id,2)=0;
savepoint bb;
update lob_hzy_111501 set c_w_id=c_w_id+1,c_since=sysdate,c_delivery_cnt=false,c_data1=upper(c_data1),c_data2=upper(c_data2),c_data3=upper(c_data3),c_data4=upper(c_data4),c_data5=upper(c_data5),c_data6=upper(c_data6),c_data7=upper(c_data7),c_data8=upper(c_data8),c_clob=lpad('234567890adgjklRHKG',6000,'ftiun95'),c_blob=lpad('1112222',8000,'333') where mod(c_id,2)=1;
commit;

drop table if exists lob_hzy_111501;
create table lob_hzy_111501(c_id int,c_d_id bigint NOT NULL,c_w_id tinyint unsigned NOT NULL,c_first varchar(16) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data1 varchar(8000),c_data2 varchar(8000),c_data3 varchar(8000),c_data4 varchar(8000),c_data5 varchar(8000),c_data6 varchar(8000),c_data7 varchar(8000),c_data8 varchar(8000),c_clob clob,c_blob blob);
insert into lob_hzy_111501 select c_id,c_d_id,c_w_id,c_first,c_middle,c_last,c_street_1,c_street_2,c_city,c_state,c_zip,c_phone,c_since,c_credit,c_credit_lim,c_discount,c_balance,c_ytd_payment,c_payment_cnt,c_delivery_cnt,c_end,lpad('QVBRfSCC3484942ZCSfjvCF',8000,'QVLDBURhlhfrc484ZCSfjF'),lpad('QVBUflcHOQNvmgfvdPFZSF',8000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',8000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',8000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',8000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',8000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',8000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',5000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',5000,'1435764ABC7890abcdef') from lob_hzy_1115;
commit;

drop table if exists t_case_when_base_002;
CREATE TABLE t_case_when_base_002(
c_id VARCHAR(20),
C_BLOB BLOB
)LOB(C_BLOB_NOT) STORE AS(DISABLE STORAGE IN ROW);  

drop table if exists t_case_when_base_002;
CREATE TABLE t_case_when_base_002(
c_id VARCHAR(20),
C_BLOB BLOB
)LOB(c_id) STORE AS(DISABLE STORAGE IN ROW);

create user hzy_lob identified by Cantian_234;
GRANT CREATE SESSION TO hzy_lob;
grant dba to hzy_lob;
grant create table to hzy_lob;

alter tablespace USERS autopurge off;
purge recyclebin;
CREATE TABLE hzy_lob.STORAGE_LOB_INLINE_TBL_000(C_ID INT,
C_D_ID int NOT NULL,
C_W_ID int NOT NULL,
C_FIRST1 VARCHAR(100) NOT NULL,
C_FIRST2 VARCHAR(100) NOT NULL,
C_FIRST3 VARCHAR(100) NOT NULL,
C_FIRST4 VARCHAR(100) NOT NULL,
C_FIRST5 VARCHAR(100) NOT NULL,
C_FIRST6 VARCHAR(100) NOT NULL,
C_FIRST7 VARCHAR(100) NOT NULL,
C_FIRST8 VARCHAR(100) NOT NULL,
C_DATA LONG,
C_TEXT BLOB,
C_CLOB CLOB);
insert into  hzy_lob.STORAGE_LOB_INLINE_TBL_000 values(0,0,0,'AA','BB','CC','DD','EE','FF','GG','HH','LONG','111','CLOB');
commit;

alter table hzy_lob.STORAGE_LOB_INLINE_TBL_000 add add_double double default 1.001;
alter table hzy_lob.STORAGE_LOB_INLINE_TBL_000 add add_decimal decimal default 1.001;
alter table hzy_lob.STORAGE_LOB_INLINE_TBL_000 add add_number number default 1.001;
alter table hzy_lob.STORAGE_LOB_INLINE_TBL_000 add add_numeric numeric default 1.001;
alter table hzy_lob.STORAGE_LOB_INLINE_TBL_000 add add_char char default 'a';
alter table hzy_lob.STORAGE_LOB_INLINE_TBL_000 add add_varchar varchar(100) default lpad('aa',80,'bb');
alter table hzy_lob.STORAGE_LOB_INLINE_TBL_000 add add_varchar2 varchar2(100) default lpad('aa',80,'bb');
alter table hzy_lob.STORAGE_LOB_INLINE_TBL_000 add add_binary binary(100) default lpad('111',80,'222');
alter table hzy_lob.STORAGE_LOB_INLINE_TBL_000 add varadd_binary varbinary(100) default lpad('111',80,'222');
alter table hzy_lob.STORAGE_LOB_INLINE_TBL_000 add varadd_binary1 date default sysdate;
alter table hzy_lob.STORAGE_LOB_INLINE_TBL_000 add varadd_timestamp timestamp default systimestamp;
alter table hzy_lob.STORAGE_LOB_INLINE_TBL_000 add varadd_boolean boolean default TRUE;
alter table hzy_lob.STORAGE_LOB_INLINE_TBL_000 add add_clob clob default lpad('aa',100,'bb');
alter table hzy_lob.STORAGE_LOB_INLINE_TBL_000 add add_long long default lpad('aa',100,'bb');
alter table hzy_lob.STORAGE_LOB_INLINE_TBL_000 add add_blob blob default lpad('111',100,'222');
alter table hzy_lob.STORAGE_LOB_INLINE_TBL_000 add add_raw raw(100) default lpad('111',100,'222');
alter table hzy_lob.STORAGE_LOB_INLINE_TBL_000 add add_image image default lpad('111',100,'222');
alter table hzy_lob.STORAGE_LOB_INLINE_TBL_000 add add_varchar1 varchar(100) default lpad('aa',80,'bb');

alter tablespace USERS autopurge off;
CREATE TABLE hzy_lob.STORAGE_LOB_INLINE_COM_001(C_ID INT,C_D_ID int NOT NULL,C_W_ID int NOT NULL,C_FIRST1 VARCHAR(4000) NOT NULL,C_FIRST2 VARCHAR(100) NOT NULL,C_FIRST3 VARCHAR(100) NOT NULL,C_FIRST4 VARCHAR(100) NOT NULL,C_FIRST5 VARCHAR(100) NOT NULL,C_FIRST6 VARCHAR(100) NOT NULL,C_FIRST7 VARCHAR(100) NOT NULL,C_FIRST8 VARCHAR(100) NOT NULL,C_DATA LONG,C_TEXT BLOB,C_CLOB CLOB);
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 add add_double double default 1.001;
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 add add_decimal decimal default 1.001;
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 add add_number number default 1.001;
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 add add_numeric numeric default 1.001;
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 add add_char char default 'a';
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 add add_varchar varchar(100) default lpad('aa',80,'bb');
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 add add_varchar2 varchar2(100) default lpad('aa',80,'bb');
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 add add_binary binary(100) default lpad('111',80,'222');
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 add varadd_binary varbinary(100) default lpad('111',80,'222');
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 add varadd_binary1 date default sysdate;
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 add varadd_timestamp timestamp default systimestamp;
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 add varadd_boolean boolean default TRUE;
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 add add_clob clob default lpad('aa',100,'bb');
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 add add_long long default lpad('aa',100,'bb');
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 add add_blob blob default lpad('111',100,'222');
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 add add_raw raw(100) default lpad('111',100,'222');
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 add add_image image default lpad('111',100,'222');
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 add add_varchar1 varchar(100) default lpad('aa',80,'bb');

insert into hzy_lob.STORAGE_LOB_INLINE_COM_001(C_ID,C_D_ID,C_W_ID,C_FIRST1,C_FIRST2,C_FIRST3,C_FIRST4,C_FIRST5,C_FIRST6,C_FIRST7,C_FIRST8,C_DATA,C_TEXT,C_CLOB)select C_ID,C_D_ID,C_W_ID,lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',3500,'yxcfgdsgtcsdsjxrbxxbm'),C_FIRST2,C_FIRST3,C_FIRST4,C_FIRST5,C_FIRST6,C_FIRST7,C_FIRST8,lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',3000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('454545454',2000,'111111113'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',3500,'yxcfgdsgtcsdsjxrbxxbm') from hzy_lob.STORAGE_LOB_INLINE_TBL_000;
commit;
select count(C_ID) from hzy_lob.STORAGE_LOB_INLINE_COM_001;
select distinct C_FIRST1,C_FIRST2,C_FIRST3,C_FIRST4,C_FIRST5,C_FIRST6,C_FIRST7,C_FIRST8,count(C_ID) from hzy_lob.STORAGE_LOB_INLINE_COM_001 group by C_FIRST1,C_FIRST2,C_FIRST3,C_FIRST4,C_FIRST5,C_FIRST6,C_FIRST7,C_FIRST8 order by C_FIRST1;
delete from hzy_lob.STORAGE_LOB_INLINE_COM_001;
commit;
select count(C_ID) from hzy_lob.STORAGE_LOB_INLINE_COM_001;
select distinct C_FIRST1,C_FIRST2,C_FIRST3,C_FIRST4,C_FIRST5,C_FIRST6,C_FIRST7,C_FIRST8,count(C_ID) from hzy_lob.STORAGE_LOB_INLINE_COM_001 group by C_FIRST1,C_FIRST2,C_FIRST3,C_FIRST4,C_FIRST5,C_FIRST6,C_FIRST7,C_FIRST8 order by C_FIRST1;

alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 modify C_FIRST1 varchar(8000) default lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7000,'yxcfgdsgtcsdsjxrbxxbm');
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 modify C_FIRST2 varchar(8000) default lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7000,'yxcfgdsgtcsdsjxrbxxbm');
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 modify C_FIRST3 varchar(8000) default lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7000,'yxcfgdsgtcsdsjxrbxxbm');
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 modify C_FIRST4 varchar(8000) default lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7000,'yxcfgdsgtcsdsjxrbxxbm');
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 modify C_FIRST5 varchar(8000) default lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7000,'yxcfgdsgtcsdsjxrbxxbm');
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 modify C_FIRST6 varchar(8000) default lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7000,'yxcfgdsgtcsdsjxrbxxbm');
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 modify C_FIRST7 varchar(8000) default lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7000,'yxcfgdsgtcsdsjxrbxxbm');
alter table hzy_lob.STORAGE_LOB_INLINE_COM_001 modify C_FIRST8 varchar(8000) default lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7000,'yxcfgdsgtcsdsjxrbxxbm');
insert into hzy_lob.STORAGE_LOB_INLINE_COM_001(C_ID,C_D_ID,C_W_ID,C_FIRST1,C_FIRST2,C_FIRST3,C_FIRST4,C_FIRST5,C_FIRST6,C_FIRST7,C_FIRST8,C_DATA,C_TEXT,C_CLOB) select C_ID,C_D_ID,C_W_ID,lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',7000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),lpad('sbfacwjdafgjyjhfpyxcpmnutcjxrbfgxxbm',8000,'yxcfgdsgtcsdsjxrbxxbm'),C_DATA,C_TEXT,C_CLOB from hzy_lob.STORAGE_LOB_INLINE_TBL_000;
commit;

drop user hzy_lob cascade; 

drop table if exists lob_inline2outline;
create table lob_inline2outline(
id int,
var1 VARCHAR(8000),
var2 VARCHAR(8000),
var3 VARCHAR(8000),
var4 VARCHAR(8000),
lob1 clob,
var5 VARCHAR(8000),
lob2 clob,
var6 VARCHAR(8000),
var7 VARCHAR(8000),
lob3 clob,
lob4 clob,
lob5 clob,
var8 VARCHAR(8000)
) format csf;
insert into lob_inline2outline values(1,LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('a',8000,'a'),null,LPAD('a',8000,'a'),null, LPAD('a',8000,'a'),LPAD('a',8000,'a'),LPAD('3',940,'3'),null,LPAD('5',340,'5'), null); 
update lob_inline2outline set var8 = LPAD('a',8000,'a'), lob4 = LPAD('4',940,'4'), lob1 = LPAD('1',340,'1'), lob2 = LPAD('1',1040,'1');
drop table if exists lob_inline2outline;