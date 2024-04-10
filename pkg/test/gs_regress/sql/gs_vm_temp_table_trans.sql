drop table if exists vm_temp_table;
create global temporary table vm_temp_table(f_int1 int);
insert into vm_temp_table values(1);
delete from vm_temp_table;

--Do not change expectations easily; there may be a virtual memory leak,
-- Unstable use case, due to SYS_TMP_SEG_STATS, all table will record stat info, even the table drop, stat info is not free
--select ID,TOTAL_VIRTUAL,FREE_VIRTUAL,PAGE_SIZE,TOTAL_PAGES,FREE_PAGES from v$temp_pool;

insert into vm_temp_table values(1);
commit;

--Do not change expectations easily; there may be a virtual memory leak
-- Unstable use case, due to SYS_TMP_SEG_STATS, all table will record stat info, even the table drop, stat info is not free
--select ID,TOTAL_VIRTUAL,FREE_VIRTUAL,PAGE_SIZE,TOTAL_PAGES,FREE_PAGES from v$temp_pool;

