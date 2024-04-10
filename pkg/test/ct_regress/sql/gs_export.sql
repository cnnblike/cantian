exp users=abc, pfa, huawei, cantiandb
file="cantiandb.sql"
log = "cantiandb.log"
query="where '1' = true"
CONTENT=METADATA_ONLY
COMPRESS=1;

exp tables=abc, pfa, huawei, cantiandb
query="where '1' = true"
CONTENT=METADATA_ONLY
COMPRESS=1;

exp tables=abc, pfa, huawei, cantiandb,
query="where '1' = true"
CONTENT=METADATA_ONLY
COMPRESS=1;

export users="   xxx"
query="where '1' = true"
CONTENT=METADATA_ONLY
COMPRESS=1;

export users="   xxx", SYS
query="where '1' = true"
CONTENT=METADATA_ONLY
COMPRESS=1;

export users="SYS"
query="where '1' = true"
CONTENT=METADATA_ONLY
COMPRESS=1;

export users="sys"
query="where '1' = true"
CONTENT=METADATA_ONLY
COMPRESS=1;

export query="where '1' = true"
CONTENT=METADATA_ONLY
COMPRESS=1;

export users=abc, pfa, huawei, cantiandb query="where '1' = true"
CONTENT=METADATA_ONLY
COMPRESS=1;

exp log = "cantiandb.log"
 users=abc, pfa, huawei, sys query="where '1' = true"
CONTENT=METADATA_ONLY
COMPRESS=1;

exp log = "cantiandb.log"
 tables=bg:nh query="where '1' = true"
CONTENT=METADATA_ONLY
COMPRESS=1;

-- DTS2019020205132
drop USER if exists exp_invalid_file;
create user exp_invalid_file IDENTIFIED by 'exp_invalid_file123';
grant dba to exp_invalid_file;
conn exp_invalid_file/exp_invalid_file123@127.0.0.1:1611
drop table if exists DTS2019020205132_T1;
create table DTS2019020205132_T1 (
    `column1` int,
    `column2` int
);
insert into DTS2019020205132_T1 values (1,2),(3,4),(5,6);
commit;
exp TABLES=DTS2019020205132_T1 CONTENT=METADATA_ONLY file="/root/exp_invalid_file.dmp";
imp TABLES=DTS2019020205132_T1 file="/root/exp_invalid_file.dmp";
dump table DTS2019020205132_T1 into file '/root/exp_invalid_file.dmp';

-- DTS2018092111805
create user fenglang identified by Cantian_234;
grant dba to fenglang;
conn fenglang/Cantian_234@127.0.0.1:1611
drop table if exists FTV_global_003;
create global temporary table FTV_global_003(id int,name varchar2(10));
insert into FTV_global_003 values(1,'m'),(2,'m_s'),(3,'m_.&*%');
drop table if exists FTV_global_004;
create global temporary table FTV_global_004(id int,time date ,name clob);
insert into FTV_global_004 values(1,to_date('2018','yyyy'),'mm'),(2,('2017','yyyy'),'m_s')(3,('2015','yyyy'),'m_.&*%');
exp tables=FTV_global_003,FTV_global_004 file="temporary.dmp";

conn sys/Huawei@123@127.0.0.1:1611

create user exp_user1 IDENTIFIED by 'exp_user123';
grant dba to exp_user1;
grant select on SYS_TABLES to exp_user1;
grant create session to exp_user1;
grant create table to exp_user1;

create user exp_user2 IDENTIFIED by 'exp_user123';
grant create session to exp_user2;
grant create table to exp_user2;

drop table if exists exp_user1.HOTELAVAILABILITY;
CREATE TABLE exp_user1.HOTELAVAILABILITY
     (HOTEL_ID INT NOT NULL, BOOKING_DATE DATE NOT NULL,
--	ROOMS_TAKEN INT DEFAULT 0, PRIMARY KEY (HOTEL_ID, BOOKING_DATE));
	ROOMS_TAKEN INT DEFAULT 0);

drop table if exists exp_user1.admin_emp;
CREATE TABLE exp_user1.admin_emp (
    empno      NUMBER(5) PRIMARY KEY,
--	empno      NUMBER(5) PRIMARY KEY,
	ename      VARCHAR2(15) NOT NULL,
	ssn        NUMBER(9),
	job        VARCHAR2(10),
	mgr        NUMBER(5),
	hiredate   DATE DEFAULT (sysdate),
	birthday   timestamp(5) default current_timestamp(2),
	photo      BLOB,
	sal        NUMBER(7,2),
	hrly_rate  NUMBER(7,2),
	comm       NUMBER(7,2),
	"abc"      NUMBER(7,2),
	deptno     NUMBER(3) NOT NULL,
	working_age  interval year(4) to month default '0-0',
	working_age2 interval day(7) to second(4) default numtodsinterval(0, 'second')
);

create or replace view exp_user1.test_v1 as select * from SYS_TABLES;

--BEGIN: test serveroutput
CREATE OR REPLACE FUNCTION exp_user1.func_test return varchar2
IS
 cunt int := 0;
 Begin
 select count(*) into cunt from dual;
 dbe_output.print_line(cunt);
 IF SQL % FOUND
  then
 return cunt;
 end if;
 End func_test;
/

CREATE OR REPLACE PROCEDURE exp_user1.proc_test(param1 out varchar2)
IS
    tmp varchar2(20) :='12345678';
begin
    dbe_output.print_line('OUT PUT RESULT:'||param1);
end proc_test;
/

DROP TABLE IF EXISTS exp_user2.T_PROC_1;
CREATE TABLE exp_user2.T_PROC_1 (F_INT1 INT);

-- use sys to export user
exp users = exp_user1, exp_user2 file = "stdout";
exp users = exp_user1 file = "stdout";

conn exp_user1/exp_user123@127.0.0.1:1611
exp users = exp_user1 file = "stdout";
-- use exp_user1 to export exp_user2
exp users = exp_user2 file = "stdout";

-- export distribute rules
exp help;

exp dist_rules=% tables=% file="stdout";

conn exp_user1/exp_user123@127.0.0.1:1611

--test constraint
create table t_test_cons1
(
    id1 int, 
    id2 int, 
    name1 varchar2(100), 
    name2 varchar2(100),
    primary key(id1, name1),
    unique(name2),
    check(name2 in ('a', 'b', 'c'))
);

create unique index ix_test_cons1 on t_test_cons1(id2, name2);
alter table t_test_cons1 add constraint cons1_xxx unique(id2);
alter table t_test_cons1 add constraint cons1_yyy check(id2 in (1, 2, 3));

create table t_test_cons2
(
    id1 int, 
    id2 int, 
    name1 varchar2(100), 
    name2 varchar2(100),
    foreign key(id1, name1) references t_test_cons1(id1, name1) on delete cascade
);

alter table t_test_cons2 add constraint cons2_aaa primary key(id1);
alter table t_test_cons2 add constraint cons2_bbb foreign key(name2) references t_test_cons1(name2) on delete set null;

exp tables=t_test_cons1, t_test_cons2 file = "stdout";

--test commit_batch
create table t_test_batch
(
    id int, name varchar2(100)
);

alter table t_test_batch add constraint pk_t_test_batch primary key(id);
create index ix_t_test_batch on t_test_batch(name);

begin
    for i in 1 .. 20 loop
        insert into t_test_batch(id) values(i);
    end loop;
    commit;
end;
/

exp tables= t_test_batch commit_batch=5 file = "stdout";

conn sys/Huawei@123@127.0.0.1:1611
create user exp_user3 IDENTIFIED by 'exp_user123';
grant create session to exp_user3;
grant create table to exp_user3;
grant create sequence to exp_user3;

--test sequence
create sequence exp_user3.S_CONFIGID_1
minvalue 1
maxvalue 99999999999999999999
start with 21
increment by 1
cache 20
order
cycle;

exp users=exp_user3 file = "stdout";

create user northwind IDENTIFIED by 'exp_user123';
grant create session to northwind;
grant create table to northwind;

CREATE TABLE northwind.Region 
( 
  RegionID  NUMBER NOT NULL, 
  RegionDescription  CHAR(50 CHAR) NOT NULL, 
CONSTRAINT PK_Region 
  PRIMARY KEY (RegionID)
) 
/ 

CREATE TABLE northwind.Territories 
( 
  TerritoryID  VARCHAR2(20) NOT NULL, 
  TerritoryDescription  NCHAR(50) NOT NULL, 
  RegionID  NUMBER NOT NULL, 
CONSTRAINT PK_Territories 
  PRIMARY KEY (TerritoryID), 
CONSTRAINT FK_Territories_Region FOREIGN KEY (RegionID) REFERENCES northwind.Region(RegionID)
) 
/ 

CREATE TABLE northwind.Categories 
( 
  CategoryID  NUMBER NOT NULL, 
  SuperID     NUMBER, -- parent Categories
  CategoryName  VARCHAR2(15) NOT NULL, 
  Description  NVARCHAR(300), 
  Picture  BLOB, 
CONSTRAINT PK_Categories 
  PRIMARY KEY (CategoryID)
) 
/ 

ALTER TABLE northwind.Categories ADD CONSTRAINT FK_Categories_Categories FOREIGN KEY (SuperID) REFERENCES northwind.Categories(CategoryID)
/

CREATE TABLE northwind.Suppliers 
( 
  SupplierID  NUMBER NOT NULL, 
  CompanyName  VARCHAR2(40 CHAR) NOT NULL, 
  ContactName  VARCHAR2(30), 
  ContactTitle  VARCHAR2(30), 
  Address  VARCHAR2(60), 
  City  VARCHAR2(15), 
  Region  VARCHAR2(15), 
  PostalCode  VARCHAR2(10), 
  Country  VARCHAR2(15), 
  Phone  VARCHAR2(24), 
  Fax  VARCHAR2(24), 
  HomePage  VARCHAR2(200), 
CONSTRAINT PK_Suppliers 
  PRIMARY KEY (SupplierID)
) 
/ 

CREATE TABLE northwind.Products 
( 
  ProductID  NUMBER NOT NULL, 
  ProductName  VARCHAR2(40) NOT NULL, 
  SupplierID  NUMBER, 
  CategoryID  NUMBER, 
  QuantityPerUnit  VARCHAR2(20), 
  UnitPrice  NUMBER, 
  UnitsInStock  NUMBER, 
  UnitsOnOrder  NUMBER, 
  ReorderLevel  NUMBER, 
  Discontinued  NUMBER(1) NOT NULL, 
CONSTRAINT PK_Products 
  PRIMARY KEY (ProductID), 
CONSTRAINT CK_Products_UnitPrice   CHECK ((UnitPrice >= 0)), 
CONSTRAINT CK_ReorderLevel   CHECK ((ReorderLevel >= 0)), 
CONSTRAINT CK_UnitsInStock   CHECK ((UnitsInStock >= 0)), 
CONSTRAINT CK_UnitsOnOrder   CHECK ((UnitsOnOrder >= 0)), 
CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID) REFERENCES northwind.Categories(CategoryID), 
CONSTRAINT FK_Products_Suppliers FOREIGN KEY (SupplierID) REFERENCES northwind.Suppliers(SupplierID)
) 
/ 

CREATE TABLE northwind.Shippers 
( 
  ShipperID  NUMBER NOT NULL, 
  CompanyName  VARCHAR2(40) NOT NULL, 
  Phone  VARCHAR2(24), 
CONSTRAINT PK_Shippers 
  PRIMARY KEY (ShipperID)
) 
/ 

CREATE TABLE northwind.Customers 
( 
  CustomerID  CHAR(5) NOT NULL, 
  CompanyName  VARCHAR2(40) NOT NULL, 
  ContactName  VARCHAR2(30), 
  ContactTitle  VARCHAR2(30), 
  Address  VARCHAR2(60), 
  City  VARCHAR2(15), 
  Region  VARCHAR2(15), 
  PostalCode  VARCHAR2(10), 
  Country  VARCHAR2(15), 
  Phone  VARCHAR2(24), 
  Fax  VARCHAR2(24), 
CONSTRAINT PK_Customers 
  PRIMARY KEY (CustomerID)
) 
/ 

CREATE TABLE northwind.Employees 
( 
  EmployeeID  NUMBER NOT NULL, 
  LastName  VARCHAR2(20) NOT NULL, 
  FirstName  VARCHAR2(10) NOT NULL, 
  Title  VARCHAR2(30), 
  TitleOfCourtesy  VARCHAR2(25), 
  BirthDate  DATE, 
  HireDate  DATE, 
  Address  VARCHAR2(60), 
  City  VARCHAR2(15), 
  Region  VARCHAR2(15), 
  PostalCode  VARCHAR2(10), 
  Country  VARCHAR2(15), 
  HomePhone  VARCHAR2(24), 
  Extension  VARCHAR2(4), 
  Photo  BLOB, 
  Notes  VARCHAR2(600), 
  ReportsTo  NUMBER, 
  PhotoPath  VARCHAR2(255), 
CONSTRAINT PK_Employees 
  PRIMARY KEY (EmployeeID)
) 
/ 

ALTER TABLE northwind.Employees  ADD CONSTRAINT FK_Employees_Employees FOREIGN KEY (ReportsTo) REFERENCES northwind.Employees(EmployeeID)
/

CREATE TABLE northwind.EmployeeTerritories 
( 
  EmployeeID  NUMBER NOT NULL, 
  TerritoryID  VARCHAR2(20) NOT NULL, 
CONSTRAINT PK_EmpTerritories 
  PRIMARY KEY (EmployeeID, TerritoryID), 
CONSTRAINT FK_EmpTerri_Employees FOREIGN KEY (EmployeeID) REFERENCES northwind.Employees(EmployeeID), 
CONSTRAINT FK_EmpTerri_Territories FOREIGN KEY (TerritoryID) REFERENCES northwind.Territories(TerritoryID)
) 
/ 

CREATE TABLE northwind.CustomerDemographics 
( 
  CustomerTypeID  CHAR(10) NOT NULL, 
  CustomerDesc  varchar(4000 CHAR), 
CONSTRAINT PK_CustomerDemographics 
  PRIMARY KEY (CustomerTypeID)
) 
/ 

CREATE TABLE northwind.CustomerCustomerDemo 
( 
  CustomerID  CHAR(5) NOT NULL, 
  CustomerTypeID  CHAR(10) NOT NULL, 
CONSTRAINT PK_CustomerDemo 
  PRIMARY KEY (CustomerID, CustomerTypeID), 
CONSTRAINT FK_CustomerDemo FOREIGN KEY (CustomerTypeID) REFERENCES northwind.CustomerDemographics(CustomerTypeID), 
CONSTRAINT FK_CustomerDemo_Customers FOREIGN KEY (CustomerID) REFERENCES northwind.Customers(CustomerID)
) 
/ 

CREATE TABLE northwind.Orders 
( 
  OrderID  NUMBER NOT NULL, 
  CustomerID  CHAR(5), 
  EmployeeID  NUMBER, 
  TerritoryID  VARCHAR2(20), 
  OrderDate  timestamp, 
  RequiredDate  timestamp, 
  ShippedDate  timestamp, 
  ShipVia  NUMBER, 
  Freight  NUMBER, 
  ShipName  VARCHAR2(40), 
  ShipAddress  VARCHAR2(60 BYTE), 
  ShipCity  VARCHAR2(15), 
  ShipRegion  VARCHAR2(15), 
  ShipPostalCode  VARCHAR2(10), 
  ShipCountry  VARCHAR2(15), 
CONSTRAINT PK_Orders 
  PRIMARY KEY (OrderID), 
CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES northwind.Customers(CustomerID), 
CONSTRAINT FK_Orders_Employees FOREIGN KEY (EmployeeID) REFERENCES northwind.Employees(EmployeeID), 
CONSTRAINT FK_Orders_Shippers FOREIGN KEY (ShipVia) REFERENCES northwind.Shippers(ShipperID),
CONSTRAINT FK_Orders_Territories FOREIGN KEY (TerritoryID) REFERENCES northwind.Territories(TerritoryID)
) 
/ 

CREATE TABLE northwind.OrderDetails 
( 
  OrderID  NUMBER NOT NULL, 
  ProductID  NUMBER NOT NULL, 
  UnitPrice  NUMBER NOT NULL, 
  Quantity  NUMBER NOT NULL, 
  Discount  NUMBER NOT NULL, 
CONSTRAINT PK_Order_Details 
  PRIMARY KEY (OrderID, ProductID), 
CONSTRAINT CK_Discount   CHECK ((Discount >= 0 and Discount <= 1)), 
CONSTRAINT CK_Quantity   CHECK ((Quantity > 0)), 
CONSTRAINT CK_UnitPrice   CHECK ((UnitPrice >= 0)), 
CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderID) REFERENCES northwind.Orders(OrderID), 
CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (ProductID) REFERENCES northwind.Products(ProductID)
) CRMODE page
/

CREATE TABLE northwind.WebScripts
(
  name    varchar(60) not null,
  script  CLOB
) CRMODE row
/ 

CREATE TABLE northwind.tb_supplier
(
  supplier_id number not null,
  supplier_name varchar2(50) not null,
  contact_name varchar2(50),
  CONSTRAINT pk_supplier PRIMARY KEY (supplier_id)
)
/
 
CREATE TABLE northwind.tb_products
(
  product_id number not null,
  product_name varchar2(100),
  supplier_id number not null references northwind.tb_supplier(supplier_id)
)
/

exp users=northwind file = "stdout";
exp users=northwind file = "stdout" quote_names=Y;

conn northwind/exp_user123@127.0.0.1:1611
comment on table OrderDetails is 'Test table comments'
/
comment on column OrderDetails.ProductID is 'Test column comments'
/

exp tables=OrderDetails file = "stdout" quote_names=Y;
exp tables=OrderDetails file = "stdout" quote_names=Y skip_comments=y;

conn exp_user1/exp_user123@127.0.0.1:1611
exp tables=t_test_batch feedback=5 file = "t_test_batch.sql";

exp tables=% file = "all_table.sql";

CREATE GLOBAL TEMPORARY TABLE T_TEST_TEMP11
(
  ID INTEGER
)ON COMMIT PRESERVE ROWS;

CREATE GLOBAL TEMPORARY TABLE T_TEST_TEMP22
(
  ID INTEGER
)ON COMMIT DELETE ROWS;

exp tables=T_TEST_TEMP11,T_TEST_TEMP22 file = "temp_table.sql";

CREATE TABLE part_andy111
(
    andy_ID NUMBER,
    andy_ID2 NUMBER,
    FIRST_NAME  VARCHAR2(30) NOT NULL,
    LAST_NAME   VARCHAR2(30) NOT NULL,
    PHONE        VARCHAR2(15) NOT NULL,
    EMAIL        VARCHAR2(80),
    STATUS       CHAR(1)
)
PARTITION BY RANGE (andy_ID, andy_ID2)
(
    PARTITION PART1 VALUES LESS THAN (10000, 100) tablespace users,
    PARTITION PART2 VALUES LESS THAN (20000, 200),
    PARTITION PART3 VALUES LESS THAN (30000, 300)
)
TABLESPACE USERS;

create index ix_part_andy111 on part_andy111(andy_ID, andy_ID2) local;
alter table part_andy111 add constraint ix_part_andy111 primary key(andy_ID, andy_ID2);
alter table part_andy111 add constraint uk_part_andy111 unique(andy_ID, andy_ID2, FIRST_NAME);

create table T_BILLDATAINFOHIS
(
  dataid           NUMBER(20) not null,
  undologid        NUMBER(20) default 0 not null,
  writetime        DATE default sysdate not null,
  movetime         DATE,
  content          VARCHAR2(4000) not null,
  servicetype      NUMBER(3) not null,
  datatype         NUMBER(6) not null,
  datastatus       NUMBER(3) default 1 not null,
  dataindex        NUMBER(20) default 0 not null,
  loopcount        INTEGER default 0,
  latestfailtime   DATE,
  phonenumber      VARCHAR2(24),
  latestfailreason VARCHAR2(500)
)
partition by range (WRITETIME)
(
  partition JUN2019 values less than (TO_DATE('2019-07-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS')),
  partition JUL2019 values less than (TO_DATE('2019-08-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS')),
  partition AUG2019 values less than (TO_DATE('2019-09-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'))
);

create table t_groupmemberinfo1
(
  subgroupid        number(20)                       not null,
  groupid           number(20)                       not null,
  msisdn            varchar2(20)                     not null,
  updatetime        date           default sysdate   not null
)
partition by list(msisdn)
(
    partition GRP0 values('ab'),
    partition GRP1 values('cd')
); 

exp tables=part_andy111,T_BILLDATAINFOHIS,t_groupmemberinfo1  file="stdout";

CREATE TABLE t_userinfo_t3 (
userid             number(20)                      not null,
phonenumber        varchar2(128)                    not null,
passwd             varchar2(40)                    not null,
partition_num      integer not null
)
PARTITION BY HASH (userid,phonenumber)
(
PARTITION p1 tablespace users,
PARTITION p2 tablespace users,
PARTITION p3 tablespace users,
PARTITION p4 tablespace users,
PARTITION p5 tablespace users,
PARTITION p6 tablespace users
);

create table MS_BIGTABLE_LOG
(
  record_date DATE,
  col_1       VARCHAR2(200)
 )
PARTITION BY RANGE (record_date)
INTERVAL (numtodsinterval(1,'day'))
STORE IN(tablespace users)
(
   PARTITION P1 VALUES LESS THAN (TO_DATE('2014-1-1', 'YYYY-MM-DD'))
);
insert into MS_BIGTABLE_LOG values(TO_DATE('2018-1-1', 'YYYY-MM-DD'), '1');

create table MS_BIGTABLE_LOG2
(
  record_date DATE,
  col_1       VARCHAR2(200)
 )
PARTITION BY RANGE (record_date)
INTERVAL (numtodsinterval(1,'day'))
(
   PARTITION P1 VALUES LESS THAN (TO_DATE('2014-1-1', 'YYYY-MM-DD'))
);

insert into MS_BIGTABLE_LOG2 values(TO_DATE('2018-1-1', 'YYYY-MM-DD'), '1');

create index MS_BIGTABLE_LOG2_idx on MS_BIGTABLE_LOG2(record_date) local
/

exp tables=t_userinfo_t3,MS_BIGTABLE_LOG,MS_BIGTABLE_LOG2  file="stdout";

drop table if exists TEST_T1;
CREATE GLOBAL TEMPORARY TABLE TEST_T1
(
  ID INTEGER,num INTEGER
)ON COMMIT PRESERVE ROWS; 
insert into TEST_T1(id,num) values(1,111);
insert into TEST_T1(id,num) values(2,222);
insert into TEST_T1(id,num) values(3,333);
insert into TEST_T1(id,num) values(4,444);
insert into TEST_T1(id,num) values(5,555); 
select * from TEST_T1;
exp tables=TEST_T1 file = "stdout" filetype = txt;
exp tables=TEST_T1 file = "stdout" filetype = bin;

conn exp_user1/exp_user123@127.0.0.1:1611
drop table if exists test_part_t1;
create table test_part_t1(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp)
PARTITION BY RANGE(f1)
(
 PARTITION p1 values less than(10),
 PARTITION p2 values less than(20),
 PARTITION p3 values less than(30),
 PARTITION p4 values less than(MAXVALUE)
) crmode row;
create index idx_t1_1 on test_part_t1(f2,f3);
create index idx_t1_2 on test_part_t1(f4,f5) local;
insert into test_part_t1 values(5, 15, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(6, 16, 29, '16', '29', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(16, 26, 39, '26', '39', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(26, 36, 49, '36', '49', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(36, 46, 59, '46', '59', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 values(46, 56, 69, '56', '69', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_part_t1 select * from test_part_t1;
insert into test_part_t1 select * from test_part_t1;
insert into test_part_t1 select * from test_part_t1;
insert into test_part_t1 select * from test_part_t1;
commit;
insert into test_part_t1 select * from test_part_t1;
insert into test_part_t1 select * from test_part_t1;
insert into test_part_t1 select * from test_part_t1;
insert into test_part_t1 select * from test_part_t1;
commit;
exp tables=test_part_t1 parallel=10 file = "test_part_t1.sql";

exp tables=test_part_t1 filetype =bin parallel=10 file = "test_part_t1_bin.sql";
drop table if exists test_part_t1;

drop table if exists test_t2;
create table test_t2(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp);
drop table if exists test_t3;
create table test_t3(f1 int, f2 real, f3 number, f4 char(30), f5 varchar(30), f6 date, f7 timestamp);

insert into test_t2 values(1, 15, 28, 'abcd', 'abcd', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_t2 values(2, 16, 29, '16', '29', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_t2 values(7, 26, 39, '26', '39', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_t2 values(8, 36, 49, '36', '49', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_t2 values(12, 46, 59, '46', '59', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_t2 values(13, 56, 69, '56', '69', to_date('2018/01/24', 'YYYY/MM/DD'), to_timestamp('2018-01-24 16:00:00.00', 'YYYY-MM-DD HH24:MI:SS.FF3'));
insert into test_t2 select * from test_t2;
insert into test_t2 select * from test_t2;
insert into test_t2 select * from test_t2;
insert into test_t2 select * from test_t2;
insert into test_t2 select * from test_t2;
insert into test_t2 select * from test_t2;
insert into test_t2 select * from test_t2;
commit;
insert into test_t3 select * from test_t2;
commit;

exp tables=test_t2,test_t3 parallel=10 file = "test_t2.sql";

\! rm -rf exp_dir/
\! mkdir exp_dir

exp tables=test_t2,test_t3 parallel=10 insert_batch=10 consistent=y file="./exp_dir/exp_user_par1.sql";
exp tables=test_t2,test_t3 parallel=10 filetype = bin file="./exp_dir/exp_user_par2.sql";
exp tables=test_t2,test_t3 parallel=30 filetype = bin file="./exp_dir/exp_user_par30.sql";

create user exp_user_par IDENTIFIED by 'exp_user123';
grant dba to exp_user_par;
grant create session to exp_user_par;
grant create table to exp_user_par;

conn exp_user_par/exp_user123@127.0.0.1:1611
\! ctsql exp_user_par/exp_user123@127.0.0.1:1611 -c "@./exp_dir/exp_user_par1.sql";

select count(*), avg(f3) from exp_user_par.test_t2;
select count(*), avg(f3) from exp_user_par.test_t3;

truncate table exp_user_par.test_t2;
truncate table exp_user_par.test_t3;

\! ctsql exp_user_par/exp_user123@127.0.0.1:1611 -c "imp tables=test_t2,test_t3 parallel=3 filetype = bin file='./exp_dir/exp_user_par2.sql'";

select count(*), avg(f3) from exp_user_par.test_t2;
select count(*), avg(f3) from exp_user_par.test_t3;

--new requirement 
conn sys/Huawei@123@127.0.0.1:1611

drop USER if exists lin_u1;
drop USER if exists lin_u2;
drop USER if exists lin_u3;
drop USER if exists lin_u4;
drop USER if exists lin_u5;

create user lin_u1 IDENTIFIED by 'z9MZsgYA0Ac88PIqy1wrPgnKHq4izEGUzbQG29z5I1P917nkIWwBwYe9FIH6DIqRJ2vgQOYpXtMBIBC7Qx6WOVthvWX4V9/UcZLGA0/FlMPfl1YJMoQhbA==' ENCRYPTED;
create role lin_r1 identified by 'cNKM9gYA0Aedv9Lnu6tX8wiiGm8Cm/hZEzVQfpElEeyn3GCWukXeze+RKSCQeBPAADtxGAUJFxoyAP54IBTKbTwt0atPGxBE8/NHaNDaDCzhd15sja05Hw==' ENCRYPTED;
create role lin_r2;
grant dba to lin_u1;
grant create session to lin_r1;
grant create table to lin_r2;
grant lin_r1 to lin_u1;
grant lin_r2 to lin_u1;
grant CREATE DATABASE to lin_u1;
grant CREATE ANY VIEW to lin_u1;

export users = lin_u1 tablespace = y file = "lin_u1.sql" log="tmp_file.log" content = metadata_only compress = 1;
drop tablespace TBS_TEST including contents and datafiles;
create tablespace tbs_test datafile 'tbs_test' size 134217728 autoextend on next  16777216 maxsize  34359730176;
drop tablespace tbs_atest including contents and datafiles;
create tablespace tbs_atest datafile 'tbs_atest' size 134217728 autoextend off;

conn lin_u1/huawei_123@127.0.0.1:1611
drop table if exists EXP_LIN_TEST1;
create table EXP_LIN_TEST1(id int,name varchar2(10));
insert into EXP_LIN_TEST1 values(1,'m'),(2,'m_s'),(3,'dd');

exp users = lin_u1 create_user = Y role = Y grant = Y file = "stdout";
exp users = lin_u1 create_user = N role = N grant = N tablespace = N file = "stdout";
exp users = lin_u1 role = Y grant = Y create_user = Y tablespace = N file = "stdout";
exp users = lin_u1 create_user = Y role = Y grant = Y tablespace = Y file = "temp_file_create.sql" log="tmp_file.log";
exp users = lin_u1 grant = Y create_user = Y role = Y file = "stdout";
exp users = lin_u1 create_user = Y file = "stdout";
exp users = lin_u1 create_user = N file = "stdout";
exp users = lin_u1 role = Y file = "stdout";
exp users = lin_u1 role = N file = "stdout";
exp users = lin_u1 grant = Y file = "stdout";
exp users = lin_u1 grant = N file = "stdout";
exp users = lin_u1 tablespace = Y file = "temp_file_lin.sql" log="tmp_file.log";
exp users = lin_u1 tablespace = N file = "stdout";
exp users = lin_u1 role = Y grant = Y file = "stdout";
exp users = lin_u1 role = N grant = Y file = "stdout";
exp users = lin_u1 role = Y grant = N file = "stdout";
exp users = lin_u1 role = N grant = N file = "stdout";
exp users = lin_u1 create_user = Y grant = Y file = "stdout";
exp users = lin_u1 create_user = N grant = Y file = "stdout";
exp users = lin_u1 create_user = Y grant = N file = "stdout";
exp users = lin_u1 create_user = N grant = N file = "stdout";
exp users = lin_u1 create_user = Y role = Y file = "stdout";
exp users = lin_u1 create_user = N role = Y file = "stdout";
exp users = lin_u1 create_user = Y role = N file = "stdout";
exp users = lin_u1 create_user = N role = N file = "stdout";

CREATE USER lin_u2 IDENTIFIED BY 'QVMF1gYA0AfgXzVDksDDgqqhwTg6Gdqe68XDo1dC3Mysy+qTd1TnvdF0blgzqb5WfMAEjNtk77oADkUAxndmku+R6jt9rZhWX+p8dYI8W0apFiBc7K+/sw==' ENCRYPTED PASSWORD EXPIRE;
CREATE USER lin_u3 IDENTIFIED BY 'sQCqEwYA0Afz/Fi6DaGvwfSo6dfywDekFGFlE5kd3LDVfhNKSgGCjqDY70T2SskYtYmRxiUkqdYARa4VmCZdz2qWp1e90+BPRavV2jrG9hM29MtG6n5BmQ==' ENCRYPTED PASSWORD EXPIRE ACCOUNT LOCK;
CREATE USER lin_u4 IDENTIFIED BY 'M21e/AYA0AccXnwx++JF34lKwNPhXp6q9rD49N5vO0Os+p38nvgUB6EGN4Caa6r/5I7FraNJT0hSVX1lzAVGWjsLubxyG54UcKASjWVZQUWDKrsglHMVpA==' ENCRYPTED;
CREATE USER lin_u5 IDENTIFIED BY 'KCyY1gYA0AeSQ+MD7PjUUPMKpF/+INwzJ4GhHSmSG+bl7RxZJUk1gIZ5N38lI4ujoEXaLASjuXOC0wFZSQhRU/lXzNbiY75Vpv+PMmy5i0GrERq+WGnTzg==' ENCRYPTED;
grant dba to lin_u4;
grant create session to lin_u2;
grant create session to lin_u3;
grant create session to lin_u4;
grant dba to lin_u5;
grant create table to lin_u2;
grant create table to lin_u3;


conn lin_u3/huawei_123@127.0.0.1:1611

conn lin_u4/huawei_123@127.0.0.1:1611
drop table if exists EXP_LIN_TEST2;
create table EXP_LIN_TEST2(id int,name varchar2(10),description varchar2(100));
insert into EXP_LIN_TEST2 values(1,'m','lin'),(2,'ms','lin1'),(3,'dms','lin2'),(4,'ddss','lin3');

conn lin_u1/huawei_123@127.0.0.1:1611
exp users = lin_u2,lin_u3,lin_u4,lin_u5 create_user = Y role = Y grant = Y file = "stdout";
exp users = lin_u2,lin_u3,lin_u4,lin_u5 create_user = Y role = Y grant = Y tablespace = Y file = "temp_file_u2.sql" log="tmp_file.log";
exp users = lin_u1 create_user = Y role = Y grant = Y file = "stdout";
exp users = lin_u2 create_user = Y role = Y grant = Y file = "stdout";

conn sys/Huawei@123@127.0.0.1:1611
revoke dba from lin_u5;
grant create session to lin_u5;
conn lin_u5/huawei_123@127.0.0.1:1611
exp users = lin_u2,lin_u3,lin_u4,lin_u5 create_user = Y role = Y grant = Y tablespace = N file = "stdout";

conn sys/Huawei@123@127.0.0.1:1611
drop tablespace TBS_TEST including contents and datafiles;
drop tablespace tbs_atest including contents and datafiles;
drop USER if exists lin_u1;
drop USER if exists lin_u2;
drop USER if exists lin_u3;
drop USER if exists lin_u4;
drop USER if exists lin_u5;
drop role lin_r1;
drop role lin_r2;
--tablespace filter
conn sys/Huawei@123@127.0.0.1:1611

drop USER if exists feng_u1;
create user feng_u1 IDENTIFIED by 'z9MZsgYA0Ac88PIqy1wrPgnKHq4izEGUzbQG29z5I1P917nkIWwBwYe9FIH6DIqRJ2vgQOYpXtMBIBC7Qx6WOVthvWX4V9/UcZLGA0/FlMPfl1YJMoQhbA==' ENCRYPTED;
grant dba to feng_u1;
drop USER if exists feng_u2;
create user feng_u2 IDENTIFIED by 'z9MZsgYA0Ac88PIqy1wrPgnKHq4izEGUzbQG29z5I1P917nkIWwBwYe9FIH6DIqRJ2vgQOYpXtMBIBC7Qx6WOVthvWX4V9/UcZLGA0/FlMPfl1YJMoQhbA==' ENCRYPTED;
grant dba to feng_u2;

drop tablespace TBS_FENG1 including contents and datafiles;
create tablespace TBS_FENG1 datafile 'tbs_feng1' size 134217728 autoextend on next  16777216 maxsize  34359730176;
drop tablespace "tbs_feng1" including contents and datafiles;
create tablespace "tbs_feng1" datafile 'tbs_feng2' size 134217728 autoextend off;

conn feng_u1/huawei_123@127.0.0.1:1611

drop table if exists tab_faaa;
drop table if exists tab_fbbb;
create table tab_faaa(id int, num int, name varchar2(10)) tablespace TBS_FENG1;
insert into tab_faaa values(1,100,'m'),(2,200,'m_s'),(3,300,'dd');
create index index_aaa_id on tab_faaa(id) tablespace "tbs_feng1";
create index index_aaa_num on tab_faaa(num);

create table tab_fbbb(id int, num int, name varchar2(10));
insert into tab_fbbb values(1,100,'m'),(2,200,'m_s'),(3,300,'dd');
create index index_bbb_num on tab_fbbb(num);

exp tables=tab_faaa tablespace_filter = TBS_FENG3 file = "stdout";
exp tables=tab_faaa,tab_fbbb tablespace_filter = TBS_FENG1 file = "stdout";
exp tables=tab_faaa,tab_fbbb tablespace_filter = TBS_FENG1,USERS file = "stdout";
exp tables=tab_faaa tablespace_filter = TBS_FENG1 file = "stdout";
exp tables=tab_faaa tablespace_filter = USERS file = "stdout";
exp tables=tab_fbbb tablespace_filter = USERS file = "stdout";
exp tables=% tablespace_filter = TBS_FENG1 file = "stdout";
exp tables=tab_faaa tablespace_filter = TBS_FENG1 file = "stdout";

conn sys/Huawei@123@127.0.0.1:1611
exp users = feng_u1 create_user = Y role = Y grant = Y tablespace_filter = TBS_FENG3 file = "stdout";
exp users = feng_u1 create_user = Y role = Y grant = Y tablespace_filter = TBS_FENG1 file = "stdout";
exp users = feng_u1 create_user = Y role = Y grant = Y tablespace_filter = TBS_FENG1,"tbs_feng1" file = "stdout";
exp users = feng_u1 create_user = Y role = Y grant = Y tablespace_filter = "tbs_feng1" file = "stdout";
exp users = feng_u1 create_user = Y role = Y grant = Y tablespace_filter = USERS file = "stdout";
exp users = feng_u1 create_user = Y role = Y grant = Y file = "stdout";
exp users = feng_u1 create_user = Y role = Y grant = Y tablespace_filter = TBS_FENG1 tablespace = Y file = "temp_file_feng.sql" log="tmp_file.log";
exp tables = tab_faaa tablespace_filter = TBS_FENG1 file = "stdout";

exp users = feng_u2 tablespace = Y file = "tbsname_case_sensitive.sql" log="tbsname_case_sensitive.log";

drop table if exists tab_faaa;
drop table if exists tab_fbbb;
drop tablespace TBS_FENG1 including contents and datafiles;
drop tablespace "tbs_feng1" including contents and datafiles;

select TABLESPACE_NAME from dba_data_files where TABLESPACE_NAME in('tbs_feng1','TBS_FENG1') order by TABLESPACE_NAME;
imp users = feng_u2 IGNORE=Y file = "./data/tbsname_case_sensitive_txt.sql" log="tbsname_case_sensitive_txt.log";
select TABLESPACE_NAME from dba_data_files where TABLESPACE_NAME in('tbs_feng1','TBS_FENG1') order by TABLESPACE_NAME;
--exp users = feng_u2 tablespace = Y file = "tbsname_case_sensitive.sql" FILETYPE=BIN log="tbsname_case_sensitive.log";
--drop tablespace TBS_FENG1 including contents and datafiles;
--drop tablespace "tbs_feng1" including contents and datafiles;
--select TABLESPACE_NAME from dba_data_files where TABLESPACE_NAME in('tbs_feng1','TBS_FENG1') order by TABLESPACE_NAME;
--imp users = feng_u2 IGNORE=Y file = "tbsname_case_sensitive.sql" FILETYPE=BIN log="tbsname_case_sensitive.log";
--select TABLESPACE_NAME from dba_data_files where TABLESPACE_NAME in('tbs_feng1','TBS_FENG1') order by TABLESPACE_NAME;
drop tablespace TBS_FENG1 including contents and datafiles;
drop tablespace "tbs_feng1" including contents and datafiles;

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists exp_user1 cascade;
create user exp_user1 IDENTIFIED by 'Changme_123';
grant dba to exp_user1;

drop user if exists exp_user2 cascade;
create user exp_user2 IDENTIFIED by 'Changme_123';
grant dba to exp_user2;

\! ctsql exp_user1/Changme_123@127.0.0.1:1611 -c "@./sql/TBL_CLOUDSERVICE_LOGCONFIG.sql";

\! rm -rf exp_dir/
\! mkdir exp_dir

conn exp_user1/Changme_123@127.0.0.1:1611
update "TBL_CLOUDSERVICE_LOGCONFIG" set "LOGCONFIGS" = "LOGCONFIGS" || "LOGCONFIGS";
commit;

select count(*) from "TBL_CLOUDSERVICE_LOGCONFIG" where lengthb("LOGCONFIGS") > 8000;

exp tables=TBL_CLOUDSERVICE_LOGCONFIG filetype=bin file="./exp_dir/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX_TBL_CLOUDSERVICE_LOGCONFIG.sql";

conn exp_user2/Changme_123@127.0.0.1:1611
imp tables=TBL_CLOUDSERVICE_LOGCONFIG filetype=bin file="./exp_dir/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX_TBL_CLOUDSERVICE_LOGCONFIG.sql";

conn sys/Huawei@123@127.0.0.1:1611
select count(*), sum(length(LOGCONFIGID)), sum(lengthb(LOGCONFIGS)) from exp_user1.TBL_CLOUDSERVICE_LOGCONFIG 
union select count(*), sum(length(LOGCONFIGID)), sum(lengthb(LOGCONFIGS)) from exp_user2.TBL_CLOUDSERVICE_LOGCONFIG;


-- DTS2018101807176
create user exp_user_pfa IDENTIFIED by 'exp_user123';
grant dba to exp_user_pfa;
conn exp_user_pfa/exp_user123@127.0.0.1:1611

show parameter upper;

drop table DTS2018101807176_T1;
create table DTS2018101807176_T1 (
    `column1` int,
    `column2` int
);
desc DTS2018101807176_T1;
exp TABLES=DTS2018101807176_T1 CONTENT=METADATA_ONLY file="exp_user_pfa.dmp";
drop table DTS2018101807176_T1;

\! ctsql exp_user_pfa/exp_user123@127.0.0.1:1611 -c "@exp_user_pfa.dmp"

desc DTS2018101807176_T1;
select * from DTS2018101807176_T1 where `column1` = 0;

create table DTS2018111210546
(
    id1 int,
	id2 int
);

create index ix_DTS2018111210546_id1 on DTS2018111210546(id1);
create unique index ix_DTS2018111210546_id2 on DTS2018111210546(id2);

create table DTS2018111210499
(
    id1 int,
	id2 int
);

COMMENT ON COLUMN DTS2018111210499.id1 is 'id1 column';
COMMENT ON COLUMN DTS2018111210499.id2 is 'id2 column';

exp tables=DTS2018111210546,DTS2018111210499 file="stdout" quote_names=Y;


-- DTS2018120404189
DROP TABLE IF EXISTS "DTS2018120404189";
CREATE TABLE "DTS2018120404189"
(
"DTS2018120404189_COL_1" VARCHAR(75 BYTE) NOT NULL,
"DTS2018120404189_COL_2" NUMBER(10) NOT NULL,
"DTS2018120404189_COL_3" NUMBER(5) NOT NULL,
"DTS2018120404189_COL_4" NUMBER(5) NOT NULL,
"DTS2018120404189_COL_5" NUMBER(10) NOT NULL,
"DTS2018120404189_COL_6" NUMBER(10) NOT NULL,
"DTS2018120404189_COL_7" NUMBER(3) NOT NULL,
"DTS2018120404189_COL_8" NUMBER(10) NOT NULL,
"DTS2018120404189_COL_9" NUMBER(10) NOT NULL DEFAULT -1,
"DTS2018120404189_COL_10" NUMBER(10) NOT NULL,
"DTS2018120404189_COL_11" NUMBER(3) NOT NULL DEFAULT 2,
PRIMARY KEY("DTS2018120404189_COL_1", "DTS2018120404189_COL_2", "DTS2018120404189_COL_3", "DTS2018120404189_COL_4", "DTS2018120404189_COL_5","DTS2018120404189_COL_6","DTS2018120404189_COL_7","DTS2018120404189_COL_8")
);

exp tables="DTS2018120404189" file="stdout";

-- DTS2018121208820, the 
DROP TABLE IF EXISTS "DTS2018121208820";
CREATE TABLE "DTS2018121208820"
(
  "DTS2018121208820_COL_1" VARCHAR(1024)
);

insert into "DTS2018121208820" values('000000000000000000000000000000000000');

exp tables="DTS2018121208820" file="DTS2018121208820.exp" log="DTS2018121208820.log";

\! stat -c "%a %A %n" DTS2018121208820.exp DTS2018121208820.log  > DTS2018121208820.permissions 

dump table DTS2018121208820 into file "DTS2018121208820.dump";

\! stat -c "%a %A %n" DTS2018121208820.dump  >> DTS2018121208820.permissions

load data infile "DTS2018121208820.permissions" into table "DTS2018121208820";

select * from "DTS2018121208820" order by 1;

-- DTS2018112900633, DTS2018112811658
create user exp_user_long_proc IDENTIFIED by 'exp_user123';
grant dba to exp_user_long_proc;
conn exp_user_long_proc/exp_user123@127.0.0.1:1611

\! ctsql exp_user_long_proc/exp_user123@127.0.0.1:1611 -c "@./sql/long_source_proc_test.sql"

exp users=exp_user_long_proc file="stdout";

-- DTS2018122711387: bug: truncated binary & varbinary datatype
drop table if exists EXP_TAB_BIN;
create table EXP_TAB_BIN(fb binary(30), vb varbinary(200), img image, a blob);
insert into EXP_TAB_BIN select rownum, sin(rownum), sqrt(rownum/7.3) || floor(exp(rownum)), floor(exp(rownum)) || 'ABC' from dual connect by rownum <= 80;

select count(*), avg(fb::varchar(300)), avg(vb::varchar(300)), avg(img::varchar(300)), avg(vsize(a)) from EXP_TAB_BIN;

exp tables=EXP_TAB_BIN file = "exp_tab_bin.sql";

truncate table EXP_TAB_BIN;

\! ctsql exp_user_long_proc/exp_user123@127.0.0.1:1611 -c "@./exp_tab_bin.sql";

select count(*), avg(fb::varchar(300)), avg(vb::varchar(300)), avg(img::varchar(300)), avg(vsize(a)) from EXP_TAB_BIN;

insert into EXP_TAB_BIN select * from EXP_TAB_BIN;
insert into EXP_TAB_BIN select * from EXP_TAB_BIN;
insert into EXP_TAB_BIN select * from EXP_TAB_BIN;
insert into EXP_TAB_BIN select * from EXP_TAB_BIN;
commit;

exp tables=EXP_TAB_BIN file = "exp_tab_bin2.sql" parallel=3 insert_batch=10;

truncate table EXP_TAB_BIN;
select count(*), avg(fb::varchar(300)), avg(vb::varchar(300)), avg(img::varchar(300)), avg(vsize(a)) from EXP_TAB_BIN;

\! ctsql exp_user_long_proc/exp_user123@127.0.0.1:1611 -c "@./exp_tab_bin2.sql";
select count(*), avg(fb::varchar(300)), avg(vb::varchar(300)), avg(img::varchar(300)), avg(vsize(a)) from EXP_TAB_BIN;

-- exp bigwidth table
drop user if exists EXP_USER_LONG_PROC cascade;
create user EXP_USER_LONG_PROC IDENTIFIED by 'exp_user123';
grant dba to EXP_USER_LONG_PROC;
conn EXP_USER_LONG_PROC/exp_user123@127.0.0.1:1611

set termout off
set feedback off
@@load_and_dump_wide_table.sql
exp tables="TABLE_NAME_CHAOCHANGTAB_MMMMMMMMM_ARE_YOU_OK" file = "./exp_bigwide_table.sql" CONSISTENT = Y;
@exp_bigwide_table.sql

set termout on
set feedback on
set echo on
select count(*) EXPORT_BIGWIDE_TABLE from all_tables where OWNER = 'EXP_USER_LONG_PROC' and TABLE_NAME='TABLE_NAME_CHAOCHANGTAB_MMMMMMMMM_ARE_YOU_OK';


-- autoincrement table export
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists exp_test_auto_incre cascade;
create user exp_test_auto_incre IDENTIFIED by 'Changme_123';
grant dba to exp_test_auto_incre;
conn exp_test_auto_incre/Changme_123@127.0.0.1:1611
CREATE TABLE table_exp_auto_increment (F1 int, F2 INT AUTO_INCREMENT CONSTRAINT UK_F2 unique) AUTO_INCREMENT 1000;
INSERT INTO table_exp_auto_increment VALUES(1, NULL);
INSERT INTO table_exp_auto_increment VALUES(2, 0);
INSERT INTO table_exp_auto_increment (F1) VALUES(3);
commit;
exp tables = table_exp_auto_increment file = "table_exp_auto_increment.sql";
drop table table_exp_auto_increment;

\! ctsql exp_test_auto_incre/Changme_123@127.0.0.1:1611 -c "@./table_exp_auto_increment.sql";

INSERT INTO table_exp_auto_increment (F1) VALUES(4);
update   table_exp_auto_increment set F1 ='5' where f1=3;
commit;
select * from table_exp_auto_increment  order by f2;
drop table table_exp_auto_increment;

-- for global temporary table index
drop table if exists exp_global_tmp_table;
create global temporary table exp_global_tmp_table(c int,c1 int);
create index exp_global_tmp_table_indx on exp_global_tmp_table(c);
exp tables = exp_global_tmp_table file="stdout";

-- for case sensitive unique index
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists case_sensitive_unique_idx cascade;
create user case_sensitive_unique_idx IDENTIFIED by 'Changme_123';
grant dba to case_sensitive_unique_idx;
conn case_sensitive_unique_idx/Changme_123@127.0.0.1:1611
DROP TABLE IF EXISTS "eos_port_ldc_db" CASCADE CONSTRAINTS;
CREATE TABLE "eos_port_ldc_db"
(
  "node" NUMBER(10) NOT NULL DEFAULT 0,
  "shelf" NUMBER(10) NOT NULL DEFAULT 0,
  "board" NUMBER(10) NOT NULL DEFAULT 0,
  "subcard" NUMBER(10) NOT NULL DEFAULT 0,
  "port" NUMBER(10) NOT NULL DEFAULT 0,
  "rnode" NUMBER(10) NOT NULL DEFAULT 0,
  "rshelf" NUMBER(10) NOT NULL DEFAULT 0,
  "rboard" NUMBER(10) NOT NULL DEFAULT 0,
  "rsubcard" NUMBER(10) NOT NULL DEFAULT 0,
  "rport" NUMBER(10) NOT NULL DEFAULT 0,
  "phy_state" NUMBER(10) NOT NULL DEFAULT 0,
  "link_state" NUMBER(10) NOT NULL DEFAULT 0,
  "mtu" NUMBER(10) NOT NULL DEFAULT 0,
  "max_bandwidth" NUMBER(10) NOT NULL DEFAULT 0,
  "remain_bandwidth" NUMBER(10) NOT NULL DEFAULT 0,
  "encap_type" NUMBER(10) NOT NULL DEFAULT 0,
  "detect_en" NUMBER(10) NOT NULL DEFAULT 0,
  "tag_type" NUMBER(10) NOT NULL DEFAULT 0,
  "port_enable" NUMBER(10) NOT NULL DEFAULT 0,
  "board_type" NUMBER(10) NOT NULL DEFAULT 0,
  "def_vlanid" NUMBER(10) NOT NULL DEFAULT 0,
  "def_vlanpri" NUMBER(10) NOT NULL DEFAULT 0,
  "vlan_bmp" CLOB,
  "op_module" CLOB,
  "protocol" NUMBER(10) NOT NULL DEFAULT 0,
  "lcas" NUMBER(10) NOT NULL DEFAULT 0,
  "cfg_dir" NUMBER(10) NOT NULL DEFAULT 0,
  "cfg_level" NUMBER(10) NOT NULL DEFAULT 0,
  "cfg_path_num" NUMBER(10) NOT NULL DEFAULT 0,
  "cfg_path" CLOB,
  "real_dir" NUMBER(10) NOT NULL DEFAULT 0,
  "real_level" NUMBER(10) NOT NULL DEFAULT 0,
  "real_path_num" NUMBER(10) NOT NULL DEFAULT 0,
  "real_path" CLOB,
  "occupied_status" NUMBER(10) NOT NULL DEFAULT 0,
  "port_type" NUMBER(10) NOT NULL DEFAULT 0,
  "r_oper_type" BINARY_INTEGER NOT NULL DEFAULT 1,
  "r_timestamp" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  "r_etag" BINARY_BIGINT NOT NULL DEFAULT 0,
  "r_index" BINARY_INTEGER NOT NULL
)
INITRANS 2
MAXTRANS 255
PCTFREE 8;
ALTER TABLE "eos_port_ldc_db" ADD CONSTRAINT "eos_port_ldc_db-r_index" UNIQUE("r_index");
ALTER TABLE "eos_port_ldc_db" MODIFY "r_index" AUTO_INCREMENT;

exp tables="eos_port_ldc_db" file="./data/case_sensitive_unique_idx.dat";
imp tables="eos_port_ldc_db" file="./data/case_sensitive_unique_idx.dat";

exp users=% log="?/temp_invalid_exp_path1.txt" file="./data/temp_invalid_exp_path1.dat";
exp users=% log="./data/?/temp_invalid_exp_path2.txt" file="./data/temp_invalid_exp_path2.dat";
exp users=% file="?/temp_invalid_exp_path3.dat";
exp users=% file="./data/?/temp_invalid_exp_path3.dat";
exp users=% log="./exp_logpath/" file="./data/temp_invalid_exp_path2.dat";
exp users=% file="./exp_logpath1/";
imp users=% log="?/err_path1.log" file="./data/case_sensitive_unique_idx.dat";
imp users=% log="./data/?/err_path2.log" file="./data/case_sensitive_unique_idx.dat";
imp users=% log="./imp_logpath/" file="./data/case_sensitive_unique_idx.dat";
imp users=% file="./imp_logpath1/";

conn sys/Huawei@123@127.0.0.1:1611

drop user if exists ddl_thread_throws_error cascade ;
create user ddl_thread_throws_error identified by Test_123456;
grant create session to ddl_thread_throws_error;
grant SELECT ANY TABLE to ddl_thread_throws_error;
grant create table to ddl_thread_throws_error;
conn ddl_thread_throws_error/Test_123456@127.0.0.1:1611
exp users=ddl_thread_throws_error file="./data/" filetype=bin;

--DTS2019050808874 
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists exp_lob;
create user exp_lob IDENTIFIED by 'exp_user123';
grant dba to exp_lob;
conn exp_lob/exp_user123@127.0.0.1:1611
DROP TABLE IF EXISTS T_LOB_DATA;
CREATE TABLE T_LOB_DATA(f_clob CLOB,f_blob BLOB);
INSERT INTO T_LOB_DATA VALUES(LPAD('ab',8000,'a'), LPAD('10',8000,'1') || LPAD('10',8000,'1'));
select lengthb(f_clob),lengthb(f_blob) from T_LOB_DATA;
exp tables= T_LOB_DATA file = 'lob8000.txt';
update T_LOB_DATA set f_blob = LPAD('10',8000,'1') || LPAD('10',8000,'1') || LPAD('10',2,'1');
select lengthb(f_clob),lengthb(f_blob) from T_LOB_DATA;
exp tables= T_LOB_DATA file = 'blob8001.txt';
update T_LOB_DATA set f_clob = f_clob || '1', f_blob = LPAD('10',8000,'1');
select lengthb(f_clob),lengthb(f_blob) from T_LOB_DATA;
exp tables= T_LOB_DATA file = 'clob8001.txt';

-- test for order of exporting view
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists exp_view_order cascade;
create user exp_view_order identified by Test_123456;
grant dba to exp_view_order;
grant select on dv_version to exp_view_order;
conn exp_view_order/Test_123456@127.0.0.1:1611
create table ts (c int);
create view v_1 as select * from ts;
create view v_2 as select * from v_1;
drop view v_1;
create view v_1 as select * from ts;
create view v_3 as select * from dv_version;
create view v_4 as select * from v_3;
drop view v_3;
create view v_3 as select * from dv_version;
conn sys/Huawei@123@127.0.0.1:1611
exp users=exp_view_order file="./data/exp_view_order.dmp";
drop view exp_view_order.v_1;
drop view exp_view_order.v_3;
imp users=exp_view_order file="./data/exp_view_order.dmp";
exp users=exp_view_order file="./data/exp_view_order_consistent.dmp" consistent=Y;
drop view exp_view_order.v_1;
drop view exp_view_order.v_3;
imp users=exp_view_order file="./data/exp_view_order_consistent.dmp";
drop user if exists exp_view_order cascade;

-- test for interval paritition table export
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists exp_interval_part_table cascade;
create user exp_interval_part_table identified by Test_123456;
grant dba to exp_interval_part_table;
conn exp_interval_part_table/Test_123456@127.0.0.1:1611
drop table if exists interval_t1;
create table interval_t1(f1 int, f2 int, f3 char(30))
PARTITION BY RANGE(f2)
INTERVAL(1)
(
 PARTITION interval_t1p1 values less than(1),
 PARTITION interval_t1p2 values less than(2),
 PARTITION interval_t1p3 values less than(3)
);
insert into interval_t1 values (1,1,'abc'),(1000000,1000000,'abc');
commit;
conn sys/Huawei@123@127.0.0.1:1611
exp users=exp_interval_part_table file="./data/exp_interval_part_table.dmp" filetype=bin parallel = 16;
imp users=exp_interval_part_table file="./data/exp_interval_part_table.dmp" filetype=bin;
select * from exp_interval_part_table.interval_t1 order by f1;
drop user if exists exp_interval_part_table cascade;

-- index and primary key at same columns
drop user if exists exp_primary_key cascade;
create user exp_primary_key identified by Test_123456;
grant dba to  exp_primary_key;
conn exp_primary_key/Test_123456@127.0.0.1:1611
create table ts (c int , c1 int);
create index tsi on ts(c);
alter table ts add primary key(c);
conn sys/Huawei@123@127.0.0.1:1611
exp users = exp_primary_key filetype=bin file="./data/exp_primary_key.dmp";
imp users = exp_primary_key filetype=bin file="./data/exp_primary_key.dmp" log="./data/exp_primary_key.log";
drop user if exists exp_primary_key cascade;

drop user if exists exp_foreign_key cascade;
create user exp_foreign_key identified by Test_123456;
grant dba to  exp_foreign_key;
conn exp_foreign_key/Test_123456@127.0.0.1:1611
create table ts (c int , c1 int);
create table ts1 (c int primary key, c1 int);
alter table ts add foreign key(c) REFERENCES ts1(c);
conn sys/Huawei@123@127.0.0.1:1611
exp users = exp_foreign_key filetype=bin file="./data/exp_foreign_key.dmp";
imp users = exp_foreign_key filetype=bin file="./data/exp_foreign_key.dmp" log="./data/exp_foreign_key.log";
drop user if exists exp_foreign_key cascade;

conn sys/Huawei@123@127.0.0.1:1611
create user my_user identified by Changme_123;
grant create session to my_user;
grant select on sys.dv_database to my_user;
create table my_user.test(f1 int, f2 varchar(10));
insert into my_user.test values(1, 'sdsf');
commit;
conn my_user/Changme_123@127.0.0.1:1611
exp users=my_user filetype=bin file="my_test1.dmp";
exp tables=test filetype=bin file="my_test3.dmp";
exp tables=% filetype=bin file="my_test4.dmp";

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists my_user cascade;

-- DTS2019121400044
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists my_user cascade;
create user my_user identified by Test_123456;
grant dba to my_user;
conn my_user/Test_123456@127.0.0.1:1611
DROP TABLE IF EXISTS tbl_show_create_table6;
CREATE TABLE tbl_show_create_table6 (
    id INT CONSTRAINT tbl_show_create_table6 PRIMARY KEY
    ,col_integer_0 INTEGER
    ,col_BINARY_INTEGER_0 BINARY_INTEGER
    ,col_smallint_0 SMALLINT NOT NULL DEFAULT '7'
    ,col_bigint_0 BIGINT NOT NULL DEFAULT '3'
    ,col_BINARY_BIGINT_0 BINARY_BIGINT DEFAULT -9223372036854775808
    ,col_real_0 REAL DEFAULT 1.79e+308
    ,col_double_0 DOUBLE DEFAULT -1.79e+308
    ,col_float_0 FLOAT DEFAULT -1.79e+308
    ,col_BINARY_DOUBLE_0 BINARY_DOUBLE
    ,col_decimal_0 DECIMAL
    ,col_number1_0 number
    ,col_number2_0 number(38)
    ,col_number3_0 number(38, -84)
    ,col_number4_0 number(38, 127)
    ,col_number5_0 number(38, 7)
    ,col_numeric_0 NUMERIC
    ,col_char1_0 CHAR(8000)
    ,col_nchar1_0 NCHAR(8000)
    ,col_varchar_8000_0 VARCHAR(8000) DEFAULT 'aaaabbbb'
    ,col_varchar2_80000_0 varchar2(8000) NOT NULL DEFAULT 'aaaabbbb' comment 'varchar2(80000)'
    ,col_nvarchar1_0 NVARCHAR(8000)
    ,col_nvarchar2_80000_0 nvarchar2(8000) DEFAULT 
    'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBA'
    ,col_clob_0 clob
    ,col_text_0 TEXT
    ,col_longtext_0 longtext
    ,col_image_0 IMAGE
    ,col_binary2_0 BINARY (8000)
    ,col_varbinary2_0 VARBINARY(8000)
    ,col_raw2_0 raw(8000)
    ,col_blob_0 blob
    ,col_date_0 DATE NOT NULL DEFAULT '2018-01-07 08:08:08'
    ,col_datetime_0 DATETIME DEFAULT '2018-01-07 08:08:08'
    ,col_timestamp1_0 TIMESTAMP
    ,col_timestamp2_0 TIMESTAMP (6)
    ,col_timestamp3_0 TIMESTAMP WITH TIME ZONE
    ,col_timestamp4_0 TIMESTAMP WITH LOCAL TIME ZONE
    ,col_bool_0 bool
    ,col_boolean_0 boolean
    ,col_interval1_0 INTERVAL YEAR TO MONTH
    ,col_interval2_0 INTERVAL DAY TO SECOND
    );
exp tables=tbl_show_create_table6;
imp FULL = Y;

-- DTS2019121801909
conn sys/Huawei@123@127.0.0.1:1611
create user hbh identified by 'Cantian_123';
grant dba to hbh;
conn hbh/Cantian_123@127.0.0.1:1611
create or replace type array_number is table of number(20);
/
exp file="./data/hbh.sql";
imp file="./data/hbh.sql";

-- test export 'query' options
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists test_exp_query;
create user test_exp_query identified by 'Cantian_123';
grant dba to test_exp_query;
conn test_exp_query/Cantian_123@127.0.0.1:1611
create table t1(c int);
insert into t1 values(1),(2),(3);
commit;
exp tables = t1 query = "where c = 1" filetype=txt file = "./data/test_exp_query.dmp";
exp tables = t1 query = "where c = 1" filetype=txt parallel=2 file = "./data/test_exp_query.dmp";
exp tables = t1 query = "where c = 1" filetype=bin file = "./data/test_exp_query.dmp";
exp tables = t1 query = "where c = 1" filetype=bin parallel=2 file = "./data/test_exp_query.dmp";

-- test comment content include character "'"
conn sys/Huawei@123@127.0.0.1:1611
create user comment_specail_char identified by 'Cantian_123';
grant dba to comment_specail_char;
conn comment_specail_char/Cantian_123@127.0.0.1:1611
DROP TABLE IF EXISTS "ORDER_ORDERLINE";
CREATE TABLE "ORDER_ORDERLINE"
(
  "REC_SEQ" NUMBER(20) NOT NULL,
  "X_DAY" NUMBER(8)
);
COMMENT ON TABLE "ORDER_ORDERLINE" IS 'Order line table, record the order line.';
COMMENT ON COLUMN "ORDER_ORDERLINE"."X_DAY" IS 'X day(when the effect mode is ''x-day'' later).';

exp tables = ORDER_ORDERLINE file = "./data/test_comment_specail.dmp";
imp tables = ORDER_ORDERLINE file = "./data/test_comment_specail.dmp";
select COMMENTS from DB_COL_COMMENTS where OWNER = upper('comment_specail_char') and TABLE_NAME = 'ORDER_ORDERLINE';
exp tables = ORDER_ORDERLINE file = "./data/test_comment_specail_bin.dmp" filetype=bin;
imp tables = ORDER_ORDERLINE file = "./data/test_comment_specail_bin.dmp" filetype=bin;
select COMMENTS from DB_COL_COMMENTS where OWNER = upper('comment_specail_char') and TABLE_NAME = 'ORDER_ORDERLINE';

-- test multi user export
alter system set OPEN_CURSORS = 25; 

declare
sq1 varchar(1024);
begin
for i in 1..20 loop
sq1 := 'create user test_exp_stmt_lose'||i||' identified by Cantian_234';
execute immediate sq1;
end loop;
end;
/

exp users=test_exp_stmt_lose1,test_exp_stmt_lose2,test_exp_stmt_lose3,test_exp_stmt_lose4,test_exp_stmt_lose5,test_exp_stmt_lose6,test_exp_stmt_lose7,test_exp_stmt_lose8,test_exp_stmt_lose9,test_exp_stmt_lose10,test_exp_stmt_lose11,test_exp_stmt_lose12,test_exp_stmt_lose13,test_exp_stmt_lose14,test_exp_stmt_lose15,test_exp_stmt_lose16,test_exp_stmt_lose17,test_exp_stmt_lose18,test_exp_stmt_lose19,test_exp_stmt_lose20 file="./data/test_exp_stmt_lose.dmp";

declare
sq1 varchar(1024);
begin
for i in 1..20 loop
sq1 := 'drop user test_exp_stmt_lose'||i||' cascade';
execute immediate sq1;
end loop;
end;
/

alter system set OPEN_CURSORS = 2000; 

-- test sql larger than 1M
conn sys/Huawei@123@127.0.0.1:1611
create user TEST_LARGE_TABLE identified by 'Cantian_123';
grant dba to TEST_LARGE_TABLE;
conn TEST_LARGE_TABLE/Cantian_123@127.0.0.1:1611
-- error because agent stack is not enough
imp file="./data/large_table.dmp" filetype=bin tables=staffs_p;
imp file="./data/large_table.sql" filetype=txt tables=staffs_p;
