--test dead lock
set serveroutput on;
conn sys/Huawei@123@127.0.0.1:1611
drop user if exists gs_parallel_trigger2 cascade;
create user gs_parallel_trigger2 identified by Lh00420062;
grant all privileges to gs_parallel_trigger2;
conn gs_parallel_trigger2/Lh00420062@127.0.0.1:1611

SELECT GET_LOCK('t_parallel_trig_1');
create table if not exists t_parallel_trig_1(f1 int);
SELECT RELEASE_LOCK('t_parallel_trig_1');

declare
i int := 0;
sql1 varchar(512);
sql2 varchar(512);
begin
	sql1 := 'CREATE OR REPLACE TRIGGER trig_parallel BEFORE DELETE ON t_parallel_trig_1 BEGIN NULL;END;';
	sql2 := 'DROP TRIGGER trig_parallel';
	while i < 5000 LOOP
		execute immediate sql1;
		execute immediate sql2;
		i := i + 1;
	end loop;
end;
/


drop table if exists FVT_PROC_ADDITIONAL_table_A2;
drop table if exists FVT_PROC_ADDITIONAL_table_B2;
drop table if exists FVT_PROC_ADDITIONAL_table_C2;
create table FVT_PROC_ADDITIONAL_table_A2 
(
c_int int not null,
c_number number,
c_varchar varchar(80),
c_date date
);
insert into FVT_PROC_ADDITIONAL_table_A2 values(1,1.111,'view structure',to_date('2019-01-01','yyyy-mm-dd'));	
insert into FVT_PROC_ADDITIONAL_table_A2 values(2,2.222,'123456',to_date('2019-02-02','yyyy-mm-dd'));	
insert into FVT_PROC_ADDITIONAL_table_A2 values(3,3.333,'AAAAA',to_date('2019-03-03','yyyy-mm-dd'));		

create table FVT_PROC_ADDITIONAL_table_B2 as select * from FVT_PROC_ADDITIONAL_table_A2;
delete FVT_PROC_ADDITIONAL_table_B2 where c_int<=2;
insert into FVT_PROC_ADDITIONAL_table_B2 values(4,6.666,'physical',to_date('2019-04-04','yyyy-mm-dd'));	
insert into FVT_PROC_ADDITIONAL_table_B2 values(2,10.0,'peking university',to_date('2019-05-30','yyyy-mm-dd'));	

CREATE TABLE FVT_PROC_ADDITIONAL_table_C2(staff_id INT NOT NULL, higest_degree CHAR(8), graduate_school VARCHAR(64), graduate_date DATETIME, education_note VARCHAR(70))
partition BY LIST(higest_degree)
(
partition doctor values ('doctor'),
partition master values ('master'),
partition undergraduate values ('bachelor')
);
insert into FVT_PROC_ADDITIONAL_table_C2(staff_id,higest_degree,graduate_school,graduate_date,education_note) values(1,'doctor','XIDIAN UNIVERSITY','2017-07-06 12:00:00','211');
insert into FVT_PROC_ADDITIONAL_table_C2(staff_id,higest_degree,graduate_school,graduate_date,education_note) values(2,'master','Northwestern Polytechnical University','2017-07-06 12:00:00','211_985');
insert into FVT_PROC_ADDITIONAL_table_C2(staff_id,higest_degree,graduate_school,graduate_date,education_note) values(3,'bachelor','Beijing Normal University','2017-07-06 12:00:00','211_985');

COMMIT;

create or replace function FVT_PROC_ADDITIONAL_TRIG_FUN(i varchar) RETURN INT
AS
	a varchar(80);
	d int;
begin
 a:=i;
 select staff_id into d from FVT_PROC_ADDITIONAL_table_C2 where graduate_school =a;
 return d;
end FVT_PROC_ADDITIONAL_TRIG_FUN;
/


create or replace trigger FVT_PROC_ADDITIONAL_trigger_1 before insert or delete on FVT_PROC_ADDITIONAL_table_A2
begin
    declare
    c1 sys_refcursor;
    c_rows FVT_PROC_ADDITIONAL_table_B2%rowtype;
    d_rows FVT_PROC_ADDITIONAL_table_B2%rowtype;
    type tcur is ref cursor;
    c2 tcur;
    i int:=0;
    graduate_id int;
    begin
            open c1 for select * from FVT_PROC_ADDITIONAL_table_B2;
            fetch c1 into c_rows,d_rows;
    exception
    
    when ROWTYPE_MISMATCH then
        begin
            execute immediate 'create or replace trigger FVT_PROC_ADDITIONAL_trigger_2 before insert or delete on FVT_PROC_ADDITIONAL_table_A2
                begin
				declare
				c2 sys_refcursor;
				graduate_id int;
				begin
                    open c2 for select graduate_school from FVT_PROC_ADDITIONAL_table_C2 where staff_id=3;
                    fetch c2 into graduate_id;
                    exception
                    when ROWTYPE_MISMATCH then
                        begin
                            sys.dbe_output.print_line(''jump to exception''||''ROWTYPE_MISMATCH'');
                            sys.dbe_output.print_line(''expeption code''||SQL_ERR_CODE||'',''||''error''||''exception message:''||SQL_ERR_MSG);
                        end;
				end;
                end';
        end;
        sys.dbe_output.print_line('jump to exception'||'ROWTYPE_MISMATCH');
        sys.dbe_output.print_line('exception code:'||SQL_ERR_CODE||','||'error'||'exception message:'||SQL_ERR_MSG);
        
    when others then sys.dbe_output.print_line('other error');
                    sys.dbe_output.print_line(SQL_ERR_CODE||'error'||SQL_ERR_MSG);
                    dbe_output.print_line(c_rows.c_varchar);

    end;
end;
/

create or replace procedure FVT_PROC_ADDITIONAL_procedure_p2_2(a number)
is
b number:=a;
begin
	insert into FVT_PROC_ADDITIONAL_table_A2 values(FVT_PROC_ADDITIONAL_TRIG_FUN('XIDIAN UNIVERSITY'),b,'++++$%#@',to_date('2019-12-31','yyyy-mm-dd'));
	delete FVT_PROC_ADDITIONAL_table_A2 where c_int =1;
end;
/
call FVT_PROC_ADDITIONAL_procedure_p2_2(8.88);


conn sys/Huawei@123@127.0.0.1:1611
drop user if exists gs_parallel_trigger2 cascade;
set serveroutput off;