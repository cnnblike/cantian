alter system set _LOG_LEVEL=256;
alter system set LONGSQL_TIMEOUT=0;
DROP TABLE IF EXISTS T_LONGSQL;
CREATE TABLE T_LONGSQL(ID int);
INSERT INTO T_LONGSQL(ID) VALUES(1);
SELECT ID FROM T_LONGSQL;
DELETE FROM T_LONGSQL WHERE ID = 1;
CREATE or replace procedure proc_longsql(start_no int,end_no int) as
i INT;
BEGIN
  if start_no <= end_no then
    FOR i IN start_no..end_no LOOP
      insert into T_LONGSQL(ID) select i from dual;
commit;
    END LOOP;
  end if;
END;
/
call proc_longsql(2,3);

insert into T_LONGSQL(ID) select 52013140 from dual where 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 5201314=5201314 and 12=12;

alter system set _LOG_LEVEL=7;
alter system set LONGSQL_TIMEOUT=10;
select stage,sql_text from v$longsql where sql_text like '%T_LONGSQL%';
DROP procedure proc_longsql;
DROP TABLE IF EXISTS T_LONGSQL2;
create table T_LONGSQL2 as select * from v$longsql;
DROP TABLE T_LONGSQL;
DROP TABLE T_LONGSQL2;


--check sql execute time when have more than one sql in one trigger
alter system set sql_stat = true;
DROP TABLE IF EXISTS T_STAT_TRIG_1;
DROP TABLE IF EXISTS T_STAT_TRIG_2;
DROP TABLE IF EXISTS T_STAT_TRIG_3;
CREATE TABLE T_STAT_TRIG_1 (F_INT1 INT);
CREATE TABLE T_STAT_TRIG_2 (F_INT1 INT);
CREATE TABLE T_STAT_TRIG_3 (F_INT1 INT);

CREATE OR REPLACE TRIGGER TRIG_STAT_TRIG_1 BEFORE INSERT   ON T_STAT_TRIG_1
BEGIN
  INSERT INTO T_STAT_TRIG_2 (F_INT1) select sleep(3) from dual;
  INSERT INTO T_STAT_TRIG_3 (F_INT1) select sleep(2) from dual;
END;
/

INSERT INTO T_STAT_TRIG_1 (F_INT1) select sleep(1) from dual;

commit;

--insert T_STAT_TRIG_1 execute time will include  TRIG_STAT_TRIG_1 execute time
select 1 from dual where ((select elapsed_time from v$sqlarea  where sql_text like 'INSERT%INTO%T_STAT_TRIG_1%' order by elapsed_time desc    limit 1) > ((select elapsed_time from v$sqlarea  where sql_text like '%INTO%T_STAT_TRIG_2%' order by elapsed_time desc    limit 1) + (select elapsed_time from v$sqlarea  where sql_text like 'insert%INTO%T_STAT_TRIG_3%' order by elapsed_time desc    limit 1)));

drop table T_STAT_TRIG_1;
drop table T_STAT_TRIG_2;
drop table T_STAT_TRIG_3;