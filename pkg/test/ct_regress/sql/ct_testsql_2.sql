set term off

select * from dual
where dual.x > 1;
select * from dual;
select * from duall;

drop function if exists f_tab_qr_getrownum1111; 
create or replace funcTioN f_tab_qr_getrownum1111
(
    str_in_schema       in            varchar2,
    str_in_tablename    in            varchar2,
    str_in_version      in            varchar2,
    i_o_rownum          out           integer
)
return integer
as
begin    
    if (str_in_version = '0') then--default
        i_o_rownum := null;    
    elsif (str_in_version = '1') then--music
        begin
            execute immediate 'select num_rows from ' || str_in_schema || '.t_tablestat where table_name = :1' into i_o_rownum using str_in_tablename;
        exception
            when no_data_found then
                i_o_rownum := null;
        end;    
    elsif (str_in_version in ('2', '4')) then--telecom usdp
        begin
            execute immediate 'select num_rows from ' || str_in_schema || '.usdp$table_stats where table_name = :1' into i_o_rownum using str_in_tablename;
        exception
            when no_data_found then
                i_o_rownum := null;
        end;
    end if;
    return 1;
exception
    when others then
        p_in_procexceptionlog('');
        return 0;
end f_tab_qr_getrownum1111;
/
--create a function, which is used to output SQL result to defined file
drop function if exists f_exportdata_ronghe_201209; 
create or replace procedure f_exportdata_ronghe_201209
(
    str_in_sql                in            varchar2,
    str_in_filename           in            varchar2,
    str_o_error               out           varchar2,
    i_o_result                out           integer
)
as
    cur_l_result      pkg_type.refcur;
    str_l_record      varchar2(4000);
    v_file_handle     utl_file.file_type;
begin
    v_file_handle := utl_file.fopen('EXPORT_DATA_PATH', str_in_filename, 'w');

    i_o_result := 1;

    open cur_l_result for str_in_sql;

    loop
        fetch cur_l_result into str_l_record;

        exit when cur_l_result%notfound;

        utl_file.put_line(v_file_handle, str_l_record);

    end loop;

    close cur_l_result;
    utl_file.fclose(v_file_handle);
    return;
    
exception
    when others then      
        str_o_error := substr(SQL_ERR_MSG,1,2000);
        i_o_result := 0;    
        return; 
end f_exportdata_ronghe_201209;
/