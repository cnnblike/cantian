drop table if exists rid_heap_tbl;

create table rid_heap_tbl(id int,c_int int not null,c_vchar1 varchar(100) not null,c_vchar2 varchar(100) not null,c_clob clob not null,c_blob blob not null,c_date date);

insert into rid_heap_tbl select rownum, rownum, 'abc123','defadsfa', lpad('123abc',50,'abc'), lpad('11100011',50,'1100'), to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss') from dual connect by rownum <= 10;
create view rid_tmp_view1 as select * from rid_heap_tbl where id>3;
create view rid_tmp_view2 as select * from rid_tmp_view1;
create view rid_tmp_view3 as select * from rid_tmp_view2;
create view rid_tmp_view4 as select * from rid_tmp_view3;
create view rid_tmp_view5 as select * from rid_tmp_view4;

drop table if exists rid_heap_TBL2;
create table rid_heap_TBL2(id int, c_int int not null, c_vchar1 varchar(100) not null);
insert into rid_heap_TBL2 select rownum, sin(rownum) * 100, 'WaHaHa' from dual connect by rownum <= 10;

create view rid_join_view1 as select T.id TID, R.id RID from rid_heap_tbl T join rid_heap_TBL2 R on T.id < R.id;

select rowid from rid_join_view1;
select T.rowid from rid_join_view1;

drop table if exists rid_test_tbl;
create global temporary table rid_test_tbl(id int, rid varchar(100), rid2 varchar(100));

insert into rid_test_tbl select id, rowid, NULL from rid_heap_tbl;
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select id, rowid, null from rid_tmp_view1;
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select id, rowid, null from rid_tmp_view2;
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;
insert into rid_test_tbl select id, rowid, null from rid_tmp_view3;
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select id, rowid, null from rid_tmp_view4;
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select id, rowid, rowid from rid_tmp_view4 group by rowid, id;
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select id, rowid, null from rid_tmp_view5;
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select id, rowid, rowid from rid_tmp_view5 group by rowid, id;
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select id, rowid, NULL from (select * from (select sysdate + 1, id from rid_heap_tbl));
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select id, rowid, NULL from (select *, rowid from (select sysdate + 1, id from rid_heap_tbl));
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select id, rowid, NULL from (select *, rowid from (select sysdate + 1, id from rid_tmp_view5));
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select rownum, rowid, id from (select *, rowid from (select sysdate + 1, id from rid_heap_tbl));
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select rownum, rowid, id from (select *, rowid from (select sysdate + 1, id from rid_tmp_view3));
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select T.id, T.rowid, R.rowid from rid_heap_tbl T join rid_heap_tbl R on T.id + R.id = 10;
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select T.id, T.rowid, R.rowid from rid_heap_tbl T join rid_tmp_view3 R on T.id + R.id = 10;
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select T.id, T.rowid, R.rowid from rid_tmp_view2 T join rid_heap_tbl R on T.id + R.id = 10;
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select T.id, T.rowid, R.rowid from rid_tmp_view2 T join rid_tmp_view5 R on T.id + R.id = 10 where T.id = 4;
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select * from (select T.id, T.rowid, R.rowid from rid_tmp_view2 T join rid_tmp_view5 R on T.id + R.id = 10 where T.id = 4);
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select T.id, NULL, R.rowid from rid_tmp_view2 T join rid_tmp_view5 R on T.id + R.id = 10 where T.id <8 order by T.rowid;
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select t1.id, t1.rowid, t2.rowid from rid_tmp_view2 t1 inner join rid_tmp_view5 t2 on t1.rowid=t2.rowid;
select min(length(rid)), max(length(rid)), min(length(rid2)), max(length(rid2)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select NULL, t1.rowid, t2.rowid from rid_tmp_view2 t1 inner join rid_tmp_view5 t2 on t1.rowid=t2.rowid;
select min(length(rid)), max(length(rid)), min(length(rid2)), max(length(rid2)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select t1.id, t1.rowid, t2.rowid from rid_heap_tbl t1 inner join rid_tmp_view5 t2 on t1.rowid=t2.rowid;
select min(length(rid)), max(length(rid)), min(length(rid2)), max(length(rid2)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select t1.id, t1.rowid, t2.rowid from rid_tmp_view5 t1 inner join rid_heap_tbl t2 on t1.rowid=t2.rowid;
select min(length(rid)), max(length(rid)), min(length(rid2)), max(length(rid2)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select t1.id, t1.rowid, t2.rowid from rid_tmp_view5 t1 inner join rid_tmp_view5 t2 on t1.rowid=t2.rowid;
select min(length(rid)), max(length(rid)), min(length(rid2)), max(length(rid2)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select t1.id, t1.rowid, t2.rowid from rid_tmp_view1 t1 inner join rid_heap_tbl t2 on t1.rowid=t2.rowid;
select min(length(rid)), max(length(rid)), min(length(rid2)), max(length(rid2)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select 1, NULL, NULL from rid_tmp_view1 t1 inner join rid_heap_tbl t2 on t1.rowid=t2.rowid;
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select t2.id, replace(t1.c_vchar1,'abc',t1.rowid || t2.rowid), t1.c_vchar2 from rid_heap_tbl t1 right join rid_tmp_view5 t2 on t1.c_int<=t2.c_int order by 1,2;
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

create view rid_view_003X as select c_int "ROWID", id, c_vchar1  from rid_tmp_view2 where rowid in (select rowid from rid_tmp_view5);

insert into rid_test_tbl select rownum, rowid, c_vchar1 from rid_view_003X;
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select rownum, "ROWID", c_vchar1 from rid_view_003X;
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select rownum, "rowid", c_vchar1 from rid_view_003X;
select min(length(rid)), max(length(rid)), sum(id) from rid_test_tbl;
commit;

insert into rid_test_tbl select 0, sum(rowid), 0 from rid_heap_tbl;
select 'YES' from rid_test_tbl where rid > 0;
commit;

insert into rid_test_tbl select 1, sum(rowid), 1 from rid_tmp_view1;
select 'YES' from rid_test_tbl where rid > 0;
commit;

insert into rid_test_tbl select 2, sum(rowid), 2 from rid_tmp_view2;
select 'YES' from rid_test_tbl where rid > 0;
commit;

insert into rid_test_tbl select 3, sum(rowid), 3 from rid_tmp_view3;
select 'YES' from rid_test_tbl where rid > 0;
commit;

insert into rid_test_tbl select 4, sum(rowid), 4 from rid_tmp_view4;
select 'YES' from rid_test_tbl where rid > 0;
commit;

insert into rid_test_tbl select 5, sum(rowid), 5 from rid_tmp_view5;
select 'YES' from rid_test_tbl where rid > 0;
commit;

insert into rid_test_tbl select 6, sum(rowid), 6 from rid_view_003X;
select 'YES' from rid_test_tbl where rid > 0;
commit;

insert into rid_test_tbl select 5, max(rowid), 5 from rid_tmp_view5;
select 'YES' from rid_test_tbl where rid > 0;
commit;

insert into rid_test_tbl select 6, max(rowid), 6 from rid_view_003X;
select 'YES' from rid_test_tbl where rid > 0;
commit;

create view rid_view_004X as select t1.c_int "ROWID",t1.id,t1.c_vchar1  from  rid_tmp_view4 t1 join rid_heap_tbl t2 on t1.c_int=t2.c_int;
select rowid from rid_view_004X;

CREATE OR REPLACE PROCEDURE mulit_nested_query_for_rowid(lvl in int) AS
  v_sql       varchar(32000);
  rid_max_len number;
  rid_min_len number;
BEGIN
    v_sql := 'select sysdate, * from rid_tmp_view5';
    for i in 1..lvl loop
        begin
            v_sql := 'select sysdate+'|| i || ',123,''WHF''from ('|| v_sql ||')';
            -- dbe_output.print_line(v_sql);
        end;
    end loop;
    v_sql := 'insert into rid_test_tbl select rownum, rowid, NULL from (' || v_sql || ')';
    dbe_output.print_line(v_sql);
    execute immediate v_sql;
    select min(length(rid)), max(length(rid)) into rid_min_len, rid_max_len from rid_test_tbl;
    dbe_output.print_line('max rowid length = ' || rid_max_len);
    dbe_output.print_line('min rowid length = ' || rid_min_len);
    commit;
END;
/

set serveroutput on;
call mulit_nested_query_for_rowid(10);
call mulit_nested_query_for_rowid(30);
call mulit_nested_query_for_rowid(50);

select id, rowid, NULL from (select *, rowid, rownum from (select sysdate + 1, id from rid_tmp_view5));

select id, rowid, NULL from (select *, rowid, rownum "rowid" from (select sysdate + 1, id from rid_tmp_view5));

select rowid from dba_segments;
select rowid from all_tables;
select avg(length(rowid)) from v$parameter;
select avg(length(rowid)) from (select * from v$parameter);

select "rowid" from (select * from dual);
select avg(length("ROWID")) from (select * from rid_heap_tbl);

select avg(length("ROWID")) from (select * from rid_tmp_view4);

-- DTS2019010305694
drop table if exists t_join_base_001;
create table t_join_base_001(id int,c_int int not null,c_vchar1 varchar(100) not null,c_vchar2 varchar(100) not null,c_clob clob not null,c_blob blob not null,c_date date); 

insert into t_join_base_001 values(1,1000,'abc123','defadsfa',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));

CREATE or replace procedure proc_insert(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
  sqlst := 'insert into ' || tname ||' select id+'||i||',c_int+'||i||',c_vchar1||'||i||',c_vchar2||'||i||',c_clob||'||i||',c_blob'||',c_date from '||tname|| ' where id=1';
        execute immediate sqlst;
  END LOOP;
END;
/
exec proc_insert('t_join_base_001',1,9);
commit;

create view ChangHong_view_001 as select * from t_join_base_001 t1 where rowid in(select rowid from t_join_base_001 t2 where  t2.c_int>=t1.c_int);

insert into rid_test_tbl select 0, sum(rowid), 0 from ChangHong_view_001;
select 'YES' from rid_test_tbl where rid > 0;
commit;

insert into rid_test_tbl select 0, sum(rowid), rowid from ChangHong_view_001 group by rowid;
select avg(length(rid2)) from rid_test_tbl where rid > 0;
commit;

create view ChangHong_view_002 as select * from  ChangHong_view_001 where rowid in(select rowid from t_join_base_001);

insert into rid_test_tbl select 0, sum(rowid), 0 from ChangHong_view_002;
select count(*), 'YES' from rid_test_tbl where rid > 0;
commit;

insert into rid_test_tbl select 0, sum(rowid), rowid from ChangHong_view_002 group by rowid;
select count(*), avg(length(rid2)) from rid_test_tbl where rid > 0;
commit;

drop table if exists t_join_base_001;
create table t_join_base_001(id int,c_int int not null,c_vchar1 varchar(100) not null,c_vchar2 varchar(100) not null,c_clob clob not null,c_blob blob not null,c_date date) crmode page; 
insert into t_join_base_001 values(1,1000,'abc123','defadsfa',lpad('123abc',50,'abc'),lpad('11100011',50,'1100'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'));
CREATE or replace procedure proc_insert(tname varchar,startall int,endall int) as
sqlst varchar(500);
BEGIN
  FOR i IN startall..endall LOOP
  sqlst := 'insert into ' || tname ||' select id+'||i||',c_int+'||i||',c_vchar1||'||i||',c_vchar2||'||i||',c_clob||'||i||',c_blob'||',c_date from '||tname|| ' where id=1';
        execute immediate sqlst;
  END LOOP;
END;
/
exec proc_insert('t_join_base_001',1,9);
commit;
drop table if exists t_join_base_002;
create table t_join_base_002 crmode page as select rowid as c_number,id,c_int,c_vchar1,c_date from t_join_base_001;