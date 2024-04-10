--insert all
drop table if exists insall_dual;
create table insall_dual(a int);
insert into insall_dual values(1);
commit;

drop table if exists insall_std;
create table insall_std(a int, b int, c clob);
insert into insall_std values(0,0,'a');
insert into insall_std values(18,18,'b');
insert into insall_std values(5,5,'c');
commit;

drop table if exists insall_t1;
create table insall_t1(a int, b int, c clob);

drop table if exists "insall_t1";
create table "insall_t1"(a int, "a" int, b int, c clob);

insert all
into insall_t1 as int1(a,b,c) values(1,1,'a')
into insall_t1  int1(a,b,c) values(5,5,'b')
into insall_t1 as int1(a,b,c) values(3,3,'c')
select 1 from insall_dual;

insert all
into insall_t1 int1(a,b,c) values(1,1,'a')
into insall_t1 as int1(a,b,c) values(5,5,'b')
into insall_t1 int1(a,b,c) values(3,3,'c')
select 1 from insall_dual;

insert all
into insall_t1 int1 (a,b,c) values(1,1,'a')
into insall_t1 int1 (a,"B",c) values(5,5,'b')
into insall_t1 int1 (a,b,"C") values(3,3,'c')
select 1 from insall_dual;

insert all
into insall_t1 (a,b,c) values(1,1,'a')
into insall_std (a,b,c) values(5,5,'b')
into insall_t1 (a,b,c) values(3,3,'c')
select 1 from insall_dual;

insert all
into insall_t1 (a,b,c) values(1,1,'a')
into insall_t1 (a,b,c) values(5,5,'b')
into insall_std (a,b,c) values(3,3,'c')
select 1 from insall_dual;

insert all
into "insall_t1" (a,b,c) values(1,1,'a')
into insall_t1 (a,b,c) values(5,5,'b')
into "insall_t1" (a,b,c) values(3,3,'c')
select 1 from insall_dual;

insert all
into insall_t1 (a,b,c) values(1,1,'a')
into insall_t1 (a,b,c) values(5,5,'b')
into "insall_t1" (a,b,c) values(3,3,'c')
select 1 from insall_dual;

insert all
into "insall_t1" (a,b,c) values(1,1,'a')
into "insall_t1" (a,b,c) values(5,5,'b')
into insall_t1 (a,b,c) values(3,3,'c')
select 1 from insall_dual;

insert all
into insall_t1 (a,b,c) values(1,1,'a')
into insall_t1  values(5,5,'b')
into insall_t1  values(3,3,'c')
select 1 from insall_dual;

insert all
into insall_t1  values(1,1,'a')
into insall_t1 (a,b,c) values(5,5,'b')
into insall_t1 (a,b,c) values(3,3,'c')
select 1 from insall_dual;

insert all
into "insall_t1" (a,b,c) values(1,1,'a')
into "insall_t1" (a,b,c) values(5,5,'b')
into "insall_t1" ("a",b,c) values(3,3,'c')
select 1 from insall_dual;

drop table if exists insall_part;
create table insall_part (a int, b number, c varchar(5))
partition by range (a)
(
partition p1 values less than (5),
partition p2 values less than (10),
partition p3 values less than (15),
partition p4 values less than(MAXVALUE)
);

insert all
into insall_part values(1,1.2,'aa')
into insall_part values(7,0.2,'ab')
into insall_part values(100,1.00,'da')
into insall_part values(13,3.1,'ca')
select 1 from  insall_dual;

DECLARE 
num INT;
BEGIN  
INSERT all INTO insall_t1(a) VALUES(1) select 1 from insall_dual returning a into num;  
COMMIT;
END;
/

DECLARE 
num INT;
BEGIN  
INSERT all INTO insall_t1(a) VALUES(1) returning a into num ;  
COMMIT;
END;
/

DECLARE
num INT;
BEGIN
INSERT ALL 
	INTO insall_t1(a) VALUES(1)
	INTO insall_t1(a) VALUES(2)
	INTO insall_t1(a) VALUES(3)
	INTO insall_t1(a) VALUES(4)
	INTO insall_t1(a) VALUES(5)
SELECT a FROM insall_t1 return a into num;
COMMIT;
END;
/

DECLARE
num INT;
BEGIN
INSERT ALL 
	INTO insall_t1(a) VALUES(1)
	INTO insall_t1(a) VALUES(2)
	INTO insall_t1(a) VALUES(3)
	INTO insall_t1(a) VALUES(4)
	INTO insall_t1(a) VALUES(5)
SELECT a FROM insall_t1 returning a into num;
COMMIT;
END;
/

drop table insall_dual;
drop table insall_std;
drop table insall_t1;
drop table insall_part;