create table cr_pool_t1(a int, b int);
create table cr_pool_t2(a int, b int);
create index cr_pool_idx_t2_1 on cr_pool_t2(b);

insert into cr_pool_t1 values(1,1);
insert into cr_pool_t1 values(2,2);
insert into cr_pool_t1 values(3,3);

insert into cr_pool_t2 values(1,1);
insert into cr_pool_t2 values(2,2);
insert into cr_pool_t2 values(3,3);

commit;

select * from cr_pool_t1 where exists (select 1 from cr_pool_t2 where cr_pool_t1.b = cr_pool_t2.b);
select * from cr_pool_t1 join cr_pool_t2 on cr_pool_t1.b = cr_pool_t2.b;

drop table cr_pool_t1;
drop table cr_pool_t2;
