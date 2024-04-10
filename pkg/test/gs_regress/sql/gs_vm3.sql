
--Do not change expectations easily; there may be a virtual memory leak
select ID,TOTAL_VIRTUAL,FREE_VIRTUAL,PAGE_SIZE,TOTAL_PAGES,FREE_PAGES from v$temp_pool;
select count(1) from v$vm_func_stack;

--Turn off the vm monitoring
ALTER SYSTEM SET _MAX_VM_FUNC_STACK_COUNT = 0;
SHOW PARAMETER _MAX_VM_FUNC_STACK_COUNT;
