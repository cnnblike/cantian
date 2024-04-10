DROP TABLE IF EXISTS TRANS_RECORD;
CREATE TABLE TRANS_RECORD
(
	SEQ_NO bigint,
	SEQ_FLAG int,
	TR_API_ID varchar(32), 
	TR_API_VERSION varchar(10), 
	TR_TIME timestamp DEFAULT CURRENT_TIMESTAMP, 
	TR_TIME_MS bigint, 
	TR_CHANNEL char(6), 
	DURATION int,
	REF_NO varchar(32), 
	STATE char(1),
	ID_TYPE char(2), 
	ID_NO varchar(50), 
	CUST_NO char(16), 
	CARD_NO1 varchar(19), 
	CARD_NO2 varchar(19), 
	CUST_NAME varchar(100), 
	UID varchar(12),
	RSP_CODE varchar(12), 
	RSP_MSG varchar(512), 
	EXTRA_INFO varchar(1024), 
	RESERVE1 varchar(32), 
	RESERVE2 varchar(64), 
	RESERVE3 varchar(128), 
	REQUEST varchar(1024),
	RESPONSE varchar(4000)
);

ALTER  TABLE TRANS_RECORD ADD PRIMARY KEY (REF_NO, TR_TIME);
CREATE INDEX TRANS_RECORD_INDEX_1 ON TRANS_RECORD(ID_NO, CARD_NO1); 
CREATE INDEX TRANS_RECORD_INDEX_2 ON TRANS_RECORD(TR_TIME); 

select TR_API_ID,
       TR_API_VERSION,
       TR_TIME,
       TR_TIME_MS,
       TR_CHANNEL,
       DURATION,
       REF_NO,
       STATE,
       ID_TYPE,
       ID_NO,
       CUST_NO,
       CARD_NO1,
       CARD_NO2,
       CUST_NAME,
       UID,
       RSP_CODE,
       RSP_MSG,
       EXTRA_INFO,
       RESERVE1,
       RESERVE2,
       RESERVE3,
       REQUEST,
       RESPONSE
  from TRANS_RECORD
 where 1 = 1
   and TR_TIME between to_date('2017-12-11 14:08:00', 'yyyy-mm-dd hh24:mi:ss') and to_date('2017-12-12 14:08:02', 'yyyy-mm-dd hh24:mi:ss')
 order by TR_TIME desc limit 2, 2;


insert into TRANS_RECORD (SEQ_NO, SEQ_FLAG,TR_API_ID, TR_API_VERSION, TR_TIME, TR_TIME_MS, TR_CHANNEL, REF_NO, STATE, ID_TYPE, ID_NO, CUST_NO, CARD_NO1, CARD_NO2, CUST_NAME, UID,RSP_CODE, RSP_MSG, EXTRA_INFO, RESERVE1, RESERVE2, RESERVE3, REQUEST)  
values (1,2,'1', 'V1R1C00', '2017-12-11 14:08:00', 123456789012, '0', 'REF_1', '0', 'T', 'id_no_1', 'cust_no_1', 'card_no1_1', 'card_no2_1', 'cust_name_1', 'UID_1','RSP_CODE_1', 'RSP_MSG_1', 'EXTRA_INFO', 'RESERVE1', 'RESERVE2', 'RESERVE3', 'REQUEST');

insert into TRANS_RECORD (SEQ_NO, SEQ_FLAG,TR_API_ID, TR_API_VERSION, TR_TIME, TR_TIME_MS, TR_CHANNEL, REF_NO, STATE, ID_TYPE, ID_NO, CUST_NO, CARD_NO1, CARD_NO2, CUST_NAME, UID, RSP_CODE, RSP_MSG, EXTRA_INFO, RESERVE1, RESERVE2, RESERVE3, REQUEST)  
values (2,3,'1', 'V1R1C00', '2017-12-11 14:08:01', 123456789012, '0', 'REF_1', '0', 'T', 'id_no_1', 'cust_no_1', 'card_no1_1', 'card_no2_1', 'cust_name_1', 'UID_1','RSP_CODE_1', 'RSP_MSG_1', 'EXTRA_INFO', 'RESERVE1', 'RESERVE2', 'RESERVE3', 'REQUEST');

insert into TRANS_RECORD (SEQ_NO, SEQ_FLAG,TR_API_ID, TR_API_VERSION, TR_TIME, TR_TIME_MS, TR_CHANNEL, REF_NO, STATE, ID_TYPE, ID_NO, CUST_NO, CARD_NO1, CARD_NO2, CUST_NAME, UID, RSP_CODE, RSP_MSG, EXTRA_INFO, RESERVE1, RESERVE2, RESERVE3, REQUEST)  
values (3,4,'1', 'V1R1C00', '2017-12-11 14:08:02', 123456789012, '0', 'REF_1', '0', 'T', 'id_no_2', 'cust_no_1', 'card_no1_1', 'card_no2_1', 'cust_name_1', 'UID_1','RSP_CODE_1', 'RSP_MSG_1', 'EXTRA_INFO', 'RESERVE1', 'RESERVE2', 'RESERVE3', 'REQUEST');

insert into TRANS_RECORD (SEQ_NO, SEQ_FLAG,TR_API_ID, TR_API_VERSION, TR_TIME, TR_TIME_MS, TR_CHANNEL, REF_NO, STATE, ID_TYPE, ID_NO, CUST_NO, CARD_NO1, CARD_NO2, CUST_NAME, UID, RSP_CODE, RSP_MSG, EXTRA_INFO, RESERVE1, RESERVE2, RESERVE3, REQUEST)  
values (4,5,'1', 'V1R1C00', '2017-12-11 14:08:02', 123456789012, '0', 'REF_2', '0', 'P', 'id_no_1', 'cust_no_1', 'card_no1_1', 'card_no2_1', 'cust_name_1', 'UID_1','RSP_CODE_1', 'RSP_MSG_1', 'EXTRA_INFO', 'RESERVE1', 'RESERVE2', 'RESERVE3', 'REQUEST');

insert into TRANS_RECORD (SEQ_NO, SEQ_FLAG,TR_API_ID, TR_API_VERSION, TR_TIME, TR_TIME_MS, TR_CHANNEL, REF_NO, STATE, ID_TYPE, ID_NO, CUST_NO, CARD_NO1, CARD_NO2, CUST_NAME, UID, RSP_CODE, RSP_MSG, EXTRA_INFO, RESERVE1, RESERVE2, RESERVE3, REQUEST)  
values (5,6,'1', 'V1R1C00', '2017-12-12 14:08:02', 123456789012, '0', 'REF_1', '0', 'T', 'id_no_1', 'cust_no_1', 'card_no1_2', 'card_no2_1', 'cust_name_1', 'UID_1','RSP_CODE_1', 'RSP_MSG_1', 'EXTRA_INFO', 'RESERVE1', 'RESERVE2', 'RESERVE3', 'REQUEST');

select TR_API_ID,
       TR_API_VERSION,
       TR_TIME,
       TR_TIME_MS,
       TR_CHANNEL,
       DURATION,
       REF_NO,
       STATE,
       ID_TYPE,
       ID_NO,
       CUST_NO,
       CARD_NO1,
       CARD_NO2,
       CUST_NAME,
       UID,
       RSP_CODE,
       RSP_MSG,
       EXTRA_INFO,
       RESERVE1,
       RESERVE2,
       RESERVE3,
       REQUEST,
       RESPONSE
  from TRANS_RECORD
 where 1 = 1
   and TR_TIME between to_date('2017-12-11 14:08:00','yyyy-mm-dd hh24:mi:ss') and to_date('2017-12-12 14:08:02','yyyy-mm-dd hh24:mi:ss')
 order by TR_TIME desc limit 2, 2;


select TR_API_ID,
       TR_API_VERSION,
       TR_TIME,
       TR_TIME_MS,
       TR_CHANNEL,
       DURATION,
       REF_NO,
       STATE,
       ID_TYPE,
       ID_NO,
       CUST_NO,
       CARD_NO1,
       CARD_NO2,
       CUST_NAME,
       UID,
       RSP_CODE,
       RSP_MSG,
       EXTRA_INFO,
       RESERVE1,
       RESERVE2,
       RESERVE3,
       REQUEST,
       RESPONSE
  from TRANS_RECORD
 where 1 = 1
   and ID_NO = 'id_no_1'
   and ID_TYPE = 'T'
   and CARD_NO1 = 'card_no1_1'
   and CARD_NO2 = 'card_no2_1'
   and TR_API_ID = '1'
   and CUST_NO = 'cust_no_1'
   and REF_NO = 'REF_1'
   and STATE = '0'
   and RSP_CODE = 'RSP_CODE_1'
   and TR_API_ID in (2, 1)
   and TR_TIME between to_date('2017-12-11 14:08:00','yyyy-mm-dd hh24:mi:ss') and to_date('2017-12-11 14:08:02','yyyy-mm-dd hh24:mi:ss')
 order by TR_TIME desc limit 0, 2;

update TRANS_RECORD set DURATION = 3, STATE = '1', CUST_NO = 'cust_no_2', RSP_CODE = 'RSP_CODE_2', RSP_MSG  = 'RSP_MSG_2', RESPONSE = 'RESPONSE' where REF_NO = 'REF_2' and TR_API_ID = '1' and TR_TIME = to_date('2017-12-11 14:08:02','yyyy-mm-dd hh24:mi:ss');
   
select DURATION,STATE,CUST_NO,RSP_CODE,RSP_MSG,RESPONSE from TRANS_RECORD where DURATION = 3;

select * from TRANS_RECORD where 1=1 and REF_NO = 'REF_2' and TR_API_ID = '1' and TR_TIME = to_date('2017-12-11 14:08:02','yyyy-mm-dd hh24:mi:ss') order by TR_TIME desc limit 1;

select SEQ_NO,
       SEQ_FLAG,
       TR_API_ID,
       TR_API_VERSION,
       TR_TIME,
       TR_CHANNEL,
       DURATION,
       REF_NO,
       STATE,
       ID_TYPE,
       ID_NO,
       CUST_NO,
       CARD_NO1,
       CARD_NO2,
       CUST_NAME,
       UID,
       RSP_CODE,
       RSP_MSG,
       EXTRA_INFO,
       RESERVE1,
       RESERVE2,
       RESERVE3,
       REQUEST,
       RESPONSE
  from TRANS_RECORD
 where TR_TIME >= to_date('2017-12-11 14:08:00','yyyy-mm-dd hh24:mi:ss')
   and TR_TIME < to_date('2017-12-12 14:08:02','yyyy-mm-dd hh24:mi:ss')
   and SEQ_NO > 1
 order by SEQ_NO asc, SEQ_FLAG asc limit 1000;

select * from trans_record where TR_TIME between to_date('2017-12-11 14:08:00','yyyy-mm-dd hh24:mi:ss') and  to_date('2017-12-12 14:08:02','yyyy-mm-dd hh24:mi:ss') order by TR_TIME, SEQ_NO desc limit 2,2;

select tr_time, tr_api_id, tr_channel, rsp_code, count(1) as total_num
  from TRANS_RECORD
 where TR_TIME between to_date('2017-12-11 14:08:00','yyyy-mm-dd hh24:mi:ss') and to_date('2017-12-12 14:08:02','yyyy-mm-dd hh24:mi:ss')
 group by tr_time, tr_api_id, tr_channel, rsp_code
 order by TR_TIME desc, tr_channel,RSP_CODE;


 (select SEQ_NO,
        SEQ_FLAG,
        TR_API_ID,
        TR_API_VERSION,
        TR_TIME,
        TR_TIME_MS,
        TR_CHANNEL,
        DURATION,
        REF_NO,
        STATE,
        ID_TYPE,
        ID_NO,
        CUST_NO,
        CARD_NO1,
        CARD_NO2,
        CUST_NAME,
        UID,
        RSP_CODE,
        RSP_MSG,
        EXTRA_INFO,
        RESERVE1,
        RESERVE2,
        RESERVE3,
        REQUEST,
        RESPONSE
   from TRANS_RECORD
  where 1 = 1
    and ID_NO = 'id_no_1'
    and ID_TYPE = 'T'
    and CARD_NO1 = 'card_no1_1'
    and CARD_NO2 = 'card_no2_1'
    and TR_API_ID = 1
    and CUST_NO = 'cust_no_1'
    and REF_NO = 'REF_1'
    and STATE = '0'
    and RSP_CODE = 'RSP_CODE_1'
    and TR_API_ID in (1,2)
    and TR_TIME >= to_date('2017-12-11 14:08:00','yyyy-mm-dd hh24:mi:ss')
    and TR_TIME < to_date('2017-12-12 14:08:02','yyyy-mm-dd hh24:mi:ss')
 )
 union all 
(
select SEQ_NO,
       SEQ_FLAG,
       TR_API_ID,
       TR_API_VERSION,
       TR_TIME,
       TR_TIME_MS,
       TR_CHANNEL,
       DURATION,
       REF_NO,
       STATE,
       ID_TYPE,
       ID_NO,
       CUST_NO,
       CARD_NO1,
       CARD_NO2,
       CUST_NAME,
       UID,
       RSP_CODE,
       RSP_MSG,
       EXTRA_INFO,
       RESERVE1,
       RESERVE2,
       RESERVE3,
       REQUEST,
       RESPONSE
  from TRANS_RECORD
 where 1 = 1
    and ID_NO = 'id_no_1'
    and ID_TYPE = 'T'
    and CARD_NO1 = 'card_no1_1'
    and CARD_NO2 = 'card_no2_1'
    and TR_API_ID = 1
    and CUST_NO = 'cust_no_1'
    and REF_NO = 'REF_1'
    and STATE = '0'
    and RSP_CODE = 'RSP_CODE_1'
    and TR_API_ID in (1,2)
    and TR_TIME >= to_date('2017-12-11 14:08:01','yyyy-mm-dd hh24:mi:ss')
    and TR_TIME < to_date('2017-12-12 14:08:03','yyyy-mm-dd hh24:mi:ss')
)
order by TR_TIME desc  limit 1,1;

commit;