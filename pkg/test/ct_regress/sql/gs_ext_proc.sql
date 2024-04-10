
set serveroutput on;

create or replace library test as '/home/regress/cantiandb/include/libfuncs.so';

select USER#, NAME, LEAF_FILENAME from SYS_LIBRARIES where NAME = 'TEST' AND USER# = 0;

drop function if exists test_bool;
create function test_bool() return bool as language c library test name "return_bool"
/
drop function if exists test_add_two_short;
create function test_add_two_short (x short, y ushort) return short as language c library test name "add_two_short"
/
drop function if exists test_sub_two_int;
create function test_sub_two_int (x integer, y uinteger) return integer as language c library test name "sub_two_int"
/
drop function if exists test_mul_two_bigint;
create function test_mul_two_bigint (x bigint, y bigint) return bigint as language c library test name "mul_two_bigint"
/
drop function if exists test_div_two_double;
create function test_div_two_double (x float, y double) return double as language c library test name "div_two_double"
/
drop function if exists test_copy_binary;
create  function test_copy_binary (x binary) return binary as language c library test name "copy_binary"
/
drop function if exists test_concat_binary;
create function test_concat_binary (x binary, y varbinary, z raw) return varbinary as language c library test name "concat_binary"
/
drop function if exists test_copy_text;
create function test_copy_text(x char, y out char) return char as language c library test name "copy_text"
/
drop procedure if exists test_concat_text;
create procedure test_concat_text(x varchar, y char, z out varchar) as language c library test name "concat_text"
/
drop procedure if exists test_in_out_param;
create procedure test_in_out_param(a in out integer, b in out float, c in out binary, d in out varchar) as language c library test name "in_out_param"
/
drop function if exists test_exception_core;
create function test_exception_core() return int as language c library test name "exception_core"
/

select test_bool();
select test_add_two_short(-2, 2);
select test_sub_two_int(-3, 300000000);
select test_mul_two_bigint(-4, 400000000);
select test_div_two_double(1.55555555, -2.4555555555);
select test_copy_binary('1010101111111111111111111111111111111111111111');
select test_concat_binary('1010', '1234'::binary(4), '4142');

select test_add_two_short('abcde', 2);
select test_add_two_short(-2, 2, 3);
select test_add_two_short(-2);
select test_copy_text('ccc', 'ddd');

declare
x int;
y varchar(100);
begin
Y := test_copy_text('ccc', x);
end;
/
create library test as '/home/regress/cantiandb/include/libfuncs.so';
drop user if exists c##test_A cascade;
create  user c##test_A identified by Cantian_234;
grant create session to c##test_A;
conn c##test_A/Cantian_234@127.0.0.1:1611
drop library test;
drop library sys.test;
conn / as sysdba
drop user if exists c##test_A cascade;
drop library test_lib123;

drop library test;
select USER#, NAME, LEAF_FILENAME from SYS_LIBRARIES where NAME = 'TEST' AND USER# = 0;
select test_bool();
select test_add_two_short(-2, 2);

create library test as '/home/regress/cantiandb/include/libfuncs.so';
select USER#, NAME, LEAF_FILENAME from SYS_LIBRARIES where NAME = 'TEST' AND USER# = 0;

declare
x varchar(100) := 'this is x';
y varchar(100) := ', y';
ret1 varchar(100);
ret2 varchar(100);
a int := 1;
b float := 0.899999999999;
c binary(100) := '1010101111111111111111111111111111111111111111';
d varchar(100):= '123';
begin
	ret1 := test_copy_text(x, ret2);
	dbe_output.print_line(ret1);
	dbe_output.print_line(ret2);
	test_concat_text(x, y, ret1);
	dbe_output.print_line(ret1);
	test_in_out_param(a, b, c, d);
	dbe_output.print_line(a);
	dbe_output.print_line(b);
	dbe_output.print_line(c);
	dbe_output.print_line(d);
end;
/
drop library test;

drop function test_bool;

drop function test_add_two_short;

drop function test_sub_two_int;

drop function test_mul_two_bigint;

drop function test_div_two_double;

drop function test_copy_binary;

drop function test_concat_binary;

drop function test_copy_text;

drop procedure test_concat_text;

drop procedure test_in_out_param;

drop function test_exception_core;

--privilege test
--1. create any library
conn / as sysdba
drop user if exists c##test_A cascade;
create  user c##test_A identified by Cantian_234;
drop user if exists c##test_B cascade;
create  user c##test_B identified by Cantian_234;
grant create session to c##test_A;
grant create library to c##test_A;
conn c##test_A/Cantian_234@127.0.0.1:1611
create or replace library c##test_B.tlib1 as '/home/regress/cantiandb/include/libfuncs.so'; --fail
conn / as sysdba
revoke create library from c##test_A;
grant create any library to c##test_A;
conn c##test_A/Cantian_234@127.0.0.1:1611
create or replace library c##test_B.tlib1 as '/home/regress/cantiandb/include/libfuncs.so';--success

--2. drop any library
drop library c##test_B.tlib1;--fail
conn / as sysdba
revoke create any library from c##test_A;
grant drop any library to c##test_A;
conn c##test_A/Cantian_234@127.0.0.1:1611
drop library c##test_B.tlib1;--success
conn / as sysdba
revoke drop any library from c##test_A;

--user A creates B.func, using C.lib
--3. execute object privilege
drop user if exists c##test_C cascade;
create  user c##test_C identified by Cantian_234;
grant create any procedure to c##test_A;
create or replace library c##test_C.lib1 as '/home/regress/cantiandb/include/libfuncs.so';
--3.1 user A and B don't have execute object privilege on C.lib, fail.
conn c##test_A/Cantian_234@127.0.0.1:1611
create or replace function c##test_B.test_add(x short, y ushort) return short as language c library c##test_C.lib1 name "add_two_short"
/
--3.2 only A has execute object privilege on C.lib, fail.
conn / as sysdba
grant execute on c##test_C.lib1 to c##test_A;
conn c##test_A/Cantian_234@127.0.0.1:1611
create or replace function c##test_B.test_add(x short, y ushort) return short as language c library c##test_C.lib1 name "add_two_short"
/
--3.3 only B has execute object privilege on C.lib, success.
conn / as sysdba
revoke execute on c##test_C.lib1 from c##test_A;
grant execute on c##test_C.lib1 to c##test_B;
conn c##test_A/Cantian_234@127.0.0.1:1611
create or replace function c##test_B.test_add(x short, y ushort) return short as language c library c##test_C.lib1 name "add_two_short"
/
--4. only B has execute any library system privilege, success.
conn / as sysdba
revoke execute on c##test_C.lib1 from c##test_B;
grant execute any library to c##test_B;
conn c##test_A/Cantian_234@127.0.0.1:1611
create or replace function c##test_B.test_add2(x short, y ushort) return short as language c library c##test_C.lib1 name "add_two_short"
/

--when B.func already exists which using C.lib, user A executes B.func.
--5. execute object privilege
conn / as sysdba
drop user c##test_A cascade;
create  user c##test_A identified by Cantian_234;
drop user c##test_B cascade;
create  user c##test_B identified by Cantian_234;
drop user c##test_C cascade;
create  user c##test_C identified by Cantian_234;
grant create session to c##test_A;
create or replace library c##test_C.lib1 as '/home/regress/cantiandb/include/libfuncs.so';
--5.1 only B has execute object privilege on C.lib, fail.
grant execute on c##test_C.lib1 to c##test_B;
create or replace function c##test_B.test_add(x short, y ushort) return short as language c library c##test_C.lib1 name "add_two_short"
/
conn c##test_A/Cantian_234@127.0.0.1:1611
select c##test_B.test_add(1, 5) from dual;
--5.2 only A has execute object privilege on B.func, fail.
conn / as sysdba
revoke execute on c##test_C.lib1 from c##test_B;
grant execute on c##test_B.test_add to c##test_A;
conn c##test_A/Cantian_234@127.0.0.1:1611
select c##test_B.test_add(1, 5) from dual;
--5.3 A has execute object privilege on B.func, and B has execute object privilege on C.lib, fail.
conn / as sysdba
grant execute on c##test_C.lib1 to c##test_B;
conn c##test_A/Cantian_234@127.0.0.1:1611
select c##test_B.test_add(1, 5) from dual;
--5.4 A has execute object privilege on B.func, and B has execute object privilege on C.lib, a has execute object privilege on C.lib success.
conn / as sysdba
grant execute on c##test_C.lib1 to c##test_A;
conn c##test_A/Cantian_234@127.0.0.1:1611
select c##test_B.test_add(1, 5) from dual;
conn / as sysdba
drop user c##test_A cascade;
drop user c##test_B cascade;
drop user c##test_C cascade;
--DTS2020020504434
create function test_add_101_short_01 (x1 short, x2 ushort, x3 ushort, x4 ushort, x5 ushort, x6 ushort, x7 ushort, x8 ushort, x9 ushort, x10 ushort, x11 ushort, x12 ushort, x13 ushort, x14 ushort, x15 ushort, x16 ushort, x17 ushort, x18 ushort, x19 ushort, x20 ushort, x21 ushort, x22 ushort, x23 ushort, x24 ushort, x25 ushort, x26 ushort, x27 ushort, x28 ushort, x29 ushort, x30 ushort, x31 ushort, x32 ushort, x33 ushort, x34 ushort, x35 ushort, x36 ushort, x37 ushort, x38 ushort, x39 ushort, x40 ushort, x41 ushort, x42 ushort, x43 ushort, x44 ushort, x45 ushort, x46 ushort, x47 ushort, x48 ushort, x49 ushort, x50 ushort, x51 ushort, x52 ushort, x53 ushort, x54 ushort, x55 ushort, x56 ushort, x57 ushort, x58 ushort, x59 ushort, x60 ushort, x61 ushort, x62 ushort, x63 ushort, x64 ushort, x65 ushort, x66 ushort, x67 ushort, x68 ushort, x69 ushort, x70 ushort, x71 ushort, x72 ushort, x73 ushort, x74 ushort, x75 ushort, x76 ushort, x77 ushort, x78 ushort, x79 ushort, x80 ushort, x81 ushort, x82 ushort, x83 ushort, x84 ushort, x85 ushort, x86 ushort, x87 ushort, x88 ushort, x89 ushort, x90 ushort, x91 ushort, x92 ushort, x93 ushort, x94 ushort, x95 ushort, x96 ushort, x97 ushort, x98 ushort, x99 ushort, x100 ushort, x101 ushort) return short as language c library zn_test_01 name "add_101_short"
/
drop function if exists test_add_101_short_01;

--DTS2020020705506
drop user if exists user2;
create user user2 identified by Changeme_123;
create or replace library test1_lib as '/home/regress/cantiandb/include/libfuncs.so';
grant create session to user2;
grant create any procedure to user2;
grant execute on test1_lib to user2;
conn user2/Changeme_123@127.0.0.1:1611
select * from my_tab_privs where GRANTEE='USER2';
conn / as sysdba
drop library test1_lib;
conn user2/Changeme_123@127.0.0.1:1611
select * from my_tab_privs where GRANTEE='USER2';
conn / as sysdba
drop user user2 CASCADE;

--DTS2020020702611
DROP USER if exists user1 CASCADE;
create user user1 identified by Changeme_123;
create or replace library lib_test2 as '/home/regress/cantiandb/include/libfuncs.so';
create OR REPLACE function func_test2 (x short, y ushort) return short as language c library lib_test2 name "add_two_short"
/
select func_test2(123,234);
create library user1.lib_test2 as '/home/regress/cantiandb/include/libfuncs.so';
create  function user1.func_test3 (x short, y ushort) return short as language c library lib_test2 name "add_two_short"
/
select user1.func_test3(123,234);
drop library lib_test2;
drop function func_test2;
drop library user1.lib_test2;
drop function user1.func_test3;
DROP USER if exists user1 CASCADE;


