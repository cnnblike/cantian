drop table if exists bmsql_config;

drop table if exists bmsql_new_order;

drop table if exists bmsql_order_line;

drop table if exists bmsql_oorder;

drop table if exists bmsql_history;

drop table if exists bmsql_customer;

drop table if exists bmsql_stock;

drop table if exists bmsql_item;

drop table if exists bmsql_district;

drop table if exists bmsql_warehouse;

create table bmsql_config (
  cfg_name    varchar(30) primary key,
  cfg_value   varchar(50)
);

create table bmsql_warehouse (
  w_id        integer   not null,
  w_ytd       decimal(12,2),
  w_tax       decimal(4,4),
  w_name      varchar(10),
  w_street_1  varchar(20),
  w_street_2  varchar(20),
  w_city      varchar(20),
  w_state     char(2),
  w_zip       char(9)
);

create table bmsql_district (
  d_w_id       integer       not null,
  d_id         integer       not null,
  d_ytd        decimal(12,2),
  d_tax        decimal(4,4),
  d_next_o_id  integer,
  d_name       varchar(10),
  d_street_1   varchar(20),
  d_street_2   varchar(20),
  d_city       varchar(20),
  d_state      char(2),
  d_zip        char(9)
);

create table bmsql_customer (
  c_w_id         integer        not null,
  c_d_id         integer        not null,
  c_id           integer        not null,
  c_discount     decimal(4,4),
  c_credit       char(2),
  c_last         varchar(16),
  c_first        varchar(16),
  c_credit_lim   decimal(12,2),
  c_balance      decimal(12,2),
  c_ytd_payment  decimal(12,2),
  c_payment_cnt  integer,
  c_delivery_cnt integer,
  c_street_1     varchar(20),
  c_street_2     varchar(20),
  c_city         varchar(20),
  c_state        char(2),
  c_zip          char(9),
  c_phone        char(16),
  c_since        timestamp,
  c_middle       char(2),
  c_data         varchar(500)
);

create table bmsql_history (
  hist_id  integer,
  h_c_id   integer,
  h_c_d_id integer,
  h_c_w_id integer,
  h_d_id   integer,
  h_w_id   integer,
  h_date   timestamp,
  h_amount decimal(6,2),
  h_data   varchar(24)
);

create table bmsql_new_order (
  no_w_id  integer   not null,
  no_d_id  integer   not null,
  no_o_id  integer   not null
);

create table bmsql_oorder (
  o_w_id       integer      not null,
  o_d_id       integer      not null,
  o_id         integer      not null,
  o_c_id       integer,
  o_carrier_id integer,
  o_ol_cnt     integer,
  o_all_local  integer,
  o_entry_d    timestamp
);

create table bmsql_order_line (
  ol_w_id         integer   not null,
  ol_d_id         integer   not null,
  ol_o_id         integer   not null,
  ol_number       integer   not null,
  ol_i_id         integer   not null,
  ol_delivery_d   timestamp,
  ol_amount       decimal(6,2),
  ol_supply_w_id  integer,
  ol_quantity     integer,
  ol_dist_info    char(24)
);

create table bmsql_item (
  i_id     integer      not null,
  i_name   varchar(24),
  i_price  decimal(5,2),
  i_data   varchar(50),
  i_im_id  integer
);

create table bmsql_stock (
  s_w_id       integer       not null,
  s_i_id       integer       not null,
  s_quantity   integer,
  s_ytd        integer,
  s_order_cnt  integer,
  s_remote_cnt integer,
  s_data       varchar(50),
  s_dist_01    char(24),
  s_dist_02    char(24),
  s_dist_03    char(24),
  s_dist_04    char(24),
  s_dist_05    char(24),
  s_dist_06    char(24),
  s_dist_07    char(24),
  s_dist_08    char(24),
  s_dist_09    char(24),
  s_dist_10    char(24)
);

alter table bmsql_warehouse add constraint bmsql_warehouse_pkey  primary key (w_id);

alter table bmsql_district add constraint bmsql_district_pkey  primary key (d_w_id, d_id);

alter table bmsql_customer add constraint bmsql_customer_pkey  primary key (c_w_id, c_d_id, c_id);

-- create index bmsql_customer_idx1  on  bmsql_customer (c_w_id, c_d_id, c_last, c_first);

alter table bmsql_oorder add constraint bmsql_oorder_pkey  primary key (o_w_id, o_d_id, o_id);

-- create unique index bmsql_oorder_idx1  on  bmsql_oorder (o_w_id, o_d_id, o_carrier_id, o_id);

alter table bmsql_new_order add constraint bmsql_new_order_pkey  primary key (no_w_id, no_d_id, no_o_id);

alter table bmsql_order_line add constraint bmsql_order_line_pkey  primary key (ol_w_id, ol_d_id, ol_o_id, ol_number);

alter table bmsql_stock add constraint bmsql_stock_pkey  primary key (s_w_id, s_i_id);

alter table bmsql_item add constraint bmsql_item_pkey  primary key (i_id);

---	DTS2020022721644
alter table bmsql_district add constraint d_warehouse_fkey
    foreign key (d_w_id1)
    references bmsql_warehouse (w_id);
alter table bmsql_district add constraint d_warehouse_fkey
    foreign key (d_w_id)
    references bmsql_warehouse (w_id1);

alter table bmsql_district add constraint d_warehouse_fkey
    foreign key (d_w_id)
    references bmsql_warehouse (w_id);

alter table bmsql_customer add constraint c_district_fkey
    foreign key (c_w_id, c_d_id)
    references bmsql_district (d_w_id, d_id);

alter table bmsql_history add constraint h_customer_fkey
    foreign key (h_c_w_id, h_c_d_id, h_c_id)
    references bmsql_customer (c_w_id, c_d_id, c_id);
alter table bmsql_history add constraint h_district_fkey
    foreign key (h_w_id, h_d_id)
    references bmsql_district (d_w_id, d_id);

alter table bmsql_new_order add constraint no_order_fkey
    foreign key (no_w_id, no_d_id, no_o_id)
    references bmsql_oorder (o_w_id, o_d_id, o_id);

alter table bmsql_oorder add constraint o_customer_fkey
    foreign key (o_w_id, o_d_id, o_c_id)
    references bmsql_customer (c_w_id, c_d_id, c_id);

alter table bmsql_order_line add constraint ol_order_fkey
    foreign key (ol_w_id, ol_d_id, ol_o_id)
    references bmsql_oorder (o_w_id, o_d_id, o_id);
alter table bmsql_order_line add constraint ol_stock_fkey
    foreign key (ol_supply_w_id, ol_i_id)
    references bmsql_stock (s_w_id, s_i_id);

alter table bmsql_stock add constraint s_warehouse_fkey
    foreign key (s_w_id)
    references bmsql_warehouse (w_id);
alter table bmsql_stock add constraint s_item_fkey
    foreign key (s_i_id)
    references bmsql_item (i_id);
	
select t.name, c.cols, c.col_list from SYS_CONSTRAINT_DEFS c, SYS_TABLES t where c.cons_type = 2 and c.user# = t.user# and c.table# = t.id and t.name like 'BMSQL%' order by t.name, c.cols, c.col_list;

drop table bmsql_oorder;

drop table bmsql_config;

drop table bmsql_new_order;

drop table bmsql_order_line;

drop table bmsql_oorder;

drop table bmsql_history;

drop table bmsql_customer;

drop table bmsql_stock;

drop table bmsql_item;

drop table bmsql_district;

drop table bmsql_warehouse;

drop table if exists child1;

drop table if exists parent2;

drop table if exists parent1;

create table parent1(c3 int, c1 int, c2 int);

create table parent2(c1 int, c2 int, c3 int);

create table child1(c1 int, c2 int, c3 int);

alter table child1 add foreign key(c1, c2, c3) references parent1(c1, c2);

alter table child1 add foreign key(c1,c2) references parent1(c1,c2);

alter table parent1 add primary key(c1,c2);

alter table child1 add foreign key(c1,c2) references parent1(c1,c2);

alter table parent2 add unique(c3);

alter table child1 add foreign key(c3) references parent2(c3);

alter table parent2 add primary key(c2);

alter table parent2 add foreign key (c1) references parent2(c2);

insert into child1 values(1, 2, 3);

insert into child1 values(1, null, 3);

insert into parent1 values(3, 1, 2);

insert into child1 values(1, 2, 3);

insert into child1 values(1, 2, null);

insert into parent2 values(1, 2, 3);

insert into parent2 values(1, 1, 3);

insert into child1 values(1, 2, 3);

delete from parent1 where c1 = 1;

delete from parent2 where c3 = 3;

delete from child1;

delete from parent1;

delete from parent2;

drop table parent1;

drop table parent2;

drop table child1;

drop table parent2;

drop table parent1;

drop table if exists part_child;
drop table if exists part_parent;
create table part_parent(c1 int, c2 int, primary key (c1));
create table part_child(c1 int, c2 int, c3 int) partition by range(c1) (partition p1 values less than(10), partition p2 values less than (maxvalue));
alter table part_child add constraint fk_part_child foreign key(c1) references part_parent(c1);
insert into part_parent values(1,1);
insert into part_parent values(2,2);
insert into part_parent values(200, 200);
insert into part_child values(2, 1, 3);
insert into part_child values(1, 1, 3);
insert into part_child values(200, 200, 200);
update part_child set c1=2;
update part_child set c1=3;
update part_parent set c1=3 where c2=2;
update part_parent set c1=201 where c1=200;
delete from part_child;
delete from part_parent;
drop table part_child;
drop table part_parent;

--syntax 
drop table if exists test_fk1;
drop table if exists test_fk2;
drop table if exists test_pk;
create table test_pk(c1 int primary key, c2 int);
create table test_fk1(c1 int, c2 int, foreign key(c1) references test_pk(c1) match full);
create table test_fk1(c1 int, c2 int, foreign key(c1) references test_pk(c1) on delete set null);
create table test_fk2(c1 int, c2 int, foreign key(c1) references test_pk(c1) on delete cascade);
drop table test_fk1;
drop table test_fk2;
drop table test_pk;

--CloudSOP's needs
DROP TABLE IF EXISTS META_CLASS;
DROP TABLE IF EXISTS META_RELATION1;
CREATE TABLE META_CLASS (ID BIGINT NOT NULL, NAME VARCHAR(32) NOT NULL, GENDER BOOLEAN, PRIMARY KEY(ID));
CREATE TABLE META_RELATION1
(
  ID BIGINT NOT NULL ,
  NAME VARCHAR(128) UNIQUE NOT NULL,
  DESCRIPTION VARCHAR(250),
  SOURCE_CLASS_ID BIGINT NOT NULL,
  TARGET_CLASS_ID BIGINT NOT NULL,
  SOURCE_REMARK VARCHAR(500),
  TARGET_REMARK VARCHAR(500),
  SOURCE_ATTRIBUTE_ID BIGINT,
  TARGET_ATTRIBUTE_ID BIGINT,
  SOURCE_ALIAS VARCHAR(60),
  TARGET_ALIAS VARCHAR(60),
  CARDINALITY INTEGER NOT NULL,
  CUSTOM BOOLEAN DEFAULT TRUE,
  SENDEVENT BOOLEAN DEFAULT FALSE,
  RELCATEGORY VARCHAR(128),
  PRIMARY KEY (ID),
  CONSTRAINT FK_SOURCE_CLASS_ID FOREIGN KEY (SOURCE_CLASS_ID) REFERENCES META_CLASS(ID),
  CONSTRAINT FK_TARGET_CLASS_ID FOREIGN KEY (TARGET_CLASS_ID) REFERENCES META_CLASS(ID)
);

INSERT INTO META_CLASS VALUES(1, 'Bill Clinton', TRUE);
INSERT INTO META_CLASS VALUES(2, 'Hilary Clinton', FALSE);
COMMIT;

INSERT INTO META_RELATION1(ID, NAME, SOURCE_CLASS_ID, TARGET_CLASS_ID, CARDINALITY) VALUES (100, 'NAME100', 1, 2, 65535); --success
COMMIT;
INSERT INTO META_RELATION1(ID, NAME, SOURCE_CLASS_ID, TARGET_CLASS_ID, CARDINALITY) VALUES (200, 'NAME200', 2, 3, 65535); --fail
INSERT INTO META_RELATION1(ID, NAME, SOURCE_CLASS_ID, TARGET_CLASS_ID, CARDINALITY) VALUES (300, 'NAME300', 1, 4, 65535); --fail
INSERT INTO META_RELATION1(ID, NAME, SOURCE_CLASS_ID, TARGET_CLASS_ID, CARDINALITY) VALUES (400, 'NAME400', 3, 4, 65535); --fail 

DROP TABLE META_RELATION1;
DROP TABLE META_CLASS;

--test parent table referenced by many tables
DROP  TABLE IF EXISTS parent_table;
CREATE TABLE parent_table(id int primary key, val varchar(10));
CREATE TABLE child_001(id int, val varchar(10), CONSTRAINT fk_001 FOREIGN KEY(id) REFERENCES parent_table(id));
CREATE TABLE child_002(id int, val varchar(10), CONSTRAINT fk_002 FOREIGN KEY(id) REFERENCES parent_table(id));
CREATE TABLE child_003(id int, val varchar(10), CONSTRAINT fk_003 FOREIGN KEY(id) REFERENCES parent_table(id));
CREATE TABLE child_004(id int, val varchar(10), CONSTRAINT fk_004 FOREIGN KEY(id) REFERENCES parent_table(id));
INSERT INTO child_001 VALUES(1, 'a');
INSERT INTO child_002 VALUES(1, 'a');
INSERT INTO child_003 VALUES(1, 'a');
INSERT INTO child_004 VALUES(1, 'a');
INSERT INTO parent_table VALUES(1, 'b');
INSERT INTO child_001 VALUES(1, 'a');
INSERT INTO child_002 VALUES(1, 'a');
INSERT INTO child_003 VALUES(1, 'a');
INSERT INTO child_004 VALUES(1, 'a');
commit;
DELETE FROM parent_table;
DELETE FROM child_001;
DELETE FROM child_002;
DELETE FROM child_003;
DELETE FROM parent_table;
DELETE FROM child_004;
DELETE FROM parent_table;
DROP TABLE parent_table;
DROP TABLE parent_table CASCADE CONSTRAINTS;
INSERT INTO child_001 VALUES(2, 'a');
INSERT INTO child_002 VALUES(2, 'a');
INSERT INTO child_003 VALUES(2, 'a');
INSERT INTO child_004 VALUES(2, 'a');
DROP TABLE child_001;
DROP TABLE child_002;
DROP TABLE child_003;
DROP TABLE child_004;
DROP TABLE parent_table;

-- test foreign key update
DROP TABLE IF EXISTS CRON_TRIGGERS;
DROP TABLE IF EXISTS CRON_JOB_DETAILS;
CREATE TABLE CRON_JOB_DETAILS
(
SCHED_NAME VARCHAR(120) NOT NULL,
JOB_NAME VARCHAR(200) NOT NULL,
JOB_GROUP VARCHAR(200) NOT NULL,
DESCRIPTION VARCHAR(250) NULL,
JOB_CLASS_NAME VARCHAR(250) NOT NULL,
IS_DURABLE SMALLINT NOT NULL,
IS_NONCONCURRENT SMALLINT NOT NULL,
IS_UPDATE_DATA SMALLINT NOT NULL,
REQUESTS_RECOVERY SMALLINT NOT NULL,
PRIMARY KEY (SCHED_NAME,JOB_NAME,JOB_GROUP)
);
CREATE TABLE CRON_TRIGGERS
(
SCHED_NAME VARCHAR(120) NOT NULL,
TRIGGER_NAME VARCHAR(200) NOT NULL,
TRIGGER_GROUP VARCHAR(200) NOT NULL,
JOB_NAME VARCHAR(200) NOT NULL, 
JOB_GROUP VARCHAR(200) NOT NULL,
DESCRIPTION VARCHAR(250) NULL,
NEXT_FIRE_TIME BIGINT NULL,
PREV_FIRE_TIME BIGINT NULL,
PRIORITY INTEGER NULL,
TRIGGER_STATE VARCHAR(16) NOT NULL,
TRIGGER_TYPE VARCHAR(8) NOT NULL,
START_TIME BIGINT NOT NULL,
END_TIME BIGINT NULL,
CALENDAR_NAME VARCHAR(200) NULL,
MISFIRE_INSTR SMALLINT NULL,
PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
FOREIGN KEY (SCHED_NAME,JOB_NAME,JOB_GROUP) 
REFERENCES CRON_JOB_DETAILS(SCHED_NAME,JOB_NAME,JOB_GROUP) 
);
insert into CRON_JOB_DETAILS values ('CronScheduler','deleteservice_job','BasicService','','com.huawei.bsp.cron.quartz.job.QuartzJob','0','0','0','0');
insert into CRON_TRIGGERS values ('CronScheduler','deleteservice_job','BasicService','deleteservice_job','BasicService','','1531065600000','-1','5','WAITING','DAILY_I','1531065600000','0','','0');
commit;
UPDATE CRON_TRIGGERS SET JOB_NAME = 'deleteservice_job', JOB_GROUP = 'BasicService',SCHED_NAME = 'CronScheduler', DESCRIPTION = '', NEXT_FIRE_TIME = 1530709017237, PREV_FIRE_TIME = -1, TRIGGER_STATE = 'WAITING', TRIGGER_TYPE = 'DAILY_I', START_TIME = 1530633600000, END_TIME = 0, CALENDAR_NAME = '', MISFIRE_INSTR = 0, PRIORITY = 5 WHERE SCHED_NAME = 'CronScheduler' AND TRIGGER_NAME = 'deleteservice_job' AND TRIGGER_GROUP = 'BasicService';
commit;
DROP TABLE CRON_TRIGGERS;
DROP TABLE CRON_JOB_DETAILS;

--test delete cascade
DROP TABLE IF EXISTS STUDENT1;
DROP TABLE IF EXISTS CLASS1;
DROP TABLE  IF EXISTS CLASS2;
CREATE TABLE CLASS1 (c_id int primary key, class char(1), num int);
CREATE TABLE CLASS2 (c_id int, class char(1), num int);
alter table CLASS2 add constraint pk_class2 primary key (c_id, num);
CREATE TABLE STUDENT1 (s_id int primary key, c_id1 int not null, c_id2 int, c_id3 int, FOREIGN KEY (c_id1) REFERENCES CLASS1(c_id) ON DELETE SET NULL, FOREIGN KEY (c_id1) REFERENCES CLASS1(c_id) ON DELETE CASCADE);
CREATE TABLE STUDENT1 (s_id int primary key, c_id1 int not null, c_id2 int, c_id3 int, CONSTRAINT REF_S1_C1 FOREIGN KEY (c_id1) REFERENCES CLASS1(c_id) ON DELETE SET NULL, CONSTRAINT REF_S1_C2 FOREIGN KEY (c_id2, c_id3) REFERENCES CLASS2(c_id, num) ON DELETE CASCADE);
SELECT CONS_NAME,  CONS_TYPE, REF_CONS,REFACT FROM SYS_CONSTRAINT_DEFS WHERE CONS_NAME = 'REF_S1_C2' OR CONS_NAME = 'REF_S1_C1' ORDER BY CONS_NAME;
INSERT INTO CLASS1 VALUES(1, 'A', 10);
INSERT INTO CLASS1 VALUES(2, 'B', 20);
INSERT INTO CLASS1 VALUES(3, 'C', 30);
INSERT INTO CLASS2 VALUES(1, 'A', 10);
INSERT INTO CLASS2 VALUES(2, 'B', 20);
INSERT INTO STUDENT1 VALUES(1, 2, 1, 10);
INSERT INTO STUDENT1 VALUES(2, 3, 1, 10);
INSERT INTO STUDENT1 VALUES(3, 1, 1, 10);
COMMIT;
DELETE FROM CLASS1 WHERE c_id < 3;
SELECT * FROM CLASS1 ORDER BY c_id;
COMMIT;
INSERT INTO STUDENT1 VALUES(4, 3, 1, 10);
INSERT INTO STUDENT1 VALUES(5, 3, 2, 20);
DELETE FROM CLASS2 WHERE c_id = 1;
COMMIT;
SELECT * FROM CLASS2 ORDER BY c_id;
SELECT * FROM STUDENT1 ORDER BY s_id;

--dep_scan_index --DTS2018090409831
drop table if exists B;
drop table if exists A;
create table a (id1 int, id2 int, id3 int,id4 int);
create table B (id1 int, id2 int, id3 int,id4 int);
create index idx_b on b (id2, id3);
alter table A add primary key (id3, id2);
alter table B add foreign key (id2, id3) references A(id3, id2);
insert into A values (1,1,1,1);
insert into B values (1,1,1,1);
insert into A values (2,2,2,2);
insert into B values (3,2,2,4);
commit;
delete from A where id1 =1; commit;

drop table if exists B;
drop table if exists A;
create table a (id1 int, id2 int, id3 int,id4 int) crmode row;
create table B (id1 int, id2 int, id3 int,id4 int) crmode row;
create index idx_b on b (id2, id3) crmode row;
alter table A add primary key (id3, id2);
alter table B add foreign key (id2, id3) references A(id3, id2);
insert into A values (1,1,1,1);
insert into B values (1,1,1,1);
insert into A values (2,2,2,2);
insert into B values (3,2,2,4);
commit;
delete from A where id1 =1; commit;

drop table if exists B;
drop table if exists A;
create table a (id1 int unique, id2 int, id3 int,id4 int);
create table B (id1 int, id2 int, id3 int,id4 int);
create unique index idx_b1 on b (id2, id3);
alter table A add primary key (id2, id3);
alter table B add foreign key (id2)references A(id1)on delete cascade;
insert into A values (1,1,1,1);
insert into B values (1,1,1,1);
commit;
update A set id1 = 6;commit;
-- dep_scan_mix
drop table if exists B;
drop table if exists A;
create table a (id1 int, id2 int, id3 int,id4 int);
create table B (id1 int, id2 int, id3 int,id4 int);
create index idx_b on b (id2, id3);
alter table A add primary key (id3, id2, id1);
alter table B add foreign key (id2, id3, id1) references A(id3, id2, id1) on delete cascade;
insert into A values (1,2,3,4);
insert into B values (1,3,2,1);
insert into B values (1,3,2,2);
insert into B values (1,3,2,3);
insert into A values (5,6,7,8);
insert into B values (5,7,6,8);
commit;
delete from A where id1 =1; commit;
drop index idx_b on b;
delete from A; rollback;
--part_table
DROP TABLE IF EXISTS CLASS4;
DROP TABLE IF EXISTS cons_part;
CREATE TABLE CLASS4 (c_id int, class char(1), num int)PARTITION BY RANGE(num) (PARTITION p1 VALUES LESS THAN (100), PARTITION p2 VALUES LESS THAN (200), PARTITION p3 VALUES LESS THAN (300), PARTITION p4 VALUES LESS THAN (maxvalue));
CREATE TABLE cons_part(c1 int primary key, c2 varchar(32), c3 int) PARTITION BY RANGE(c3) (PARTITION p1 VALUES LESS THAN (100), PARTITION p2 VALUES LESS THAN (200), PARTITION p3 VALUES LESS THAN (300), PARTITION p4 VALUES LESS THAN (maxvalue));
CREATE INDEX idx_p1 ON CLASS4(c_id, num) local;
INSERT INTO CLASS4 VALUES(50, 'A', 20);
INSERT INTO CLASS4 VALUES(150, 'B', 150);
INSERT INTO CLASS4 VALUES(250, 'C', 250);
INSERT INTO cons_part VALUES(50, 'P1', 20);
INSERT INTO cons_part VALUES(150, 'P2', 150);
INSERT INTO cons_part VALUES(250, 'P3', 250);
COMMIT;
ALTER TABLE CLASS4 ADD FOREIGN KEY (c_id) REFERENCES cons_part(c1) ON DELETE SET NULL;
ALTER TABLE CLASS4 ADD FOREIGN KEY (c_id) REFERENCES cons_part(c1) ON DELETE SET NULL;
DELETE FROM cons_part WHERE c1 < 250;
SELECT * FROM CLASS4 ORDER BY class;
SELECT * FROM cons_part ORDER BY c1;

DROP TABLE IF EXISTS E;
DROP TABLE IF EXISTS D;
DROP TABLE IF EXISTS C;
DROP TABLE IF EXISTS B;
DROP TABLE IF EXISTS A;
CREATE TABLE A (id int, a_num int, a_id char, num int);
CREATE TABLE B (id int primary key, b_num int, b_id char, num int);
ALTER TABLE A ADD CONSTRAINT pf_a PRIMARY KEY (a_num, a_id);
CREATE TABLE C (id int primary key, c_num int, FOREIGN KEY (c_num) REFERENCES B (id) ON DELETE CASCADE);
CREATE TABLE D (id int primary key, d_num int,FOREIGN KEY (d_num) REFERENCES C (id) ON DELETE CASCADE);
CREATE TABLE E (id int primary key, e_num int,FOREIGN KEY (e_num) REFERENCES B (id) ON DELETE SET NULL);
INSERT INTO A VALUES (1,2,'a',4);
INSERT INTO B VALUES (1,2,'a',1);
INSERT INTO B VALUES (2,2,'a',1);
INSERT INTO B VALUES (3,2,'c',1);
INSERT INTO C VALUES (1,1);
INSERT INTO D VALUES (1,1);
INSERT INTO E VALUES (1,1);
COMMIT;
CREATE INDEX id_a ON A(id);
ALTER TABLE B ADD CONSTRAINT ref_ab FOREIGN KEY (b_num, b_id) REFERENCES A (a_num, a_id) ON DELETE SET NULL;
INSERT INTO A VALUES (1,2,'c',4);
COMMIT;
ALTER TABLE B ADD CONSTRAINT ref_ab1 FOREIGN KEY (b_num, b_id) REFERENCES A (a_num, a_id) ON DELETE SET NULL;
DELETE FROM A;
SELECT * FROM B ORDER BY id;
ROLLBACK;
ALTER TABLE B ADD CONSTRAINT ref_ab2 FOREIGN KEY (b_num, b_id) REFERENCES A (a_num, a_id) ON DELETE CASCADE;

DROP TABLE E;
DROP TABLE D;
DROP TABLE C;
DROP TABLE B;
DROP TABLE A;
DROP TABLE IF EXISTS TB1;
CREATE TABLE A (id int primary key, a_num int);
CREATE TABLE TB1 (
t1 int, t2 int, t3 int, t4 int, t5 int, t6 int, t7 int, t8 int, t9 int, t10 int,
t11 int, t12 int, t13 int, t14 int, t15 int, t16 int, t17 int, t18 int, t19 int, t20 int,
t21 int, t22 int, t23 int, t24 int, t25 int, t26 int, t27 int, t28 int, t29 int, t30 int, 
t31 int, t32 int, t33 int, t34 int);
ALTER TABLE TB1 ADD FOREIGN KEY (t1) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t2) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t3) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t4) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t5) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t6) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t7) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t8) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t9) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t10) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t11) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t12) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t13) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t14) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t15) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t16) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t17) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t18) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t19) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t20) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t21) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t22) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t23) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t24) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t25) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t26) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t27) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t28) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t29) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t30) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t31) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD FOREIGN KEY (t32) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1 ADD CONSTRAINT pk_tb1 PRIMARY KEY (t34);
ALTER TABLE TB1 ADD FOREIGN KEY (t33) REFERENCES A (id) ON DELETE CASCADE;
ALTER TABLE TB1  ADD CONSTRAINT chk_tb1 check(t1 - t2 <= 0 );

DROP TABLE TB1;
DROP TABLE A;
DROP TABLE STUDENT1;
DROP TABLE CLASS1;
DROP TABLE  CLASS2;
DROP TABLE  CLASS4;
DROP TABLE cons_part;

DROP TABLE IF EXISTS F_TAB;
DROP TABLE IF EXISTS C_TAB;
CREATE TABLE F_TAB(FD_INT INT, FD_VARCHAR VARCHAR(100));
CREATE TABLE C_TAB(FD_INT INT, FD_VARCHAR VARCHAR(100), FD_INT_2 INT REFERENCES F_TAB);
CREATE TABLE C_TAB(FD_INT INT, FD_VARCHAR VARCHAR(100), FD_INT_2 INT REFERENCES F_TAB () ON DELETE CASCADE, FD_CLOB CLOB);
CREATE TABLE C_TAB(FD_INT INT, FD_VARCHAR VARCHAR(100), FD_INT_2 INT REFERENCES F_TAB ON DELETE SET NULL, FD_CLOB CLOB);
DROP TABLE F_TAB;
CREATE TABLE F_TAB(FD_INT INT PRIMARY KEY, FD_VARCHAR VARCHAR(100));
CREATE TABLE C_TAB(FD_INT INT PRIMARY KEY, FD_VARCHAR VARCHAR(100), FD_INT_2 INT REFERENCES F_TAB ON DELETE CASCADE, FD_CLOB CLOB);
INSERT INTO F_TAB VALUES(1,'F_ABC');
INSERT INTO F_TAB VALUES(2,'F_ABC');
INSERT INTO C_TAB VALUES(1,'C_ABC', 1, '1234354587643123455213445656723123424554566776763221132454566768767433242323'),(3,'C_ABC', 3, '1234354587643123455213445656723123424554566776763221132454566768767433242323'),(2,'C_ABC', 2, '1234354587643123455213445656723123424554566776763221132454566768767433242323');
INSERT INTO C_TAB VALUES(1,'C_ABC', 1, '1234354587643123455213445656723123424554566776763221132454566768767433242323'),(2,'C_ABC', 2, '1234354587643123455213445656723123424554566776763221132454566768767433242323');
UPDATE C_TAB SET FD_INT_2 = 3 WHERE FD_INT = 1;
SELECT * FROM C_TAB ORDER BY FD_INT;
DELETE FROM F_TAB WHERE  FD_INT = 1;
SELECT * FROM C_TAB WHERE FD_INT_2 = 1;
UPDATE F_TAB SET FD_INT = 3 WHERE FD_VARCHAR = 'F_ABC';
SELECT * FROM F_TAB WHERE FD_INT = 2;
SELECT * FROM C_TAB WHERE FD_INT_2 = 2;
SELECT * FROM C_TAB WHERE FD_INT_2 = 3;
DROP TABLE C_TAB;
DROP TABLE F_TAB;

CREATE TABLE F_TAB(FD_INT INT, FD_VARCHAR VARCHAR(100), CONSTRAINT PK_F_TAB PRIMARY KEY (FD_INT, FD_VARCHAR));
CREATE TABLE C_TAB(FD_INT INT, FD_VARCHAR VARCHAR(10), FD_INT_2 INT, FD_CLOB CLOB, CONSTRAINT RF_C_TAB FOREIGN KEY (FD_VARCHAR, FD_INT_2) REFERENCES F_TAB ON DELETE SET NULL);
CREATE TABLE C_TAB(FD_INT INT PRIMARY KEY, FD_VARCHAR VARCHAR(100), FD_INT_2 INT, FD_CLOB CLOB, CONSTRAINT RF_C_TAB FOREIGN KEY (FD_INT_2, FD_VARCHAR) REFERENCES F_TAB ON DELETE SET NULL);
INSERT INTO F_TAB VALUES(1,'F_ABC');
INSERT INTO F_TAB VALUES(2,'F_ABC');
INSERT INTO C_TAB VALUES(1,'F_ABC', 1, '1234354587643123455213445656723123424554566776763221132454566768767433242323'),(3,'F_ABC', 3, '1234354587643123455213445656723123424554566776763221132454566768767433242323'),(2,'F_ABC', 2, '1234354587643123455213445656723123424554566776763221132454566768767433242323');
INSERT INTO C_TAB VALUES(1,'C_ABC', 1, '1234354587643123455213445656723123424554566776763221132454566768767433242323'),(2,'C_ABC', 2, '1234354587643123455213445656723123424554566776763221132454566768767433242323');
INSERT INTO C_TAB VALUES(1,'F_ABC', 1, '1234354587643123455213445656723123424554566776763221132454566768767433242323'),(2,'F_ABC', 2, '1234354587643123455213445656723123424554566776763221132454566768767433242323');
UPDATE C_TAB SET FD_INT_2 = 3 WHERE FD_INT = 1;
SELECT * FROM C_TAB ORDER BY FD_INT;
DELETE FROM F_TAB WHERE  FD_INT = 1;
SELECT * FROM C_TAB WHERE FD_INT = 1;
UPDATE F_TAB SET FD_VARCHAR = 'F_F_ABC' WHERE FD_INT = 2;
SELECT * FROM C_TAB ORDER BY FD_INT;
DROP TABLE C_TAB;
DROP TABLE F_TAB;


CREATE TABLE F_TAB(FD_INT INT, FD_VARCHAR VARCHAR(100), CONSTRAINT PK_F_TAB PRIMARY KEY (FD_INT, FD_VARCHAR));
CREATE TABLE C_TAB(FD_INT INT PRIMARY KEY, FD_VARCHAR VARCHAR(100), FD_INT_2 INT, FD_CLOB CLOB);
ALTER TABLE  C_TAB ADD CONSTRAINT RF_C_TAB FOREIGN KEY (FD_INT_2, FD_VARCHAR) REFERENCES F_TAB ON DELETE SET NULL;
INSERT INTO F_TAB VALUES(1,'F_ABC');
INSERT INTO F_TAB VALUES(2,'F_ABC');
INSERT INTO C_TAB VALUES(1,'F_ABC', 1, '1234354587643123455213445656723123424554566776763221132454566768767433242323'),(3,'F_ABC', 3, '1234354587643123455213445656723123424554566776763221132454566768767433242323'),(2,'F_ABC', 2, '1234354587643123455213445656723123424554566776763221132454566768767433242323');
INSERT INTO C_TAB VALUES(1,'C_ABC', 1, '1234354587643123455213445656723123424554566776763221132454566768767433242323'),(2,'C_ABC', 2, '1234354587643123455213445656723123424554566776763221132454566768767433242323');
INSERT INTO C_TAB VALUES(1,'F_ABC', 1, '1234354587643123455213445656723123424554566776763221132454566768767433242323'),(2,'F_ABC', 2, '1234354587643123455213445656723123424554566776763221132454566768767433242323');
UPDATE C_TAB SET FD_INT_2 = 3 WHERE FD_INT = 1;
SELECT * FROM C_TAB ORDER BY FD_INT;
DELETE FROM F_TAB WHERE  FD_INT = 1;
SELECT * FROM C_TAB WHERE FD_INT = 1;
UPDATE F_TAB SET FD_VARCHAR = 'F_F_ABC' WHERE FD_INT = 2;
SELECT * FROM C_TAB ORDER BY FD_INT;
DROP TABLE C_TAB;
DROP TABLE F_TAB;
--locate
drop table if exists ft1;
drop table if exists pt1;
CREATE TABLE PT1 (id1 int, id2 int, id3 int, id4 int, id5 int) PARTITION BY RANGE(id2, id4)(PARTITION P1 VALUES LESS THAN (10,10),PARTITION p2 VALUES LESS THAN (20,20), PARTITION p3 VALUES LESS THAN (30,30));
CREATE TABLE FT1 (id1 int, id2 int, id3 int, id4 int, id5 int) PARTITION BY RANGE(id2, id4)(PARTITION F1 VALUES LESS THAN (10,10), PARTITION F2 VALUES LESS THAN (20,20),  PARTITION F3 VALUES LESS THAN (30,30));
CREATE INDEX idx_pt1 ON PT1 (id1, id2, id4) LOCAL;
CREATE INDEX idx_ft1 ON FT1 (id1, id2, id4) LOCAL;
ALTER TABLE PT1 ADD CONSTRAINT pk_pt1 PRIMARY KEY (id1, id2, id4);
ALTER TABLE FT1 ADD FOREIGN KEY (id4, id2, id1) REFERENCES PT1(id1, id2, id4) ON DELETE CASCADE;
INSERT INTO PT1 VALUES (1,2,3,4,5);
INSERT INTO FT1 VALUES (4,2,7,1,6);
INSERT INTO PT1 VALUES (10,20,30,40,50);
INSERT INTO FT1 VALUES (40,20,70,10,60);
INSERT INTO PT1 VALUES (2,4,6,8,10);
INSERT INTO FT1 VALUES (8,4,14,2,12);
COMMIT;
DELETE FROM pt1 where id5 < 60;
select * from ft1;
--border
drop table ft1;
drop table pt1;
CREATE TABLE PT1 (id1 int, id2 int, id3 int, id4 int, id5 int) PARTITION BY RANGE(id3, id4) (PARTITION P1 VALUES LESS THAN (10,10),PARTITION p2 VALUES LESS THAN (20,20), PARTITION p3 VALUES LESS THAN (30,30));
CREATE TABLE FT1 (id1 int, id2 int, id3 int, id4 int, id5 int) PARTITION BY RANGE(id4, id3) (PARTITION F1 VALUES LESS THAN (10,10),PARTITION F2 VALUES LESS THAN (20,20), PARTITION F3 VALUES LESS THAN (50,50));
CREATE INDEX idx_ft1 ON FT1 (id1, id2, id4) LOCAL;
ALTER TABLE PT1 ADD CONSTRAINT pk_pt2 PRIMARY KEY (id1, id2, id4);
ALTER TABLE FT1 ADD FOREIGN KEY (id4, id2, id1) REFERENCES PT1(id1, id2, id4) ON DELETE CASCADE;
INSERT INTO PT1 VALUES (1,2,3,4,5);
INSERT INTO FT1 VALUES (4,2,7,1,6);
INSERT INTO PT1 VALUES (10,20,29,29,50);
INSERT INTO FT1 VALUES (29,20,20,10,60);
INSERT INTO PT1 VALUES (2,4,6,8,10);
INSERT INTO FT1 VALUES (8,4,14,2,12);
COMMIT;
DELETE FROM pt1 where id5 = 50;
select * from ft1 order by id1;
--DTS2018122512126  
drop table if exists test_hash_fk;
create table test_hash_fk (
c1 char(20) not null,
c2 number(8) not null
)
partition by hash(c1)
(
partition part_01,
partition part_02,
partition part_03
);
 create index idx_hash_t1 on test_hash_fk(c1);
insert into test_hash_fk values('aaaa',111);
insert into test_hash_fk values('bbbb',111);
commit;

drop table if exists test_hash_fk1;
create table test_hash_fk1 (
c1 char(20) not null,
c2 number(8) not null
)
partition by hash(c1)
(
partition part_01,
partition part_02,
partition part_03
);
 create index idx_hash_t2 on test_hash_fk1(c1);
insert into test_hash_fk1 values('aaaa',111);commit;

alter table test_hash_fk add constraint t_hash_pk primary key(c1) using index idx_hash_t1;
alter table test_hash_fk1 add CONSTRAINT t_hash_fk foreign key(c1) references test_hash_fk(c1);
alter table test_hash_fk truncate partition part_01;
alter table test_hash_fk1 disable constraint t_hash_fk;
alter table test_hash_fk truncate partition part_01;
alter table test_hash_fk1 enable constraint t_hash_fk;
drop table if exists test_hash_fk1;
drop table if exists test_hash_fk;

DROP TABLE IF EXISTS T_EMP;
CREATE TABLE t_EMP
(EMPNO NUMBER(4) ,
ENAME VARCHAR2(10),
MGR NUMBER(4)
);
alter table t_emp add constraint t_emp_pk unique (empno);
alter table t_emp add CONSTRAINT t_emp_fk_emp foreign key(mgr) references t_emp(empno);
alter table t_emp drop constraint t_emp_pk;
DROP TABLE IF EXISTS T_EMP;

--DTS2018083008766
drop table ft1;
drop table pt1;
CREATE TABLE PT1 (id1 int, id2 int, id3 int, id4 int, id5 int) PARTITION BY RANGE(id3, id4) (PARTITION P1 VALUES LESS THAN (10,10),PARTITION p2 VALUES LESS THAN (20,20), PARTITION p3 VALUES LESS THAN (30,30));
CREATE TABLE FT1 (id1 int, id2 int, id3 int, id4 int, id5 int) PARTITION BY RANGE(id4, id3) (PARTITION F1 VALUES LESS THAN (10,10),PARTITION F2 VALUES LESS THAN (20,20), PARTITION F3 VALUES LESS THAN (50,50));
ALTER TABLE PT1 ADD CONSTRAINT pk_pt2 PRIMARY KEY (id1, id2, id4);
ALTER TABLE FT1 ADD FOREIGN KEY (id4, id2, id1) REFERENCES PT1(id1, id2, id4) ON DELETE CASCADE;
INSERT INTO PT1 VALUES (1,2,3,4,5);
INSERT INTO FT1 VALUES (4,2,7,1,6);
INSERT INTO PT1 VALUES (10,20,29,29,50);
INSERT INTO FT1 VALUES (29,20,20,10,60);
INSERT INTO PT1 VALUES (2,4,6,8,10);
INSERT INTO FT1 VALUES (8,4,14,2,12);
COMMIT;
DELETE FROM pt1;
select * from ft1 order by id1;
alter table pt1 split partition p3 at (25, 25) into (partition p4 ,partition p6 ) invalidate global indexes;
alter table pt1 split partition p3 at (25, 25) into (partition p4 ,partition p6 ) update global indexes;
alter index pk_pt2 on pt1 unusable;
INSERT INTO FT1 VALUES (4,2,7,1,6);
 --full
drop table ft1;
drop table pt1;
CREATE TABLE PT1 (id1 int, id2 int, id3 int, id4 int, id5 int) PARTITION BY RANGE(id2, id4) (PARTITION P1 VALUES LESS THAN (10,10), PARTITION p2 VALUES LESS THAN (20,20),  PARTITION p3 VALUES LESS THAN (30,30));
CREATE TABLE FT1 (id1 int, id2 int, id3 int, id4 int, id5 int) PARTITION BY RANGE(id5, id3) (PARTITION F1 VALUES LESS THAN (10,10), PARTITION F2 VALUES LESS THAN (20,20),  PARTITION F3 VALUES LESS THAN (50,50));
CREATE INDEX idx_pt1 ON PT1 (id1, id2, id4);
CREATE INDEX idx_ft1 ON FT1 (id1, id2, id4) LOCAL;
ALTER TABLE PT1 ADD CONSTRAINT pk_pt2 PRIMARY KEY (id1, id2, id4);
ALTER TABLE FT1 ADD FOREIGN KEY (id4, id2, id1) REFERENCES PT1(id1, id2, id4) ON DELETE CASCADE;
INSERT INTO PT1 VALUES (1,2,3,4,5);
INSERT INTO FT1 VALUES (4,2,7,1,6);
INSERT INTO PT1 VALUES (10,20,29,29,20);
INSERT INTO FT1 VALUES (29,20,20,10,20);
INSERT INTO PT1 VALUES (2,4,6,8,29);
INSERT INTO FT1 VALUES (8,4,14,2,29);
COMMIT;
DELETE FROM pt1 where id5 = 20;
select * from ft1 order by id1;
drop table ft1;
drop table pt1;
--DTS2018083009606
DROP TABLE IF EXISTS CONS_SELF;
CREATE TABLE CONS_SELF(ID INT PRIMARY KEY, NUM INT, FOREIGN KEY (ID) REFERENCES CONS_SELF(ID));
DROP TABLE IF EXISTS CONS_SELF;
CREATE TABLE CONS_SELF(ID INT PRIMARY KEY, NUM INT);
ALTER TABLE CONS_SELF ADD FOREIGN KEY (ID) REFERENCES CONS_SELF(ID);
INSERT INTO CONS_SELF VALUES(1,1);
COMMIT;
DELETE FROM CONS_SELF;
DROP TABLE IF EXISTS CONS_SELF;
--DTS2018083009778
DROP TABLE IF EXISTS TMP_CONS;
DROP TABLE IF EXISTS REF_TMP;
CREATE GLOBAL TEMPORARY TABLE TMP_CONS (ID INT PRIMARY KEY);
CREATE TABLE REF_TMP(ID INT, NUM INT UNIQUE);
ALTER TABLE REF_TMP ADD FOREIGN KEY (ID) REFERENCES TMP_CONS(ID);
ALTER TABLE TMP_CONS ADD FOREIGN KEY (ID) REFERENCES REF_TMP(ID);
DROP TABLE IF EXISTS TMP_CONS;
DROP TABLE IF EXISTS REF_TMP;

drop table if exists test_001;
drop table if exists test_00;
create table test_00(i int,j int,primary key(i));
create table test_001(i int,j int,primary key(i));
insert into test_00 values(1,1);
insert into test_001 values(1,1);
alter table test_001 add constraint foreign_key_001 foreign key(i) references test_00(i);
insert into test_001 values(2,2);
alter table test_00 modify i auto_increment;
insert into test_00 values(2,2);
insert into test_001 values(2,2);
drop table if exists test_001;
drop table if exists test_00;

--DTS2018102208126DTS2018102206692
DROP TABLE IF EXISTS PT;
create table pt (i int primary key, id int references pt(i));
insert into pt values (1,2);
insert into pt values (1,1);
insert into pt values (2,1); 
commit;
delete from pt where id = 1;rollback;
delete from pt where i = 2;rollback;
delete from pt where i = 1;rollback;
delete from pt where i = 2;
delete from pt where i = 1;
rollback;
DROP TABLE IF EXISTS PT;

DROP TABLE IF EXISTS T_EMP;
CREATE TABLE t_EMP
(EMPNO NUMBER(4) ,
ENAME VARCHAR2(10),
MGR NUMBER(4)
);
alter table t_emp add constraint t_emp_pk primary key(empno);
alter table t_emp add CONSTRAINT t_emp_fk_emp foreign key(mgr) references t_emp(empno);
INSERT INTO t_EMP VALUES(-3,'',-100);
alter table T_EMP DISABLE constraint t_emp_fk_emp;
INSERT INTO t_EMP VALUES(-3,'',-100);
commit;
alter table T_EMP ENABLE constraint t_emp_fk_emp;
UPDATE t_EMP SET empno=-100 WHERE empno=-3;
COMMIT;
alter table T_EMP ENABLE constraint t_emp_fk_emp;
DROP TABLE IF EXISTS T_EMP;
--DTS2018120502981
drop table if exists test_zlj_001;
drop table if exists test_zlj;
create table test_zlj(i int,j int,primary key(i));
create table test_zlj_001(i int,j int,primary key(i));
alter table test_zlj_001 add constraint foreign_key_001 foreign key(i) references test_zlj(i);
alter table test_zlj_001 add k char(20) default 'bbbbb';
insert into test_zlj_001(i,j) values(1,1);
alter table test_zlj add k char(20) default 'bbbbb';
insert into test_zlj (i,j) values(1,1);
insert into test_zlj_001(i,j) values(1,1);
ROLLBACK;
drop table test_zlj_001;
drop table test_zlj;

DROP TABLE IF EXISTS E;
DROP TABLE IF EXISTS D;
DROP TABLE IF EXISTS C;
DROP TABLE IF EXISTS B;
DROP TABLE IF EXISTS A;
CREATE TABLE A (id int, a_num int, a_id char, num int);
CREATE TABLE B (id int primary key, b_num int, b_id char, num int);
ALTER TABLE A ADD CONSTRAINT pk_a1 PRIMARY KEY (id);
ALTER TABLE B ADD CONSTRAINT fk_ab1 FOREIGN KEY (b_num) REFERENCES A (id) ON DELETE CASCADE;
CREATE TABLE C (id int primary key, c_num int);
ALTER TABLE C ADD CONSTRAINT fk_bc1 FOREIGN KEY (c_num) REFERENCES B (id) ON DELETE CASCADE;
CREATE TABLE D (id int primary key, d_num int,FOREIGN KEY (d_num) REFERENCES C (id) ON DELETE CASCADE);
CREATE TABLE E (id int primary key, e_num int);
ALTER TABLE E ADD CONSTRAINT fk_be1 FOREIGN KEY (e_num) REFERENCES B (id) ON DELETE SET NULL;
INSERT INTO A VALUES (1,2,'a',4);
INSERT INTO B VALUES (1,1,'a',1);
INSERT INTO B VALUES (2,1,'a',1);
INSERT INTO B VALUES (3,1,'c',1);
INSERT INTO C VALUES (1,1);
INSERT INTO D VALUES (1,1);
INSERT INTO E VALUES (1,1);
COMMIT;
DELETE FROM A;
SELECT * FROM B;
SELECT * FROM C;
SELECT * FROM D;
SELECT * FROM E;
ROLLBACK;
ALTER TABLE C DROP CONSTRAINT fk_bc1;
ALTER TABLE C ADD CONSTRAINT fk_bc1 FOREIGN KEY (c_num) REFERENCES B (id) ON DELETE SET NULL;
DELETE FROM A;
SELECT * FROM B;
SELECT * FROM C;
SELECT * FROM D;
SELECT * FROM E;
ROLLBACK;
ALTER TABLE C DROP CONSTRAINT fk_bc1;
ALTER TABLE C ADD CONSTRAINT fk_bc1 FOREIGN KEY (c_num) REFERENCES B (id) ON DELETE CASCADE;
ALTER TABLE E DROP CONSTRAINT fk_be1;
ALTER TABLE E ADD CONSTRAINT fk_be1 FOREIGN KEY (e_num) REFERENCES D (id);
DELETE FROM A;
DROP TABLE IF EXISTS E;
DROP TABLE IF EXISTS D;
DROP TABLE IF EXISTS C;
DROP TABLE IF EXISTS B;
DROP TABLE IF EXISTS A;

drop table if exists tbl_ports;
drop table if exists tbl_vnics;
drop table if exists tbl_vms;
drop table if exists tbl_vdus;
drop table if exists tbl_vnfs;
drop table if exists tbl_solution;

CREATE TABLE tbl_solution (
    dn                 NVARCHAR2(255) NOT NULL PRIMARY KEY,
    solution_name      NVARCHAR2(255) NULL,
    solution_id        NVARCHAR2(255) NULL
)
/

 CREATE TABLE tbl_vnfs (
   dn                 NVARCHAR2(255) NOT NULL PRIMARY KEY,
    solution_dn        NVARCHAR2(255) NOT NULL,
    solution_id        NVARCHAR2(255) NULL,
    FOREIGN KEY (solution_dn) REFERENCES tbl_solution (dn) ON DELETE CASCADE
)
/
 CREATE INDEX idx_vnfs_2 ON tbl_vnfs (solution_dn)
/
CREATE TABLE tbl_vdus (
    dn          NVARCHAR2(255) NOT NULL PRIMARY KEY,
    vnf_dn      NVARCHAR2(255) NOT NULL,
   vdu_name    NVARCHAR2(255) NULL,
    FOREIGN KEY (vnf_dn) REFERENCES tbl_vnfs (dn) ON DELETE CASCADE
)
/
 CREATE INDEX idx_vdus_2 ON tbl_vdus (vnf_dn)
/
  
 CREATE TABLE tbl_vms (
    dn                  NVARCHAR2(255) NOT NULL PRIMARY KEY,
    vdu_dn              NVARCHAR2(255) NOT NULL,
    vm_name             NVARCHAR2(255) NOT NULL,
    FOREIGN KEY (vdu_dn) REFERENCES tbl_vdus (dn) ON DELETE CASCADE
)
/
CREATE INDEX idx_vms_2  ON tbl_vms (vdu_dn)
/
 CREATE TABLE tbl_vnics
(
    dn                  NVARCHAR2(255) NOT NULL PRIMARY KEY,
    vm_dn               NVARCHAR2(255) NOT NULL,
    interface_name      NVARCHAR2(255) NULL,
    FOREIGN KEY (vm_dn) REFERENCES tbl_vms (dn) ON DELETE CASCADE
)
/
CREATE INDEX idx_vnics_2 ON tbl_vnics (vm_dn)
/
  
 CREATE TABLE tbl_ports (
    dn                 NVARCHAR2(255) NOT NULL PRIMARY KEY,
    port_index         INT            NULL,
    nic_dn             NVARCHAR2(255) NOT NULL,
    FOREIGN KEY (nic_dn) REFERENCES tbl_vnics (dn) ON DELETE CASCADE
)
/

 CREATE INDEX idx_ports_2  ON tbl_ports (nic_dn)
/
  
insert into tbl_solution values ('a','b','c');
insert into tbl_vnfs values ('d','a','f');
insert into tbl_vdus values ('h','d','i');
insert into tbl_vms values ('t','h','b');
insert into tbl_vnics values ('a','t','f');
insert into tbl_ports values ('h',1,'a');
commit;
delete from tbl_vnfs;
select * from tbl_vms;
select * from tbl_ports;
drop table if exists tbl_ports;
drop table if exists tbl_vnics;
drop table if exists tbl_vms;
drop table if exists tbl_vdus;
drop table if exists tbl_vnfs;
drop table if exists tbl_solution;

drop user if exists vv cascade;
create user vv identified by Cantian_234;
grant dba to vv;
connect vv/Cantian_234@127.0.0.1:1611
create table test (i int, id int) partition by range(i) (partition p1 values less than(10), partition p2 values less than (maxvalue));
create table fk_test (i int, id int) partition by range(i) (partition p1 values less than(10), partition p2 values less than (maxvalue));
alter table test add constraint pk_vv_test primary key (i);
alter table fk_test add constraint foreign_key_001 foreign key(i) references test(i);
insert into test values(1,1);
insert into fk_test values(1,1);
commit;
alter table fk_test drop constraint foreign_key_001;
alter table test truncate partition p1;
alter index pk_vv_test on test rebuild;
insert into test values (1,1);
alter table fk_test add constraint foreign_key_001 foreign key(i) references test(i);
flashback table test partition p1 to before truncate force;
insert into fk_test values (1,1);
commit;
connect sys/Huawei@123@127.0.0.1:1611
drop user vv cascade;

drop table if exists part_ft1;
drop table if exists part_pt1;
CREATE TABLE part_pt1 (id1 int, id2 int, id3 int, id4 int, id5 int) PARTITION BY RANGE(id1) (PARTITION P1 VALUES LESS THAN (10), PARTITION p2 VALUES LESS THAN (20),  PARTITION p3 VALUES LESS THAN (30));
CREATE TABLE part_ft1 (id1 int, id2 int, id3 int, id4 int, id5 int);
CREATE INDEX idx_part_pt1 ON part_pt1 (id1, id2, id3) LOCAL;
INSERT INTO part_ft1 VALUES (4,1,2,3,6);
ALTER TABLE part_pt1 ADD CONSTRAINT pk_part_pt2 PRIMARY KEY (id1, id2, id3);
ALTER TABLE part_ft1 ADD FOREIGN KEY (id2, id3, id4) REFERENCES part_pt1(id1, id2, id3);
DELETE FROM part_ft1;
INSERT INTO part_pt1 VALUES (1,2,3,4,5);
INSERT INTO part_ft1 VALUES (4,1,2,3,6);
COMMIT;
ALTER TABLE part_ft1 ADD FOREIGN KEY (id2, id3, id4) REFERENCES part_pt1(id1, id2, id3);
INSERT INTO part_ft1 VALUES (40,60,20,30,60);
drop table if exists part_ft1;
drop table if exists part_pt1;

drop table if exists interval_ft1;
drop table if exists interval_pt1;
create table interval_pt1(f1 int, f2 int, f3 char(30))
PARTITION BY RANGE(f2)
INTERVAL(10)
(
 PARTITION pt1p1 values less than(10),
 PARTITION pt1p2 values less than(20),
 PARTITION pt1p3 values less than(30)
);
CREATE TABLE interval_ft1 (f1 int, f2 int, f3 char(30));
CREATE INDEX idx_interval_pt1 ON interval_pt1 (f1, f2) LOCAL;
ALTER TABLE interval_pt1 ADD CONSTRAINT pk_interval_pt2 PRIMARY KEY (f1, f2);
ALTER TABLE interval_ft1 ADD FOREIGN KEY (f2, f1) REFERENCES interval_pt1(f1, f2);
INSERT INTO interval_pt1 values(1,1,'a');
INSERT INTO interval_ft1 values(1,1,'a');
INSERT INTO interval_ft1 values(999999999,1,'a');
drop table if exists interval_ft1;
drop table if exists interval_pt1;

DROP TABLE IF EXISTS TRAINING0;
DROP TABLE IF EXISTS EDUCATION0;
CREATE TABLE EDUCATION0(STAFF_ID INT PRIMARY KEY, FIRST_NAME VARCHAR(20));
CREATE TABLE TRAINING0(STAFF_ID INT CHECK(STAFF_ID IS NOT NULL), FIRST_NAME VARCHAR(20));
ALTER TABLE TRAINING0 ADD CONSTRAINT TRAINING0CON FOREIGN KEY(STAFF_ID) REFERENCES EDUCATION0(STAFF_ID) ON DELETE SET NULL;
INSERT INTO EDUCATION0 VALUES(1, 'ALICE');
INSERT INTO EDUCATION0 VALUES(2, 'BROWN');
INSERT INTO TRAINING0 VALUES(1, 'ALICE');
INSERT INTO TRAINING0 VALUES(1, 'ALICE');
DELETE EDUCATION0,TRAINING0 FROM EDUCATION0 JOIN TRAINING0 ON EDUCATION0.STAFF_ID = TRAINING0.STAFF_ID;
ALTER TABLE TRAINING0 DROP CONSTRAINT TRAINING0CON;
TRUNCATE TABLE TRAINING0;
TRUNCATE TABLE EDUCATION0;
ALTER TABLE TRAINING0 ADD CONSTRAINT TRAINING0CON FOREIGN KEY(STAFF_ID) REFERENCES EDUCATION0(STAFF_ID) ON DELETE CASCADE;
INSERT INTO EDUCATION0 VALUES(1, 'ALICE');
INSERT INTO EDUCATION0 VALUES(2, 'BROWN');
INSERT INTO TRAINING0 VALUES(1, 'ALICE');
INSERT INTO TRAINING0 VALUES(1, 'ALICE');
DELETE EDUCATION0,TRAINING0 FROM EDUCATION0 JOIN TRAINING0 ON EDUCATION0.STAFF_ID = TRAINING0.STAFF_ID;
SELECT * FROM EDUCATION0;
SELECT * FROM TRAINING0;
DROP TABLE IF EXISTS TRAINING0;
DROP TABLE IF EXISTS EDUCATION0;


DROP TABLE IF EXISTS SELF_REF;
CREATE TABLE SELF_REF(ID INT PRIMARY KEY, C1 INT);
INSERT INTO SELF_REF VALUES(1, NULL);
INSERT INTO SELF_REF VALUES(2, 1);
INSERT INTO SELF_REF VALUES(3, 2);
UPDATE SELF_REF SET C1=3 WHERE ID=1;
COMMIT;
ALTER TABLE SELF_REF ADD CONSTRAINT FK_SELF_REF FOREIGN KEY (C1) REFERENCES SELF_REF(ID) ON DELETE CASCADE;
DELETE FROM SELF_REF;
SELECT * FROM SELF_REF;
ROLLBACK;
DELETE FROM SELF_REF WHERE ID=2;
SELECT * FROM SELF_REF;
ROLLBACK;
CREATE INDEX IX_SELF_REF_C1 ON SELF_REF(C1);
DELETE FROM SELF_REF;
SELECT * FROM SELF_REF;
ROLLBACK;
DELETE FROM SELF_REF WHERE ID=2;
SELECT * FROM SELF_REF;
COMMIT;

DROP TABLE SELF_REF PURGE;

DROP TABLE IF EXISTS storage_interval_tbl;
DROP TABLE IF EXISTS storage_interval_tbl_1;
CREATE TABLE storage_interval_tbl(C_ID INT,C_D_ID bigint NOT NULL,C_W_ID tinyint unsigned NOT NULL)PARTITION BY RANGE(C_ID)INTERVAL(50000)(PARTITION PART_1 VALUES LESS THAN (201),PARTITION PART_2 VALUES LESS THAN (401));
CREATE TABLE storage_interval_tbl_1(C_ID INT,C_D_ID bigint NOT NULL,C_W_ID tinyint unsigned NOT NULL)PARTITION BY RANGE(C_ID)INTERVAL(50000)(PARTITION PART_1 VALUES LESS THAN (201),PARTITION PART_2 VALUES LESS THAN (401));
create index storage_interval_tbl_idx on storage_interval_tbl(c_id) local;
alter table storage_interval_tbl add constraint storage_interval_tbl_002_cons primary key(c_id);
alter table storage_interval_tbl_1 add constraint storage_interval_tbl_002_cons_1 primary key(c_id);
alter table storage_interval_tbl add constraint for_cons foreign key(c_id) references storage_interval_tbl_1(c_id) on delete cascade;
insert into storage_interval_tbl_1 values(2001,1,1);
delete from storage_interval_tbl_1;commit;
DROP TABLE IF EXISTS storage_interval_tbl;
DROP TABLE IF EXISTS storage_interval_tbl_1;