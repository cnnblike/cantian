--TEST SYNONYM
alter database set time_zone='+08:00';
alter database set time_zone='+00:00';
drop table if exists t_hint;

create table t_hint (fint1 int, fint2 int, fstr1 varchar(128), fstr2 varchar(128));
create index t_hint_idx1 on t_hint(fint1);
create index t_hint_idx2 on t_hint(fint2);
create index t_hint_idx3 on t_hint(fstr1);
create index t_hint_idx4 on t_hint(fstr2);

insert into t_hint values(1, 2, 'a', 'aa');
insert into t_hint values(2, 4, 'b', 'bb');
insert into t_hint values(3, 6, 'c', 'cc');
insert into t_hint values(4, 8, 'd', 'dd');
insert into t_hint values(5, 10, 'e', 'ee');


explain select fint1, fint2, fstr1, fstr2 from t_hint where fint1=1;
explain select fint1, fint2, fstr1, fstr2 from t_hint where fint2=1;
explain select fint1, fint2, fstr1, fstr2 from t_hint where fstr1='a';
explain select fint1, fint2, fstr1, fstr2 from t_hint where fstr2='a';

explain select /*+ index(t t_hint_idx2) */ fint1, fint2, fstr1, fstr2 from t_hint t where fint1 = 1;
explain select /*+ index_ffs(t t_hint_idx2) */ fint1, fint2, fstr1, fstr2 from t_hint t where fint1 = 1;
explain select /*+ index(t_hint t_hint_idx3) this is a hint */fint1, fint2, fstr1, fstr2 from t_hint t where fint2=1;
explain select /*+ index_ffs(t_hint t_hint_idx3) this is a hint */fint1, fint2, fstr1, fstr2 from t_hint t where fint2=1;
explain select /*+ index(t_hint t_hint_idx3) this is a hint */fint1, fint2, fstr1, fstr2 from t_hint where fint2=1;
explain select /*+ index_ffs(t_hint t_hint_idx3) this is a hint */fint1, fint2, fstr1, fstr2 from t_hint where fint2=1;
explain select /*+ index(t t_hint_idx4) this is a hint */fint1, fint2, fstr1, fstr2 from t_hint t where fstr1='a';
explain select /*+ index_ffs(t t_hint_idx4) this is a hint */fint1, fint2, fstr1, fstr2 from t_hint t where fstr1='a';
explain select /*+ index(t t_hint_idx1) this is a hint */fint1, fint2, fstr1, fstr2 from t_hint t where fstr2='a';
explain select /*+ index_ffs(t t_hint_idx1) this is a hint */fint1, fint2, fstr1, fstr2 from t_hint t where fstr2='a';

select /*+ index(t t_hint_idx2) this is a hint */ fint1, fint2, fstr1, fstr2 from t_hint t where fint1 = 1;
select /*+ index_ffs(t t_hint_idx2) this is a hint */ fint1, fint2, fstr1, fstr2 from t_hint t where fint1 = 1;
select /*+ index(t t_hint_idx3) this is a hint */fint1, fint2, fstr1, fstr2 from t_hint t where fint2=1;
select /*+ index_ffs(t t_hint_idx3) this is a hint */fint1, fint2, fstr1, fstr2 from t_hint t where fint2=1;
select /*+ index(t t_hint_idx4) this is a hint */fint1, fint2, fstr1, fstr2 from t_hint t where fstr1='a';
select /*+ index_ffs(t t_hint_idx4) this is a hint */fint1, fint2, fstr1, fstr2 from t_hint t where fstr1='a';
select /*+ index(t t_hint_idx1) this is a hint */fint1, fint2, fstr1, fstr2 from t_hint t where fstr2='a';
select /*+ index_ffs(t t_hint_idx1) this is a hint */fint1, fint2, fstr1, fstr2 from t_hint t where fstr2='a';

--------------------------------------------------------------------------------
--------------------------------   HINTS   -------------------------------------
-------------------------------------------------------------------------------- 
BEGIN
    FOR i IN 1..10 LOOP
        -- drop if exists
        BEGIN
            EXECUTE IMMEDIATE 'drop table t' || i;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
        EXECUTE IMMEDIATE 'create table t' || i || ' (c1 int, c2 int, c3 int, c4 int)';
        EXECUTE IMMEDIATE 'create unique index idx_t' || i || '_c1         on t' || i || '(c1)';
        EXECUTE IMMEDIATE 'create unique index idx_t' || i || '_c1_c2      on t' || i || '(c1, c2)';
        EXECUTE IMMEDIATE 'create unique index idx_t' || i || '_c1_c2_c3   on t' || i || '(c1, c2, c3)';
        EXECUTE IMMEDIATE 'insert into t' || i || ' values (1, 2, 3, 0)';
        EXECUTE IMMEDIATE 'insert into t' || i || ' values (2, 0, 1, 3)';
        EXECUTE IMMEDIATE 'insert into t' || i || ' values (0, 1, 2, 3)'; 
    END LOOP;
END;
/


-----------------------------   INDEX HINT   -----------------------------------
----- 1. 功能用例 -----
explain select c1 from t1 where c1 >= 0;
explain select /*+ index( t1 idx_t1_c1_c2_c3 ) */ c1 from t1 where c1 >= 0;
select /*+ index( t1 idx_t1_c1_c2_c3 ) */ c1 from t1 where c1 >= 0;                 
explain select /*+ index( t1 idx_t1_c1_c2_c3 idx_t1_c1_c2 ) */ c1 from t1 where c1 >= 0;
explain select c1,c2 from t1;
explain select /*+ index( t1 idx_t1_c1_c2_c3 idx_t1_c1_c2 ) */ c1, c2 from t1; 

-- 不具备走索引条件，index hint无效，应考虑使用index_ffs
explain select /*+ index( t1 idx_t1_c1_c2_c3 ) */ c1, c2 from t1;
explain select /*+ index_ffs( t1 idx_t1_c1_c2_c3 ) */ c1, c2 from t1; 

explain select c1, c2 from t1 order by c1, c2;
explain select /*+ index( t1 idx_t1_c1_c2_c3 ) */ c1, c2 from t1 order by c1, c2;  
explain select c1, c2 from t1 group by c1, c2;  
explain select /*+ index( t1 idx_t1_c1_c2_c3 ) */c1, c2 from t1 group by c1, c2; 
explain select /*+ index( t1 idx_t1_c1 ) */c1, c2 from t1 group by c1, c2;  
explain select /*+ index_ffs( t1 idx_t1_c1 ) */c1, c2 from t1 group by c1, c2;  
explain select /*+ index_ffs( t1 idx_t1_c1_c2_c3 ) */c1, c2 from t1;
explain select /*+ no_index_ffs( t1 idx_t1_c1_c2_c3 ) */c1, c2 from t1;  
explain select /*+ index_desc( t1 idx_t1_c1_c2_c3 ) */c1, c2 from t1;
explain select c1, c2 from t1 where c1 >= 0 and c2 >= 0;  
select c1, c2 from t1 where c1 >= 0 and c2 >= 0;          
explain select /*+ index_desc( t1 idx_t1_c1_c2_c3 ) */c1, c2 from t1 where c1 >= 0 and c2 >= 0;
select /*+ index_desc( t1 idx_t1_c1_c2_c3 ) */c1, c2 from t1 where c1 >= 0 and c2 >= 0;       
explain select c1, c2 from t1 where c1 >= 0 and c2 >= 0 order by c1 asc, c2 asc;
select c1, c2 from t1 where c1 >= 0 and c2 >= 0 order by c1 asc, c2 asc;              
explain select /*+ index_desc( t1 idx_t1_c1_c2_c3 ) */c1, c2 from t1 where c1 >= 0 and c2 >= 0 order by c1 asc, c2 asc;              
explain select /*+ index_desc( t1 idx_t1_c1_c2_c3 ) */c1, c2 from t1 where c1 >= 0 and c2 >= 0 group by c1, c2;
select /*+ index_desc( t1 idx_t1_c1_c2_c3 ) */c1, c2 from t1 where c1 >= 0 and c2 >= 0 group by c1, c2; 
explain select /*+ index_asc( t1 idx_t1_c1_c2_c3 ) */c1, c2 from t1 where c1 >= 0 and c2 >= 0;
select /*+ index_asc( t1 idx_t1_c1_c2_c3 ) */c1, c2 from t1 where c1 >= 0 and c2 >= 0;
explain select c1, c2 from t1 where c1 >= 1 and c2 >= 0 order by c1 desc, c2 desc;  
select c1, c2 from t1 where c1 >= 1 and c2 >= 0 order by c1 desc, c2 desc;
explain select /*+ index_asc( t1 idx_t1_c1_c2_c3 ) */c1, c2 from t1 where c1 >= 1 and c2 >= 0 order by c1 desc, c2 desc;
select /*+ index_asc( t1 idx_t1_c1_c2_c3 ) */c1, c2 from t1 where c1 >= 1 and c2 >= 0 order by c1 desc, c2 desc;  
explain select c1, c2 from t1 where c1 >= 1;
explain select /*+ no_index( t1 idx_t1_c1 ) */ c1, c2 from t1 where c1 >= 1; 
explain select /*+ no_index( t1 idx_t1_c1 idx_t1_c1_c2 ) */ c1, c2 from t1 where c1 >= 1;
explain select /*+ no_index( t1 idx_t1_c1 idx_t1_c1_c2 idx_t1_c1_c2_c3 ) */ c1, c2 from t1 where c1 >= 1; 
select /*+ no_index( t1 idx_t1_c1 idx_t1_c1_c2 idx_t1_c1_c2_c3 ) */ c1, c2 from t1 where c1 >= 1; 

----- 2. 格式用例 -----   
explain select /*+ index( t1 idx_t1_c1_c2 ) full( t1 ) */ c1, c2 from t1 where c1 >= 1; 
explain select /*+ index( t1 idx_t1_c1_c2 ) full( t1 ) index( t1 idx_t1_c1_c2_c3 ) */ c1, c2 from t1 where c1 >= 1;  
explain select /*+ index( t1 idx_t1_c1 ) index_desc( t1 idx_t1_c1_c2 ) index_ffs( t1 idx_t1_c1_c2_c3 ) */ c1, c2 from t1 where c1 >= 1;  
select /*+ index( t1 idx_t1_c1 ) index_desc( t1 idx_t1_c1_c2 ) index_ffs( t1 idx_t1_c1_c2_c3 ) */ c1, c2 from t1 where c1 >= 1;                
explain select /*+ index( t1 idx_t1_c1_c2 idx_xxx idx_xxx ) */ c1, c2 from t1 where c1 >= 1;        
explain select /*+ index( t1 ) */ c1, c2 from t1 where c1 >= 1; 
explain select /*+ index(t1 idx_t1_c1) index(idx_t1_c1_c2)*/ c1, c2 from t1 where c1 >= 1;

-----------------------------   JOIN ORDER HINT   -----------------------------------
explain select t1.c1, t2.c1, t3.c1, v.c1 from t1, t2, t3, (select t4.c1, t5.c1 c2 from t4, t5 where t4.c1 = t5.c1) v where t1.c1 = t2.c1 and t1.c1 = t3.c1 and t2.c1 = t3.c1 and t1.c1 = v.c1 and t2.c1 = v.c1 and t3.c1 = v.c1;
select t1.c1, t2.c1, t3.c1, v.c1 from t1, t2, t3, (select t4.c1, t5.c1 c2 from t4, t5 where t4.c1 = t5.c1) v where t1.c1 = t2.c1 and t1.c1 = t3.c1 and t2.c1 = t3.c1 and t1.c1 = v.c1 and t2.c1 = v.c1 and t3.c1 = v.c1;

explain select /*+ leading (t1 t2 t3 v) */ t1.c1, t2.c1, t3.c1, v.c1 from t1, t2, t3, (select /*+ leading (t5 t4)*/ t4.c1, t5.c1 c2 from t4, t5 where t4.c1 = t5.c1) v where t1.c1 = t2.c1 and t1.c1 = t3.c1 and t2.c1 = t3.c1 and t1.c1 = v.c1 and t2.c1 = v.c1 and t3.c1 = v.c1;
select /*+ leading (t1 t2 t3 v) */ t1.c1, t2.c1, t3.c1, v.c1 from t1, t2, t3, (select /*+ leading (t5 t4)*/ t4.c1, t5.c1 c2 from t4, t5 where t4.c1 = t5.c1) v where t1.c1 = t2.c1 and t1.c1 = t3.c1 and t2.c1 = t3.c1 and t1.c1 = v.c1 and t2.c1 = v.c1 and t3.c1 = v.c1;

explain select /*+ leading (t3 v t2 t1) */ t1.c1, t2.c1, t3.c1, v.c1 from t1, t2, t3, (select /*+ leading (t5 t4)*/ t4.c1, t5.c1 c2 from t4, t5 where t4.c1 = t5.c1) v where t1.c1 = t2.c1 and t1.c1 = t3.c1 and t2.c1 = t3.c1 and t1.c1 = v.c1 and t2.c1 = v.c1 and t3.c1 = v.c1;    
select /*+ leading (t3 v t2 t1) */ t1.c1, t2.c1, t3.c1, v.c1 from t1, t2, t3, (select /*+ leading (t5 t4)*/ t4.c1, t5.c1 c2 from t4, t5 where t4.c1 = t5.c1) v where t1.c1 = t2.c1 and t1.c1 = t3.c1 and t2.c1 = t3.c1 and t1.c1 = v.c1 and t2.c1 = v.c1 and t3.c1 = v.c1;

-- leading do not support in outer join
explain select /*+ leading (t2 t3 v t1) */ t1.c1, t2.c1, t3.c1, v.c1 from t1, t2 left join t3 on (t2.c1 = t3.c1 ), (select /*+ leading (t5 t4)*/ t4.c1, t5.c1 c2 from t4, t5 where t4.c1 = t5.c1) v where t1.c1 = t2.c1 and t1.c1 = t3.c1 and t1.c1 = v.c1 and t2.c1 = v.c1 and t3.c1 = v.c1;   
select /*+ leading (t2 t3 v t1) */ t1.c1, t2.c1, t3.c1, v.c1 from t1, t2 left join t3 on (t2.c1 = t3.c1 ), (select /*+ leading (t5 t4)*/ t4.c1, t5.c1 c2 from t4, t5 where t4.c1 = t5.c1) v where t1.c1 = t2.c1 and t1.c1 = t3.c1 and t1.c1 = v.c1 and t2.c1 = v.c1 and t3.c1 = v.c1;

explain select t1.c1, t2.c1, t3.c1, v.c1 from t1, t2, t3, (select t4.c1, t5.c1 c2 from t4, t5 where t4.c1 = t5.c1) v where t1.c1 = t3.c1 and t1.c1 = v.c1 and t2.c1 = v.c1 and t3.c1 = v.c1; 
explain select /*+ leading (t3 t2 v t1) */ t1.c1, t2.c1, t3.c1, v.c1 from t1, t2, t3, (select /*+ leading (t5 t4)*/ t4.c1, t5.c1 c2 from t4, t5 where t4.c1 = t5.c1) v where t1.c1 = t3.c1 and t1.c1 = v.c1 and t2.c1 = v.c1 and t3.c1 = v.c1;   
select /*+ leading (t3 t2 v t1) */ t1.c1, t2.c1, t3.c1, v.c1 from t1, t2, t3, (select /*+ leading (t5 t4)*/ t4.c1, t5.c1 c2 from t4, t5 where t4.c1 = t5.c1) v where t1.c1 = t3.c1 and t1.c1 = v.c1 and t2.c1 = v.c1 and t3.c1 = v.c1;

explain select /*+ ordered */ t1.c1, t2.c1, t3.c1, v.c1 from t1, t2, t3, (select /*+ ordered */ t4.c1, t5.c1 c2 from t4, t5 where t4.c1 = t5.c1) v where t1.c1 = t3.c1 and t1.c1 = v.c1 and t2.c1 = v.c1 and t3.c1 = v.c1;   
select /*+ ordered */ t1.c1, t2.c1, t3.c1, v.c1 from t1, t2, t3, (select /*+ ordered */ t4.c1, t5.c1 c2 from t4, t5 where t4.c1 = t5.c1) v where t1.c1 = t3.c1 and t1.c1 = v.c1 and t2.c1 = v.c1 and t3.c1 = v.c1;



-----------------------------   JOIN METHOD HINT   -----------------------------------
explain select t1.c1, t2.c1 from t1, t2 where t1.c1 = t2.c1;
select t1.c1, t2.c1 from t1, t2 where t1.c1 = t2.c1;

-- 未指定leading，优化器选择t1作为左表，hint失效
explain select /*+ use_nl (t1) */ t1.c1, t2.c1 from t1, t2 where t1.c1 = t2.c1;
explain select /*+ leading(t2 t1) use_nl (t1) */ t1.c1, t2.c1 from t1, t2 where t1.c1 = t2.c1;
select /*+ leading(t2 t1) use_nl (t1) */ t1.c1, t2.c1 from t1, t2 where t1.c1 = t2.c1;

explain select /*+ use_nl (t2) */ t1.c1, t2.c1 from t1, t2 where t1.c1 = t2.c1;
explain select /*+ use_nl (t1 t2) */ t1.c1, t2.c1 from t1, t2 where t1.c1 = t2.c1;
select /*+ use_nl (t1 t2) */ t1.c1, t2.c1 from t1, t2 where t1.c1 = t2.c1;

-- 未指定leading，优化器选择t1作为左表，hint失效
explain select /*+ use_merge (t1) */ t1.c1, t2.c1 from t1, t2 where t1.c1 = t2.c1;    
explain select /*+ leading(t2 t1) use_merge (t1) */ t1.c1, t2.c1 from t1, t2 where t1.c1 = t2.c1;    
select /*+ leading(t2 t1) use_merge (t1) */ t1.c1, t2.c1 from t1, t2 where t1.c1 = t2.c1;

explain select /*+ use_merge (t2) */ t1.c1, t2.c1 from t1, t2 where t1.c1 = t2.c1;
explain select /*+ use_merge (t1 t2) */ t1.c1, t2.c1 from t1, t2 where t1.c1 = t2.c1;
select /*+ use_merge (t1 t2) */ t1.c1, t2.c1 from t1, t2 where t1.c1 = t2.c1;

-- 默认选择HASH，实际上HINT失效
explain select /*+ use_hash (t1) */ t1.c1, t2.c1 from t1, t2 where t1.c1 = t2.c1;
explain select /*+ leading(t2 t1) use_hash (t1) */ t1.c1, t2.c1 from t1, t2 where t1.c1 = t2.c1;
select /*+ leading(t2 t1) use_hash (t1) */ t1.c1, t2.c1 from t1, t2 where t1.c1 = t2.c1;

explain select /*+ use_hash (t2) */ t1.c1, t2.c1 from t1, t2 where t1.c1 = t2.c1;
explain select /*+ use_hash (t1 t2) */ t1.c1, t2.c1 from t1, t2 where t1.c1 = t2.c1;
select /*+ use_hash (t1 t2) */ t1.c1, t2.c1 from t1, t2 where t1.c1 = t2.c1;

explain select /*+ use_hash (t2) use_nl(t2) */ t1.c1, t2.c1 from t1, t2 where t1.c1 = t2.c1;
explain select /*+ use_hash (t2) use_hash(t2, t1) */ t1.c1, t2.c1 from t1, t2 where t1.c1 = t2.c1;

-----------------------------   COMBINE HINT   -----------------------------------
explain select t1.c1, t2.c1, v.c1 from t1, t2, (select t3.c1 from t3, t4 where t3.c1 = t4.c1) v where t1.c1 = v.c1 and t2.c1 = v.c1;
select t1.c1, t2.c1, v.c1 from t1, t2, (select t3.c1 from t3, t4 where t3.c1 = t4.c1) v where t1.c1 = v.c1 and t2.c1 = v.c1;

explain select /*+ use_merge(t1 t2) */t1.c1, t2.c1, v.c1 from t1, t2, (select t3.c1 from t3, t4 where t3.c1 = t4.c1) v where t1.c1 = v.c1 and t2.c1 = v.c1;
select /*+ use_merge(t1 t2) */t1.c1, t2.c1, v.c1 from t1, t2, (select t3.c1 from t3, t4 where t3.c1 = t4.c1) v where t1.c1 = v.c1 and t2.c1 = v.c1;

explain select /*+ leading (t1 t2 t3 v) index_ffs(t1 idx_t1_c1_c2_c3) index(t2 idx_t2_c1_c2_c3) index(t3 idx_t3_c1_c2_c3) use_hash(t2) use_merge(t3) use_hash(v) */ t1.c1, t2.c1, t3.c1, v.c1 from t1, t2, t3, (select /*+ leading (t5 t4) index_ffs(t5 idx_t5_c1_c2_c3) full(t4 idx_t5_c1_c2_c3) use_merge(t4 t5) */ t4.c1, t5.c1 c2 from t4, t5 where t4.c1 = t5.c1) v where t1.c1 = t2.c1 and t1.c1 = t3.c1 and t2.c1 = t3.c1 and t1.c1 = v.c1 and t2.c1 = v.c1 and t3.c1 = v.c1;  
select /*+ leading (t1 t2 t3 v) index_ffs(t1 idx_t1_c1_c2_c3) index(t2 idx_t2_c1_c2_c3) index(t3 idx_t3_c1_c2_c3) use_hash(t2) use_merge(t3) use_hash(v) */ t1.c1, t2.c1, t3.c1, v.c1 from t1, t2, t3, (select /*+ leading (t5 t4) index_ffs(t5 idx_t5_c1_c2_c3) full(t4 idx_t5_c1_c2_c3) use_merge(t4 t5) */ t4.c1, t5.c1 c2 from t4, t5 where t4.c1 = t5.c1) v where t1.c1 = t2.c1 and t1.c1 = t3.c1 and t2.c1 = t3.c1 and t1.c1 = v.c1 and t2.c1 = v.c1 and t3.c1 = v.c1;

explain select /*+ leading (t1 t2 t3 v) index_ffs(t1 idx_t1_c1_c2_c3) index(t2 idx_t2_c1_c2_c3) index(t3 idx_t3_c1_c2_c3) use_hash(t2) use_merge(t3) use_hash(v) */ t1.c1, t2.c1, t3.c1, v.c1 from t1, t2, t3, (select /*+ leading (t5 t4) index_ffs(t5 idx_t5_c1_c2_c3) full(t4 idx_t5_c1_c2_c3) use_merge(t4 t5) */ t4.c1, t5.c1 c2 from t4, t5 where t4.c1 = t5.c1) v where t1.c1 = t2.c1 and t1.c1 = t3.c1 and t2.c1 = t3.c1 and t1.c1 = v.c1 and t2.c1 = v.c1 and t3.c1 = v.c1;
select /*+ leading (t1 t2 t3 v) index_ffs(t1 idx_t1_c1_c2_c3) index(t2 idx_t2_c1_c2_c3) index(t3 idx_t3_c1_c2_c3) use_hash(t2) use_merge(t3) use_hash(v) */ t1.c1, t2.c1, t3.c1, v.c1 from t1, t2, t3, (select /*+ leading (t5 t4) index_ffs(t5 idx_t5_c1_c2_c3) full(t4 idx_t5_c1_c2_c3) use_merge(t4 t5) */ t4.c1, t5.c1 c2 from t4, t5 where t4.c1 = t5.c1) v where t1.c1 = t2.c1 and t1.c1 = t3.c1 and t2.c1 = t3.c1 and t1.c1 = v.c1 and t2.c1 = v.c1 and t3.c1 = v.c1;

explain select /*+ leading (t1 t2 t3 v) index_ffs(t1 idx_t1_c1_c2_c3) index(t2 idx_t2_c1_c2_c3) index(t3 idx_t3_c1_c2_c3) use_merge(t2) use_merge(t3) use_merge(v) */ t1.c1, t2.c1, t3.c1, v.c1 from t1, t2, t3, (select /*+ leading (t5 t4) index_ffs(t5 idx_t5_c1_c2_c3) full(t4 idx_t5_c1_c2_c3) use_merge(t4 t5) */ t4.c1, t5.c1 c2 from t4, t5 where t4.c1 = t5.c1) v where t1.c1 = t2.c1 and t1.c1 = t3.c1 and t2.c1 = t3.c1 and t1.c1 = v.c1 and t2.c1 = v.c1 and t3.c1 = v.c1;
select /*+ leading (t1 t2 t3 v) index_ffs(t1 idx_t1_c1_c2_c3) index(t2 idx_t2_c1_c2_c3) index(t3 idx_t3_c1_c2_c3) use_merge(t2) use_merge(t3) use_merge(v) */ t1.c1, t2.c1, t3.c1, v.c1 from t1, t2, t3, (select /*+ leading (t5 t4) index_ffs(t5 idx_t5_c1_c2_c3) full(t4 idx_t5_c1_c2_c3) use_merge(t4 t5) */ t4.c1, t5.c1 c2 from t4, t5 where t4.c1 = t5.c1) v where t1.c1 = t2.c1 and t1.c1 = t3.c1 and t2.c1 = t3.c1 and t1.c1 = v.c1 and t2.c1 = v.c1 and t3.c1 = v.c1;

explain select /*+ leading (t1 t2 t3 v) index_ffs(t1 idx_t1_c1_c2_c3) index(t2 idx_t2_c1_c2_c3) index(t3 idx_t3_c1_c2_c3) use_merge(t2) use_merge(t3) use_merge(v) */ t1.c1, t2.c1, t3.c1, v.c1 from t1, t2, t3, (select /*+ leading (t5 t4) index_ffs(t5 idx_t5_c1_c2_c3) full(t4 idx_t5_c1_c2_c3) use_merge(t4 t5) */ t4.c1, t5.c1 c2 from t4, t5 where t4.c1 = t5.c1) v where t1.c1 = t2.c1 and t1.c1 = t3.c1 and t2.c1 = t3.c1 and t1.c1 = v.c1 and t2.c1 = v.c1 and t3.c1 = v.c1;
select /*+ leading (t1 t2 t3 v) index_ffs(t1 idx_t1_c1_c2_c3) index(t2 idx_t2_c1_c2_c3) index(t3 idx_t3_c1_c2_c3) use_merge(t2) use_merge(t3) use_merge(v) */ t1.c1, t2.c1, t3.c1, v.c1 from t1, t2, t3, (select /*+ leading (t5 t4) index_ffs(t5 idx_t5_c1_c2_c3) full(t4 idx_t5_c1_c2_c3) use_merge(t4 t5) */ t4.c1, t5.c1 c2 from t4, t5 where t4.c1 = t5.c1) v where t1.c1 = t2.c1 and t1.c1 = t3.c1 and t2.c1 = t3.c1 and t1.c1 = v.c1 and t2.c1 = v.c1 and t3.c1 = v.c1;

--------------------------------   非功能用例   -------------------------------------
-- leading冲突
explain select /*+ leading (t3) leading(t2) */ t1.c1, t2.c1, t3.c1 from t1, t2, t3 where t1.c1 = t2.c1 and t1.c1 = t3.c1 and t2.c1 = t3.c1;
explain select /*+ leading (t1) leading(t2) leading(t3) */ t1.c1, t2.c1, t3.c1 from t1, t2, t3 where t1.c1 = t2.c1 and t1.c1 = t3.c1 and t2.c1 = t3.c1;
explain select /*+ leading (t1) leading(t2) leading(t3) ordered */ t1.c1, t2.c1, t3.c1 from t1, t2, t3 where t1.c1 = t2.c1 and t1.c1 = t3.c1 and t2.c1 = t3.c1;
select /*+ leading (t1) leading(t2) leading(t3) ordered */ t1.c1, t2.c1, t3.c1 from t1, t2, t3 where t1.c1 = t2.c1 and t1.c1 = t3.c1 and t2.c1 = t3.c1;

--------------------------------   HINT FORCE   -------------------------------------
show parameter hint;

explain select  t1.c1, t2.c1, t3.c1, t4.c1 from t1, t2, t3, t4 where t2.c1 = t3.c1 and t3.c1 = t4.c1 and t1.c1 = t4.c1;
select t1.c1, t2.c1, t3.c1, t4.c1 from t1, t2, t3, t4 where t2.c1 = t3.c1 and t3.c1 = t4.c1 and t1.c1 = t4.c1;

-- HINT FORCE: ORDERED
alter system set _HINT_FORCE = 1;
explain select t1.c1,  t2.c1, t3.c1, t4.c1 from t4, t3, t2, t1 where t2.c1 = t3.c1 and t3.c1 = t4.c1 and t1.c1 = t4.c1;
select t1.c1, t2.c1, t3.c1, t4.c1 from t4, t3, t2, t1 where t2.c1 = t3.c1 and t3.c1 = t4.c1 and t1.c1 = t4.c1;

-- HINT FORCE: USE_NL  
alter system set _HINT_FORCE = 2;
explain select t1.c1, t2.c1,  t3.c1, t4.c1 from t4, t3, t2, t1 where t2.c1 = t3.c1 and t3.c1 = t4.c1 and t1.c1 = t4.c1;
select t1.c1, t2.c1, t3.c1, t4.c1 from t4, t3, t2, t1 where t2.c1 = t3.c1 and t3.c1 = t4.c1 and t1.c1 = t4.c1;

-- HINT FORCE: USE_MERGE 
alter system set _HINT_FORCE = 4;
explain select t1.c1, t2.c1, t3.c1,  t4.c1 from t4, t3, t2, t1 where t2.c1 = t3.c1 and t3.c1 = t4.c1 and t1.c1 = t4.c1;
select t1.c1, t2.c1, t3.c1, t4.c1 from t4, t3, t2, t1 where t2.c1 = t3.c1 and t3.c1 = t4.c1 and t1.c1 = t4.c1;

-- HINT FORCE: USE_HASH
alter system set _HINT_FORCE = 8;
explain select t1.c1, t2.c1, t3.c1, t4.c1 from  t4, t3, t2, t1 where t2.c1 = t3.c1 and t3.c1 = t4.c1 and t1.c1 = t4.c1;
select t1.c1, t2.c1, t3.c1, t4.c1 from t4, t3, t2, t1 where t2.c1 = t3.c1 and t3.c1 = t4.c1 and t1.c1 = t4.c1;

-- HINT FORCE: ORDERED + USE_NL
alter system set _HINT_FORCE = 3;      
explain select t1.c1, t2.c1, t3.c1, t4.c1 from t4,  t3, t2, t1 where t2.c1 = t3.c1 and t3.c1 = t4.c1 and t1.c1 = t4.c1;
select t1.c1, t2.c1, t3.c1, t4.c1 from t4, t3, t2, t1 where t2.c1 = t3.c1 and t3.c1 = t4.c1 and t1.c1 = t4.c1;
 
-- HINT FORCE: ORDERED + USE_MERGE
alter system set _HINT_FORCE = 5; 
explain select t1.c1, t2.c1, t3.c1, t4.c1 from t4, t3,  t2, t1 where t2.c1 = t3.c1 and t3.c1 = t4.c1 and t1.c1 = t4.c1;
select t1.c1, t2.c1, t3.c1, t4.c1 from t4, t3, t2, t1 where t2.c1 = t3.c1 and t3.c1 = t4.c1 and t1.c1 = t4.c1;

-- HINT FORCE: ORDERED + USE_HASH
alter system set _HINT_FORCE = 9;  
explain select t1.c1, t2.c1, t3.c1, t4.c1 from t4, t3, t2,  t1 where t2.c1 = t3.c1 and t3.c1 = t4.c1 and t1.c1 = t4.c1;
select t1.c1, t2.c1, t3.c1, t4.c1 from t4, t3, t2, t1 where t2.c1 = t3.c1 and t3.c1 = t4.c1 and t1.c1 = t4.c1;

-- DISABLE HINT FORCE
alter system set _HINT_FORCE = 0; 

--------------------------------   CLEAN   -------------------------------------
BEGIN
    FOR i IN 1..10 LOOP
        -- drop if exists
        BEGIN
            EXECUTE IMMEDIATE 'drop table t' || i;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
    END LOOP;
END;
/ 

-- DTS2018092809318
drop table if exists t1_gs_hint ;
create table t1_gs_hint (c1 int);
create index idx_t1_gs_hint_c1 on t1_gs_hint(c1);
BEGIN
    FOR i IN 1..500 LOOP
        BEGIN
            EXECUTE IMMEDIATE 'insert into t1_gs_hint values(:1) ' using i;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
    END LOOP;
	commit;
END;
/

drop table if exists t2_gs_hint ;
create table t2_gs_hint (c1 int);
create index idx_t2_gs_hint_c1 on t2_gs_hint(c1);
BEGIN
    FOR i IN 1..1000 LOOP
        BEGIN
            EXECUTE IMMEDIATE 'insert into t2_gs_hint values(:1) ' using i;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
    END LOOP;
	commit;
END;
/

explain select * from t1_gs_hint where c1 = 1;
explain select /*+ */ * from t1_gs_hint where c1 = 1;
explain select /*+*/ * from t1_gs_hint where c1 = 1;
explain select /*+ full(t1_gs_hint) */ * from t1_gs_hint where c1 = 1;
explain select /*+full(t1_gs_hint) */ * from t1_gs_hint where c1 = 1;
explain select /*+full(t1_gs_hint)*/ * from t1_gs_hint where c1 = 1;
explain select /*+
full(t1_gs_hint)
*/ * from t1_gs_hint where c1 = 1;    

explain select count(*) from t1_gs_hint a, t2_gs_hint b where a.c1 = b.c1;
explain select /*+use_hash(a b)*/count(*) from t1_gs_hint a, t2_gs_hint b where a.c1 = b.c1;
explain select /*+ use_hash(a b)*/count(*) from t1_gs_hint a, t2_gs_hint b where a.c1 = b.c1;

drop table t1_gs_hint;
drop table t2_gs_hint;


BEGIN
    FOR i IN 1..10 LOOP
        -- drop if exists
        BEGIN
            EXECUTE IMMEDIATE 'drop table if exists t' || i;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
        EXECUTE IMMEDIATE 'create table t' || i || ' (c1 int, c2 int, c3 int, c4 int)';
        EXECUTE IMMEDIATE 'create unique index idx_t' || i || '_c1         on t' || i || '(c1)';
        EXECUTE IMMEDIATE 'create unique index idx_t' || i || '_c1_c2      on t' || i || '(c1, c2)';
        EXECUTE IMMEDIATE 'create unique index idx_t' || i || '_c1_c2_c3   on t' || i || '(c1, c2, c3)';
        EXECUTE IMMEDIATE 'insert into t' || i || ' values (1, 2, 3, 0)';
        EXECUTE IMMEDIATE 'insert into t' || i || ' values (2, 0, 1, 3)';
        EXECUTE IMMEDIATE 'insert into t' || i || ' values (0, 1, 2, 3)';
    END LOOP;
END;
/

BEGIN
    FOR i IN 1..10 LOOP
        BEGIN
            EXECUTE IMMEDIATE 'drop view if exists view' || i;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
        EXECUTE IMMEDIATE 'create view view' || i || ' as select c1 , c2 , c3 , c4 from t' || i;
    END LOOP;
END;
/

explain select view1.c1, view2.c1, view3.c1, view4.c1 from view4, view3, view2, view1 where view2.c1 = view3.c1 and view3.c1 = view4.c1 and view1.c1 = view4.c1;
explain select  /*+ leading(view1 view2) use_nl (view2) */ view1.c1, view2.c1, view3.c1, view4.c1 from view4, view3, view2, view1 where view2.c1 = view3.c1 and view3.c1 = view4.c1 and view1.c1 = view4.c1;
explain select  /*+ leading(view1 view2) use_merge (view2) */ view1.c1, view2.c1, view3.c1, view4.c1 from view4, view3, view2, view1 where view2.c1 = view3.c1 and view3.c1 = view4.c1 and view1.c1 = view4.c1;
explain select /*+ leading(view1 view2) use_merge (view2) use_nl (view2) */ view1.c1, view2.c1, view3.c1, view4.c1 from view4, view3, view2, view1 where view2.c1 = view3.c1 and view3.c1 = view4.c1 and view1.c1 = view4.c1;
explain select  /*+ leading(view1 view2) use_nl (view2) */ view1.c1, view2.c1, view3.c1 from  view3, view2, view1 where view2.c1 = view3.c1 and view3.c1 = view1.c1;
select view1.c1, view2.c1, view3.c1, view4.c1 from view4, view3, view2, view1 where view2.c1 = view3.c1 and view3.c1 = view4.c1 and view1.c1 = view4.c1 order by 1;
select  /*+ leading(view1 view2) use_nl (view2) */ view1.c1, view2.c1, view3.c1, view4.c1 from view4, view3, view2, view1 where view2.c1 = view3.c1 and view3.c1 = view4.c1 and view1.c1 = view4.c1 order by 1;
select  /*+ leading(view1 view2) use_merge (view2) */ view1.c1, view2.c1, view3.c1, view4.c1 from view4, view3, view2, view1 where view2.c1 = view3.c1 and view3.c1 = view4.c1 and view1.c1 = view4.c1 order by 1;
select /*+ leading(view1 view2) use_merge (view2) use_nl (view2) */ view1.c1, view2.c1, view3.c1, view4.c1 from view4, view3, view2, view1 where view2.c1 = view3.c1 and view3.c1 = view4.c1 and view1.c1 = view4.c1 order by 1;
select  /*+ leading(view1 view2) use_nl (view2) */ view1.c1, view2.c1, view3.c1 from  view3, view2, view1 where view2.c1 = view3.c1 and view3.c1 = view1.c1 order by 1;

--DTS2019110804256
explain select /*+ use_hash (view1) */ view1.c1, view2.c1 from view1, view2 where view1.c1 = view2.c1;
select /*+ use_hash (view1) */ view1.c1, view2.c1 from view1, view2 where view1.c1 = view2.c1;
explain select /*+ leading(view2 view1) use_hash (view1) */ view1.c1, view2.c1 from view1, view2 where view1.c1 = view2.c1;
select /*+ leading(view2 view1) use_hash (view1) */ view1.c1, view2.c1 from view1, view2 where view1.c1 = view2.c1;
explain select /*+ leading(view1 view2) use_hash (view2) */ view1.c1, view2.c1 from view1, view2 where view1.c1 = view2.c1;
select /*+ leading(view1 view2) use_hash (view2) */ view1.c1, view2.c1 from view1, view2 where view1.c1 = view2.c1;
explain select /*+ use_hash (view1 view2) */ view1.c1, view2.c1 from view1, view2 where view1.c1 = view2.c1;
select /*+ use_hash (view1 view2) */ view1.c1, view2.c1 from view1, view2 where view1.c1 = view2.c1;
explain select /*+ use_hash (view2 view1) */ view1.c1, view2.c1 from view1, view2 where view1.c1 = view2.c1;
select /*+ use_hash (view2 view1) */ view1.c1, view2.c1 from view1, view2 where view1.c1 = view2.c1;
explain plan for select /*+ leading(view2 view1) use_hash (view1) */ view1.c1, view2.c1 from (select c1,c2,c3,c4 from t1) as view1, (select c1,c2,c3,c4 from t2) as view2  where view1.c1 = view2.c1;
select /*+ leading(view2 view1) use_hash (view1) */ view1.c1, view2.c1 from (select c1,c2,c3,c4 from t1) as view1, (select c1,c2,c3,c4 from t2) as view2  where view1.c1 = view2.c1;
explain plan for select /*+ leading(view2 view1) use_hash (view1) */ view1.c1, view2.c1 from (select c1,c2,c3,c4 from t1) as view1,view2  where view1.c1 = view2.c1;
select /*+ leading(view2 view1) use_hash (view1) */ view1.c1, view2.c1 from (select c1,c2,c3,c4 from t1) as view1,view2  where view1.c1 = view2.c1;
explain plan for select /*+ leading(view2 view1) use_hash (view1) */ view1.c1, view2.c1 from view1, (select c1,c2,c3,c4 from t2) as view2  where view1.c1 = view2.c1;
select /*+ leading(view2 view1) use_hash (view1) */ view1.c1, view2.c1 from view1, (select c1,c2,c3,c4 from t2) as view2  where view1.c1 = view2.c1;


--use_hash support outer join
explain plan for select /*+use_hash (view2)*/ * from view1 left join view2 on view1.c1 = view2.c1;
explain plan for select /*+use_hash(view3)*/ * from (view1 inner join view2 on view1.c1 = view2.c1 ) left join view3 on view1.c1 = view3.c1;
explain plan for select /*+use_hash(view3) use_nl(view1, view2)*/ * from (view1 inner join view2 on view1.c1 = view2.c1 ) left join view3 on view1.c1 = view3.c1;
explain plan for select /*+use_hash(view3) use_hash(view2) leading(view1)*/ * from (view1 inner join view2 on view1.c1 = view2.c1 ) left join view3 on view1.c1 = view3.c1;
explain plan for select /*+use_hash(view3)*/ * from (view1 inner join view2 on view1.c1 = view2.c1 ) left join (view3 inner join view4 on view3.c1 = view4.c1) on view1.c1 = view3.c1;
explain plan for select /*+use_hash(view3), use_hash(view1) leading(view2)*/ * from (view1 inner join view2 on view1.c1 = view2.c1 ) left join view3 on view1.c1 = view3.c1;
explain plan for select /*+use_hash(view3) leading(view4)*/ * from (view1 inner join view2 on view1.c1 = view2.c1 ) left join (view3 inner join view4 on view3.c1 = view4.c1) on view1.c1 = view3.c1;
explain plan for select /*+use_hash(view4)*/ * from (view1 left join view2 on view1.c1 = view2.c1 ) inner join (view3 left join view4 on view3.c1 = view4.c1) on view1.c1 = view3.c1;
explain plan for select /*+use_hash(view3) use_hash(view2)*/ * from view1 left join view2 on view1.c1 = view2.c1 left join view3 on view1.c2 = view3.c2;
explain plan for select /*+use_hash(view3) use_nl(view1, view2)*/ * from view1 left join view2 on view1.c1 = view2.c1 left join view3 on view1.c2 = view3.c2;
explain plan for select /*+use_hash (view1, view2)*/ * from view1 left join view2 on view1.c1 > view2.c1;

explain plan for select /*+use_hash(t3) leading(t2, t1)*/ * from (t1 inner join t2 on t1.c1 = t2.c1) left join t3 on t1.c1 = t3.c1;
explain plan for select /*+use_hash(t3) leading(t2, t1)*/ * from (t1 inner join t2 on t1.c1 = t2.c1) full join t3 on t1.c1 = t3.c1;
explain plan for select /*+use_nl(t3) leading(t2, t1)*/ * from (t1 inner join t2 on t1.c1 = t2.c1) full join t3 on t1.c1 = t3.c1;

explain plan for select /*+use_hash(t3) leading(t2,t4,t1)*/ * from (t1 inner join t2 on t1.c1 = t2.c1 and t2.c2 > 10 inner join t4 on t1.c1 = t4.c1) left join t3 on t1.c1 = t3.c1;
explain plan for select /*+use_hash(t3) leading(t4,t2,t1)*/ * from (t1 inner join t2 on t1.c1 = t2.c1 and t2.c2 > 10 inner join t4 on t1.c1 = t4.c1) left join t3 on t1.c1 = t3.c1;
explain plan for select * from (t1 inner join t2 on t1.c2 = t2.c2 and t2.c1 > 10 inner join t4 on t1.c1 = t4.c1) left join t3 on t1.c1 = t3.c1;
explain plan for select /*+leading(t5,t4)*/ * from (t1 inner join t2 on t1.c1 = t2.c1 and t2.c2 > 10 inner join t3 on t1.c1 = t3.c1) left join (t4 inner join t5 on t4.c1 = t5.c1) on t1.c1 = t4.c1;
explain plan for select /*+use_hash(t3) ordered*/ * from (t1 inner join t2 on t1.c2 = t2.c2 and t2.c1 > 10 inner join t4 on t1.c1 = t4.c1) left join t3 on t1.c1 = t3.c1;
--hint invalid
explain plan for select /*+leading(t3,t1,t2) leading(t5,t4)*/ * from (t1 inner join t2 on t1.c1 = t2.c1 and t2.c2 > 10 inner join t3 on t1.c1 = t3.c1) left join (t4 inner join t5 on t4.c1 = t5.c1) on t1.c1 = t4.c1;
explain plan for select /*+use_nl(t3,t4)leading(t5,t4)*/ * from (t1 inner join t2 on t1.c1 = t2.c1 and t2.c2 > 10 inner join t3 on t1.c1 = t3.c1) left join (t4 inner join t5 on t4.c1 = t5.c1) on t1.c1 = t4.c1 ;
explain plan for select /*+use_hash(t3, t4) leading(t5,t4)*/ * from (t1 inner join t2 on t1.c1 = t2.c1 and t2.c2 > 10 inner join t3 on t1.c1 = t3.c1) left join t4 on t1.c1 = t4.c1;
explain plan for select /*+use_merge(t3) leading(t2, t1)*/ * from (t1 inner join t2 on t1.c1 = t2.c1) full join t3 on t1.c1 = t3.c1;
explain plan for select /*+use_merge(view1, view2)*/ * from view1 left join view2 on view1.c1 = view2.c1;
explain plan for select /*+ordered*/ * from (t1 inner join t2 on t1.c2 = t2.c2 and t2.c1 > 10 inner join t3 on t1.c1 = t3.c1) left join (t4 inner join t5 on t4.c2 = t5.c2 and t5.c1 > 10) on t1.c1 = t4.c1;
explain plan for select /*+ordered*/ * from (t1 inner join t2 on t1.c2 = t2.c2 and t2.c1 > 10 inner join t4 on t1.c1 = t4.c1) left join t3 on t1.c1 = t3.c1;
explain plan for select /*+leading(t3,t5,t4)*/ * from (t1 inner join t2 on t1.c1 = t2.c1 and t2.c2 > 10 inner join t3 on t1.c1 = t3.c1) left join (t4 inner join t5 on t4.c1 = t5.c1) on t1.c1 = t4.c1;
BEGIN
    FOR i IN 1..10 LOOP
        -- drop if exists
        BEGIN
            EXECUTE IMMEDIATE 'drop table if exists t' || i;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
    END LOOP;
END;
/

--DTS2020011606772
drop table if exists hbh1;
drop table if exists hbh2;
CREATE TABLE hbh1(id1 INT, id2 INT, id3 int);
CREATE TABLE hbh2(id4 INT, id5 INT, id6 int);
create index hbh1_idx_1 on hbh1(id1);
create index hbh1_idx_2 on hbh1(id2);
create index hbh2_idx_4 on hbh2(id4);
create index hbh2_idx_5 on hbh2(id5);
explain update hbh1,hbh2 set id3 = 3 where id1 = id4;
explain update /*+ index(hbh2 hbh2_idx_5)*/ hbh1,hbh2 set id3 = 3 where id1 =id4;
explain delete from hbh1 where id1 =2;
explain delete /*+ index(hbh1 hbh1_idx_2)*/ from hbh1 where id1 =2;
drop table hbh1;
drop table hbh2;
--code coverage
drop table if exists t_cnct_1;
drop table if exists t_cnct_2;
create table t_cnct_1 (a int, b int);
insert into t_cnct_1 values(1, 2);
create index ind_cnct_a1 on t_cnct_1(a);
create index ind_cnct_b1 on t_cnct_1(b);
commit;
create table t_cnct_2 (a int, b int);
insert into t_cnct_2 values(1, 2);
commit;

--sql_adjust_join_plan_with_2_cnct
select * from t_cnct_1 t1 join t_cnct_1 t2 where (t1.a = 1 or t1.b = 2) and (t2.a = 1 or t2.b = 2);
explain select * from t_cnct_1 t1 join t_cnct_1 t2 where (t1.a = 1 or t1.b = 2) and (t2.a = 1 or t2.b = 2);
--sql_rebuild_ssa_in_case_when、sql_rebuild_ssa_in_node、sql_rebuild_ssa_in_expr
select * from t_cnct_1 t 
   where exists (select a from t_cnct_1 where a + b in (select count(a) from t_cnct_1 where rownum < 5) 
                    and t.a in (select count(a) from t_cnct_1 group by a)
                    and case when b = 2 then b else null end in (select b from t_cnct_1 limit 1));
--sql_verify_column_value
select column_value from t_cnct_1  ;
--sql_hint_string2text
select /*+ index('t' ind_cnct_b1) */ * from t_cnct_1 t where a = 1;
--transform_group_expr_node
select (select a from (select t.a from t_cnct_1) where  t.a = a) as a from t_cnct_1 as t group by a ;
select count(*) from (select (select rowid from (select t.rowid from t_cnct_1) where  t.rowid = rowid) as a from t_cnct_1 as t group by rowid );
--modify_group_node_info
select (select a from t_cnct_1 s where a = (select count(a) from t_cnct_1 where t.a = s.a) ) as a from t_cnct_1 as t group by a ;
select (select a from t_cnct_1 s where a = (select count(a) from t_cnct_1 where t.rowid = s.rowid) ) as a from t_cnct_1 as t group by rowid ;
--modify_child_node_4_tab
select (SELECT count(*) FROM (SELECT a, b FROM t_cnct_1 where t.a = 1) t0 LEFT JOIN  t_cnct_2 t1 on t0.a = t1.a where t0.b = 2 ) from t_cnct_1 t group by t.a;
select (SELECT count(*) FROM (SELECT a, b FROM t_cnct_1 where t.rowid is not null) t0 LEFT JOIN  t_cnct_2 t1 on t0.a = t1.a where t0.b = 2 ) from t_cnct_1 t group by t.rowid;
--modify_node_4_group 
select (select  min(t1.a) from t_cnct_1 t1, t_cnct_2 t2 where t.b = t1.b group by t1.a) from t_cnct_1 t group by t.a, t.b;
select (select  min(t1.a) from t_cnct_1 t1, t_cnct_2 t2 where t.rowid = t1.b group by t1.a) from t_cnct_1 t group by t.a, t.rowid;
drop table t_cnct_1;
drop table t_cnct_2;


drop table if exists t_in_minus_1;
drop table if exists t_in_minus_2;
create table t_in_minus_1(f_int1 int, f_int2 int);
create table t_in_minus_2(f_int1 int, f_int2 int);
insert into t_in_minus_1 values(1, 11);
insert into t_in_minus_1 values(3, 332);
insert into t_in_minus_1 values(1, 11);
insert into t_in_minus_1 values(3, 33);
insert into t_in_minus_1 values(2, 22);
insert into t_in_minus_1 values(3, 33);
insert into t_in_minus_1 values(1, 11);
insert into t_in_minus_1 values(5, 55);
insert into t_in_minus_2 values(2, 22);
insert into t_in_minus_2 values(4, 44);
insert into t_in_minus_2 values(2, 22);
insert into t_in_minus_2 values(4, 44);
insert into t_in_minus_2 values(5, 54);
insert into t_in_minus_2 values(5, 55);
insert into t_in_minus_2 values(6, 66);
insert into t_in_minus_1 values(2, 22);
insert into t_in_minus_2 values(2, 22);
commit;

explain select * from t_in_minus_1 where f_int1 in (select f_int1 from t_in_minus_1 except select f_int1 from t_in_minus_2);
explain select * from t_in_minus_1 where f_int1 in (select f_int1 from t_in_minus_1 except all select f_int1 from t_in_minus_2);
explain select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in (select f_int1 from t_in_minus_1 except select f_int1 from t_in_minus_2);
explain select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in (select f_int1 from t_in_minus_1 except all select f_int1 from t_in_minus_2);
explain select * from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 except select f_int1 from t_in_minus_2) except select f_int1 from t_in_minus_2);
explain select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 except select f_int1 from t_in_minus_2) except select f_int1 from t_in_minus_2);
-- complex except all
explain select distinct f_int1, f_int2 from t_in_minus_1 except all select f_int1, f_int2 from t_in_minus_2;
explain select distinct * from (select f_int1, f_int2 from t_in_minus_1 except all select f_int1, f_int2 from t_in_minus_2);
explain select * from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 except all select f_int1 from t_in_minus_2) except select f_int1 from t_in_minus_2);
select * from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 except all select f_int1 from t_in_minus_2) except select f_int1 from t_in_minus_2);
explain select * from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 except all select f_int1 from t_in_minus_2) except all select f_int1 from t_in_minus_2);
select * from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 except all select f_int1 from t_in_minus_2) except all select f_int1 from t_in_minus_2);
explain select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 except all select f_int1 from t_in_minus_2) except select f_int1 from t_in_minus_2);
select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 except all select f_int1 from t_in_minus_2) except select f_int1 from t_in_minus_2);
explain select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 except all select f_int1 from t_in_minus_2) except all select f_int1 from t_in_minus_2);
select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 except all select f_int1 from t_in_minus_2) except all select f_int1 from t_in_minus_2);
-- intersect
explain select distinct f_int1, f_int2 from t_in_minus_1 intersect select f_int1, f_int2 from t_in_minus_2;
explain select * from t_in_minus_1 where f_int1 in (select f_int1 from t_in_minus_1 intersect select f_int1 from t_in_minus_2);
explain select * from t_in_minus_1 where f_int1 in (select f_int1 from t_in_minus_1 intersect all select f_int1 from t_in_minus_2);
explain select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in (select f_int1 from t_in_minus_1 intersect select f_int1 from t_in_minus_2);
select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in (select f_int1 from t_in_minus_1 intersect select f_int1 from t_in_minus_2);
explain select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in (select f_int1 from t_in_minus_1 intersect all select f_int1 from t_in_minus_2);
select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in (select f_int1 from t_in_minus_1 intersect all select f_int1 from t_in_minus_2);
-- complex intersect
explain select distinct f_int1, f_int2 from t_in_minus_1 intersect all select f_int1, f_int2 from t_in_minus_2;
explain select distinct * from (select f_int1, f_int2 from t_in_minus_1 intersect all select f_int1, f_int2 from t_in_minus_2);
explain select * from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 intersect select f_int1 from t_in_minus_2) intersect select f_int1 from t_in_minus_2);
select * from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 intersect select f_int1 from t_in_minus_2) intersect select f_int1 from t_in_minus_2);
explain select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 intersect select f_int1 from t_in_minus_2) intersect select f_int1 from t_in_minus_2);
select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 intersect select f_int1 from t_in_minus_2) intersect select f_int1 from t_in_minus_2);
explain select * from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 intersect all select f_int1 from t_in_minus_2) intersect select f_int1 from t_in_minus_2);
select * from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 intersect all select f_int1 from t_in_minus_2) intersect select f_int1 from t_in_minus_2);
explain select * from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 intersect all select f_int1 from t_in_minus_2) intersect all select f_int1 from t_in_minus_2);
select * from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 intersect all select f_int1 from t_in_minus_2) intersect all select f_int1 from t_in_minus_2);
explain select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 intersect all select f_int1 from t_in_minus_2) intersect select f_int1 from t_in_minus_2);
select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 intersect all select f_int1 from t_in_minus_2) intersect select f_int1 from t_in_minus_2);
explain select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 intersect all select f_int1 from t_in_minus_2) intersect all select f_int1 from t_in_minus_2);
select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 intersect all select f_int1 from t_in_minus_2) intersect all select f_int1 from t_in_minus_2);
explain select * from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 intersect all select f_int1 from t_in_minus_2) intersect all select f_int1 from t_in_minus_2);
select * from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 intersect all select f_int1 from t_in_minus_2) intersect all select f_int1 from t_in_minus_2);
--combine test
explain select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 except all select f_int1 from t_in_minus_2) intersect select f_int1 from t_in_minus_2);
select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 except all select f_int1 from t_in_minus_2) intersect select f_int1 from t_in_minus_2);
explain select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 intersect all select f_int1 from t_in_minus_2) except all select f_int1 from t_in_minus_2);
select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 intersect all select f_int1 from t_in_minus_2) except all select f_int1 from t_in_minus_2);
explain select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 except all select f_int1 from t_in_minus_2) intersect all select f_int1 from t_in_minus_2);
select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 except all select f_int1 from t_in_minus_2) intersect all select f_int1 from t_in_minus_2);
explain select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 except select f_int1 from t_in_minus_2) intersect all select f_int1 from t_in_minus_2);
select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in ((select f_int1 from t_in_minus_1 except select f_int1 from t_in_minus_2) intersect all select f_int1 from t_in_minus_2);
--combine limit
explain select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in (select f_int1 from t_in_minus_1 limit 10); 
explain select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in (select f_int1 from t_in_minus_1 intersect all select f_int1 from t_in_minus_2 limit 10);
explain select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in (select f_int1 from t_in_minus_1 except all select f_int1 from t_in_minus_2 limit 10);
explain select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in (select f_int1 from t_in_minus_1 union all select f_int1 from t_in_minus_2 limit 10);
explain select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in (select f_int1 from t_in_minus_1 minus select f_int1 from t_in_minus_2 limit 10);
explain select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in (select f_int1 from t_in_minus_1 except select f_int1 from t_in_minus_2 limit 10);
explain select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in (select f_int1 from t_in_minus_1 union select f_int1 from t_in_minus_2 limit 10);
explain select /*+use_nl(t_in_minus_1)*/* from t_in_minus_1 where f_int1 in (select f_int1 from t_in_minus_1 intersect select f_int1 from t_in_minus_2 limit 10);
drop table t_in_minus_1;
drop table t_in_minus_2;

-- test parallel hint
drop table if exists test_parallel_hint_t;
create table test_parallel_hint_t(c1 int);
explain plan for select /*+parallel(-1)*/ * from test_parallel_hint_t;
explain plan for select /*+parallel(0)*/ * from test_parallel_hint_t;
explain plan for select /*+parallel(1)*/ * from test_parallel_hint_t;
explain plan for select /*+parallel(4.0)*/ * from test_parallel_hint_t;
explain plan for select /*+parallel(4.1)*/ * from test_parallel_hint_t;
explain plan for select /*+parallel(9223372036854775807)*/ * from test_parallel_hint_t;
explain plan for select /*+parallel(9223372036854775808)*/ * from test_parallel_hint_t;
drop table test_parallel_hint_t;