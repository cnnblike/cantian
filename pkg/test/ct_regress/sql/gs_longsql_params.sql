spool ./results/gs_longsql_params.out
alter system set _LOG_LEVEL=256;
alter system set LONGSQL_TIMEOUT=1;

select sleep(3) from dual;
select sleep(?),?,?,?,?,?,?,?,? from dual;
in
int
2
in
real
100.000010E-2
in
decimal
100.000010E-2
in
number
1000.001E-3
in
string
abcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcdeabcde
in
bool
1
in
bigint
222
in
timestamp
2000-01-01 13:12:16.2323
in
date
2012-12-13 15:16:17


alter system set _LOG_LEVEL=7;
alter system set LONGSQL_TIMEOUT=10;

spool off
