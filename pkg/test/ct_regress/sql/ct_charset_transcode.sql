-- column name, put_line need transcode : DTS2019080710708
alter database character set gbk;

select length('中国') from dual;

set serveroutput on
BEGIN
dbe_output.print_line('一二');
END;
/
set serveroutput off
alter database character set utf8;

-- charset transcode
set serveroutput on
declare 
	a int;
BEGIN
    dbe_output.print_line (a);
END;
/
set serveroutput off
exit
