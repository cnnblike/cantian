spool ./results/gs_interactive_alter.out
conn / as sysdba
drop user if exists chen cascade;
create user chen identified by Gauss_234;
grant dba to chen;
alter user chen password expire;
select USERNAME, ACCOUNT_STATUS from adm_users where USERNAME = 'CHEN';
conn chen/Gauss_234@127.0.0.1:1611
Gauss_123
Gauss_234
conn chen/Gauss_234@127.0.0.1:1611
123456
123456
conn chen/Gauss_234@127.0.0.1:1611
Gauss_234Gauss_234Gauss_234Gauss_234Gauss_234Gauss_234Gauss_234Ga
Gauss_234Gauss_234Gauss_234Gauss_234Gauss_234Gauss_234Gauss_234Ga
conn chen/Gauss_234@127.0.0.1:1611
Gauss_2
Gauss_2
conn chen/Gauss_234@127.0.0.1:1611
Gauss_234Gauss_234Gauss_234Gauss_234Gauss_234Gauss_234Gauss_234G
Gauss_234Gauss_234Gauss_234Gauss_234Gauss_234Gauss_234Gauss_234G
alter user chen password expire;
conn chen/Gauss_234Gauss_234Gauss_234Gauss_234Gauss_234Gauss_234Gauss_234G@127.0.0.1:1611
Gauss_23
Gauss_23
alter user chen password expire;
conn chen/Gauss_23@127.0.0.1:1611
Gauss_234

conn chen/Gauss_23@127.0.0.1:1611

conn chen/Gauss_23@127.0.0.1:1611
Gauss%234
Gauss%234
conn chen/Gauss_23@127.0.0.1:1611
Gauss_123
Gauss_123
select USERNAME, ACCOUNT_STATUS from my_users where USERNAME = 'CHEN';
conn chen/Gauss_23@127.0.0.1:1611
conn chen/Gauss_123@127.0.0.1:1611
conn / as sysdba
drop user chen cascade;
spool off