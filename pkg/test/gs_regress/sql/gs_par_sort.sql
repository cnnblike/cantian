drop table if exists aaa;
create table aaa( a int, b int, c int);
drop procedure if exists insert_into_aaa;

CREATE or replace procedure insert_into_aaa(startall int, endall int)  as
i INT;
BEGIN
  FOR i IN startall..endall LOOP
  insert into aaa values(i,i+1,endall-i);  
  commit;
  END LOOP;
END;
/

CREATE or replace procedure insert_into_aaa1(startall int, endall int)  as
i INT;
BEGIN
  FOR i IN startall..endall LOOP
  insert into aaa values(startall,startall-1,endall-i);  
  commit;
  END LOOP;
END;
/

call insert_into_aaa(2000,3000);
call insert_into_aaa1(1,1000);

select /*+ parallel(8) */ * from aaa order by a,b,c;

select /*+ parallel(8) */ * from aaa order by c,b,a;

select /*+ parallel(8) */ * from aaa order by b, c desc;

select /*+ parallel(8) */ * from aaa order by c, a desc;

drop table if exists test;
create table test (id int, c_int int) partition by list(id) (
 partition p1 values (1,2,3),
 partition p2 values (4,5),
 partition p3 values (7,8,9));
insert into test values (1,1);
commit;
create index idx_par_test on test(id) local;
select /*+parallel(2)*/ id from test where id < 6;
drop table if exists test;

--DTS2019042608049
drop table if exists bmsql_order_line;
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

insert into bmsql_order_line values(15001,1,10,1,1,'2018-10-1', 10.2,1,1,'abc');
insert into bmsql_order_line values(15002,1,10,1,1,'2018-10-1', 10.2,1,1,'abc');
insert into bmsql_order_line values(15003,1,10,1,1,'2018-10-1', 10.2,1,1,'abc');
insert into bmsql_order_line values(15004,1,10,1,1,'2018-10-1', 10.2,1,1,'abc');
insert into bmsql_order_line values(15005,1,10,1,1,'2018-10-1', 10.2,1,1,'abc');
insert into bmsql_order_line values(15006,1,10,1,1,'2018-10-1', 10.2,1,1,'abc');
insert into bmsql_order_line values(15007,1,10,1,1,'2018-10-1', 10.2,1,1,'abc');
insert into bmsql_order_line values(15008,1,10,1,1,'2018-10-1', 10.2,1,1,'abc');


select /*+ parallel(16)*/ ROW_NUMBER() over(order by OL_W_ID)as b from BMSQL_ORDER_LINE a 
 where  OL_W_ID between 
150001 and 1500010 or OL_O_ID =10  order by  OL_W_ID ;

drop table if exists bmsql_history;
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

insert into BMSQL_HISTORY values(150001, 150001, 1,1,1,1,'2018-10-1', 10.2, 'abc');
insert into BMSQL_HISTORY values(150001, 150001, 1,1,1,1,'2018-10-1', 10.2, 'abc');
insert into BMSQL_HISTORY values(150001, 150001, 1,1,1,1,'2018-10-1', 10.2, 'abc');
insert into BMSQL_HISTORY values(150001, 150001, 1,1,1,1,'2018-10-1', 10.2, 'abc');
insert into BMSQL_HISTORY values(150001, 150001, 1,1,1,1,'2018-10-1', 10.2, 'abc');
insert into BMSQL_HISTORY values(150001, 150001, 1,1,1,1,'2018-10-1', 10.2, 'abc');


select /*+parallel(16)*/ t.* from BMSQL_HISTORY t where not exists (select 1 from BMSQL_HISTORY s where s.H_C_ID = t.HIST_ID) start with HIST_ID = '150001' connect by H_C_ID = prior HIST_ID
order by H_C_ID;

select /*+parallel(16)*/ distinct * from BMSQL_HISTORY order by hist_id;

select  /*+parallel(6)*/ length (H_DATA) as changdu from (select H_DATA,HIST_ID  from BMSQL_HISTORY where H_DATE = '2018-12-17 12:48:33.216000' or H_DATA  in ('hKKiF2iCzJVubzbKj','Zi4KDEKo4iaSp')) order by H_DATA;

select /*+ parallel(8) */ * from aaa order by a,b,c limit 10;

create index bmsql_history_idx_005 on bmsql_history (h_data);

declare
    i integer;
begin
    for i in 1 .. 3000 loop
        execute immediate 'insert into bmsql_history values('||i||',1848,9,72,9,72,''2018-10-1'',10.2,''shanghai'')';
		execute immediate 'insert into bmsql_history values('||i||',1848,9,72,9,72,''2018-10-1'',10.2,''nanjing'')';
		execute immediate 'insert into bmsql_history values('||i||',1848,9,72,9,72,''2018-10-1'',10.2,''guangdong'')';
    end loop;
    commit;
end;
/

select /*+parallel(10)*/ count(*) from BMSQL_HISTORY where H_DATA='shanghai';
select /*+parallel(5)*/ count(*) from BMSQL_HISTORY where H_DATA='shanghai';
select /*+parallel(1)*/ count(*) from BMSQL_HISTORY where H_DATA='shanghai';
