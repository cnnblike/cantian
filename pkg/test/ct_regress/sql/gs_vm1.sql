
--Do not change expectations easily; there may be a virtual memory leak
select ID,TOTAL_VIRTUAL,FREE_VIRTUAL,PAGE_SIZE,TOTAL_PAGES,FREE_PAGES from v$temp_pool;
select count(1) from v$vm_func_stack;
