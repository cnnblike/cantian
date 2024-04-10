drop table if exists cart_t1;
drop table if exists cart_t2;
drop table if exists cart_t3;
create table cart_t1(a int, b int);
create table cart_t2(a int, b int);
create table cart_t3(a int, b int);

explain select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ count(*) from cart_t1 join (select  distinct a from cart_t2) ta2;
explain  select count(*) from  cart_t3  where   cart_t3.a  in ( select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ cart_t1.a from cart_t1 join (select  distinct a from cart_t2 ) ta2);

explain select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ count(*) from cart_t1 join (select a from cart_t2 group by a) ta2; 
explain select /*+ leading(cart_t3,tmp)  */ count(*) from cart_t3 join (select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ * from cart_t1 join (select  a from cart_t2 group by a) ta2) tmp;

explain select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ count(*) from cart_t1 join (select /*+ USE_HASH(cart_t2,cart_t3) */ cart_t2.a from cart_t2 join cart_t3 on cart_t2.a = cart_t3.a) ta2;   
explain select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ count(*) from cart_t1 join (select /*+ USE_HASH(cart_t2,cart_t3) */ cart_t2.a from cart_t2 left join cart_t3 on cart_t2.a = cart_t3.a) ta2;   
explain select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ count(*) from cart_t1 join (select /*+ USE_HASH(cart_t2,cart_t3) */ cart_t2.a from cart_t2 full join cart_t3 on cart_t2.a = cart_t3.a) ta2;   
explain select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ count(*) from cart_t1 join (select a from cart_t2 where  exists (select a from cart_t3 where cart_t2.a = cart_t3.a)) ta2;   
explain select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ count(*) from cart_t1 join (select a from cart_t2 where  cart_t2.a not in (select a from cart_t3 )) ta2;

explain select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ count(*) from cart_t1 join (select  distinct a from cart_t2) ta2 where cart_t1.a = ta2.a;
explain select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ count(*) from cart_t1 join (select  distinct a from cart_t2) ta2 where ta2.a =  cart_t1.a or cart_t1.a > 1;
explain select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ count(*) from cart_t1 join (select  distinct a from cart_t2) ta2 where ta2.a =  ? or cart_t1.a > ? or ? = ?;
explain select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ count(*) from cart_t1 join (select  distinct a from cart_t2) ta2 where ta2.a =  1 or  cart_t1.a > 1;
explain select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ * from cart_t1 join (select  distinct a from cart_t2) ta2 where log(abs(cart_t1.a + 2) + 1)= ta2.a or ta2.a > 1;
explain select /*+ leading(cart_t3)  */ count(*) from cart_t3 join (select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ distinct cart_t1.a from cart_t1 join 
(select  /*+ USE_NL(cart_t2,Ta3)   leading(cart_t2)  */ cart_t2.a from cart_t2 join (select cart_t2.a from cart_t2 join cart_t3 on cart_t2.a = cart_t3.a) ta3 group by cart_t2.a) ta2  where cart_t1.a = ta2.a ) tmp;

explain  select count(*) from  cart_t3  where   cart_t3.a  in ( select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ cart_t1.a from cart_t1 join (select  distinct a from cart_t2 where cart_t3.a = cart_t2.a ) ta2);
explain  select count(*) from  cart_t3  where   cart_t3.a  in ( select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ cart_t1.a  from cart_t1 join (select  distinct a from cart_t2) ta2 where cart_t3.a = ta2.a);
explain select  count(*) from cart_t3 as test where test.a in (select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ distinct cart_t1.a from cart_t1 join 
(select  /*+ USE_NL(cart_t2,Ta3)   leading(cart_t2)  */ cart_t2.a from cart_t2 join (select /*+ USE_HASH(cart_t2) */ cart_t2.a  from cart_t2 join cart_t3 on cart_t2.a = cart_t3.a  where test.a = 1) ta3  group by cart_t2.a )  ta2);

explain select  count(*) from cart_t3 as test where test.a in (select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ distinct cart_t1.a from cart_t1 join 
(select  /*+ USE_NL(cart_t2,Ta3)   leading(cart_t2)  */ cart_t2.a from cart_t2 join (select /*+ USE_HASH(cart_t2) */ cart_t2.a  from cart_t2 join cart_t3 on cart_t2.a = cart_t3.a  where ? = ?) ta3  group by cart_t2.a )  ta2);

explain select  count(*) from cart_t3 as test where test.a in (select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ distinct cart_t1.a from cart_t1 join 
(select  /*+ USE_NL(cart_t2,Ta3)   leading(cart_t2)  */ cart_t2.a from cart_t2 join (select /*+ USE_HASH(cart_t2,cart_t3) */ cart_t2.a  from cart_t2 join cart_t3 on cart_t2.a = cart_t3.a) ta3  where test.a = 1 group by cart_t2.a )  ta2);

explain select /*+ leading(cart_t3)  */ count(*) from cart_t3 join (select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ distinct cart_t1.a from cart_t1 join (select  distinct a from cart_t2) ta2) tmp;

explain select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ count(*) from cart_t1 join (select  distinct a from cart_t2) ta2 
union
select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ count(*) from cart_t1 join (select cart_t2.a from cart_t2 join cart_t3 on cart_t2.a = cart_t3.a) ta2;
explain select /*+ leading(cart_t3)  */   count(*) from cart_t3 ,(select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ distinct cart_t1.a from cart_t1 ,
(select  /*+ USE_NL(cart_t2,Ta3)   leading(cart_t2)  */ cart_t2.a from cart_t2 , (select cart_t2.a from cart_t2 join cart_t3 on cart_t2.a = cart_t3.a) ta3 where cart_t2.a = 3 group by cart_t2.a) ta2 where cart_t1.a = 1) tmp;

explain  select count(*) from cart_t1 as test2 where test2.a in (
select count(*) from  cart_t3  where   cart_t3.a  in ( select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ cart_t1.a from cart_t1 join (select a from cart_t2  where test2.a = 1 group by a) ta2)
);

explain  select count(*) from cart_t1 as test2 where test2.a in (
select count(*) from  cart_t3  where   cart_t3.a  in ( select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ cart_t1.a from cart_t1 join (select a,test2.a from cart_t2  group by a,test2.a) ta2)
);

explain  select count(*) from  cart_t3  where   cart_t3.a  in ( select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ cart_t1.a from cart_t1 join (select  /*+ USE_HASH(cart_t2,tt) */ cart_t2.a, cart_t3.a from cart_t2 join cart_t1 as tt on cart_t2.a = tt.a ) ta2);

explain  select count(*) from  cart_t3  where   cart_t3.a  in ( select /*+ USE_NL(cart_t1,Ta2)   leading(cart_t1)  */ cart_t1.a from cart_t1 join (select  /*+ USE_HASH(cart_t2,tt) */ cart_t2.a, mod(cart_t3.a,1) from cart_t2 join cart_t1 as tt on cart_t2.a = tt.a ) ta2);

explain select /*+use_nl(t1,subq_0) leading(t1)*/ t1.a from cart_t1 t1 inner join (select max(a) c1, b from cart_t2 group by b) subq_0 on t1.a > any(subq_0.b);
explain select /*+use_nl(t1,subq_0) leading(t1)*/ t1.a from cart_t1 t1 inner join (select max(a) c1, b from cart_t2 group by b) subq_0 on t1.a + subq_0.b = 10;
explain select /*+use_nl(t1,subq_0) leading(t1)*/ t1.a from cart_t1 t1 inner join (select max(a) c1, b from cart_t2 group by b) subq_0 on t1.a = 10 or t1.b = subq_0.b;
explain select /*+use_nl(t1,subq_0) leading(t1)*/ t1.a from cart_t1 t1 inner join (select distinct a from cart_t2) subq_0 on t1.a in (select subq_0.a from cart_t3 where rownum=2);
explain select /*+ordered*/ t1.a from cart_t1 t1 inner join cart_t1 t2 on t1.b=t2.b inner join (select max(a) c1, b from cart_t2 group by b) subq_0 on t2.a > t1.a;
explain select /*+use_nl(t1,subq_0) leading(t1)*/ t1.a from cart_t1 t1 inner join (select max(a) c1, b from cart_t2 group by b) subq_0 start with t1.a + subq_0.c1 = 2 connect by t1.b + subq_0.b = 10;
explain select /*+use_nl(t1,subq_0) leading(t1)*/ t1.a from cart_t1 t1 inner join (select t2.rowid as c1 from cart_t2 t2 inner join cart_t3 t3 on t2.a = t3.a) subq_0 on t1.rowid = subq_0.c1;

drop table cart_t1;
drop table cart_t2;
drop table cart_t3;