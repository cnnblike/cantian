create directory test_dir as '/home/cantiandba';
select * from sys_directories;
drop directory test_dir;
create user test identified by Cantian_234;
grant read on directory test_dir to test;
create directory test_dir as '/home/cantiandba';
grant connect, read on directory test_dir to test;
grant write on directory test_dir to test;
grant execute on directory test_dir to test;
grant read on directory test_dir to test;
select count(*) from sys_object_privs where OBJECT_NAME = 'TEST_DIR';
drop directory test_dir;
select count(*) from sys_object_privs where OBJECT_NAME = 'TEST_DIR';
revoke read on directory test_dir from test;
grant read on directory test_dir to test with grant option;
create directory test_dir as '/home/cantiandba';
grant read on directory test_dir to test with grant option;
revoke read on directory test_dir from test;
create role test_role;
grant read on directory test_dir to test_role;
grant test_role to test;
select count(*) from sys_object_privs where OBJECT_NAME = 'TEST_DIR';
revoke read on directory test_dir from test_role;
select count(*) from sys_object_privs where OBJECT_NAME = 'TEST_DIR';
drop user test;
drop role test_role;
create or replace directory test_dir as '/home/regress/CantianKernel/pkg/test/gs_regress/data';
select * from sys_directories;
drop table if exists ext_1;
create table ext_1(c1 int, c2 float, c3 decimal, c4 real, c5 varchar(32), c6 datetime, c7 timestamp) 
organization external
(
	type loader
	directory test_dir
	access parameters(
	    records delimited by newline
	    fields terminated by ',')
    location 'external_1.data'
);

drop table if exists ext_2;
create table ext_2(c1 int, c2 float, c3 decimal, c4 real, c5 varchar(32), c6 datetime, c7 timestamp)
organization external
(
    directory test_dir
    location 'external_1.data'
);

drop table if exists ext_3;
create table ext_3(c1 int, c2 float, c3 decimal, c4 real, c5 varchar(32), c6 datetime, c7 timestamp)
organization external
(
	type loader
	directory test_dir
	location 'external_1.data'
);

drop table if exists ext_4;
create table ext_4(c1 int, c2 float, c3 decimal, c4 real, c5 varchar(32), c6 datetime, c7 timestamp)
organization external
(
	type datapump
  	directory test_dir
    location 'external_1.data'
);

drop table if exists ext_5;
create table ext_5(id int, name varchar(60))
organization external
(
    directory test_dir
    location 'external_2.data'
);

drop table if exists ext_6;
create table ext_6(
SRC_ADDR varchar(20) not null,   
DST_ADDR varchar(20) not null,   
NEXTHOP  varchar(20) not null,
IN_IFID varchar(20) not null,   
OUT_IFID varchar(20) not null,   
BYTES varchar(20) not null,
PACKETS varchar(20) not null,   
FLOWS varchar(20) not null,   
SRC_PORT varchar(20) not null,
DST_PORT varchar(20) not null,   
PROTOCOLID varchar(20) not null,   
TOS varchar(20) not null,
TCP_FLAG varchar(20) not null,   
SRC_AS varchar(20) not null,   
DST_AS varchar(20) not null,
SRC_MASK varchar(20) not null,   
DST_MASK varchar(20) not null,   
FLOW_START_TIME varchar(20) not null,
FLOW_END_TIME varchar(20) not null,   
DEVICEID varchar(20) not null,   
FS_TIME varchar(20) not null,
APPID varchar(20) not null,   
FLOW_DURATION varchar(20) not null, 
FLOW_DIRECTION varchar(20) not null,    
BGP_NEXTHOP varchar(20) not null, 
SRC_VLAN varchar(20) not null,    
DST_VLAN varchar(20) not null,    
VPNID varchar(20) not null, 
DROP_ATTR varchar(20) not null)
organization external
(
    type loader
    directory test_dir
    access parameters(
    records delimited by '^'
    fields terminated by '|')
    location 'external_3.data'
);

create table ext_7(id int, name clob)
organization external
(
    directory test_dir
    location 'external_2.data'
);

create table ext_8(c1 int, c2 float default 10.3, c3 decimal, c4 real, c5 varchar(32), c6 datetime, c7 timestamp) 
organization external
(
	type loader
	directory test_dir
	access parameters(
	    records delimited by newline
	    fields terminated by ',')
    location 'external_1.data'
);

select count(*) from SYS_EXTERNAL_TABLES;
select * from ext_1 where c1=1;
select * from ext_2 where c5='aa';
select * from ext_3;
select * from ext_4;
select count(*) from ext_5;
select * from ext_5 where id>500 and id<=510;
select count(*) from ext_6;
select * from ext_6;

insert into ext_1(c1,c5) values(1,'dd');
update ext_1 set c1=c1+1;
delete from ext_1;
drop table ext_1;
drop table ext_2;
drop table ext_3;
drop table ext_4;
drop table ext_5;
drop table ext_6;
drop table ext_7;

drop table if exists ext_9;
create table ext_9(c1 int, c2 float, c3 decimal, c4 real, c5 varchar(32), c6 datetime, c7 timestamp) 
organization external
(
	type loader
	directory test_dir
	access parameters(
	    records delimited by ','
	    fields terminated by ',')
    location 'external_1.data'
);

drop table if exists ext_10;
create table ext_10(c1 int, c2 float, c3 decimal, c4 real, c5 varchar(32), c6 datetime, c7 timestamp) 
organization external
(
	type loader
	directory test_dir
	access parameters(
	    records delimited by ''
	    fields terminated by ',')
    location 'external_1.data'
);

drop table if exists ext_11;
create table ext_11(c1 int, c2 float, c3 decimal, c4 real, c5 varchar(32), c6 datetime, c7 timestamp) 
organization external
(
	type loader
	directory test_dir
	access parameters(
	    records delimited by newline
	    fields terminated by ',')
    location 'external_1.data'
)
partition by range(c1)
(
partition p1 values less than(50)
);

drop table if exists ext_12;
create table ext_12(c1 int, c2 float, c3 decimal, c4 real, c5 varchar(32), c6 datetime, c7 timestamp) 
organization external
(
	type loader
	directory test_dir
	access parameters(
	    records delimited by newline
	    fields terminated by ',')
    location 'external_1.data'
)nologging;
drop directory test_dir;

create directory test_dir as 'd:\test_dir11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
create directory test_diraaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as '/home/cantiandba';
drop directory test_diraaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
create directory test_diraaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa as '/home/cantiandba';
create user test identified by Cantian_234;
create directory test_dir as '/home/cantiandba';
grant read on directory test_dir to test;
select * from user_tab_privs where OBJECT_NAME = 'TEST_DIR';
select * from all_objects where OBJECT_NAME = 'TEST_DIR';
select * from my_objects where OBJECT_NAME = 'TEST_DIR';
select * from adm_objects where OBJECT_NAME = 'TEST_DIR';
drop directory test_dir;
drop user test;
create directory test_dir as 'f:\test';
create directory test_dir as '${CTDB_HOME}';