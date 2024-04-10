-- load large clob data.
drop table if exists LOAD_CLOB_TABLE;

create TABLE LOAD_CLOB_TABLE(
	c          integer,
	c1         clob
);

load data infile "./data/clob_data.dat" into table LOAD_CLOB_TABLE
fields enclosed by '"' 
fields terminated by ',' 
lines terminated by '\n'
ignore 0 lines;

select c,length(c1) from LOAD_CLOB_TABLE;

-- load convert char clob data
truncate table LOAD_CLOB_TABLE;

load data infile "./data/clob_data_convert.dat" into table LOAD_CLOB_TABLE
fields enclosed by '"' 
fields terminated by ',' 
lines terminated by '\n'
ignore 0 lines;

select c,length(c1) from LOAD_CLOB_TABLE;

-- load multi row clob data
truncate table LOAD_CLOB_TABLE;

load data infile "./data/multi_row_clob_data.dat" into table LOAD_CLOB_TABLE
fields enclosed by '"' 
fields terminated by ',' 
lines terminated by '\n'
ignore 0 lines;

select c,length(c1) from LOAD_CLOB_TABLE;

-- dump clob data
dump table LOAD_CLOB_TABLE into file './data/clob_data_dump.dat'
fields enclosed by '"' 
fields terminated by ',' 
lines terminated by '\n';

-- load large blob data.
drop table if exists LOAD_BLOB_TABLE;

create TABLE LOAD_BLOB_TABLE(
	c          integer,
	c1         blob
);

load data infile "./data/clob_data.dat" into table LOAD_BLOB_TABLE
fields enclosed by '"' 
fields terminated by ',' 
lines terminated by '\n'
ignore 0 lines;

select c,length(c1) from LOAD_BLOB_TABLE;

-- load convert char blob data
truncate table LOAD_BLOB_TABLE;

load data infile "./data/clob_data_convert.dat" into table LOAD_BLOB_TABLE
fields enclosed by '"' 
fields terminated by ',' 
lines terminated by '\n'
ignore 0 lines;

select c,length(c1) from LOAD_BLOB_TABLE;


-- load multi row clob data
truncate table LOAD_BLOB_TABLE;

load data infile "./data/multi_row_clob_data.dat" into table LOAD_BLOB_TABLE
fields enclosed by '"' 
fields terminated by ',' 
lines terminated by '\n'
ignore 0 lines;

select c,length(c1) from LOAD_BLOB_TABLE;

-- dump blob data
dump table LOAD_BLOB_TABLE into file './data/blob_data_dump.dat'
fields enclosed by '"' 
fields terminated by ',' 
lines terminated by '\n';

--construct big data
drop table if exists clob_big_data;
create table clob_big_data (c clob);

insert into clob_big_data values('abcdefghijklmn');

create or replace procedure gen_big_data(size in int )
as
begin 
    for i in 1..size loop
        update clob_big_data set c=c||c;
    end loop;
end;
/

call gen_big_data(20);

select length(c) from clob_big_data;

dump table clob_big_data into file './data/clob_big_data_dump.dat'
fields enclosed by '"' 
fields terminated by ',' 
lines terminated by '\n';

truncate table clob_big_data;

load data infile "./data/clob_big_data_dump.dat" into table clob_big_data
fields enclosed by '"' 
fields terminated by ',' 
lines terminated by '\n'
ignore 0 lines;

select length(c) from clob_big_data;

-- large string can not be loaded into string 
drop table if exists load_too_long_data_table;
create table load_too_long_data_table (c varchar(1000));

load data infile "./data/clob_big_data_dump.dat" into table load_too_long_data_table
fields enclosed by '"' 
fields terminated by ',' 
lines terminated by '\n'
ignore 0 lines;

-- load NULL and "" to lob column
alter system set EMPTY_STRING_AS_NULL = FALSE;
drop table if exists empty_lob;
create table empty_lob(c clob , c1 clob not null , b blob , b1 blob not null);
insert into empty_lob values(NULL, '', NULL, '');
commit;
select * from empty_lob;
select length(c),length(c1),length(b),length(b1) from empty_lob;
dump table empty_lob into file "./data/empty_lob.dat" columns enclosed by '"';
truncate table empty_lob;
select count(*) from empty_lob;
load data infile "./data/empty_lob.dat" into table empty_lob columns enclosed by '"';
select * from empty_lob;
select length(c),length(c1),length(b),length(b1) from empty_lob;
alter system set EMPTY_STRING_AS_NULL = TRUE;

-- load "" from large string to lob by bind
alter system set EMPTY_STRING_AS_NULL = FALSE;

drop table if exists relation_dashboard_widget;

CREATE TABLE IF NOT EXISTS relation_dashboard_widget
(
    id NVARCHAR2(50) NOT NULL,
    dashboard_id NVARCHAR2(50) NOT NULL,
    widget_id NVARCHAR2(50) NOT NULL,
    show_mode NVARCHAR2(50) NOT NULL,
    position NVARCHAR2(128) NOT NULL,
    size NVARCHAR2(128) NOT NULL,
    container_size NVARCHAR2(128) NOT NULL,
    type NVARCHAR2(32),
    layer_index INT DEFAULT 1000 NOT NULL,
    extension NVARCHAR2(2048),
    PRIMARY KEY (id)
);

insert into relation_dashboard_widget values ('1','1','1','1','1','1','1','1','1','');
commit;

dump table relation_dashboard_widget into file './data/relation_dashboard_widget.csv' columns enclosed by '`';
truncate table relation_dashboard_widget;
load data infile "./data/relation_dashboard_widget.csv" into table relation_dashboard_widget columns enclosed by '`' lines terminated by '\n';

select * from relation_dashboard_widget order by id limit 10;

alter system set EMPTY_STRING_AS_NULL = TRUE;

-- large msg split
drop table if exists clob_big_data;
create table clob_big_data (c int,c1 clob);

insert into clob_big_data values(2, 'abcdefghijklmn');

create or replace procedure gen_big_data(size in int )
as
begin 
    for i in 1..size loop
        update clob_big_data set c1=c1||c1;
    end loop;
end;
/

call gen_big_data(20);

insert into clob_big_data values(1, 'abcdefghijklmn');
insert into clob_big_data values(3, 'abcdefghijklmn');
insert into clob_big_data values(4, 'abcdefghijklmn');
select c,length(c1) from clob_big_data order by c asc;

dump query "select * from clob_big_data order by c asc" into file './data/clob_big_data_dump1.dat'
fields enclosed by '"' 
fields terminated by ',' 
lines terminated by '\n';

truncate table clob_big_data;

load data infile "./data/clob_big_data_dump1.dat" into table clob_big_data
fields enclosed by '"' 
fields terminated by ',' 
lines terminated by '\n'
threads 2
ignore 0 lines;

select c,length(c1) from clob_big_data order by c asc;

-- table include nvarchar(1500) and clob ,load and dump
alter system set EMPTY_STRING_AS_NULL = FALSE;
drop table if exists TBL_AGGR_RULE;
CREATE TABLE IF NOT EXISTS TBL_AGGR_RULE
(
    ID                     INT NOT NULL,
    TENANTID    NVARCHAR2(512)     NULL,
    NAME        NVARCHAR2(600) NOT NULL,
    ENABLE             TINYINT NOT NULL,
    DESCRIPTION NVARCHAR2(1500)     NULL,
    CREATE_TIME         BIGINT NOT NULL,
    UPDATE_TIME         BIGINT NOT NULL,
    CATEGORY          SMALLINT     NULL DEFAULT NULL,
    TIME_COND             TEXT     NULL,
    OBJECT_COND           TEXT     NULL,
    ALARM_COND            TEXT     NULL,
    EXT_COND              TEXT     NULL,
    POLICY_COND           TEXT     NULL,
    AGE_TIME            BIGINT     NULL,
    MODIFIER          VARCHAR(255) NULL,
    PRIMARY KEY (ID)
);

insert into TBL_AGGR_RULE values(1,'abc','abc',1,'abc',1,1,1,'','','','abc','abc',1,'abc');
insert into TBL_AGGR_RULE values(2,'abc','abc',1,'abc',1,1,1,'','','','abc','abc',1,'abc');
insert into TBL_AGGR_RULE values(3,'abc','abc',1,'abc',1,1,1,'','','','abc','abc',1,'abc');
insert into TBL_AGGR_RULE values(4,'abc','abc',1,'abc',1,1,1,'','','','abc','abc',1,'abc');
insert into TBL_AGGR_RULE values(5,'abc','abc',1,'abc',1,1,1,'','','','abc','abc',1,'abc');

select * from TBL_AGGR_RULE order by id asc;

dump table TBL_AGGR_RULE into file './data/TBL_AGGR_RULE.dat' columns enclosed by '"';

truncate table TBL_AGGR_RULE;

load data infile './data/TBL_AGGR_RULE.dat' into table TBL_AGGR_RULE columns enclosed by '"';
select * from TBL_AGGR_RULE order by id asc;
alter system set EMPTY_STRING_AS_NULL = TRUE;

drop table if exists clob_lob_var;
create table clob_lob_var (f1 varchar(8000), c1 clob, f2 varchar(8000), f3 varchar(8000), f4 varchar(8000), f5 varchar(8000));
insert into clob_lob_var values(LPAD('10',8000,'1'),'sdfsf_sdfsf_sdfsf_sdfsf_sdfsf_1', LPAD('10',8000,'1'), LPAD('10',8000,'1'), LPAD('10',8000,'1'), LPAD('10',8000,'1'));
commit;
drop procedure if exists gen_big_lob;
create or replace procedure gen_big_lob(size in int )
as
begin 
    for i in 1..size loop
        update clob_lob_var set c1=c1||c1||c1||c1||c1||c1||c1||c1;
    end loop;
end;
/

call gen_big_lob(5);
commit;
select length(f2),length(c1),length(f2),length(f3),length(f4),length(f5) from clob_lob_var;

dump table clob_lob_var into file 'clob_and_varchar_dump.dat'
fields enclosed by '"' 
fields terminated by ',' 
lines terminated by '\n';

truncate table clob_lob_var;

load data infile "clob_and_varchar_dump.dat" into table clob_lob_var
fields enclosed by '"' 
fields terminated by ',' 
lines terminated by '\n'
ignore 0 lines;

drop procedure if exists gen_big_lob;
drop table if exists clob_lob_var;

--DTS2019070111073/DTS2019070109848
drop table if exists DUMPDTS2019070111073_UDS;
create TABLE DUMPDTS2019070111073_UDS(
	B_INT          integer,
	B_NUMBER       number,
	B_CHAR_SMALL   char(20),
	B_VARCHAR_MID  varchar(200)
);
drop table if exists DUMPDTS2019070109848_UDS;
create TABLE DUMPDTS2019070109848_UDS(
	B_INT          integer,
	B_NUMBER       number,
	B_CHAR_SMALL   char(20),
	B_VARCHAR_MID  varchar(200)
);
insert into DUMPDTS2019070111073_UDS values(0, 2574526298633856, 123123, '3AqXUOEGaAEXG3NeYY6bQCYACkW');
insert into DUMPDTS2019070111073_UDS values(1, 34534, 'World', '123123123');
insert into DUMPDTS2019070111073_UDS values(2, 124, 'Hellow', 'XqXnWYECg2CXN4PxQgw');
insert into DUMPDTS2019070111073_UDS values(3, 569345692354, '124df', '123123123');
insert into DUMPDTS2019070111073_UDS values(4, 555555, 'af', '5aWgGQ');
insert into DUMPDTS2019070111073_UDS values(5, 7777777777777, 'asdfsdf', 'YXqInXa');
insert into DUMPDTS2019070111073_UDS values(6, 222222222, 'asf', 'X4U8QUyOXGOioaubIGugGQw');
commit;

ALTER SYSTEM SET AUDIT_LEVEL=255;

dump TABLE DUMPDTS2019070111073_UDS into FILE './DUMPDTS2019070111073_UDS.csv'
fields enclosed by '`'
fields terminated by ',' 
lines terminated by '\n';

load data infile "./DUMPDTS2019070111073_UDS.csv" into table DUMPDTS2019070109848_UDS threads 10
fields enclosed by '`' 
fields terminated by ',' 
lines terminated by '\n'
ignore 0 lines
nologging;
select * from DUMPDTS2019070109848_UDS order by B_INT;
delete from DUMPDTS2019070109848_UDS;
drop table DUMPDTS2019070111073_UDS;
drop table DUMPDTS2019070109848_UDS;

-- test lob truncate at enclosed char position
drop table if exists lob_truncate;
create table lob_truncate(c clob);
insert into lob_truncate values('a');
create or replace procedure gen_big_data(size in int )
as
begin 
    for i in 1..size loop
        update lob_truncate set c=c||lpad('a',8000,'abc');
    end loop;
end;
/
call gen_big_data(131);
update lob_truncate set c=c||lpad('a',573,'abc');
update lob_truncate set c=c||'"isNull":false';
commit;
select lengthb(c) from lob_truncate;
dump table lob_truncate into file "./data/lob_truncate.dat" columns enclosed by '"';
truncate table lob_truncate;
load data infile "./data/lob_truncate.dat" into table lob_truncate columns enclosed by '"';
select lengthb(c) from lob_truncate;
drop table lob_truncate;