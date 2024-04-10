DROP TABLE IF EXISTS test;
create table test
(
f1 int not null,
f2 int,
f3 varchar(100)
);
alter table test add primary key (f1);
create index test_index_001 on test (f1, f2,f3);
create unique index test_index_002 on test (f2);

--nonunique index info
select null as table_cat,
 i.owner as table_schem, 
 i.table_name, 
 case i.IS_PRIMARY || i.is_unique when 'NN' then 0 else 1 end as NON_UNIQUE,
 null as index_qualifier, 
 --i.index_name as index_name, 
  1 as type, 
 c.column_position as ordinal_position, 
 c.column_name, 
 null as asc_or_desc, 
 0 as cardinality, 
 i.pages as pages, 
 null as filter_condition 
 from all_indexes i, sys.dba_ind_columns c 
 where i.table_name = 'TEST' 
 and i.owner = 'SYS' 
 --and (i.IS_PRIMARY = 'Y' or i.IS_UNIQUE = 'Y')    
 and i.index_name = c.index_name 
 and i.owner = c.table_owner 
 and i.table_name = c.table_name 
 and i.owner = c.index_owner
 order by non_unique, type, i.index_name, ordinal_position ;

 
--unique index info
select null as table_cat,
 i.owner as table_schem, 
 i.table_name, 
 case i.IS_PRIMARY || i.is_unique when 'NN' then 0 else 1 end as NON_UNIQUE,
 null as index_qualifier, 
 --i.index_name as index_name, 
  1 as type, 
 c.column_position as ordinal_position, 
 c.column_name, 
 null as asc_or_desc, 
 0 as cardinality, 
 i.pages as pages, 
 null as filter_condition 
 from all_indexes i, sys.dba_ind_columns c 
 where i.table_name = 'TEST' 
 and i.owner = 'SYS' 
 and (i.IS_PRIMARY = 'Y' or i.IS_UNIQUE = 'Y')    
 and i.index_name = c.index_name 
 and i.owner = c.table_owner 
 and i.table_name = c.table_name 
 and i.owner = c.index_owner
 order by non_unique, type, i.index_name, ordinal_position ;
 
 DROP TABLE IF EXISTS test;