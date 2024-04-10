alter system set ENABLE_SYSDBA_LOGIN=FALSE;
conn / as sysdba
conn sys/sys@127.0.0.1:1611
alter system set ENABLE_SYSDBA_LOGIN=TRUE;
conn / as sysdba
alter system REFRESH SYSDBA PRIVILEGE;
conn / as sysdba
