drop table if exists std_temp_t1;
create global temporary table std_temp_t1(field_name varchar(4000), avg_value float, count_value int)
on commit delete rows;

drop table if exists std_temp_t2;
create global temporary table std_temp_t2(field_name varchar(4000), sum_value float)
on commit delete rows;

create or replace procedure std(std_expr in varchar, table_name in varchar, where_cond in varchar, group_field_name in varchar, std_ref out sys_refcursor)
as 
    sql         varchar(4000);
    p_avg       float;
    p_sum       float;
    p_count     int;

Begin

    if group_field_name is null then
        
        sql := 'select avg(' || std_expr || '),count(*) from ' || table_name;
        if where_cond is not null then
            sql := sql || ' where ' || where_cond;
        end if;
        execute immediate sql into p_avg, p_count;
    
        if p_count = 0 then
            open std_ref for select null from dual;
            return;
        end if;
        
        sql := 'select sum(power(' || std_expr || ' - ' || p_avg || ',2)) from ' || table_name;
        if where_cond is not null then
            sql := sql || ' where ' || where_cond;
        end if;
        execute immediate sql into p_sum;
        
        sql := 'select sqrt(' || p_sum || '/' || p_count || ') as std from dual';
        open std_ref for sql;
        
    else
    
        delete from std_temp_t1;
        delete from std_temp_t2;
        
        sql := 'insert into std_temp_t1(field_name, avg_value, count_value) select ' || group_field_name || ',avg(' || std_expr || '),count(*) from ' || table_name;
        if where_cond is not null then
            sql := sql || ' where ' || where_cond;
        end if;
        sql := sql || ' group by ' || group_field_name;
        execute immediate sql;
        
        sql := 'insert into std_temp_t2(field_name, sum_value) select ' || group_field_name || ',sum(power(a.' || std_expr || ' - b.avg_value, 2)) from ' || table_name || ' a ' ||
               'join std_temp_t1 b on a.' || group_field_name || '=b.field_name';
        if where_cond is not null then
            sql := sql || ' where ' || where_cond;
        end if;
        sql := sql || ' group by a.' || group_field_name;
        execute immediate sql;
        
        sql := 'select a.field_name as ' || group_field_name || ', sqrt(b.sum_value / a.count_value) as std from std_temp_t1 a join std_temp_t2 b on a.field_name=b.field_name order by '|| group_field_name ;
        open std_ref for sql;

    end if;

end;
/



create or replace procedure stdev(std_expr in varchar, table_name in varchar, where_cond in varchar, group_field_name in varchar, std_ref out sys_refcursor)
as 
    sql         varchar(4000);
    p_avg       float;
    p_sum       float;
    p_count     int;

Begin

    if group_field_name is null then
        
        sql := 'select avg(' || std_expr || '),count(*) from ' || table_name;
        if where_cond is not null then
            sql := sql || ' where ' || where_cond;
        end if;
        execute immediate sql into p_avg, p_count;
    
        if p_count < 2 then
            open std_ref for select null from dual;
            return;
        end if;
        
        sql := 'select sum(power(' || std_expr || ' - ' || p_avg || ',2)) from ' || table_name;
        if where_cond is not null then
            sql := sql || ' where ' || where_cond;
        end if;
        execute immediate sql into p_sum;
        
        sql := 'select sqrt(' || p_sum || '/(' || p_count || '-1)) as std from dual';
        open std_ref for sql;
        
    else
    
        delete from std_temp_t1;
        delete from std_temp_t2;
        
        sql := 'insert into std_temp_t1(field_name, avg_value, count_value) select ' || group_field_name || ',avg(' || std_expr || '),count(*) from ' || table_name;
        if where_cond is not null then
            sql := sql || ' where ' || where_cond;
        end if;
        sql := sql || ' group by ' || group_field_name;
        execute immediate sql;
        
        select count(*) into p_count from std_temp_t1;
        if p_count = 1 then
            sql := 'select field_name as ' || group_field_name || ', null as std from std_temp_t1';
            open std_ref for sql;
            return;
        end if;
        
        sql := 'insert into std_temp_t2(field_name, sum_value) select ' || group_field_name || ',sum(power(a.' || std_expr || ' - b.avg_value, 2)) from ' || table_name || ' a ' ||
               'join std_temp_t1 b on a.' || group_field_name || '=b.field_name';
        if where_cond is not null then
            sql := sql || ' where ' || where_cond;
        end if;
        sql := sql || ' group by a.' || group_field_name;
        execute immediate sql;
        
        sql := 'select a.field_name as ' || group_field_name || ', sqrt(b.sum_value / (a.count_value-1)) as std from std_temp_t1 a join std_temp_t2 b on a.field_name=b.field_name order by '|| group_field_name;
        open std_ref for sql;

    end if;

end;
/


drop table if exists std_test1;
create table std_test1(aa int, bb int);
insert into std_test1 values(1,5),(1,6),(1,9),(1,10),(1,5),(2,5),(2,4),(2,9);
commit;

drop table if exists std_test2;
create table std_test2(aa int, bb int);
insert into std_test2 values(5,5);
commit;

drop table if exists std_test3;
create table std_test3(aa int, bb int);



set serveroutput on;

drop table if exists my_std_t;
create table my_std_t(aa varchar(100), std float);
drop table if exists my_std_t2;
create table my_std_t2(std float);


declare
    std_ref    sys_refcursor;
    my_std     my_std_t%ROWTYPE;
begin
    std('bb','std_test1','aa>0', 'aa', std_ref);
    loop
        fetch std_ref into my_std;
        exit when std_ref%NOTFOUND;
        dbe_output.print_line('value= ' || my_std.aa || ' , ' || my_std.std);
    end loop;
    close std_ref;
end;
/


declare
    std_ref    sys_refcursor;
    my_std     my_std_t%ROWTYPE;
begin
    std('bb','std_test1',null, 'aa', std_ref);
    loop
        fetch std_ref into my_std;
        exit when std_ref%NOTFOUND;
        dbe_output.print_line('value= ' || my_std.aa || ' , ' || my_std.std);
    end loop;
    close std_ref;
end;
/


declare
    std_ref    sys_refcursor;
    my_std     my_std_t2%ROWTYPE;
begin
    std('bb','std_test1','aa>0', null, std_ref);
    loop
        fetch std_ref into my_std;
        exit when std_ref%NOTFOUND;
        dbe_output.print_line('value= ' ||  my_std.std);
    end loop;
    close std_ref;
end;
/


declare
    std_ref    sys_refcursor;
    my_std     my_std_t2%ROWTYPE;
begin
    std('bb','std_test1',null, null, std_ref);
    loop
        fetch std_ref into my_std;
        exit when std_ref%NOTFOUND;
        dbe_output.print_line('value= ' ||  my_std.std);
    end loop;
    close std_ref;
end;
/

declare
    std_ref    sys_refcursor;
    my_std     my_std_t%ROWTYPE;
begin
    std('bb','std_test2',null, 'aa', std_ref);
    loop
        fetch std_ref into my_std;
        exit when std_ref%NOTFOUND;
        dbe_output.print_line('value= ' || my_std.aa || ' , ' || my_std.std);
    end loop;
    close std_ref;
end;
/


declare
    std_ref    sys_refcursor;
    my_std     my_std_t2%ROWTYPE;
begin
    std('bb','std_test2',null, null, std_ref);
    loop
        fetch std_ref into my_std;
        exit when std_ref%NOTFOUND;
        dbe_output.print_line('value= ' || my_std.std);
    end loop;
    close std_ref;
end;
/


declare
    std_ref    sys_refcursor;
    my_std     my_std_t%ROWTYPE;
begin
    std('bb','std_test3',null, 'aa', std_ref);
    loop
        fetch std_ref into my_std;
        exit when std_ref%NOTFOUND;
        dbe_output.print_line('value= ' || my_std.aa || ' , ' || my_std.std);
    end loop;
    close std_ref;
end;
/


declare
    std_ref    sys_refcursor;
    my_std     my_std_t2%ROWTYPE;
begin
    std('bb','std_test3',null, null, std_ref);
    loop
        fetch std_ref into my_std;
        exit when std_ref%NOTFOUND;
        dbe_output.print_line('value= ' || my_std.std);
    end loop;
    close std_ref;
end;
/


declare
    std_ref    sys_refcursor;
    my_std     my_std_t%ROWTYPE;
begin
    stdev('bb','std_test1','aa>0', 'aa', std_ref);
    loop
        fetch std_ref into my_std;
        exit when std_ref%NOTFOUND;
        dbe_output.print_line('value= ' || my_std.aa || ' , ' || my_std.std);
    end loop;
    close std_ref;
end;
/


declare
    std_ref    sys_refcursor;
    my_std     my_std_t%ROWTYPE;
begin
    stdev('bb','std_test1',null, 'aa', std_ref);
    loop
        fetch std_ref into my_std;
        exit when std_ref%NOTFOUND;
        dbe_output.print_line('value= ' || my_std.aa || ' , ' || my_std.std);
    end loop;
    close std_ref;
end;
/


declare
    std_ref    sys_refcursor;
    my_std     my_std_t2%ROWTYPE;
begin
    stdev('bb','std_test1','aa>0', null, std_ref);
    loop
        fetch std_ref into my_std;
        exit when std_ref%NOTFOUND;
        dbe_output.print_line('value= ' ||  my_std.std);
    end loop;
    close std_ref;
end;
/


declare
    std_ref    sys_refcursor;
    my_std     my_std_t2%ROWTYPE;
begin
    stdev('bb','std_test1',null, null, std_ref);
    loop
        fetch std_ref into my_std;
        exit when std_ref%NOTFOUND;
        dbe_output.print_line('value= ' ||  my_std.std);
    end loop;
    close std_ref;
end;
/

declare
    std_ref    sys_refcursor;
    my_std     my_std_t%ROWTYPE;
begin
    stdev('bb','std_test2',null, 'aa', std_ref);
    loop
        fetch std_ref into my_std;
        exit when std_ref%NOTFOUND;
        dbe_output.print_line('value= ' || my_std.aa || ' , ' || my_std.std);
    end loop;
    close std_ref;
end;
/


declare
    std_ref    sys_refcursor;
    my_std     my_std_t2%ROWTYPE;
begin
    stdev('bb','std_test2',null, null, std_ref);
    loop
        fetch std_ref into my_std;
        exit when std_ref%NOTFOUND;
        dbe_output.print_line('value= ' || my_std.std);
    end loop;
    close std_ref;
end;
/

declare
    std_ref    sys_refcursor;
    my_std     my_std_t%ROWTYPE;
begin
    stdev('bb','std_test3',null, 'aa', std_ref);
    loop
        fetch std_ref into my_std;
        exit when std_ref%NOTFOUND;
        dbe_output.print_line('value= ' || my_std.aa || ' , ' || my_std.std);
    end loop;
    close std_ref;
end;
/


declare
    std_ref    sys_refcursor;
    my_std     my_std_t2%ROWTYPE;
begin
    stdev('bb','std_test3',null, null, std_ref);
    loop
        fetch std_ref into my_std;
        exit when std_ref%NOTFOUND;
        dbe_output.print_line('value= ' || my_std.std);
    end loop;
    close std_ref;
end;
/





drop table if exists T_APP;
create table T_APP(SCR_VA_TW varchar(100), SCR_VA_AA int, APP_NBR varchar(100), SCENE_COD varchar(10), CAS_EYDT_TIM varchar(38));
insert into T_APP values('scr1', 5, 'nbr1', 'B602D', '2018-08-30 00:00:00');
insert into T_APP values('scr1', 6, 'nbr2', 'AG19D', '2018-08-30 00:00:01');
insert into T_APP values('scr1', 7, 'nbr3', 'G122N', '2018-08-30 00:00:02');
insert into T_APP values('scr1', 9, 'nbr4', 'N022C', '2018-08-30 00:00:03');
insert into T_APP values('scr1', 5, 'nbr5', 'I032N', '2018-08-30 00:00:04');
insert into T_APP values('scr2', 5, 'nbr1', 'F042F', '2018-08-30 00:00:00');
insert into T_APP values('scr2', 6, 'nbr2', 'F042F', '2018-08-30 00:00:01');
insert into T_APP values('scr2', 7, 'nbr3', 'F042F', '2018-08-30 00:00:02');
commit;

declare
    std_ref    sys_refcursor;
    my_std     my_std_t%ROWTYPE;
begin
    stdev('SCR_VA_AA','T_APP','APP_NBR in (select APP_NBR from T_APP where SCENE_COD in (''B602D'',''AG19D'',''G122N'',''N022C'',''I032N'',''F042F'')) and CAS_EYDT_TIM between ''2018-08-30 00:00:00'' and  ''2018-08-30 00:15:00''', 'SCR_VA_TW', std_ref);
    loop
        fetch std_ref into my_std;
        exit when std_ref%NOTFOUND;
        dbe_output.print_line('value= ' || my_std.aa || ',' || my_std.std);
    end loop;
    close std_ref;
end;
/





