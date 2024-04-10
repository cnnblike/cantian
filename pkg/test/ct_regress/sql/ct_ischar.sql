--DTS2018110601285
drop table if exists t_string_32k_base_001;
drop table if exists t_string_32k_002;
drop table if exists t_string_32k_003;
drop table if exists t_string_32k_004;
drop table if exists t_string_32k_005;

create table t_string_32k_base_001(c_id int,c_num numeric(12,2),c_vchars varchar(32) NOT NULL,c_vchar_c varchar2(3000 char),c_ts timestamp,c_blob blob,c_clob clob,primary key(c_id,c_num,c_vchars,c_vchar_c,c_ts));
insert into t_string_32k_base_001 values(1,1000.56,'AA'||'BAR1BARBAR',lpad('1234567890abcdfe',2500,'abc1d2fb456cdef'),to_timestamp(to_char('1800-01-01 10:51:47'),'yyyy-mm-dd hh24:mi:ss'),lpad('123abc',2500,'abc'),lpad('12345abcde',2500,'abcde'));
commit;

create table t_string_32k_002 as select c_vchar_c||'aa' c from t_string_32k_base_001 where c_id=1;
create table t_string_32k_003 as select substr(c_vchar_c,3,10) c from t_string_32k_base_001 where c_id=1;
create table t_string_32k_004 as select trim(c_vchar_c) c from t_string_32k_base_001 where c_id=1;
create table t_string_32k_005 as select ltrim(c_vchar_c) c from t_string_32k_base_001 where c_id=1;
desc t_string_32k_002;
desc t_string_32k_003;
desc t_string_32k_004;
desc t_string_32k_005;

