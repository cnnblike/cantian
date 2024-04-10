--test orcle pl/sql example collections and records

set serveroutput on;

--Example 5–1 Associative array indexed by string:
DECLARE
  TYPE population IS TABLE OF NUMBER -- Associative array type
    INDEX BY VARCHAR2(64); -- indexed by string
  city_population population; -- Associative array variable
  i VARCHAR2(64); -- Scalar variable
BEGIN
-- Add elements (key-value pairs) to associative array:
  city_population('Smallville') := 2000;
  city_population('Midland') := 750000;
  city_population('Megalopolis') := 1000000;
-- Change value associated with key 'Smallville':
  city_population('Smallville') := 2001;
-- Print associative array:
  i := city_population.FIRST; -- Get first element of array
  WHILE i IS NOT NULL LOOP
    dbe_output.print_line
      ('Population of ' || i || ' is ' || city_population(i));
    i := city_population.NEXT(i); -- Get next element of array
  END LOOP;
END;
/

--Example 5–2 Function Returns Associative Array Indexed by PLS_INTEGER
DECLARE
  TYPE sum_multiples IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;
  n PLS_INTEGER := 5; -- number of multiples to sum for display
  sn PLS_INTEGER := 10; -- number of multiples to sum
  m PLS_INTEGER := 3; -- multiple
  FUNCTION get_sum_multiples (
    multiple IN PLS_INTEGER,
    num IN PLS_INTEGER
  ) RETURN sum_multiples
  IS
    s sum_multiples;
  BEGIN
    FOR i IN 1..num LOOP
      s(i) := multiple * ((i * (i + 1)) / 2); -- sum of multiples
    END LOOP;
    RETURN s;
  END get_sum_multiples;
BEGIN
  dbe_output.print_line (
    'Sum of the first ' || TO_CHAR(n) || ' multiples of ' ||
    TO_CHAR(m) || ' is ' || TO_CHAR(get_sum_multiples (m, sn)(n))
  );
END;
/

--Example 5–3 Declaring Associative Array Constant
CREATE OR REPLACE PACKAGE My_Types AUTHID DEFINER IS
  TYPE My_AA IS TABLE OF VARCHAR2(20) INDEX BY PLS_INTEGER;
  FUNCTION Init_My_AA RETURN My_AA;
END My_Types;
/
CREATE OR REPLACE PACKAGE BODY My_Types IS
  FUNCTION Init_My_AA RETURN My_AA IS
    Ret My_AA;
  BEGIN
    Ret(-10) := '-ten';
    Ret(0) := 'zero';
    Ret(1) := 'one';
    Ret(2) := 'two';
    Ret(3) := 'three';
    Ret(4) := 'four';
    Ret(9) := 'nine';
    RETURN Ret;
  END Init_My_AA;
END My_Types;
/
DECLARE
  v CONSTANT My_Types.My_AA := My_Types.Init_My_AA();
BEGIN
  DECLARE
    Idx PLS_INTEGER := v.FIRST();
  BEGIN
    WHILE Idx IS NOT NULL LOOP
      dbe_output.print_line(TO_CHAR(Idx, '999')||LPAD(v(Idx), 7));
      Idx := v.NEXT(Idx);
    END LOOP;
  END;
END;
/

--Example 5–4 Varray (Variable-Size Array)
DECLARE
  TYPE Foursome IS VARRAY(4) OF VARCHAR2(15); -- VARRAY type
  -- varray variable initialized with constructor:
  team Foursome := Foursome('John', 'Mary', 'Alberto', 'Juanita');
  PROCEDURE print_team (heading VARCHAR2) IS
  BEGIN
    dbe_output.print_line(heading);
    FOR i IN 1..4 LOOP
      dbe_output.print_line(i || '.' || team(i));
    END LOOP;
    dbe_output.print_line('---');
  END;
BEGIN
  print_team('2001 Team:');
  team(3) := 'Pierre'; -- Change values of two elements
  team(4) := 'Yvonne';
  print_team('2005 Team:');
  -- Invoke constructor to assign new values to varray variable:
  team := Foursome('Arun', 'Amitha', 'Allan', 'Mae');
  print_team('2009 Team:');
END;
/

--Example 5–5 Nested Table of Local Type
DECLARE
  TYPE Roster IS TABLE OF VARCHAR2(15); -- nested table type
  -- nested table variable initialized with constructor:
  names Roster := Roster('D Caruso', 'J Hamil', 'D Piro', 'R Singh');
  PROCEDURE print_names (heading VARCHAR2) IS
  BEGIN
    dbe_output.print_line(heading);
    FOR i IN names.FIRST .. names.LAST LOOP -- For first to last element
      dbe_output.print_line(names(i));
    END LOOP;
    dbe_output.print_line('---');
  END;
BEGIN
  print_names('Initial Values:');
  names(3) := 'P Perez'; -- Change value of one element
  print_names('Current Values:');
  names := Roster('A Jansen', 'B Gupta'); -- Change entire table
  print_names('Current Values:');
END;
/

--Example 5–6 Nested Table of Standalone Type
CREATE OR REPLACE TYPE nt_type IS TABLE OF NUMBER;
/
CREATE OR REPLACE PROCEDURE print_nt (nt nt_type) IS
  i NUMBER;
BEGIN
  i := nt.FIRST;
  IF i IS NULL THEN
    dbe_output.print_line('nt is empty');
  ELSE
    WHILE i IS NOT NULL LOOP
      dbe_output.print('nt.(' || i || ') = '); print(nt(i));
      i := nt.NEXT(i);
    END LOOP;
  END IF;
  dbe_output.print_line('---');
END print_nt;
/
DECLARE
  nt nt_type := nt_type(); -- nested table variable initialized to empty
BEGIN
  print_nt(nt);
  nt := nt_type(90, 9, 29, 58);
  print_nt(nt);
END;
/

--Example 5–7 Initializing Collection (Varray) Variable to Empty
DECLARE
  TYPE Foursome IS VARRAY(4) OF VARCHAR2(15);
  team Foursome := Foursome(); -- initialize to empty
  PROCEDURE print_team (heading VARCHAR2)
  IS
  BEGIN
    dbe_output.print_line(heading);
    IF team.COUNT = 0 THEN
      dbe_output.print_line('Empty');
    ELSE
      FOR i IN 1..4 LOOP
        dbe_output.print_line(i || '.' || team(i));
      END LOOP;
    END IF;
    dbe_output.print_line('---');
  END;
BEGIN
  print_team('Team:');
  team := Foursome('John', 'Mary', 'Alberto', 'Juanita');
  print_team('Team:');
END;
/

--Example 5–8 Data Type Compatibility for Collection Assignment
DECLARE
  TYPE triplet IS VARRAY(3) OF VARCHAR2(15);
  TYPE trio IS VARRAY(3) OF VARCHAR2(15);
  group1 triplet := triplet('Jones', 'Wong', 'Marceau');
  group2 triplet;
  group3 trio;
BEGIN
  group2 := group1; -- succeeds
  group3 := group1; -- fails
END;
/

--Example 5–9 Assigning Null Value to Nested Table Variable
DECLARE
  TYPE dnames_tab IS TABLE OF VARCHAR2(30);
  dept_names dnames_tab := dnames_tab(
    'Shipping','Sales','Finance','Payroll'); -- Initialized to non-null value
  empty_set dnames_tab; -- Not initialized, therefore null
  PROCEDURE print_dept_names_status IS
  BEGIN
    IF dept_names IS NULL THEN
      dbe_output.print_line('dept_names is null.');
    ELSE
      dbe_output.print_line('dept_names is not null.');
    END IF;
  END print_dept_names_status;
BEGIN
  print_dept_names_status;
  dept_names := empty_set; -- Assign null collection to dept_names.
  print_dept_names_status;
  dept_names := dnames_tab (
    'Shipping','Sales','Finance','Payroll'); -- Re-initialize dept_names
  print_dept_names_status;
END;
/

--Example 5–10 Assigning Set Operation Results to Nested Table Variable
DECLARE
  TYPE nested_typ IS TABLE OF NUMBER;
  nt1 nested_typ := nested_typ(1,2,3);
  nt2 nested_typ := nested_typ(3,2,1);
  nt3 nested_typ := nested_typ(2,3,1,3);
  nt4 nested_typ := nested_typ(1,2,4);
  answer nested_typ;
  PROCEDURE print_nested_table (nt nested_typ) IS
    output VARCHAR2(128);
  BEGIN
    IF nt IS NULL THEN
      dbe_output.print_line('Result: null set');
    ELSIF nt.COUNT = 0 THEN
      dbe_output.print_line('Result: empty set');
    ELSE
      FOR i IN nt.FIRST .. nt.LAST LOOP -- For first to last element
        output := output || nt(i) || ' ';
      END LOOP;
      dbe_output.print_line('Result: ' || output);
    END IF;
  END print_nested_table;
BEGIN
  answer := nt1 MULTISET UNION nt4;
  print_nested_table(answer);
  answer := nt1 MULTISET UNION nt3;
  print_nested_table(answer);
  answer := nt1 MULTISET UNION DISTINCT nt3;
  print_nested_table(answer);
  answer := nt2 MULTISET INTERSECT nt3;
  print_nested_table(answer);
  answer := nt2 MULTISET INTERSECT DISTINCT nt3;
  print_nested_table(answer);
  answer := SET(nt3);
  print_nested_table(answer);
  answer := nt3 MULTISET EXCEPT nt2;
  print_nested_table(answer);
  answer := nt3 MULTISET EXCEPT DISTINCT nt2;
  print_nested_table(answer);
END;
/

--Example 5–11 Two-Dimensional Varray (Varray of Varrays)
DECLARE
  TYPE t1 IS VARRAY(10) OF INTEGER; -- varray of integer
  va t1 := t1(2,3,5);
  TYPE nt1 IS VARRAY(10) OF t1; -- varray of varray of integer
  nva nt1 := nt1(va, t1(55,6,73), t1(2,4), va);
  i INTEGER;
  va1 t1;
BEGIN
  i := nva(2)(3);
  dbe_output.print_line('i = ' || i);
  nva.EXTEND;
  nva(5) := t1(56, 32); -- replace inner varray elements
  nva(4) := t1(45,43,67,43345); -- replace an inner integer element
  nva(4)(4) := 1; -- replace 43345 with 1
  nva(4).EXTEND; -- add element to 4th varray element
  nva(4)(5) := 89; -- store integer 89 there
END;
/

--Example 5–12 Nested Tables of Nested Tables and Varrays of Integers
DECLARE
  TYPE tb1 IS TABLE OF VARCHAR2(20); -- nested table of strings
  vtb1 tb1 := tb1('one', 'three');
  TYPE ntb1 IS TABLE OF tb1; -- nested table of nested tables of strings
  vntb1 ntb1 := ntb1(vtb1);
  TYPE tv1 IS VARRAY(10) OF INTEGER; -- varray of integers
  TYPE ntb2 IS TABLE OF tv1; -- nested table of varrays of integers
  vntb2 ntb2 := ntb2(tv1(3,5), tv1(5,7,3));
BEGIN
  vntb1.EXTEND;
  vntb1(2) := vntb1(1);
  vntb1.DELETE(1); -- delete first element of vntb1
  vntb1(2).DELETE(1); -- delete first string from second table in nested table
END;
/

--Example 5–13 Nested Tables of Associative Arrays and Varrays of Strings
DECLARE
  TYPE tb1 IS TABLE OF INTEGER INDEX BY PLS_INTEGER; -- associative arrays
  v4 tb1;
  v5 tb1;
  TYPE aa1 IS TABLE OF tb1 INDEX BY PLS_INTEGER; -- associative array of
  v2 aa1; -- associative arrays
  TYPE va1 IS VARRAY(10) OF VARCHAR2(20); -- varray of strings
  v1 va1 := va1('hello', 'world');
  TYPE ntb2 IS TABLE OF va1 INDEX BY PLS_INTEGER; -- associative array of varrays
  v3 ntb2;
BEGIN
  v4(1) := 34; -- populate associative array
  v4(2) := 46456;
  v4(456) := 343;
  v2(23) := v4; -- populate associative array of associative arrays
  v3(34) := va1(33, 456, 656, 343); -- populate associative array varrays
  v2(35) := v5; -- assign empty associative array to v2(35)
  v2(35)(2) := 78;
END;
/

--Example 5–14 Comparing Varray and Nested Table Variables to NULL
DECLARE
  TYPE Foursome IS VARRAY(4) OF VARCHAR2(15); -- VARRAY type
  team Foursome; -- varray variable
  TYPE Roster IS TABLE OF VARCHAR2(15); -- nested table type
  names Roster := Roster('Adams', 'Patel'); -- nested table variable
BEGIN
  IF team IS NULL THEN
    dbe_output.print_line('team IS NULL');
  ELSE
    dbe_output.print_line('team IS NOT NULL');
  END IF;
  IF names IS NOT NULL THEN
    dbe_output.print_line('names IS NOT NULL');
  ELSE
    dbe_output.print_line('names IS NULL');
  END IF;
END;
/

--Example 5–15 Comparing Nested Tables for Equality and Inequality
DECLARE
  TYPE dnames_tab IS TABLE OF VARCHAR2(30); -- element type is not record type
  dept_names1 dnames_tab :=
    dnames_tab('Shipping','Sales','Finance','Payroll');
  dept_names2 dnames_tab :=
    dnames_tab('Sales','Finance','Shipping','Payroll');
  dept_names3 dnames_tab :=
    dnames_tab('Sales','Finance','Payroll');
BEGIN
  IF dept_names1 = dept_names2 THEN
    dbe_output.print_line('dept_names1 = dept_names2');
  END IF;
  IF dept_names2 != dept_names3 THEN
    dbe_output.print_line('dept_names2 != dept_names3');
  END IF;
END;
/

--Example 5–16 Comparing Nested Tables with SQL Multiset Conditions
DECLARE
  TYPE nested_typ IS TABLE OF NUMBER;
  nt1 nested_typ := nested_typ(1,2,3);
  nt2 nested_typ := nested_typ(3,2,1);
  nt3 nested_typ := nested_typ(2,3,1,3);
  nt4 nested_typ := nested_typ(1,2,4);
  PROCEDURE testify (
    truth BOOLEAN := NULL,
    quantity NUMBER := NULL
  ) IS
  BEGIN
    IF truth IS NOT NULL THEN
      dbe_output.print_line (
        CASE truth
          WHEN TRUE THEN 'True'
          WHEN FALSE THEN 'False'
        END
      );
    END IF;
    IF quantity IS NOT NULL THEN
      dbe_output.print_line(quantity);
    END IF;
  END;
BEGIN
  testify(truth => (nt1 IN (nt2,nt3,nt4))); -- condition
  testify(truth => (nt1 SUBMULTISET OF nt3)); -- condition
  testify(truth => (nt1 NOT SUBMULTISET OF nt4)); -- condition
  testify(truth => (4 MEMBER OF nt1)); -- condition
  testify(truth => (nt3 IS A SET)); -- condition
  testify(truth => (nt3 IS NOT A SET)); -- condition
  testify(truth => (nt1 IS EMPTY)); -- condition
  testify(quantity => (CARDINALITY(nt3))); -- function
  testify(quantity => (CARDINALITY(SET(nt3)))); -- 2 functions
END;
/

--Example 5–17 DELETE Method with Nested Table
DECLARE
  nt nt_type := nt_type(11, 22, 33, 44, 55, 66);
BEGIN
  print_nt(nt);
  nt.DELETE(2); -- Delete second element
  print_nt(nt);
  nt(2) := 2222; -- Restore second element
  print_nt(nt);
  nt.DELETE(2, 4); -- Delete range of elements
  print_nt(nt);
  nt(3) := 3333; -- Restore third element
  print_nt(nt);
  nt.DELETE; -- Delete all elements
  print_nt(nt);
END;
/

--Example 5–18 DELETE Method with Associative Array Indexed by String
DECLARE
  TYPE aa_type_str IS TABLE OF INTEGER INDEX BY VARCHAR2(10);
  aa_str aa_type_str;
  PROCEDURE print_aa_str IS
    i VARCHAR2(10);
  BEGIN
    i := aa_str.FIRST;
    IF i IS NULL THEN
      dbe_output.print_line('aa_str is empty');
    ELSE
      WHILE i IS NOT NULL LOOP
        dbe_output.print('aa_str.(' || i || ') = '); print(aa_str(i));
        i := aa_str.NEXT(i);
      END LOOP;
    END IF;
    dbe_output.print_line('---');
  END print_aa_str;
BEGIN
  aa_str('M') := 13;
  aa_str('Z') := 26;
  aa_str('C') := 3;
  print_aa_str;
  aa_str('M') := 13; -- Replace deleted element with same value
  aa_str('Z') := 260; -- Replace deleted element with new value
  aa_str('C') := 30; -- Replace deleted element with new value
  aa_str('W') := 23; -- Add new element
  aa_str('J') := 10; -- Add new element
  aa_str('N') := 14; -- Add new element
  aa_str('P') := 16; -- Add new element
  aa_str('W') := 23; -- Add new element
  aa_str('J') := 10; -- Add new element
  print_aa_str;
  aa_str.DELETE('C'); -- Delete one element
  print_aa_str;
  aa_str.DELETE('N','W'); -- Delete range of elements
  print_aa_str;
  aa_str.DELETE('Z','M'); -- Does nothing
  print_aa_str;
END;
/

--Example 5–19 TRIM Method with Nested Table
DECLARE
  nt nt_type := nt_type(11, 22, 33, 44, 55, 66);
BEGIN
  print_nt(nt);
  nt.TRIM; -- Trim last element
  print_nt(nt);
  nt.DELETE(4); -- Delete fourth element
  print_nt(nt);
  nt.TRIM(2); -- Trim last two elements
  print_nt(nt);
END;
/

--Example 5–20 EXTEND Method with Nested Table
DECLARE
  nt nt_type := nt_type(11, 22, 33);
BEGIN
  print_nt(nt);
  nt.EXTEND(2,1); -- Append two copies of first element
  print_nt(nt);
  nt.DELETE(5); -- Delete fifth element
  print_nt(nt);
  nt.EXTEND; -- Append one null element
  print_nt(nt);
END;
/

--Example 5–21 EXISTS Method with Nested Table
DECLARE
  TYPE NumList IS TABLE OF INTEGER;
  n NumList := NumList(1,3,5,7);
BEGIN
  n.DELETE(2); -- Delete second element
  FOR i IN 1..6 LOOP
    IF n.EXISTS(i) THEN
      dbe_output.print_line('n(' || i || ') = ' || n(i));
    ELSE
      dbe_output.print_line('n(' || i || ') does not exist');
    END IF;
  END LOOP;
END;
/

--Example 5–22 FIRST and LAST Values for Associative Array Indexed by PLS_INTEGER
DECLARE
  TYPE aa_type_int IS TABLE OF INTEGER INDEX BY PLS_INTEGER;
  aa_int aa_type_int;
  PROCEDURE print_first_and_last IS
  BEGIN
    dbe_output.print_line('FIRST = ' || aa_int.FIRST);
    dbe_output.print_line('LAST = ' || aa_int.LAST);
  END print_first_and_last;
BEGIN
  aa_int(1) := 3;
  aa_int(2) := 6;
  aa_int(3) := 9;
  aa_int(4) := 12;
  dbe_output.print_line('Before deletions:');
  print_first_and_last;
  aa_int.DELETE(1);
  aa_int.DELETE(4);
  dbe_output.print_line('After deletions:');
  print_first_and_last;
END;
/

--Example 5–23 FIRST and LAST Values for Associative Array Indexed by String
DECLARE
  TYPE aa_type_str IS TABLE OF INTEGER INDEX BY VARCHAR2(10);
  aa_str aa_type_str;
  PROCEDURE print_first_and_last IS
  BEGIN
    dbe_output.print_line('FIRST = ' || aa_str.FIRST);
    dbe_output.print_line('LAST = ' || aa_str.LAST);
  END print_first_and_last;
BEGIN
  aa_str('Z') := 26;
  aa_str('A') := 1;
  aa_str('K') := 11;
  aa_str('R') := 18;
  dbe_output.print_line('Before deletions:');
  print_first_and_last;
  aa_str.DELETE('A');
  aa_str.DELETE('Z');
  dbe_output.print_line('After deletions:');
  print_first_and_last;
END;
/

--Example 5–24 Printing Varray with FIRST and LAST in FOR LOOP
DECLARE
  TYPE team_type IS VARRAY(4) OF VARCHAR2(15);
  team team_type;
  PROCEDURE print_team (heading VARCHAR2)
  IS
  BEGIN
    dbe_output.print_line(heading);
    IF team IS NULL THEN
      dbe_output.print_line('Does not exist');
    ELSIF team.FIRST IS NULL THEN
      dbe_output.print_line('Has no members');
    ELSE
      FOR i IN team.FIRST..team.LAST LOOP
        dbe_output.print_line(i || '. ' || team(i));
      END LOOP;
    END IF;
    dbe_output.print_line('---');
  END;
BEGIN
  print_team('Team Status:');
  team := team_type(); -- Team is funded, but nobody is on it.
  print_team('Team Status:');
  team := team_type('John', 'Mary'); -- Put 2 members on team.
  print_team('Initial Team:');
  team := team_type('Arun', 'Amitha', 'Allan', 'Mae'); -- Change team.
  print_team('New Team:');
END;
/  

--Example 5–25 Printing Nested Table with FIRST and LAST in FOR LOOP
DECLARE
  TYPE team_type IS TABLE OF VARCHAR2(15);
  team team_type;
  PROCEDURE print_team (heading VARCHAR2) IS
  BEGIN
    dbe_output.print_line(heading);
    IF team IS NULL THEN
      dbe_output.print_line('Does not exist');
    ELSIF team.FIRST IS NULL THEN
      dbe_output.print_line('Has no members');
    ELSE
      FOR i IN team.FIRST..team.LAST LOOP
        dbe_output.print(i || '. ');
        IF team.EXISTS(i) THEN
          dbe_output.print_line(team(i));
        ELSE
          dbe_output.print_line('(to be hired)');
        END IF;
      END LOOP;
    END IF;
    dbe_output.print_line('---');
  END;
BEGIN
  print_team('Team Status:');
  team := team_type(); -- Team is funded, but nobody is on it.
  print_team('Team Status:');
  team := team_type('Arun', 'Amitha', 'Allan', 'Mae'); -- Add members.
  print_team('Initial Team:');
  team.DELETE(2,3); -- Remove 2nd and 3rd members.
  print_team('Current Team:');
END;
/

--Example 5–26 COUNT and LAST Values for Varray
DECLARE
  TYPE NumList IS VARRAY(10) OF INTEGER;
  n NumList := NumList(1,3,5,7);
  PROCEDURE print_count_and_last IS
  BEGIN
    dbe_output.print('n.COUNT = ' || n.COUNT || ', ');
    dbe_output.print_line('n.LAST = ' || n.LAST);
  END print_count_and_last;
BEGIN
  print_count_and_last;
  n.EXTEND(3);
  print_count_and_last;
  n.TRIM(5);
  print_count_and_last;
END;
/

--Example 5–27 COUNT and LAST Values for Nested Table
DECLARE
  TYPE NumList IS TABLE OF INTEGER;
  n NumList := NumList(1,3,5,7);
  PROCEDURE print_count_and_last IS
  BEGIN
    dbe_output.print('n.COUNT = ' || n.COUNT || ', ');
    dbe_output.print_line('n.LAST = ' || n.LAST);
  END print_count_and_last;
BEGIN
  print_count_and_last;
  n.DELETE(3); -- Delete third element
  print_count_and_last;
  n.EXTEND(2); -- Add two null elements to end
  print_count_and_last;
  FOR i IN 1..8 LOOP
    IF n.EXISTS(i) THEN
      IF n(i) IS NOT NULL THEN
        dbe_output.print_line('n(' || i || ') = ' || n(i));
      ELSE
        dbe_output.print_line('n(' || i || ') = NULL');
      END IF;
    ELSE
      dbe_output.print_line('n(' || i || ') does not exist');
    END IF;
  END LOOP;
END;
/

--Example 5–28 LIMIT and COUNT Values for Different Collection Types
DECLARE
  TYPE aa_type IS TABLE OF INTEGER INDEX BY PLS_INTEGER;
  aa aa_type; -- associative array
  TYPE va_type IS VARRAY(4) OF INTEGER;
  va va_type := va_type(2,4); -- varray
  TYPE nt_type IS TABLE OF INTEGER;
  nt nt_type := nt_type(1,3,5); -- nested table
BEGIN
  aa(1):=3; aa(2):=6; aa(3):=9; aa(4):= 12;
  dbe_output.print('aa.COUNT = '); print(aa.COUNT);
  dbe_output.print('aa.LIMIT = '); print(aa.LIMIT);
  dbe_output.print('va.COUNT = '); print(va.COUNT);
  dbe_output.print('va.LIMIT = '); print(va.LIMIT);
  dbe_output.print('nt.COUNT = '); print(nt.COUNT);
  dbe_output.print('nt.LIMIT = '); print(nt.LIMIT);
END;
/

--Example 5–29 PRIOR and NEXT Methods
DECLARE
  TYPE nt_type IS TABLE OF NUMBER;
  nt nt_type := nt_type(18, NULL, 36, 45, 54, 63);
BEGIN
  nt.DELETE(4);
  dbe_output.print_line('nt(4) was deleted.');
  FOR i IN 1..7 LOOP
    dbe_output.print('nt.PRIOR(' || i || ') = '); print(nt.PRIOR(i));
    dbe_output.print('nt.NEXT(' || i || ') = '); print(nt.NEXT(i));
  END LOOP;
END;
/

--Example 5–30 Printing Elements of Sparse Nested Table
DECLARE
  TYPE NumList IS TABLE OF NUMBER;
  n NumList := NumList(1, 2, NULL, NULL, 5, NULL, 7, 8, 9, NULL);
  idx INTEGER;
BEGIN
  dbe_output.print_line('First to last:');
  idx := n.FIRST;
  WHILE idx IS NOT NULL LOOP
    dbe_output.print('n(' || idx || ') = ');
    print(n(idx));
    idx := n.NEXT(idx);
  END LOOP;
  dbe_output.print_line('--------------');
  dbe_output.print_line('Last to first:');
  idx := n.LAST;
  WHILE idx IS NOT NULL LOOP
    dbe_output.print('n(' || idx || ') = ');
    print(n(idx));
    idx := n.PRIOR(idx);
  END LOOP;
END;
/

--Example 5–31 Identically Defined Package and Local Collection Types
CREATE OR REPLACE PACKAGE pkg AS
  TYPE NumList IS TABLE OF NUMBER;
   PROCEDURE print_numlist (nums NumList);
END pkg;
/
CREATE OR REPLACE PACKAGE BODY pkg AS
  PROCEDURE print_numlist (nums NumList) IS
  BEGIN
    FOR i IN nums.FIRST..nums.LAST LOOP
      dbe_output.print_line(nums(i));
    END LOOP;
  END;
END pkg;
/
DECLARE
  TYPE NumList IS TABLE OF NUMBER; -- local type identical to package type
  n1 pkg.NumList := pkg.NumList(2,4); -- package type
  n2 NumList := NumList(6,8); -- local type
BEGIN
  pkg.print_numlist(n1); -- succeeds
  pkg.print_numlist(n2); -- fails
END;
/

--Example 5–32 Identically Defined Package and Standalone Collection Types
CREATE OR REPLACE TYPE NumList IS TABLE OF NUMBER;
-- standalone collection type identical to package type
/
DECLARE
  n1 pkg.NumList := pkg.NumList(2,4); -- package type
  n2 NumList := NumList(6,8); -- standalone type
BEGIN
  pkg.print_numlist(n1); -- succeeds
  pkg.print_numlist(n2); -- fails
END;
/

--Example 5–33 Declaring Record Constant
CREATE OR REPLACE PACKAGE My_Types AUTHID DEFINER IS
  TYPE My_Rec IS RECORD (a NUMBER, b NUMBER);
  FUNCTION Init_My_Rec RETURN My_Rec;
END My_Types;
/
CREATE OR REPLACE PACKAGE BODY My_Types IS
  FUNCTION Init_My_Rec RETURN My_Rec IS
    Rec My_Rec;
  BEGIN
    Rec.a := 0;
    Rec.b := 1;
    RETURN Rec;
  END Init_My_Rec;
END My_Types;
/
DECLARE
  r CONSTANT My_Types.My_Rec := My_Types.Init_My_Rec();
BEGIN
  dbe_output.print_line('r.a = ' || r.a);
  dbe_output.print_line('r.b = ' || r.b);
END;
/

--Example 5–34 RECORD Type Definition and Variable Declarations
DECLARE
  TYPE DeptRecTyp IS RECORD (
    dept_id NUMBER(4) NOT NULL := 10,
    dept_name VARCHAR2(30) NOT NULL := 'Administration',
    mgr_id NUMBER(6) := 200,
    loc_id NUMBER(4)
  );
  dept_rec DeptRecTyp;
  dept_rec_2 dept_rec%TYPE;
BEGIN
  dbe_output.print_line('dept_rec:');
  dbe_output.print_line('---------');
  dbe_output.print_line('dept_id: ' || dept_rec.dept_id);
  dbe_output.print_line('dept_name: ' || dept_rec.dept_name);
  dbe_output.print_line('mgr_id: ' || dept_rec.mgr_id);
  dbe_output.print_line('loc_id: ' || dept_rec.loc_id);
  dbe_output.print_line('-----------');
  dbe_output.print_line('dept_rec_2:');
  dbe_output.print_line('-----------');
  dbe_output.print_line('dept_id: ' || dept_rec_2.dept_id);
  dbe_output.print_line('dept_name: ' || dept_rec_2.dept_name);
  dbe_output.print_line('mgr_id: ' || dept_rec_2.mgr_id);
  dbe_output.print_line('loc_id: ' || dept_rec_2.loc_id);
END;
/

--Example 5–35 RECORD Type with RECORD Field (Nested Record)
DECLARE
  TYPE name_rec IS RECORD (
    first employees.first_name%TYPE,
    last employees.last_name%TYPE
  );
  TYPE contact IS RECORD (
    name name_rec, -- nested record
    phone employees.phone_number%TYPE
  );
  friend contact;
BEGIN
  friend.name.first := 'John';
  friend.name.last := 'Smith';
  friend.phone := '1-650-555-1234';
  dbe_output.print_line (
    friend.name.first || ' ' ||
    friend.name.last || ', ' ||
    friend.phone
  );
END;
/

--Example 5–36 RECORD Type with Varray Field
DECLARE
  TYPE full_name IS VARRAY(2) OF VARCHAR2(20);
  TYPE contact IS RECORD (
    name full_name := full_name('John', 'Smith'), -- varray field
    phone employees.phone_number%TYPE
  );
  friend contact;
BEGIN
  friend.phone := '1-650-555-1234';
  dbe_output.print_line (
    friend.name(1) || ' ' ||
    friend.name(2) || ', ' ||
    friend.phone
  );
END;
/

--Example 5–37 Identically Defined Package and Local RECORD Types
CREATE OR REPLACE PACKAGE pkg AS
  TYPE rec_type IS RECORD ( -- package RECORD type
    f1 INTEGER,
    f2 VARCHAR2(4)
  );
  PROCEDURE print_rec_type (rec rec_type);
END pkg;
/
CREATE OR REPLACE PACKAGE BODY pkg AS
  PROCEDURE print_rec_type (rec rec_type) IS
  BEGIN
    dbe_output.print_line(rec.f1);
    dbe_output.print_line(rec.f2);
  END;
END pkg;
/
DECLARE
  TYPE rec_type IS RECORD ( -- local RECORD type
    f1 INTEGER,
    f2 VARCHAR2(4)
  );
  r1 pkg.rec_type; -- package type
  r2 rec_type; -- local type
BEGIN
  r1.f1 := 10; r1.f2 := 'abcd';
  r2.f1 := 25; r2.f2 := 'wxyz';
  pkg.print_rec_type(r1); -- succeeds
  pkg.print_rec_type(r2); -- fails
END;
/

--Example 5–38 %ROWTYPE Variable Represents Full Database Table Row
DECLARE
  dept_rec departments%ROWTYPE;
BEGIN
  -- Assign values to fields:
  dept_rec.department_id := 10;
  dept_rec.department_name := 'Administration';
  dept_rec.manager_id := 200;
  dept_rec.location_id := 1700;
  -- Print fields:
  dbe_output.print_line('dept_id: ' || dept_rec.department_id);
  dbe_output.print_line('dept_name: ' || dept_rec.department_name);
  dbe_output.print_line('mgr_id: ' || dept_rec.manager_id);
  dbe_output.print_line('loc_id: ' || dept_rec.location_id);
END;
/

--Example 5–39 %ROWTYPE Variable Does Not Inherit Initial Values or Constraints
DROP TABLE t1;
CREATE TABLE t1 (
  c1 INTEGER DEFAULT 0 NOT NULL,
  c2 INTEGER DEFAULT 1 NOT NULL
);
DECLARE
  t1_row t1%ROWTYPE;
BEGIN
  dbe_output.print('t1.c1 = '); print(t1_row.c1);
  dbe_output.print('t1.c2 = '); print(t1_row.c2);
END;
/

--Example 5–40 %ROWTYPE Variable Represents Partial Database Table Row
DECLARE
  CURSOR c IS
    SELECT first_name, last_name, phone_number
    FROM employees;
  friend c%ROWTYPE;
BEGIN
  friend.first_name := 'John';
  friend.last_name := 'Smith';
  friend.phone_number := '1-650-555-1234';
  dbe_output.print_line (
    friend.first_name || ' ' ||
    friend.last_name || ', ' ||
    friend.phone_number
);
END;
/

--Example 5–41 %ROWTYPE Variable Represents Join Row
DECLARE
  CURSOR c2 IS
    SELECT employee_id, email, employees.manager_id, location_id
    FROM employees, departments
    WHERE employees.department_id = departments.department_id;
  join_rec c2%ROWTYPE; -- includes columns from two tables
BEGIN
  NULL;
END;
/

--Example 5–42 Inserting %ROWTYPE Record into Table (Wrong)
DROP TABLE plch_departure;
CREATE TABLE plch_departure (
  destination VARCHAR2(100),
  departure_time DATE,
  delay NUMBER(10),
  expected GENERATED ALWAYS AS (departure_time + delay/24/60/60)
);
DECLARE
  dep_rec plch_departure%ROWTYPE;
BEGIN
  dep_rec.destination := 'X';
  dep_rec.departure_time := SYSDATE;
  dep_rec.delay := 1500;
  INSERT INTO plch_departure VALUES dep_rec;
END;
/

--Example 5–43 Inserting %ROWTYPE Record into Table (Right)
DECLARE
  dep_rec plch_departure%rowtype;
BEGIN
  dep_rec.destination := 'X';
  dep_rec.departure_time := SYSDATE;
  dep_rec.delay := 1500;
  INSERT INTO plch_departure (destination, departure_time, delay)
  VALUES (dep_rec.destination, dep_rec.departure_time, dep_rec.delay);
end;
/

--Example 5–44 Assigning Record to Another Record of Same RECORD Type
DECLARE
  TYPE name_rec IS RECORD (
    first employees.first_name%TYPE DEFAULT 'John',
    last employees.last_name%TYPE DEFAULT 'Doe'
  );
  name1 name_rec;
  name2 name_rec;
BEGIN
  name1.first := 'Jane'; name1.last := 'Smith';
  dbe_output.print_line('name1: ' || name1.first || ' ' || name1.last);
  name2 := name1;
  dbe_output.print_line('name2: ' || name2.first || ' ' || name2.last);
END;
/

--Example 5–45 Assigning %ROWTYPE Record to RECORD Type Record
DECLARE
  TYPE name_rec IS RECORD (
    first employees.first_name%TYPE DEFAULT 'John',
    last employees.last_name%TYPE DEFAULT 'Doe' 
  );
  CURSOR c IS
    SELECT first_name, last_name
    FROM employees;
  target name_rec;
  source c%ROWTYPE;
BEGIN
  source.first_name := 'Jane'; source.last_name := 'Smith';
  dbe_output.print_line (
    'source: ' || source.first_name || ' ' || source.last_name
  );
  target := source;
  dbe_output.print_line (
    'target: ' || target.first || ' ' || target.last
  );
END;
/

--Example 5–46 Assigning Nested Record to Another Record of Same RECORD Type
DECLARE
  TYPE name_rec IS RECORD (
    first employees.first_name%TYPE,
    last employees.last_name%TYPE
  );
  TYPE phone_rec IS RECORD (
    name name_rec, -- nested record
    phone employees.phone_number%TYPE
  );
  TYPE email_rec IS RECORD (
    name name_rec, -- nested record
    email employees.email%TYPE
  );
  phone_contact phone_rec;
  email_contact email_rec;
BEGIN
  phone_contact.name.first := 'John';
  phone_contact.name.last := 'Smith';
  phone_contact.phone := '1-650-555-1234';
  email_contact.name := phone_contact.name;
  email_contact.email := (
    email_contact.name.first || '.' ||
    email_contact.name.last || '@' ||
    'example.com'
  );
  dbe_output.print_line (email_contact.email);
END;
/

--Example 5–47 SELECT INTO Assigns Values to Record Variable
DECLARE
  TYPE RecordTyp IS RECORD (
    last employees.last_name%TYPE,
    id employees.employee_id%TYPE
  );
  rec1 RecordTyp;
BEGIN
  SELECT last_name, employee_id INTO rec1
  FROM employees
  WHERE job_id = 'AD_PRES';
  dbe_output.print_line ('Employee #' || rec1.id || ' = ' || rec1.last);
END;
/

--Example 5–48 FETCH Assigns Values to Record that Function Returns
DECLARE
  TYPE EmpRecTyp IS RECORD (
    emp_id employees.employee_id%TYPE,
    salary employees.salary%TYPE
  );
  CURSOR desc_salary RETURN EmpRecTyp IS
    SELECT employee_id, salary
    FROM employees
    ORDER BY salary DESC;
  highest_paid_emp EmpRecTyp;
  next_highest_paid_emp EmpRecTyp;
  FUNCTION nth_highest_salary (n INTEGER) RETURN EmpRecTyp IS
    emp_rec EmpRecTyp;
  BEGIN
    OPEN desc_salary;
    FOR i IN 1..n LOOP
      FETCH desc_salary INTO emp_rec;
    END LOOP;
    CLOSE desc_salary;
    RETURN emp_rec;
  END nth_highest_salary;
BEGIN
  highest_paid_emp := nth_highest_salary(1);
  next_highest_paid_emp := nth_highest_salary(2);
  dbe_output.print_line(
    'Highest Paid: #' ||
    highest_paid_emp.emp_id || ', $' ||
    highest_paid_emp.salary
  );
  dbe_output.print_line(
    'Next Highest Paid: #' ||
    next_highest_paid_emp.emp_id || ', $' ||
    next_highest_paid_emp.salary
  );
END;
/

--Example 5–49 UPDATE Statement Assigns Values to Record Variable
DECLARE
  TYPE EmpRec IS RECORD (
    last_name employees.last_name%TYPE,
    salary employees.salary%TYPE
  );
  emp_info EmpRec;
  old_salary employees.salary%TYPE;
BEGIN
  SELECT salary INTO old_salary
    FROM employees
    WHERE employee_id = 100;
  UPDATE employees
    SET salary = salary * 1.1
    WHERE employee_id = 100
    RETURNING last_name, salary INTO emp_info;
  dbe_output.print_line (
    'Salary of ' || emp_info.last_name || ' raised from ' ||
    old_salary || ' to ' || emp_info.salary
  );
END;
/

--Example 5–50 Assigning NULL to Record Variable
DECLARE
  TYPE age_rec IS RECORD (
    years INTEGER DEFAULT 35,
    months INTEGER DEFAULT 6
  );
  TYPE name_rec IS RECORD (
    first employees.first_name%TYPE DEFAULT 'John',
    last employees.last_name%TYPE DEFAULT 'Doe',
    age age_rec
  );
  name name_rec;
  PROCEDURE print_name AS
  BEGIN
    dbe_output.print(NVL(name.first, 'NULL') || ' ');
    dbe_output.print(NVL(name.last, 'NULL') || ', ');
    dbe_output.print(NVL(TO_CHAR(name.age.years), 'NULL') || ' yrs ');
    dbe_output.print_line(NVL(TO_CHAR(name.age.months), 'NULL') || ' mos');
  END;
BEGIN
  print_name;
  name := NULL;
  print_name;
END;
/

--Example 5–51 Initializing Table by Inserting Record of Default Values
DROP TABLE schedule;
CREATE TABLE schedule (
  week NUMBER,
  Mon VARCHAR2(10),
  Tue VARCHAR2(10),
  Wed VARCHAR2(10),
  Thu VARCHAR2(10),
  Fri VARCHAR2(10),
  Sat VARCHAR2(10),
  Sun VARCHAR2(10)
);
DECLARE
  default_week schedule%ROWTYPE;
  i NUMBER;
BEGIN
  default_week.Mon := '0800-1700';
  default_week.Tue := '0800-1700';
  default_week.Wed := '0800-1700';
  default_week.Thu := '0800-1700';
  default_week.Fri := '0800-1700';
  default_week.Sat := 'Day Off';
  default_week.Sun := 'Day Off';
  FOR i IN 1..6 LOOP
    default_week.week := i;
    INSERT INTO schedule VALUES default_week;
  END LOOP;
END;
/
COLUMN week FORMAT 99
COLUMN Mon FORMAT A9
COLUMN Tue FORMAT A9
COLUMN Wed FORMAT A9
COLUMN Thu FORMAT A9
COLUMN Fri FORMAT A9
COLUMN Sat FORMAT A9
COLUMN Sun FORMAT A9
SELECT * FROM schedule;

--Example 5–52 Updating Rows with Record
DECLARE
  default_week schedule%ROWTYPE;
BEGIN
  default_week.Mon := 'Day Off';
  default_week.Tue := '0900-1800';
  default_week.Wed := '0900-1800';
  default_week.Thu := '0900-1800';
  default_week.Fri := '0900-1800';
  default_week.Sat := '0900-1800';
  default_week.Sun := 'Day Off';
  FOR i IN 1..3 LOOP
    default_week.week := i;
    UPDATE schedule
    SET ROW = default_week
    WHERE week = i;
  END LOOP;
END;
/
SELECT * FROM schedule;

set serveroutput off;

