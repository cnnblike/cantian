set serveroutput on;
create user gs_plsql_dts identified by Whf00174302;
grant dba to gs_plsql_dts;
conn gs_plsql_dts/Whf00174302@127.0.0.1:1611
--CLOUDSOP Script1
drop table if exists plsql_dts_test;
create table plsql_dts_test(a int);
insert into plsql_dts_test values(1),(2);
begin
--check if error.
delete from plsql_dts_test t1 where exists (select * from plsql_dts_test t2 where t2.a = 1);
insert into plsql_dts_test select * from plsql_dts_test where a <> '*';
end;
/
select * from plsql_dts_test;
--CLOUDSOP Script2
drop table if exists plsql_dts_tbl_NeUserDefineGrp;
drop table if exists plsql_dts_tbl_BackupNeSelDefGrp;
drop table if exists plsql_dts_tbl_NEDefCmdGroupTable;
drop table if exists plsql_dts_tbl_CmdReflect;
drop table if exists plsql_dts_tbl_NEAccess;
drop table if exists PLSQL_DTS_TBL_NEUSERGROUPACCESS;
create table plsql_dts_tbl_NeUserDefineGrp(GrpID int, SrcGrp int, NeFdn int, CmdGroupName varchar(100));
create table plsql_dts_tbl_BackupNeSelDefGrp(NeFdn int, DstGrp varchar(100), SrcNeType varchar(100), DstNeType varchar(100));
create table plsql_dts_tbl_NEDefCmdGroupTable(CmdGroupName varchar(100), NEType int);
create table plsql_dts_tbl_CmdReflect(GrpID int, CmdGroupName varchar(100));
create table plsql_dts_tbl_NEAccess(CmdGroupName varchar(100), NeFdn varchar(100));
create table PLSQL_DTS_TBL_NEUSERGROUPACCESS(CmdGroupName varchar(100), NeFdn varchar(100));

create or replace procedure plsql_dts_neuser_convertSelfDefGrp (vNeFdn in varchar,vNeTypeKey in varchar,ConvertAccess in int,cus_r OUT SYS_REFCURSOR)
AS
exist_in_default_grp number;
exist_in_custmoized_grp number;
groupid number;
current_groupid number;
groupid_index number;
vcmdgroupname varchar(10);
target_cmdgrp varchar(10);
cursor overladpped_cmdgrp is select GrpID,CmdGroupName from plsql_dts_tbl_NeUserDefineGrp where NeFdn = vNeFdn and CmdGroupName in (select CmdGroupName from plsql_dts_tbl_NEDefCmdGroupTable where NEType = vNeTypeKey) order by CmdGroupName;
begin
        delete from plsql_dts_tbl_CmdReflect;
        insert into plsql_dts_tbl_CmdReflect select tbl1.GrpID,tbl1.CmdGroupName from plsql_dts_tbl_NeUserDefineGrp tbl1 where tbl1.NeFdn = vNeFdn and tbl1.CmdGroupName not in (select tbl2.CmdGroupName from plsql_dts_tbl_NEDefCmdGroupTable tbl2 where tbl2.NEType = vNeTypeKey) order by tbl1.CmdGroupName;
        open overladpped_cmdgrp;
        fetch overladpped_cmdgrp into groupid ,vcmdgroupname;
        WHILE overladpped_cmdgrp%FOUND
    loop
            begin
                current_groupid := to_number(substr(vcmdgroupname,3,length(vcmdgroupname)));
                groupid_index := current_groupid;
                WHILE (groupid_index < 999)
                loop
                        begin
                                groupid_index := groupid_index + 1;
                                    target_cmdgrp := 'G_'|| to_char(groupid_index);
                                    select count(*) into exist_in_default_grp from plsql_dts_tbl_NeUserDefineGrp tbl1 where tbl1.NeFdn = vNeFdn and tbl1.CmdGroupName = target_cmdgrp;
                                    if(exist_in_default_grp = 0) then
                                            select count(*) into exist_in_custmoized_grp from plsql_dts_tbl_NEDefCmdGroupTable tbl2 where tbl2.NEType = vNeTypeKey and tbl2.CmdGroupName = target_cmdgrp;
                                            if(exist_in_custmoized_grp = 0) then
                                                    update plsql_dts_tbl_NeUserDefineGrp set CmdGroupName= target_cmdgrp where GrpID=groupid;
                                                    insert into plsql_dts_tbl_CmdReflect values(vcmdgroupname,target_cmdgrp);
                                                    if (ConvertAccess = 1) then
                                                            delete from plsql_dts_tbl_NEAccess where CmdGroupName = target_cmdgrp and NeFdn = vNeFdn;
                                                            update plsql_dts_tbl_NEAccess set CmdGroupName = target_cmdgrp where NeFdn = vNeFdn and CmdGroupName = vcmdgroupname;
                                                            delete from PLSQL_DTS_TBL_NEUSERGROUPACCESS where CmdGroupName = target_cmdgrp and NeFdn = vNeFdn;
                                                            update PLSQL_DTS_TBL_NEUSERGROUPACCESS set CmdGroupName = target_cmdgrp where NeFdn = vNeFdn and CmdGroupName = vcmdgroupname;

                                                end if;
                                                groupid_index := 999;
                                            end if;
                                    end if;
                        end;
                end loop;
            end;
            fetch overladpped_cmdgrp into groupid ,vcmdgroupname;
    end loop;
    close overladpped_cmdgrp;
end;
/

--CLOUDSOP Script3
drop procedure if exists plsql_dts_restoreSelfCmdGrp;
drop type if exists plsql_dts_restoreSelfCmdGrp force;
drop function if exists plsql_dts_restoreSelfCmdGrp;
drop package if exists plsql_dts_restoreSelfCmdGrp;
create or replace procedure plsql_dts_restoreSelfCmdGrp(vNeFdn in varchar, vSrcNeTypeKey in varchar, vDstNeTypeKey in varchar, ConvertAccess in int)
as
vgroupid number;
vsrcgrpname varchar(50);
vdstgrpname varchar(50);
cursor self_cmdgrp is select GrpID, SrcGrp from plsql_dts_tbl_NeUserDefineGrp tbl1, plsql_dts_tbl_BackupNeSelDefGrp tbl2 where tbl1.NeFdn = tbl2.NeFdn and tbl1.CmdGroupName = tbl2.DstGrp and tbl2.NeFdn = vNeFdn and tbl2.SrcNeType = vSrcNeTypeKey and tbl2.DstNeType = vDstNeTypeKey;
begin
    open self_cmdgrp;
        fetch self_cmdgrp into vgroupid ,vsrcgrpname;
        WHILE self_cmdgrp%FOUND
        loop
                begin
                update plsql_dts_tbl_NeUserDefineGrp set CmdGroupName = vsrcgrpname where GrpID = vgroupid;
                fetch self_cmdgrp into vgroupid ,vsrcgrpname;
        end;
    end loop;
    close self_cmdgrp;
    delete from plsql_dts_tbl_BackupNeSelDefGrp where NeFdn = vNeFdn and SrcNeType = vsrcgrpname and DstNeType = vdstgrpname;
end;
/
call  plsql_dts_restoreSelfCmdGrp('vNeFdn', 'vSrcNeTypeKey', 'vDstNeTypeKey', 2);
drop table if exists plsql_dts_tbl_NeUserDefineGrp;
drop table if exists plsql_dts_tbl_BackupNeSelDefGrp;

--CLOUDSOP Script4
drop table if exists plsql_dts_tbl_NeUser_Rule_Apply;
drop table if exists plsql_dts_tbl_NETypeRule_tmp;
create table plsql_dts_tbl_NETypeRule_tmp(fdn int,ruleId int);
create table plsql_dts_tbl_NeUser_Rule_Apply(fdn int,ruleId int);

create or replace procedure plsql_dts_neuser_syncNeTypeRuleAccess_i
as
begin
    delete from plsql_dts_tbl_NeUser_Rule_Apply where fdn in (select distinct fdn from plsql_dts_tbl_NETypeRule_tmp);
    insert into plsql_dts_tbl_NeUser_Rule_Apply select fdn,ruleId from plsql_dts_tbl_NETypeRule_tmp;
    delete from plsql_dts_tbl_NETypeRule_tmp;
end;
/
--CLOUDSOP Script5
drop table if exists plsql_dts_PMCOMDB.systbl_CounterAllStyle;
create user plsql_dts_PMCOMDB identified by Whf00174302;
create table plsql_dts_PMCOMDB.systbl_CounterAllStyle(CounterId int, CounterName varchar(100), CounterAliasName varchar(100), VersionId int);

CREATE OR REPLACE PROCEDURE "plsql_dts_PMCOMDB"."PROC_COUNTERSTYLE"(P_VersionId IN NUMBER,P_BeAliasName IN NUMBER)
AS
    V_SqlUpdate         VARCHAR2(255);
    V_CounterId         plsql_dts_PMCOMDB.systbl_CounterAllStyle.CounterId%TYPE;
    V_CounterName       plsql_dts_PMCOMDB.systbl_CounterAllStyle.CounterName%TYPE;
    V_CounterAliasName  plsql_dts_PMCOMDB.systbl_CounterAllStyle.CounterAliasName%TYPE;

    CURSOR cur_attr(VID NUMBER) IS
        SELECT CounterId ,REPLACE(CounterName,'''',''''''),REPLACE(CounterAliasName,'''','''''') from plsql_dts_PMCOMDB.systbl_CounterAllStyle where VersionId=VID;
BEGIN
    IF cur_attr%ISOPEN THEN
        CLOSE cur_attr;
    END IF;

    OPEN cur_attr(P_VersionId);
    LOOP
        FETCH cur_attr INTO V_CounterId, V_CounterName,V_CounterAliasName;
        EXIT WHEN cur_attr%NOTFOUND;

        IF P_BeAliasName =0 THEN
            V_SqlUpdate := 'UPDATE systbl_Counters SET CounterName='''||V_CounterName||''' where CounterId='||V_CounterId||' and VersionId='||P_VersionId||'';
        ELSE
            V_SqlUpdate := 'UPDATE systbl_Counters SET CounterName='''||V_CounterAliasName||''' where CounterId='||V_CounterId||' and VersionId='||P_VersionId||'';
        END IF;
        --dbe_output.print_line(V_SqlUpdate);
        EXECUTE IMMEDIATE V_SqlUpdate;
    END LOOP;
    CLOSE cur_attr;
    COMMIT;
 END;
/
drop procedure "plsql_dts_PMCOMDB"."PROC_COUNTERSTYLE";
drop table if exists plsql_dts_PMCOMDB.systbl_CounterAllStyle;
--CLOUDSOP Script6
create or replace function TO_NUMBER_ADAPTER( v_char varchar2)
return NUMBER
as
begin
    if (instr(v_char, '0x') = 1) or (instr(v_char, '0X') = 1) then
        return 1;
    end if;
    if (REGEXP_LIKE(v_char,'[a-f]|[A-F]') = true) then
        return 2;
    end if;
    return 3;
end;
/
select TO_NUMBER_ADAPTER('12342334.423');
select TO_NUMBER_ADAPTER('fdsfsdcc');

--CLOUDSOP Script7
create or replace FUNCTION inttohex(v_int numeric)
RETURN VARCHAR2
AS
    v_return VARCHAR2(4000);
BEGIN
    SELECT upper(TRIM(to_char(to_char(v_int), 'xxxxxxxxxxxxxxxxxxxxxxxxxx'))) INTO v_return FROM dual;
    RETURN v_return;
    EXCEPTION
        WHEN OTHERS THEN
        RETURN NULL;
END;
/

--CLOUDSOP Script8
drop table if exists plsql_dts_Utils_CheckPoint;
create table plsql_dts_Utils_CheckPoint(PlanID number, Tag varchar2(100));
create or replace procedure plsql_dts_sp_LockFor (
    v_PlanID in number ,
    v_Tag in varchar2  )
as
    v_flag number(10, 0) ;
begin
    insert into plsql_dts_Utils_CheckPoint
        select v_PlanID, v_Tag from dual where  not  exists ( select 1 from plsql_dts_Utils_CheckPoint where PlanID = v_PlanID and Tag = v_Tag ) ;
    commit;
    v_flag := 1;
    while  (v_flag = 1 )
    loop
        begin
            begin
                select  count( 1 ) into v_flag from plsql_dts_Utils_CheckPoint where PlanID = v_PlanID and Tag = v_Tag;
            exception
                when no_data_found then
                    null;
            end;
            begin dbe_output.print_line('Ignored Statement:  waitfor delay '); end;
        end;
    end loop;

end;
/
create or replace procedure plsql_dts_sp_UnlockFor (
    v_PlanID in number ,
    v_Tag in varchar2  )
as
begin
    delete from plsql_dts_Utils_CheckPoint  where PlanID = v_PlanID and Tag = v_Tag;

end;
/

declare
  table_name  varchar2(100);
  strSQL varchar2(1000);
  result_cur sys_refcursor;
begin
  table_name  := 'plsql_dts_test';
  strSQL := 'select * from ' || table_name;
  dbe_output.print_line(strSQL);
  OPEN result_cur for strSQL;
  close result_cur;
end;
/

declare
  table_name  varchar2(100);
  strSQL varchar2(1000);
  result_cur sys_refcursor;
begin
  table_name  := 'aaa';
  strSQL := 'select * from ' || table_name;
  dbe_output.print_line(strSQL);
  OPEN result_cur for strSQL;
end;
/

begin
delete from plsql_dts_test t1;
end;
/

select stmt_id,sql_text,status from sys.v$open_cursor open_cur, sys.v$me me where open_cur.session_id = me.sid;
drop procedure if exists plsql_dts_hanoi;
drop function if exists plsql_dts_hanoi;
create or replace procedure plsql_dts_hanoi(n int,a varchar2,b varchar2,c varchar2)
as
v_n int :=n;
v_a char(4) :=a;
v_b char(4) :=b;
v_c char(4) :=c;
v_call_stmt varchar2(128);
begin
    if(1=v_n)
 then
        dbe_output.print_line(v_a||'---->'||v_c);
    else
        plsql_dts_hanoi(v_n-1,v_a,v_c,v_b);
        dbe_output.print_line(v_a||'---->'||v_c);
  	plsql_dts_hanoi(v_n-1,v_b,v_a,v_c);
    end if;
end;
/

call plsql_dts_hanoi(3,'A','B','C');
drop procedure plsql_dts_hanoi;

create or replace procedure plsql_dts_handle_even(even int)
as
v_even int :=even;
begin
  if(mod(v_even,2)=0)
  then
      dbe_output.print_line('handle_even:'||v_even);
   elsif(mod(v_even,2)=1)
  then
         dbe_output.print_line('please input even digit');
  end if;
end;
/

call plsql_dts_handle_even(1);
call plsql_dts_handle_even(2);

create or replace procedure plsql_dts_handle_even(even int)
as
v_even int :=even;
v_cmd varchar2(32);
begin
  if(mod(v_even,2)=0 and 0<>v_even)
  then
      dbe_output.print_line('handle_even:'||v_even);
      v_cmd := 'call plsql_dts_handle_odd('||(v_even-1)||')';
      EXECUTE IMMEDIATE v_cmd;
  elsif(0 = v_even)
  then
      dbe_output.print_line('handle_even:'||v_even);
  else
      dbe_output.print_line('please input even digit');
  end if;
end;
/

create or replace procedure plsql_dts_handle_odd(odd int)
as
v_odd int :=odd;
v_cmd varchar2(32);
begin
  if(mod(v_odd,2)=1 and 1<>v_odd)
  then
      dbe_output.print_line('handle_odd:'||v_odd);
      v_cmd := 'call plsql_dts_handle_even('||(v_odd-1)||')';
      EXECUTE IMMEDIATE v_cmd;
  elsif(1 = v_odd)
  then
      dbe_output.print_line('handle_odd:'||v_odd);
  else
      dbe_output.print_line('please input odd digit');
  end if;
end;
/

call plsql_dts_handle_even(4);

drop procedure if exists plsql_dts_hanoi;
drop function if exists plsql_dts_hanoi;
create or replace procedure plsql_dts_hanoi(n int,a varchar2,b varchar2,c varchar2)
as
v_n int :=n;
v_a char(4) :=a;
v_b char(4) :=b;
v_c char(4) :=c;
v_call_stmt varchar2(128);
begin
    if(1=v_n)
 then
        dbe_output.print_line(v_a||'---->'||v_c);
    else
        v_call_stmt:='call plsql_dts_hanoi('||(v_n-1)||','''||v_a||''','''||v_c||''','''||v_b||''')';
     EXECUTE IMMEDIATE v_call_stmt;
        dbe_output.print_line(v_a||'---->'||v_c);
  v_call_stmt:='call plsql_dts_hanoi('||(v_n-1)||','''||v_b||''','''||v_a||''','''||v_c||''')';
     EXECUTE IMMEDIATE v_call_stmt;
    end if;
end;
/

call plsql_dts_hanoi(3,'A','B','C');

drop procedure plsql_dts_handle_even;
drop procedure plsql_dts_handle_odd;
drop procedure plsql_dts_hanoi;

drop table if exists plsql_dts_tbl_ADNPicoOSSArea;
create table plsql_dts_tbl_ADNPicoOSSArea(PLMN varchar2(100), picoDBKey NUMBER);

BEGIN
    declare
    v_plmn varchar2(100);
    maxDBKey NUMBER;
    COUNT_ROW NUMBER;
    tsql varchar2(500);

    CURSOR cur
        is select PLMN
        from (select PLMN from plsql_dts_tbl_ADNPicoOSSArea where PLMN is not NULL and PLMN <> '-1' order by picoDBKey) where rownum = 1;
    BEGIN
        open cur;
        fetch cur into v_plmn;
        WHILE cur %FOUND
        LOOP
            BEGIN
                tsql := 'SELECT COUNT(PLMN) FROM plsql_dts_tbl_ADNPicoPLMN where PLMN = ''' || v_plmn || '''';
                EXECUTE IMMEDIATE tsql into COUNT_ROW;
                IF(COUNT_ROW <> 0) THEN
                    fetch cur into v_plmn;
                    CONTINUE;
                END IF;

                tsql := 'SELECT COUNT(PLMN) FROM plsql_dts_tbl_ADNPicoPLMN';
                EXECUTE IMMEDIATE tsql into COUNT_ROW;

                maxDBKey := 1;
                IF(COUNT_ROW = 0) THEN
                    maxDBKey := 1;
                ELSE
                    tsql := 'select picoDBKey from(select picoDBKey from plsql_dts_tbl_ADNPicoPLMN order by picoDBKey desc) where rownum = 1';
                    EXECUTE IMMEDIATE tsql into maxDBKey;
                    maxDBKey := maxDBKey + 1;
                END IF;

                tsql := 'insert into plsql_dts_tbl_ADNPicoPLMN(picoDBKey,PLMN) values(' || maxDBKey || ', ''' || v_plmn || ''')';
                EXECUTE IMMEDIATE tsql;

                fetch cur into v_plmn;
            END;
        END LOOP;
        CLOSE cur;
    END;
END;
/
 CREATE OR REPLACE FUNCTION plsql_dts_bitdomain_bitsets_to_number(bit_omc_value VARCHAR2, bit_pos_str VARCHAR2, value NUMBER)
 RETURN NUMBER AS bit_ne_value NUMBER(17);

 single_bit_pos VARCHAR2(2000);
 split_index NUMBER := 0;
 bit_pair VARCHAR2(2000);
 pair_index NUMBER;
 ne_index NUMBER;
 omc_index NUMBER;
 omc_bit_value VARCHAR2(2000);
 omc_max_pos NUMBER;
 bit_name VARCHAR2(2000);
 index_pair VARCHAR2(2000);
 single_omc_bit_value NUMBER;

 BEGIN

 IF (bit_omc_value = 'NULL' or bit_omc_value = '<NULL>' or bit_omc_value is NULL) THEN
     return value;
 END IF;

 single_bit_pos := bit_pos_str;
 bit_ne_value := 0;

 WHILE instr(single_bit_pos, ',') != 0 LOOP
     split_index := instr(single_bit_pos, ',');
     bit_pair := substr(single_bit_pos,1,split_index-1);

     pair_index := instr(bit_pair, ':');
     bit_name := substr(bit_pair,1,pair_index-1);
     index_pair := substr(bit_pair, pair_index + 1, length(bit_pair) - pair_index);
     pair_index := instr(index_pair, ':');

     omc_index := to_number(substr(index_pair, 1, pair_index-1));
     ne_index := to_number(substr(index_pair, pair_index+1, length(index_pair) - pair_index));

     if (omc_index + 1) > length(bit_omc_value) then
         single_omc_bit_value := 0;
     else
         single_omc_bit_value := to_number(substr(bit_omc_value, omc_index+1, 1));
     end if;

     if(single_omc_bit_value != 0 and single_omc_bit_value != 1) then
         single_omc_bit_value := 0;
     end if;

     bit_ne_value := bit_ne_value + power(2, ne_index)*single_omc_bit_value;

single_bit_pos := substr(single_bit_pos, split_index+1, length(single_bit_pos)-split_index);
END LOOP;

bit_pair := single_bit_pos;

pair_index := instr(bit_pair, ':');
bit_name := substr(bit_pair,1,pair_index-1);

index_pair := substr(bit_pair, pair_index + 1, length(bit_pair) - pair_index);
pair_index := instr(index_pair, ':');

omc_index := to_number(substr(index_pair,1,pair_index-1));
ne_index := to_number(substr(index_pair, pair_index+1, length(index_pair)-pair_index));

if omc_index + 1 > length(bit_omc_value) then
   single_omc_bit_value := 0;
else
   single_omc_bit_value := to_number(substr(bit_omc_value, omc_index+1, 1));
end if;

if single_omc_bit_value != 0 and single_omc_bit_value != 1 then
   single_omc_bit_value := 0;
end if;

bit_ne_value := bit_ne_value + power(2, ne_index)*single_omc_bit_value;

return bit_ne_value;
END;
/
create or replace function MULTIENUM_FIND_VALUE_BY_NAME(name varchar2, all_def varchar2)
return number as
new_value number(17) := 1;
begin
return new_value;
end;
/
create or replace function plsql_dts_multienum_string_to_number(enum_all_name varchar2, enum_all_def varchar2, value number)
return number as
enum_new_value number(17);
tmp_enum_all_name varchar2(2000) := enum_all_name;
split_index number;
enum_name varchar2(2000);
enum_value number;
begin
if (enum_all_name = 'NULL' or enum_all_name = '<NULL>' or enum_all_name is NULL) then
    return value;
end if;
enum_new_value := 0;
while (instr(tmp_enum_all_name, '&') != 0) loop
    split_index := instr(tmp_enum_all_name, '&');
    enum_name := substr(tmp_enum_all_name, 1, split_index-1);
    enum_value := multienum_find_value_by_name(enum_name, enum_all_def);
    if (enum_value is not NULL) then
        enum_new_value := enum_new_value + power(2, enum_value);
    end if;
    tmp_enum_all_name := substr(tmp_enum_all_name, split_index+1, length(tmp_enum_all_name)-split_index);
end loop;
enum_name := tmp_enum_all_name;
enum_value := multienum_find_value_by_name(enum_name, enum_all_def);
if (enum_value is not NULL) then
    enum_new_value := enum_new_value + power(2, enum_value);
end if;
if (enum_new_value >= 2147483648) then
    if (enum_new_value >= 4294967296) then
        enum_new_value := value;
    end if;
    enum_new_value := enum_new_value - 4294967296;
end if;
return enum_new_value;
end;
/
select plsql_dts_bitdomain_bitsets_to_number(null, null, 1234.324324) from dual;

create or replace function plsql_dts_test(value number)
return varchar
IS
begin
return upper(to_char('result :' || (value + 2)));
end;
/
select plsql_dts_test(2.33) from dual;

drop table if exists plsql_dts_tbl_NEAccess;
drop table if exists PLSQL_DTS_TBL_NEUSERGROUPACCESS;
drop table if exists plsql_dts_tbl_NEAccess_tmp;

create table plsql_dts_tbl_NEAccess(NeUser varchar, NeFdn int, CmdGroupName varchar);
create table plsql_dts_tbl_NEAccess(NeUser varchar(20), NeFdn int, CmdGroupName varchar(20));
create table PLSQL_DTS_TBL_NEUSERGROUPACCESS(NeUser varchar(20), NeFdn int, CmdGroupName varchar(20));
create table plsql_dts_tbl_NEAccess_tmp(NeUser varchar(20), NeFdn int, CmdGroupName varchar(20));

create or replace procedure neuser_syncTmpAccess
(UserType in int)
as

begin
    if UserType = 0 then
        delete from plsql_dts_tbl_NEAccess T1 where exists (select * from plsql_dts_tbl_NEAccess_tmp where NeUser=T1.NeUser and NeFdn=T1.NeFdn);
        insert into plsql_dts_tbl_NEAccess select NeUser,NeFdn,CmdGroupName from plsql_dts_tbl_NEAccess_tmp where CmdGroupName <> '*';
    else
        delete from PLSQL_DTS_TBL_NEUSERGROUPACCESS T1 where exists (select * from plsql_dts_tbl_NEAccess_tmp where NeUser=T1.NeUser and NeFdn=T1.NeFdn);
        insert into PLSQL_DTS_TBL_NEUSERGROUPACCESS select NeUser,NeFdn,CmdGroupName from plsql_dts_tbl_NEAccess_tmp where CmdGroupName <> '*';
    end if;
    delete from plsql_dts_tbl_NEAccess_tmp;
end;
/

drop table if exists plsql_dts_tbl_NEAccess;
drop table if exists PLSQL_DTS_TBL_NEUSERGROUPACCESS;
drop table if exists plsql_dts_tbl_NEAccess_tmp;

drop function plsql_dts_bitdomain_bitsets_to_number;
drop function plsql_dts_test;
drop table if exists plsql_dts_tbl_ADNPicoOSSArea;
drop table if exists plsql_dts_test;
drop table if exists plsql_dts_tbl_NeUserDefineGrp;
drop table if exists plsql_dts_tbl_BackupNeSelDefGrp;
drop table if exists plsql_dts_tbl_NEDefCmdGroupTable;
drop table if exists plsql_dts_tbl_CmdReflect;
drop table if exists plsql_dts_tbl_NEAccess;
drop table if exists PLSQL_DTS_TBL_NEUSERGROUPACCESS;
drop table if exists plsql_dts_Utils_CheckPoint;
drop user if exists plsql_dts_PMCOMDB cascade;

-- DTS2018063003073
declare
   v_real real;
   v_bigint bigint;
begin
    v_real:=9223372036854775800.7898765;
    select v_real into v_bigint from dual;
 dbe_output.print_line('result: '||v_bigint);
end;
/

select '9223372036854775800.7898765'::real::bigint;
select '8223372036854775800.7898765'::real::bigint;
select '1234567890123456789'::real::bigint;
select '123456789012345678'::real::bigint;

-- DTS2018111510733
select '9223372036854775800.7898765'::real::bigint;
select '9.2233720368547748e+18'::real::bigint;
select '9.2233720368547758e+18'::real::bigint;
select '9.2233720368547757e+18'::real:: bigint;
select '9.2233720368547750e+18'::real:: bigint;
select '9.2233720368547754e+18'::real:: bigint;
select '9.2233720368547752e+18'::real:: bigint;
select '9.2233720368547751e+18'::real::bigint;
select '-9.2233720368547758e+18'::real::bigint;
select '-9223372036854775800.78987665'::real::bigint;
select '-9.2233720368547748e+18'::real::bigint;
select '-9.2233720368547749e+18'::real::bigint;
select '-9.2233720368547750e+18'::real::bigint;
select '-9223372036854775810'::real::bigint;
select '-9223372036854775807'::real::bigint;
select '-9223372036854775808'::real::bigint;
select '9223372036854775807'::real::bigint;
select '-9.2233720368547750e+18'::real:: bigint;
select '-9.2233720368547751e+18'::real:: bigint;

--BEGIN: DTS2018071807758
DROP PROCEDURE IF EXISTS Pro_ColumnOper;
CREATE PROCEDURE Pro_ColumnOper(TableName VARCHAR,ColumnName VARCHAR,CType INT,SqlStr VARCHAR)
AS
   Rows1 INT;
   SqlStr1 VARCHAR(4000);
BEGIN
Rows1 := 0;
SELECT COUNT(*) INTO Rows1  FROM USER_TAB_COLS WHERE TABLE_NAME=UPPER(TableName) AND COLUMN_NAME=REPLACE(ColumnName, '`', '');

IF CType=1 AND Rows1<=0 THEN
    SqlStr1 := CONCAT( 'ALTER TABLE ',TableName,' ADD COLUMN ',ColumnName,' ',SqlStr);
ELSIF CType=2 AND Rows1>0  THEN
    SqlStr1 := CONCAT('ALTER TABLE ',TableName,' MODIFY ',ColumnName,' ',SqlStr);
ELSIF CType=3 AND Rows1>0 THEN
    SqlStr1 := CONCAT('ALTER TABLE  ',TableName,' DROP COLUMN  ',ColumnName);
ELSE
    SqlStr1 :='';
END IF;
IF (SqlStr1 is not null) THEN
    EXECUTE IMMEDIATE SqlStr1;
END IF;
END;
/

drop table if exists plsql_dts_test;
create table plsql_dts_test (a int,b int);
call Pro_ColumnOper('plsql_dts_test','C',1,'int');
select * from plsql_dts_test;
call Pro_ColumnOper('plsql_dts_test','C',2,'int not null');
select * from plsql_dts_test;
insert into plsql_dts_test(a) values(1);
call Pro_ColumnOper('plsql_dts_test','A',3,'');
select * from plsql_dts_test;
--END: DTS2018071807758

--BEGIN: DTS2018071310481
drop table if exists plsql_dts_tbl_loop_commit;
create table plsql_dts_tbl_loop_commit(c_id int, c_int int, c_integer integer);
INSERT INTO plsql_dts_tbl_loop_commit VALUES ( 20, 0, 10);
commit;
select c_id,c_int,c_integer from plsql_dts_tbl_loop_commit;
create unique index plsql_dts_tbl_loop_commit_ndx on plsql_dts_tbl_loop_commit(c_id,c_int,c_integer);
declare
v_sql varchar2(128);
begin
for i in 1..300
	loop
		update plsql_dts_tbl_loop_commit set c_id=c_id+2,c_int=c_int+2,c_integer=c_integer+2;
		if mod(i,2)=0
		then
			commit;
		elsif mod(i,2)=1
		then
			rollback;
		end if;

		if mod(i,5)=0
		then
			dbe_output.print_line('ROUND:'||i);
			v_sql:='drop index plsql_dts_tbl_loop_commit_ndx on plsql_dts_tbl_loop_commit';
			EXECUTE IMMEDIATE v_sql;
			v_sql:='create unique index plsql_dts_tbl_loop_commit_ndx on plsql_dts_tbl_loop_commit(c_id,c_int,c_integer)';
			EXECUTE IMMEDIATE v_sql;
		end if;
	end loop;
end;
/
select c_id,c_int,c_integer from plsql_dts_tbl_loop_commit;

drop table if exists plsql_dts_tbl_loop_commit;
create table plsql_dts_tbl_loop_commit(c_id int, c_int int, c_integer integer);
INSERT INTO plsql_dts_tbl_loop_commit VALUES ( 20, 0, 10);
commit;
select c_id,c_int,c_integer from plsql_dts_tbl_loop_commit;
create unique index plsql_dts_tbl_loop_commit_ndx on plsql_dts_tbl_loop_commit(c_id,c_int,c_integer);
declare
v_sql varchar2(128);
begin
for i in 1..300
	loop
		update plsql_dts_tbl_loop_commit set c_id=c_id+2,c_int=c_int+2,c_integer=c_integer+2;
		if mod(i,2)=0
		then
			commit;
		elsif mod(i,2)=1
		then
			rollback;
		end if;

		if mod(i,5)=0
		then
			dbe_output.print_line('ROUND:'||i);
			v_sql:='drop index plsql_dts_tbl_loop_commit_ndx on plsql_dts_tbl_loop_commit';
			EXECUTE IMMEDIATE v_sql;
			v_sql:='create unique index plsql_dts_tbl_loop_commit_ndx on plsql_dts_tbl_loop_commit(c_id,c_int,c_integer)';
			EXECUTE IMMEDIATE v_sql;
		end if;
	end loop;
end;
/
select c_id,c_int,c_integer from plsql_dts_tbl_loop_commit;
--END: DTS2018071310481

--BEGIN:DTS2018071701307
drop table if exists plsql_dts_emp_test;
create table plsql_dts_emp_test(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into plsql_dts_emp_test values(1,'zhangsan','doctor1',10000);
insert into plsql_dts_emp_test values(2,'zhangsan2','doctor2',10000);
insert into plsql_dts_emp_test values(123,'zhangsan3','doctor3',10000);
insert into plsql_dts_emp_test values(1,'zhansi','doctor1',12000);
insert into plsql_dts_emp_test values(2,'lisiabc','doctor2',13000);
insert into plsql_dts_emp_test values(123,'zhangwu123','doctor3',14000);
commit;
drop table if exists syscur_018;
create table syscur_018(empno int,edepart varchar(20));
insert into syscur_018 values(1,'jizhenshi');
insert into syscur_018 values(2,'guke');
insert into syscur_018 values(3,'xueyeke');
commit;
declare
  cv SYS_REFCURSOR;
  v_job plsql_dts_emp_test.job%type;
  v_empno  plsql_dts_emp_test.empno%type;
  v_edepart syscur_018.edepart%type;
BEGIN
       open cv for select a.empno,a.job,b.edepart from plsql_dts_emp_test a right join syscur_018 b on a.empno=b.empno group by a.empno,a.job,b.edepart order by 1,2,3;
       loop
       fetch cv into v_empno,v_job,v_edepart;
       exit when cv%notfound;
               case v_empno
               when 1 then dbe_output.print_line('empno is '||v_empno||'----->'||'job is '||v_job||'----->'||'depart is '||v_edepart);
               when 2 then dbe_output.print_line('empno is '||v_empno||'----->'||'job is '||v_job||'----->'||'depart is '||v_edepart);
               else dbe_output.print_line('empno is '||v_empno||'----->'||'job is '||v_job||'----->'||'depart is '||v_edepart);
               end case;
       end loop;
       close cv;
end;
/
--END:DTS2018071701307

--BEGIN:DTS2018071402784
create or replace function v_update(v_data in date default sysdate) return int
IS
BEGIN
EXECUTE IMMEDIATE 'set transaction isolation level serializable';
update plsql_dts_tbl_loop_commit set c_id=c_id+2,c_int=c_int+2,c_integer=c_integer+2;
return SQL%FOUND;
end v_update;
/

drop table if exists plsql_dts_tbl_loop_commit;
create table plsql_dts_tbl_loop_commit(c_id int, c_int int, c_integer integer);
INSERT INTO plsql_dts_tbl_loop_commit VALUES ( 20, 0, 10);
commit;
select c_id,c_int,c_integer from plsql_dts_tbl_loop_commit;
create unique index plsql_dts_tbl_loop_commit_ndx on plsql_dts_tbl_loop_commit(c_id,c_int,c_integer);
declare
v_sql varchar2(128);
v_id int;
begin
EXECUTE IMMEDIATE 'savepoint p1';
update plsql_dts_tbl_loop_commit set c_id=c_id+2,c_int=c_int+2,c_integer=c_integer+2;
EXECUTE IMMEDIATE 'rollback to savepoint p1';
if 1<>v_update()
then
null;
end if;
EXECUTE IMMEDIATE 'rollback to savepoint p1';
end;
/
rollback;
set transaction isolation level read committed;
--END:DTS2018071402784


drop table if exists article;
create table article(
  id number primary key, --id
  cont varchar2(4000),
  pid number,
  isleaf number(1),
  alevle number(2)
);
insert into article values(1,'1',0,0,0);
insert into article values(2,'2',1,0,1);
insert into article values(3,'3',2,1,2);
insert into article values(4,'4',2,0,2);
insert into article values(5,'5',4,1,3);
insert into article values(6,'6',1,0,1);
insert into article values(7,'7',6,1,2);
insert into article values(8,'8',6,1,2);
insert into article values(9,'9',2,0,2);
insert into article values(10,'10',9,1,3);
commit;

create or replace procedure sp_tree_recur(v_pid article.pid%type,v_level int) is
cursor c is select * from article where pid=v_pid;
v_format_string  varchar2(4000):='';
begin
 for c_article in c loop
     begin
       for i in 1..v_level loop
         v_format_string:=v_format_string||'****';
       end loop;
       dbe_output.print_line(v_format_string||c_article.cont);
       if(c_article.isleaf = 0) then
          sp_tree_recur(c_article.id,c_article.ALEVLE+1);
       end if;
     end;
 end loop;
end;
/
exec sp_tree_recur(0,0);

--core
create or replace procedure proc_UpdAttr
(iRet out number)
as
flag number;
attrgid_i number;
devid_i number;
mtype number;
stype number;
begin
declare cursor attr_cur is select iid, attrid, value from tbl_ProcAttr;

begin
for cur_data in attr_cur loop
select count(iid) into flag from tbl_ResAttr where iid = cur_data.iid and attrid = cur_data.attrid;
if flag > 0 then
update tbl_ResAttr set value = cur_data.value where iid = cur_data.iid and attrid = cur_data.attrid;
else
if cur_data.attrid >= 0 then
select attrgid into attrgid_i from tbl_ResAttrStatic where attrid = cur_data.attrid;
select devid, maintype, subtype into devid_i, mtype, stype from tbl_Resource where iid = cur_data.iid;
insert into tbl_ResAttr(iid,attrid,value,devid,maintype,subtype,attrgid)
values(cur_data.iid,cur_data.attrid,cur_data.value,devid_i,mtype,stype,attrgid_i);
else
delete tbl_ResAttr where iid = cur_data.iid and attrid = -cur_data.attrid;
end if;
end if;
end loop;
end;
commit;
iRet := 0;
exception
when others then
iRet := 1000;
rollback;
end;
/

Declare
   v_number number(5,2) :=331.225;
   v_varchar2 varchar2(30) :=v_number;
begin
    dbe_output.print_line('Hello Zenith:'||v_varchar2);
end;
/

Declare
   v_datetime date :=to_date('2018-01-07','YYYY-MM-DD');
   v_varchar2 varchar2(18) :=to_char(v_datetime,'YYYY-MM-DD');
begin
   dbe_output.print_line('Hello Zenith:'||v_varchar2);
end;
/

CREATE or replace PROCEDURE Zenith_Test_004(param1 in out varchar2 default 'hello',param2 in out varchar2 default 'zenith')
IS
    tmp varchar2(20);
begin
   tmp:=param1;
   param1:=param2;
   param2:=tmp;
end Zenith_Test_004;
/

CREATE or replace PROCEDURE Zenith_Test_004(param1 in out varchar2,param2 in out varchar2)
IS
    tmp varchar2(20);
begin
   tmp:=param1;
   param1:=param2;
   param2:=tmp;
end Zenith_Test_004;
/

Declare
   v_char1 char(8) :=null;
   v_char2 char(8) :=null;
begin
   v_char1:='A';
   v_char2:='B';
   dbe_output.print_line(v_char1||':'||v_char2);
   Zenith_Test_004(v_char1,'B');
   dbe_output.print_line(v_char1||':'||v_char2);
end;
/

Declare
   v_char1 char(8) :=null;
   v_char2 char(8) :=null;
begin
   v_char1:='A';
   v_char2:='B';
   dbe_output.print_line(v_char1||':'||v_char2);
   Zenith_Test_004(v_char1,v_char2);
   dbe_output.print_line(v_char1||':'||v_char2);
end;
/


drop table if exists plsql_dts_emp;
create table plsql_dts_emp(empno int, ename varchar(100), job varchar(100), sal int);
insert into plsql_dts_emp values(1,'whf','doctor',1222);
insert into plsql_dts_emp values(2,'whf1','doctor',2222);
insert into plsql_dts_emp values(3,'whf2','doctor1',2222);
select * from plsql_dts_emp;

declare
       cursor c_job
       is
       select *
       from plsql_dts_emp
       where job='doctor';
       c_row plsql_dts_emp%type;
begin
       open c_job;
         loop
           fetch c_job into c_row;
           exit when c_job%notfound;
            dbe_output.print_line(c_row.empno||'-'||c_row.ename||'-'||c_row.job||'-'||c_row.sal);
         end loop;
      close c_job;
end;
/

declare
       cursor c_job
       is
       select *
       from plsql_dts_emp
       where job='doctor';
       c_row plsql_dts_emp%rowtype;
       a int;
       c a%type;
       d a%rowtype;
begin
       open c_job;
         loop
           fetch c_job into c_row;
           exit when c_job%notfound;
            dbe_output.print_line(c_row.empno||'-'||c_row.ename||'-'||c_row.job||'-'||c_row.sal);
         end loop;
      close c_job;
end;
/

declare
       cursor c_job
       is
       select *
       from plsql_dts_emp
       where job='doctor';
       c_row plsql_dts_emp%rowtype;
       type rec is record(xx int);
       e rec;
       f e%type;
       g e%rowtype;
begin
       open c_job;
         loop
           fetch c_job into c_row;
           exit when c_job%notfound;
            dbe_output.print_line(c_row.empno||'-'||c_row.ename||'-'||c_row.job||'-'||c_row.sal);
         end loop;
      close c_job;
end;
/

declare

       cursor c_job
       is
       select *
       from plsql_dts_emp
       where job='doctor';
       c_row plsql_dts_emp%rowtype;
begin
       open c_job;
         loop
           fetch c_job into c_row;
           exit when c_job%notfound;
            dbe_output.print_line(c_row.empno||'-'||c_row.ename||'-'||c_row.job||'-'||c_row.sal);
         end loop;
      close c_job;
end;
/

declare

       cursor c_job
       is
       select empno
       from plsql_dts_emp
       where job='doctor';
       c_row plsql_dts_emp.empno%rowtype;
begin
       open c_job;
         loop
           fetch c_job into c_row;
           exit when c_job%notfound;
            dbe_output.print_line(c_row.empno);
         end loop;
      close c_job;
end;
/

declare

       cursor c_job
       is
       select empno
       from plsql_dts_emp
       where job='doctor';
       c_row plsql_dts_emp.empno%type;
begin
       open c_job;
         loop
           fetch c_job into c_row;
           exit when c_job%notfound;
            dbe_output.print_line(c_row);
         end loop;
      close c_job;
end;
/

delete from plsql_dts_emp;
insert into plsql_dts_emp values(1,'whf','doctor',1222);
insert into plsql_dts_emp values(2,'whf1','doctor',2222);
insert into plsql_dts_emp values(3,'whf2','doctor1',2222);
select * from plsql_dts_emp;
declare
       cursor c_job
       is
       select *
       from plsql_dts_emp
       where job='doctor';
       c_row c_job%type;
begin
       open c_job;
         loop
           fetch c_job into c_row;
           exit when c_job%notfound;
            dbe_output.print_line(c_row.empno||'-'||c_row.ename||'-'||c_row.job||'-'||c_row.sal);
         end loop;
      close c_job;
end;
/
declare
       cursor c_job
       is
       select *
       from plsql_dts_emp
       where job='doctor';
       c_row c_job%rowtype;
begin
       open c_job;
         loop
           fetch c_job into c_row;
           exit when c_job%notfound;
            dbe_output.print_line(c_row.empno||'-'||c_row.ename||'-'||c_row.job||'-'||c_row.sal);
         end loop;
      close c_job;
end;
/
drop table if exists plsql_dts_emp;


create or replace procedure proc_params(i in int, n out int, y out int, x in int default 1)
as
  strSQL varchar2(1000);
begin
  n:=i;
  dbe_output.print_line(i);
  dbe_output.print_line(n);
  dbe_output.print_line(x);
  dbe_output.print_line(y);
  y := 20;
end proc_params;
/
DECLARE
    outn int;
    outy int;
BEGIN
    proc_params(1, outn, outy);
    dbe_output.print_line(outn);
    dbe_output.print_line(outy);
END;
/
drop procedure proc_params;

drop table if exists Zenith_Test_006;
create table Zenith_Test_006(id int);
Declare
begin
    insert into Zenith_Test_006 values (1);
    rollback;
    insert into Zenith_Test_006 values (2);
    rollback;
end;
/
select * from Zenith_Test_006;
drop table if exists Zenith_Test_006;

create or replace function plsql_dts_hanoi_fun(n number, oneT char, twoT char, threeT char) return number
is
v_sql char(128);
begin
  if (n = 1) then
    dbe_output.print_line(oneT ||'---->'|| threeT);
  else
    v_sql:='call plsql_dts_hanoi_pro('||to_char(n - 1)||','''||oneT||''','''||threeT||''','''||twoT||''')';
    EXECUTE IMMEDIATE v_sql;
    dbe_output.print_line(oneT ||'---->'|| threeT);
    v_sql:='call plsql_dts_hanoi_pro('||to_char(n - 1)||','''||twoT||''','''||oneT||''','''||threeT||''')';
	EXECUTE IMMEDIATE v_sql;
  end if;
  return 0;
end plsql_dts_hanoi_fun;
/

create or replace procedure plsql_dts_hanoi_pro(n int,a varchar2,b varchar2,c varchar2)
as
v_tmp int;
v_n int :=n;
v_a varchar2(4) :=a;
v_b varchar2(4) :=b;
v_c varchar2(4) :=c;
begin
    if(1=v_n)
    then
        dbe_output.print_line(v_a||'---->'||v_c);
    else
        v_tmp:=plsql_dts_hanoi_fun(v_n-1,v_a,v_c,v_b);
        dbe_output.print_line(v_a||'---->'||v_c);
        v_tmp:=plsql_dts_hanoi_fun(v_n-1,v_b,v_a,v_c);
    end if;
end plsql_dts_hanoi_pro;
/

select plsql_dts_hanoi_fun(3, 'A', 'B', 'C') from dual;
exec plsql_dts_hanoi_pro(3, 'A', 'B', 'C');
drop function plsql_dts_hanoi_fun;
drop procedure plsql_dts_hanoi_pro;

drop procedure if exists plsql_dts_hanoi;
create or replace function plsql_dts_hanoi(n number, oneT char, twoT char, threeT char) return number
is
cn number := 0;
begin
  cn := cn + 1;
  if (n = 1) then
    dbe_output.print_line(oneT || '-->' || threeT);
  else
    cn := cn + plsql_dts_hanoi(n - 1, oneT, threeT, twoT);
    dbe_output.print_line(oneT || '-->' || threeT);
    cn := cn + plsql_dts_hanoi(n - 1, twoT, oneT, threeT);
  end if;
  return cn;
end plsql_dts_hanoi;
/
select plsql_dts_hanoi(3, 'A', 'B', 'C') from dual;
drop function plsql_dts_hanoi;

create or replace function a1() return int
as
begin
return 1;
end;
/

create or replace function a(yyy int) return int
as
begin
return a1(yyy);
end;
/

create or replace function plsql_dts_hanoi(n number, oneT char, twoT char, threeT char) return number
is
cn number := 0;
begin
  cn := cn + 1;
  if (n = 1) then
    dbe_output.print_line(oneT || '-->' || threeT);
  else
    cn := cn + plsql_dts_hanoi(to_char(n - 1), oneT, threeT, twoT);
    dbe_output.print_line(oneT || '-->' || threeT);
    cn := cn + plsql_dts_hanoi(n - 1, twoT, oneT, threeT);
  end if;
  return cn;
end plsql_dts_hanoi;
/
select plsql_dts_hanoi(3, 'A', 'B', 'C') from dual;

create or replace function plsql_dts_hanoi(n number, oneT char, twoT char, threeT char) return number
is
cn number := 0;
begin
  cn := cn + 1;
  if (n = 1) then
    dbe_output.print_line(oneT || '-->' || threeT);
  else
    cn := cn + plsql_dts_hanoi(n - 1, oneT, threeT);
    dbe_output.print_line(oneT || '-->' || threeT);
    cn := cn + plsql_dts_hanoi(n - 1, twoT, oneT, threeT);
  end if;
  return cn;
end plsql_dts_hanoi;
/

drop table if exists plsql_dts_emp;
create table plsql_dts_emp(empno int, ename varchar(100), job varchar(100), sal int);
insert into plsql_dts_emp values(1,'whf','doctor',1222);
insert into plsql_dts_emp values(2,'whf1','doctor',2222);
insert into plsql_dts_emp values(3,'whf2','doctor1',2222);
select * from plsql_dts_emp;

declare
a plsql_dts_emp%rowtype;
cursor mycursor is  select * from plsql_dts_emp where empno=1 order by ename;
begin
open mycursor;
fetch mycursor into a;
loop
open mycursor;
if  mycursor%notfound=false  then
dbe_output.print_line('a is emp:'||a.empno||'name:'||a.ename||'job:'||a.job||'sal:'||a.sal);
dbe_output.print_line(mycursor%rowcount);fetch mycursor into a;
end if;
exit
when  mycursor%notfound;
end loop;
exception
when CURSOR_ALREADY_OPEN
then
dbe_output.print_line('exception CURSOR_ALREADY_OPEN');
close mycursor;
end;
/


declare
a plsql_dts_emp%rowtype;
cursor mycursor is  select * from plsql_dts_emp where empno=1 order by ename;
begin
dbe_output.print_line(mycursor%isopen);
if  not mycursor%isopen  then
open mycursor;fetch mycursor into a;
dbe_output.print_line('a is emp:'||a.empno||'name:'||a.ename||'job:'||a.job||'sal:'||a.sal);
dbe_output.print_line(mycursor%rowcount);
end if;
dbe_output.print_line(mycursor%isopen);
if  mycursor%isopen then
dbe_output.print_line('mycursor is open');
close mycursor;
end if;
dbe_output.print_line(mycursor%isopen);
end;
/

delete from plsql_dts_emp;
insert into plsql_dts_emp values(174302,'wanghaifeng','doctor1',12000);
insert into plsql_dts_emp values(174302,'wanghaifeng1','doctor1',8000);
commit;

declare
cursor mycursor(job_real varchar2,max_sal number ) is  select empno,ename,(sal-max_sal) overpament from plsql_dts_emp where job=job_real and sal> max_sal  order by sal;
c_empno plsql_dts_emp.empno%type;
c_ename plsql_dts_emp.ename%type;
c_overpament plsql_dts_emp.sal%type;
begin
open mycursor('doctor1',9000);
fetch mycursor into c_empno,c_ename,c_overpament;
close mycursor;
dbe_output.print_line('result is ' || c_empno || ',' || c_ename || ',' || c_overpament);
end;
/

declare
max_sal1 number;
cursor mycursor(job_real varchar2,max_sal number ) is  select empno,ename,(sal-max_sal1) overpament from plsql_dts_emp where job=job_real and sal> max_sal1  order by sal;
c_empno plsql_dts_emp.empno%type;
c_ename plsql_dts_emp.ename%type;
c_overpament plsql_dts_emp.sal%type;
begin
max_sal1 := 9000;
open mycursor('doctor1',9000);
fetch mycursor into c_empno,c_ename,c_overpament;
close mycursor;
dbe_output.print_line('result is ' || c_empno || ',' || c_ename || ',' || c_overpament);
end;
/

declare
cursor mycursor(job_real varchar2,max_sal number default 9000) is  select empno,ename,(sal-max_sal) overpament from plsql_dts_emp where job=job_real and sal> max_sal  order by sal;
c_empno plsql_dts_emp.empno%type;
c_ename plsql_dts_emp.ename%type;
c_overpament plsql_dts_emp.sal%type;
begin
open mycursor('doctor1');
fetch mycursor into c_empno,c_ename,c_overpament;
close mycursor;
dbe_output.print_line('result is ' || c_empno || ',' || c_ename || ',' || c_overpament);
end;
/

declare
cursor mycursor(job_real varchar2,max_sal number default 9000) is  select empno,ename,(sal-max_sal) overpament from plsql_dts_emp where job=job_real and sal> max_sal  order by sal;
c_empno plsql_dts_emp.empno%type;
c_ename plsql_dts_emp.ename%type;
c_overpament plsql_dts_emp.sal%type;
begin
open mycursor('doctor1', max_sal=>9900);
fetch mycursor into c_empno,c_ename,c_overpament;
close mycursor;
dbe_output.print_line('result is ' || c_empno || ',' || c_ename || ',' || c_overpament);
end;
/

declare
cursor mycursor(job_real varchar2,max_sal number default 9000) is  select empno,ename,(sal-max_sal) overpament from plsql_dts_emp where job=job_real and sal> max_sal  order by sal;
c_empno plsql_dts_emp.empno%type;
c_ename plsql_dts_emp.ename%type;
c_overpament plsql_dts_emp.sal%type;
begin
open mycursor(job_real=>'doctor1');
fetch mycursor into c_empno,c_ename,c_overpament;
close mycursor;
dbe_output.print_line('result is ' || c_empno || ',' || c_ename || ',' || c_overpament);
end;
/
declare
cursor mycursor(job_real varchar2,max_sal number default 9000, f2 int) is  select empno,ename,(sal-max_sal) overpament from plsql_dts_emp where job=job_real and sal> max_sal  order by sal;
c_empno plsql_dts_emp.empno%type;
c_ename plsql_dts_emp.ename%type;
c_overpament plsql_dts_emp.sal%type;
begin
open mycursor('doctor1', f2=> 2);
fetch mycursor into c_empno,c_ename,c_overpament;
close mycursor;
dbe_output.print_line('result is ' || c_empno || ',' || c_ename || ',' || c_overpament);
end;
/

declare
cursor mycursor(job_real varchar2,max_sal number default 9000, f2 int) is  select empno,ename,(sal-max_sal) overpament from plsql_dts_emp where job=job_real and sal> max_sal  order by sal;
c_empno plsql_dts_emp.empno%type;
c_ename plsql_dts_emp.ename%type;
c_overpament plsql_dts_emp.sal%type;
begin
open mycursor('doctor1',max_sal=>8000, f2=> 2);
fetch mycursor into c_empno,c_ename,c_overpament;
close mycursor;
dbe_output.print_line('result is ' || c_empno || ',' || c_ename || ',' || c_overpament);
end;
/

declare
cursor mycursor(job_real varchar2,max_sal number default 9000, f2 int) is  select empno,ename,(sal-max_sal) overpament from plsql_dts_emp where job=job_real and sal> max_sal  order by sal;
c_empno plsql_dts_emp.empno%type;
c_ename plsql_dts_emp.ename%type;
c_overpament plsql_dts_emp.sal%type;
begin
open mycursor(job_real=>'doctor1',max_sal=>8000, f2=> 2);
fetch mycursor into c_empno,c_ename,c_overpament;
close mycursor;
dbe_output.print_line('result is ' || c_empno || ',' || c_ename || ',' || c_overpament);
end;
/

declare
cursor mycursor(job_real varchar2,max_sal number default 9000, f2 int) is  select empno,ename,(sal-max_sal) overpament from plsql_dts_emp where job=job_real and sal> max_sal  order by sal;
c_empno plsql_dts_emp.empno%type;
c_ename plsql_dts_emp.ename%type;
c_overpament plsql_dts_emp.sal%type;
begin
open mycursor('doctor1', f2=> 2, f2=>3);
fetch mycursor into c_empno,c_ename,c_overpament;
close mycursor;
dbe_output.print_line('result is ' || c_empno || ',' || c_ename || ',' || c_overpament);
end;
/

declare
cursor mycursor(job_real varchar2,max_sal number default 9000, f2 int) is  select empno,ename,(sal-max_sal) overpament from plsql_dts_emp where job=job_real and sal> max_sal  order by sal;
c_empno plsql_dts_emp.empno%type;
c_ename plsql_dts_emp.ename%type;
c_overpament plsql_dts_emp.sal%type;
begin
open mycursor('doctor1', f2=> 2, max_sal=> 5000);
fetch mycursor into c_empno,c_ename,c_overpament;
close mycursor;
dbe_output.print_line('result is ' || c_empno || ',' || c_ename || ',' || c_overpament);
end;
/

declare
cursor mycursor(job_real varchar2,max_sal number default 9000, f2 int) is  select empno,ename,(sal-max_sal) overpament from plsql_dts_emp where job=job_real and sal> max_sal  order by sal;
c_empno plsql_dts_emp.empno%type;
c_ename plsql_dts_emp.ename%type;
c_overpament plsql_dts_emp.sal%type;
begin
open mycursor(f2=> 2, max_sal=> 5000,job_real=>'doctor1');
fetch mycursor into c_empno,c_ename,c_overpament;
close mycursor;
dbe_output.print_line('result is ' || c_empno || ',' || c_ename || ',' || c_overpament);
end;
/

declare
cursor mycursor(job_real varchar2 ,max_sal number default 9000, factor int ) is  select empno,sal,sal*factor exp_sal  from plsql_dts_emp where job=job_real and sal> max_sal  order by sal;
c_empno plsql_dts_emp.empno%type;
b int;
c int;
rec mycursor%rowtype;
begin
open mycursor('doctor1',factor=>2);
fetch mycursor into c_empno,b,c;
if  mycursor%found  then
dbe_output.print_line('c_empno is emp:'||c_empno||'sal'||b||'ep_sal'||c);
dbe_output.print_line(mycursor%rowcount);
end if;
close mycursor;
open mycursor('doctor2',8000,3);
fetch mycursor into rec;
dbe_output.print_line('doctor2 c_empno is emp:'||rec.empno||'sal'||rec.sal||'ep_sal'||rec.exp_sal);
dbe_output.print_line(mycursor%rowcount);
close mycursor;
end;
/

declare
cursor mycursor(job_real varchar2 ,max_sal number default 9000, factor int ) is  select empno,sal,sal*factor exp_sal  from plsql_dts_emp where job=job_real and sal> max_sal  order by sal;
c_empno plsql_dts_emp.empno%type;
b  int;
c int;
begin
open mycursor('doctor1',factor=>2);
fetch mycursor into c_empno,b,c;
if  mycursor%found  then
dbe_output.print_line('c_empno is emp:'||c_empno||'sal'||b||'ep_sal'||c);
dbe_output.print_line(mycursor%rowcount);
end if;
close mycursor;
open mycursor('doctor2',8000,3);
fetch mycursor into c_empno;
dbe_output.print_line('doctor2 c_empno is emp:'||c_empno||'sal'||b||'ep_sal'||c);
dbe_output.print_line(mycursor%rowcount);
close mycursor;
end;
/

delete from plsql_dts_emp;

declare
cursor mycursor(job_real varchar2 ,max_sal number default 9000, factor int ) is  select empno,sal,sal*factor exp_sal  from plsql_dts_emp where job=job_real and sal> max_sal  order by sal;
c_empno plsql_dts_emp.empno%type;
b  int;
c int;
begin
open mycursor('doctor1',factor=>2);
fetch mycursor into c_empno,b,c;
if  mycursor%found  then
dbe_output.print_line('c_empno is emp:'||c_empno||'sal'||b||'ep_sal'||c);
dbe_output.print_line(mycursor%rowcount);
end if;
close mycursor;
open mycursor('doctor2',8000,3);
fetch mycursor into c_empno;
dbe_output.print_line('doctor2 c_empno is emp:'||c_empno||'sal'||b||'ep_sal'||c);
dbe_output.print_line(mycursor%rowcount);
close mycursor;
end;
/
drop table plsql_dts_emp;

begin
for a in (select * from plsql_dts_emp where ename like '%zhangsan%' and sal > 9000 order by empno;)
loop
dbe_output.print_line('a is emp:'||a.empno||'name:'||a.ename||'job:'||a.job||'sal:'||a.sal);
dbe_output.print_line(mycursor%rowcount);
end loop;
end;
/
create table plsql_dts_emp(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into plsql_dts_emp values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10000),(123,'zhangsan3','doctor3',10000);
insert into plsql_dts_emp values(1,'zhansi','doctor1',10000),(2,'lisiabc','doctor2',10000),(123,'zhangwu123','doctor3',10000);
insert into plsql_dts_emp values(10,'abc','worker',9000);

begin
for a in (select * from plsql_dts_emp where ename like '%zhangsan%' and sal > 9000 order by empno;)
loop
dbe_output.print_line('a is emp:'||a.empno||'name:'||a.ename||'job:'||a.job||'sal:'||a.sal);
dbe_output.print_line(mycursor%rowcount);
end loop;
end;
/

begin
for a  in  (select * from plsql_dts_emp where ename like '%zhangsan%' and sal > 9000 order by empno)
loop
dbe_output.print_line('a is emp:'||a.empno||'name:'||a.ename||'job:'||a.job||'sal:'||a.sal);
dbe_output.print_line(sql%rowcount);
end loop;
end;
/

drop table plsql_dts_emp;
drop table if exists plsql_dts_test;
create table plsql_dts_test(a int, b int);
select * from plsql_dts_test;
delete from plsql_dts_test;
create unique index test_idex on plsql_dts_test(a);

begin
insert into plsql_dts_test values(1,2);
insert into plsql_dts_test values(2,2);
insert into plsql_dts_test values(1,2);
end;
/

select * from plsql_dts_test;
drop table plsql_dts_test;

--dts:DTS2018071102955
--add 2018/07/17
--begin
drop PROCEDURE if exists Pro_ColumnOper;
drop table if exists I_FRAME;
create table I_FRAME (a int);

CREATE PROCEDURE Pro_ColumnOper(a VARCHAR,b VARCHAR,c INT,d VARCHAR)
AS
Rows1 INT;
BEGIN
Rows1 := 0;
dbe_output.print_line(a||b||c||d);
END;
/

CALL Pro_ColumnOper('I_FRAME','`softVersion`',1,"VARCHAR(128) ");
CALL Pro_ColumnOper('I_FRAME','`softVersion`',1,'VARCHAR(128) ');

drop PROCEDURE if exists Pro_ColumnOper;
drop table if exists I_FRAME;

--end plsql_dts_test dts:DTS2018071102955


--test dts:DTS2018071310549
drop table if exists plsql_dts_tbl_loop_commit;
create table plsql_dts_tbl_loop_commit(c_id int, c_int int, c_integer integer);
INSERT INTO plsql_dts_tbl_loop_commit VALUES ( 20, 0, 10);
commit;
select c_id,c_int,c_integer from plsql_dts_tbl_loop_commit;

create or replace function v_update(v_data in date default sysdate) return int
IS
BEGIN
    EXECUTE IMMEDIATE 'set transaction isolation level serializable';
    update plsql_dts_tbl_loop_commit set c_id=c_id+2,c_int=c_int+2,c_integer=c_integer+2;
 return SQL%FOUND;
end v_update;
/

create unique index plsql_dts_tbl_loop_commit_ndx on plsql_dts_tbl_loop_commit(c_id,c_int,c_integer);
declare
    v_sql varchar2(128);
begin
     for i in 1..30
  loop
      if 1<> v_update()
   then
       dbe_output.print_line('UPDATE FAILED:'||i);
   else
       null;
   end if;
   if mod(i,10)=0
   then
       commit;
   elsif mod(i,10)=5
   then
       rollback;
   end if;
  end loop;
end;
/
select c_id,c_int,c_integer from plsql_dts_tbl_loop_commit;
rollback;
set transaction isolation level read committed;
--end plsql_dts_test dts:DTS2018071310549


--begin:DTS2018071111512
create or replace function plsql_dts_hanoi(n number, oneT char, twoT char, threeT char) return number
is
v_sql char(128);
v_tmp int;
begin
  if (n = 1) then
    dbe_output.print_line(oneT ||'---->'|| threeT);
  else
    v_sql:='select plsql_dts_hanoi('||to_char(n - 1)||','''||oneT||''','''||threeT||''','''||twoT||''') from dual';
    EXECUTE IMMEDIATE v_sql;
    dbe_output.print_line(oneT ||'---->'|| threeT);
    v_sql:='select plsql_dts_hanoi('||to_char(n - 1)||','''||twoT||''','''||oneT||''','''||threeT||''') from dual';
 EXECUTE IMMEDIATE v_sql;
  end if;
  return 0;
end plsql_dts_hanoi;
/

select plsql_dts_hanoi(3, 'A', 'B', 'C') from dual;
--end:DTS2018071111512

--test DTS2018071708798 :the object set and the result set has same column at fetch-into
--add 2018/07/18
--begin
drop table if exists plsql_dts_emp_test;
create table plsql_dts_emp_test(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into plsql_dts_emp_test values(1,'zhangsan','doctor1',10000);
insert into plsql_dts_emp_test values(2,'zhangsan2','doctor2',10000);
insert into plsql_dts_emp_test values(123,'zhangsan3','doctor3',10000);
insert into plsql_dts_emp_test values(1,'zhansi','doctor1',12000);
insert into plsql_dts_emp_test values(2,'lisiabc','doctor2',13000);
insert into plsql_dts_emp_test values(123,'zhangwu123','doctor3',14000);
commit;

--expect error
declare
type syscur is record (
  a int,
  b int
);
cv sys_refcursor;
cv1 syscur;
begin
open cv for select empno from plsql_dts_emp_test where job like '%1%' order by empno;
loop
fetch cv into cv1;
exit when cv%notfound;
dbe_output.print_line('empno is ' || cv1.a||'---->'||'ename is '|| cv1.b);
end loop;
close cv;
end;
/

--expect error
declare
type syscur is record (
  a int,
  b int
);
cv sys_refcursor;
cv1 syscur;
begin
open cv for select empno,sal,ename from plsql_dts_emp_test where job like '%1%' order by empno;
loop
fetch cv into cv1;
exit when cv%notfound;
dbe_output.print_line('empno is ' || cv1.a||'---->'||'ename is '|| cv1.b);
end loop;
close cv;
end;
/

--expect error
declare
type syscur is record (
  a int,
  b int
);
cv sys_refcursor;
cv1 syscur;
begin
open cv for select empno,ename from plsql_dts_emp_test where job like '%1%' order by empno;
loop
fetch cv into cv1;
exit when cv%notfound;
dbe_output.print_line('empno is ' || cv1.a||'---->'||'ename is '|| cv1.b);
end loop;
close cv;
end;
/

--expect success
declare
type syscur is record (
  a int,
  b varchar2(20)
);
cv sys_refcursor;
cv1 syscur;
begin
open cv for select empno,ename from plsql_dts_emp_test where job like '%1%' order by empno;
loop
fetch cv into cv1;
exit when cv%notfound;
dbe_output.print_line('empno is ' || cv1.a||'---->'||'ename is '|| cv1.b);
end loop;
close cv;
end;
/
CREATE OR REPLACE PROCEDURE syscur(sys_cur OUT SYS_REFCURSOR)
IS
C1 SYS_REFCURSOR;
a1 number;
b1 varchar2(20);
BEGIN
OPEN C1 FOR
    SELECT empno,ename FROM plsql_dts_emp_test  where empno=1 ORDER BY empno;
sys_cur := C1;
close c1;
END;
/


DECLARE
  cv SYS_REFCURSOR;
  v_empno  plsql_dts_emp_test.empno%TYPE;
  v_ename     plsql_dts_emp_test.ename%TYPE;
  v_sal    plsql_dts_emp_test.sal%TYPE;
  query_2 VARCHAR2(200) :=
    'select * from plsql_dts_emp_test order by 1,2,3';
  v_emp_test plsql_dts_emp_test%ROWTYPE;
BEGIN
  syscur(cv);
  LOOP
    FETCH cv INTO v_empno, v_ename;
    EXIT WHEN cv%NOTFOUND;
    -- dbe_output.print_line('v_empno is :'||v_empno||'---->'||'v_ename is :'||v_ename);
	dbe_output.print_line(rpad(v_empno,25,' ')||v_ename);
  END LOOP;

  dbe_output.print_line( '-------------------------------------' );
  CLOSE cv;
END;
/

CREATE OR REPLACE PROCEDURE syscur(sys_cur OUT SYS_REFCURSOR)
IS
C1 SYS_REFCURSOR;
a1 number;
b1 varchar2(20);
BEGIN
OPEN C1 FOR
    SELECT empno,ename FROM plsql_dts_emp_test  where empno=1 ORDER BY empno;
sys_cur := C1;
END;
/


DECLARE
  cv SYS_REFCURSOR;
  v_empno  plsql_dts_emp_test.empno%TYPE;
  v_ename     plsql_dts_emp_test.ename%TYPE;
  v_sal    plsql_dts_emp_test.sal%TYPE;
  query_2 VARCHAR2(200) :=
    'select * from plsql_dts_emp_test order by 1,2,3';
  v_emp_test plsql_dts_emp_test%ROWTYPE;
BEGIN
  syscur(cv);
  LOOP
    FETCH cv INTO v_empno, v_ename;
    EXIT WHEN cv%NOTFOUND;
    -- dbe_output.print_line('v_empno is :'||v_empno||'---->'||'v_ename is :'||v_ename);
	dbe_output.print_line(rpad(v_empno,25,' ')||v_ename);
  END LOOP;

  dbe_output.print_line( '-------------------------------------' );
  CLOSE cv;
END;
/

CREATE OR REPLACE PROCEDURE syscur(sys_cur OUT SYS_REFCURSOR)
IS
C1 SYS_REFCURSOR;
a1 number;
b1 varchar2(20);
BEGIN
OPEN C1 FOR
    SELECT empno,ename FROM plsql_dts_emp_test  where empno=1 ORDER BY empno;
sys_cur := C1;
FETCH C1 into a1,b1;
END;
/


DECLARE
  cv SYS_REFCURSOR;
  v_empno  plsql_dts_emp_test.empno%TYPE;
  v_ename     plsql_dts_emp_test.ename%TYPE;
  v_sal    plsql_dts_emp_test.sal%TYPE;
  query_2 VARCHAR2(200) :=
    'select * from plsql_dts_emp_test order by 1,2,3';
  v_emp_test plsql_dts_emp_test%ROWTYPE;
BEGIN
  syscur(cv);
  LOOP
    FETCH cv INTO v_empno, v_ename;
    EXIT WHEN cv%NOTFOUND;
    -- dbe_output.print_line('v_empno is :'||v_empno||'---->'||'v_ename is :'||v_ename);
	dbe_output.print_line(rpad(v_empno,25,' ')||v_ename);
  END LOOP;

  dbe_output.print_line( '-------------------------------------' );
  CLOSE cv;
END;
/

CREATE OR REPLACE PROCEDURE syscur(sys_cur OUT SYS_REFCURSOR)
IS
C1 SYS_REFCURSOR;
a1 number;
b1 varchar2(20);
BEGIN
OPEN C1 FOR
    SELECT empno,ename FROM plsql_dts_emp_test  where empno=1 ORDER BY empno;
sys_cur := C1;
FETCH C1 into a1,b1;
FETCH C1 into a1,b1;
END;
/


DECLARE
  cv SYS_REFCURSOR;
  v_empno  plsql_dts_emp_test.empno%TYPE;
  v_ename     plsql_dts_emp_test.ename%TYPE;
  v_sal    plsql_dts_emp_test.sal%TYPE;
  query_2 VARCHAR2(200) :=
    'select * from plsql_dts_emp_test order by 1,2,3';
  v_emp_test plsql_dts_emp_test%ROWTYPE;
BEGIN
  syscur(cv);
  LOOP
    FETCH cv INTO v_empno, v_ename;
    EXIT WHEN cv%NOTFOUND;
    -- dbe_output.print_line('v_empno is :'||v_empno||'---->'||'v_ename is :'||v_ename);
	dbe_output.print_line(rpad(v_empno,25,' ')||v_ename);
  END LOOP;

  dbe_output.print_line( '-------------------------------------' );
  CLOSE cv;
END;
/

--cursor move-value will point the same cursor
declare
C1 SYS_REFCURSOR;
D1 SYS_REFCURSOR;
a1 number;
b1 varchar2(20);
BEGIN
OPEN C1 FOR
    SELECT empno,ename FROM plsql_dts_emp_test  where empno=1 ORDER BY empno;
D1 := C1;
close c1;
FETCH D1 into a1,b1;
END;
/

--cursor move-value will point the same cursor
declare
CURSOR C1 IS SELECT empno,ename FROM plsql_dts_emp_test  where empno=1 ORDER BY empno;
D1 SYS_REFCURSOR;
a1 number;
b1 varchar2(20);
BEGIN
D1 := C1;
for ind in C1 LOOP
    dbe_output.print_line('A1 is ' || a1 ||',B1 is' || b1);
END LOOP;
FETCH D1 into a1,b1;
END;
/

declare
CURSOR C1 IS SELECT empno,ename FROM plsql_dts_emp_test  where empno=1 ORDER BY empno;
CURSOR C2 IS SELECT empno,ename FROM plsql_dts_emp_test  where empno=1 ORDER BY empno;
D1 SYS_REFCURSOR;
a1 number;
b1 varchar2(20);
BEGIN
C2 := C1;
END;
/

declare
CURSOR C1 IS SELECT empno,ename FROM plsql_dts_emp_test  where empno=1 ORDER BY empno;
D1 SYS_REFCURSOR;
a1 number;
b1 varchar2(20);
BEGIN
D1 := C1;
END;
/

declare
CURSOR C1 IS SELECT empno,ename FROM plsql_dts_emp_test  where empno=1 ORDER BY empno;
D1 SYS_REFCURSOR;
a1 number;
b1 varchar2(20);
BEGIN
D1 := C1 + C1;
END;
/
--end

--test DTS2018071913156: return should jump the procedure totally.
drop table if exists trigger_tbl_028;
drop table if exists trigger_tbl_028_1;
drop table if exists trigger_tbl_028_2;
drop table if exists trigger_tbl_028_3;
drop table if exists trigger_tbl_028_4;
create table trigger_tbl_028(c_id int not null,c_d_id int not null,c_w_id int not null,c_credit_lim numeric(12,2),c_first varchar(32),c_since timestamp);
insert into trigger_tbl_028  values(1,1,1,10,'c_firstaaaaaaaa',to_timestamp('2018-01-01 00:00:00.00','yyyy-mm-dd hh24:mi:ss.ff3'));
insert into trigger_tbl_028 values(2,2,2,10,'c_firstbbbbbbbb',to_timestamp('2018-12-01 00:00:00.00','yyyy-mm-dd hh24:mi:ss.ff3'));
insert into trigger_tbl_028 values(3,3,3,10,'c_firstcccccccc',to_timestamp('2018-12-30 00:00:00.00','yyyy-mm-dd hh24:mi:ss.ff3'));
insert into trigger_tbl_028 values(1000,1000,1000,10,'c_firstdddddddd',to_timestamp('2018-12-30 00:00:00.00','yyyy-mm-dd hh24:mi:ss.ff3'));

create table trigger_tbl_028_1(c_id numeric(12,2),c_d_id numeric(4,4),c_w_id numeric(12,2));
insert into trigger_tbl_028_1 values(1,0.4361328,5000.0);
insert into trigger_tbl_028_1 values(-1,0.4000,5001.0);
insert into trigger_tbl_028_1 values(1000,0.500000,5002.0);

create table trigger_tbl_028_2(c_d_id int,c_id int ,c_w_id int,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_first varchar(32),c_last varchar(32),cc_id int,c_since timestamp);
insert into trigger_tbl_028_2 values(1000,1000,1000,1,0.11,4000.0,'c_firstbbbbbbbb','c_lastbbbbbbbb',1,to_timestamp('2018-07-18 00:00:00.00','yyyy-mm-dd hh24:mi:ss.ff3'));
insert into trigger_tbl_028_2 values(2000,2000,2000,2,0.12,4001.0,'c_firstcccccccc','c_lastcccccccc',2,to_timestamp('2018-07-18 00:00:00.00','yyyy-mm-dd hh24:mi:ss.ff3'));
insert into trigger_tbl_028_2 values(1,2000,2000,2,0.12,4001.0,'c_firstdddddddd','c_lastdddddddd',2,to_timestamp('2018-07-18 00:00:00.00','yyyy-mm-dd hh24:mi:ss.ff3'));
commit;

create table trigger_tbl_028_3(c_d_id int,c_id int ,c_w_id int,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_first varchar(32),c_last varchar(32),cc_id int,c_since timestamp);

create table trigger_tbl_028_4(c_d_id int,c_id int ,c_w_id int,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_first varchar(32),c_last varchar(32),cc_id int,c_since timestamp);
insert into trigger_tbl_028_4 values(1,2000,2000,2,0.12,4001.0,'c_firstaaaaaaaa','c_lastcccccccc',2,to_timestamp('2018-07-18 00:00:00.00','yyyy-mm-dd hh24:mi:ss.ff3'));
commit;
drop sequence if exists trigger_sequence_028;
create sequence trigger_sequence_028;
create or replace trigger trg_aft_dml_028 after delete on trigger_tbl_028_4 for each row
declare
v_c_id number(10);
v_c_d_id number(10);
v_c_w_id number(10);
v_c_credit_lim number(10);
begin
  begin
      select a.c_id,a.c_d_id,a.c_w_id+1 as c_w_id,a.c_credit_lim into v_c_id,v_c_d_id,v_c_w_id,v_c_credit_lim from trigger_tbl_028 a,trigger_tbl_028_2 b where :new.c_first=a.c_first and :new.c_last=b.c_last;
      exception
         when  NO_DATA_FOUND then
           return;
      end;
  insert into trigger_tbl_028_3 values(trigger_sequence_028.nextval,v_c_id,v_c_d_id,:new.c_credit_lim,:new.c_discount,:new.c_balance,:new.c_first,:new.c_last,v_c_w_id,:new.c_since);
  update trigger_tbl_028 set c_w_id=v_c_w_id where c_id=:new.c_d_id;
  update trigger_tbl_028_1 set c_w_id=-1 where c_id=:new.c_d_id and exists(select 1 from trigger_tbl_028_2 where c_id=:new.c_id);
end;
/


delete from trigger_tbl_028_4;
select c_id,c_d_id,c_w_id from trigger_tbl_028;
select c_id,c_d_id,c_w_id from trigger_tbl_028_1;
--expect no rows
select c_id,c_d_id,c_w_id from trigger_tbl_028_3;
select c_id,c_d_id,c_w_id from trigger_tbl_028_4;
--end

-- only one anonymous block
declare
v_order number;
begin
for i in 1..8192
loop
dbe_output.print_line('111');
end loop;
end;
declare
v_order number;
begin
for i in 1..8192
loop
dbe_output.print_line('111');
end loop;
end;
/

-- only one anonymous block
create or replace function test(a int) return number
as
v_order number := 0;
begin
for i in 1..8192
loop
dbe_output.print_line('111');
end loop;
return v_order;
end;
select test(1) from dual;
/

-- only one function
create or replace function test(a int) return number
as
v_order number := 0;
begin
begin
for i in 1..8192
loop
dbe_output.print_line('111');
end loop;
end;
return v_order;
end;
begin
 test(1);
end;
/

CREATE OR REPLACE FUNCTION Zenith_Test_005(param1 in out varchar2) return varchar2
AS
    tmp varchar2(20) :='Hello';
Begin
    dbe_output.print_line(tmp||','||param1);
    return concat(tmp,param1);
End Zenith_Test_005;
/
select Zenith_Test_005('Zenith') from dual;

CREATE OR REPLACE FUNCTION Zenith_Test_005(param1 in varchar2) return varchar2
AS
    tmp varchar2(20) :='Hello';
Begin
    dbe_output.print_line(tmp||','||param1);
    return concat(tmp,param1);
End Zenith_Test_005;
/
select Zenith_Test_005('Zenith') from dual;


CREATE OR REPLACE FUNCTION Zenith_Test_005(param1 in out varchar2) return varchar2
AS
    tmp varchar2(20) :='Hello';
Begin
    dbe_output.print_line(tmp||','||param1);
    return concat(tmp,param1);
End Zenith_Test_005;
/
select Zenith_Test_005('Zenith') from dual;

--begin
drop table if exists plsql_dts_employees;
create table plsql_dts_employees(employeesno int,ename varchar(10),job varchar(10) ,sal integer);
insert into plsql_dts_employees values(1,'zhangsan','doctor1',10000);
insert into plsql_dts_employees values(2,'zhangsan2','doctor2',10010);
insert into plsql_dts_employees values(123,'zhangsan3','doctor3',10020);
commit;
DECLARE
  TYPE empcurtyp IS REF CURSOR ;  -- strong type
  cursor1  empcurtyp;
  salv  plsql_dts_employees.sal%type;
  mulsal  plsql_dts_employees.sal%type;
  factor integer := 2;
BEGIN
  open cursor1 for select sal, sal*factor  from plsql_dts_employees ;
  loop
  dbe_output.print_line('factor is :'|| factor);
  fetch cursor1 into salv,mulsal;
  dbe_output.print_line('sal is:'|| salv ||'mulsal is:' || mulsal);
  factor := factor + 1;
  exit when cursor1%notfound;
  end loop;
  close cursor1;
END;
/

DECLARE
  factor integer := 2;
  cursor cur1 is select sal a, sal*factor b from plsql_dts_employees;
BEGIN
  for lll in cur1 loop
  dbe_output.print_line('factor is :'|| factor);
  dbe_output.print_line('sal is:'|| lll.a ||'mulsal is:' || lll.b);
  factor := factor + 1;
  end loop;
END;
/

DECLARE
  factor integer := 2;
  cursor cur1 is select sal a, sal*factor b from plsql_dts_employees;
  cursor cur2 is select sal a, sal*factor b from plsql_dts_employees;
  a1 int;
  b1 int;
BEGIN
  for lll in cur1 loop
  dbe_output.print_line('factor is :'|| factor);
  dbe_output.print_line('sal is:'|| lll.a ||'mulsal is:' || lll.b);
  factor := factor + 1;
  if factor = 3 then
     Open cur2;
  end if;
  end loop;
  fetch cur2 into a1, b1;
  dbe_output.print_line('sal is:'|| a1 ||'mulsal is:' || b1);
  close cur2;
END;
/

create or replace  function test_outf1   return sys_refcursor is
type mycurtp is  ref cursor;
cursorv1  mycurtp;
sys_cur1  sys_refcursor;
type  XXX is record(
a varchar2(100),
b number(10,1),
c number(11,1)
);
var1 XXX;
begin
--�ȸ�ֵ��
sys_cur1 := cursorv1;
open  cursorv1 for  select ename as name, sal, sal*2 ep_sal from plsql_dts_employees where ename like 'zhangsan%' ;
return  sys_cur1;
end;
/

--expect error
select test_outf1();

--expect success
declare
mycurtp sys_refcursor;
begin
mycurtp := test_outf1();
end;
/

drop table if exists plsql_dts_employees;
--end

-------------------DTS2018080206396
drop table if exists plsql_dts_employees;
create table plsql_dts_employees(employeesno int,ename varchar(10),job varchar(10) ,sal integer);
insert into plsql_dts_employees values(1,'zhangsan','doctor1',10000);
insert into plsql_dts_employees values(2,'zhangsan2','doctor2',10010);
insert into plsql_dts_employees values(123,'zhangsan3','doctor3',10020);
alter table plsql_dts_employees add hiretime date;

create or replace function test_outf return sys_refcursor
is
cursorv1 sys_refcursor;
begin
open cursorv1 for select ename as name, sal, sal*2 ep_sal from plsql_dts_employees where ename like 'zhangsan%' ;
return cursorv1;
end;
/

declare
sys_cur1 sys_refcursor;
type XXX is record(
a varchar2(100),
b number(10,1),
c number(11,1)
);
var1 XXX;
begin
open sys_cur1 for select test_outf() from dual;
loop
fetch sys_cur1 into var1;
exit when sys_cur1%notfound;
dbe_output.print_line('��'||sys_cur1%rowcount||'�� +'||var1.a||'+'||var1.b||'+'||var1.c);
end loop;
close sys_cur1;
end;
/
-------------------DTS2018080206396
drop table if exists plsql_dts_test;
create table plsql_dts_test (a int);
insert into plsql_dts_test values(1),(2);
select * from plsql_dts_test;
begin
insert into plsql_dts_test values('aaa');
end;
/
select * from plsql_dts_test;
rollback;
select * from plsql_dts_test;
insert into plsql_dts_test values(3),(4);
begin
insert into plsql_dts_test values(5);
insert into plsql_dts_test values('aaa');
end;
/
select * from plsql_dts_test;
begin
insert into plsql_dts_test values(5);
commit;
insert into plsql_dts_test values('aaa');
end;
/
select * from plsql_dts_test;

drop table if exists plsql_dts_test;
create table plsql_dts_test (a int);
create or replace procedure insert_test
is
begin
insert into plsql_dts_test values('aaa');
end;
/
insert into plsql_dts_test values(1),(2);
select * from plsql_dts_test;
exec insert_test;
select * from plsql_dts_test;
rollback;
select * from plsql_dts_test;
create or replace procedure insert_test
is
begin
insert into plsql_dts_test values(5);
insert into plsql_dts_test values('aaa');
end;
/
insert into plsql_dts_test values(3),(4);
exec insert_test;
select * from plsql_dts_test;
rollback;
select * from plsql_dts_test;
create or replace procedure insert_test
is
begin
insert into plsql_dts_test values(5);
commit;
insert into plsql_dts_test values('aaa');
end;
/
insert into plsql_dts_test values(3),(4);
exec insert_test;
select * from plsql_dts_test;
--------------------
begin
for i in 1...10 loop
null;
end loop;
end;
/

begin
for i in 1.. .10 loop
null;
end loop;
end;
/

begin
for i in 1.. ..10 loop
null;
end loop;
end;
/
---------------DTS2018073105339
drop table if exists plsql_dts_emp;
create table plsql_dts_emp(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into plsql_dts_emp values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10000),(123,'zhangsan3','doctor3',10000);
insert into plsql_dts_emp values(1,'zhansi','doctor1',10000),(2,'lisiabc','doctor2',10000),(123,'zhangwu123','doctor3',10000);
insert into plsql_dts_emp values(10,'abc','worker',9000);
insert into plsql_dts_emp values(716,'ZHANGSAN','leader',20000);
create or  replace procedure procedure2(a int) is
cursor mycursor is select * from plsql_dts_emp where empno != 123 and sal=10000;
b plsql_dts_emp%rowtype;
mysyscur  sys_refcursor;
strSQL1 varchar(1000);
strSQL2 varchar(1000);
begin
strSQL1 := 'select * from plsql_dts_emp  where  sal <> 10000';
strSQL2 := '';
 if a <= 10 then
   for i in mycursor
   loop
    dbe_output.print_line(i.ename||' is not 10000');
   end loop;
 elsif a >10  then
  open mysyscur for  strSQL1;
  fetch mysyscur into  a;  --fetch ���󣬱���
  dbe_output.print_line(b.ename||' a > 10 and a < 100');
  close mycursor;
 else
  open mysyscur for strSQL2;
  dbe_output.print_line('else a > 10 and a < 100');
 end if;
end;
/
---------------------
drop table if exists trigger_tbl_046;
drop table if exists trigger_tbl_046_1;
create table trigger_tbl_046(i int);
create table trigger_tbl_046_1(i int);
create or replace procedure proc_1
is
begin
   loop
    if (true)
      then
        insert into trigger_tbl_046_1 values(1);
        goto end_loop;
    end if;
   end loop;
  <<end_loop>> --label
end;
/
select * from trigger_tbl_046_1;
call proc_1;
select * from trigger_tbl_046_1;
begin
   loop
    if (true)
      then
        insert into trigger_tbl_046_1 values(1);
        goto end_loop;
    end if;
   end loop;
  <<end_loop>> --label
end;
/
select * from trigger_tbl_046_1;
create or replace function func_1 return int
is
begin
   loop
    if (true)
      then
        insert into trigger_tbl_046_1 values(1);
        goto end_loop;
    end if;
   end loop;
  <<end_loop>> --label
  return 0;
end;
/
select func_1() from dual;
select * from trigger_tbl_046_1;

drop procedure proc_1;
drop function func_1;

drop table if exists trigger_tbl_041;
drop table if exists trigger_tbl_041_1;
create table trigger_tbl_041(i int);
create table trigger_tbl_041_1(i int);
create or replace trigger trg_aft_dml_041 before insert on trigger_tbl_041
declare
i number;
begin
   for i in 1...10 loop
        insert into trigger_tbl_041_1 values(i);
      end loop;
end;
/
insert into trigger_tbl_041 values(11);
create or replace trigger trg_aft_dml_041 before insert on trigger_tbl_041
declare
i number;
begin
for i in 1...10 loop
    insert into trigger_tbl_041_1 values(i);
end loop;
end;
/
drop table if exists plsql_dts_employees;
create table plsql_dts_employees(employeesno int,ename varchar(10),job varchar(10) ,sal integer);
insert into plsql_dts_employees values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10010),(123,'zhangsan3','doctor3',10020);
alter table plsql_dts_employees add  hiretime datetime;
DECLARE
type rectype is record(
a int,
b varchar(10),
e varchar(10),
c integer,
d  int
);
var2 rectype;
var1  var2%type;
TYPE empcurtyp IS REF CURSOR ;
cursor1  empcurtyp;
BEGIN
 var1.b:='record';
 dbe_output.print_line('record  is:'||var1.b||' '||var1.a);
  open cursor1 for select EMPLOYEESNO,ENAME,job,SAL,HIRETIME  from plsql_dts_employees order by EMPLOYEESNO;
  loop
  fetch cursor1 into var1;
  exit
  when cursor1%notfound ;
dbe_output.print_line('record  is:'||var1.b||' '||var1.a||' '||var1.d);
  end loop;
  close cursor1;
END;
/
insert into plsql_dts_employees values(1,'test','worker',10000,'2018-08-01');

drop table if exists plsql_dts_employees;
create table plsql_dts_employees(employeesno int,ename varchar(10),job varchar(10) ,sal integer);
insert into plsql_dts_employees values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10010),(123,'zhangsan3','doctor3',10020);
alter table plsql_dts_employees add  hiretime datetime;
select * from plsql_dts_employees;
DECLARE
type rectype is record(
a int,
b varchar(10),
e varchar(10),
c integer,
d  int
);
var2 rectype;
var1  var2%type;
TYPE empcurtyp IS REF CURSOR ;
cursor1  empcurtyp;
BEGIN
 var1.b:='record';
 dbe_output.print_line('record  is:'||var1.b||' '||var1.a);
  open cursor1 for select EMPLOYEESNO,ENAME,job,SAL,HIRETIME  from plsql_dts_employees order by EMPLOYEESNO;
  loop
  fetch cursor1 into var1;
  exit
  when cursor1%notfound ;
  dbe_output.print_line('record  is:'||var1.b||' '||var1.a||' '||var1.d);
  end loop;
  close cursor1;
END;
/
insert into plsql_dts_employees values(1,'test','worker',10000,'2018-08-01');
select * from plsql_dts_employees;
DECLARE
type rectype is record(
a int,
b varchar(10),
e varchar(10),
c integer,
d  int
);
var2 rectype;
var1  var2%type;
TYPE empcurtyp IS REF CURSOR ;
cursor1  empcurtyp;
BEGIN
 var1.b:='record';
 dbe_output.print_line('record  is:'||var1.b||' '||var1.a);
  open cursor1 for select EMPLOYEESNO,ENAME,job,SAL,HIRETIME  from plsql_dts_employees order by EMPLOYEESNO;
  loop
  fetch cursor1 into var1;
  exit
  when cursor1%notfound ;
  dbe_output.print_line('record  is:'||var1.b||' '||var1.a||' '||var1.d);
  end loop;
  close cursor1;
END;
/

select * from plsql_dts_employees;

------------------argument view
conn sys/Huawei@123@127.0.0.1:1611
grant select on sys.SYS_PROC_ARGS to gs_plsql_dts;
conn gs_plsql_dts/Whf00174302@127.0.0.1:1611
select object_name,argument_name from sys.SYS_PROC_ARGS where object_name = 'AAA' order by argument_name;
select object_name,argument_name from dba_arguments where object_name = 'AAA' order by argument_name;
select object_name,argument_name from all_arguments where object_name = 'AAA' order by argument_name;
select object_name,argument_name from user_arguments where object_name = 'AAA' order by argument_name;
create or replace function aaa(a int) return sys_refcursor
is
b int;
begin
null;
end;
/

select object_name,argument_name from sys.SYS_PROC_ARGS where object_name = 'AAA' order by argument_name;
select object_name,argument_name from dba_arguments where object_name = 'AAA' order by argument_name;
select object_name,argument_name from all_arguments where object_name = 'AAA' order by argument_name;
select object_name,argument_name from user_arguments where object_name = 'AAA' order by argument_name;
create or replace function aaa(a int) return sys_refcursor
is
b int;
begin
null;
end;
/

select object_name,argument_name from sys.SYS_PROC_ARGS where object_name = 'AAA' order by argument_name;
select object_name,argument_name from dba_arguments where object_name = 'AAA' order by argument_name;
select object_name,argument_name from all_arguments where object_name = 'AAA' order by argument_name;
select object_name,argument_name from user_arguments where object_name = 'AAA' order by argument_name;
drop function aaa;
select object_name,argument_name from sys.SYS_PROC_ARGS where object_name = 'AAA' order by argument_name;
select object_name,argument_name from dba_arguments where object_name = 'AAA' order by argument_name;
select object_name,argument_name from all_arguments where object_name = 'AAA' order by argument_name;
select object_name,argument_name from user_arguments where object_name = 'AAA' order by argument_name;
create or replace procedure aaa(a int)
is
b int;
begin
null;
end;
/

select object_name,argument_name from sys.SYS_PROC_ARGS where object_name = 'AAA' order by argument_name;
select object_name,argument_name from dba_arguments where object_name = 'AAA' order by argument_name;
select object_name,argument_name from all_arguments where object_name = 'AAA' order by argument_name;
select object_name,argument_name from user_arguments where object_name = 'AAA' order by argument_name;
create or replace procedure aaa(a int)
is
b int;
begin
null;
end;
/

select object_name,argument_name from sys.SYS_PROC_ARGS where object_name = 'AAA' order by argument_name;
select object_name,argument_name from dba_arguments where object_name = 'AAA' order by argument_name;
select object_name,argument_name from all_arguments where object_name = 'AAA' order by argument_name;
select object_name,argument_name from user_arguments where object_name = 'AAA' order by argument_name;
drop procedure aaa;

select object_name,argument_name from sys.SYS_PROC_ARGS where object_name = 'AAA' order by argument_name;
select object_name,argument_name from dba_arguments where object_name = 'AAA' order by argument_name;
select object_name,argument_name from all_arguments where object_name = 'AAA' order by argument_name;
select object_name,argument_name from user_arguments where object_name = 'AAA' order by argument_name;
create or replace procedure aaa(a int)
is
b int;
begin
NULL;
end;
/
rollback;
select object_name,argument_name from sys.SYS_PROC_ARGS where object_name = 'AAA' order by argument_name;
select object_name,argument_name from dba_arguments where object_name = 'AAA' order by argument_name;
select object_name,argument_name from all_arguments where object_name = 'AAA' order by argument_name;
select object_name,argument_name from user_arguments where object_name = 'AAA' order by argument_name;

drop procedure aaa;

select object_name,argument_name from sys.SYS_PROC_ARGS where object_name = 'AAA' order by argument_name;
select object_name,argument_name from dba_arguments where object_name = 'AAA' order by argument_name;
select object_name,argument_name from all_arguments where object_name = 'AAA' order by argument_name;
select object_name,argument_name from user_arguments where object_name = 'AAA' order by argument_name;

-----------------------------expect error
CREATE OR REPLACE PROCEDURE proc_getdatabypage(v_SqlStr IN varchar2,
v_PageSize IN NUMBER,
v_CurrentPage IN NUMBER) as
   v_refcur SYS_REFCURSOR;
   v_refcur2 SYS_REFCURSOR;
   v_FirstRec  NUMBER(10,0);
   v_LastRec  NUMBER(10,0);
   v_dt  VARCHAR2(10);
   SWV_SqlStr varchar2(8000);
BEGIN
   begin
   v_dt := SUBSTR(CAST(DBE_RANDOM.GET_STRING('U',3) AS VARCHAR2),3,10);
   dbe_output.print_line(v_dt);
   end;
END;
/
-----------------------------DTS2018080608513
drop table if exists plsql_dts_emp;
create table plsql_dts_emp(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into plsql_dts_emp values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10000),(123,'zhangsan3','doctor3',10000);
insert into plsql_dts_emp values(1,'zhansi','doctor1',10000),(2,'lisiabc','doctor2',10000),(123,'zhangwu123','doctor3',10000);
insert into plsql_dts_emp values(10,'abc','worker',9000);
insert into plsql_dts_emp values(716,'ZHANGSAN','leader',20000);
drop table if exists plsql_dts_emp2;
create table plsql_dts_emp2(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into plsql_dts_emp2 values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10000),(123,'zhangsan3','doctor3',10000);

create or replace procedure p1(selected char) is
   a plsql_dts_emp%rowtype;
   v_refcur1 SYS_REFCURSOR;
    v_refcur2 SYS_REFCURSOR;
    v_refcur3 SYS_REFCURSOR;
 v_refcur4 SYS_REFCURSOR;
 v_refcur5 SYS_REFCURSOR;
v_refcur6 SYS_REFCURSOR;
v_refcur7 SYS_REFCURSOR;
begin
case selected
when 'A' then
--�α�󶨵�select���оۼ��������order by�Ӿ�
open v_refcur1 for    select sum(sal) he from plsql_dts_emp where ename like '%zhangsan%' and sal > 9000 order by empno;
dbe_sql.return_cursor(v_refcur1);
--�α�󶨵�select����ϵͳ��ͼ
open v_refcur2 for  select EMPNO,ENAME,JOB,SAL,NAME from plsql_dts_emp,SYS_USERS where plsql_dts_emp.ename=user$.NAME and  plsql_dts_emp.ename like '%ZHANGSAN%' and plsql_dts_emp.sal > 9000 order by empno;
dbe_sql.return_cursor(v_refcur2);
when 'B' then
--�α�󶨵�select����union���where�Ӿ�
open v_refcur3 for select * from plsql_dts_emp union select * from plsql_dts_emp2  where  ename like '%ZHANGSAN%' and sal > 9000 order by empno;
dbe_sql.return_cursor(v_refcur3);
 open v_refcur4 for select * from plsql_dts_emp union select * from plsql_dts_emp2;
 dbe_sql.return_cursor(v_refcur4);
when others then
 open v_refcur5 for select * from plsql_dts_emp where exists (select * from plsql_dts_emp2 where plsql_dts_emp2.ename=emp.ename);
  dbe_sql.return_cursor(v_refcur5);
end case;
end;
/
----------------------------
drop table plsql_dts_employees;
create table plsql_dts_employees(employeesno int,ename varchar(10),job varchar(10) ,sal integer);
insert into plsql_dts_employees values(1,'zhangsan','doctor1',10000);
insert into plsql_dts_employees values(2,'zhangsan2','doctor2',10010);
insert into plsql_dts_employees values(123,'zhangsan3','doctor3',10020);
alter table plsql_dts_employees add  hiretime date;


DECLARE
  TYPE empcurtyp IS REF CURSOR ;  -- strong type
  cursor1  empcurtyp;
  syscur_001 sys_refcursor;
  a varchar(100);
  b  plsql_dts_employees%rowtype;
  querystr2 varchar2(1000) := 'select *  from plsql_dts_employees order by ename';
  c int;
BEGIN
  open cursor1 for select ename  from plsql_dts_employees ;
  loop
  fetch cursor1 into a;
  dbe_output.print_line('a is:'||a);
  exit when cursor1%notfound;
  end loop;
  close cursor1;
  open cursor1 for querystr2;
  loop
    fetch cursor1 into b;
   dbe_output.print_line('b is:'||b.ename||''||b.sal);
   if cursor1%notfound  then
      goto end_loop;
   end if;
  end loop;
  <<end_loop>>  --label
  close cursor1;
END;
/
---------------------expected error
create or replace procedure proc_CreatePortDataView as
   v_refcur SYS_REFCURSOR;
   v_iTBLCnt  INT;
   v_vchTempText  VARCHAR2(1024);
BEGIN
   v_iTBLCnt := 0;

   v_vchTempText := 'create or replace view view_PortData  as ';
   v_vchTempText := v_vchTempText || ' select *  from plsql_dts_employees ';
   v_iTBLCnt := v_iTBLCnt + 1;

   IF  (v_iTBLCnt > 0) then
      open v_refcur for v_vchTempText;
      dbe_sql.return_cursor(v_refcur);
   end if;
END;
/

call proc_CreatePortDataView();
----------------------
drop table if exists PMS_TEMPLATE_INDICATOR;
create table PMS_TEMPLATE_INDICATOR
(
   MONITOR_TMPL_ID INT not null,
   PMS_RES_TYPE_ID INT not null,
   INDICATOR_GRP_ID INT not null,
   INDICATOR_ID INT not null,
   IS_NE_PERSISTENT INT,
   CONSTRAINT PK_PMS_TEMPLATE_INDICATOR PRIMARY KEY(PMS_RES_TYPE_ID,MONITOR_TMPL_ID,INDICATOR_GRP_ID,INDICATOR_ID)
);

create index PMS_TEMPLATE_INDICATOR_N1
on PMS_TEMPLATE_INDICATOR
(MONITOR_TMPL_ID,
INDICATOR_ID);

drop table if exists PMS_COLLECTION;
create table PMS_COLLECTION
(
   INDICATOR_GRP_ID INT not null,
   RES_ID VARCHAR(252) not null,
   COLLECTION_TYPE INT not null,
   PERIOD_MINUTES INT not null,
   RES_NAME VARCHAR(255),
   NE_ID INT,
   MONITOR_TMPL_ID INT,
   PROCESS_ID INT not null,
   COLLECTOR_PROCHANDLE INT,
   MIB_INDEX VARCHAR(512),
   START_TIME DATETIME,
   END_TIME DATETIME,
   MONITOR_STATUS INT,
   SCHEDULE_ID INT,
   TDT_MAIN_TYPE_ID INT,
   TDT_SUB_TYPE_ID INT,
   IS_NE_LEVEL INT   DEFAULT  0,
   CONSTRAINT PK_PMS_COLLECTION PRIMARY KEY(INDICATOR_GRP_ID,RES_ID,PERIOD_MINUTES,COLLECTION_TYPE,PROCESS_ID)
);

create index PMS_COLLECTION_N1
on PMS_COLLECTION
(COLLECTOR_PROCHANDLE);

drop table if exists PMS_MONITOR_INSTANCE;
create table PMS_MONITOR_INSTANCE
(
   MONITOR_INST_ID INT not null,
   MONITOR_TMPL_ID INT,
   RES_ID VARCHAR(255),
   NE_ID INT,
   INSTANCE_TYPE INT,
   PERIOD_MINUTES INT,
   START_TIME DATETIME,
   END_TIME DATETIME,
   MONITOR_STATUS INT,
   SCHEDULE_ID INT,
   IS_MEMBER INT,
   CLIENT_TYPE INT   DEFAULT  0,
   PERIOD_TYPE INT,
   PMS_RES_TYPE_ID INT not null,
   IS_NE_LEVEL INT   DEFAULT  0,
   IS_AUTO SMALLINT   DEFAULT  0,
   CREATE_TIME DATETIME,
   LATEST_START_TIME DATETIME,
   INSTANCE_NAME VARCHAR(300),
   TREND_STATUS INT not null  DEFAULT  -1,
   VAR_COLUMN_1 VARCHAR(500),
   IS_AGG_INST SMALLINT not null  DEFAULT  0,
   IS_NPMS_INSTANCE SMALLINT not null  DEFAULT  0,
   CONSTRAINT PK_PMS_MONITOR_INSTANCE PRIMARY KEY(MONITOR_INST_ID)
);
create index PMS_MONITOR_INSTANCE_N1
on PMS_MONITOR_INSTANCE
(NE_ID);
create index PMS_MONITOR_INSTANCE_N2
on PMS_MONITOR_INSTANCE
(MONITOR_TMPL_ID);
create index PMS_MONITOR_INSTANCE_N3
on PMS_MONITOR_INSTANCE
(RES_ID);

drop table if exists TDT_RES_TYPE_MEMBER;
create table TDT_RES_TYPE_MEMBER(MEMBER_ID int, PARENT_ID int);
drop table if exists PMS_TEMPLATE_MEMBER;
create table PMS_TEMPLATE_MEMBER(MEMBER_ID int, PARENT_ID int);


CREATE OR REPLACE PROCEDURE p_EquivalentRecordValue (v_b_iscomposite_res_type BOOLEAN, v_en_access_query_type INT, v_ul_res_type_id INT, v_b_u2k_flag BOOLEAN)
as
    v_nNumberOfIndicators INT;
    v_nNumberOfCollections INT;
    v_dEquivalentRecordValue FLOAT;
    v_dFinalERValue FLOAT;
    v_nProcessID INT;
    v_nMemberID INT;
    v_nZero INT;
    v_nPeriod INT;
    v_dtmpERValue FLOAT;
    v_dDifERValue FLOAT;
    HAS_DATA INT DEFAULT 0;
    SWV_CurNum INT DEFAULT 0;
    c_get_indicator_collection_simple sys_refcursor;
	c_get_indicator_collection_access_bulk sys_refcursor;
	c_get_indicator_collection_access_snmp sys_refcursor;
	c_get_indicator_collection_composite sys_refcursor;
BEGIN
    v_nNumberOfIndicators := 0;
    v_nNumberOfCollections := 0;
    v_dEquivalentRecordValue := 0.0;
    v_dFinalERValue := 0.0;
    v_nProcessID := 0;
    v_nMemberID := 0;
    v_nZero := 0;
    v_nPeriod := 0;

	/*------------------------------------------- Read and calculate the raw records -------------------------------------------*/
    IF (v_b_iscomposite_res_type <> 0) THEN
        open c_get_indicator_collection_simple FOR
        SELECT COUNT(DISTINCT TBL_COLLECTION_INDICATOR.INDICATOR_ID), COUNT(DISTINCT TBL_INST_INFO.RES_ID), TBL_COLLECTION_INDICATOR.PROCESS_ID, TBL_COLLECTION_INDICATOR.PMS_RES_TYPE_ID, TBL_COLLECTION_INDICATOR.PERIOD_MINUTES
        FROM
            (
                SELECT a.INDICATOR_GRP_ID, b.INDICATOR_ID,a.RES_ID,a.MONITOR_TMPL_ID,a.PROCESS_ID,b.PMS_RES_TYPE_ID,a.PERIOD_MINUTES
                FROM  PMS_TEMPLATE_INDICATOR b, PMS_COLLECTION a
                WHERE  b.PMS_RES_TYPE_ID
                IN (
                        SELECT MEMBER_ID
                        FROM TDT_RES_TYPE_MEMBER
                        WHERE PARENT_ID = v_ul_res_type_id
                   )
                AND a.MONITOR_STATUS = 1
                AND a.COLLECTION_TYPE = 0
                AND a.INDICATOR_GRP_ID = b.INDICATOR_GRP_ID
                AND a.MONITOR_TMPL_ID = b.MONITOR_TMPL_ID
            ) TBL_COLLECTION_INDICATOR,
            (
                SELECT RES_ID
                FROM PMS_MONITOR_INSTANCE
                WHERE IS_MEMBER = 1 AND MONITOR_TMPL_ID
                IN (
                        SELECT MEMBER_ID
                        FROM PMS_TEMPLATE_MEMBER
                        WHERE PARENT_ID
                        IN (
                                SELECT DISTINCT MONITOR_TMPL_ID
                                FROM PMS_MONITOR_INSTANCE
                                WHERE PMS_RES_TYPE_ID = v_ul_res_type_id
                          )
                  )
            ) TBL_INST_INFO
        WHERE TBL_COLLECTION_INDICATOR.RES_ID = TBL_INST_INFO.RES_ID
        GROUP BY TBL_COLLECTION_INDICATOR.INDICATOR_GRP_ID, TBL_COLLECTION_INDICATOR.MONITOR_TMPL_ID, TBL_COLLECTION_INDICATOR.PROCESS_ID, TBL_COLLECTION_INDICATOR.PMS_RES_TYPE_ID, TBL_COLLECTION_INDICATOR.PERIOD_MINUTES;
	end if;
END;
/

drop table if exists t;
create table t (
    id   int,
    des varchar(32),
    pid  int
);
create or replace procedure f_c(id_ IN OUT int, desc_ varchar, pid_ int, level_ int)
IS
    l_pid int;
begin
    l_pid   := pid_;

    if level_ - 1 < 0 then
        return;
    end if;

    insert into t values (id_, desc_, l_pid);
    l_pid  := id_;
    id_ := id_ + 1;

    for i in 0..3 loop
        f_c(id_, desc_ || chr(65 + i), l_pid, level_ - 1);
    end loop;
end;
/

declare
    id int := 1;
begin
    f_c(id, '', NULL, 3);
end;
/



-- DTS2018081305809
create or replace function my_current_timestamp() return timestamp
IS
timestamp_para timestamp;
begin
     timestamp_para :=to_timestamp('2018-07-26 12:00:01.12112','YYYY-MM-DD HH:MI:SS.ff6');
     return timestamp_para;
end;
/
select my_current_timestamp(),substring (my_current_timestamp() from 1 for 4) year;
select my_current_timestamp(),substring (my_current_timestamp() from 6 for 5) month_day;
select my_current_timestamp(),substring (my_current_timestamp() from 12 ) time;


create or replace function pfa_func return timestamp
IS
ts_var timestamp;
begin
	ts_var := systimestamp;
	return ts_var;
end;
/

drop table if exists PFA_TBL2;
create table PFA_TBL2 as select pfa_func() y from dual;
desc PFA_TBL2


create or replace function pfa_func return number
IS
ts_var timestamp;
begin
	ts_var := systimestamp;
	return '123123.333';
end;
/

drop table if exists PFA_TBL2;
create table PFA_TBL2 as select pfa_func() y from dual;
desc PFA_TBL2


create or replace function pfa_func return char
IS
ts_var timestamp;
begin
	ts_var := systimestamp;
	return '123123.333';
end;
/

drop table if exists PFA_TBL2;
create table PFA_TBL2 as select pfa_func() y from dual;
desc PFA_TBL2


create or replace function pfa_func return varchar
IS
ts_var timestamp;
begin
	ts_var := systimestamp;
	return '123123.333';
end;
/

drop table if exists PFA_TBL2;
create table PFA_TBL2 as select pfa_func() y from dual;
desc PFA_TBL2


create or replace function pfa_func return varchar
IS
char_var varchar(32760);
begin
	char_var := '1234567890-=qwertyuiop[]\asdfghjkl;zxcvbnm,./{}|?<>~`_+QWERTYUIOPASDFGHJKLZXCVBNM1234567890-=qwertyuiop[]\asdfghjkl;zxcvbnm,./{}|?<>~`_+QWERTYUIOPASDFGHJKLZXCVBNM1234567890-=qwertyuiop[]\asdfghjkl;zxcvbnm,./{}|?<>~`_+QWERTYUIOPASDFGHJKLZXCVBNM1234567890-=qwertyuiop[]\asdfghjkl;zxcvbnm,./{}|?<>~`_+QWERTYUIOPASDFGHJKLZXCVBNM1234567890-=qwertyuiop[]\asdfghjkl;zxcvbnm,./{}|?<>~`_+QWERTYUIOPASDFGHJKLZXCVBNM1234567890-=qwertyuiop[]\asdfghjkl;zxcvbnm,./{}|?<>~`_+QWERTYUIOPASDFGHJKLZXCVBNM1234567890-=qwertyuiop[]\asdfghjkl;zxcvbnm,./{}|?<>~`_+QWERTYUIOPASDFGHJKLZXCVBNM1234567890-=qwertyuiop[]\asdfghjkl;zxcvbnm,./{}|?<>~`_+QWERTYUIOPASDFGHJKLZXCVBNM1234567890-=qwertyuiop[]\asdfghjkl;zxcvbnm,./{}|?<>~`_+QWERTYUIOPASDFGHJKLZXCVBNM1234567890-=qwertyuiop[]\asdfghjkl;zxcvbnm,./{}|?<>~`_+QWERTYUIOPASDFGHJKLZXCVBNM1234567890-=qwertyuiop[]\asdfghjkl;zxcvbnm,./{}|?<>~`_+QWERTYUIOPASDFGHJKLZXCVBNM1234567890-=qwertyuiop[]\asdfghjkl;zxcvbnm,./{}|?<>~`_+QWERTYUIOPASDFGHJKLZXCVBNM1234567890-=qwertyuiop[]\asdfghjkl;zxcvbnm,./{}|?<>~`_+QWERTYUIOPASDFGHJKLZXCVBNM1234567890-=qwertyuiop[]\asdfghjkl;zxcvbnm,./{}|?<>~`_+QWERTYUIOPASDFGHJKLZXCVBNM1234567890-=qwertyuiop[]\asdfghjkl;zxcvbnm,./{}|?<>~`_+QWERTYUIOPASDFGHJKLZXCVBNM1234567890-=qwertyuiop[]\asdfghjkl;zxcvbnm,./{}|?<>~`_+QWERTYUIOPASDFGHJKLZXCVBNM';
	char_var := char_var || char_var;
	char_var := char_var || char_var;
	char_var := char_var || char_var;
	-- length(char_var) = 10368
	return char_var;
end;
/

drop table if exists PFA_TBL2;
-- overlength error
create table PFA_TBL2 as select pfa_func() y from dual;
desc PFA_TBL2


create or replace function pfa_func return raw
IS
ts_var timestamp;
begin
	ts_var := systimestamp;
	return '123123333';
end;
/

drop table if exists PFA_TBL2;
create table PFA_TBL2 as select pfa_func() y from dual;
desc PFA_TBL2


create or replace function pfa_func return clob
IS
ts_var timestamp;
begin
	ts_var := systimestamp;
	return '123123333';
end;
/

drop table if exists PFA_TBL2;
create table PFA_TBL2 as select pfa_func() y from dual;
desc PFA_TBL2


create or replace function pfa_func return interval year to month
IS
ts_var timestamp;
begin
	ts_var := systimestamp;
	return numtoyminterval(12.33, 'YEAR');
end;
/

drop table if exists PFA_TBL2;
create table PFA_TBL2 as select pfa_func() y from dual;
desc PFA_TBL2
select * from pfa_tbl2;

create or replace function pfa_func return interval day to second
IS
ts_var timestamp;
begin
	ts_var := systimestamp;
	return numtodsinterval(12.333333, 'DAY');
end;
/

drop table if exists PFA_TBL2;
create table PFA_TBL2 as select pfa_func() y from dual;
desc PFA_TBL2
select * from pfa_tbl2;

----------------------------------------
create user plsql_dts_whf identified by Whf00174302;
create user plsql_dts_mcdb identified by Whf00174302;

grant dba to plsql_dts_whf;
grant dba to plsql_dts_mcdb;

conn plsql_dts_whf/Whf00174302@127.0.0.1:1611
 drop table if exists tt;
 create table tt ( a int);
 insert into tt values(1),(2);
 commit;

 create or replace procedure p1 as
 b tt%rowtype;
 begin
 select * into b from tt limit 1;
 delete from tt;
 dbe_output.print_line(b);
 null
 end;
 /

conn plsql_dts_mcdb/Whf00174302@127.0.0.1:1611
 create or replace procedure p2 as
 begin
 plsql_dts_whf.p1();
 end;
 /

conn gs_plsql_dts/Whf00174302@127.0.0.1:1611

 begin
 plsql_dts_mcdb.p2();
 end;
 /
---------------test error
declare
   cv=cv SYS_REFCURSOR;
   v_ename  plsql_dts_emp_test.ename%type;
BEGIN
        open cv=cv for select ename from plsql_dts_emp_test where empno=1 order by ename;
        loop
        fetch cv into v_ename;
        exit when cv%notfound;
        dbe_output.print_line('ename is '||v_ename);
        end loop;
        close cv;
end;
/

declare
   cv SYS_REFCURSOR;
   v_ename  plsql_dts_emp_test.ename%type;
BEGIN
        open cv for select ename from plsql_dts_emp_test where empno=1 order by ename;
        loop
        fetch cv into v_ename;
        exit when cv%notfound;
        dbe_output.print_line('ename is '||v_ename);
        end loop;
        close cv;
end;
/

declare
   cv%cv  SYS_REFCURSOR;
   v_ename  plsql_dts_emp_test.ename%type;
BEGIN
        open cv%cv for select ename from plsql_dts_emp_test where empno=1 order by ename;
        loop
        fetch cv%cv into v_ename;
        exit when cv%notfound;
        dbe_output.print_line('ename is '||v_ename);
        end loop;
        close cv;
end;
/

--Example 4-14 CONTINUE WHEN Statement in Basic LOOP Statement
DECLARE
  x NUMBER := 0;
BEGIN
  LOOP -- After CONTINUE statement, control resumes here
    dbe_output.print_line ('Inside loop:  x = ' || TO_CHAR(x));
    x := x + 1;
    CONTINUE WHEN x < 3;
    dbe_output.print_line
      ('Inside loop, after CONTINUE:  x = ' || TO_CHAR(x));
    EXIT WHEN x = 5;
  END LOOP;
  dbe_output.print_line (' After loop:  x = ' || TO_CHAR(x));
END;
/
---DTS2018083003267
drop table if exists plsql_dts_test;
create or replace procedure plsql_dts_test
is
cursor plsql_dts_test_xxx;
begin
plsql_dts_test_xxx is select 1 from dual;
open plsql_dts_test_xxx;
close plsql_dts_test_xxx;
return;
end;
/

create or replace procedure plsql_dts_test is
cursor plsql_dts_test_xxx
begin
open plsql_dts_test_xxx(1,2);
close plsql_dts_test_xxx;
return;
end;
/

create or replace procedure plsql_dts_test is
cursor plsql_dts_test_xxx;
begin
open plsql_dts_test_xxx(1,2);
close plsql_dts_test_xxx;
return;
end;
/

create or replace procedure plsql_dts_test is
cursor plsql_dts_test_xxx;
begin
open plsql_dts_test_xxx;
close plsql_dts_test_xxx;
return;
end;
/

drop procedure plsql_dts_test;
---DTS2018083005780
create or replace procedure plsql_dts_loop_test is
i int;
begine
i:=0;
loop
 i:=i+1;
end loop;
end plsql_dts_loop_test;
/

create or replace procedure plsql_dts_loop_test is
i int;
begine
loop
 i:=i+1;
end loop;
end plsql_dts_loop_test;
/

--DTS2018082905466
declare
    i int;
begin
    i := prior 1;
end;
/

--begin : DTS2018083005171
drop table if exists plsql_dts_storage_row_link_range_tbl_000;
create table plsql_dts_storage_row_link_range_tbl_000(c_id int,c_d_id bigint NOT NULL,c_w_id tinyint unsigned NOT NULL,c_first varchar(16) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data1 varchar(8000),c_data2 varchar(8000),c_data3 varchar(8000),c_data4 varchar(8000),c_data5 varchar(8000),c_data6 varchar(8000),c_data7 varchar(8000),c_data8 varchar(8000),c_data9 varchar(4000),c_data10 varchar(4000),c_clob clob,c_text blob);
CREATE or replace procedure plsql_dts_storage_row_link_range_proc_000(startnum int,endall int) is
i INT :=1;
j varchar(10);
BEGIN
  FOR i IN startnum..endall LOOP
    select cast(i as varchar(10)) into j from dual;
    insert into plsql_dts_storage_row_link_range_tbl_000 select i,i,i,'iscmRDs'||j,'OE','BARBar'||j,'bkilifcrRGF'||j,'pmbwovhSDGj'||j,'dyfrDa'||j,'uq','4801'||j,'940215'||j,sysdate,'GC',50000.0,0.4361328,-10.0,10.0,1,1,sysdate,lpad('QVBRfSCC3484942ZCSfjvCF',4000,'QVLDBURhlhfrc484ZCSfjF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('QVBUflcHOQNvmgfvdPFZSF',3000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',3000,'1435764ABC7890abcdef'),lpad('QVBUflcHOQNvmgfvdPFZSF',4000,'QVLDfscHOQgfvmPFZDSF'),lpad('12314315487569809',4000,'1435764ABC7890abcdef') from dual;
  END LOOP;
END;
/
call plsql_dts_storage_row_link_range_proc_000(1,100);
commit;

drop table if exists plsql_dts_storage_row_link_range_trg_tbl_010;
create table plsql_dts_storage_row_link_range_trg_tbl_010(c_id int,c_d_id bigint NOT NULL,c_w_id tinyint unsigned NOT NULL,c_first varchar(16 char) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data1 varchar(8000 byte),c_data2 varchar(8000),c_data3 varchar(8000),c_data4 varchar(8000),c_data5 varchar(8000),c_data6 varchar(8000),c_data7 varchar(8000),c_data8 varchar(8000),c_data9 varchar(4000),c_data10 varchar(4000),c_clob clob,c_text blob) partition by range(c_id,c_first) (partition PART_1 values less than (21,'is21'),partition PART_2 values less than (41,'is41'),partition PART_3 values less than (61,'is61'),partition PART_4 values less than (81,'is81'),partition PART_5 values less than (maxvalue,maxvalue));
insert into plsql_dts_storage_row_link_range_trg_tbl_010 select * from plsql_dts_storage_row_link_range_tbl_000;
commit;

drop table if exists plsql_dts_storage_row_link_range_trg_tbl_010_1;
create table plsql_dts_storage_row_link_range_trg_tbl_010_1(c_id int,c_d_id bigint NOT NULL,c_w_id tinyint unsigned NOT NULL,c_first varchar(16 char) NOT NULL,c_middle char(2),c_last varchar(16) NOT NULL,c_street_1 varchar(20) NOT NULL,c_street_2 varchar(20),c_city varchar(20) NOT NULL,c_state char(2) NOT NULL,c_zip char(9) NOT NULL,c_phone char(16) NOT NULL,c_since timestamp,c_credit char(2) NOT NULL,c_credit_lim numeric(12,2),c_discount numeric(4,4),c_balance numeric(12,2),c_ytd_payment real NOT NULL,c_payment_cnt number NOT NULL,c_delivery_cnt bool NOT NULL,c_end date NOT NULL,c_data1 varchar(8000 byte),c_data2 varchar(8000),c_data3 varchar(8000),c_data4 varchar(8000),c_data5 varchar(8000),c_data6 varchar(8000),c_data7 varchar(8000),c_data8 varchar(8000),c_data9 varchar(4000),c_data10 varchar(4000),c_clob clob,c_text blob) partition by range(c_id,c_first) (partition PART_1 values less than (21,'is21'),partition PART_2 values less than (41,'is41'),partition PART_3 values less than (61,'is61'),partition PART_4 values less than (81,'is81'),partition PART_5 values less than (maxvalue,maxvalue));
insert into plsql_dts_storage_row_link_range_trg_tbl_010_1 select * from plsql_dts_storage_row_link_range_tbl_000;
commit;

create or replace trigger plsql_dts_storage_row_link_range_trg_010 before update on plsql_dts_storage_row_link_range_trg_tbl_010
begin
  update plsql_dts_storage_row_link_range_trg_tbl_010_1 set c_d_id=c_d_id+1,c_w_id=c_w_id+1,c_since=sysdate,c_first=c_first||'b',c_data1=c_data1||'aaaaa',c_data2=c_data2||'aaaaa',c_data3=c_data3||'aaaaa',c_data4=c_data4||'aaaaa',c_data5=c_data5||'aaaaa',c_data6=c_data6||'aaaaa',c_data7=c_data7||'aaaaa',c_data8=c_data8||'aaaaa';
  dbe_output.print_line('Hello 1!');
END;
/

create or replace trigger plsql_dts_storage_row_link_range_trg_010_1 after update on plsql_dts_storage_row_link_range_trg_tbl_010
begin
  update plsql_dts_storage_row_link_range_trg_tbl_010_1 set c_d_id=c_d_id+1,c_w_id=c_w_id+1,c_since=sysdate,c_first=c_first||'b',c_data1=c_data1||'aaaaa',c_data2=c_data2||'aaaaa',c_data3=c_data3||'aaaaa',c_data4=c_data4||'aaaaa',c_data5=c_data5||'aaaaa',c_data6=c_data6||'aaaaa',c_data7=c_data7||'aaaaa',c_data8=c_data8||'aaaaa';
  dbe_output.print_line('Hello 2!');
END;
/

--line connection -> normal line
update plsql_dts_storage_row_link_range_trg_tbl_010 set c_d_id=c_d_id+1,c_w_id=c_w_id+1,c_since=sysdate,c_first=c_first||'aa',c_data1='aaaaaaaaaaaa',c_data2='bbbbbbbbbb',c_data3='cccccccccc',c_data4='dddddddddd',c_data5='eeeeeeeeee',c_data6='ffffffffff',c_data7='gggggggggg',c_data8='aaaaaaaaaa',c_text='aaaaaaaaaa',c_clob='1111111111' where mod(c_id,2)=0;
--end : DTS2018083005171

--DTS2018082903212
drop table if exists zsharding_tbl;
create table zsharding_tbl(
c_id int, c_int int, c_integer integer, c_bool bool, c_boolean boolean, c_bigint bigint,
c_real real, c_double double,
c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
c_date date, c_datetime datetime, c_timestamp timestamp,c_float float default null
);
INSERT INTO zsharding_tbl VALUES ( 20, 0, 10, 1, 0, -1088618496, 500000, 1000, 9, 5, 8, 'a', 'def', '2003-02-28', TO_DATE('2002-03-18', 'YYYY-MM-DD'), TO_DATE('2003-11-25', 'YYYY-MM-DD'), TO_TIMESTAMP('2004-08-19 21:38:09', 'YYYY-MM-DD HH24:Mi:SS') ,-1.79E+308);
INSERT INTO zsharding_tbl VALUES ( 21, 30000, 20000, 0, 1, 30000, 294453248, 0, 2, -110231552, 9, 'ghi', '2004-05-24', 'kbvumx', TO_DATE('2010-08-08', 'YYYY-MM-DD'), TO_DATE('1995-08-08', 'YYYY-MM-DD'), TO_TIMESTAMP('2018-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS'),1.79E+308 );
INSERT INTO zsharding_tbl VALUES ( 22, 12, 20000, 1, 1, 0, 1, 10, 3000, 13, 0, 'ekb', 'eekbvumxm', 'd', TO_DATE('1995-08-08', 'YYYY-MM-DD'), TO_DATE('2009-11-25', 'YYYY-MM-DD'), TO_TIMESTAMP('1885-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS') ,'');
INSERT INTO zsharding_tbl VALUES ( 23, -1294729216, -1349124096, 1, 1, 1421737984, 10, 20000, 2, 3000, 3000, 'b', '%b%', '2004-06-20 20:20:31', TO_DATE('1880-08-08', 'YYYY-MM-DD'), TO_DATE('2009-11-08', 'YYYY-MM-DD'), TO_TIMESTAMP('2002-05-28 01:05:16', 'YYYY-MM-DD HH24:Mi:SS'),9999999999.123456789 );
INSERT INTO zsharding_tbl VALUES ( 24, -1485242368, -480182272, 1, 0, 3000, 1000, 0, 12, 11, 1000, '2005-09-02', 'q', '2001-08-18 14:31:12', TO_DATE('2002-05-09', 'YYYY-MM-DD'), TO_DATE('2005-08-06', 'YYYY-MM-DD'), TO_TIMESTAMP('2012-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS'),'' );
INSERT INTO zsharding_tbl VALUES ( 25, 1000, 0, 1, 0, 4, 20000, 3000, -1371799552, -1394540544, 3, 'def', 'abc', '%b%', TO_DATE('2009-02-10', 'YYYY-MM-DD'), TO_DATE('2001-05-14', 'YYYY-MM-DD'), TO_TIMESTAMP('2001-02-18 14:25:33', 'YYYY-MM-DD HH24:Mi:SS'),''  );
INSERT INTO zsharding_tbl VALUES ( 26, 1, 10, 1, 0, 1971322880, 11, 30000, 0, 1088159744, 9, 'abc', '_a_%', 'abe', TO_DATE('2002-12-07', 'YYYY-MM-DD'), TO_DATE('2000-07-02', 'YYYY-MM-DD'), TO_TIMESTAMP('2000-01-01 01:01:01', 'YYYY-MM-DD HH24:Mi:SS') ,'' );
INSERT INTO zsharding_tbl VALUES ( 27, 1199702016, 10, 0, 1, 500000, -1063911424, 12, 0, 11, 5, 'abcdef', 'a', 'c', TO_DATE('2009-04-08', 'YYYY-MM-DD'), TO_DATE('2010-08-08', 'YYYY-MM-DD'), TO_TIMESTAMP('1880-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS') ,'' );
INSERT INTO zsharding_tbl VALUES ( 28, 5, 30000, 1, 1, 14, 500000, 5, 292421632, 5, 13, 'c', 'mab', 'b', TO_DATE('2006-02-08', 'YYYY-MM-DD'), TO_DATE('2000-08-08', 'YYYY-MM-DD'), TO_TIMESTAMP('2011-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS'),''  );
INSERT INTO zsharding_tbl VALUES ( 29, 1000, 500000, 1, 0, 1221525504, 20000, 2077491200, 13, 12, 40000, '', '2003-07-06 21:08:14', '2004-05-15', TO_DATE('2000-04-20', 'YYYY-MM-DD'), TO_DATE('2008-01-02', 'YYYY-MM-DD'), TO_TIMESTAMP('2011-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS') ,'' );
INSERT INTO zsharding_tbl VALUES ( 30, 1000, 500000, 1, 0, 1221525504, 20000, 2077491200, 13, 12, 40000, 'abcdefgaaaaaaaaa', '2003-07-06 21:08:14', '2004-05-15', TO_DATE('2000-04-20', 'YYYY-MM-DD'), TO_DATE('2008-01-02', 'YYYY-MM-DD'), TO_TIMESTAMP('2011-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS'),''  );
INSERT INTO zsharding_tbl VALUES ( 31, 1000, 500000, 1, 0, 1221525504, 20000, 2077491200, 13, 12, 40000, null, '2003-07-06 21:08:14', '2004-05-15', TO_DATE('2000-04-20', 'YYYY-MM-DD'), TO_DATE('2008-01-02', 'YYYY-MM-DD'), TO_TIMESTAMP('2011-08-08 08:08:08', 'YYYY-MM-DD HH24:Mi:SS') ,'' );
create or replace procedure sp_zsharding_tbl
as
v_Temp_1 NUMBER(10, 0);
begin
select count(*)  into v_Temp_1 from (SELECT c_id,c_varchar FROM zsharding_tbl where c_varchar = any (select c_varchar from zsharding_tbl where c_date in (select c_date from zsharding_tbl where exists(select c_bool from zsharding_tbl)))  group by c_id,c_varchar union
SELECT c_id,c_varchar FROM zsharding_tbl where c_varchar = any (select c_varchar from zsharding_tbl where c_date in (select c_date from zsharding_tbl where exists(select c_bool from zsharding_tbl))) group by c_id,c_varchar order by c_id desc);
end ;
/
call sp_zsharding_tbl;
--DTS2018083001179
drop user if exists plsql_dts_nebula cascade;
create user plsql_dts_nebula identified by Cantian_234;
create table plsql_dts_nebula.hash_tbl_005(c_first varchar2(20)) partition by hash(c_first) (partition part_1,partition part_2,partition part_3);
declare
pname varchar2(20);
count_num int;
v_first varchar2(50);
v_sql varchar2(500);
hashcursor sys_refcursor;
cursor hash_cursor is SELECT PARTITION_NAME FROM DBA_TAB_PARTITIONS WHERE TABLE_NAME =upper('hash_tbl_005') order by PARTITION_NAME;
begin
   open hash_cursor;
   fetch hash_cursor into pname;
   while hash_cursor%found loop
   execute immediate 'select c_first from plsql_dts_nebula.hash_tbl_005 partition('||pname||') where rownum=1 order by c_first' into v_first;
   dbe_output.print_line(pname ||' c_first is '||v_first);
   v_sql :='update plsql_dts_nebula.hash_tbl_005 set c_first='''||v_first||''' where c_first in (select c_first from plsql_dts_nebula.hash_tbl_005 partition('||pname||'))';
   execute immediate v_sql;
   v_sql :='select distinct c_first from plsql_dts_nebula.hash_tbl_005 partition('||pname||')';
   open hashcursor for v_sql;
   dbe_sql.return_cursor(hashcursor);
   fetch hash_cursor into pname;
   end loop;
   close hash_cursor;
 end;
/
--DTS2018082909668
drop table if exists plsql_dts_tab_001 ;
create table plsql_dts_tab_001 (f1 int, f2 int);
insert into plsql_dts_tab_001 (select 1, 1 from dual);
insert into plsql_dts_tab_001  select 1, 1 from dual;
select * from plsql_dts_tab_001;
declare
  sqlstr varchar(1024);
  begin
  sqlstr := 'insert into plsql_dts_tab_001 (select 1, 1 from dual)';
  execute immediate sqlstr;
end;
/
begin insert into plsql_dts_tab_001 (select 1, 1 from dual); end;
/
--DTS2018082404475
drop table if exists plsql_dts_emp;
create table plsql_dts_emp(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into plsql_dts_emp values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10000),(123,'zhangsan3','doctor3',10000);
declare
a plsql_dts_emp%rowtype;
cursor mycursor return plsql_dts_emp%rowtype;
cursor mycursor return plsql_dts_emp%rowtype  is  select * from plsql_dts_emp;
begin
open mycursor;
loop
if  mycursor%isopen  then  dbe_output.print_line('open');fetch mycursor into a;
end if;
exit
when  mycursor%notfound;
dbe_output.print_line('a is emp:'||a.ename);
dbe_output.print_line(mycursor%rowcount);
end loop;
end;
/
declare
cursor mycursor(job_real varchar(10) default 'doctor1',max_sal number default 9000) is  select ename from plsql_dts_emp where job=job_real and sal> max_sal  order by sal;
c_empno varchar(10);
begin
open mycursor;
fetch mycursor into c_empno;
if  mycursor%found  then
dbe_output.print_line('c_empno is emp:'||c_empno);
dbe_output.print_line(mycursor%rowcount);
end if;
close mycursor;
open mycursor('doctor2',8000);
fetch mycursor into c_empno;
dbe_output.print_line('doctor2 c_empno is emp:'||c_empno);
dbe_output.print_line(mycursor%rowcount);
close mycursor;
end;
/
--DTS2018082902927
drop table if exists plsql_dts_employees;
create table plsql_dts_employees(employeesno int,ename varchar(10),job varchar(10) ,sal integer);
insert into plsql_dts_employees values(1,'zhangsan','doctor1',10000);
insert into plsql_dts_employees values(2,'zhangsan2','doctor2',10010);
insert into plsql_dts_employees values(123,'zhangsan3','AD_PRES',10020);
alter table plsql_dts_employees add  hiretime datetime;
DECLARE
  TYPE RecordTyp IS RECORD (
    last plsql_dts_employees.ename%TYPE,
    id   plsql_dts_employees.employeesno%TYPE
  );
  rec1 RecordTyp;
BEGIN
  SELECT ename, employeesno INTO rec1
  FROM plsql_dts_employees
  WHERE job = 'AD_PRES';

  dbe_output.print_line ('Employee #' || rec1.id || ' = ' || rec1.last);
END;
/
-------
drop table if exists t_test_zenith_t1;
create table t_test_zenith_t1(id int primary key, name varchar2(100), sqltext varchar2(1000));
declare
    i integer;
begin
    for i in 1 .. 100 loop
        insert into t_test_zenith_t1 values(i, i || 'abcdefg', lpad(' ', 1000, ' '));
    end loop;
    commit;
end;
/

declare
    str_name varchar2(100);
    b_time   timestamp;
    interval_local interval day to second;
    result   varchar2(20);
begin
    b_time := systimestamp;
    for i in 1 .. 10 loop
        select name into str_name from t_test_zenith_t1 where id = i;
    end loop;
    interval_local := systimestamp - b_time;
    result := cast(interval_local as varchar(20));
    if interval_local < '0 0:0:1' then
        dbe_output.print_line('OK');
    else
        dbe_output.print_line('FAIL');
    end if;
end;
/

drop user plsql_dts_whf cascade;
drop user plsql_dts_mcdb cascade;

--DTS2018082702743:
--(1)test the eof cursor cannot be used by return result
--(2)return result should fetch data from the cursor alone with the last pos.
drop table if exists plsql_dts_emp1;
create table plsql_dts_emp1(employeesno int,ename varchar(10),job varchar(10) ,sal integer);
insert into plsql_dts_emp1 values(1,'zhangsan','doctor1',10000);
insert into plsql_dts_emp1 values(2,'zhangsan2','doctor2',10010);
insert into plsql_dts_emp1 values(123,'zhangsan3','doctor3',10020);
commit;

--------------------
--fetch eof,return_result will error
create or replace procedure plsql_dts_p1 is
a plsql_dts_emp1%rowtype;
mycursor sys_refcursor;
begin
open mycursor for  select * from plsql_dts_emp1 where ename in('zhangsan','zhangsan2');
fetch mycursor into a;
loop
exit when mycursor%notfound;
dbe_output.print_line(a.ename||'sal is not 10000');
fetch mycursor into a;
end loop;
dbe_sql.return_cursor(mycursor);
end;
/

exec plsql_dts_p1;


create or replace procedure plsql_dts_p2 is
a plsql_dts_emp1%rowtype;
mycursor sys_refcursor;
begin
open mycursor for  select * from plsql_dts_emp1 where ename in('zhangsan','zhangsan2');
fetch mycursor into a;
dbe_output.print_line(a.ename||':sal is not 10000');
dbe_sql.return_cursor(mycursor);
end;
/
exec plsql_dts_p2;


--eof cursor,fetch ok
create or replace procedure plsql_dts_p3 is
a plsql_dts_emp1%rowtype;
mycursor sys_refcursor;
begin
open mycursor for  select * from plsql_dts_emp1 where ename in('zhangsan','zhangsan2');
fetch mycursor into a;
loop
exit when mycursor%notfound;
dbe_output.print_line(a.ename||':sal is not 10000');
fetch mycursor into a;
end loop;
fetch mycursor into a;
end;
/

exec plsql_dts_p3;

--null,return_result success
create or replace procedure plsql_dts_p4 is
a plsql_dts_emp1%rowtype;
mycursor sys_refcursor;
begin
open mycursor for  select * from plsql_dts_emp1 where ename in('zhangsan','zhangsan2') and 1=2;
dbe_sql.return_cursor(mycursor);
end;
/

exec plsql_dts_p4;

--eof cursor,return_result error
create or replace procedure plsql_dts_p5 is
a plsql_dts_emp1%rowtype;
mycursor sys_refcursor;
begin
open mycursor for  select * from plsql_dts_emp1 where ename in('zhangsan','zhangsan2') and 1=2;
fetch mycursor into a;
dbe_sql.return_cursor(mycursor);
end;
/

exec plsql_dts_p5;
--end

--DTS2018091501413
create or replace function c10(id text) return int as mm text; begin if id is null then (select id  from a                                                 limit 1); end if;end;
/
--
drop table if exists zsharding_tbl_p1;
create table zsharding_tbl_p1(
c_id int, c_int int, c_integer integer, c_bool bool, c_boolean boolean, c_bigint bigint,
c_real real, c_double double,
c_decimal decimal(38), c_number number(38), c_numeric numeric(38),
c_char char(50) default null, c_varchar varchar(20), c_varchar2 varchar2(4000),
c_date date, c_datetime datetime, c_timestamp timestamp,c_float float default null
);
CREATE OR REPLACE FUNCTION F1 RETURN BOOL AS A BOOL ;
 BEGIN
 SELECT C_BOOL INTO A FROM ZSHARDING_TBL_P1 WHERE C_ID = 21;
 RETURN A;
 END F1;
 /
 DECLARE A BOOL;
 BEGIN
 SELECT F1()*10 INTO A FROM DUAL;
 dbe_output.print_line(A);
 END;
 /

set charset gbk
drop table if exists FTV_substr_002;
create table FTV_substr_002(id blob,text clob);
insert into FTV_substr_002 values('1111','���ҵ�ma');
select DBE_LOB.get_length(id) from FTV_substr_002;
select DBE_LOB.get_length(text) from FTV_substr_002;
select DBE_LOB.substr(text,3,1) from FTV_substr_002;
select DBE_LOB.substr(text,3,4) from FTV_substr_002;
select DBE_LOB.substr(text,3,7) from FTV_substr_002;
select DBE_LOB.substr(text,3,10) from FTV_substr_002;
select DBE_LOB.substr(text,3,11) from FTV_substr_002;
select DBE_LOB.substr(id,1,1) from FTV_substr_002;
select DBE_LOB.substr(id,2,1) from FTV_substr_002;
select DBE_LOB.substr(id,1,2) from FTV_substr_002;
select DBE_LOB.substr(id,1,3) from FTV_substr_002;
drop table if exists FTV_substr_002;

--DTS2018103108873
set serveroutput on

BEGIN
  THROW_EXCEPTION(-20000.49, 'user dinfe error');
EXCEPTION
  WHEN OTHERS THEN
    dbe_output.print_line(SQL_ERR_CODE || ': ' || SQL_ERR_MSG);
END;
/

set serveroutput on

BEGIN
  THROW_EXCEPTION(-20000.5, 'user dinfe error');
EXCEPTION
  WHEN OTHERS THEN
    dbe_output.print_line(SQL_ERR_CODE || ': ' || SQL_ERR_MSG);
END;
/

BEGIN
  THROW_EXCEPTION('-20000'::number, 'user dinfe error');
EXCEPTION
  WHEN OTHERS THEN
    dbe_output.print_line(SQL_ERR_CODE || ': ' || SQL_ERR_MSG);
END;
/

BEGIN
  THROW_EXCEPTION('-20000', 'user dinfe error');
EXCEPTION
  WHEN OTHERS THEN
    dbe_output.print_line(1);
    dbe_output.print_line(SQL_ERR_CODE || ': ' || SQL_ERR_MSG);
END;
/

BEGIN
  THROW_EXCEPTION('-20000x', 'user dinfe error');
EXCEPTION
  WHEN OTHERS THEN
    dbe_output.print_line(1);
    dbe_output.print_line(SQL_ERR_CODE || ': ' || SQL_ERR_MSG);
END;
/

BEGIN
  THROW_EXCEPTION(TRUE, 'user dinfe error');
EXCEPTION
  WHEN OTHERS THEN
    dbe_output.print_line(1);
    dbe_output.print_line(SQL_ERR_CODE || ': ' || SQL_ERR_MSG);
END;
/

BEGIN
  THROW_EXCEPTION(sysdate, 'user dinfe error');
EXCEPTION
  WHEN OTHERS THEN
    dbe_output.print_line(1);
END;
/


--DTS2018092906474
DROP TABLE IF EXISTS t_001;
DROP TABLE IF EXISTS t_002;
drop view IF EXISTS v_001;

create table t_001(
id int,
dept_id varchar2(20),
name varchar2(20)
);


create table t_002(
id int,
name varchar2(20)
);

insert into t_001 values(1,'01','huawei'),(2,'02','iss'),(3,'02','chain'),(4,'03','huawei');
commit;

create view v_001 as select id ,name from t_001;


drop table t_001;

CREATE OR REPLACE PROCEDURE P1(V_ID INT) IS
  V_NUM  INT;
  V_NAME VARCHAR2(2000);
  V_SQL  VARCHAR2(2000);
BEGIN
  INSERT INTO t_002
  select * from v_001;
  COMMIT;
END;
/
--DTS2018101204444
select 1+2+3+4+5+6+7+8+9+10+1+2+3+4+5+6+7+8 from dual;

begin
  for item in (select * from v$session) loop
      null;
  end loop;
end;
/

--pltext exceed 64K test(create & replace)
create or replace procedure sp_RANCC_MBTSComPMU_C3 (
    v_PlanID in number ,
    v_MBTSID in varchar2 ,
    v_CMENEID in number ,
    v_PhyNEID in number ,
    v_SiteId in number  )
as
begin
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'CMEMODE' || to_char(PN), 'BTSENVALMPORT', 'SW', v_MBTSID, b.CN, b.SRN, b.SN
                , to_char(SW), '0', to_char(SW), '0', 'Switch on Port No.' || to_char(PN), 'G', sys_guid() from t_C_BTSENVALMPORT_C3 a, t_C_BTSBRD_C3 b where a.CMENEID = v_PhyNEID and a.CMENEID = b.CMENEID and a.BTSID = v_SiteId
                     and a.BTSID = b.BTSID and a.CN = b.CN and a.SRN = b.SRN
                     and a.SN = b.SN and BT = 114;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'AVOL' || to_char(PN), 'BTSENVALMPORT', 'AVOL', v_MBTSID, b.CN, b.SRN, b.SN
                , to_char(a.AVOL), '0', case
                    when a.SW = 0 then 'NA' else to_char(case a.AVOL when 0 then 1 when 1 then 0 end
) end
, '1', 'Alarm Voltage on Port No.' || to_char(PN), 'G', sys_guid() from t_C_BTSENVALMPORT_C3 a, t_C_BTSBRD_C3 b where a.CMENEID = v_PhyNEID and a.CMENEID = b.CMENEID and a.BTSID = v_SiteId
                     and a.BTSID = b.BTSID and a.CN = b.CN and a.SRN = b.SRN
                     and a.SN = b.SN and BT = 114;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'CFGFLAG', 'BTSAPMUBP', 'CFGFLAG', v_MBTSID, CN, SRN, SN
                , to_char(CFGFLAG), '1', to_char(CFGFLAG), '1', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'LFLG', 'BTSAPMUBP', 'HIGHTEMPLOADPWROFF', v_MBTSID, CN, SRN, SN
                , to_char(HIGHTEMPLOADPWROFF), '170', to_char(case
                    when HIGHTEMPLOADPWROFF = 170 then 0 else 1 end
), '0', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'LTEM', 'BTSAPMUBP', 'TEMPOFHIGHTEMPLOADPWROFF', v_MBTSID, CN, SRN, SN
                , to_char(TEMPOFHIGHTEMPLOADPWROFF), to_char(65), to_char(TEMPOFHIGHTEMPLOADPWROFF), to_char(65), 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and HIGHTEMPLOADPWROFF = 170;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'HTSDF', 'BTSAPMUBP', 'HTSDF', v_MBTSID, CN, SRN, SN
                , to_char(HTSDF), '1', to_char(HTSDF), '1', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'SDT', 'BTSAPMUBP', 'SDT', v_MBTSID, CN, SRN, SN
                , to_char(SDT), to_char(53), to_char(SDT), to_char(53), 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and HTSDF = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'BT1_DISABLE', 'BTSAPMUBP', 'SAAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 1)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (2, 3, 5) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 1)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (2, 3, 5) then '0' else '1' end
, 'Special Analog Alarm Flag(Battery Temperature Sensor 1 Disabled)', '1', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'AH_DISABLE', 'BTSAPMUBP', 'SAAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 2)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 2)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, 'Special Analog Alarm Flag(Cabinet Humidity Sensor Disabled)', '2', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'AT1_DISABLE', 'BTSAPMUBP', 'SAAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 4)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (0, 1, 7) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 4)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (0, 1, 7) then '0' else '1' end
, 'Special Analog Alarm Flag(Cabinet Temperature Sensor 1 Disabled)', '4', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'AT2_DISABLE', 'BTSAPMUBP', 'SAAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 8)) = 0 then 0 else 1 end
), '1', to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 8)) = 0 then 0 else 1 end
), '1', 'Special Analog Alarm Flag(Cabinet Temperature Sensor 2 Disabled)', '8', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'BT2_DISABLE', 'BTSAPMUBP', 'SAAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 16)) = 0 then 0 else 1 end
), '1', to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 16)) = 0 then 0 else 1 end
), '1', 'Special Analog Alarm Flag(Battery Temperature Sensor 2 Disabled)', to_char(16), 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'WS_DISABLE', 'BTSAPMUBP', 'SBAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 1)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 1)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, 'Special Boolean Alarm Flag(Water-Immersed Sensor Disabled)', '1', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'SS_DISABLE', 'BTSAPMUBP', 'SBAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 2)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 2)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, 'Special Boolean Alarm Flag(Smog Sensor Disabled)', '2', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'GS_DISABLE', 'BTSAPMUBP', 'SBAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 4)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (0, 1, 2, 7) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 4)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (0, 1, 2, 7) then '0' else '1' end
, 'Special Boolean Alarm Flag(Gating Sensor Disabled)', '4', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'PTYPE', 'BTSAPMUBP', 'PTYPE', v_MBTSID, CN, SRN, SN
                , to_char(PTYPE), '2', to_char(PTYPE), '2', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'BTYPE', 'BTSAPMUBP', 'BTYPE', v_MBTSID, CN, SRN, SN
                , to_char(BTYPE), '255', to_char(BTYPE), '255', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and BE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'BCLC', 'BTSAPMUBP', 'BCLC', v_MBTSID, CN, SRN, SN
                , to_char(BCLC), to_char(15), to_char(BCLC), to_char(15), 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and BE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'BC1', 'BTSAPMUBP', 'BC', v_MBTSID, CN, SRN, SN
                , to_char(BC), to_char(36), to_char(BC), to_char(36), 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and BE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'BN', 'BTSAPMUBP', 'BN', v_MBTSID, CN, SRN, SN
                , to_char(BN), '1', to_char(BN), '1', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and BE = 1
                     and BTYPE = 2;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'LSDV', 'BTSAPMUBP', 'LSDV', v_MBTSID, CN, SRN, SN
                , to_char(LSDV), '440', to_char(LSDV), '440', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and HPVFLAG = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'BCV', 'BTSAPMUBP', 'BCV', v_MBTSID, CN, SRN, SN
                , to_char(BCV), '565', to_char(BCV), '565', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and HPVFLAG = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'FCV', 'BTSAPMUBP', 'FCV', v_MBTSID, CN, SRN, SN
                , to_char(FCV), '535', to_char(FCV), '535', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and HPVFLAG = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'LSDF', 'BTSAPMUBP', 'LSDF', v_MBTSID, CN, SRN, SN
                , to_char(LSDF), '0', to_char(LSDF), '0', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and HPVFLAG = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'LVSDF', 'BTSAPMUBP', 'LVSDF', v_MBTSID, CN, SRN, SN
                , to_char(LVSDF), '1', to_char(LVSDF), '1', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and HPVFLAG = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'SDV', 'BTSAPMUBP', 'SDV', v_MBTSID, CN, SRN, SN
                , to_char(SDV), '430', to_char(SDV), '430', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and HPVFLAG = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'LOWTEMPLOADPWROFF', 'BTSAPMUBP', 'LOWTEMPLOADPWROFF', v_MBTSID, CN, SRN, SN
                , to_char(LOWTEMPLOADPWROFF), to_char(85), to_char(LOWTEMPLOADPWROFF), to_char(85), 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and HPVFLAG = 1;

            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'BT1_DISABLE', 'BTSAPMUBP', 'SAAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 1)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (2, 3, 5) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 1)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (2, 3, 5) then '0' else '1' end
, 'Special Analog Alarm Flag(Battery Temperature Sensor 1 Disabled)', '1', 'G', sys_guid(), 'ALMENABLE = 1' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId
                     and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'AH_DISABLE', 'BTSAPMUBP', 'SAAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 2)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 2)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, 'Special Analog Alarm Flag(Cabinet Humidity Sensor Disabled)', '2', 'G', sys_guid(), 'ALMENABLE = 1' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId
                     and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'AT1_DISABLE', 'BTSAPMUBP', 'SAAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 4)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (0, 1, 7) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 4)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (0, 1, 7) then '0' else '1' end
, 'Special Analog Alarm Flag(Cabinet Temperature Sensor 1 Disabled)', '4', 'G', sys_guid(), 'ALMENABLE = 1' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId
                     and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'AT2_DISABLE', 'BTSAPMUBP', 'SAAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 8)) = 0 then 0 else 1 end
), '1', to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 8)) = 0 then 0 else 1 end
), '1', 'Special Analog Alarm Flag(Cabinet Temperature Sensor 2 Disabled)', '8', 'G', sys_guid(), 'ALMENABLE = 1' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId
                     and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'BT2_DISABLE', 'BTSAPMUBP', 'SAAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 16)) = 0 then 0 else 1 end
), '1', to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 16)) = 0 then 0 else 1 end
), '1', 'Special Analog Alarm Flag(Battery Temperature Sensor 2 Disabled)', to_char(16), 'G', sys_guid(), 'ALMENABLE = 1' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId
                     and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'WS_DISABLE', 'BTSAPMUBP', 'SBAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 1)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 1)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, 'Special Boolean Alarm Flag(Water-Immersed Sensor Disabled)', '1', 'G', sys_guid(), 'ALMENABLE = 1' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId
                     and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'SS_DISABLE', 'BTSAPMUBP', 'SBAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 2)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 2)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, 'Special Boolean Alarm Flag(Smog Sensor Disabled)', '2', 'G', sys_guid(), 'ALMENABLE = 1' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId
                     and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'GS_DISABLE', 'BTSAPMUBP', 'SBAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 4)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (0, 1, 2, 7) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 4)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (0, 1, 2, 7) then '0' else '1' end
, 'Special Boolean Alarm Flag(Gating Sensor Disabled)', '4', 'G', sys_guid(), 'ALMENABLE = 1' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId
                     and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'PTYPE', 'BTSAPMUBP', 'PTYPE', v_MBTSID, CN, SRN, SN
                , to_char(PTYPE), '2', to_char(PTYPE), '2', 'G', sys_guid() from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'BTYPE', 'BTSAPMUBP', 'BTYPE', v_MBTSID, CN, SRN, SN
                ,  nvl(to_char(BTYPE), '255'), '255', case
                    when BE = 0 then '255' else to_char(BTYPE) end
, '255', 'G', sys_guid(), 'BE = 1,BCLC = case when BTYPE = 2 then null else nvl(BCLC,15) end, BC = case when BTYPE = 2 then null else nvl(BC,36) end' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'BCLC', 'BTSAPMUBP', 'BCLC', v_MBTSID, CN, SRN, SN
                , to_char(BCLC), to_char(15), case
                    when  (BE = 0 or BTYPE = 255 ) then 'NA' else to_char(BCLC) end
, to_char(15), 'G', sys_guid(), 'BE = 1,BTYPE = nvl(BTYPE,255), BC = nvl(BC,36)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'BC1', 'BTSAPMUBP', 'BC', v_MBTSID, CN, SRN, SN
                , to_char(BC), to_char(36), case
                    when  (BE = 0 or BTYPE = 255 ) then 'NA' else to_char(BC) end
, to_char(36), 'G', sys_guid(), 'BE = 1,BTYPE = nvl(BTYPE,255),BCLC = nvl(BCLC,15)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'BN', 'BTSAPMUBP', 'BN', v_MBTSID, CN, SRN, SN
                , to_char(BN), '1', case
                    when  (BE = 0 or BTYPE in  (255, 0, 1) ) then 'NA' else to_char(BN) end
, '1', 'G', sys_guid(), 'BE = 1' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'LSDV', 'BTSAPMUBP', 'LSDV', v_MBTSID, CN, SRN, SN
                , to_char(to_number(LSDV)), '440', case
                    when HPVFLAG = 0 or LSDF = 0 then 'NA' else to_char(to_number(LSDV)) end
, '440', 'G', sys_guid(), 'HPVFLAG = 1,BCV=nvl(BCV,565) ,FCV =nvl(FCV,535) ,LSDF=nvl(LSDF,0),LVSDF=nvl(LVSDF,1), SDV= nvl(SDV,430), LOWTEMPLOADPWROFF=nvl(LOWTEMPLOADPWROFF,85),TEMPOFLOWTEMPLOADPWROFF=nvl(TEMPOFLOWTEMPLOADPWROFF,-100),ACVUTHD=nvl(ACVUTHD,280),ACVLTHD=nvl(ACVLTHD,180),DCVUTHD=nvl(DCVUTHD,580),DCVLTHD=nvl(DCVLTHD,450)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'BCV', 'BTSAPMUBP', 'BCV', v_MBTSID, CN, SRN, SN
                , to_char(to_number(BCV)), '565', case
                    when HPVFLAG = 0 then 'NA' else to_char(to_number(BCV)) end
, '565', 'G', sys_guid(), 'HPVFLAG = 1,LSDV = nvl(LSDV,440) ,FCV =nvl(FCV,535) ,LSDF=nvl(LSDF,0),LVSDF=nvl(LVSDF,1), SDV= nvl(SDV,430), LOWTEMPLOADPWROFF=nvl(LOWTEMPLOADPWROFF,85),TEMPOFLOWTEMPLOADPWROFF=nvl(TEMPOFLOWTEMPLOADPWROFF,-100),ACVUTHD=nvl(ACVUTHD,280),ACVLTHD=nvl(ACVLTHD,180),DCVUTHD=nvl(DCVUTHD,580),DCVLTHD=nvl(DCVLTHD,450)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'FCV', 'BTSAPMUBP', 'FCV', v_MBTSID, CN, SRN, SN
                , to_char(to_number(FCV)), '535', case
                    when HPVFLAG = 0 then 'NA' else to_char(to_number(FCV)) end
, '535', 'G', sys_guid(), 'HPVFLAG = 1,LSDV = nvl(LSDV,440) ,BCV=nvl(BCV,565) ,LSDF=nvl(LSDF,0),LVSDF=nvl(LVSDF,1), SDV= nvl(SDV,430), LOWTEMPLOADPWROFF=nvl(LOWTEMPLOADPWROFF,85),TEMPOFLOWTEMPLOADPWROFF=nvl(TEMPOFLOWTEMPLOADPWROFF,-100),ACVUTHD=nvl(ACVUTHD,280),ACVLTHD=nvl(ACVLTHD,180),DCVUTHD=nvl(DCVUTHD,580),DCVLTHD=nvl(DCVLTHD,450)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'LSDF', 'BTSAPMUBP', 'LSDF', v_MBTSID, CN, SRN, SN
                , to_char(LSDF), '0', case
                    when HPVFLAG = 0 then 'NA' else to_char(LSDF) end
, '0', 'G', sys_guid(), 'HPVFLAG = 1,LSDV = nvl(LSDV,440) ,BCV=nvl(BCV,565) ,FCV =nvl(FCV,535) ,LVSDF=nvl(LVSDF,1), SDV= nvl(SDV,430), LOWTEMPLOADPWROFF=nvl(LOWTEMPLOADPWROFF,85),TEMPOFLOWTEMPLOADPWROFF=nvl(TEMPOFLOWTEMPLOADPWROFF,-100),ACVUTHD=nvl(ACVUTHD,280),ACVLTHD=nvl(ACVLTHD,180),DCVUTHD=nvl(DCVUTHD,580),DCVLTHD=nvl(DCVLTHD,450)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'LVSDF', 'BTSAPMUBP', 'LVSDF', v_MBTSID, CN, SRN, SN
                , to_char(LVSDF), '1', case
                    when HPVFLAG = 0 then 'NA' else to_char(LVSDF) end
, '1', 'G', sys_guid(), 'HPVFLAG = 1,LSDV = nvl(LSDV,440) ,BCV=nvl(BCV,565) ,FCV =nvl(FCV,535) ,LSDF=nvl(LSDF,0), SDV= nvl(SDV,430), LOWTEMPLOADPWROFF=nvl(LOWTEMPLOADPWROFF,85),TEMPOFLOWTEMPLOADPWROFF=nvl(TEMPOFLOWTEMPLOADPWROFF,-100),ACVUTHD=nvl(ACVUTHD,280),ACVLTHD=nvl(ACVLTHD,180),DCVUTHD=nvl(DCVUTHD,580),DCVLTHD=nvl(DCVLTHD,450)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'SDV', 'BTSAPMUBP', 'SDV', v_MBTSID, CN, SRN, SN
                , to_char(SDV), '430', case
                    when HPVFLAG = 0 or LVSDF = 0 then 'NA' else to_char(SDV) end
, '430', 'G', sys_guid(), 'HPVFLAG = 1,LSDV = nvl(LSDV,440) ,BCV=nvl(BCV,565) ,FCV =nvl(FCV,535) ,LSDF=nvl(LSDF,0),LVSDF=nvl(LVSDF,1), LOWTEMPLOADPWROFF=nvl(LOWTEMPLOADPWROFF,85),TEMPOFLOWTEMPLOADPWROFF=nvl(TEMPOFLOWTEMPLOADPWROFF,-100),ACVUTHD=nvl(ACVUTHD,280),ACVLTHD=nvl(ACVLTHD,180),DCVUTHD=nvl(DCVUTHD,580),DCVLTHD=nvl(DCVLTHD,450)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'LOWTEMPLOADPWROFF', 'BTSAPMUBP', 'LOWTEMPLOADPWROFF', v_MBTSID, CN, SRN, SN
                , to_char(LOWTEMPLOADPWROFF), to_char(85), case
                    when HPVFLAG = 0 then 'NA' else to_char(LOWTEMPLOADPWROFF) end
, to_char(85), 'G', sys_guid(), 'HPVFLAG = 1,LSDV = nvl(LSDV,440) ,BCV=nvl(BCV,565) ,FCV =nvl(FCV,535) ,LSDF=nvl(LSDF,0),LVSDF=nvl(LVSDF,1), SDV= nvl(SDV,430), TEMPOFLOWTEMPLOADPWROFF=nvl(TEMPOFLOWTEMPLOADPWROFF,-100),ACVUTHD=nvl(ACVUTHD,280),ACVLTHD=nvl(ACVLTHD,180),DCVUTHD=nvl(DCVUTHD,580),DCVLTHD=nvl(DCVLTHD,450)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'TEMPOFLOWTEMPLOADPWROFF', 'BTSAPMUBP', 'TEMPOFLOWTEMPLOADPWROFF', v_MBTSID, CN, SRN, SN
                , to_char(TEMPOFLOWTEMPLOADPWROFF), '-100', case
                    when HPVFLAG = 0 then 'NA' else to_char(TEMPOFLOWTEMPLOADPWROFF) end
, '-100', 'G', sys_guid(), 'HPVFLAG = 1,LSDV = nvl(LSDV,440) ,BCV=nvl(BCV,565) ,FCV =nvl(FCV,535) ,LSDF=nvl(LSDF,0),LVSDF=nvl(LVSDF,1), SDV= nvl(SDV,430), LOWTEMPLOADPWROFF=nvl(LOWTEMPLOADPWROFF,85),ACVUTHD=nvl(ACVUTHD,280),ACVLTHD=nvl(ACVLTHD,180),DCVUTHD=nvl(DCVUTHD,580),DCVLTHD=nvl(DCVLTHD,450)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'ACVUTHD', 'BTSAPMUBP', 'ACVUTHD', v_MBTSID, CN, SRN, SN
                , to_char(ACVUTHD), '280', case
                    when HPVFLAG = 0 then 'NA' else to_char(ACVUTHD) end
, '280', 'G', sys_guid(), 'HPVFLAG = 1,LSDV = nvl(LSDV,440) ,BCV=nvl(BCV,565) ,FCV =nvl(FCV,535) ,LSDF=nvl(LSDF,0),LVSDF=nvl(LVSDF,1), SDV= nvl(SDV,430), LOWTEMPLOADPWROFF=nvl(LOWTEMPLOADPWROFF,85),TEMPOFLOWTEMPLOADPWROFF=nvl(TEMPOFLOWTEMPLOADPWROFF,-100),ACVLTHD=nvl(ACVLTHD,180),DCVUTHD=nvl(DCVUTHD,580),DCVLTHD=nvl(DCVLTHD,450)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'ACVLTHD', 'BTSAPMUBP', 'ACVLTHD', v_MBTSID, CN, SRN, SN
                , to_char(ACVLTHD), '180', case
                    when HPVFLAG = 0 then 'NA' else to_char(ACVLTHD) end
, '180', 'G', sys_guid(), 'HPVFLAG = 1,LSDV = nvl(LSDV,440) ,BCV=nvl(BCV,565) ,FCV =nvl(FCV,535) ,LSDF=nvl(LSDF,0),LVSDF=nvl(LVSDF,1), SDV= nvl(SDV,430), LOWTEMPLOADPWROFF=nvl(LOWTEMPLOADPWROFF,85),TEMPOFLOWTEMPLOADPWROFF=nvl(TEMPOFLOWTEMPLOADPWROFF,-100),ACVUTHD=nvl(ACVUTHD,280),DCVUTHD=nvl(DCVUTHD,580),DCVLTHD=nvl(DCVLTHD,450)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DCVUTHD', 'BTSAPMUBP', 'DCVUTHD', v_MBTSID, CN, SRN, SN
                , to_char(to_number(DCVUTHD)), '580', case
                    when HPVFLAG = 0 then 'NA' else to_char(to_number(DCVUTHD)) end
, '580', 'G', sys_guid(), 'HPVFLAG = 1,LSDV = nvl(LSDV,440) ,BCV=nvl(BCV,565) ,FCV =nvl(FCV,535) ,LSDF=nvl(LSDF,0),LVSDF=nvl(LVSDF,1), SDV= nvl(SDV,430), LOWTEMPLOADPWROFF=nvl(LOWTEMPLOADPWROFF,85),TEMPOFLOWTEMPLOADPWROFF=nvl(TEMPOFLOWTEMPLOADPWROFF,-100),ACVUTHD=nvl(ACVUTHD,280),ACVLTHD=nvl(ACVLTHD,180),DCVLTHD=nvl(DCVLTHD,450)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DCVLTHD', 'BTSAPMUBP', 'DCVLTHD', v_MBTSID, CN, SRN, SN
                , to_char(to_number(DCVLTHD)), '450', case
                    when HPVFLAG = 0 then 'NA' else to_char(to_number(DCVLTHD)) end
, '450', 'G', sys_guid(), 'HPVFLAG = 1, LSDV = nvl(LSDV,440), BCV=nvl(BCV,565) ,FCV =nvl(FCV,535), LSDF=nvl(LSDF,0), LVSDF=nvl(LVSDF,1), SDV= nvl(SDV,430), LOWTEMPLOADPWROFF=nvl(LOWTEMPLOADPWROFF,85), TEMPOFLOWTEMPLOADPWROFF=nvl(TEMPOFLOWTEMPLOADPWROFF,-100), ACVUTHD=nvl(ACVUTHD,280), ACVLTHD=nvl(ACVLTHD,180), DCVUTHD=nvl(DCVUTHD,580)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'TUL', 'BTSAPMUBP', 'CELLTEMP1THRESHOLDH', v_MBTSID, CN, SRN, SN
                , to_char(CELLTEMP1THRESHOLDH), '800', case
                    when CELLTEMPCOMPENABLED = 0 then 'NA' else to_char(CELLTEMP1THRESHOLDH) end
, '800', 'G', sys_guid(), 'CELLTEMPCOMPENABLED = 1,CELLTEMP1THRESHOLDL = nvl(CELLTEMP1THRESHOLDL,-200),TUTHD=nvl(TUTHD,50),TLTHD =nvl(TLTHD ,-19),TCC= nvl(TCC,80),BASETEMPERATURE=nvl(BASETEMPERATURE,170)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'TLL', 'BTSAPMUBP', 'CELLTEMP1THRESHOLDL', v_MBTSID, CN, SRN, SN
                , to_char(CELLTEMP1THRESHOLDL), '-200', case
                    when CELLTEMPCOMPENABLED = 0 then 'NA' else to_char(CELLTEMP1THRESHOLDL) end
, '-200', 'G', sys_guid(), 'CELLTEMPCOMPENABLED = 1,CELLTEMP1THRESHOLDH =nvl(CELLTEMP1THRESHOLDH,800),TUTHD=nvl(TUTHD,50),TLTHD =nvl(TLTHD ,-19),TCC= nvl(TCC,80),BASETEMPERATURE=nvl(BASETEMPERATURE,170)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'TUTHD', 'BTSAPMUBP', 'TUTHD', v_MBTSID, CN, SRN, SN
                , to_char(TUTHD), to_char(55), case
                    when CELLTEMPCOMPENABLED = 0 then 'NA' else to_char(TUTHD) end
, to_char(55), 'G', sys_guid(), 'CELLTEMPCOMPENABLED = 1,CELLTEMP1THRESHOLDH =nvl(CELLTEMP1THRESHOLDH,800),CELLTEMP1THRESHOLDL = nvl(CELLTEMP1THRESHOLDL,-200),TLTHD =nvl(TLTHD ,-19),TCC= nvl(TCC,80),BASETEMPERATURE=nvl(BASETEMPERATURE,170)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'TLTHD', 'BTSAPMUBP', 'TLTHD', v_MBTSID, CN, SRN, SN
                , to_char(TLTHD), '-19', case
                    when CELLTEMPCOMPENABLED = 0 then 'NA' else to_char(TLTHD) end
, '-19', 'G', sys_guid(), 'CELLTEMPCOMPENABLED = 1,CELLTEMP1THRESHOLDH =nvl(CELLTEMP1THRESHOLDH,800),CELLTEMP1THRESHOLDL = nvl(CELLTEMP1THRESHOLDL,-200),TUTHD=nvl(TUTHD,50),TCC= nvl(TCC,80),BASETEMPERATURE=nvl(BASETEMPERATURE,170)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'TCC', 'BTSAPMUBP', 'TCC', v_MBTSID, CN, SRN, SN
                , to_char(TCC), to_char(80), case
                    when CELLTEMPCOMPENABLED = 0 then 'NA' else to_char(TCC) end
, to_char(80), 'G', sys_guid(), 'CELLTEMPCOMPENABLED = 1,CELLTEMP1THRESHOLDH =nvl(CELLTEMP1THRESHOLDH,800),CELLTEMP1THRESHOLDL = nvl(CELLTEMP1THRESHOLDL,-200),TUTHD=nvl(TUTHD,50),TLTHD =nvl(TLTHD ,-19),BASETEMPERATURE=nvl(BASETEMPERATURE,170)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'BASETEMPERATURE', 'BTSAPMUBP', 'BASETEMPERATURE', v_MBTSID, CN, SRN, SN
                , to_char(BASETEMPERATURE), '170', case
                    when CELLTEMPCOMPENABLED = 0 then 'NA' else to_char(BASETEMPERATURE) end
, '170', 'G', sys_guid(), 'CELLTEMPCOMPENABLED = 1' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'AHUTHD', 'BTSAPMUBP', 'HUMALAMRTHRESHOLDH', v_MBTSID, CN, SRN, SN
                , to_char(HUMALAMRTHRESHOLDH), '800', case
                    when SETHUMPARAENABLED = 0 then 'NA' else to_char(HUMALAMRTHRESHOLDH) end
, '800', 'G', sys_guid(), 'SETHUMPARAENABLED = 1,HUMALAMRTHRESHOLDL = nvl(HUMALAMRTHRESHOLDL,100)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'AHLTHD', 'BTSAPMUBP', 'HUMALAMRTHRESHOLDL', v_MBTSID, CN, SRN, SN
                , to_char(HUMALAMRTHRESHOLDL), '100', case
                    when SETHUMPARAENABLED = 0 then 'NA' else to_char(HUMALAMRTHRESHOLDL) end
, '100', 'G', sys_guid(), 'SETHUMPARAENABLED = 1,HUMALAMRTHRESHOLDH = nvl(HUMALAMRTHRESHOLDH,800)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'ATUTHD', 'BTSAPMUBP', 'TEMPALARMTHRESHOLDH', v_MBTSID, CN, SRN, SN
                , to_char(TEMPALARMTHRESHOLDH), '500', case
                    when SETENVPARAENABLED = 0 then 'NA' else to_char(TEMPALARMTHRESHOLDH) end
, '500', 'G', sys_guid(), 'SETENVPARAENABLED = 1,TEMPALARMTHRESHOLDL = nvl(TEMPALARMTHRESHOLDL , 0)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'ATLTHD', 'BTSAPMUBP', 'TEMPALARMTHRESHOLDL', v_MBTSID, CN, SRN, SN
                , to_char(TEMPALARMTHRESHOLDL), '0', case
                    when SETENVPARAENABLED = 0 then 'NA' else to_char(TEMPALARMTHRESHOLDL) end
, '0', 'G', sys_guid(), 'SETENVPARAENABLED = 1,TEMPALARMTHRESHOLDH = nvl(TEMPALARMTHRESHOLDH,500)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'SETDIESELENGINEENABLED', 'BTSAPMUBP', 'SETDIESELENGINEENABLED', v_MBTSID, CN, SRN, SN
                , to_char(SETDIESELENGINEENABLED), '0', to_char(SETDIESELENGINEENABLED), '0', 'G', sys_guid(), 'ICF = nvl(ICF,0), POWER = nvl(POWER,125), BATTERYDISCHARGEDEPTH = nvl(BATTERYDISCHARGEDEPTH,50)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'ICF', 'BTSAPMUBP', 'ICF', v_MBTSID, CN, SRN, SN
                , to_char(ICF), '0', case
                    when SETDIESELENGINEENABLED = 0 then 'NA' else to_char(ICF) end
, '0', 'G', sys_guid(), 'POWER = nvl(POWER,125),BATTERYDISCHARGEDEPTH = nvl(BATTERYDISCHARGEDEPTH,50)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'POWER', 'BTSAPMUBP', 'POWER', v_MBTSID, CN, SRN, SN
                , to_char(to_number(POWER)), '125', case
                    when SETDIESELENGINEENABLED = 0 then 'NA' else to_char(to_number(POWER)) end
, '125', 'G', sys_guid(), 'ICF = nvl(ICF,0),BATTERYDISCHARGEDEPTH = nvl(BATTERYDISCHARGEDEPTH,50)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'BATTERYDISCHARGEDEPTH', 'BTSAPMUBP', 'BATTERYDISCHARGEDEPTH', v_MBTSID, CN, SRN, SN
                , to_char(BATTERYDISCHARGEDEPTH), to_char(55), case
                    when SETDIESELENGINEENABLED = 0 then 'NA' else to_char(BATTERYDISCHARGEDEPTH) end
, to_char(55), 'G', sys_guid(), 'ICF = nvl(ICF,0),POWER = nvl(POWER,125)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'BCD', 'BTSAPMUBP', 'BCD', v_MBTSID, CN, SRN, SN
                , to_char(BCD), to_char(60), to_char(BCD), to_char(60), 'G', sys_guid() from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DSCHGT0', 'BTSAPMUBP', 'DSCHGT0', v_MBTSID, CN, SRN, SN
                , to_char(DSCHGT0), '1200', case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(DSCHGT0) end
, '1200', 'G', sys_guid(), 'BTPC = 1,DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DSCHGT1', 'BTSAPMUBP', 'DSCHGT1', v_MBTSID, CN, SRN, SN
                , to_char(DSCHGT1), '600', case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(DSCHGT1) end
, '600', 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DSCHGT2', 'BTSAPMUBP', 'DSCHGT2', v_MBTSID, CN, SRN, SN
                , to_char(DSCHGT2), '300', case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(DSCHGT2) end
, '300', 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DSCHGT3', 'BTSAPMUBP', 'DSCHGT3', v_MBTSID, CN, SRN, SN
                , to_char(DSCHGT3), '150', case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(DSCHGT3) end
, '150', 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DSCHGT4', 'BTSAPMUBP', 'DSCHGT4', v_MBTSID, CN, SRN, SN
                , to_char(DSCHGT4), '100', case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(DSCHGT4) end
, '100', 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DSCHGT5', 'BTSAPMUBP', 'DSCHGT5', v_MBTSID, CN, SRN, SN
                , to_char(DSCHGT5), to_char(70), case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(DSCHGT5) end
, to_char(70), 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DSCHGT6', 'BTSAPMUBP', 'DSCHGT6', v_MBTSID, CN, SRN, SN
                , to_char(DSCHGT6), to_char(50), case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(DSCHGT6) end
, to_char(50), 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DSCHGT7', 'BTSAPMUBP', 'DSCHGT7', v_MBTSID, CN, SRN, SN
                , to_char(DSCHGT7), to_char(40), case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(DSCHGT7) end
, to_char(40), 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DSCHGT8', 'BTSAPMUBP', 'DSCHGT8', v_MBTSID, CN, SRN, SN
                , to_char(DSCHGT8), to_char(30), case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(DSCHGT8) end
, to_char(30), 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DSCHGT9', 'BTSAPMUBP', 'DSCHGT9', v_MBTSID, CN, SRN, SN
                , to_char(DSCHGT9), to_char(25), case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(DSCHGT9) end
, to_char(25), 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'EFF', 'BTSAPMUBP', 'EFF', v_MBTSID, CN, SRN, SN
                , to_char(EFF), to_char(80), case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(EFF) end
, to_char(80), 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'ENDV', 'BTSAPMUBP', 'ENDV', v_MBTSID, CN, SRN, SN
                , to_char(ENDV), '190', case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(ENDV) end
, '190', 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'BATNUM', 'BTSAPMUBP', 'BATNUM', v_MBTSID, CN, SRN, SN
                , to_char(BATNUM), to_char(24), case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(BATNUM) end
, to_char(24), 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM = nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DSTML', 'BTSAPMUBP', 'DSTML', v_MBTSID, CN, SRN, SN
                , to_char(DSTML), to_char(10), case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(DSTML) end
, to_char(10), 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM = nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'SDSEV', 'BTSAPMUBP', 'SDSEV', v_MBTSID, CN, SRN, SN
                , to_char(SDSEV), '450', case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(SDSEV) end
, '450', 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2), DDSTM = nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'SDSTML', 'BTSAPMUBP', 'SDSTML', v_MBTSID, CN, SRN, SN
                , to_char(SDSTML), to_char(60), case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(SDSTML) end
, to_char(60), 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),ATMODE=nvl(ATMODE,2),DDSTM = nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'ATMODE', 'BTSAPMUBP', 'ATMODE', v_MBTSID, CN, SRN, SN
                , to_char(ATMODE), '2', case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(ATMODE) end
, '2', 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),TDSTM =nvl(TDSTM,120),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'TDSTM', 'BTSAPMUBP', 'TDSTM', v_MBTSID, CN, SRN, SN
                , to_char(TDSTM), case
                    when ATMODE in  (1, 3) then '120' else '100' end
, case
                    when  (BTPC = 0 or BTPC is null or ATMODE in  (0, 2) ) then 'NA' else to_char(TDSTM) end
, case
                    when ATMODE in  (1, 3) then '120' else '100' end
, 'G', sys_guid(), 'BTPC = 1 ,DSCHGT0 =nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF = nvl(EFF,80),ENDV = nvl(ENDV,190),BATNUM = nvl(BATNUM,24),DSTML = nvl(DSTML,10),SDSEV = nvl(SDSEV,450),SDSTML = nvl(SDSTML,60),ATMODE = nvl(ATMODE,2),DDSTM = nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DDSTM', 'BTSAPMUBP', 'DDSTM', v_MBTSID, CN, SRN, SN
                , to_char(DDSTM), to_char(14), to_char(DDSTM), to_char(14), 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
        end;
end;
/

create or replace procedure sp_RANCC_MBTSComPMU_C3 (
    v_PlanID in number ,
    v_MBTSID in varchar2 ,
    v_CMENEID in number ,
    v_PhyNEID in number ,
    v_SiteId in number  )
as
begin
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'CMEMODE' || to_char(PN), 'BTSENVALMPORT', 'SW', v_MBTSID, b.CN, b.SRN, b.SN
                , to_char(SW), '0', to_char(SW), '0', 'Switch on Port No.' || to_char(PN), 'G', sys_guid() from t_C_BTSENVALMPORT_C3 a, t_C_BTSBRD_C3 b where a.CMENEID = v_PhyNEID and a.CMENEID = b.CMENEID and a.BTSID = v_SiteId
                     and a.BTSID = b.BTSID and a.CN = b.CN and a.SRN = b.SRN
                     and a.SN = b.SN and BT = 114;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'AVOL' || to_char(PN), 'BTSENVALMPORT', 'AVOL', v_MBTSID, b.CN, b.SRN, b.SN
                , to_char(a.AVOL), '0', case
                    when a.SW = 0 then 'NA' else to_char(case a.AVOL when 0 then 1 when 1 then 0 end
) end
, '1', 'Alarm Voltage on Port No.' || to_char(PN), 'G', sys_guid() from t_C_BTSENVALMPORT_C3 a, t_C_BTSBRD_C3 b where a.CMENEID = v_PhyNEID and a.CMENEID = b.CMENEID and a.BTSID = v_SiteId
                     and a.BTSID = b.BTSID and a.CN = b.CN and a.SRN = b.SRN
                     and a.SN = b.SN and BT = 114;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'CFGFLAG', 'BTSAPMUBP', 'CFGFLAG', v_MBTSID, CN, SRN, SN
                , to_char(CFGFLAG), '1', to_char(CFGFLAG), '1', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'LFLG', 'BTSAPMUBP', 'HIGHTEMPLOADPWROFF', v_MBTSID, CN, SRN, SN
                , to_char(HIGHTEMPLOADPWROFF), '170', to_char(case
                    when HIGHTEMPLOADPWROFF = 170 then 0 else 1 end
), '0', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'LTEM', 'BTSAPMUBP', 'TEMPOFHIGHTEMPLOADPWROFF', v_MBTSID, CN, SRN, SN
                , to_char(TEMPOFHIGHTEMPLOADPWROFF), to_char(65), to_char(TEMPOFHIGHTEMPLOADPWROFF), to_char(65), 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and HIGHTEMPLOADPWROFF = 170;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'HTSDF', 'BTSAPMUBP', 'HTSDF', v_MBTSID, CN, SRN, SN
                , to_char(HTSDF), '1', to_char(HTSDF), '1', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'SDT', 'BTSAPMUBP', 'SDT', v_MBTSID, CN, SRN, SN
                , to_char(SDT), to_char(53), to_char(SDT), to_char(53), 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and HTSDF = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'BT1_DISABLE', 'BTSAPMUBP', 'SAAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 1)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (2, 3, 5) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 1)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (2, 3, 5) then '0' else '1' end
, 'Special Analog Alarm Flag(Battery Temperature Sensor 1 Disabled)', '1', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'AH_DISABLE', 'BTSAPMUBP', 'SAAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 2)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 2)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, 'Special Analog Alarm Flag(Cabinet Humidity Sensor Disabled)', '2', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'AT1_DISABLE', 'BTSAPMUBP', 'SAAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 4)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (0, 1, 7) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 4)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (0, 1, 7) then '0' else '1' end
, 'Special Analog Alarm Flag(Cabinet Temperature Sensor 1 Disabled)', '4', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'AT2_DISABLE', 'BTSAPMUBP', 'SAAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 8)) = 0 then 0 else 1 end
), '1', to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 8)) = 0 then 0 else 1 end
), '1', 'Special Analog Alarm Flag(Cabinet Temperature Sensor 2 Disabled)', '8', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'BT2_DISABLE', 'BTSAPMUBP', 'SAAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 16)) = 0 then 0 else 1 end
), '1', to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 16)) = 0 then 0 else 1 end
), '1', 'Special Analog Alarm Flag(Battery Temperature Sensor 2 Disabled)', to_char(16), 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'WS_DISABLE', 'BTSAPMUBP', 'SBAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 1)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 1)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, 'Special Boolean Alarm Flag(Water-Immersed Sensor Disabled)', '1', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'SS_DISABLE', 'BTSAPMUBP', 'SBAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 2)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 2)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, 'Special Boolean Alarm Flag(Smog Sensor Disabled)', '2', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'GS_DISABLE', 'BTSAPMUBP', 'SBAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 4)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (0, 1, 2, 7) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 4)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (0, 1, 2, 7) then '0' else '1' end
, 'Special Boolean Alarm Flag(Gating Sensor Disabled)', '4', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'PTYPE', 'BTSAPMUBP', 'PTYPE', v_MBTSID, CN, SRN, SN
                , to_char(PTYPE), '2', to_char(PTYPE), '2', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'BTYPE', 'BTSAPMUBP', 'BTYPE', v_MBTSID, CN, SRN, SN
                , to_char(BTYPE), '255', to_char(BTYPE), '255', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and BE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'BCLC', 'BTSAPMUBP', 'BCLC', v_MBTSID, CN, SRN, SN
                , to_char(BCLC), to_char(15), to_char(BCLC), to_char(15), 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and BE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'BC1', 'BTSAPMUBP', 'BC', v_MBTSID, CN, SRN, SN
                , to_char(BC), to_char(36), to_char(BC), to_char(36), 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and BE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'BN', 'BTSAPMUBP', 'BN', v_MBTSID, CN, SRN, SN
                , to_char(BN), '1', to_char(BN), '1', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and BE = 1
                     and BTYPE = 2;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'LSDV', 'BTSAPMUBP', 'LSDV', v_MBTSID, CN, SRN, SN
                , to_char(LSDV), '440', to_char(LSDV), '440', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and HPVFLAG = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'BCV', 'BTSAPMUBP', 'BCV', v_MBTSID, CN, SRN, SN
                , to_char(BCV), '565', to_char(BCV), '565', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and HPVFLAG = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'FCV', 'BTSAPMUBP', 'FCV', v_MBTSID, CN, SRN, SN
                , to_char(FCV), '535', to_char(FCV), '535', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and HPVFLAG = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'LSDF', 'BTSAPMUBP', 'LSDF', v_MBTSID, CN, SRN, SN
                , to_char(LSDF), '0', to_char(LSDF), '0', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and HPVFLAG = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'LVSDF', 'BTSAPMUBP', 'LVSDF', v_MBTSID, CN, SRN, SN
                , to_char(LVSDF), '1', to_char(LVSDF), '1', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and HPVFLAG = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'SDV', 'BTSAPMUBP', 'SDV', v_MBTSID, CN, SRN, SN
                , to_char(SDV), '430', to_char(SDV), '430', 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and HPVFLAG = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'LOWTEMPLOADPWROFF', 'BTSAPMUBP', 'LOWTEMPLOADPWROFF', v_MBTSID, CN, SRN, SN
                , to_char(LOWTEMPLOADPWROFF), to_char(85), to_char(LOWTEMPLOADPWROFF), to_char(85), 'G', sys_guid() from t_C_BTSAPMUBP_C3 where CMENEID = v_PhyNEID and BTSID = v_SiteId and HPVFLAG = 1;

            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'BT1_DISABLE', 'BTSAPMUBP', 'SAAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 1)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (2, 3, 5) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 1)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (2, 3, 5) then '0' else '1' end
, 'Special Analog Alarm Flag(Battery Temperature Sensor 1 Disabled)', '1', 'G', sys_guid(), 'ALMENABLE = 1' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId
                     and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'AH_DISABLE', 'BTSAPMUBP', 'SAAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 2)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 2)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, 'Special Analog Alarm Flag(Cabinet Humidity Sensor Disabled)', '2', 'G', sys_guid(), 'ALMENABLE = 1' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId
                     and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'AT1_DISABLE', 'BTSAPMUBP', 'SAAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 4)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (0, 1, 7) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 4)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (0, 1, 7) then '0' else '1' end
, 'Special Analog Alarm Flag(Cabinet Temperature Sensor 1 Disabled)', '4', 'G', sys_guid(), 'ALMENABLE = 1' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId
                     and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'AT2_DISABLE', 'BTSAPMUBP', 'SAAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 8)) = 0 then 0 else 1 end
), '1', to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 8)) = 0 then 0 else 1 end
), '1', 'Special Analog Alarm Flag(Cabinet Temperature Sensor 2 Disabled)', '8', 'G', sys_guid(), 'ALMENABLE = 1' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId
                     and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'BT2_DISABLE', 'BTSAPMUBP', 'SAAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 16)) = 0 then 0 else 1 end
), '1', to_char(case
                    when (bitand((case
                    when SAAF is NULL then 0 else SAAF end
), 16)) = 0 then 0 else 1 end
), '1', 'Special Analog Alarm Flag(Battery Temperature Sensor 2 Disabled)', to_char(16), 'G', sys_guid(), 'ALMENABLE = 1' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId
                     and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'WS_DISABLE', 'BTSAPMUBP', 'SBAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 1)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 1)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, 'Special Boolean Alarm Flag(Water-Immersed Sensor Disabled)', '1', 'G', sys_guid(), 'ALMENABLE = 1' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId
                     and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'SS_DISABLE', 'BTSAPMUBP', 'SBAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 2)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 2)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (7) then '0' else '1' end
, 'Special Boolean Alarm Flag(Smog Sensor Disabled)', '2', 'G', sys_guid(), 'ALMENABLE = 1' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId
                     and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,FieldDesc,ProcForFix,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'GS_DISABLE', 'BTSAPMUBP', 'SBAF', v_MBTSID, CN, SRN, SN
                , to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 4)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (0, 1, 2, 7) then '0' else '1' end
, to_char(case
                    when (bitand((case
                    when SBAF is NULL then 0 else SBAF end
), 4)) = 0 then 0 else 1 end
), case
                    when PTYPE in  (0, 1, 2, 7) then '0' else '1' end
, 'Special Boolean Alarm Flag(Gating Sensor Disabled)', '4', 'G', sys_guid(), 'ALMENABLE = 1' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId
                     and ALMENABLE = 1;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'PTYPE', 'BTSAPMUBP', 'PTYPE', v_MBTSID, CN, SRN, SN
                , to_char(PTYPE), '2', to_char(PTYPE), '2', 'G', sys_guid() from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'BTYPE', 'BTSAPMUBP', 'BTYPE', v_MBTSID, CN, SRN, SN
                ,  nvl(to_char(BTYPE), '255'), '255', case
                    when BE = 0 then '255' else to_char(BTYPE) end
, '255', 'G', sys_guid(), 'BE = 1,BCLC = case when BTYPE = 2 then null else nvl(BCLC,15) end, BC = case when BTYPE = 2 then null else nvl(BC,36) end' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'BCLC', 'BTSAPMUBP', 'BCLC', v_MBTSID, CN, SRN, SN
                , to_char(BCLC), to_char(15), case
                    when  (BE = 0 or BTYPE = 255 ) then 'NA' else to_char(BCLC) end
, to_char(15), 'G', sys_guid(), 'BE = 1,BTYPE = nvl(BTYPE,255), BC = nvl(BC,36)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'BC1', 'BTSAPMUBP', 'BC', v_MBTSID, CN, SRN, SN
                , to_char(BC), to_char(36), case
                    when  (BE = 0 or BTYPE = 255 ) then 'NA' else to_char(BC) end
, to_char(36), 'G', sys_guid(), 'BE = 1,BTYPE = nvl(BTYPE,255),BCLC = nvl(BCLC,15)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'BN', 'BTSAPMUBP', 'BN', v_MBTSID, CN, SRN, SN
                , to_char(BN), '1', case
                    when  (BE = 0 or BTYPE in  (255, 0, 1) ) then 'NA' else to_char(BN) end
, '1', 'G', sys_guid(), 'BE = 1' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'LSDV', 'BTSAPMUBP', 'LSDV', v_MBTSID, CN, SRN, SN
                , to_char(to_number(LSDV)), '440', case
                    when HPVFLAG = 0 or LSDF = 0 then 'NA' else to_char(to_number(LSDV)) end
, '440', 'G', sys_guid(), 'HPVFLAG = 1,BCV=nvl(BCV,565) ,FCV =nvl(FCV,535) ,LSDF=nvl(LSDF,0),LVSDF=nvl(LVSDF,1), SDV= nvl(SDV,430), LOWTEMPLOADPWROFF=nvl(LOWTEMPLOADPWROFF,85),TEMPOFLOWTEMPLOADPWROFF=nvl(TEMPOFLOWTEMPLOADPWROFF,-100),ACVUTHD=nvl(ACVUTHD,280),ACVLTHD=nvl(ACVLTHD,180),DCVUTHD=nvl(DCVUTHD,580),DCVLTHD=nvl(DCVLTHD,450)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'BCV', 'BTSAPMUBP', 'BCV', v_MBTSID, CN, SRN, SN
                , to_char(to_number(BCV)), '565', case
                    when HPVFLAG = 0 then 'NA' else to_char(to_number(BCV)) end
, '565', 'G', sys_guid(), 'HPVFLAG = 1,LSDV = nvl(LSDV,440) ,FCV =nvl(FCV,535) ,LSDF=nvl(LSDF,0),LVSDF=nvl(LVSDF,1), SDV= nvl(SDV,430), LOWTEMPLOADPWROFF=nvl(LOWTEMPLOADPWROFF,85),TEMPOFLOWTEMPLOADPWROFF=nvl(TEMPOFLOWTEMPLOADPWROFF,-100),ACVUTHD=nvl(ACVUTHD,280),ACVLTHD=nvl(ACVLTHD,180),DCVUTHD=nvl(DCVUTHD,580),DCVLTHD=nvl(DCVLTHD,450)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'FCV', 'BTSAPMUBP', 'FCV', v_MBTSID, CN, SRN, SN
                , to_char(to_number(FCV)), '535', case
                    when HPVFLAG = 0 then 'NA' else to_char(to_number(FCV)) end
, '535', 'G', sys_guid(), 'HPVFLAG = 1,LSDV = nvl(LSDV,440) ,BCV=nvl(BCV,565) ,LSDF=nvl(LSDF,0),LVSDF=nvl(LVSDF,1), SDV= nvl(SDV,430), LOWTEMPLOADPWROFF=nvl(LOWTEMPLOADPWROFF,85),TEMPOFLOWTEMPLOADPWROFF=nvl(TEMPOFLOWTEMPLOADPWROFF,-100),ACVUTHD=nvl(ACVUTHD,280),ACVLTHD=nvl(ACVLTHD,180),DCVUTHD=nvl(DCVUTHD,580),DCVLTHD=nvl(DCVLTHD,450)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'LSDF', 'BTSAPMUBP', 'LSDF', v_MBTSID, CN, SRN, SN
                , to_char(LSDF), '0', case
                    when HPVFLAG = 0 then 'NA' else to_char(LSDF) end
, '0', 'G', sys_guid(), 'HPVFLAG = 1,LSDV = nvl(LSDV,440) ,BCV=nvl(BCV,565) ,FCV =nvl(FCV,535) ,LVSDF=nvl(LVSDF,1), SDV= nvl(SDV,430), LOWTEMPLOADPWROFF=nvl(LOWTEMPLOADPWROFF,85),TEMPOFLOWTEMPLOADPWROFF=nvl(TEMPOFLOWTEMPLOADPWROFF,-100),ACVUTHD=nvl(ACVUTHD,280),ACVLTHD=nvl(ACVLTHD,180),DCVUTHD=nvl(DCVUTHD,580),DCVLTHD=nvl(DCVLTHD,450)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'LVSDF', 'BTSAPMUBP', 'LVSDF', v_MBTSID, CN, SRN, SN
                , to_char(LVSDF), '1', case
                    when HPVFLAG = 0 then 'NA' else to_char(LVSDF) end
, '1', 'G', sys_guid(), 'HPVFLAG = 1,LSDV = nvl(LSDV,440) ,BCV=nvl(BCV,565) ,FCV =nvl(FCV,535) ,LSDF=nvl(LSDF,0), SDV= nvl(SDV,430), LOWTEMPLOADPWROFF=nvl(LOWTEMPLOADPWROFF,85),TEMPOFLOWTEMPLOADPWROFF=nvl(TEMPOFLOWTEMPLOADPWROFF,-100),ACVUTHD=nvl(ACVUTHD,280),ACVLTHD=nvl(ACVLTHD,180),DCVUTHD=nvl(DCVUTHD,580),DCVLTHD=nvl(DCVLTHD,450)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'SDV', 'BTSAPMUBP', 'SDV', v_MBTSID, CN, SRN, SN
                , to_char(SDV), '430', case
                    when HPVFLAG = 0 or LVSDF = 0 then 'NA' else to_char(SDV) end
, '430', 'G', sys_guid(), 'HPVFLAG = 1,LSDV = nvl(LSDV,440) ,BCV=nvl(BCV,565) ,FCV =nvl(FCV,535) ,LSDF=nvl(LSDF,0),LVSDF=nvl(LVSDF,1), LOWTEMPLOADPWROFF=nvl(LOWTEMPLOADPWROFF,85),TEMPOFLOWTEMPLOADPWROFF=nvl(TEMPOFLOWTEMPLOADPWROFF,-100),ACVUTHD=nvl(ACVUTHD,280),ACVLTHD=nvl(ACVLTHD,180),DCVUTHD=nvl(DCVUTHD,580),DCVLTHD=nvl(DCVLTHD,450)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'LOWTEMPLOADPWROFF', 'BTSAPMUBP', 'LOWTEMPLOADPWROFF', v_MBTSID, CN, SRN, SN
                , to_char(LOWTEMPLOADPWROFF), to_char(85), case
                    when HPVFLAG = 0 then 'NA' else to_char(LOWTEMPLOADPWROFF) end
, to_char(85), 'G', sys_guid(), 'HPVFLAG = 1,LSDV = nvl(LSDV,440) ,BCV=nvl(BCV,565) ,FCV =nvl(FCV,535) ,LSDF=nvl(LSDF,0),LVSDF=nvl(LVSDF,1), SDV= nvl(SDV,430), TEMPOFLOWTEMPLOADPWROFF=nvl(TEMPOFLOWTEMPLOADPWROFF,-100),ACVUTHD=nvl(ACVUTHD,280),ACVLTHD=nvl(ACVLTHD,180),DCVUTHD=nvl(DCVUTHD,580),DCVLTHD=nvl(DCVLTHD,450)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'TEMPOFLOWTEMPLOADPWROFF', 'BTSAPMUBP', 'TEMPOFLOWTEMPLOADPWROFF', v_MBTSID, CN, SRN, SN
                , to_char(TEMPOFLOWTEMPLOADPWROFF), '-100', case
                    when HPVFLAG = 0 then 'NA' else to_char(TEMPOFLOWTEMPLOADPWROFF) end
, '-100', 'G', sys_guid(), 'HPVFLAG = 1,LSDV = nvl(LSDV,440) ,BCV=nvl(BCV,565) ,FCV =nvl(FCV,535) ,LSDF=nvl(LSDF,0),LVSDF=nvl(LVSDF,1), SDV= nvl(SDV,430), LOWTEMPLOADPWROFF=nvl(LOWTEMPLOADPWROFF,85),ACVUTHD=nvl(ACVUTHD,280),ACVLTHD=nvl(ACVLTHD,180),DCVUTHD=nvl(DCVUTHD,580),DCVLTHD=nvl(DCVLTHD,450)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'ACVUTHD', 'BTSAPMUBP', 'ACVUTHD', v_MBTSID, CN, SRN, SN
                , to_char(ACVUTHD), '280', case
                    when HPVFLAG = 0 then 'NA' else to_char(ACVUTHD) end
, '280', 'G', sys_guid(), 'HPVFLAG = 1,LSDV = nvl(LSDV,440) ,BCV=nvl(BCV,565) ,FCV =nvl(FCV,535) ,LSDF=nvl(LSDF,0),LVSDF=nvl(LVSDF,1), SDV= nvl(SDV,430), LOWTEMPLOADPWROFF=nvl(LOWTEMPLOADPWROFF,85),TEMPOFLOWTEMPLOADPWROFF=nvl(TEMPOFLOWTEMPLOADPWROFF,-100),ACVLTHD=nvl(ACVLTHD,180),DCVUTHD=nvl(DCVUTHD,580),DCVLTHD=nvl(DCVLTHD,450)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'ACVLTHD', 'BTSAPMUBP', 'ACVLTHD', v_MBTSID, CN, SRN, SN
                , to_char(ACVLTHD), '180', case
                    when HPVFLAG = 0 then 'NA' else to_char(ACVLTHD) end
, '180', 'G', sys_guid(), 'HPVFLAG = 1,LSDV = nvl(LSDV,440) ,BCV=nvl(BCV,565) ,FCV =nvl(FCV,535) ,LSDF=nvl(LSDF,0),LVSDF=nvl(LVSDF,1), SDV= nvl(SDV,430), LOWTEMPLOADPWROFF=nvl(LOWTEMPLOADPWROFF,85),TEMPOFLOWTEMPLOADPWROFF=nvl(TEMPOFLOWTEMPLOADPWROFF,-100),ACVUTHD=nvl(ACVUTHD,280),DCVUTHD=nvl(DCVUTHD,580),DCVLTHD=nvl(DCVLTHD,450)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DCVUTHD', 'BTSAPMUBP', 'DCVUTHD', v_MBTSID, CN, SRN, SN
                , to_char(to_number(DCVUTHD)), '580', case
                    when HPVFLAG = 0 then 'NA' else to_char(to_number(DCVUTHD)) end
, '580', 'G', sys_guid(), 'HPVFLAG = 1,LSDV = nvl(LSDV,440) ,BCV=nvl(BCV,565) ,FCV =nvl(FCV,535) ,LSDF=nvl(LSDF,0),LVSDF=nvl(LVSDF,1), SDV= nvl(SDV,430), LOWTEMPLOADPWROFF=nvl(LOWTEMPLOADPWROFF,85),TEMPOFLOWTEMPLOADPWROFF=nvl(TEMPOFLOWTEMPLOADPWROFF,-100),ACVUTHD=nvl(ACVUTHD,280),ACVLTHD=nvl(ACVLTHD,180),DCVLTHD=nvl(DCVLTHD,450)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DCVLTHD', 'BTSAPMUBP', 'DCVLTHD', v_MBTSID, CN, SRN, SN
                , to_char(to_number(DCVLTHD)), '450', case
                    when HPVFLAG = 0 then 'NA' else to_char(to_number(DCVLTHD)) end
, '450', 'G', sys_guid(), 'HPVFLAG = 1, LSDV = nvl(LSDV,440), BCV=nvl(BCV,565) ,FCV =nvl(FCV,535), LSDF=nvl(LSDF,0), LVSDF=nvl(LVSDF,1), SDV= nvl(SDV,430), LOWTEMPLOADPWROFF=nvl(LOWTEMPLOADPWROFF,85), TEMPOFLOWTEMPLOADPWROFF=nvl(TEMPOFLOWTEMPLOADPWROFF,-100), ACVUTHD=nvl(ACVUTHD,280), ACVLTHD=nvl(ACVLTHD,180), DCVUTHD=nvl(DCVUTHD,580)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'TUL', 'BTSAPMUBP', 'CELLTEMP1THRESHOLDH', v_MBTSID, CN, SRN, SN
                , to_char(CELLTEMP1THRESHOLDH), '800', case
                    when CELLTEMPCOMPENABLED = 0 then 'NA' else to_char(CELLTEMP1THRESHOLDH) end
, '800', 'G', sys_guid(), 'CELLTEMPCOMPENABLED = 1,CELLTEMP1THRESHOLDL = nvl(CELLTEMP1THRESHOLDL,-200),TUTHD=nvl(TUTHD,50),TLTHD =nvl(TLTHD ,-19),TCC= nvl(TCC,80),BASETEMPERATURE=nvl(BASETEMPERATURE,170)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'TLL', 'BTSAPMUBP', 'CELLTEMP1THRESHOLDL', v_MBTSID, CN, SRN, SN
                , to_char(CELLTEMP1THRESHOLDL), '-200', case
                    when CELLTEMPCOMPENABLED = 0 then 'NA' else to_char(CELLTEMP1THRESHOLDL) end
, '-200', 'G', sys_guid(), 'CELLTEMPCOMPENABLED = 1,CELLTEMP1THRESHOLDH =nvl(CELLTEMP1THRESHOLDH,800),TUTHD=nvl(TUTHD,50),TLTHD =nvl(TLTHD ,-19),TCC= nvl(TCC,80),BASETEMPERATURE=nvl(BASETEMPERATURE,170)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'TUTHD', 'BTSAPMUBP', 'TUTHD', v_MBTSID, CN, SRN, SN
                , to_char(TUTHD), to_char(55), case
                    when CELLTEMPCOMPENABLED = 0 then 'NA' else to_char(TUTHD) end
, to_char(55), 'G', sys_guid(), 'CELLTEMPCOMPENABLED = 1,CELLTEMP1THRESHOLDH =nvl(CELLTEMP1THRESHOLDH,800),CELLTEMP1THRESHOLDL = nvl(CELLTEMP1THRESHOLDL,-200),TLTHD =nvl(TLTHD ,-19),TCC= nvl(TCC,80),BASETEMPERATURE=nvl(BASETEMPERATURE,170)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'TLTHD', 'BTSAPMUBP', 'TLTHD', v_MBTSID, CN, SRN, SN
                , to_char(TLTHD), '-19', case
                    when CELLTEMPCOMPENABLED = 0 then 'NA' else to_char(TLTHD) end
, '-19', 'G', sys_guid(), 'CELLTEMPCOMPENABLED = 1,CELLTEMP1THRESHOLDH =nvl(CELLTEMP1THRESHOLDH,800),CELLTEMP1THRESHOLDL = nvl(CELLTEMP1THRESHOLDL,-200),TUTHD=nvl(TUTHD,50),TCC= nvl(TCC,80),BASETEMPERATURE=nvl(BASETEMPERATURE,170)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'TCC', 'BTSAPMUBP', 'TCC', v_MBTSID, CN, SRN, SN
                , to_char(TCC), to_char(80), case
                    when CELLTEMPCOMPENABLED = 0 then 'NA' else to_char(TCC) end
, to_char(80), 'G', sys_guid(), 'CELLTEMPCOMPENABLED = 1,CELLTEMP1THRESHOLDH =nvl(CELLTEMP1THRESHOLDH,800),CELLTEMP1THRESHOLDL = nvl(CELLTEMP1THRESHOLDL,-200),TUTHD=nvl(TUTHD,50),TLTHD =nvl(TLTHD ,-19),BASETEMPERATURE=nvl(BASETEMPERATURE,170)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'BASETEMPERATURE', 'BTSAPMUBP', 'BASETEMPERATURE', v_MBTSID, CN, SRN, SN
                , to_char(BASETEMPERATURE), '170', case
                    when CELLTEMPCOMPENABLED = 0 then 'NA' else to_char(BASETEMPERATURE) end
, '170', 'G', sys_guid(), 'CELLTEMPCOMPENABLED = 1' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'AHUTHD', 'BTSAPMUBP', 'HUMALAMRTHRESHOLDH', v_MBTSID, CN, SRN, SN
                , to_char(HUMALAMRTHRESHOLDH), '800', case
                    when SETHUMPARAENABLED = 0 then 'NA' else to_char(HUMALAMRTHRESHOLDH) end
, '800', 'G', sys_guid(), 'SETHUMPARAENABLED = 1,HUMALAMRTHRESHOLDL = nvl(HUMALAMRTHRESHOLDL,100)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'AHLTHD', 'BTSAPMUBP', 'HUMALAMRTHRESHOLDL', v_MBTSID, CN, SRN, SN
                , to_char(HUMALAMRTHRESHOLDL), '100', case
                    when SETHUMPARAENABLED = 0 then 'NA' else to_char(HUMALAMRTHRESHOLDL) end
, '100', 'G', sys_guid(), 'SETHUMPARAENABLED = 1,HUMALAMRTHRESHOLDH = nvl(HUMALAMRTHRESHOLDH,800)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'ATUTHD', 'BTSAPMUBP', 'TEMPALARMTHRESHOLDH', v_MBTSID, CN, SRN, SN
                , to_char(TEMPALARMTHRESHOLDH), '500', case
                    when SETENVPARAENABLED = 0 then 'NA' else to_char(TEMPALARMTHRESHOLDH) end
, '500', 'G', sys_guid(), 'SETENVPARAENABLED = 1,TEMPALARMTHRESHOLDL = nvl(TEMPALARMTHRESHOLDL , 0)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'ATLTHD', 'BTSAPMUBP', 'TEMPALARMTHRESHOLDL', v_MBTSID, CN, SRN, SN
                , to_char(TEMPALARMTHRESHOLDL), '0', case
                    when SETENVPARAENABLED = 0 then 'NA' else to_char(TEMPALARMTHRESHOLDL) end
, '0', 'G', sys_guid(), 'SETENVPARAENABLED = 1,TEMPALARMTHRESHOLDH = nvl(TEMPALARMTHRESHOLDH,500)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'SETDIESELENGINEENABLED', 'BTSAPMUBP', 'SETDIESELENGINEENABLED', v_MBTSID, CN, SRN, SN
                , to_char(SETDIESELENGINEENABLED), '0', to_char(SETDIESELENGINEENABLED), '0', 'G', sys_guid(), 'ICF = nvl(ICF,0), POWER = nvl(POWER,125), BATTERYDISCHARGEDEPTH = nvl(BATTERYDISCHARGEDEPTH,50)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'ICF', 'BTSAPMUBP', 'ICF', v_MBTSID, CN, SRN, SN
                , to_char(ICF), '0', case
                    when SETDIESELENGINEENABLED = 0 then 'NA' else to_char(ICF) end
, '0', 'G', sys_guid(), 'POWER = nvl(POWER,125),BATTERYDISCHARGEDEPTH = nvl(BATTERYDISCHARGEDEPTH,50)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'POWER', 'BTSAPMUBP', 'POWER', v_MBTSID, CN, SRN, SN
                , to_char(to_number(POWER)), '125', case
                    when SETDIESELENGINEENABLED = 0 then 'NA' else to_char(to_number(POWER)) end
, '125', 'G', sys_guid(), 'ICF = nvl(ICF,0),BATTERYDISCHARGEDEPTH = nvl(BATTERYDISCHARGEDEPTH,50)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'BATTERYDISCHARGEDEPTH', 'BTSAPMUBP', 'BATTERYDISCHARGEDEPTH', v_MBTSID, CN, SRN, SN
                , to_char(BATTERYDISCHARGEDEPTH), to_char(55), case
                    when SETDIESELENGINEENABLED = 0 then 'NA' else to_char(BATTERYDISCHARGEDEPTH) end
, to_char(55), 'G', sys_guid(), 'ICF = nvl(ICF,0),POWER = nvl(POWER,125)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId)
                select v_PlanID, v_CMENEID, 'PMU', 'BCD', 'BTSAPMUBP', 'BCD', v_MBTSID, CN, SRN, SN
                , to_char(BCD), to_char(60), to_char(BCD), to_char(60), 'G', sys_guid() from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DSCHGT0', 'BTSAPMUBP', 'DSCHGT0', v_MBTSID, CN, SRN, SN
                , to_char(DSCHGT0), '1200', case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(DSCHGT0) end
, '1200', 'G', sys_guid(), 'BTPC = 1,DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DSCHGT1', 'BTSAPMUBP', 'DSCHGT1', v_MBTSID, CN, SRN, SN
                , to_char(DSCHGT1), '600', case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(DSCHGT1) end
, '600', 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DSCHGT2', 'BTSAPMUBP', 'DSCHGT2', v_MBTSID, CN, SRN, SN
                , to_char(DSCHGT2), '300', case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(DSCHGT2) end
, '300', 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DSCHGT3', 'BTSAPMUBP', 'DSCHGT3', v_MBTSID, CN, SRN, SN
                , to_char(DSCHGT3), '150', case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(DSCHGT3) end
, '150', 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DSCHGT4', 'BTSAPMUBP', 'DSCHGT4', v_MBTSID, CN, SRN, SN
                , to_char(DSCHGT4), '100', case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(DSCHGT4) end
, '100', 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DSCHGT5', 'BTSAPMUBP', 'DSCHGT5', v_MBTSID, CN, SRN, SN
                , to_char(DSCHGT5), to_char(70), case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(DSCHGT5) end
, to_char(70), 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DSCHGT6', 'BTSAPMUBP', 'DSCHGT6', v_MBTSID, CN, SRN, SN
                , to_char(DSCHGT6), to_char(50), case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(DSCHGT6) end
, to_char(50), 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DSCHGT7', 'BTSAPMUBP', 'DSCHGT7', v_MBTSID, CN, SRN, SN
                , to_char(DSCHGT7), to_char(40), case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(DSCHGT7) end
, to_char(40), 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DSCHGT8', 'BTSAPMUBP', 'DSCHGT8', v_MBTSID, CN, SRN, SN
                , to_char(DSCHGT8), to_char(30), case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(DSCHGT8) end
, to_char(30), 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DSCHGT9', 'BTSAPMUBP', 'DSCHGT9', v_MBTSID, CN, SRN, SN
                , to_char(DSCHGT9), to_char(25), case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(DSCHGT9) end
, to_char(25), 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'EFF', 'BTSAPMUBP', 'EFF', v_MBTSID, CN, SRN, SN
                , to_char(EFF), to_char(80), case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(EFF) end
, to_char(80), 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'ENDV', 'BTSAPMUBP', 'ENDV', v_MBTSID, CN, SRN, SN
                , to_char(ENDV), '190', case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(ENDV) end
, '190', 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'BATNUM', 'BTSAPMUBP', 'BATNUM', v_MBTSID, CN, SRN, SN
                , to_char(BATNUM), to_char(24), case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(BATNUM) end
, to_char(24), 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM = nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DSTML', 'BTSAPMUBP', 'DSTML', v_MBTSID, CN, SRN, SN
                , to_char(DSTML), to_char(10), case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(DSTML) end
, to_char(10), 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2),DDSTM = nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'SDSEV', 'BTSAPMUBP', 'SDSEV', v_MBTSID, CN, SRN, SN
                , to_char(SDSEV), '450', case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(SDSEV) end
, '450', 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2), DDSTM = nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'SDSTML', 'BTSAPMUBP', 'SDSTML', v_MBTSID, CN, SRN, SN
                , to_char(SDSTML), to_char(60), case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(SDSTML) end
, to_char(60), 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),ATMODE=nvl(ATMODE,2),DDSTM = nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'ATMODE', 'BTSAPMUBP', 'ATMODE', v_MBTSID, CN, SRN, SN
                , to_char(ATMODE), '2', case
                    when BTPC = 0 or BTPC is null then 'NA' else to_char(ATMODE) end
, '2', 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),TDSTM =nvl(TDSTM,120),DDSTM=nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'TDSTM', 'BTSAPMUBP', 'TDSTM', v_MBTSID, CN, SRN, SN
                , to_char(TDSTM), case
                    when ATMODE in  (1, 3) then '120' else '100' end
, case
                    when  (BTPC = 0 or BTPC is null or ATMODE in  (0, 2) ) then 'NA' else to_char(TDSTM) end
, case
                    when ATMODE in  (1, 3) then '120' else '100' end
, 'G', sys_guid(), 'BTPC = 1 ,DSCHGT0 =nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF = nvl(EFF,80),ENDV = nvl(ENDV,190),BATNUM = nvl(BATNUM,24),DSTML = nvl(DSTML,10),SDSEV = nvl(SDSEV,450),SDSTML = nvl(SDSTML,60),ATMODE = nvl(ATMODE,2),DDSTM = nvl(DDSTM,14)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
            insert into t_RANCC_MBTSComParaTemp (PlanID,CMENEID,Moc,MocParameter,MocName,TableField,MBTSID,CN,SRN,SN,FieldValue,DefaultValue,cFieldValue,cDefauleValue,NEType,ObjId,RelatedField)
                select v_PlanID, v_CMENEID, 'PMU', 'DDSTM', 'BTSAPMUBP', 'DDSTM', v_MBTSID, CN, SRN, SN
                , to_char(DDSTM), to_char(14), to_char(DDSTM), to_char(14), 'G', sys_guid(), 'BTPC = 1,DSCHGT0 = nvl(DSCHGT0,1200),DSCHGT1 = nvl(DSCHGT1,600),DSCHGT2 = nvl(DSCHGT2,300),DSCHGT3 = nvl(DSCHGT3,150),DSCHGT4 = nvl(DSCHGT4,100),DSCHGT5 = nvl(DSCHGT5,70),DSCHGT6 = nvl(DSCHGT6,50),DSCHGT7 = nvl(DSCHGT7,40),DSCHGT8 = nvl(DSCHGT8,30),DSCHGT9 = nvl(DSCHGT9,25),EFF=nvl(EFF,80),ENDV=nvl(ENDV,190),BATNUM=nvl(BATNUM,24),DSTML=nvl(DSTML,10),SDSEV=nvl(SDSEV,450),SDSTML=nvl(SDSTML,60),ATMODE=nvl(ATMODE,2)' from t_P_BTSAPMUBP_C3 where PlanID = v_PlanID and CMENEID = v_PhyNEID and BTSID = v_SiteId;
        end;
end;
/

create or replace function FUNC_NEST_TRANSFER_005(V_ID5 INT) return int is
  V_num5 int;
begin
  dbe_output.print_line('FUNC_NEST_TRANSFER_005 begin');
  V_num5:=V_ID5+1;
  dbe_output.print_line('FUNC_NEST_TRANSFER_005 end');
  return(V_num5);
end FUNC_NEST_TRANSFER_005;
/

create or replace function FUNC_NEST_TRANSFER_004(V_ID4 INT) return int is
  V_num4 int;
  V_num4_1 int;
begin
  dbe_output.print_line('FUNC_NEST_TRANSFER_004 begin');
  V_num4:=V_ID4+1;
  select FUNC_NEST_TRANSFER_005(V_num4) into V_num4_1 from dual;
  dbe_output.print_line('FUNC_NEST_TRANSFER_004 end');
  return(V_num4_1);
end FUNC_NEST_TRANSFER_004;
/

create or replace function FUNC_NEST_TRANSFER_003(V_ID3 INT) return int is
  V_num3 int;
  V_num3_1 int;
begin
  dbe_output.print_line('FUNC_NEST_TRANSFER_003 begin');
  V_num3:=V_ID3+1;
  select FUNC_NEST_TRANSFER_004(V_num3) into V_num3_1 from dual;
  dbe_output.print_line('FUNC_NEST_TRANSFER_003 end');
  return(V_num3_1);
end FUNC_NEST_TRANSFER_003;
/

select FUNC_NEST_TRANSFER_003(3) from dual;

drop function if exists FUNC_NEST_TRANSFER_003;
drop function if exists FUNC_NEST_TRANSFER_004;
drop function if exists FUNC_NEST_TRANSFER_005;

--statement level consistency test--
drop table if exists dbe_test_t1;
create table dbe_test_t1(f1 int);
insert into dbe_test_t1 (f1) values(1);
insert into dbe_test_t1 (f1) values(2);
commit;

CREATE OR REPLACE PROCEDURE dbe_test_proc AS
  rc1 sys_refcursor;
BEGIN
  update dbe_test_t1 set f1 = -1 where f1 = 1;
  delete from dbe_test_t1 where f1 = 2;
  OPEN rc1 FOR SELECT * FROM dbe_test_t1;
  dbe_sql.return_cursor(rc1);
  commit;
END;
/

exec dbe_test_proc();

drop procedure dbe_test_proc;
drop table dbe_test_t1;

conn sys/Huawei@123@127.0.0.1:1611
SELECT NAME, LENGTH(SOURCE) FROM SYS_PROCS WHERE NAME='SP_RANCC_MBTSCOMPMU_C3';
drop user if exists plsql_dts_nebula cascade;
drop user gs_plsql_dts cascade;

--test char expr length
drop table if exists test_char_006;
create table test_char_006 (name char(8000));

--expect success
DECLARE
  V_C varchar2(8000);
BEGIN
  FOR I IN 1 .. 800 LOOP
    V_C := V_C || 'xxxxxxxxxx';
  END LOOP;
  EXECUTE IMMEDIATE 'insert into test_char_006 values('''|| V_C ||''')';
END;
/
--end

conn sys/Huawei@123@127.0.0.1:1611
create user gs_plsql_dts_trigger_0107 identified by Lh00420062;
grant dba to gs_plsql_dts_trigger_0107;
conn gs_plsql_dts_trigger_0107/Lh00420062@127.0.0.1:1611
drop table if exists tab_1;
drop table if exists tab_2;

create table tab_1
(
c_int int,
c_number number,
c_varchar varchar(4000)
);
insert into tab_1 values
(1,1.25,'abcd');

create table tab_2
(
c_int int,
c_number number,
c_varchar varchar(4000)
);

insert into tab_2 values
(1,1.12345,'aaa');

create or replace trigger trigger_1
before insert on tab_2
declare
begin
  update tab_1 set c_number= 2019;
  dbe_output.print_line('here execute 1');
  update tab_2 set c_varchar= '454654';
  dbe_output.print_line('here execute 2');
end;
/

CREATE OR REPLACE PROCEDURE proc_1
IS
a int :=1;
BEGIN
  insert into tab_2 values(11,1.12345,'aaa');
END;
/

CREATE OR REPLACE PROCEDURE  proc_4
IS
b_temp int :=1;
sql1 varchar(600);
BEGIN
 for i in 1..2
  loop
    proc_1();
    sql1 :='analyze table tab_1 COMPUTE STATISTICS';
    execute immediate sql1;
 end loop;
END;
/

call proc_4();



--begin
drop table if exists test_rrs;
create table test_rrs(a int, b int);

--expect success
declare
   v_refcur1 SYS_REFCURSOR;
   a   int := 1;
begin
open v_refcur1 for   select a, count(*) from test_rrs group by a;
dbe_sql.return_cursor(v_refcur1);
end;
/
--expect success
declare
   type xxx is record(a int);
   v1 xxx;
   v_refcur1 SYS_REFCURSOR;
begin
v1.a := 1;
open v_refcur1 for   select v1.a, count(*) from test_rrs group by v1.a;
dbe_sql.return_cursor(v_refcur1);
end;
/
--end

create table whlp_t1(a int);
insert into whlp_t1 values(1);
insert into whlp_t1 values(2);
insert into whlp_t1 values(3);
commit;
set serveroutput on;

declare
cursor c1 is select * from whlp_t1;
begin
        open  c1;
        dbe_output.print_line('rowcount= '||c1%rowcount);
        close c1;
end;
/

declare
a whlp_t1%rowtype;
begin
   for item in (select * from whlp_t1)
   loop
       dbe_output.print_line('SQL%rowcount is '||sql%rowcount);
   end loop;
end;
/

conn sys/Huawei@123@127.0.0.1:1611
drop user if exists gs_plsql_dts_trigger_0107 cascade;

--test return value memory
--begin
create or replace function quotedStr (
    v_inStr in varchar2  )
return varchar2
is
    v_transferredStr varchar2(2246) ;
begin
    v_transferredStr := replace(v_inStr, '''', '''''');
    return  ltrim('''') || v_transferredStr || '''';
end;
/

alter system set COVERAGE_ENABLE = TRUE;
select quotedStr('829a057a-ab29-439e-bc68-ac85395cdaff');

alter system set COVERAGE_ENABLE = FALSE;
select quotedStr('829a057a-ab29-439e-bc68-ac85395cdaff');

drop function if exists quotedStr;
--end

--test case :recursive call(2)
create or replace procedure recursive_self_p(a int)
as
c int := 1;
d int := 2;
begin
	dbe_output.print_line(a);
	c := a-1;
	if c > 0 then
  recursive_self_p(c);
  end if;
end;
/

exec recursive_self_p(6);
--end

--DTS2019062013489
drop table if exists t_groupoperationlog;
create table t_groupoperationlog
(
logid NUMBER(20) not null,
logtime DATE not null,
operationtype NUMBER(2) not null,
phonenumber VARCHAR2(24) not null,
groupid NUMBER(20),
externalCallGrpID VARCHAR2(40),
membernumber VARCHAR2(24),
transactionid varchar2(30)
);
create or replace function f_log_di_groupoperationlog
( i_operationtype in t_groupoperationlog.operationtype%type,
i_phonenumber in t_groupoperationlog.phonenumber%type,
i_groupid in t_groupoperationlog.groupid%type,
i_externalcallgrpid in t_groupoperationlog.externalcallgrpid%type,
i_membernumber in t_groupoperationlog.membernumber%type,
str_transactionid in varchar2,
i_result out integer
)
return integer as
begin
null;
end;
/
drop table t_groupoperationlog;

drop table if exists JOBMATCH_MAIN;
create table JOBMATCH_MAIN(DUTY_POSITION int, PERFORMANCE int);

CREATE OR REPLACE FUNCTION hbh_01(BATCH_ID IN VARCHAR2,
M_ID IN VARCHAR2,
MATCH_RESULT IN VARCHAR2) RETURN VARCHAR IS
RESULT VARCHAR2(2000);
P_PERFORMANCE JOBMATCH_MAIN.PERFORMANCE%TYPE;
P_DUTY_POSITION JOBMATCH_MAIN.DUTY_POSITION%TYPE;

BEGIN
RETURN(rtrim(RESULT, '$'));
END ;
/

drop table JOBMATCH_MAIN;
--end

--DTS2019110701401
drop table if exists TEST_1401;
CREATE TABLE TEST_1401(
  T12 CHAR(400),
  T13 CHAR(100),
  T22 CHAR(10)
);
INSERT INTO TEST_1401 VALUES('1','abade','true');
INSERT INTO TEST_1401 VALUES('dbce','prode','true');
commit;
CREATE OR REPLACE PROCEDURE PROC_IN_OUT_PARAM_001(
P1 IN CHAR,
P2 OUT VARCHAR
)
AS
BEGIN
SELECT T13 INTO P2 FROM TEST_1401 WHERE T12=P1;
dbe_output.print_line(P2);
EXCEPTION
WHEN NO_DATA_FOUND THEN dbe_output.print_line('NO_DATA_FOUND');
END;
/
DECLARE
V_P2 CHAR(100);
BEGIN
PROC_IN_OUT_PARAM_001('dbce',V_P2);
dbe_output.print_line(V_P2);
END;
/
CREATE OR REPLACE PROCEDURE PROC_IN_OUT_PARAM_002(
P1 IN CHAR,
P2 OUT VARCHAR
)
AS
BEGIN
SELECT T13 INTO P2 FROM TEST_1401 WHERE T12=P1;
dbe_output.print_line(P2);
EXCEPTION
WHEN NO_DATA_FOUND THEN dbe_output.print_line('NO_DATA_FOUND');
END;
/
DECLARE
V_P2 CHAR(100);
BEGIN
PROC_IN_OUT_PARAM_002(1,V_P2);
dbe_output.print_line(V_P2);
END;
/
drop table TEST_1401;
drop PROCEDURE PROC_IN_OUT_PARAM_001;
drop PROCEDURE PROC_IN_OUT_PARAM_002;
--end

--DTS2019110614000
drop table if exists emp;
create table emp(empno int,ename varchar(10),job varchar(10) ,sal integer);
insert into emp values(1,'zhangsan','doctor1',10000),(2,'zhangsan2','doctor2',10000),(123,'zhangsan3','doctor3',10000);
create or  replace procedure procedure3(a int) is
cursor mycursor is select * from emp where empno != 123 and sal=10000;
b emp%rowtype;
mysyscur  sys_refcursor;
strSQL1 varchar(1000);
strSQL2 varchar(1000);
begin
strSQL1 := 'select * from emp  where  sal <> 10000';
strSQL2 := '';
 if a <= 10 then
   for i in mycursor
   loop
    dbe_output.print_line(i.ename||' is not 10000');
   end loop;
 elsif a >10 and a <100 then
  open mysyscur for  strSQL1;
  fetch mysyscur into  b;
  dbe_output.print_line(b.ename||' a > 10 and a < 100');
  close mysyscur;
 else
  open mysyscur for strSQL2;
  dbe_output.print_line('else a > 10 and a < 100');
 end if;
end;
/
call procedure3 ('abc');
drop procedure procedure3;

DECLARE
  type test_type_limit is varray(20) of int;
	var_C test_type_limit := test_type_limit(123, 234, 345);
BEGIN
	dbe_output.print_line(var_C(4));
END;
/

CREATE OR REPLACE PROCEDURE PRO1(C_BOOL BOOL, C_DATETIME DATETIME) IS A_CHAR VARCHAR(40);
 C_TIME DATE;
 E_BOOL BOOL;
 BEGIN
 C_TIME := UNIX_TIMESTAMP(C_DATETIME) ;
  E_BOOL := NOT C_BOOL;
 END PRO1;
/
BEGIN
    PRO1('1',CAST(CAST('2007-09-23' AS DATETIME) AS DATETIME));
END;
/
DROP PROCEDURE PRO1;

--DTS2019111300893
create or replace type v_type_t_17 force is object(id int,name varchar(3))not final;
/
create or replace type  v_type_t_017 under v_type_t_17(a number,b int) final;
/
drop table if exists AW_T_1;
create table AW_T_1(id int,name varchar(3),a number,b int);
insert into AW_T_1 values (4,'fd',4,8);
create or replace procedure proc_t_1 is
sec_del v_type_t_017:=v_type_t_017(null,null,null,null);
begin
select * into sec_del.id,sec_del.name,sec_del.a,sec_del.b from AW_T_1;
dbe_output.print_line(sec_del.id||' '||sec_del.name||' '||sec_del.a||' '||sec_del.b);
end;
/
call proc_t_1();
drop procedure proc_t_1;
drop table AW_T_1;
drop type v_type_t_017;
drop type v_type_t_17;

--DTS2019111300691
create or replace type my_type1 is object (id number, name varchar2(32));
 /
create or replace type my_type2 is table of my_type1;
 /
create or replace type varray09 force is varray(4) of varchar(100);
/
CREATE OR REPLACE TYPE varray9 force is varray(4) of varchar(100);
/
create table test_pack_table(id number, name varchar2(32));

insert into test_pack_table values(1,'happy');
insert into test_pack_table values(2,'like');
insert into test_pack_table values(3,'love');

CREATE OR REPLACE PACKAGE pack_coll_09
IS
FUNCTION pack_funcl_09(xxx my_type2) return my_type2;
procedure pack_procl_09(ap varray09,bp out varray9);
END pack_coll_09;
/
CREATE OR REPLACE PACKAGE body pack_coll_09
IS
FUNCTION pack_funcl_09(xxx my_type2) return my_type2 is
tab9 my_type2;
n int;
begin
tab9 :=my_type2();
n:=0;
for r in (select id,name from test_pack_table)
     loop
        tab9.extend;
        n := n + 1;
       tab9(n) := my_type1(r.id, r.name);
     end loop;
return tab9;
end;
procedure pack_procl_09 (ap varray09,bp out varray9) is
c int;
begin
c :=1;
end;
END pack_coll_09;
/

drop table test_pack_table;
drop type my_type1 force;
drop type my_type2 force;
drop type varray09 force;
drop type varray9 force;
drop PACKAGE pack_coll_09;

--DTS2020030546475
Declare
t int;
BEGIN
t:=0;
FOR i IN ((t))..3 LOOP
DBE_OUTPUT.PRINT_LINE('here:' || i);
END LOOP;
END;
/

Declare
t int;
BEGIN
t:=0;
FOR i IN (t + 1)..3 LOOP
DBE_OUTPUT.PRINT_LINE('here:' || i);
END LOOP;
END;
/

Declare
a int;
b int;
c int;
begin
a:=14;
b:=7;
c:=a
/ b;
DBE_OUTPUT.PRINT_LINE(c);
end;
/

Declare
a int;
b int;
c int;
begin
a:=14;
b:=7;
c:=a/
b;
DBE_OUTPUT.PRINT_LINE(c);
end;
/

--DTS2020033007668 end judgement
drop function if exists F1;
CREATE OR REPLACE FUNCTION F1 RETURN char IS
A char(100) ;
B NUMERIC(6,4);
BEGIN
B := 20.2345;
SELECT B INTO A FROM dual;
RETURN A;
ENDT; 
  /

CREATE OR REPLACE FUNCTION F1 RETURN char AS
A char(100) ;
B NUMERIC(6,4);
BEGIN
B := 20.2345;
SELECT B INTO A FROM dual;
RETURN A;
END;
//
fafd
fsdf
/

CREATE OR REPLACE FUNCTION F1 RETURN char AS
A char(100) ;
B NUMERIC(6,4);
BEGIN
B := 20.2345;
SELECT B INTO A FROM dual;
RETURN A;
END;
///
fafd
fsdf
/
drop function if exists F1;

declare
var int;
begin
var := 
/*fd
saf*/1;
end;
/

set serveroutput on;
declare
var int;
a int := 2;
begin
var := a; /*ss*/
DBE_OUTPUT.PRINT_LINE(var);
end;
///
/

begin
DBE_OUTPUT.PRINT_LINE('ok');
end;
/;
/

begin
DBE_OUTPUT.PRINT_LINE('ok');
end;
;/
/

begin
DBE_OUTPUT.PRINT_LINE('ok');
end;
/*ss
*/
/

begin
DBE_OUTPUT.PRINT_LINE('ok');
end;
/*ss
*//
/

create or replace type type_end is table of int;/
/
drop type if exists type_end;

begin
null;
end;
/--aa
/

begin
null;
end;
/*ss*/ /
  /

begin
null;
end;
	/

begin
null;
end;
/*

*/
/


set serveroutput off;
