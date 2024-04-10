
--DTS2018101803228,hash join core
--1 prepare table and data
DROP TABLE IF EXISTS T__PREPARADEFAULTBTSBRD_A41;
CREATE GLOBAL TEMPORARY TABLE T__PREPARADEFAULTBTSBRD_A41
(
  VERSION VARCHAR(48 BYTE) NOT NULL,
  BTSTYPE NUMBER(10) NOT NULL,
  CABCLASS VARCHAR(48 BYTE) NOT NULL,
  SHELFNAME VARCHAR(96 BYTE) NOT NULL,
  CMEUID NUMBER(10) NOT NULL
)ON COMMIT DELETE ROWS;

DROP TABLE IF EXISTS T_BSCBTS_BTSCABINETMODULEMAP;
CREATE TABLE T_BSCBTS_BTSCABINETMODULEMAP
(
  VERSION VARCHAR(48 BYTE) NOT NULL,
  BTSTYPE NUMBER(10) NOT NULL,
  CABCLASS VARCHAR(48 BYTE) NOT NULL,
  SHELFNAME VARCHAR(96 BYTE) NOT NULL,
  CMEUID NUMBER(10) NOT NULL,
  constraint   PK_T_BSCBTS_BTSCABINETMODULEMAP PRIMARY KEY(VERSION, CMEUID)
)
INITRANS 2
MAXTRANS 255
PCTFREE 8;
INSERT INTO T_BSCBTS_BTSCABINETMODULEMAP (VERSION,BTSTYPE,CABCLASS,SHELFNAME,CMEUID) values('A8',9,'MainGrpMainCab','g_Site3002C_shf',20012);
INSERT INTO T_BSCBTS_BTSCABINETMODULEMAP (VERSION,BTSTYPE,CABCLASS,SHELFNAME,CMEUID) values('A8',8,'SubGrpMainCab','g_Site3001CP_shf',20011);
INSERT INTO T_BSCBTS_BTSCABINETMODULEMAP (VERSION,BTSTYPE,CABCLASS,SHELFNAME,CMEUID) values('A8',8,'SubCab','g_Site3001CP_shf',20010);
INSERT INTO T_BSCBTS_BTSCABINETMODULEMAP (VERSION,BTSTYPE,CABCLASS,SHELFNAME,CMEUID) values('A8',8,'MainGrpMainCab','g_Site3001CP_shf',20009);
INSERT INTO T_BSCBTS_BTSCABINETMODULEMAP (VERSION,BTSTYPE,CABCLASS,SHELFNAME,CMEUID) values('A8',7,'SubGrpMainCab','g_Site3001CP_shf',20008);
COMMIT;
CREATE INDEX IDX_BSCBTS_BTSCABINETMODULEMAP ON T_BSCBTS_BTSCABINETMODULEMAP(VERSION, BTSTYPE, CABCLASS, SHELFNAME)
INITRANS 2
PCTFREE 8;

DROP TABLE IF EXISTS T__PREPARADEFAULTBTSBRD_A44;
CREATE GLOBAL TEMPORARY TABLE T__PREPARADEFAULTBTSBRD_A44
(
  VERSION VARCHAR(48 BYTE) NOT NULL,
  BTSTYPE NUMBER(10) NOT NULL,
  CABNUMINGRP NUMBER(10),
  CMEUID NUMBER(10) NOT NULL
)ON COMMIT DELETE ROWS;

DROP TABLE IF EXISTS T_BSCBTS_CABNUMINGRPMAP;
CREATE TABLE T_BSCBTS_CABNUMINGRPMAP
(
  VERSION VARCHAR(48 BYTE) NOT NULL,
  BTSTYPE NUMBER(10) NOT NULL,
  CABNUMINGRP NUMBER(10),
  CMEUID NUMBER(10) NOT NULL,
  constraint   PK_T_BSCBTS_CABNUMINGRPMAP PRIMARY KEY(VERSION, CMEUID)
)
INITRANS 2
MAXTRANS 255
PCTFREE 8;
INSERT INTO T_BSCBTS_CABNUMINGRPMAP (VERSION,BTSTYPE,CABNUMINGRP,CMEUID) values('A4',0,255,20000);
INSERT INTO T_BSCBTS_CABNUMINGRPMAP (VERSION,BTSTYPE,CABNUMINGRP,CMEUID) values('A4',2,255,20001);
INSERT INTO T_BSCBTS_CABNUMINGRPMAP (VERSION,BTSTYPE,CABNUMINGRP,CMEUID) values('A4',3,3,20002);
INSERT INTO T_BSCBTS_CABNUMINGRPMAP (VERSION,BTSTYPE,CABNUMINGRP,CMEUID) values('A4',5,2,20003);
INSERT INTO T_BSCBTS_CABNUMINGRPMAP (VERSION,BTSTYPE,CABNUMINGRP,CMEUID) values('A4',7,255,20004);
INSERT INTO T_BSCBTS_CABNUMINGRPMAP (VERSION,BTSTYPE,CABNUMINGRP,CMEUID) values('A4',8,255,20005);
COMMIT;
CREATE INDEX IDX_BSCBTS_CABNUMINGRPMAP ON T_BSCBTS_CABNUMINGRPMAP(VERSION, BTSTYPE)
INITRANS 2
PCTFREE 8;

--2 show explain
delete from t__PreparaDefaultBTSBRD_A41;
insert into t__PreparaDefaultBTSBRD_A41 (VERSION,BTSTYPE,CabClass,ShelfName,CMEUID) 
select VERSION, BTSTYPE, CabClass, ShelfName, CMEUID from t_BSCBTS_BTSCabinetModuleMap where VERSION = 'A4';

delete from t__PreparaDefaultBTSBRD_A44;
insert into t__PreparaDefaultBTSBRD_A44 (VERSION,BTSTYPE,CabNumInGrp,CMEUID) 
select VERSION, BTSTYPE, CabNumInGrp, CMEUID from t_BSCBTS_CabNumInGrpMap where VERSION = 'A4';
	
--3 check if fixed	
delete from t__PreparaDefaultBTSBRD_A41;
insert into t__PreparaDefaultBTSBRD_A41 (VERSION,BTSTYPE,CabClass,ShelfName,CMEUID) 
select VERSION, BTSTYPE, CabClass, ShelfName, CMEUID from t_BSCBTS_BTSCabinetModuleMap where VERSION = 'A4';

delete from t__PreparaDefaultBTSBRD_A44;
insert into t__PreparaDefaultBTSBRD_A44 (VERSION,BTSTYPE,CabNumInGrp,CMEUID) 
select VERSION, BTSTYPE, CabNumInGrp, CMEUID from t_BSCBTS_CabNumInGrpMap where VERSION = 'A4';

select  
		1
from             
		t__PreparaDefaultBTSBRD_A41 c, 
		t__PreparaDefaultBTSBRD_A44 f 
where
    f.VERSION = c.VERSION	 and 
	c.CabClass = (case when mod(0, f.CabNumInGrp) <> 0 then 'SubCab' end);


--DTS2018101803264,nested loop join core
--1 prepare table and data
DROP TABLE IF EXISTS T_NCELLEXPRESS_GCELLKEYINFO;
CREATE TABLE T_NCELLEXPRESS_GCELLKEYINFO
(
  PLANID NUMBER(10) NOT NULL,
  CMENEID NUMBER(10) NOT NULL,
  CELLID NUMBER(10) NOT NULL,
  CELLNAME VARCHAR(96 BYTE),
  ISNCELL NUMBER(10),
  MCC VARCHAR(5 BYTE) NOT NULL,
  MNC VARCHAR(5 BYTE) NOT NULL,
  LAC NUMBER(10) NOT NULL,
  CI NUMBER(10) NOT NULL,
  NCC NUMBER(5),
  BCC NUMBER(5),
  RA NUMBER(5),
  BCCHNO NUMBER(10),
  NCMENEID NUMBER(10),
  constraint PK_T_NCELLEXPRESS_GCELLKEYINFO PRIMARY KEY(PLANID, CMENEID, CELLID, MCC, MNC, LAC, CI)
)
INITRANS 2
MAXTRANS 255
PCTFREE 8;

DROP TABLE IF EXISTS T_TMP_LOADG2GNCELL;
CREATE TABLE T_TMP_LOADG2GNCELL
(
  PLANID NUMBER(10) NOT NULL,
  ROWINDEX NUMBER(10) NOT NULL,
  BSCNAME VARCHAR(383 BYTE),
  ISNCELL NUMBER(10),
  CELLID NUMBER(10),
  CELLNAME VARCHAR(96 BYTE),
  MCC VARCHAR(5 BYTE),
  MNC VARCHAR(5 BYTE),
  LAC NUMBER(10),
  CI NUMBER(10),
  BCC NUMBER(10),
  NCC NUMBER(10),
  BCCH NUMBER(10),
  constraint PK_T_TMP_LOADG2GNCELL PRIMARY KEY(PLANID, ROWINDEX)
)
INITRANS 2
MAXTRANS 255
PCTFREE 8;

DROP TABLE IF EXISTS SYS_NEINFO_BSC;
CREATE TABLE SYS_NEINFO_BSC
(
  PLANID NUMBER(10) NOT NULL,
  CMENEID NUMBER(10) NOT NULL,
  PHYNEID NUMBER(10) NOT NULL DEFAULT 0,
  TYPE NUMBER(10) NOT NULL,
  NAME VARCHAR(383 BYTE) NOT NULL,
  FDN VARCHAR(96 BYTE) NOT NULL,
  VERSION VARCHAR(24 BYTE) NOT NULL,
  COMPVERSION VARCHAR(96 BYTE),
  NEVERSION VARCHAR(450 BYTE),
  NEFAMILYVERSION VARCHAR(450 BYTE),
  DSPVERSION VARCHAR(450 BYTE),
  ITFVERSION VARCHAR(96 BYTE),
  BASICID NUMBER(10) DEFAULT 0,
  TYPEDSPNAME VARCHAR(96 BYTE),
  OMIP VARCHAR(48 BYTE),
  OMIP2 VARCHAR(48 BYTE),
  SYNCHSTATUS NUMBER(10) DEFAULT 0,
  LASTSYNCTIME NUMBER(10) DEFAULT 0,
  STATUS NUMBER(10) DEFAULT 0,
  RNCPOOLTYPE NUMBER(10) DEFAULT 77,
  CLASSIFY NUMBER(10) DEFAULT 0,
  REMARK VARCHAR(383 BYTE),
  DBAREA VARCHAR(48 BYTE),
  constraint PK_SYS_NEINFO_BSC PRIMARY KEY(PLANID, CMENEID)
)
INITRANS 2
MAXTRANS 255
PCTFREE 8;
INSERT INTO SYS_NEINFO_BSC (PLANID,CMENEID,PHYNEID,TYPE,NAME,FDN,VERSION,COMPVERSION,NEVERSION,NEFAMILYVERSION,DSPVERSION,ITFVERSION,BASICID,TYPEDSPNAME,OMIP,OMIP2,SYNCHSTATUS,LASTSYNCTIME,STATUS,RNCPOOLTYPE,CLASSIFY,REMARK,DBAREA) values(37,126,126,173,'Auto_919C10SPC500_Reparent_Destination','GU_20180925110359_607110_001','A4','BSC6900V900R019C10SPC500','BSC6900V900R019C10SPC500','BSC6900V900R019C10SPC500','BSC6900V900R019C10SPC500','BSC6900-GUV9R19C10ID0500',-1,'BSC6900GUNE',null,null,0,1537844664,32,100,3,null,'cmedb');
INSERT INTO SYS_NEINFO_BSC (PLANID,CMENEID,PHYNEID,TYPE,NAME,FDN,VERSION,COMPVERSION,NEVERSION,NEFAMILYVERSION,DSPVERSION,ITFVERSION,BASICID,TYPEDSPNAME,OMIP,OMIP2,SYNCHSTATUS,LASTSYNCTIME,STATUS,RNCPOOLTYPE,CLASSIFY,REMARK,DBAREA) values(41,146,146,173,'Auto_919C10SPC500_Reparent_Destination','GU_20180926112606_019604_001','A4','BSC6900V900R019C10SPC500','BSC6900V900R019C10SPC500','BSC6900V900R019C10SPC500','BSC6900V900R019C10SPC500','BSC6900-GUV9R19C10ID0500',-1,'BSC6900GUNE',null,null,0,1537932405,32,100,3,null,'cmedb');
INSERT INTO SYS_NEINFO_BSC (PLANID,CMENEID,PHYNEID,TYPE,NAME,FDN,VERSION,COMPVERSION,NEVERSION,NEFAMILYVERSION,DSPVERSION,ITFVERSION,BASICID,TYPEDSPNAME,OMIP,OMIP2,SYNCHSTATUS,LASTSYNCTIME,STATUS,RNCPOOLTYPE,CLASSIFY,REMARK,DBAREA) values(45,166,166,173,'Auto_919C10SPC500_Reparent_Destination','GU_20180927085503_942653_002','A4','BSC6900V900R019C10SPC500','BSC6900V900R019C10SPC500','BSC6900V900R019C10SPC500','BSC6900V900R019C10SPC500','BSC6900-GUV9R19C10ID0500',934,'BSC6900GUNE',null,null,0,1538009732,32,100,3,null,'cmedb');
INSERT INTO SYS_NEINFO_BSC (PLANID,CMENEID,PHYNEID,TYPE,NAME,FDN,VERSION,COMPVERSION,NEVERSION,NEFAMILYVERSION,DSPVERSION,ITFVERSION,BASICID,TYPEDSPNAME,OMIP,OMIP2,SYNCHSTATUS,LASTSYNCTIME,STATUS,RNCPOOLTYPE,CLASSIFY,REMARK,DBAREA) values(53,265,265,173,'Auto_919C10SPC500_Reparent_Destination - 19','GU_20180927180040_528010_033','A4','BSC6900V900R019C10SPC500','BSC6900V900R019C10SPC500','BSC6900V900R019C10SPC500','BSC6900V900R019C10SPC500','BSC6900-GUV9R19C10ID0500',-1,'BSC6900GUNE',null,null,0,1538043115,32,100,3,null,'cmedb');
INSERT INTO SYS_NEINFO_BSC (PLANID,CMENEID,PHYNEID,TYPE,NAME,FDN,VERSION,COMPVERSION,NEVERSION,NEFAMILYVERSION,DSPVERSION,ITFVERSION,BASICID,TYPEDSPNAME,OMIP,OMIP2,SYNCHSTATUS,LASTSYNCTIME,STATUS,RNCPOOLTYPE,CLASSIFY,REMARK,DBAREA) values(53,274,274,173,'Auto_919C10SPC500_Reparent_Destination - 9','GU_20180927180040_533954_042','A4','BSC6900V900R019C10SPC500','BSC6900V900R019C10SPC500','BSC6900V900R019C10SPC500','BSC6900V900R019C10SPC500','BSC6900-GUV9R19C10ID0500',-1,'BSC6900GUNE',null,null,0,1538043115,32,100,3,null,'cmedb');
INSERT INTO SYS_NEINFO_BSC (PLANID,CMENEID,PHYNEID,TYPE,NAME,FDN,VERSION,COMPVERSION,NEVERSION,NEFAMILYVERSION,DSPVERSION,ITFVERSION,BASICID,TYPEDSPNAME,OMIP,OMIP2,SYNCHSTATUS,LASTSYNCTIME,STATUS,RNCPOOLTYPE,CLASSIFY,REMARK,DBAREA) values(53,273,273,173,'Auto_919C10SPC500_Reparent_Destination - 8','GU_20180927180040_533930_041','A4','BSC6900V900R019C10SPC500','BSC6900V900R019C10SPC500','BSC6900V900R019C10SPC500','BSC6900V900R019C10SPC500','BSC6900-GUV9R19C10ID0500',-1,'BSC6900GUNE',null,null,0,1538043115,32,100,3,null,'cmedb');
INSERT INTO SYS_NEINFO_BSC (PLANID,CMENEID,PHYNEID,TYPE,NAME,FDN,VERSION,COMPVERSION,NEVERSION,NEFAMILYVERSION,DSPVERSION,ITFVERSION,BASICID,TYPEDSPNAME,OMIP,OMIP2,SYNCHSTATUS,LASTSYNCTIME,STATUS,RNCPOOLTYPE,CLASSIFY,REMARK,DBAREA) values(53,272,272,173,'Auto_919C10SPC500_Reparent_Destination - 7','GU_20180927180040_533899_040','A4','BSC6900V900R019C10SPC500','BSC6900V900R019C10SPC500','BSC6900V900R019C10SPC500','BSC6900V900R019C10SPC500','BSC6900-GUV9R19C10ID0500',-1,'BSC6900GUNE',null,null,0,1538043115,32,100,3,null,'cmedb');
COMMIT;

--3 check if fixed
select  1 
from t_NCELLEXPRESS_GCELLKeyInfo a
 join 
t_tmp_LoadG2GNCELL b on a.PlanID = b.PlanID
 join 
(select 
	aa.PlanID as PlanID, 
	aa.CMENEID as CMENEID, 
	aa.Type as NEType, 
	aa.PhyNEID as PhyNEID, 
	aa.Name as BSCName, 
	aa.Version as BSCVersion,
	aa.DspVersion as BSCDspVersion, 
	aa.FDN as BSCFDN, 
	aa.BasicId as neRawID, 
	aa.ItfVersion as InternalID, 
	aa.Remark as Remark, 
	aa.Classify as DataSource 
 from 
	Sys_NEInfo_BSC aa 
 where 
	aa.PlanID <> 0 and aa.CMENEID = aa.PhyNEID) c on a.PlanID = c.PlanID and a.CMENEID = c.CMENEID 
where 
c.BSCName = (case when b.BSCName is not null then b.BSCName else c.BSCName end);

DROP TABLE IF EXISTS "TMP_PREERRLOG_SITE";
CREATE GLOBAL TEMPORARY TABLE "TMP_PREERRLOG_SITE"
(
  "OBJECTGROUPID" NUMBER(10) NOT NULL,
  "CMENEID" NUMBER(10) NOT NULL,
  "ENTITYMOOPID" NUMBER(10),
  "OBJECTID" NUMBER(10),
  "MOCNAME" VARCHAR(75 BYTE) NOT NULL,
  "MOID" VARCHAR(3000 BYTE) NOT NULL,
  "ERRCODE" NUMBER(10) NOT NULL
)ON COMMIT DELETE ROWS;

DROP TABLE IF EXISTS "TMP_CELLLTEFLEXBW_A12K";
CREATE TABLE "TMP_CELLLTEFLEXBW_A12K"
(
  "PLANID" NUMBER(10) NOT NULL,
  "PHYID" NUMBER(10) NOT NULL,
  "CMENEID" NUMBER(10) NOT NULL,
  "ENTITYMOOPID" NUMBER(10),
  "OBJECTID" NUMBER(10) NOT NULL,
  "DLCUSTENDPRBINDEX" NUMBER(10),
  "DLCUSTSTARTPRBINDEX" NUMBER(10),
  "LOCALCELLID" NUMBER(10) NOT NULL,
  "LTEFLEXBWSWITCH" NUMBER(10),
  "ULCUSTENDPRBINDEX" NUMBER(10),
  "ULCUSTSTARTPRBINDEX" NUMBER(10)
)
INITRANS 2
MAXTRANS 255
PCTFREE 8;
CREATE INDEX "IDX2#_M_235_0_A12K" ON TMP_CELLLTEFLEXBW_A12K("PLANID", "PHYID", "LOCALCELLID")
INITRANS 2
PCTFREE 8;
ALTER TABLE "TMP_CELLLTEFLEXBW_A12K" ADD CONSTRAINT "PK#_M_235_A12K" PRIMARY KEY("PLANID", "OBJECTID");

DROP TABLE IF EXISTS "RULECHECK_OBJGROUP";
CREATE TABLE "RULECHECK_OBJGROUP"
(
  "GROUPID" NUMBER(10) NOT NULL,
  "OBJECTID" NUMBER(10) NOT NULL,
  "MOOPID" NUMBER(10) NOT NULL
)
INITRANS 2
MAXTRANS 255
PCTFREE 8;
ALTER TABLE "RULECHECK_OBJGROUP" ADD CONSTRAINT "PK_RULECHECK_OBJGROUP" PRIMARY KEY("GROUPID", "OBJECTID", "MOOPID");

DROP TABLE IF EXISTS "TMP_CELLLTEFLEXBWITFCFG_A12K";
CREATE TABLE "TMP_CELLLTEFLEXBWITFCFG_A12K"
(
  "PLANID" NUMBER(10) NOT NULL,
  "PHYID" NUMBER(10) NOT NULL,
  "CMENEID" NUMBER(10) NOT NULL,
  "ENTITYMOOPID" NUMBER(10),
  "OBJECTID" NUMBER(10) NOT NULL,
  "GSMCARRIERFREQ" NUMBER(10) NOT NULL,
  "HIGHITFGSMARFCN" NUMBER(10) NOT NULL,
  "LOCALCELLID" NUMBER(10) NOT NULL
)
INITRANS 2
MAXTRANS 255
PCTFREE 8;
CREATE INDEX "IDX2#_M_236_012_A12K" ON TMP_CELLLTEFLEXBWITFCFG_A12K("PLANID", "PHYID", "LOCALCELLID", "HIGHITFGSMARFCN", "GSMCARRIERFREQ")
INITRANS 2
PCTFREE 8;
ALTER TABLE "TMP_CELLLTEFLEXBWITFCFG_A12K" ADD CONSTRAINT "PK#_M_236_A12K" PRIMARY KEY("PLANID", "OBJECTID");

DROP TABLE IF EXISTS "TMP_CELL_A12K";
CREATE TABLE "TMP_CELL_A12K"
(
  "PLANID" NUMBER(10) NOT NULL,
  "PHYID" NUMBER(10) NOT NULL,
  "CMENEID" NUMBER(10) NOT NULL,
  "ENTITYMOOPID" NUMBER(10),
  "OBJECTID" NUMBER(10) NOT NULL,
  "AIRCELLFLAG" NUMBER(10),
  "CELLACTIVESTATE" NUMBER(10),
  "CELLID" NUMBER(10),
  "CELLRADIUS" NUMBER(10),
  "CELLRADIUSSTARTLOCATION" NUMBER(10),
  "CNOPSHARINGGROUPID" NUMBER(10),
  "COMPACTBWCTRLINTRFMODE" NUMBER(10),
  "COVERAGELEVELTYPE" NUMBER(10),
  "CPRICOMPRESSION" NUMBER(10),
  "CPRIETHCOMPRESSIONRATIO" NUMBER(10),
  "CRSPORTMAP" NUMBER(10),
  "CRSPORTNUM" NUMBER(10),
  "CSGIND" NUMBER(10),
  "CUSTOMIZEDBANDWIDTHCFGIND" NUMBER(10),
  "CUSTOMIZEDDLBANDWIDTH" NUMBER(10),
  "CUSTOMIZEDULBANDWIDTH" NUMBER(10),
  "DLBANDWIDTH" NUMBER(10),
  "DLCYCLICPREFIX" NUMBER(10),
  "DLEARFCN" NUMBER(10),
  "DLPUNCTUREDRBNUM" NUMBER(10),
  "EMERGENCYAREAID" NUMBER(10),
  "EMERGENCYAREAIDCFGIND" NUMBER(10),
  "EUCELLSTANDBYMODE" NUMBER(10),
  "FDDTDDIND" NUMBER(10),
  "FREQBAND" NUMBER(10),
  "HIGHSPEEDFLAG" NUMBER(10),
  "HSCELLROOTSEQUENCEINDEX" NUMBER(10),
  "INTRAFREQANRIND" NUMBER(10),
  "LOCALCELLID" NUMBER(10) NOT NULL,
  "MULTICELLSHAREMODE" NUMBER(10),
  "MULTIRRUCELLFLAG" NUMBER(10),
  "MULTIRRUCELLMODE" NUMBER(10),
  "NBCELLFLAG" NUMBER(10),
  "PHYCELLID" NUMBER(10),
  "PREAMBLEFMT" NUMBER(10),
  "ROOTSEQUENCEIDX" NUMBER(10),
  "SECTOREQMNUM" NUMBER(10),
  "SPECIALSUBFRAMEPATTERNS" NUMBER(10),
  "SPECIFIEDCELLFLAG" NUMBER(10),
  "SUBFRAMEASSIGNMENT" NUMBER(10),
  "TXRXMODE" NUMBER(10),
  "UEPOWERMAX" NUMBER(10),
  "UEPOWERMAXCFGIND" NUMBER(10),
  "ULBANDWIDTH" NUMBER(10),
  "ULCYCLICPREFIX" NUMBER(10),
  "ULEARFCN" NUMBER(10),
  "ULEARFCNCFGIND" NUMBER(10),
  "ULPUNCTUREDRBNUMOFFSET" NUMBER(10),
  "WORKMODE" NUMBER(10)
)
INITRANS 2
MAXTRANS 255
PCTFREE 8;
CREATE INDEX "IDX2#_M_13_0_A12K" ON TMP_CELL_A12K("PLANID", "PHYID", "LOCALCELLID")
INITRANS 2
PCTFREE 8;
ALTER TABLE "TMP_CELL_A12K" ADD CONSTRAINT "PK#_M_13_A12K" PRIMARY KEY("PLANID", "OBJECTID");

DROP TABLE IF EXISTS "T_LLLTE_CELLM_MO_1615_A12Q1";
CREATE GLOBAL TEMPORARY TABLE "T_LLLTE_CELLM_MO_1615_A12Q1"
(
  "PLANID" NUMBER(10) NOT NULL,
  "PHYID" NUMBER(10) NOT NULL,
  "V_DLCENTRALFREQ" NUMBER,
  "V_LOCALCELLID" NUMBER(10) NOT NULL
)ON COMMIT DELETE ROWS;

insert into Tmp_PreErrLog_Site
  select distinct 1,
                  o_self.CMENEID,
                  o_self.entityMoOpId,
                  o_self.objectId,
                  'CELLLTEFLEXBW',
                  ltrim(' ') || '[PARA]CellLteFlexBw::LocalCellId[/PARA]:' ||
                  to_char(o_self.LOCALCELLID) as MoID,
                  21326 as ErrCode
    from tMP_CELLLTEFLEXBW_A12K o_self
    join RuleCheck_ObjGroup ObjGroup on o_self.CMENEID = ObjGroup.objectId
    join tMP_CELLLTEFLEXBWITFCFG_A12K o_aa on (o_aa.PlanID = o_self.PlanID and
                                              o_aa.PHYID = o_self.PHYID)
                                          and (o_self.LOCALCELLID =
                                              o_aa.LOCALCELLID)
    join tMP_CELL_A12K o_dd on (o_dd.PlanID = o_self.PlanID and
                               o_dd.PHYID = o_self.PHYID)
    join t_LLLTE_CELLM_MO_1615_A12Q1 o_ee on (o_ee.PlanID = o_self.PlanID and
                                             o_ee.PHYID = o_self.PHYID)
                                         and (o_self.LOCALCELLID =
                                             o_ee.v_LocalCellId)
   where o_self.PlanID = 1
     and ObjGroup.groupId = 2
     and (((o_self.DLCUSTSTARTPRBINDEX <> 255) and
         (o_self.DLCUSTENDPRBINDEX <> 255) and
         ((bitand((bitand(to_number(to_number(o_self.LTEFLEXBWSWITCH)),
                            15)),
                    1)) <> 0)) and
         (((o_self.LOCALCELLID = o_dd.LOCALCELLID) and
         (o_dd.NBCELLFLAG = 0)) and
         (((o_self.DLCUSTSTARTPRBINDEX < o_self.DLCUSTENDPRBINDEX) and
         (((case when(o_aa.GSMCARRIERFREQ = 1) then(935000)
          when((o_aa.GSMCARRIERFREQ <> 1) and
                     (o_aa.GSMCARRIERFREQ = 2)) then(1805200)
          when((o_aa.GSMCARRIERFREQ <> 1) and
                     (o_aa.GSMCARRIERFREQ <> 2) and
                     (o_aa.GSMCARRIERFREQ = 3)) then(1930200)
          when((o_aa.GSMCARRIERFREQ <> 1) and
                     (o_aa.GSMCARRIERFREQ <> 2) and
                     (o_aa.GSMCARRIERFREQ <> 3)) then(869200) end) +
         200 *
         (o_aa.HIGHITFGSMARFCN -
         (case when((o_aa.GSMCARRIERFREQ = 1) and
                           (o_aa.HIGHITFGSMARFCN <= 124)) then(0)
          when(((o_aa.GSMCARRIERFREQ <> 1) or
                      (o_aa.HIGHITFGSMARFCN > 124)) and
                      ((o_aa.GSMCARRIERFREQ = 1) and
                      (o_aa.HIGHITFGSMARFCN >= 975) and
                      (o_aa.HIGHITFGSMARFCN <= 1023))) then(1024)
          when(((o_aa.GSMCARRIERFREQ <> 1) or
                      (o_aa.HIGHITFGSMARFCN > 124)) and
                      ((o_aa.GSMCARRIERFREQ <> 1) or
                      (o_aa.HIGHITFGSMARFCN < 975) or
                      (o_aa.HIGHITFGSMARFCN > 1023)) and
                      ((o_aa.GSMCARRIERFREQ = 2) or
                      (o_aa.GSMCARRIERFREQ = 3))) then(512)
          when(((o_aa.GSMCARRIERFREQ <> 1) or
                      (o_aa.HIGHITFGSMARFCN > 124)) and
                      ((o_aa.GSMCARRIERFREQ <> 1) or
                      (o_aa.HIGHITFGSMARFCN < 975) or
                      (o_aa.HIGHITFGSMARFCN > 1023)) and
                      ((o_aa.GSMCARRIERFREQ <> 2) and
                      (o_aa.GSMCARRIERFREQ <> 3))) then(128) end)) + 100 >
         ((o_ee.v_DlCentralFreq * 100 -
         90 *
         (case when(o_dd.DLBANDWIDTH = 2) then(25)
          when((o_dd.DLBANDWIDTH <> 2) and (o_dd.DLBANDWIDTH = 3))
          then(50)
          when((o_dd.DLBANDWIDTH <> 2) and (o_dd.DLBANDWIDTH <> 3) and
                       (o_dd.DLBANDWIDTH = 4)) then(75)
          when((o_dd.DLBANDWIDTH <> 2) and (o_dd.DLBANDWIDTH <> 3) and
                       (o_dd.DLBANDWIDTH <> 4)) then(100) end)) +
         o_self.DLCUSTSTARTPRBINDEX * 180)) and
         ((case when(o_aa.GSMCARRIERFREQ = 1) then(935000)
          when((o_aa.GSMCARRIERFREQ <> 1) and
                     (o_aa.GSMCARRIERFREQ = 2)) then(1805200)
          when((o_aa.GSMCARRIERFREQ <> 1) and
                     (o_aa.GSMCARRIERFREQ <> 2) and
                     (o_aa.GSMCARRIERFREQ = 3)) then(1930200)
          when((o_aa.GSMCARRIERFREQ <> 1) and
                     (o_aa.GSMCARRIERFREQ <> 2) and
                     (o_aa.GSMCARRIERFREQ <> 3)) then(869200) end) +
         200 *
         (o_aa.HIGHITFGSMARFCN -
         (case when((o_aa.GSMCARRIERFREQ = 1) and
                           (o_aa.HIGHITFGSMARFCN <= 124)) then(0)
          when(((o_aa.GSMCARRIERFREQ <> 1) or
                      (o_aa.HIGHITFGSMARFCN > 124)) and
                      ((o_aa.GSMCARRIERFREQ = 1) and
                      (o_aa.HIGHITFGSMARFCN >= 975) and
                      (o_aa.HIGHITFGSMARFCN <= 1023))) then(1024)
          when(((o_aa.GSMCARRIERFREQ <> 1) or
                      (o_aa.HIGHITFGSMARFCN > 124)) and
                      ((o_aa.GSMCARRIERFREQ <> 1) or
                      (o_aa.HIGHITFGSMARFCN < 975) or
                      (o_aa.HIGHITFGSMARFCN > 1023)) and
                      ((o_aa.GSMCARRIERFREQ = 2) or
                      (o_aa.GSMCARRIERFREQ = 3))) then(512)
          when(((o_aa.GSMCARRIERFREQ <> 1) or
                      (o_aa.HIGHITFGSMARFCN > 124)) and
                      ((o_aa.GSMCARRIERFREQ <> 1) or
                      (o_aa.HIGHITFGSMARFCN < 975) or
                      (o_aa.HIGHITFGSMARFCN > 1023)) and
                      ((o_aa.GSMCARRIERFREQ <> 2) and
                      (o_aa.GSMCARRIERFREQ <> 3))) then(128) end)) - 100 <
         ((o_ee.v_DlCentralFreq * 100 -
         90 *
         (case when(o_dd.DLBANDWIDTH = 2) then(25)
          when((o_dd.DLBANDWIDTH <> 2) and (o_dd.DLBANDWIDTH = 3))
          then(50)
          when((o_dd.DLBANDWIDTH <> 2) and (o_dd.DLBANDWIDTH <> 3) and
                       (o_dd.DLBANDWIDTH = 4)) then(75)
          when((o_dd.DLBANDWIDTH <> 2) and (o_dd.DLBANDWIDTH <> 3) and
                       (o_dd.DLBANDWIDTH <> 4)) then(100) end)) +
         (o_self.DLCUSTENDPRBINDEX + 1) * 180)))) or
         ((o_self.DLCUSTSTARTPRBINDEX >= o_self.DLCUSTENDPRBINDEX) and
         ((((case when(o_aa.GSMCARRIERFREQ = 1) then(935000)
          when((o_aa.GSMCARRIERFREQ <> 1) and
                      (o_aa.GSMCARRIERFREQ = 2)) then(1805200)
          when((o_aa.GSMCARRIERFREQ <> 1) and
                      (o_aa.GSMCARRIERFREQ <> 2) and
                      (o_aa.GSMCARRIERFREQ = 3)) then(1930200)
          when((o_aa.GSMCARRIERFREQ <> 1) and
                      (o_aa.GSMCARRIERFREQ <> 2) and
                      (o_aa.GSMCARRIERFREQ <> 3)) then(869200) end) +
         200 *
         (o_aa.HIGHITFGSMARFCN -
         (case when((o_aa.GSMCARRIERFREQ = 1) and
                            (o_aa.HIGHITFGSMARFCN <= 124)) then(0)
          when(((o_aa.GSMCARRIERFREQ <> 1) or
                       (o_aa.HIGHITFGSMARFCN > 124)) and
                       ((o_aa.GSMCARRIERFREQ = 1) and
                       (o_aa.HIGHITFGSMARFCN >= 975) and
                       (o_aa.HIGHITFGSMARFCN <= 1023))) then(1024)
          when(((o_aa.GSMCARRIERFREQ <> 1) or
                       (o_aa.HIGHITFGSMARFCN > 124)) and
                       ((o_aa.GSMCARRIERFREQ <> 1) or
                       (o_aa.HIGHITFGSMARFCN < 975) or
                       (o_aa.HIGHITFGSMARFCN > 1023)) and
                       ((o_aa.GSMCARRIERFREQ = 2) or
                       (o_aa.GSMCARRIERFREQ = 3))) then(512)
          when(((o_aa.GSMCARRIERFREQ <> 1) or
                       (o_aa.HIGHITFGSMARFCN > 124)) and
                       ((o_aa.GSMCARRIERFREQ <> 1) or
                       (o_aa.HIGHITFGSMARFCN < 975) or
                       (o_aa.HIGHITFGSMARFCN > 1023)) and
                       ((o_aa.GSMCARRIERFREQ <> 2) and
                       (o_aa.GSMCARRIERFREQ <> 3))) then(128) end)) - 100 <
         ((o_ee.v_DlCentralFreq * 100 -
         90 *
         (case when(o_dd.DLBANDWIDTH = 2) then(25)
          when((o_dd.DLBANDWIDTH <> 2) and (o_dd.DLBANDWIDTH = 3))
          then(50)
          when((o_dd.DLBANDWIDTH <> 2) and (o_dd.DLBANDWIDTH <> 3) and
                        (o_dd.DLBANDWIDTH = 4)) then(75)
          when((o_dd.DLBANDWIDTH <> 2) and (o_dd.DLBANDWIDTH <> 3) and
                        (o_dd.DLBANDWIDTH <> 4)) then(100) end)) +
         (o_self.DLCUSTENDPRBINDEX + 1) * 180)) or
         ((case when(o_aa.GSMCARRIERFREQ = 1) then(935000)
          when((o_aa.GSMCARRIERFREQ <> 1) and
                      (o_aa.GSMCARRIERFREQ = 2)) then(1805200)
          when((o_aa.GSMCARRIERFREQ <> 1) and
                      (o_aa.GSMCARRIERFREQ <> 2) and
                      (o_aa.GSMCARRIERFREQ = 3)) then(1930200)
          when((o_aa.GSMCARRIERFREQ <> 1) and
                      (o_aa.GSMCARRIERFREQ <> 2) and
                      (o_aa.GSMCARRIERFREQ <> 3)) then(869200) end) +
         200 *
         (o_aa.HIGHITFGSMARFCN -
         (case when((o_aa.GSMCARRIERFREQ = 1) and
                            (o_aa.HIGHITFGSMARFCN <= 124)) then(0)
          when(((o_aa.GSMCARRIERFREQ <> 1) or
                       (o_aa.HIGHITFGSMARFCN > 124)) and
                       ((o_aa.GSMCARRIERFREQ = 1) and
                       (o_aa.HIGHITFGSMARFCN >= 975) and
                       (o_aa.HIGHITFGSMARFCN <= 1023))) then(1024)
          when(((o_aa.GSMCARRIERFREQ <> 1) or
                       (o_aa.HIGHITFGSMARFCN > 124)) and
                       ((o_aa.GSMCARRIERFREQ <> 1) or
                       (o_aa.HIGHITFGSMARFCN < 975) or
                       (o_aa.HIGHITFGSMARFCN > 1023)) and
                       ((o_aa.GSMCARRIERFREQ = 2) or
                       (o_aa.GSMCARRIERFREQ = 3))) then(512)
          when(((o_aa.GSMCARRIERFREQ <> 1) or
                       (o_aa.HIGHITFGSMARFCN > 124)) and
                       ((o_aa.GSMCARRIERFREQ <> 1) or
                       (o_aa.HIGHITFGSMARFCN < 975) or
                       (o_aa.HIGHITFGSMARFCN > 1023)) and
                       ((o_aa.GSMCARRIERFREQ <> 2) and
                       (o_aa.GSMCARRIERFREQ <> 3))) then(128) end)) + 100 >
         ((o_ee.v_DlCentralFreq * 100 -
         90 *
         (case when(o_dd.DLBANDWIDTH = 2) then(25)
          when((o_dd.DLBANDWIDTH <> 2) and (o_dd.DLBANDWIDTH = 3))
          then(50)
          when((o_dd.DLBANDWIDTH <> 2) and (o_dd.DLBANDWIDTH <> 3) and
                        (o_dd.DLBANDWIDTH = 4)) then(75)
          when((o_dd.DLBANDWIDTH <> 2) and (o_dd.DLBANDWIDTH <> 3) and
                        (o_dd.DLBANDWIDTH <> 4)) then(100) end)) +
         o_self.DLCUSTSTARTPRBINDEX * 180))) and
         ((case when(o_aa.GSMCARRIERFREQ = 1) then(935000)
          when((o_aa.GSMCARRIERFREQ <> 1) and
                     (o_aa.GSMCARRIERFREQ = 2)) then(1805200)
          when((o_aa.GSMCARRIERFREQ <> 1) and
                     (o_aa.GSMCARRIERFREQ <> 2) and
                     (o_aa.GSMCARRIERFREQ = 3)) then(1930200)
          when((o_aa.GSMCARRIERFREQ <> 1) and
                     (o_aa.GSMCARRIERFREQ <> 2) and
                     (o_aa.GSMCARRIERFREQ <> 3)) then(869200) end) +
         200 *
         (o_aa.HIGHITFGSMARFCN -
         (case when((o_aa.GSMCARRIERFREQ = 1) and
                           (o_aa.HIGHITFGSMARFCN <= 124)) then(0)
          when(((o_aa.GSMCARRIERFREQ <> 1) or
                      (o_aa.HIGHITFGSMARFCN > 124)) and
                      ((o_aa.GSMCARRIERFREQ = 1) and
                      (o_aa.HIGHITFGSMARFCN >= 975) and
                      (o_aa.HIGHITFGSMARFCN <= 1023))) then(1024)
          when(((o_aa.GSMCARRIERFREQ <> 1) or
                      (o_aa.HIGHITFGSMARFCN > 124)) and
                      ((o_aa.GSMCARRIERFREQ <> 1) or
                      (o_aa.HIGHITFGSMARFCN < 975) or
                      (o_aa.HIGHITFGSMARFCN > 1023)) and
                      ((o_aa.GSMCARRIERFREQ = 2) or
                      (o_aa.GSMCARRIERFREQ = 3))) then(512)
          when(((o_aa.GSMCARRIERFREQ <> 1) or
                      (o_aa.HIGHITFGSMARFCN > 124)) and
                      ((o_aa.GSMCARRIERFREQ <> 1) or
                      (o_aa.HIGHITFGSMARFCN < 975) or
                      (o_aa.HIGHITFGSMARFCN > 1023)) and
                      ((o_aa.GSMCARRIERFREQ <> 2) and
                      (o_aa.GSMCARRIERFREQ <> 3))) then(128) end)) + 100 >
         (o_ee.v_DlCentralFreq * 100 -
         90 *
         (case when(o_dd.DLBANDWIDTH = 2) then(25)
          when((o_dd.DLBANDWIDTH <> 2) and (o_dd.DLBANDWIDTH = 3))
          then(50)
          when((o_dd.DLBANDWIDTH <> 2) and (o_dd.DLBANDWIDTH <> 3) and
                      (o_dd.DLBANDWIDTH = 4)) then(75)
          when((o_dd.DLBANDWIDTH <> 2) and (o_dd.DLBANDWIDTH <> 3) and
                      (o_dd.DLBANDWIDTH <> 4)) then(100) end))) and
         ((case when(o_aa.GSMCARRIERFREQ = 1) then(935000)
          when((o_aa.GSMCARRIERFREQ <> 1) and
                     (o_aa.GSMCARRIERFREQ = 2)) then(1805200)
          when((o_aa.GSMCARRIERFREQ <> 1) and
                     (o_aa.GSMCARRIERFREQ <> 2) and
                     (o_aa.GSMCARRIERFREQ = 3)) then(1930200)
          when((o_aa.GSMCARRIERFREQ <> 1) and
                     (o_aa.GSMCARRIERFREQ <> 2) and
                     (o_aa.GSMCARRIERFREQ <> 3)) then(869200) end) +
         200 *
         (o_aa.HIGHITFGSMARFCN -
         (case when((o_aa.GSMCARRIERFREQ = 1) and
                           (o_aa.HIGHITFGSMARFCN <= 124)) then(0)
          when(((o_aa.GSMCARRIERFREQ <> 1) or
                      (o_aa.HIGHITFGSMARFCN > 124)) and
                      ((o_aa.GSMCARRIERFREQ = 1) and
                      (o_aa.HIGHITFGSMARFCN >= 975) and
                      (o_aa.HIGHITFGSMARFCN <= 1023))) then(1024)
          when(((o_aa.GSMCARRIERFREQ <> 1) or
                      (o_aa.HIGHITFGSMARFCN > 124)) and
                      ((o_aa.GSMCARRIERFREQ <> 1) or
                      (o_aa.HIGHITFGSMARFCN < 975) or
                      (o_aa.HIGHITFGSMARFCN > 1023)) and
                      ((o_aa.GSMCARRIERFREQ = 2) or
                      (o_aa.GSMCARRIERFREQ = 3))) then(512)
          when(((o_aa.GSMCARRIERFREQ <> 1) or
                      (o_aa.HIGHITFGSMARFCN > 124)) and
                      ((o_aa.GSMCARRIERFREQ <> 1) or
                      (o_aa.HIGHITFGSMARFCN < 975) or
                      (o_aa.HIGHITFGSMARFCN > 1023)) and
                      ((o_aa.GSMCARRIERFREQ <> 2) and
                      (o_aa.GSMCARRIERFREQ <> 3))) then(128) end)) - 100 <
         (o_ee.v_DlCentralFreq * 100 + 90 *
         (case when(o_dd.DLBANDWIDTH = 2) then(25)
          when((o_dd.DLBANDWIDTH <> 2) and (o_dd.DLBANDWIDTH = 3))
          then(50)
          when((o_dd.DLBANDWIDTH <> 2) and (o_dd.DLBANDWIDTH <> 3) and
                      (o_dd.DLBANDWIDTH = 4)) then(75)
          when((o_dd.DLBANDWIDTH <> 2) and (o_dd.DLBANDWIDTH <> 3) and
                      (o_dd.DLBANDWIDTH <> 4)) then(100) end))))))));

drop table TMP_PREERRLOG_SITE purge;
drop table TMP_CELLLTEFLEXBW_A12K purge;
drop table RULECHECK_OBJGROUP purge;
drop table TMP_CELLLTEFLEXBWITFCFG_A12K purge;
drop table TMP_CELL_A12K;
drop table T_LLLTE_CELLM_MO_1615_A12Q1;

--DTS2018121201057
drop table if exists Z_SHARDING_LEFT_JOIN_002;
CREATE TABLE Z_SHARDING_LEFT_JOIN_002(C_INT INT ,C_INTEGER INTEGER  ,C_BIGINT BIGINT,C_NUMBER NUMBER DEFAULT 0.2332,C_NUMBER1 NUMBER(12,2),C_NUMBER2 NUMBER(12,6),C_DOUBLE DOUBLE,C_DECIMAL DECIMAL,C_DECIMAL1 DECIMAL(8,2),C_DECIMAL2 DECIMAL(8,4),C_REAL REAL,C_CHAR CHAR(2000),C_VARCHAR VARCHAR(400),C_VARCHAR2 VARCHAR2(400),C_NUMERIC NUMERIC,C_DATETIME DATETIME not null, C_DATE DATE,C_TIMESTAMP TIMESTAMP,C_TIMESTAMP1 TIMESTAMP(4),C_CLOB  varchar2(8000),C_BOOL BOOL);
create index DTS2018121201057_ind_001 on Z_SHARDING_LEFT_JOIN_002(c_datetime);
create index ind_002 on Z_SHARDING_LEFT_JOIN_002(c_datetime,c_varchar);
create index ind_003 on Z_SHARDING_LEFT_JOIN_002(c_double,c_number,c_varchar);
@@z_sharding_insert_002.sql
select count(case when c_timestamp-c_datetime<cast('+0000000 00:00:00.000000' as INTERVAL DAY TO SECOND) or c_timestamp-c_datetime>cast('+0000000 00:00:00.000000' as INTERVAL DAY TO SECOND) then c_timestamp-c_datetime else cast('+0000456 00:00:00.000000' as INTERVAL DAY TO SECOND) end) as aa from Z_SHARDING_LEFT_JOIN_002;
drop table Z_SHARDING_LEFT_JOIN_002 purge;

-- case when datatype
drop table if exists case_when_datatype_t;
create table case_when_datatype_t(c1 int, c2 number(8,3), c3 varchar(10), c4 char(5));
insert into case_when_datatype_t values(1,12.222,'test1','char1');
insert into case_when_datatype_t values(2,22.222,'test2','char2');

desc -q select case when 1!=1 then 1 else null end from sys_dummy;
desc -q select case when c1 > 1 then c1 else cast(123 as binary_uint32) end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then cast(123 as binary_uint32) else c1 end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then -1 else cast(1000000000000 as bigint) end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then cast(1000000000000 as bigint) else 1 end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then 1 else cast(1 as boolean) end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then cast(0 as boolean) else 1 end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then c1 else cast(12.34 as real) end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then cast(12.34 as real) else c1 end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then c1 else cast(12.34 as float) end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then cast(12.34 as float) else c1 end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then c2 else '1' end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then '1' else c2 end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then c3 else c4 end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then c4 else c3 end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then cast('0100' as binary(10)) else cast('0111' as varbinary(5)) end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then cast('0111' as varbinary(5)) else cast('0100' as binary(10)) end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then cast('0100' as binary(5)) else cast('0111' as varbinary(10)) end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then c3 else to_date('1999-09-27 00:00:00', 'YYYY-MM-DD HH24:MI:SS') end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then to_date('1999-09-27 00:00:00', 'YYYY-MM-DD HH24:MI:SS') else c3 end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then c3 else cast(1 as boolean) end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then cast(0 as boolean) else c3 end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then ? else ? end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then ? else NULL end as c1 from case_when_datatype_t;
desc -q select case when c1 > 1 then 2 else ? end as c1 from case_when_datatype_t;
drop table case_when_datatype_t;

select case when 2>3 then  FROM_UNIXTIME(321421) else '454' end from sys_dummy;

drop table if exists case_when_lob_t;
create table case_when_lob_t(c1 int, c2 varchar(255), c3 clob, c4 clob, c5 blob, c6 blob, c7 image, c8 image);
insert into case_when_lob_t values(1, 'c2_test1', 'c3_clob_1', 'c4_clob_1', '0011', '1100', '0101', '1010');
insert into case_when_lob_t values(2, 'c2_test2', 'c3_clob_2', 'c4_clob_2', '0011', '1100', '0101', '1010');

select case when c1 = 1 then c3 else c4 end col1 from case_when_lob_t;
select case when c1 = 1 then c5 else c6 end col1 from case_when_lob_t;
select case when c1 = 1 then c7 else c8 end col1 from case_when_lob_t;
select case when c1 = 1 then c2 else c3 end col1 from case_when_lob_t;
select case when c1 = 1 then c2 else c7 end col1 from case_when_lob_t;
select case when c1 = 1 then cast('0111' as raw(5)) else c5 end col1 from case_when_lob_t;
select case c1 when 1 then c5 else cast('0111' as raw(5)) end col1 from case_when_lob_t;
select case when c1 = 1 then cast('0111' as binary(5)) else c5 end col1 from case_when_lob_t;
drop table case_when_lob_t;

drop table if exists case_when_array_t;
create table case_when_array_t(c1 int, c2 int[], c3 char(20)[], c4 varchar(20)[]);
insert into case_when_array_t values(1, array[1,2,3],array['apple','banana'], array['{C}','{C++}']);
insert into case_when_array_t values(2, array[4,5,6],array['dog','cat'], array['{Python}','{Go}']);

select case when c1 = 2 then c2 else c3 end col1 from case_when_array_t;
select case when c1 = 2 then c3 else c4 end col1 from case_when_array_t;
select case when c1 = 2 then c4 else c4[1] end col1 from case_when_array_t;
select case when c1 = 2 then c4[1] else c4 end col1 from case_when_array_t;
select case when c1 = 2 then c2[1] else c2[2] end col1 from case_when_array_t;

delete from case_when_array_t;
insert into case_when_array_t values(1, null,array['apple','banana'], array['{C}','{C++}']);
insert into case_when_array_t values(2, null,array['dog','cat'], array['{Python}','{Go}']);

select
    case when  ref_0.c1 > ref_0.c1 then ref_1.c2 else ref_1.c2 end as c2
from((case_when_array_t as ref_0) right join
     (case_when_array_t as ref_1) on true)
    full outer join(case_when_array_t as ref_2)     
    on(ref_0.c1 = ref_2.c1);
drop table case_when_array_t;

-- _strict_case_datatype
drop table if exists case_str_num_t;
create table case_str_num_t(id int, c_num number(8,3), c_str varchar(20), c_char char(10), c_binary binary(10), c_varbinary varbinary(10));
insert into case_str_num_t values(1, 1.2, '127.0.0.1', '1111', '0110', '0220');
insert into case_str_num_t values(2, 2.3,  '0.0.0.0', 'aaaa', '0111', '0222');

-- number & string => string
desc -q select case when id = 1 then c_str else c_num end col_1 from case_str_num_t;
select case when id = 1 then c_str else c_num end col_1 from case_str_num_t;
-- number & char => string
desc -q select case when id = 1 then c_num else c_char end col_1 from case_str_num_t;
select case when id = 1 then c_num else c_char end col_1 from case_str_num_t;
-- number & varbinary => varbinary
desc -q select case when id = 1 then c_varbinary else c_num end col_1 from case_str_num_t;
select case when id = 1 then c_varbinary else c_num end col_1 from case_str_num_t;
-- number & binary => varbinary
desc -q select case when id = 1 then c_binary else c_num end col_1 from case_str_num_t;
select case when id = 1 then c_binary else c_num end col_1 from case_str_num_t;

alter system set _STRICT_CASE_DATATYPE=true;
-- number & string => number
desc -q select case when id = 1 then c_str else c_num end col_1  from case_str_num_t;
select case when id = 1 then c_str else c_num end col_1  from case_str_num_t;
-- number & varbinary => number
desc -q select case when id = 1 then c_varbinary else c_num end col_1  from case_str_num_t;
select case when id = 1 then c_varbinary else c_num end col_1  from case_str_num_t;

alter system set _STRICT_CASE_DATATYPE=false;
drop table case_str_num_t;