conn sys/Huawei@123@127.0.0.1:1611
drop user if exists gs_plsql_dts5 cascade;
create user gs_plsql_dts5 identified by Lh00420062;
grant dba to gs_plsql_dts5;

conn gs_plsql_dts5/Lh00420062@127.0.0.1:1611
set serveroutput on;

--regexp_like
declare
a varchar(30);
begin
a := '111111aaaaaaa';
if REGEXP_LIKE(a, '^[[:digit:]]{1,10}') then
dbe_output.print_line(1);
else
dbe_output.print_line(2);
end if;

if not REGEXP_LIKE(a, '^[[:digit:]]{1,10}') then
dbe_output.print_line(3);
else
dbe_output.print_line(4);
end if;

if REGEXP_LIKE(a, '^[[:digit:]]{1,10}') = true then
dbe_output.print_line(5);
else
dbe_output.print_line(6);
end if;

if REGEXP_LIKE(a, '^[[:digit:]]{1,10}') != true then
dbe_output.print_line(7);
else
dbe_output.print_line(8);
end if;

if not REGEXP_LIKE(a, '^[[:digit:]]{1,10}') <> true then
dbe_output.print_line(9);
else
dbe_output.print_line(10);
end if;

if not REGEXP_LIKE(a, '^[[:digit:]]{1,10}') = false then
dbe_output.print_line(11);
else
dbe_output.print_line(12);
end if;

if REGEXP_LIKE(a, '^[[:digit:]]{1,10}') != false then
dbe_output.print_line(13);
else
dbe_output.print_line(14);
end if;

if not REGEXP_LIKE(a, '^[[:digit:]]{1,10}') <> false then
dbe_output.print_line(15);
else
dbe_output.print_line(16);
end if;
end;
/

declare
a varchar(30);
begin
a := '111111aaaaaaa';
if REGEXP_LIKE(a, '^[[:digit:]]{1,10}') = 1 then
dbe_output.print_line(1);
end if;
end;
/

begin
if REGEXP_LIKE then
dbe_output.print_line(1);
end if;
end;
/

begin
savepoint aa;
savepoint aa;
savepoint aa;
savepoint aa;
savepoint aa;
savepoint aa;
savepoint aa;
savepoint aa;
savepoint aa;
end;
/

--dts index primary key error
DROP TABLE IF EXISTS T_EDGE_AKGKHGHKAJKGHH CASCADE;
CREATE TABLE "T_EDGE_AKGKHGHKAJKGHH"
(
  "IGS_EDGEID" VARBINARY(16) NOT NULL,
  "IGS_STARTID" VARBINARY(16) NOT NULL,
  "IGS_STARTTYPE" VARCHAR(128 BYTE) NOT NULL,
  "IGS_ENDID" VARBINARY(16) NOT NULL,
  "IGS_ENDTYPE" VARCHAR(128 BYTE) NOT NULL,
  "IGS_NAME" VARCHAR(128 BYTE) NOT NULL,
  "HISTORY_BEGIN_TIME" BINARY_BIGINT NOT NULL,
  "HISTORY_END_TIME" BINARY_BIGINT NOT NULL
);

ALTER TABLE "T_EDGE_AKGKHGHKAJKGHH" ADD CONSTRAINT constraint_123_easy PRIMARY KEY("IGS_STARTID", "HISTORY_BEGIN_TIME", "IGS_NAME", "IGS_ENDID");
ALTER TABLE "T_EDGE_AKGKHGHKAJKGHH" ADD UNIQUE("IGS_EDGEID");

insert into T_EDGE_AKGKHGHKAJKGHH values(UNHEX('11EADD782A195AFE8250286ED588C66A'),UNHEX('11EADBEC44A3EDAFB821286ED588C66A'),'ZZNetworkElement',UNHEX('11EADBEC91777080B821286ED588C66A'),'MirrorNetworkElement','ZNeHasMNe',0,1597331887687);
insert into T_EDGE_AKGKHGHKAJKGHH values(UNHEX('11EADD782A195AFE8250286ED588C66A'),UNHEX('11EADBEC44A3EDAFB821286ED588C66A'),'ZZNetworkElement',UNHEX('11EADBEC91777080B821286ED588C66A'),'MirrorNetworkElement','ZNeHasMNe',0,1597331887687);
DROP TABLE IF EXISTS T_EDGE_AKGKHGHKAJKGHH CASCADE CONSTRAINTS;

declare 
sql1 varchar(1024);
begin
for item in (select * from dv_dynamic_views) loop
begin
sql1 :='drop table if exists my'||item.name;
execute immediate sql1;
sql1 :=' create table my'||item.name||' as select * from '||item.name;
execute immediate sql1;
exception 
    when others then
        dbe_output.print(sql_err_code||', '||sql_err_msg||', '||sql1);
end;
end loop;
end;
/

set serveroutput off;
conn / as sysdba
drop user if exists gs_plsql_dts5 cascade;
drop user if exists  liuhang cascade;
create user liuhang identified by Cantian_234;
grant all privileges to liuhang;
conn liuhang/Cantian_234@127.0.0.1:1611

create table tt1 (a int,b int);
declare
begin
for item in (select * from tt1) loop
dbe_output.print(item.a);
end loop;
end;
/
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists liuhang cascade;
create user liuhang identified by Cantian_234;
grant all privileges to liuhang;
conn liuhang/Cantian_234@127.0.0.1:1611
declare
begin
for item in (select * from tt1) loop
dbe_output.print(item.a);
end loop;
end;
/

--DTS202009220HIXP6P0J00
CREATE OR REPLACE FUNCTION Zenith_Test_005() return varchar2
AS
Begin
    return (select 1 from dual);
End Zenith_Test_005;
/

select Zenith_Test_005();

--DTS20201021053RUIP0F00
set serveroutput on;
drop table if exists array_test_034;
create table array_test_034 (COL1 int,COL2 INTERVAL YEAR TO MONTH[],COL3 number[]);
insert into array_test_034 values(1,array[(INTERVAL '12' YEAR(4)) , (INTERVAL '-99' YEAR(3)) , (INTERVAL '0' YEAR(2))],array[-0.9E128 , 1.0E126 -1 , -89.0000001]);
insert into array_test_034 values(2,array[(INTERVAL '12' YEAR(4)) , (INTERVAL '-99' YEAR(3)) , (INTERVAL '0' YEAR(2))],array[-1.0E127 , 1.0E28 , -1-128]);
commit;

CREATE OR REPLACE PROCEDURE PROC_ARRAY_TEST_005(P1 out real )
AS
V1 real;
BEGIN
        select COL3[2] into V1 from array_test_034 where COL1 =2;
        P1:= V1;
        dbe_output.print_line(P1);
EXCEPTION WHEN NO_DATA_FOUND THEN dbe_output.print_line('NO_DATA_FOUND');
END;
/

DECLARE
V_P1 real[];
BEGIN
        PROC_ARRAY_TEST_005(V_P1);
END;
/

drop PACKAGE if exists a;
create or replace PACKAGE a
AS
FUNCTION  B() RETURN INT;
END;
/

CREATE OR REPLACE PACKAGE BODY a
AS
FUNCTION B()RETURN INT
AS
a int;
begin
a :=1;
return a ;
end;
end;
/
--expect error
create or replace function B() return int
as
a int;
begin
a :=a.b();
return a ;
end;
/
select b() from sys_dummy;
--expect error
create or replace function C(a in out int) return int
as
begin
a :=a.b();
return a ;
end;
/

--core: plc_try_obj_access_single  word->ex_count != 0 && word->type == WORD_TYPE_PARAM
create or replace procedure PROC_TEST1()
as
begin
dbe_output.print_line('b');
commit;:end ;
/

begin
dbe_output.print_line('b');
:end ;
/

declare
   p int;
begin
   p := :2();
end;
/

declare
   p int;
begin
   p := :a.b;
end;
/

begin
   :B;
end;
/

drop PACKAGE a;
drop function B;

--plm_is_out_arg
CREATE OR REPLACE FUNCTION function_out(a int, b int) RETURN INT
  AS
    c INT;
  BEGIN
       c := a * b * a * 4;
  RETURN c;
END;
/
CREATE OR REPLACE PROCEDURE procedure_out(a in int, b out int) IS
c int;
BEGIN
  b := a * a * 2;
  c := b;
  dbe_output.print_line(c);
  c := function_out(a, b);
  dbe_output.print_line(c);
END;
/
DECLARE
a int;
b int;
BEGIN
 a := 2;
 b := 3;
 procedure_out(a, b);
 dbe_output.print_line(b);
END;
/
drop function function_out;
drop procedure procedure_out;


create or replace procedure myp(v1 in int default 1, v2 int default 2) 
is
v3 int;
begin
dbe_output.print(v1||'  '||v2);
end;
/
--except error
call myp(v1=>1,v22=>1);

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists liuhang cascade;


create or replace procedure test_user_view471 as 
BEGIN 
EXECUTE IMMEDIATE  'select * from USER_OBJECTS'; 
END;
 /

call test_user_view471;
drop procedure test_user_view471;

--expect error
savepoint sp1;
begin
execute immediate 'rollback to sp1';
end;
/
rollback; 
--exepect right
begin
execute immediate 'savepoint sp1';
execute immediate 'savepoint sp1';
execute immediate 'savepoint sp1';
execute immediate 'savepoint sp1';
execute immediate 'savepoint sp1';
execute immediate 'savepoint sp1';
execute immediate 'savepoint sp1';
execute immediate 'savepoint sp1';
execute immediate 'savepoint sp1';
rollback to sp1;
end;
/
--exepect error
begin
execute immediate 'savepoint sp1';
execute immediate 'savepoint sp2';
execute immediate 'savepoint sp3';
execute immediate 'savepoint sp4';
execute immediate 'savepoint sp5';
execute immediate 'savepoint sp6';
execute immediate 'savepoint sp7';
execute immediate 'savepoint sp8';
execute immediate 'savepoint sp9';
end;
/

--exepect right
begin
execute immediate 'savepoint sp1';
execute immediate 'savepoint sp2';
execute immediate 'savepoint sp3';
execute immediate 'savepoint sp4';
savepoint sp5;
savepoint sp6;
savepoint sp7;
savepoint sp8;
rollback to sp8;
rollback to sp7;
rollback to sp6;
rollback to sp5;
execute immediate 'rollback to sp4';
execute immediate 'rollback to sp3';
execute immediate 'rollback to sp2';
execute immediate 'rollback to sp1';
end;
/

--exepect right
begin
execute immediate 'savepoint sp1';
execute immediate 'rollback to sp1';
end;
/

set serveroutput off;

--DTS202012260GAZSSP1F00 anonymou and xa test
drop table if exists transaction_stored_anonymous_rang_tabl_014;
create table transaction_stored_anonymous_rang_tabl_014(c_id int,c_d_id bigint not null,c_w_id tinyint unsigned not null,c_first varchar(16) not null,c_middle varchar(10),c_last varchar(16) not null,c_street_1 varchar(20) not null,c_street_2 varchar(20),c_city varchar(20) not null,c_state char(2) not null,c_zip char(9) not null,c_phone char(16) not null,c_since timestamp,c_credit char(2) not null,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real not null,c_payment_cnt number not null,c_delivery_cnt bool not null,c_end date not null,c_data1 varchar(8000),c_data2 varchar(8000),c_data3 varchar(8000),c_data4 varchar(8000),c_data5 varchar(8000),c_data6 varchar(8000),c_data7 varchar(8000),c_data8 varchar(8000),c_clob clob,c_blob blob,primary key (c_w_id,c_last)) partition by range(c_d_id)(partition part_1 values less than(150),partition part_2 values less than(300),partition part_3 values less than(450),partition part_4 values less than(700),partition part_5 values less than(850),partition part_6 values less than(maxvalue));

drop table if exists transaction_stored_anonymous_tabl_000;
create table transaction_stored_anonymous_tabl_000(c_id int,c_d_id bigint not null,c_w_id tinyint unsigned not null,c_first varchar(16) not null,c_middle char(2),c_last varchar(16) not null,c_street_1 varchar(20) not null,c_street_2 varchar(20),c_city varchar(20) not null,c_state char(2) not null,c_zip char(9) not null,c_phone char(16) not null,c_since timestamp,c_credit char(2) not null,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real not null,c_payment_cnt number not null,c_delivery_cnt bool not null,c_end date not null,c_data1 varchar(8000),c_data2 varchar(8000),c_data3 varchar(8000),c_data4 varchar(8000),c_data5 varchar(8000),c_data6 varchar(8000),c_data7 varchar(8000),c_data8 varchar(8000),c_clob clob,c_blob blob,primary key (c_id));
set serveroutput on;
declare
    i int :=1;
    j varchar(10);
    print_str varchar(1000);
    sql_str varchar(1000);
    begin
        for i in 1..1000 loop
            select cast(i as varchar(10)) into j from sys_dummy;
            if j<201 then
                --lob存行内，rowsize<8k
                insert into transaction_stored_anonymous_tabl_000 select i,i,i,'is'||(mod(j,6)+1),'oa','last'||mod(j,5),'street_1'||j,'street_2'||j,'city'||j,'uq','4801'||j,'940215'||j,to_date('2020-07-15','yyyy-mm-dd')+i,'cd',10000.0,0.4361328,-10.0,10.0,i+0.1*j,to_char(mod(j,2)),sysdate,lpad('qvf',200,'qvf'),lpad('qsf',200,'fsf'),lpad('vvd',200,'qvf'),lpad('qsf',200,'qvsf'),lpad('qvf',200,'qsf'),lpad('bqf',200,'qvf'),lpad('qvf',200,'qqf'),lpad('fsf',200,'qvl'),lpad('qvf',200,'qvl'),lpad('123',400,'abc') from sys_dummy;
            elsif j<401 then
                --lob存行内，8k<rowsize<64k(行链接)
                insert into transaction_stored_anonymous_tabl_000 select i,i,i,'is'||(mod(j,6)+1),'oa','last'||mod(j,5),'street_1'||j,'street_2'||j,'city'||j,'uq','4801'||j,'940215'||j,to_date('2020-07-15','yyyy-mm-dd')+i,'cd',10000.0,0.4361328,-10.0,10.0,i+0.1*j,to_char(mod(j,2)),sysdate,lpad('vcf',2000,'qvl'),lpad('lch',2000,'dfs'),lpad('qvb',2000,'qvl'),lpad('oqn',2000,'oqg'),lpad('zsf',2000,'fvf'),lpad('vdp',2000,'mpf'),lpad('zsf',2000,'dsf'),lpad('qsf',2000,'csf'),lpad('zsf',3000,'mpf'),lpad('123',1000,'abc') from sys_dummy;
            elsif j<601 then
                --lob存行外，rowsize<8k,local temporary不超过8k
                insert into transaction_stored_anonymous_tabl_000 select i,i,i,'is'||(mod(j,6)+1),'oa','last'||mod(j,5),'street_1'||j,'street_2'||j,'city'||j,'uq','4801'||j,'940215'||j,to_date('2020-07-15','yyyy-mm-dd')+i,'cd',10000.0,0.4361328,-10.0,10.0,i+0.1*j,to_char(mod(j,2)),sysdate,lpad('vcf',400,'qvl'),lpad('lch',400,'dfs'),lpad('qvb',400,'qvl'),lpad('oqn',400,'oqg'),lpad('zsf',400,'fvf'),lpad('vdp',400,'mpf'),lpad('zsf',400,'dsf'),lpad('qsf',400,'csf'),lpad('zsf',3000,'mpf'),lpad('123',3000,'abc') from sys_dummy;
            elsif j<801 then
                --lob存行外，8K<rowsize<64k(行链接)csf,temporary,不超过64k,local temporary不超过8k
                insert into transaction_stored_anonymous_tabl_000 select i,i,i,'is'||(mod(j,6)+1),'oa','last'||mod(j,5),'street_1'||j,'street_2'||j,'city'||j,'uq','4801'||j,'940215'||j,to_date('2020-07-15','yyyy-mm-dd')+i,'cd',10000.0,0.4361328,-10.0,10.0,i+0.1*j,to_char(mod(j,2)),sysdate,lpad('vcf',2000,'qvl'),lpad('lch',2000,'dfs'),lpad('qvb',2000,'qvl'),lpad('oqn',2000,'oqg'),lpad('zsf',2000,'fvf'),lpad('vdp',2000,'mpf'),lpad('zsf',2000,'dsf'),lpad('qsf',2000,'csf'),lpad('zsf',3000,'mpf'),lpad('123',3000,'abc') from sys_dummy;      
            else
                --rowsize>64k(lob存行外,且行链接)csf,temporary,不超过64k
                insert into transaction_stored_anonymous_tabl_000 select i,i,i,'is'||(mod(j,6)+1),'oa','last'||mod(j,5),'street_1'||j,'street_2'||j,'city'||j,'uq','4801'||j,'940215'||j,to_date('2020-07-15','yyyy-mm-dd')+i,'cd',10000.0,0.4361328,-10.0,10.0,i+0.1*j,to_char(mod(j,2)),sysdate,lpad('vcf',7500,'qvl'),lpad('lch',7500,'dfs'),lpad('qvb',7500,'qvl'),lpad('oqn',7500,'oqg'),lpad('zsf',7500,'fvf'),lpad('vdp',7500,'mpf'),lpad('zsf',7500,'dsf'),lpad('qsf',7500,'csf'),lpad('zsf',3000,'mpf'),lpad('123',3000,'abc') from sys_dummy;
            end if;
        end loop;
        sql_str :='select count(*) from transaction_stored_anonymous_tabl_000';
        execute immediate 'select count(*) from transaction_stored_anonymous_tabl_000' into print_str;
        dbe_output.print_line(sql_str);dbe_output.print_line(print_str);
    end;
/

create unique index transaction_stored_anonymous_rang_tabl_014_indx_001 on transaction_stored_anonymous_rang_tabl_014(c_phone);
create index transaction_stored_anonymous_rang_tabl_014_indx_002 on transaction_stored_anonymous_rang_tabl_014(c_middle,c_payment_cnt);
create unique index transaction_stored_anonymous_rang_tabl_014_indx_003 on transaction_stored_anonymous_rang_tabl_014(upper(c_phone));
create index transaction_stored_anonymous_rang_tabl_014_indx_004 on transaction_stored_anonymous_rang_tabl_014(upper(c_first)) ;
create index transaction_stored_anonymous_rang_tabl_014_indx_005 on transaction_stored_anonymous_rang_tabl_014(to_char(c_since)) tablespace tablespace_transaction_stored_anonymous_1 crmode row;
create unique index transaction_stored_anonymous_rang_tabl_014_indx_006 on transaction_stored_anonymous_rang_tabl_014(to_char(c_w_id),c_phone) crmode row;
create unique index transaction_stored_anonymous_rang_tabl_014_indx_007 on transaction_stored_anonymous_rang_tabl_014(c_d_id,c_street_1,c_since);
create index transaction_stored_anonymous_rang_tabl_014_indx_008 on transaction_stored_anonymous_rang_tabl_014(c_payment_cnt,to_char(c_phone),c_since) ;
create index transaction_stored_anonymous_rang_tabl_014_indx_009 on transaction_stored_anonymous_rang_tabl_014(to_char(c_w_id),upper(c_first),c_since,c_payment_cnt,to_char(c_phone));
alter table transaction_stored_anonymous_rang_tabl_014 add constraint constraint_transaction_stored_anonymous_rang_tabl_014 unique (c_id,c_first,c_since);

declare
    print_str varchar(1000);
    sql_str varchar(1000);
    begin
        insert into transaction_stored_anonymous_rang_tabl_014 select * from transaction_stored_anonymous_tabl_000;savepoint aa;
        select count(*) into print_str from transaction_stored_anonymous_rang_tabl_014;
        sql_str :='select count(*) from transaction_stored_anonymous_rang_tabl_014';
        dbe_output.print_line(sql_str);dbe_output.print_line(print_str);commit;
        delete from transaction_stored_anonymous_rang_tabl_014 where c_d_id<=100 or c_d_id>900;
    end;
/

insert into transaction_stored_anonymous_rang_tabl_014 select * from transaction_stored_anonymous_tabl_000 where c_d_id<=100 or c_d_id>900;
update transaction_stored_anonymous_rang_tabl_014 set c_middle='XH' where c_d_id<=200 or c_d_id>800;
select distinct c_middle,count(*) from transaction_stored_anonymous_rang_tabl_014 group by c_middle order by 1;

prepare transaction '2431.aaeabe.000014';
select distinct c_middle,count(*) from transaction_stored_anonymous_rang_tabl_014 group by c_middle order by 1;

update transaction_stored_anonymous_rang_tabl_014 set c_middle='WP' where c_d_id>200 and c_d_id<=800;

select distinct c_middle,count(*) from transaction_stored_anonymous_rang_tabl_014 group by c_middle order by 1;
commit;

commit prepared '2431.aaeabe.000014';
select distinct c_middle,count(*) from transaction_stored_anonymous_rang_tabl_014 group by c_middle order by 1;

declare
    print_str varchar(1000);
    sql_str varchar(1000);
    begin
        update transaction_stored_anonymous_rang_tabl_014 set c_d_id=(floor(c_d_id/150)+1)*400+c_d_id,c_first=c_first||'fsg',c_middle='W',c_street_1='rer',c_data1=lpad('dffhkswwwee',400,'c484zcsfjf'),c_data2=lpad('qvbuflchoqnsf',400,'qvoqgfvmpfzdsf'),c_data3=lpad('qvbuflggfgfdgchoqngfg',400,'qvgfgdfgldfsgfvmp'),c_data4=lpad('qvbugfgfgfvdpfzsf',400,'qvldgdfgfvmdfhfzdsf'),c_data5=lpad('qvbuflchfvdpfzsf',400,'qvldfschoqgfvmpfzdsf'),c_data6=lpad('qvbqnvmgfvdpfzsf',400,'qvldfschoqgfvmpfzdsf'),c_data7=lpad('qvbuhfhfgvmgfvdpfzsf',100,'qvldfhqgfvmpfzdsf'),c_data8=lpad('qvbuflchgfgfvdpfzsf',200,'qvlgdfoqgfvmpfzdsf'),c_clob=lpad('qvbuflchoqnvmgfvdpfzsf',400,'qvldfschoqgfvmpfzdsf'),c_blob=lpad('123143187569809',100,'1435764abc7890abcdef') where c_d_id<=400;
        execute immediate 'prepare transaction ''2431.aaeabe.000014''';
        savepoint aa;
        select count(*) into print_str from transaction_stored_anonymous_rang_tabl_014 where c_street_1='rer';
        sql_str :='select count(*) from transaction_stored_anonymous_rang_tabl_014 c_street_1=''rer''';
        dbe_output.print_line(sql_str);dbe_output.print_line(print_str);

        select count(*) into print_str from transaction_stored_anonymous_rang_tabl_014 where c_street_1='rer';
        sql_str :='select count(*) from transaction_stored_anonymous_rang_tabl_014 c_street_1=''rer''';
        dbe_output.print_line(sql_str);dbe_output.print_line(print_str);


        delete from transaction_stored_anonymous_rang_tabl_014 where c_d_id>400 and c_d_id<=500;
        sql_str :='select count(*) from transaction_stored_anonymous_rang_tabl_014';
        select count(*) into print_str from transaction_stored_anonymous_rang_tabl_014;
        dbe_output.print_line(sql_str);dbe_output.print_line(print_str);

        sql_str :='select count(*) from transaction_stored_anonymous_rang_tabl_014 c_street_1=''rer''';
        select count(*) into print_str from transaction_stored_anonymous_rang_tabl_014 where c_street_1='rer';
        dbe_output.print_line(sql_str);dbe_output.print_line(print_str);
        savepoint bb;
    end;
/
select count(*) from transaction_stored_anonymous_rang_tabl_014;
select distinct c_middle,count(*) from transaction_stored_anonymous_rang_tabl_014 group by c_middle order by 1;

create or replace function SYN_FUN_001_2021(ARRAY_C integer[]) return integer[]
as
ARRAY_A integer[];
begin
        ARRAY_A:=ARRAY_C;
        return ARRAY_A;
end;
/
create or replace function SYN_FUN_002_2021 (ARRAY_A integer[]) return integer[]
as
begin
        return SYN_FUN_001_2021(ARRAY_A);
end;
/
select SYN_FUN_002_2021(SYN_FUN_001_2021(array[1,2,3,4,5,6,7,8,9,10])) from SYS_DUMMY;

declare
x int[] :=array[1,2,3,4];
y int[];
begin
y:=SYN_FUN_001_2021(x[1:3]);
dbe_output.print_line(y);
end;
/

create or replace function SYN_FUN_005_2021(ARRAY_C integer[]) return integer[]
as
ARRAY_A integer[];
begin
        ARRAY_A:=ARRAY_C;
        return ARRAY_A[1:2];
end;
/
select SYN_FUN_005_2021(array[1,2,3,4]) from sys_dummy;

create or replace function SYN_FUN_006_2021(ARRAY_C integer[]) return integer[]
as
ARRAY_A integer[];
begin
        ARRAY_A:=ARRAY_C;
        return ARRAY_A[1];
end;
/
drop function if exists SYN_FUN_006_2021;
drop function if exists SYN_FUN_005_2021;
drop function if exists SYN_FUN_001_2021;
drop function if exists SYN_FUN_002_2021;

--create user
conn / as sysdba
drop user if exists CURSOR_FUNCTION_001_USR_01 cascade;
create user CURSOR_FUNCTION_001_USR_01  identified by Cantian_234;
grant dba to CURSOR_FUNCTION_001_USR_01;
drop table if exists CURSOR_FUNCTION_TEST_TAB_01;
drop view if exists CURSOR_FUNCTION_001_VIEW_01;
create table CURSOR_FUNCTION_TEST_TAB_01(empno int,ename varchar(10),job varchar(10) ,sal integer);
create or replace view CURSOR_FUNCTION_001_VIEW_01 as select * from CURSOR_FUNCTION_TEST_TAB_01;
--functionA
create or replace function CURSOR_FUNCTION_001_FUN_01 (str1 varchar) return int 
is 
mycursor1 sys_refcursor;
a int;
begin
 select empno into a from CURSOR_FUNCTION_001_VIEW_01;
   dbe_output.print_line(a);
   exception
   when  TOO_MANY_ROWS  then
   begin
      select empno into a from CURSOR_FUNCTION_001_VIEW_01 limit 1;
     dbe_output.print_line(a);
     return length(str1);
   end;
end;
/
conn CURSOR_FUNCTION_001_USR_01/Cantian_234@127.0.0.1:1611
select * from table(DBA_PROC_DECODE('SYS','CURSOR_FUNCTION_001_FUN_01','FUNCTION'));
conn / as sysdba
drop user if exists CURSOR_FUNCTION_001_USR_01 cascade;
set serveroutput off;

--DTS2021051908BELMP1L00 START
CONN / AS SYSDBA
ALTER SYSTEM SET LOCAL_TEMPORARY_TABLE_ENABLED = TRUE;
DROP TABLE IF EXISTS #DTS2021051908BELMP1L00_T1;
CREATE TEMPORARY TABLE #DTS2021051908BELMP1L00_T1 AS SELECT * FROM SYS_DUMMY;
DECLARE
 CURSOR1 SYS_REFCURSOR;
BEGIN
 OPEN CURSOR1 FOR SELECT * FROM #DTS2021051908BELMP1L00_T1;
 DBE_SQL.RETURN_CURSOR(CURSOR1);
END;
/
CONN / AS SYSDBA --important, do not delete
--DTS2021051908BELMP1L00 END