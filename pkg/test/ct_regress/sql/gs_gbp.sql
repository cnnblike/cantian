--USE_GBP
alter system set USE_GBP = TRUE;
select value from v$parameter where name = 'USE_GBP';
alter system set USE_GBP = FALSE;
select value from v$parameter where name = 'USE_GBP';

--GBP_ADDR
alter system set GBP_ADDR = 127.0.0.1;
alter system set GBP_ADDR = '-1.0.0.1';
alter system set GBP_ADDR = '';
alter system set GBP_ADDR = '0.0.0.0,0.0.0.256';
alter system set GBP_ADDR = '1.1.1.1,2.2.2.2,3.3.3.3,4.4.4.4,5.5.5.5,6.6.6.6,7.7.7.7,8.8.8.8,9.9.9.9';
alter system set GBP_ADDR = '1.1.1.1,2.2.2.2';
alter system set GBP_ADDR = '127.0.0.1';

--GBP_PORT
alter system set GBP_PORT = 65536;
alter system set GBP_PORT = 65535;
alter system set GBP_PORT = 1024;
alter system set GBP_PORT = 1023;
alter system set GBP_PORT = 2061;

--_GBP_TRANS_TYPE
alter system set _GBP_TRANS_TYPE = XXXX;
alter system set _GBP_TRANS_TYPE = TCP;
alter system set _GBP_TRANS_TYPE = RDMA;
alter system set _GBP_TRANS_TYPE = tcp;
alter system set _GBP_TRANS_TYPE = rdma;

--_GBP_FOR_RECOVERY
alter system set _GBP_FOR_RECOVERY = TRUE;
select value from v$parameter where name = '_GBP_FOR_RECOVERY';
alter system set _GBP_FOR_RECOVERY = FALSE;
select value from v$parameter where name = '_GBP_FOR_RECOVERY';

--_MRP_RES_LOGSIZE
alter system debug mode _MRP_RES_LOGSIZE = -1;
alter system debug mode _MRP_RES_LOGSIZE = 9223372036854775808;
alter system debug mode _MRP_RES_LOGSIZE = 0M;
alter system debug mode _GBP_RCY_CHECK = FALSE;

--DV_GBP_ANALYZE_INFO
select STATISTIC#, NAME from DV_GBP_ANALYZE_INFO;

--DV_GBPSTAT
select STATISTIC#, NAME from DV_GBP_STATS;
