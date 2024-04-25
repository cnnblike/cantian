drop table if exists t1;
drop table if exists t2;
  create table t1(id int,name varchar2(10));
  alter table t1 add constraint con_uniq_001 unique(id);
  insert into t1 values(1,'aa');
  insert into t1 values(2,'bb');
  insert into t1 values(3,'cc');
   insert into t1 values(4,'dd');
    insert into t1 values(5,'ee');
  insert into t1 values(6,'ff');

   create table t2(id int,name varchar2(10));
   
     insert into t2 values(1,'aaa');
  insert into t2 values(4,'ddd');
  insert into t2 values(5,'bbb');
  insert into t2 values(6,'ccc');
  insert into t2 values(7,'fff');
  commit;
merge into  t2 using t1 on(t2.id=t1.id)
when matched then update set name=t2.id||t2.name
when not matched then insert (id,name) values(t1.id,t1.name) ,((t1.id+t1.id)*10,t1.name||'a'),((t1.id+t1.id)*100,t1.name||'b'),((t1.id+t1.id)*1000,t1.name||'c');
select * from t2 order by id,name;
