spool ./results/gs_func_bind_para.out
select current_timestamp($1) from dual;--error
in
int
7

select trunc($1,'dd') from dual;
in
date
2019-02-13 15:16


select trunc($1,$2) from dual;  
in
date
2019-02-13 15:16
in
string
mm


select trunc(to_date('2018-06-13 12:12:12', 'yyyy-mm-dd hh24:mi:ss') , $1) from dual; 
in
string
dd

select trunc(to_date('2018-06-13 12:12:12', 'yyyy-mm-dd hh24:mi:ss') , $1) from dual; --error
in
string
abc


select trunc($1,$2) from dual; 
in
double
3.14159
in
int
1

select DBE_LOB.SUBSTR(:1,2,2);
in
string
abcd

select DBE_LOB.SUBSTR(:1,2,2);--error
in
int
5

select DBE_LOB.get_length(:1);
in
string
abc

select DBE_LOB.get_length(:1);--error
in
int
5

--DTS2019080610346
drop table if exists PROC_DML_KEY_006_TAB_01;
create table PROC_DML_KEY_006_TAB_01(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into PROC_DML_KEY_006_TAB_01 values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10000),(123,'zhangsan3','doctor3',10000);
insert into PROC_DML_KEY_006_TAB_01 values(1,'zhansi','doctor1',10000),(2,'lisiabc','doctor2',10000),(123,'zhangwu123','doctor3',10000);
insert into PROC_DML_KEY_006_TAB_01 values(null,'abc','worker',9000);
insert into PROC_DML_KEY_006_TAB_01 values(716,null,'leader',20000);
insert into PROC_DML_KEY_006_TAB_01 values(null,'abc','worker',9000);
insert into PROC_DML_KEY_006_TAB_01 values(null,null,'worker',9000);
insert into PROC_DML_KEY_006_TAB_01 values(null,null,null,null);
insert into PROC_DML_KEY_006_TAB_01 values(null,null,null,null);


begin
delete from  sys.PROC_DML_KEY_006_TAB_01   limit :f1 ;
end;
/
in
int
1

begin
delete from  sys.PROC_DML_KEY_006_TAB_01   offset :f1 ;
end;
/
in
int
1

begin
delete from  sys.PROC_DML_KEY_006_TAB_01   order by  :f1 ;
end;
/
in
int
1
commit;

drop table  PROC_DML_KEY_006_TAB_01;

--DTS2019122608716
select array_agg(:) from dual;
in
varchar
a
--DTS2019110700720
drop table if exists bind_param_test_004 ;
create table bind_param_test_004(id int,id2 varchar(100));
create or replace procedure proc_bind_param_004(p1 int,p2 varchar,p3 int,p4 varchar) is
 begin
        insert into bind_param_test_004 values(p1,p2);
        insert into bind_param_test_004 values(p3,p4);
        commit;
 end;
 /
 
call proc_bind_param_004(:f1,:f2,:f1,:f4);
in
int
1
in
string
test$%$^&*@~
in
int
2
in
string
Cantian@#!(_+)=\/

select * from bind_param_test_004 where id = :f1;
in
int
2

select * from bind_param_test_004 order by id,id2;

drop table bind_param_test_004;
drop procedure proc_bind_param_004;


-- DTS2020020506518
drop table if exists subsidies_dep1_2018_2;
CREATE TABLE subsidies_dep1_2018_2(staff_id INT NOT NULL, staff_name CHAR(50), job VARCHAR(30),subsidies NUMBER);
select * from subsidies_dep1_2018_2 as of scn :scn1 order by 1,2;
out
bigint
4758263504897


-- DTS202008040OHAVEP0D00
DROP TABLE IF EXISTS ZONEBASICINFO_1001 CASCADE CONSTRAINTS;
CREATE TABLE ZONEBASICINFO_1001
(
  "ZONEID" NUMBER(12) NOT NULL,
  "ZONEDESC" VARCHAR(255 BYTE) NOT NULL,
  "UPPERZONEID" NUMBER(12) NOT NULL
);
INSERT INTO ZONEBASICINFO_1001 values(1,'Center POP',0);
INSERT INTO ZONEBASICINFO_1001 values(9999,'idle devices',0);
INSERT INTO ZONEBASICINFO_1001 values(100,'Standby POP',0);
INSERT INTO ZONEBASICINFO_1001 values(3,'Edge POP',100);

DROP TABLE IF EXISTS CONTENT_DISTRIBUTION_1214 CASCADE CONSTRAINTS;
CREATE TABLE CONTENT_DISTRIBUTION_1214
(
  "CONTENT_ID" NUMBER(12) NOT NULL,
  "CONTENT_STATUS" NUMBER(12),
  "POP_ID" NUMBER(12)
);
INSERT INTO CONTENT_DISTRIBUTION_1214 values (268435469,0,1);
INSERT INTO CONTENT_DISTRIBUTION_1214 values (268435469,0,1);
INSERT INTO CONTENT_DISTRIBUTION_1214 values (268435429,4,1);
commit;

CREATE OR REPLACE FUNCTION GET_POP_CONTENT_STATUS_DSH_1001(v_popid integer, v_content_id integer, v_service_type integer) return number
as
v_distrib_num number :=0;
v_pop_content_status number :=-1;
BEGIN
    if ( v_service_type = 16 ) then
        select count(1) into v_distrib_num from CONTENT_DISTRIBUTION_1214 where content_status = 4 and pop_id = v_popid and content_id = v_content_id;
        if ( v_distrib_num >= 1 ) then
            v_pop_content_status := 4;
            return v_pop_content_status;
        end if;
	end if;
	return v_pop_content_status;
end;
/
ALTER SYSTEM SET _LOG_LEVEL = 375;
ALTER SYSTEM SET LONGSQL_TIMEOUT = 0;
select GET_POP_CONTENT_STATUS_DSH_1001(zoneid, :p1, 16) RESULT from ZONEBASICINFO_1001 order by RESULT desc;
in
bigint
268435429

ALTER SYSTEM SET _LOG_LEVEL = 7;
ALTER SYSTEM SET LONGSQL_TIMEOUT = 10;
DROP TABLE IF EXISTS ZONEBASICINFO_1001 CASCADE CONSTRAINTS;
DROP TABLE IF EXISTS CONTENT_DISTRIBUTION_1214 CASCADE CONSTRAINTS;
DROP FUNCTION GET_POP_CONTENT_STATUS_DSH_1001;

--fix rs column is bind param
drop table if exists R_EQUIPMENT_POSITIONMODEL;

CREATE TABLE "R_EQUIPMENT_POSITIONMODEL"
(
  "ID" BINARY_BIGINT NOT NULL,
  "RELATION_NAME" VARCHAR(180 BYTE),
  "RELATION_ID" BINARY_BIGINT,
  "SOURCE_INSTANCE_ID" BINARY_BIGINT,
  "TARGET_INSTANCE_ID" BINARY_BIGINT,
  "LAST_MODIFIED" BINARY_BIGINT,
  "ENDU" BINARY_INTEGER,
  "STARTU" BINARY_INTEGER
);

INSERT INTO "R_EQUIPMENT_POSITIONMODEL" ("ID","RELATION_NAME","RELATION_ID","SOURCE_INSTANCE_ID","TARGET_INSTANCE_ID","LAST_MODIFIED","ENDU","STARTU") values
  (3654306952349892209,'Equipment_PositionModel',1002,6640699855611377066,753170169163755937,1606460227234,30,29);

drop table if exists R_EQUIPMENT_CHASSIS;
CREATE TABLE "R_EQUIPMENT_CHASSIS"
(
  "ID" BINARY_BIGINT NOT NULL,
  "RELATION_NAME" VARCHAR(180 BYTE),
  "RELATION_ID" BINARY_BIGINT,
  "SOURCE_INSTANCE_ID" BINARY_BIGINT,
  "TARGET_INSTANCE_ID" BINARY_BIGINT,
  "LAST_MODIFIED" BINARY_BIGINT,
  "ISFONT" VARCHAR(1000 BYTE),
  "SLOTNO" VARCHAR(192 BYTE),
  "ISHALF" VARCHAR(1000 BYTE)
);

SELECT ep.target_Instance_Id FROM r_equipment_positionmodel ep 
WHERE  ep.source_Instance_Id = (SELECT IF(EXISTS( SELECT target_Instance_Id from r_equipment_positionmodel r WHERE  r.source_Instance_Id=:p1 ), :p2 ,(SELECT  ec.target_Instance_Id
                                FROM r_equipment_chassis ec
                                WHERE ec.source_Instance_Id = :p3
                            ) ) );
in
bigint
6640699855611377066
in
bigint
6640699855611377066
in
bigint
6640699855611377066

drop table if exists R_EQUIPMENT_POSITIONMODEL;
drop table if exists R_EQUIPMENT_CHASSIS;

--DTS2020120803S82TP1400
CREATE OR REPLACE procedure DTS2020120803S82TP1400(v_content_id int[2]) 
as
BEGIN
dbe_output.print_line(v_content_id[1]);
end;
/

call DTS2020120803S82TP1400(:p1);
in
int
2

drop procedure if exists DTS2020120803S82TP1400;

select :p1,:p2,:p3 from sys_dummy;
in
BOOLEAN
TRUE
in
BOOLEAN
FALSE
in
BOOLEAN
1
--20200113
drop table if exists temp_20200113;
create table temp_20200113 (f1 int, f2 int[]);
insert into temp_20200113 values(1,(select array_agg(f1) from temp_20200113));
insert into temp_20200113 values(2,(select array_agg(:) from temp_20200113));
in
int
60
select * from temp_20200113;
drop table temp_20200113;

SELECT DBE_UTIL.EDIT_DISTANCE(:1,:2)  FROM DUAL;
in
int
1
in
string
abc
SELECT DBE_UTIL.EDIT_DISTANCE(:1,:2)  FROM DUAL;
in
STRING
ABC
in
string
abc
--20210821
drop table if exists test_list_part;
create table test_list_part (  "DATA_DAY" VARCHAR(8 BYTE),  "REGION_NAME" VARCHAR(50 BYTE))
PARTITION BY LIST ("DATA_DAY")
(    PARTITION PR_DATA_DAY_YYYYMMDD VALUES('yyyymmdd'),    PARTITION PR_DATA_DAY_20210514 VALUES('20210514'),    PARTITION PR_DATA_DAY_20210519 VALUES('20210519'),    PARTITION PR_DATA_DAY_20210501 VALUES('20210501'),
    PARTITION PR_DATA_DAY_20210520 VALUES('20210520'),    PARTITION PR_DATA_DAY_20210521 VALUES('20210521'),    PARTITION PR_DATA_DAY_20210522 VALUES('20210522'),    PARTITION PR_DATA_DAY_20210523 VALUES('20210523'));
insert into test_list_part values ('20210514',1),('20210519',2),('20210501',3),('20210521',4),('20210522',5),('20210523',6);
insert into test_list_part select * from test_list_part;
insert into test_list_part select * from test_list_part;
insert into test_list_part select * from test_list_part;
insert into test_list_part select * from test_list_part;
insert into test_list_part select * from test_list_part;
insert into test_list_part select * from test_list_part;
insert into test_list_part select * from test_list_part;
insert into test_list_part select * from test_list_part;
insert into test_list_part select * from test_list_part;
insert into test_list_part select * from test_list_part;
insert into test_list_part select * from test_list_part;
insert into test_list_part select * from test_list_part;
insert into test_list_part select * from test_list_part;
insert into test_list_part select * from test_list_part;
insert into test_list_part select * from test_list_part;
insert into test_list_part select * from test_list_part;
insert into test_list_part select * from test_list_part;
insert into test_list_part select * from test_list_part;
insert into test_list_part select * from test_list_part;
insert into test_list_part values ('20210520',7);
commit;
select count(*) from test_list_part where data_day between to_char(?, 'yyyymmdd') and to_char(?, 'yyyymmdd');
in
date
20210520
in
date
20210520
spool off
