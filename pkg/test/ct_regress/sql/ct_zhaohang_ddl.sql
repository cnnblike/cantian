drop table if exists TRANS_RECORD_LOG;

/*==============================================================*/
/* Table: TRANS_RECORD_LOG                                      */
/*==============================================================*/
create table TRANS_RECORD_LOG
(
   REF_NO               varchar(32) not null comment 'Sharding Key',
   TR_TIME              timestamp(3) not null default CURRENT_TIMESTAMP(3) comment 'Partitioning Key (Per Day)',
   TR_API_ID            varchar(32) not null,
   TR_API_VERSION       varchar(10),
   TR_CHANNEL           char(6),
   REQUEST              varchar(1024) not null,
   CREATE_TIME          timestamp(3) not null default CURRENT_TIMESTAMP(3),
   ID_TYPE              char(2),
   ID_NO                varchar(50),
   CUST_NAME            varchar(100),
   CUST_NO              char(16),
   UID                  varchar(12),
   CARD_NO1             varchar(50),
   CARD1_BANK_NAME      varchar(100),
   CARD1_CD_FLAG        char(1),
   CARD_NO2             varchar(50),
   CARD2_BANK_NAME      varchar(100),
   CARD2_CD_FLAG        char(1),
   ORIGINAL_REF_NO      varchar(32),
   CUST_TC_CODE         char(4),
   TX_CHNL1             varchar(5),
   TX_CHNL2             varchar(5),
   CHNL_RSP_CODE        varchar(16),
   CHNL_RSP_MSG         varchar(512),
   EXTRA_INFO           varchar(1024),
   RESERVE1             varchar(32),
   RESERVE2             varchar(64),
   RESERVE3             varchar(128),
   RSP_CODE             varchar(12),
   RSP_MSG              varchar(512),
   VERSION_TIME         timestamp(3) null,
   UPDATE_TIME          timestamp(3) default CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
   DONE_TIME            timestamp(3) null,
   DURATION             int not null default 0,
   STATE                char(1) not null default 'N' comment 'N: Not Available, S: Success, F: Failure, Z: post result failure',
   RESPONSE             clob,
   primary key (REF_NO, TR_TIME)
);

/*==============================================================*/
/* Index: TR_RECL_IDNO_IDX                                      */
/*==============================================================*/
create index TR_RECL_IDNO_IDX on TRANS_RECORD_LOG
(
   ID_NO ASC
);

/*==============================================================*/
/* Index: TR_RECL_CRNO1_IDX                                     */
/*==============================================================*/
create index TR_RECL_CRNO1_IDX on TRANS_RECORD_LOG
(
   CARD_NO1 ASC
);

/*==============================================================*/
/* Index: TR_RECL_CRNO2_IDX                                     */
/*==============================================================*/
create index TR_RECL_CRNO2_IDX on TRANS_RECORD_LOG
(
   CARD_NO2 ASC
);

/*==============================================================*/
/* Index: TR_RECL_TRTM_IDX                                      */
/*==============================================================*/
create index TR_RECL_TRTM_IDX on TRANS_RECORD_LOG
(
   TR_TIME ASC
);

drop index TR_RECL_TRTM_IDX on TRANS_RECORD_LOG;

drop index TR_RECL_CRNO2_IDX on TRANS_RECORD_LOG;

drop index TR_RECL_CRNO1_IDX on TRANS_RECORD_LOG;

drop index TR_RECL_IDNO_IDX on TRANS_RECORD_LOG;

drop table if exists TRANS_RECORD_LOG;

----------------------------------------------------------------------------
----------------------------------------------------------------------------

drop index QR_RECL_CRNO_IDX on QUERY_RECORD_LOG;

drop index QR_RECL_IDNO_IDX on QUERY_RECORD_LOG;

drop table if exists QUERY_RECORD_LOG;

/*==============================================================*/
/* Table: QUERY_RECORD_LOG                                      */
/*==============================================================*/
create table QUERY_RECORD_LOG
(
   REF_NO               varchar(32) not null,
   TR_TIME              timestamp(3) not null default CURRENT_TIMESTAMP(3) comment 'Sharding Key and Partitioning Key (Per Day)',
   TR_API_ID            varchar(32) not null,
   TR_API_VERSION       varchar(10),
   TR_CHANNEL           char(6),
   REQUEST              varchar(1024) not null,
   CREATE_TIME          timestamp(3) not null default CURRENT_TIMESTAMP(3),
   ID_TYPE              char(2),
   ID_NO                varchar(50),
   CUST_NAME            varchar(100),
   CUST_NO              char(16),
   UID                  varchar(12),
   CARD_NO              varchar(50),
   CARD_BANK_NAME       varchar(100),
   CARD_CD_FLAG         char(1),
   EXTRA_INFO           varchar(1024),
   RESERVE1             varchar(32),
   RESERVE2             varchar(64),
   RESERVE3             varchar(128),
   RSP_CODE             varchar(12),
   RSP_MSG              varchar(512),
   UPDATE_TIME          timestamp(3) default CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
   DONE_TIME            timestamp(3) null,
   DURATION             int not null default 0,
   STATE                char(1) not null default 'N' comment 'N: Not Available, S: Success, F: Failure, Z: post result failure',
   RESPONSE             clob,
   primary key (REF_NO, TR_TIME)
);

/*==============================================================*/
/* Index: QR_RECL_IDNO_IDX                                      */
/*==============================================================*/
create index QR_RECL_IDNO_IDX on QUERY_RECORD_LOG
(
   ID_NO ASC
);

/*==============================================================*/
/* Index: QR_RECL_CRNO_IDX                                      */
/*==============================================================*/
create index QR_RECL_CRNO_IDX on QUERY_RECORD_LOG
(
   CARD_NO ASC
);

drop index QR_RECL_CRNO_IDX on QUERY_RECORD_LOG;

drop index QR_RECL_IDNO_IDX on QUERY_RECORD_LOG;

drop table if exists QUERY_RECORD_LOG;