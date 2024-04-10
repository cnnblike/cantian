drop table if exists wg_feedback_on;
create table wg_feedback_on(f1 int);
insert into wg_feedback_on values(1);
insert into wg_feedback_on values(2);
insert into wg_feedback_on values(3);
insert into wg_feedback_on values(4);
insert into wg_feedback_on values(5);
insert into wg_feedback_on values(6);
insert into wg_feedback_on values(7);
insert into wg_feedback_on values(8);
insert into wg_feedback_on values(9);
insert into wg_feedback_on values(10);

select * from wg_feedback_on;
set feedback 11
select * from wg_feedback_on;
set feedback on
select * from wg_feedback_on;
set feedback off
select * from wg_feedback_on;
set feedback 5
select * from wg_feedback_on;
set feedback 0
select * from wg_feedback_on;
set feedback -1
set feedback on
