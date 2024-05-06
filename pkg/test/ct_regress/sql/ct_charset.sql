show charset;
set charset gbkbbb;
show charset;
set charset gbk;
show charset;
drop table if exists test_gbk_t1;
create table test_gbk_t1(f1 char(40), f2 varchar(40));
insert into test_gbk_t1 values('中国','你好');
select * from test_gbk_t1;
drop table if exists test_gbk_t1;
set charset utf8;
show charset;

CREATE TABLE IF NOT EXISTS `T_RCA_RULE` 
( 
`ID` INT NOT NULL auto_increment, 
`NAME` VARCHAR(200) NOT NULL COLLATE utf8_bin, 
`DESCRIPTION` VARCHAR(500) DEFAULT '', 
`CONTENT` TEXT NOT NULL, 
`ENABLE` BOOL NOT NULL DEFAULT FALSE, 
`PRIORITY` INT NOT NULL DEFAULT 0, 
`PERIOD` INT NOT NULL, 
`TENANT_ID` VARCHAR(128) NULL DEFAULT NULL, 
`CREATE_TIME` BIGINT NOT NULL, 
`UPDATE_TIME` BIGINT NOT NULL, 
`RULE_EXPRS` TEXT NULL, 
PRIMARY KEY (`ID`), 
UNIQUE (`NAME`) ) DEFAULT COLLATE=utf8_bin CHARACTER SET = utf8; 
drop table T_RCA_RULE;

CREATE TABLE IF NOT EXISTS `T_RCA_RULE` 
( 
`ID` INT NOT NULL auto_increment, 
`NAME` VARCHAR(200) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL, 
`DESCRIPTION` VARCHAR(500) DEFAULT '', 
`CONTENT` TEXT NOT NULL, 
`ENABLE` BOOL NOT NULL DEFAULT FALSE, 
`PRIORITY` INT NOT NULL DEFAULT 0, 
`PERIOD` INT NOT NULL, 
`TENANT_ID` VARCHAR(128) NULL DEFAULT NULL, 
`CREATE_TIME` BIGINT NOT NULL, 
`UPDATE_TIME` BIGINT NOT NULL, 
`RULE_EXPRS` TEXT NULL, 
PRIMARY KEY (`ID`), 
UNIQUE (`NAME`) )COLLATE=utf8_bin DEFAULT CHARSET SET = utf8; 
drop table T_RCA_RULE;

CREATE TABLE IF NOT EXISTS `T_RCA_RULE` 
( 
`ID` INT NOT NULL auto_increment, 
`NAME` VARCHAR(200) CHARACTER SET GBK COLLATE GBK_BIN NOT NULL, 
`DESCRIPTION` VARCHAR(500) DEFAULT '', 
`CONTENT` TEXT NOT NULL, 
`ENABLE` BOOL NOT NULL DEFAULT FALSE, 
`PRIORITY` INT NOT NULL DEFAULT 0, 
`PERIOD` INT NOT NULL, 
`TENANT_ID` VARCHAR(128) NULL DEFAULT NULL, 
`CREATE_TIME` BIGINT NOT NULL, 
`UPDATE_TIME` BIGINT NOT NULL, 
`RULE_EXPRS` TEXT NULL, 
PRIMARY KEY (`ID`), 
UNIQUE (`NAME`) )COLLATE=GBK_CHINESE_CI DEFAULT CHARSET SET = utf8;
drop table T_RCA_RULE;


CREATE TABLE IF NOT EXISTS `t_vertex` (
  `igs_id` varbinary(16) DEFAULT NULL,
  `igs_int_id` bigint DEFAULT NULL,
  `igs_type` int DEFAULT NULL,
  `igs_name` varchar(256) COLLATE utf8_bin DEFAULT NULL,
  `igs_property` varchar(2000) COLLATE utf8_bin DEFAULT NULL
)  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
drop table `t_vertex`;


CREATE TABLE IF NOT EXISTS `T_RCA_RULE` 
( 
`ID` INT NOT NULL auto_increment, 
`NAME` VARCHAR(200) CHARACTER SET GBK COLLATE GBK_BIN NOT NULL, 
`DESCRIPTION` VARCHAR(500) DEFAULT '', 
`CONTENT` TEXT NOT NULL, 
`ENABLE` BOOL NOT NULL DEFAULT FALSE, 
`PRIORITY` INT NOT NULL DEFAULT 0, 
`PERIOD` INT NOT NULL, 
`TENANT_ID` VARCHAR(128) NULL DEFAULT NULL, 
`CREATE_TIME` BIGINT NOT NULL, 
`UPDATE_TIME` BIGINT NOT NULL, 
`RULE_EXPRS` TEXT NULL, 
PRIMARY KEY (`ID`), 
UNIQUE (`NAME`) )COLLATE=GBK_CHINESE_CI DEFAULT CHARSET SET = utf8; 
drop table `T_RCA_RULE`;

show charset;
-- modify server charset GBK
alter database character set gbk;
select character_set from dv_database;

-- like
drop table if exists test_gbk_t1;
create table test_gbk_t1(f1 varchar(40), f2 varchar(40));
insert into test_gbk_t1 values('中国人民','你们好');
select f1,f2,hex(f1),hex(f2) from test_gbk_t1;
select * from test_gbk_t1 where f1 like '中%人_';
select * from test_gbk_t1 where f1 like '中_人_';
select * from test_gbk_t1 where f1 like '%国%_';
select * from test_gbk_t1 where f1 like '%国%民';

-- like escape
insert into test_gbk_t1 values('中国人民','你_好');
select * from test_gbk_t1 where f2 like '你*_好' escape '*';

drop table if exists test_gbk_t1;

-- length
select length('你_好') from dual;
-- clob_len_from_knl
drop table if exists test_length;
create table test_length(f1 clob);
insert into test_length values('大家把课代表dhajhd');
select length(f1) from test_length;

-- instr
select instr('中国人民','人民') from dual;

-- left
select left('中国人名',2);

-- locate
 select locate('人','中国人名');

-- reverse
select reverse('中国人');

-- right
select right('中国人',2);

-- substr
select substr('中国人',2,2);

-- regexp_instr
select regexp_instr('中,国,人','[^,]+',2) from dual;

-- regexp_substr
select regexp_substr('中,国,人', '[^,]+', 1, 1) from dual;

-- lower
select lower('MR. SCOTT MCMILLAN') "Lowercase" from sys_dummy;

-- upper 
select upper('mr. scott mcmillan') "Uppercase" from sys_dummy;

-- asciistr
select asciistr('6473hesa*&^%') from dual;
select asciistr('abc严才123@.com') from dual;
select asciistr('にほんご') from dual;
select asciistr(111111111111111111111111111111111111111111111) from dual;
select asciistr(123.4444444444444444444444444) from dual;
select asciistr('a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456789a123456fghuftyttttttthfdghtedytydghdghfdghdfhjgfyhjfyhutyhdrfhtyrdtyddhjeryjejytedyjdnhdgfdtyjrdhdfgfdgfdfgdhgdhgedtgjedjgedrghedtfghjkld1234567891111114785r') from dual;
select asciistr(cast ('a' as char(2000))||cast ('a' as char(2000))) from dual;
select asciistr(null) from dual;
select asciistr(122asd) from dual;

-- to_single_byte
select to_single_byte('　”＄’︿‘～') from dual;
select to_single_byte('！＃％＆（）＊＋，－．／０１２３４５６７８９：；＜＝＞？＠ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ［＼］＿ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ｛｜｝') from dual;
select to_single_byte('123 abc　４５６ｅｆｇ华为数据库') from dual;
select to_single_byte(12*3+6-8/2) from dual;
select TO_SINGLE_BYTE('123 ｄａｄ达到') from dual;
select to_single_byte('\'') from dual;
select to_single_byte(１２３) from dual;

-- to_multi_byte
select to_multi_byte(' "$^`~') from dual;
select to_multi_byte('''') from dual;
select to_multi_byte('!#%&()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]_abcdefghijklmnopqrstuvwxyz{|}') from dual;
select to_multi_byte('123 abc　４５６ｅｆｇ华为数据库') from dual;
select to_multi_byte(12*3+6-8/2) from dual;
select TO_MULTI_BYTE('123 ｄａｄ达到') from dual;
select to_multi_byte('\'') from dual;
select to_multi_byte(１２３) from dual;

-- modify server charset utf8
alter database character set utf8;
select character_set from dv_database;
show charset;
