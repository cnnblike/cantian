select * from nls_session_parameters;

select to_char(to_date('2018-06-28 13:14:15', 'YYYY-MM-DD HH24:MI:SS')) from dual;
alter session set nls_date_format = 'YYYY/MM/DD HH24/MI/SS';
select to_char(to_date('2018-06-28 13:14:15', 'YYYY-MM-DD HH24:MI:SS')) from dual;
select to_char(to_date('2018/06/28 13/14/15')) from dual;

select to_char(to_timestamp('2018-06-28 13:14:15.66666', 'YYYY-MM-DD HH24:MI:SS.FF5')) from dual;
alter session set nls_timestamp_format = 'YYYY-MM/DD HH24-MI-SS.FF5';
select to_char(to_timestamp('2018-06-28 13:14:15.66666', 'YYYY-MM-DD HH24:MI:SS.FF5')) from dual;
select to_char(to_timestamp('2018-06/28 13-14-15.6666')) from dual;
select to_char(to_timestamp('2018-06/28 13-14-15.66666')) from dual;

select * from nls_session_parameters;

alter session set nls_timestamp_format = '                           "213123"YYYY-MM/DD HH24-MI-SS.FF6';
select to_char(to_timestamp('2018-06-28 13:14:15.66666', 'YYYY-MM-DD HH24:MI:SS.FF5')) from dual;
alter session set nls_timestamp_format = '"213asdfsddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd123"YYYY-MM/DD HH24-MI-SS.FF6';
select to_char(to_timestamp('2018-06-28 13:14:15.66666', 'YYYY-MM-DD HH24:MI:SS.FF5')) from dual;
alter session set nls_date_format = 'YYYY-MM-DD HH:MI:SS SS';
alter session set nls_date_format = 'YYYY-MM-DD HH:MI:SS qq';
alter session set nls_date_format = 'YYYY-MM-DD HH:MI:SS asx';
alter session set nls_date_format = 'YYYY-MM-DD HH:MI:SS.FF';

alter session set nls_timestamp_format = 'YYYY-MM-DD HH:MI:SS.FFFF3';
alter session set nls_timestamp_format = 'YYYY-MM-DD HH:MI:SS.FF Q';
alter session set nls_timestamp_format = 'YYYY-MM-DD HH:MI:SS.FF asx';
alter session set nls_timestamp_format = 'YYYY-MM-DD HH:MI:SS.FF';

alter session set nls_date_format = 'YYYY-MM-DD HH:MI:SS"abcdefg"';
select to_char(to_date('2018-06-28 13:14:15', 'YYYY-MM-DD HH24:MI:SS')) from dual;
select to_date('2018-06-28 13:14:15', 'YYYY-MM-DD HH24:MI:SS') from dual;

alter session set nls_date_format = '"This is a text in date format! ^_^"';
select sysdate from dual;
select to_char(sysdate) from dual;
