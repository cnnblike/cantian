spool ./results/gs_verify.out
set define &
set verify on
select &a from dual;
abcde
set verify off
select &a from dual;
abcde
set verify on
spool
