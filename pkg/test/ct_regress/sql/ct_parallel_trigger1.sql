--test dead lock
SELECT GET_LOCK('t_parallel_trig_1');
create table if not exists t_parallel_trig_1(f1 int);
SELECT RELEASE_LOCK('t_parallel_trig_1');

declare
i int := 0;
begin
	while i < 1000000 LOOP
		delete from t_parallel_trig_1;
		i := i + 1;
	end loop;
end;
/

commit;
