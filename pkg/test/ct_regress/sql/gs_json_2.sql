DROP  TABLE if exists  j_purchaseorder;
CREATE TABLE j_purchaseorder
   (id          RAW (16) NOT NULL,
    date_loaded TIMESTAMP WITH TIME ZONE,
    po_document CLOB
    CONSTRAINT ensure_json CHECK (po_document IS JSON)); 

---------------------------------------------------------------------------------------------------------
--begin with array
--pass
truncate table j_purchaseorder;
INSERT INTO j_purchaseorder VALUES (
    SYS_GUID(),
    SYSTIMESTAMP,
    '[{"A1":"A1111"},{"A2":"A2222"},{"A3":"A3333"},{"A4":"A4444"}]');
COMMIT;

SELECT json_value(po_document, '$[2].A3') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].A3') FROM j_purchaseorder;
SELECT json_value(po_document, '$[0 to 3].A3') FROM j_purchaseorder;
SELECT json_value(po_document, '$[0,1,2].A3') FROM j_purchaseorder;
SELECT json_value(po_document, '$[0,1,3].A3') FROM j_purchaseorder;
SELECT json_value(po_document, '$[to].A3') FROM j_purchaseorder;
SELECT json_value(po_document, '$[1, to].A3') FROM j_purchaseorder;
SELECT json_value(po_document, '$[2 to].A3') FROM j_purchaseorder;
SELECT json_value(po_document, '$[to 3].A3') FROM j_purchaseorder;

--XX on empty
select 1 from dual where (SELECT json_value(po_document, '$[0,1,3].A3' empty on empty) FROM j_purchaseorder) is null;
select 1 from dual where (SELECT json_value(po_document, '$[0,1,3].A3' null on empty) FROM j_purchaseorder) is null;
select 1 from dual where (SELECT json_value(po_document, '$[0,1,3].A3' true on empty) FROM j_purchaseorder) = true;
select 1 from dual where (SELECT json_value(po_document, '$[0,1,3].A3' true on empty) FROM j_purchaseorder) = 'true';
select 1 from dual where (SELECT json_value(po_document, '$[0,1,3].A3' false on empty) FROM j_purchaseorder) = false;
select 1 from dual where (SELECT json_value(po_document, '$[0,1,3].A3' false on empty) FROM j_purchaseorder) = 'false';
select 1 from dual where (SELECT json_value(po_document, '$[0,1,3].A3' error on empty) FROM j_purchaseorder) = true;

--XX on error
select 1 from dual where (SELECT json_value(po_document, '$$$[0,1,3, to].A3' empty on error) FROM j_purchaseorder) ='[]';
select 1 from dual where (SELECT json_value(po_document, '$$$[0,1,3, to].A3' null on error) FROM j_purchaseorder) is null;
select 1 from dual where (SELECT json_value(po_document, '$$$[0,1,3, to].A3' true on error) FROM j_purchaseorder) = true;
select 1 from dual where (SELECT json_value(po_document, '$$$[0,1,3, to].A3' true on error) FROM j_purchaseorder) = 'true';
select 1 from dual where (SELECT json_value(po_document, '$$$[0,1,3, to].A3' false on error) FROM j_purchaseorder) = false;
select 1 from dual where (SELECT json_value(po_document, '$$$[0,1,3, to].A3' false on error) FROM j_purchaseorder) = 'false';
select 1 from dual where (SELECT json_value(po_document, '$$$[0,1,3, to].A3' error on error) FROM j_purchaseorder) = true;

---------------------------------------------------------------------------------------------------------
--internal node is array
--pass
truncate table j_purchaseorder;
INSERT INTO j_purchaseorder VALUES (
    SYS_GUID(),
    SYSTIMESTAMP,
    '{"XX":[{"A1":"A1111"},{"A2":"A2222"},{"A3":"A3333"},{"A4":"A4444"}]}');
COMMIT;

SELECT json_value(po_document, '$.XX[2].A3') FROM j_purchaseorder;
SELECT json_value(po_document, '$.   [2].       A3') FROM j_purchaseorder;
SELECT json_value(po_document, '$.   *  [    2     ].       A3   ') FROM j_purchaseorder;
SELECT json_value(po_document, '$.XX[*].A3') FROM j_purchaseorder;
SELECT json_value(po_document, '$.XX[0 to 3].A3') FROM j_purchaseorder;
SELECT json_value(po_document, '$.XX[0,1,2].A3') FROM j_purchaseorder;
SELECT json_value(po_document, '$.XX[0,1,3].A3') FROM j_purchaseorder;

SELECT json_query(po_document, '$') FROM j_purchaseorder;
SELECT json_query(po_document, '$[*]') FROM j_purchaseorder;
SELECT json_query(po_document, '$[0]') FROM j_purchaseorder;
SELECT json_query(po_document, '$[1 to 5]') FROM j_purchaseorder;
SELECT json_query(po_document, '$[to,to,to,to]') FROM j_purchaseorder;

SELECT json_value(po_document, '        $.XX[*].A3     ') FROM j_purchaseorder;
SELECT json_value(po_document, '        $.XX[*]   .     A3     ') FROM j_purchaseorder;
SELECT json_value(po_document, '$.XX[*].A3') FROM j_purchaseorder;
SELECT json_value(po_document, '$.  *  [  *  ].A3') FROM j_purchaseorder;

SELECT json_value(po_document, '$.  XX  [*].  A3  ') FROM j_purchaseorder;
SELECT json_value(po_document, '$[  *  ].  XX  [*].  A3  ') FROM j_purchaseorder;
SELECT json_query(po_document, '$[  *  ].  XX  [*].  A3  ') FROM j_purchaseorder;

SELECT json_query(po_document, '$[1].  XX  [*].  A3  ') FROM j_purchaseorder;
SELECT json_query(po_document, '$[     1     ]  .  XX  [*].  A3  ') FROM j_purchaseorder;
SELECT json_value(po_document, '$.XX[0,0 to 3, 4, 5 to 7].A3') FROM j_purchaseorder;
SELECT json_value(po_document, '$.XX[0,0 to 3, to , to 4, 4, 5 to 7].A3') FROM j_purchaseorder;

--error order
SELECT json_value(po_document, '$.XX[0,0 to 3, 4, 5 to 7, 4 to 2].A3') FROM j_purchaseorder;
SELECT json_query(po_document, '$[ 2, 5 to 3 ].  XX  [*].  A3  ') FROM j_purchaseorder;

--error char
SELECT json_query(po_document, '$[ 2b, 5 to 3 ].  XX  [*].  A3  ') FROM j_purchaseorder;
SELECT json_query(po_document, '$[ 2, 5h to 3 ].  XX  [*].  A3  ') FROM j_purchaseorder;

--error array
SELECT json_query(po_document, '$[[ 2, 5 to 3 ].  XX  [*].  A3  ') FROM j_purchaseorder;
SELECT json_query(po_document, '$[ 2, 5 to 3 .  XX  [*].  A3  ') FROM j_purchaseorder;
SELECT json_query(po_document, '$[ 2, 5 to 3 ]].  XX  [*].  A3  ') FROM j_purchaseorder;
SELECT json_value(po_document, '        $.XX[*]  A3     ') FROM j_purchaseorder;
SELECT json_query(po_document, '  $[  ].  XX  [*].  A3  ') FROM j_purchaseorder;
SELECT json_query(po_document, '$[ 1 ,  *  ].  XX  [*].  A3  ') FROM j_purchaseorder;

--error begin
SELECT json_query(po_document, '    gg$[ 2, 5 to 3 ].  XX  [*].  A3  ') FROM j_purchaseorder;
SELECT json_query(po_document, '    *$h [ 2, 5 to 3 ].  XX  [*].  A3  ') FROM j_purchaseorder;
SELECT json_query(po_document, '$bb[ 2, 5 to 3 .  XX  [*].  A3  ') FROM j_purchaseorder;

--pass
SELECT json_value(po_document, '  $[  to  ].  XX  [*].  A3  ') FROM j_purchaseorder;
SELECT json_value(po_document, '   $[ 5 to  ].  XX  [*].  A3  ') FROM j_purchaseorder;
SELECT json_value(po_document, ' $[ 3 ,  5 to  ].  XX  [*].  A3  ') FROM j_purchaseorder;
SELECT json_value(po_document, '   $[ 2,  to  8  ].  XX  [*].  A3  ') FROM j_purchaseorder;
SELECT json_value(po_document, ' $[ *     ]   .  XX  [   2,  to  8 , 9 to,to   15   ,to,18 to].  A3  ') FROM j_purchaseorder;

SELECT json_query(po_document, '  $[  to  ].  XX  [*].  A3  ') FROM j_purchaseorder;
SELECT json_query(po_document, '   $[ 5 to  ].  XX  [*].  A3  ') FROM j_purchaseorder;
SELECT json_query(po_document, ' $[ 3 ,  5 to  ].  XX  [*].  A3  ') FROM j_purchaseorder;
SELECT json_query(po_document, '   $[ 2,  to  8  ].  XX  [*].  A3  ') FROM j_purchaseorder;
SELECT json_query(po_document, ' $[ *     ]   .  XX  [   2,  to  8 , 9 to,to   15   ,to,18 to].  A3  ') FROM j_purchaseorder;

---------------------------------------------------------------------------------------------------------
--begin with object
--pass
truncate table j_purchaseorder;
INSERT INTO j_purchaseorder VALUES (
    SYS_GUID(),
    SYSTIMESTAMP,
    '{"PONumber":66666, "PONumber1":8888, "PONumber2":5459, "jdd":"I Love China..."}');
COMMIT;

SELECT json_query(po_document, '$[0]') FROM j_purchaseorder;
SELECT json_query(po_document, '$[0 to 3]') FROM j_purchaseorder;
SELECT json_query(po_document, '$[1]') FROM j_purchaseorder;
SELECT json_query(po_document, '$[1 to 3]') FROM j_purchaseorder;
SELECT json_query(po_document, '$') FROM j_purchaseorder;
SELECT json_query(po_document, '$[to]') FROM j_purchaseorder;
SELECT json_query(po_document, '$[*]') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].PONumber1') FROM j_purchaseorder;

---------------------------------------------------------------------------------------------------------
--internal node is object
--pass
truncate table j_purchaseorder;
INSERT INTO j_purchaseorder VALUES (
    SYS_GUID(),
    SYSTIMESTAMP,
    '{"XX":{"PONumber":66666, "PONumber1":8888, "PONumber2":5459, "ASDF":{"PONumber3":9999}, "QWER":{"PONumber4":[1,2,3,4]}}}');
COMMIT;

SELECT json_query(po_document, '$.XX[0]') FROM j_purchaseorder;
SELECT json_query(po_document, '$.XX[0 to 3]') FROM j_purchaseorder;
SELECT json_query(po_document, '$.XX[1]') FROM j_purchaseorder;
SELECT json_query(po_document, '$.XX[1 to 3]') FROM j_purchaseorder;
SELECT json_query(po_document, '$.XX[*]') FROM j_purchaseorder;
SELECT json_value(po_document, '$.XX.PONumber1') FROM j_purchaseorder;
SELECT json_value(po_document, '$.XX[*].PONumber1') FROM j_purchaseorder;
SELECT json_value(po_document, '$.*.PONumber1') FROM j_purchaseorder;

--Path Expression Syntax Relaxation
SELECT json_value(po_document, '$.*.*.PONumber3') FROM j_purchaseorder;
SELECT json_value(po_document, '$.*[*].*.PONumber3') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].*[*].*.PONumber3') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].*[*].*[*].PONumber3') FROM j_purchaseorder;
SELECT json_value(po_document, '$[0].*[*].*[*].PONumber3') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].*[*].ASDF[*].PONumber3') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].*[*].ASDF[0].PONumber3') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].*[*].ASDF[to, TO, To, tO].PONumber3') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].*[*].ASDF.PONumber3') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].*[*].ASDF.*[0]') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].*[*].ASDF.*[*]') FROM j_purchaseorder;
SELECT json_value(po_document, '$[to].*[*].ASDF.*') FROM j_purchaseorder;

SELECT json_query(po_document, '$.*.*.PONumber4') FROM j_purchaseorder;
SELECT json_value(po_document, '$.*.*.PONumber4[2]') FROM j_purchaseorder;

SELECT json_value(po_document, '$.XX  PONumber1') FROM j_purchaseorder;

---------------------------------------------------------------------------------------------------------
--* can not appear alone
--pass
truncate table j_purchaseorder;
INSERT INTO j_purchaseorder VALUES (
    SYS_GUID(),
    SYSTIMESTAMP,
    '{"XX":{"PONumber":66666, "PONumber1":8888, "PONumber2":5459}}');
COMMIT;

SELECT json_value(po_document, '$.XX[*].PONumber1') FROM j_purchaseorder;
SELECT json_value(po_document, '$.XX[*].PONumber1[0]') FROM j_purchaseorder;
SELECT json_value(po_document, '$.XX[*].PONumber1[to]') FROM j_purchaseorder;
SELECT json_value(po_document, '$.XX[*].PONumber1[1]') FROM j_purchaseorder;
SELECT json_value(po_document, '$.XX[*].PONumber*') FROM j_purchaseorder;

---------------------------------------------------------------------------------------------------------

--head node is scaler
--* can not appear alone
--pass
truncate table j_purchaseorder;
INSERT INTO j_purchaseorder VALUES (
    SYS_GUID(),
    SYSTIMESTAMP,
    '123');
COMMIT;

SELECT json_value(po_document, '$[0]') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*]') FROM j_purchaseorder;
SELECT json_value(po_document, '$') FROM j_purchaseorder;

---------------------------------------------------------------------------------------------------------
--pass
truncate table j_purchaseorder;
INSERT INTO j_purchaseorder VALUES (
    SYS_GUID(),
    SYSTIMESTAMP,
    '[1,2,3,4,5,6]');
COMMIT;

SELECT json_value(po_document, '$[0]') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*]') FROM j_purchaseorder;
SELECT json_value(po_document, '$') FROM j_purchaseorder;

SELECT json_query(po_document, '$[0]') FROM j_purchaseorder;
SELECT json_query(po_document, '$[0,1]') FROM j_purchaseorder;
SELECT json_query(po_document, '$[*]') FROM j_purchaseorder;
SELECT json_query(po_document, '$') FROM j_purchaseorder;

--error
SELECT json_query(po_document, '$*') FROM j_purchaseorder;

---------------------------------------------------------------------------------------------------------
--pass 
truncate table j_purchaseorder;
INSERT INTO j_purchaseorder VALUES (
    SYS_GUID(),
    SYSTIMESTAMP,
    '[[1,2],[3,4]]');
COMMIT;

SELECT json_query(po_document, '$[*]') FROM j_purchaseorder;
SELECT json_query(po_document, '$[0]') FROM j_purchaseorder;
SELECT json_query(po_document, '$[0].[0]') FROM j_purchaseorder;
SELECT json_value(po_document, '$[0].[0]') FROM j_purchaseorder;
SELECT json_query(po_document, '$[0][0]') FROM j_purchaseorder;
SELECT json_value(po_document, '$[0][0]') FROM j_purchaseorder;
SELECT json_value(po_document, '$[0].*[0]') FROM j_purchaseorder;

--error
SELECT json_value(po_document, '$[0][0]') FROM j_purchaseorder;

---------------------------------------------------------------------------------------------------------
--pass 
truncate table j_purchaseorder;
INSERT INTO j_purchaseorder VALUES (
    SYS_GUID(),
    SYSTIMESTAMP,
    '[[[1,2],[3,4]],[[5,6],[7,8]]]');
COMMIT;

SELECT json_value(po_document, '$[0].*[0].*[0]') FROM j_purchaseorder;
SELECT json_value(po_document, '$[0].[0].[0]') FROM j_purchaseorder;
SELECT json_value(po_document, '$[0][0][0]') FROM j_purchaseorder;
SELECT json_query(po_document, '$[0].*[0]') FROM j_purchaseorder;

---------------------------------------------------------------------------------------------------------
--pass
truncate table j_purchaseorder;
INSERT INTO j_purchaseorder VALUES (
    SYS_GUID(),
    SYSTIMESTAMP,
    '{"XX":[1111]}');
COMMIT;

SELECT json_value(po_document, '$.XX[0]') FROM j_purchaseorder;
SELECT json_value(po_document, '$.XX[*]') FROM j_purchaseorder; 
SELECT json_value(po_document, '$.*[*]') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].*[*]') FROM j_purchaseorder;

---------------------------------------------------------------------------------------------------------
--pass
truncate table j_purchaseorder;
INSERT INTO j_purchaseorder VALUES (
    SYS_GUID(),
    SYSTIMESTAMP,
    '{"XX":[1111, 2222, 3333]}');
COMMIT;

SELECT json_value(po_document, '$.XX') FROM j_purchaseorder;
SELECT json_query(po_document, '$.XX') FROM j_purchaseorder;
SELECT json_value(po_document, '$.XX[*]') FROM j_purchaseorder;
SELECT json_value(po_document, '$.*[*]') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].*[*]') FROM j_purchaseorder;

---------------------------------------------------------------------------------------------------------
--func test
truncate table j_purchaseorder;
INSERT INTO j_purchaseorder VALUES (
    SYS_GUID(),
    SYSTIMESTAMP,
    '{"PONumber":66666, "PONumber1":8888.6666, "PONumber2":5459, "jdd":"I Love China...", "HJM":"you Love me..."}');
COMMIT;

SELECT json_value(po_document, '$[*].PONumber1') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].PONumber1.number()') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].PONumber1.upper()') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].PONumber1.ceiling()') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].PONumber1') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].  PONumber1') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*   ]. PONumber1   ') FROM j_purchaseorder;

SELECT json_value(po_document, '$[*].jdd') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].  jdd ') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].  jdd  .  upper  (    )  ') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].jdd.upper()') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].jdd') FROM j_purchaseorder;

SELECT json_value(po_document, '$[0].HJM') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].HJM.upper()') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].HJM.lower()') FROM j_purchaseorder;

SELECT json_value(po_document, '$[0].HJM.upper()?  (  @ > 0)', 'returning number') FROM j_purchaseorder;
SELECT json_value(po_document, '$[0].  HJM   .                                                                         upper  (      )  ?  (@ > 0)', 'returning number') FROM j_purchaseorder;
SELECT json_value(po_document, '$[0].  HJM    ?  (@ > 0)', 'returning number') FROM j_purchaseorder;

SELECT json_query(po_document, '$[0]') FROM j_purchaseorder;
SELECT json_query(po_document, '$[0 to 3]') FROM j_purchaseorder;
SELECT json_query(po_document, '$[1]') FROM j_purchaseorder;
SELECT json_query(po_document, '$[1 to 3]') FROM j_purchaseorder;
SELECT json_query(po_document, '$') FROM j_purchaseorder;
SELECT json_query(po_document, '$[to]') FROM j_purchaseorder;
SELECT json_query(po_document, '$[*]') FROM j_purchaseorder;

--error
SELECT json_value(po_document, '$[*].jdd?') FROM j_purchaseorder;
SELECT json_value(po_document, '$[0].HJM.upper()(@ > 0)' returning number) FROM j_purchaseorder;
SELECT json_value(po_document, '$[0].HJM?.upper()?(@ > 0)' returning number) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].PONumber1.ceiling(()') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].PONumber1.number().ceiling()') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].PONumber1') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].PONumber1.number()') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].jdd.upper().lower()') FROM j_purchaseorder;
SELECT json_value(po_document, '$[0].HJM.upper().lower()') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].jdd.upper()') FROM j_purchaseorder;
SELECT json_value(po_document, '$[0].HJM.upper()') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*  ].  jdd') FROM j_purchaseorder;
SELECT json_value(po_document, '$[0].HJM') FROM j_purchaseorder;

---------------------------------------------------------------------------------------------------------
--(JSON_MERGEPATH_TEST)
--func test
--pass
truncate table j_purchaseorder;
INSERT INTO j_purchaseorder VALUES (
    SYS_GUID(),
    SYSTIMESTAMP,
    '{"PONumber":66666, "PONumber1":8888.6, "PONumber2":5459, "jdd":"I Love China...", "HJM":"You Love Me..."}');
COMMIT;

--replace
select po_document from j_purchaseorder;
SELECT json_mergepatch(po_document, '{"PONumber2":123456}') FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '{"PONumber2":[1,2,3,4]}') FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '{"PONumber2":{"name":"jordon"}}') FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '{"HJM":true, "PONumber2":{"name":"jordon"}}') FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '{"PONumber1":{"name":"jordon"}}') FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '{"PONumber1":{"name":"jordon", "number":23, "dcfee":[5623,96,878]}}') FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '{"PONumber1":{"name":"jordon", "number":23, "hob":["ball","movie","reading",{"pat":[{"aa":23, "bb":96},9,6,7]}]}}') 
     as test_val FROM j_purchaseorder;

select json_value(test_val, '$.PONumber1.hob[0].upper()') from 
    (SELECT json_mergepatch(po_document, '{"PONumber1":{"name":"jordon", "number":23, "hob":["ball","movie","reading",{"pat":[{"aa":23, "bb":96},9,6,7]}]}}') 
     as test_val FROM j_purchaseorder);

select json_value(test_val, '$.PONumber1.hob[0]') from 
    (SELECT json_mergepatch(po_document, '{"PONumber1":{"name":"jordon", "number":23, "hob":["ball","movie","reading",{"pat":[{"aa":23, "bb":96},9,6,7]}]}}') 
     as test_val FROM j_purchaseorder);

select json_value(test_val, '$.PONumber2[3]') from 
    (SELECT json_mergepatch(po_document, '{"PONumber2":[1,2,3,4]}') 
     as test_val FROM j_purchaseorder);

select json_value(test_val, '$.PONumber1.hob[0]') from 
    (SELECT json_mergepatch(po_document, '{"PONumber1":{"name":"jordon", "number":23, "hob":["ball","movie","reading",{"pat":[{"aa":23, "bb":96},9,6,7]}]}}') 
     as test_val FROM j_purchaseorder);

select json_value(test_val, '$.PONumber1.hob[*].pat[*].aa') from 
    (SELECT json_mergepatch(po_document, '{"PONumber1":{"name":"jordon", "number":23, "hob":["ball","movie","reading",{"pat":[{"aa":"china no.1 !!!", "bb":"haHaFDfdgdfgFDgFSD"},9,6,7]}]}}') 
     as test_val FROM j_purchaseorder);

select json_value('{"PONumber":66666,"PONumber1":{"name":"jordon","number":23,"hob":["ball","movie","reading",{"pat":[{"aa":"china no.1 !!!","bb":"haHaFDfdgdfgFDgFSD"},9,6,7]}]},"PONumber2":[1,2,3,4],"jdd":"I Love China...","HJM":"You Love Me..."}', '$.PONumber1.hob[*].pat[0].aa') from dual;

select json_value(test_val, '$[0].HJM[*].lower()') from 
    (SELECT json_mergepatch(po_document, '{"PONumber1":{"name":"jordon", "number":23}}') 
     as test_val FROM j_purchaseorder);

select json_value(test_val, '$[0].HJM[*]') from 
    (SELECT json_mergepatch(po_document, '{"PONumber1":{"name":"jordon", "number":23}}') 
     as test_val FROM j_purchaseorder);

select json_value('{"PONumber":66666,"PONumber1":{"name":"jordon","number":23,"hob":["ball","movie","reading",{"pat":[{"aa":"china no.1 !!!","bb":"haHaFDfdgdfgFDgFSD"},9,6,7]}]},"PONumber2":[1,2,3,4],"jdd":"I Love China...","HJM":"You Love Me..."}', '$.PONumber1.hob[0].pat[0].aa') from dual;

select json_value('{"PONumber":66666,"PONumber1":{"name":"jordon","number":23,"hob":["ball","movie","reading",{"pat":[{"aa":"china no.1 !!!","bb":"haHaFDfdgdfgFDgFSD"},9,6,7]}]},"PONumber2":[1,2,3,4],"jdd":"I Love China...","HJM":"You Love Me..."}', '$.PONumber1.hob[*].pat[0].aa') from dual;

select json_value('{"PONumber":66666,"PONumber1":{"name":"jordon","number":23,"hob":["ball","movie","reading",{"pat":[{"aa":"china no.1 !!!","bb":"haHaFDfdgdfgFDgFSD"},9,6,7]}]},"PONumber2":[1,2,3,4],"jdd":"I Love China...","HJM":"You Love Me..."}', '$.PONumber1.hob[0].pat[*].aa') from dual;

select json_value('{"PONumber":66666,"PONumber1":{"name":"jordon","number":23,"hob":["ball","movie","reading",{"pat":[{"aa":"china no.1 !!!","bb":"haHaFDfdgdfgFDgFSD"},9,6,7]}]},"PONumber2":[1,2,3,4],"jdd":"I Love China...","HJM":"You Love Me..."}', '$.PONumber1.hob[*].pat[*].aa') from dual;

--replace
select json_mergepatch('{"User":"ABULL", "PONumber":1600}', '{"PONumber":99999}') from dual;
select json_mergepatch('{"PONumber":1600, "LineItems":[1, 2, 3]}', '{"LineItems":[4,5,6]}') from dual;

--deep test
select json_mergepatch('{"User":"ABULL", "PONumber":{"test":101, "A":256}, "test":101}', '{"PONumber":{"A":66}}') from dual;
select json_mergepatch('{"User":"ABULL", "PONumber":{"test":101, "A":{"test":101, "B":256}, "test":101}, "test":101}', '{"PONumber":{"A":{"B":66}}}') from dual;
select json_mergepatch('{"User":"ABULL", "PONumber":{"test":101, "A":{"test":101, "B":{"test":101, "C":256}, "test":101}, "test":101}, "test":101}', '{"PONumber":{"A":{"B":{"C":66}}}}') from dual;
select json_mergepatch('{"User":"ABULL", "PONumber":{"test":101, "A":{"test":101, "B":{"test":101, "C":{"test":101, "D":256}, "test":101}, "test":101}, "test":101}, "test":101}', '{"PONumber":{"A":{"B":{"C":{"D":66}}}}}') from dual;
select json_mergepatch('{"User":"ABULL", "PONumber":{"test":101, "A":{"test":101, "B":{"test":101, "C":{"test":101, "D":256}, "test":101}, "test":101}, "test":101}, "test":101}', '{"PONumber":{"A":{"B":{"C":{"D":66, "add":true}}}}}') from dual;
select json_mergepatch('{"User":"ABULL", "PONumber":{"test":101, "A":{"test":101, "B":{"test":101, "C":{"test":101, "D":256}, "test":101}, "test":101}, "test":101}, "test":101}', '{"PONumber":{"A":{"B":{"C":{"D":66, "add":true}, "add":true}}, "add":true}}') from dual;
select json_mergepatch('{"User":"ABULL", "PONumber":{"test":101, "A":{"test":101, "B":{"test":101, "C":{"test":101, "D":256}, "test":101}, "test":101}, "test":101}, "test":101}', '{"PONumber":{"A":{"B":{"C":{"D":null, "add":true}, "add":true}}, "add":true}}') from dual;
select json_mergepatch('{"User":"ABULL", "PONumber":{"test":101, "A":256}, "test":101}', '{"PONumber":{"A":66}, "User":NULL}') from dual;
select json_mergepatch('{"User":"ABULL", "PONumber":{"test":101, "A":256}, "test":101}', '{"PONumber":{"A":996}, "User":null}') from dual;

-- when path is scaler,should all output error
-- patch can not be null, true, false, number, string.  all error, but the target is null
---------------------
SELECT json_mergepatch(po_document, 123456) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '123456') FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '"123456"') FROM j_purchaseorder;
SELECT json_mergepatch(po_document, dsafdsfds) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, 'dsafdsfds') FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '"dsafdsfds"') FROM j_purchaseorder;
SELECT json_mergepatch(po_document, true) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, 'true') FROM j_purchaseorder
SELECT json_mergepatch(po_document, '"true"') FROM j_purchaseorder
SELECT json_mergepatch(po_document, false) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, 'false') FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '"false"') FROM j_purchaseorder;
SELECT json_mergepatch(po_document, null) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, 'null') FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '"null"') FROM j_purchaseorder;
SELECT json_mergepatch(po_document, NULL) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, 'NULL') FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '"NULL"') FROM j_purchaseorder;
SELECT json_mergepatch(po_document, sysdate) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, localtimestamp) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, current_timestamp) FROM j_purchaseorder;

SELECT json_mergepatch(po_document, 123456 error on error) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '123456' error on error) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '"123456"' error on error) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, true error on error) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, 'true' error on error) FROM j_purchaseorder
SELECT json_mergepatch(po_document, '"true"' error on error) FROM j_purchaseorder
SELECT json_mergepatch(po_document, false error on error) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, 'false' error on error) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '"false"' error on error) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, null error on error) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, 'null' error on error) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '"null"' error on error) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, NULL error on error) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, 'NULL' error on error) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '"NULL"' error on error) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, sysdate error on error) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, localtimestamp error on error) FROM j_purchaseorder;
SELECT json_mergepatch(po_document, current_timestamp error on error) FROM j_purchaseorder;
-------------------------------

select 1 from dual where 'NULL' is json;
select 1 from dual where 'null' is json;
select 1 from dual where 'true' is json;
select 1 from dual where 'true' is json;
select 1 from dual where 'false' is json;
select 1 from dual where 'FALSE' is json;

-- when patch is array, directly replace the target
SELECT json_mergepatch(po_document, '[2,1,5,6,8,9]') FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '["dsfds",1,5,"dsfds",8,"dsfds"]') FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '[2,"dsfds",5,6,"dsfds",9]') FROM j_purchaseorder;

--add
select json_mergepatch('{}', 123) from dual;
select json_mergepatch('{}', 123 error on error) from dual;
select json_mergepatch('{"PONumber":1600}', '{"tracking":123456}') from dual;
select json_mergepatch('{"PONumber":1600}', '{"tracking":123456, "pz":[0,1,2,3]}') from dual;
SELECT json_mergepatch(po_document, '{"tracking":123456}')   FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '{"tracking":null}')   FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '{"tracking":123456, "HUAWEI":"to be no.1"}')   FROM j_purchaseorder;

--delete
select json_mergepatch('{"PONumber":1600, "Reference":"ABULL-20140421"}', '{"Reference":null}') from dual;
SELECT json_mergepatch(po_document, '{"PONumber1":null}')   FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '{"PONumber2":null}')   FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '{"PONumber2":null, "PONumber1":null}')   FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '{"HJM":null, "PONumber1":null}')   FROM j_purchaseorder;

--Mixed scene from rfc
select json_mergepatch('{
     "a": "b",
     "c": {
       "d": "e",
       "f": "g"
     }
   }', 
   '{
     "a":"z",
     "c": {
       "f": null
     }
   }') as val from dual;
   
select json_mergepatch('{
     "title": "Goodbye!",
     "author" : {
       "givenName" : "John",
       "familyName" : "Doe"
     },
     "tags":[ "example", "sample" ],
     "content": "This will be unchanged"
   }', 
   '{
     "title": "Hello!",
     "phoneNumber": "+01-123-456-7890",
     "author": {
       "familyName": null
     },
     "tags": [ "example" ]
   }') as val from dual;

--other scene
--the target can be null
--when the target is null, and the patch is not null or string or clob, will raise error, otherwise return null
SELECT json_mergepatch(null, null) FROM j_purchaseorder;
SELECT json_mergepatch(null, 'null') FROM j_purchaseorder;
SELECT json_mergepatch(null, '"null"') FROM j_purchaseorder;
SELECT json_mergepatch(null, true) FROM j_purchaseorder;
SELECT json_mergepatch(null, 'true') FROM j_purchaseorder;
SELECT json_mergepatch(null, '"true"') FROM j_purchaseorder;
SELECT json_mergepatch(null, false) FROM j_purchaseorder;
SELECT json_mergepatch(null, 'false') FROM j_purchaseorder;
SELECT json_mergepatch(null, '"false"') FROM j_purchaseorder;
SELECT json_mergepatch(null, 123456) FROM j_purchaseorder;
SELECT json_mergepatch(null, '123456') FROM j_purchaseorder;
SELECT json_mergepatch(null, '"123456"') FROM j_purchaseorder;
SELECT json_mergepatch(null, sysdate) FROM j_purchaseorder;
SELECT json_mergepatch(null, localtimestamp) FROM j_purchaseorder;
SELECT json_mergepatch(null, current_timestamp) FROM j_purchaseorder;
SELECT json_mergepatch(null, '{}') FROM j_purchaseorder;
SELECT json_mergepatch(null, '{"assd":256}') FROM j_purchaseorder;
SELECT json_mergepatch(null, '[]') FROM j_purchaseorder;
SELECT json_mergepatch(null, '[2,1,5,6,8,9]') FROM j_purchaseorder;
SELECT json_mergepatch(null, '{}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch(null, '{"assd":256}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch(null, '[]' error on error) FROM j_purchaseorder;
SELECT json_mergepatch(null, '[2,1,5,6,8,9]' error on error) FROM j_purchaseorder;

--all error but the path is valid,return null ; when add on-error clasue will also raise error
SELECT json_mergepatch('null', null) FROM j_purchaseorder;
SELECT json_mergepatch('null', 'null') FROM j_purchaseorder;
SELECT json_mergepatch('null', '"null"') FROM j_purchaseorder;
SELECT json_mergepatch('null', true) FROM j_purchaseorder;
SELECT json_mergepatch('null', 'true') FROM j_purchaseorder;
SELECT json_mergepatch('null', '"true"') FROM j_purchaseorder;
SELECT json_mergepatch('null', false) FROM j_purchaseorder;
SELECT json_mergepatch('null', 'false') FROM j_purchaseorder;
SELECT json_mergepatch('null', '"false"') FROM j_purchaseorder;
SELECT json_mergepatch('null', 123456) FROM j_purchaseorder;
SELECT json_mergepatch('null', '123456') FROM j_purchaseorder;
SELECT json_mergepatch('null', '"123456"') FROM j_purchaseorder;
SELECT json_mergepatch('null', sysdate) FROM j_purchaseorder;
SELECT json_mergepatch('null', localtimestamp) FROM j_purchaseorder;
SELECT json_mergepatch('null', current_timestamp) FROM j_purchaseorder;
SELECT json_mergepatch('null', '{}') FROM j_purchaseorder;
SELECT json_mergepatch('null', '{"assd":256}') FROM j_purchaseorder;
SELECT json_mergepatch('null', '[]') FROM j_purchaseorder;
SELECT json_mergepatch('null', '[2,1,5,6,8,9]') FROM j_purchaseorder;
SELECT json_mergepatch('null', '{}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('null', '{"assd":256}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('null', '[]' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('null', '[2,1,5,6,8,9]' error on error) FROM j_purchaseorder;

--all error but the path is valid,return null ; when add on-error clasue will also raise error
SELECT json_mergepatch('"null"', null) FROM j_purchaseorder;
SELECT json_mergepatch('"null"', 'null') FROM j_purchaseorder;
SELECT json_mergepatch('"null"', '"null"') FROM j_purchaseorder;
SELECT json_mergepatch('"null"', true) FROM j_purchaseorder;
SELECT json_mergepatch('"null"', 'true') FROM j_purchaseorder;
SELECT json_mergepatch('"null"', '"true"') FROM j_purchaseorder;
SELECT json_mergepatch('"null"', false) FROM j_purchaseorder;
SELECT json_mergepatch('"null"', 'false') FROM j_purchaseorder;
SELECT json_mergepatch('"null"', '"false"') FROM j_purchaseorder;
SELECT json_mergepatch('"null"', 123456) FROM j_purchaseorder;
SELECT json_mergepatch('"null"', sysdate) FROM j_purchaseorder;
SELECT json_mergepatch('"null"', localtimestamp) FROM j_purchaseorder;
SELECT json_mergepatch('"null"', current_timestamp) FROM j_purchaseorder;
SELECT json_mergepatch('"null"', '123456') FROM j_purchaseorder;
SELECT json_mergepatch('"null"', '"123456"') FROM j_purchaseorder;
SELECT json_mergepatch('"null"', '{}') FROM j_purchaseorder;
SELECT json_mergepatch('"null"', '{"assd":256}') FROM j_purchaseorder;
SELECT json_mergepatch('"null"', '[]') FROM j_purchaseorder;
SELECT json_mergepatch('"null"', '[2,1,5,6,8,9]') FROM j_purchaseorder;
SELECT json_mergepatch('"null"', '{}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('"null"', '{"assd":256}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('"null"', '[]' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('"null"', '[2,1,5,6,8,9]' error on error) FROM j_purchaseorder;


--target can be scaler
SELECT json_mergepatch(123456, null) FROM j_purchaseorder;
SELECT json_mergepatch(123456, 'null') FROM j_purchaseorder;
SELECT json_mergepatch(123456, '"null"') FROM j_purchaseorder;
SELECT json_mergepatch(123456, true) FROM j_purchaseorder;
SELECT json_mergepatch(123456, 'true') FROM j_purchaseorder;
SELECT json_mergepatch(123456, '"true"') FROM j_purchaseorder;
SELECT json_mergepatch(123456, false) FROM j_purchaseorder;
SELECT json_mergepatch(123456, 'false') FROM j_purchaseorder;
SELECT json_mergepatch(123456, '"false"') FROM j_purchaseorder;
SELECT json_mergepatch(123456, 123456) FROM j_purchaseorder;
SELECT json_mergepatch(123456, '123456') FROM j_purchaseorder;
SELECT json_mergepatch(123456, '"123456"') FROM j_purchaseorder;
SELECT json_mergepatch(123456, '{}') FROM j_purchaseorder;
SELECT json_mergepatch(123456, '{"assd":256}') FROM j_purchaseorder;
SELECT json_mergepatch(123456, '[]') FROM j_purchaseorder;
SELECT json_mergepatch(123456, '[2,1,5,6,8,9]') FROM j_purchaseorder;
SELECT json_mergepatch(123456, '{}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch(123456, '{"assd":256}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch(123456, '[]' error on error) FROM j_purchaseorder;
SELECT json_mergepatch(123456, '[2,1,5,6,8,9]' error on error) FROM j_purchaseorder;

SELECT json_mergepatch('123456', null) FROM j_purchaseorder;
SELECT json_mergepatch('123456', 'null') FROM j_purchaseorder;
SELECT json_mergepatch('123456', '"null"') FROM j_purchaseorder;
SELECT json_mergepatch('123456', true) FROM j_purchaseorder;
SELECT json_mergepatch('123456', 'true') FROM j_purchaseorder;
SELECT json_mergepatch('123456', '"true"') FROM j_purchaseorder;
SELECT json_mergepatch('123456', false) FROM j_purchaseorder;
SELECT json_mergepatch('123456', 'false') FROM j_purchaseorder;
SELECT json_mergepatch('123456', '"false"') FROM j_purchaseorder;
SELECT json_mergepatch('123456', 123456) FROM j_purchaseorder;
SELECT json_mergepatch('123456', '123456') FROM j_purchaseorder;
SELECT json_mergepatch('123456', '"123456"') FROM j_purchaseorder;
SELECT json_mergepatch('123456', '{}') FROM j_purchaseorder;
SELECT json_mergepatch('123456', '{"assd":256}') FROM j_purchaseorder;
SELECT json_mergepatch('123456', '[]') FROM j_purchaseorder;
SELECT json_mergepatch('123456', '[2,1,5,6,8,9]') FROM j_purchaseorder;
SELECT json_mergepatch('123456', '{}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('123456', '{"assd":256}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('123456', '[]' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('123456', '[2,1,5,6,8,9]' error on error) FROM j_purchaseorder;

SELECT json_mergepatch('"123456"', null) FROM j_purchaseorder;
SELECT json_mergepatch('"123456"', 'null') FROM j_purchaseorder;
SELECT json_mergepatch('"123456"', '"null"') FROM j_purchaseorder;
SELECT json_mergepatch('"123456"', true) FROM j_purchaseorder;
SELECT json_mergepatch('"123456"', 'true') FROM j_purchaseorder;
SELECT json_mergepatch('"123456"', '"true"') FROM j_purchaseorder;
SELECT json_mergepatch('"123456"', false) FROM j_purchaseorder;
SELECT json_mergepatch('"123456"', 'false') FROM j_purchaseorder;
SELECT json_mergepatch('"123456"', '"false"') FROM j_purchaseorder;
SELECT json_mergepatch('"123456"', 123456) FROM j_purchaseorder;
SELECT json_mergepatch('"123456"', '123456') FROM j_purchaseorder;
SELECT json_mergepatch('"123456"', '"123456"') FROM j_purchaseorder;
SELECT json_mergepatch('"123456"', '{}') FROM j_purchaseorder;
SELECT json_mergepatch('"123456"', '{"assd":256}') FROM j_purchaseorder;
SELECT json_mergepatch('"123456"', '[]') FROM j_purchaseorder;
SELECT json_mergepatch('"123456"', '[2,1,5,6,8,9]') FROM j_purchaseorder;
SELECT json_mergepatch('"123456"', '{}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('"123456"', '{"assd":256}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('"123456"', '[]' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('"123456"', '[2,1,5,6,8,9]' error on error) FROM j_purchaseorder;


SELECT json_mergepatch('true', null) FROM j_purchaseorder;
SELECT json_mergepatch('true', 'null') FROM j_purchaseorder;
SELECT json_mergepatch('true', '"null"') FROM j_purchaseorder;
SELECT json_mergepatch('true', true) FROM j_purchaseorder;
SELECT json_mergepatch('true', 'true') FROM j_purchaseorder;
SELECT json_mergepatch('true', '"true"') FROM j_purchaseorder;
SELECT json_mergepatch('true', false) FROM j_purchaseorder;
SELECT json_mergepatch('true', 'false') FROM j_purchaseorder;
SELECT json_mergepatch('true', '"false"') FROM j_purchaseorder;
SELECT json_mergepatch('true', 123456) FROM j_purchaseorder;
SELECT json_mergepatch('true', '123456') FROM j_purchaseorder;
SELECT json_mergepatch('true', '"123456"') FROM j_purchaseorder;
SELECT json_mergepatch('true', '{}') FROM j_purchaseorder;
SELECT json_mergepatch('true', '{"assd":256}') FROM j_purchaseorder;
SELECT json_mergepatch('true', '[]') FROM j_purchaseorder;
SELECT json_mergepatch('true', '[2,1,5,6,8,9]') FROM j_purchaseorder;
SELECT json_mergepatch('true', '{}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('true', '{"assd":256}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('true', '[]' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('true', '[2,1,5,6,8,9]' error on error) FROM j_purchaseorder;

SELECT json_mergepatch('"true"', null) FROM j_purchaseorder;
SELECT json_mergepatch('"true"', 'null') FROM j_purchaseorder;
SELECT json_mergepatch('"true"', '"null"') FROM j_purchaseorder;
SELECT json_mergepatch('"true"', true) FROM j_purchaseorder;
SELECT json_mergepatch('"true"', 'true') FROM j_purchaseorder;
SELECT json_mergepatch('"true"', '"true"') FROM j_purchaseorder;
SELECT json_mergepatch('"true"', false) FROM j_purchaseorder;
SELECT json_mergepatch('"true"', 'false') FROM j_purchaseorder;
SELECT json_mergepatch('"true"', '"false"') FROM j_purchaseorder;
SELECT json_mergepatch('"true"', 123456) FROM j_purchaseorder;
SELECT json_mergepatch('"true"', '123456') FROM j_purchaseorder;
SELECT json_mergepatch('"true"', '"123456"') FROM j_purchaseorder;
SELECT json_mergepatch('"true"', '{}') FROM j_purchaseorder;
SELECT json_mergepatch('"true"', '{"assd":256}') FROM j_purchaseorder;
SELECT json_mergepatch('"true"', '[]') FROM j_purchaseorder;
SELECT json_mergepatch('"true"', '[2,1,5,6,8,9]') FROM j_purchaseorder;
SELECT json_mergepatch('"true"', '{}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('"true"', '{"assd":256}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('"true"', '[]' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('"true"', '[2,1,5,6,8,9]' error on error) FROM j_purchaseorder;

SELECT json_mergepatch('qsfregtghtrh', null) FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', 'null') FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', '"null"') FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', true) FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', 'true') FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', '"true"') FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', false) FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', 'false') FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', '"false"') FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', 123456) FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', '123456') FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', '"123456"') FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', '{}') FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', '{"assd":256}') FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', '[]') FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', '[2,1,5,6,8,9]') FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', '{}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', '{"assd":256}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', '[]' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', '[2,1,5,6,8,9]' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', '{}' null on error) FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', '{"assd":256}' null on error) FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', '[]' null on error) FROM j_purchaseorder;
SELECT json_mergepatch('qsfregtghtrh', '[2,1,5,6,8,9]' null on error) FROM j_purchaseorder;


SELECT json_mergepatch('"qsfregtghtrh"', null) FROM j_purchaseorder;
SELECT json_mergepatch('"qsfregtghtrh"', 'null') FROM j_purchaseorder;
SELECT json_mergepatch('"qsfregtghtrh"', '"null"') FROM j_purchaseorder;
SELECT json_mergepatch('"qsfregtghtrh"', true) FROM j_purchaseorder;
SELECT json_mergepatch('"qsfregtghtrh"', 'true') FROM j_purchaseorder;
SELECT json_mergepatch('"qsfregtghtrh"', '"true"') FROM j_purchaseorder;
SELECT json_mergepatch('"qsfregtghtrh"', false) FROM j_purchaseorder;
SELECT json_mergepatch('"qsfregtghtrh"', 'false') FROM j_purchaseorder;
SELECT json_mergepatch('"qsfregtghtrh"', '"false"') FROM j_purchaseorder;
SELECT json_mergepatch('"qsfregtghtrh"', 123456) FROM j_purchaseorder;
SELECT json_mergepatch('"qsfregtghtrh"', '123456') FROM j_purchaseorder;
SELECT json_mergepatch('"qsfregtghtrh"', '"123456"') FROM j_purchaseorder;
SELECT json_mergepatch('"qsfregtghtrh"', '{}') FROM j_purchaseorder;
SELECT json_mergepatch('"qsfregtghtrh"', '{"assd":256}') FROM j_purchaseorder;
SELECT json_mergepatch('"qsfregtghtrh"', '[]') FROM j_purchaseorder;
SELECT json_mergepatch('"qsfregtghtrh"', '[2,1,5,6,8,9]') FROM j_purchaseorder;
SELECT json_mergepatch('"qsfregtghtrh"', '{}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('"qsfregtghtrh"', '{"assd":256}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('"qsfregtghtrh"', '[]' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('"qsfregtghtrh"', '[2,1,5,6,8,9]' error on error) FROM j_purchaseorder;

-- the same as null
SELECT json_mergepatch('', null) FROM j_purchaseorder;
SELECT json_mergepatch('', 'null') FROM j_purchaseorder;
SELECT json_mergepatch('', '"null"') FROM j_purchaseorder;
SELECT json_mergepatch('', true) FROM j_purchaseorder;
SELECT json_mergepatch('', 'true') FROM j_purchaseorder;
SELECT json_mergepatch('', '"true"') FROM j_purchaseorder;
SELECT json_mergepatch('', false) FROM j_purchaseorder;
SELECT json_mergepatch('', 'false') FROM j_purchaseorder;
SELECT json_mergepatch('', '"false"') FROM j_purchaseorder;
SELECT json_mergepatch('', 123456) FROM j_purchaseorder;
SELECT json_mergepatch('', '123456') FROM j_purchaseorder;
SELECT json_mergepatch('', '"123456"') FROM j_purchaseorder;
SELECT json_mergepatch('', '{}') FROM j_purchaseorder;
SELECT json_mergepatch('', '{"assd":256}') FROM j_purchaseorder;
SELECT json_mergepatch('', '[]') FROM j_purchaseorder;
SELECT json_mergepatch('', '[2,1,5,6,8,9]') FROM j_purchaseorder;
SELECT json_mergepatch('', '{}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('', '{"assd":256}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('', '[]' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('', '[2,1,5,6,8,9]' error on error) FROM j_purchaseorder;

--the target is array , the path can not be scaler
SELECT json_mergepatch('[]', null) FROM j_purchaseorder;
SELECT json_mergepatch('[]', 'null') FROM j_purchaseorder;
SELECT json_mergepatch('[]', '"null"') FROM j_purchaseorder;
SELECT json_mergepatch('[]', true) FROM j_purchaseorder;
SELECT json_mergepatch('[]', 'true') FROM j_purchaseorder;
SELECT json_mergepatch('[]', '"true"') FROM j_purchaseorder;
SELECT json_mergepatch('[]', false) FROM j_purchaseorder;
SELECT json_mergepatch('[]', 'false') FROM j_purchaseorder;
SELECT json_mergepatch('[]', '"false"') FROM j_purchaseorder;
SELECT json_mergepatch('[]', 123456) FROM j_purchaseorder;
SELECT json_mergepatch('[]', '123456') FROM j_purchaseorder;
SELECT json_mergepatch('[]', '"123456"') FROM j_purchaseorder;
SELECT json_mergepatch('[]', '{}') FROM j_purchaseorder;
SELECT json_mergepatch('[]', '{"assd":256}') FROM j_purchaseorder;
SELECT json_mergepatch('[]', '[]') FROM j_purchaseorder;
SELECT json_mergepatch('[]', '[2,1,5,6,8,9]') FROM j_purchaseorder;
SELECT json_mergepatch('[]', '{}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('[]', '{"assd":256}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('[]', '[]' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('[]', '[2,1,5,6,8,9]' error on error) FROM j_purchaseorder;

--the target is array , the path can not be scaler
SELECT json_mergepatch('[1,2,3,4,5,6]', null) FROM j_purchaseorder;
SELECT json_mergepatch('[1,2,3,4,5,6]', 'null') FROM j_purchaseorder;
SELECT json_mergepatch('[1,2,3,4,5,6]', '"null"') FROM j_purchaseorder;
SELECT json_mergepatch('[1,2,3,4,5,6]', true) FROM j_purchaseorder;
SELECT json_mergepatch('[1,2,3,4,5,6]', 'true') FROM j_purchaseorder;
SELECT json_mergepatch('[1,2,3,4,5,6]', '"true"') FROM j_purchaseorder;
SELECT json_mergepatch('[1,2,3,4,5,6]', false) FROM j_purchaseorder;
SELECT json_mergepatch('[1,2,3,4,5,6]', 'false') FROM j_purchaseorder;
SELECT json_mergepatch('[1,2,3,4,5,6]', '"false"') FROM j_purchaseorder;
SELECT json_mergepatch('[1,2,3,4,5,6]', 123456) FROM j_purchaseorder;
SELECT json_mergepatch('[1,2,3,4,5,6]', '123456') FROM j_purchaseorder;
SELECT json_mergepatch('[1,2,3,4,5,6]', '"123456"') FROM j_purchaseorder;
SELECT json_mergepatch('[1,2,3,4,5,6]', '{}') FROM j_purchaseorder;
SELECT json_mergepatch('[1,2,3,4,5,6]', '{"assd":256}') FROM j_purchaseorder;
SELECT json_mergepatch('[1,2,3,4,5,6]', '[]') FROM j_purchaseorder;
SELECT json_mergepatch('[1,2,3,4,5,6]', '[2,1,5,6,8,9]') FROM j_purchaseorder;
SELECT json_mergepatch('[1,2,3,4,5,6]', '{}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('[1,2,3,4,5,6]', '{"assd":256}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('[1,2,3,4,5,6]', '[]' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('[1,2,3,4,5,6]', '[2,1,5,6,8,9]' error on error) FROM j_purchaseorder;


SELECT json_mergepatch('{}', null) FROM j_purchaseorder;
SELECT json_mergepatch('{}', 'null') FROM j_purchaseorder;
SELECT json_mergepatch('{}', '"null"') FROM j_purchaseorder;
SELECT json_mergepatch('{}', true) FROM j_purchaseorder;
SELECT json_mergepatch('{}', 'true') FROM j_purchaseorder;
SELECT json_mergepatch('{}', '"true"') FROM j_purchaseorder;
SELECT json_mergepatch('{}', false) FROM j_purchaseorder;
SELECT json_mergepatch('{}', 'false') FROM j_purchaseorder;
SELECT json_mergepatch('{}', '"false"') FROM j_purchaseorder;
SELECT json_mergepatch('{}', 123456) FROM j_purchaseorder;
SELECT json_mergepatch('{}', '123456') FROM j_purchaseorder;
SELECT json_mergepatch('{}', '"123456"') FROM j_purchaseorder;
SELECT json_mergepatch('{}', '{}') FROM j_purchaseorder;
SELECT json_mergepatch('{}', '{"assd":256}') FROM j_purchaseorder;
SELECT json_mergepatch('{}', '[]') FROM j_purchaseorder;
SELECT json_mergepatch('{}', '[2,1,5,6,8,9]') FROM j_purchaseorder;
SELECT json_mergepatch('{}', '{}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('{}', '{"assd":256}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('{}', '[]' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('{}', '[2,1,5,6,8,9]' error on error) FROM j_purchaseorder;

SELECT json_mergepatch('{"name":"fdgd"}', null) FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', 'null') FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', '"null"') FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', true) FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', 'true') FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', '"true"') FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', false) FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', 'false') FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', '"false"') FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', 123456) FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', '123456') FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', '"123456"') FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', '{}') FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', '{"assd":256}') FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', '[]') FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', '[2,1,5,6,8,9]') FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', '{}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', '{"assd":256}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', '[]' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', '[2,1,5,6,8,9]' error on error) FROM j_purchaseorder;


--error target json format
SELECT json_mergepatch('{"name" "fdgd"}', null) FROM j_purchaseorder;
SELECT json_mergepatch('{"name" "fdgd"}', 'null') FROM j_purchaseorder;
SELECT json_mergepatch('{"name" "fdgd"}', '"null"') FROM j_purchaseorder;
SELECT json_mergepatch('{"name" "fdgd"}', true) FROM j_purchaseorder;
SELECT json_mergepatch('{"name" "fdgd"}', 'true') FROM j_purchaseorder;
SELECT json_mergepatch('{"name" "fdgd"}', '"true"') FROM j_purchaseorder;
SELECT json_mergepatch('{"name" "fdgd"}', false) FROM j_purchaseorder;
SELECT json_mergepatch('{"name" "fdgd"}', 'false') FROM j_purchaseorder;
SELECT json_mergepatch('{"name" "fdgd"}', '"false"') FROM j_purchaseorder;
SELECT json_mergepatch('{"name" "fdgd"}', 123456) FROM j_purchaseorder;
SELECT json_mergepatch('{"name" "fdgd"}', '123456') FROM j_purchaseorder;
SELECT json_mergepatch('{"name" "fdgd"}', '"123456"') FROM j_purchaseorder;
SELECT json_mergepatch('{"name" "fdgd"}', '{}') FROM j_purchaseorder;
SELECT json_mergepatch('{"name" "fdgd"}', '{"assd":256}') FROM j_purchaseorder;
SELECT json_mergepatch('{"name" "fdgd"}', '[]') FROM j_purchaseorder;
SELECT json_mergepatch('{"name" "fdgd"}', '[2,1,5,6,8,9]') FROM j_purchaseorder;
SELECT json_mergepatch('{"name" "fdgd"}', '{}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('{"name" "fdgd"}', '{"assd":256}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('{"name" "fdgd"}', '[]' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('{"name" "fdgd"}', '[2,1,5,6,8,9]' error on error) FROM j_purchaseorder;

--error path json format
SELECT json_mergepatch('{"name":"fdgd"}', '}') FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', '"assd":256}') FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', ']') FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', '2,1,5,6,8,9]') FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', '}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', '"assd":256}' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', ']' error on error) FROM j_purchaseorder;
SELECT json_mergepatch('{"name":"fdgd"}', '2,1,5,6,8,9]' error on error) FROM j_purchaseorder;


SELECT json_mergepatch('{}', null) FROM j_purchaseorder;
SELECT json_mergepatch('{}', '[]') FROM j_purchaseorder;
SELECT json_mergepatch('[]', '{}') FROM j_purchaseorder;
SELECT json_mergepatch('{}', '{}') FROM j_purchaseorder;
SELECT json_mergepatch('[]', '[]') FROM j_purchaseorder;

select json_mergepatch('[1,2,3]', 123) from dual;
select json_mergepatch('[1,2,3]', '[6,8]') from dual;
select json_mergepatch(123, '[6,8]') from dual;
select json_mergepatch(123, 123) from dual;
select json_mergepatch(123, 'true') from dual;
select json_mergepatch(123, true) from dual;
select json_mergepatch(123, 'null') from dual;
select json_mergepatch(123, null) from dual;

SELECT json_mergepatch(null, sysdate) FROM j_purchaseorder;
SELECT json_mergepatch(null, localtimestamp) FROM j_purchaseorder;
SELECT json_mergepatch(null, current_timestamp) FROM j_purchaseorder;
SELECT json_mergepatch(null, sysdate error on error) FROM j_purchaseorder;
SELECT json_mergepatch(null, localtimestamp error on error) FROM j_purchaseorder;
SELECT json_mergepatch(null, current_timestamp error on error) FROM j_purchaseorder;

SELECT json_mergepatch('"null"', sysdate) FROM j_purchaseorder;
SELECT json_mergepatch('"null"', localtimestamp) FROM j_purchaseorder;
SELECT json_mergepatch('"null"', current_timestamp) FROM j_purchaseorder;
SELECT json_mergepatch('"null"', sysdate error on error) FROM j_purchaseorder;
SELECT json_mergepatch('"null"', localtimestamp error on error) FROM j_purchaseorder;
SELECT json_mergepatch('"null"', current_timestamp error on error) FROM j_purchaseorder;

SELECT json_mergepatch(sysdate, '[]') FROM j_purchaseorder;
SELECT json_mergepatch(localtimestamp, '[]') FROM j_purchaseorder;
SELECT json_mergepatch(current_timestamp, '[]') FROM j_purchaseorder;
SELECT json_mergepatch(sysdate, '[]' error on error) FROM j_purchaseorder;
SELECT json_mergepatch(localtimestamp, '[]' error on error) FROM j_purchaseorder;
SELECT json_mergepatch(current_timestamp, '[]' error on error) FROM j_purchaseorder;


---------------------------------------------------------------------------------------------------------
--func test
--pass
truncate table j_purchaseorder;
INSERT INTO j_purchaseorder VALUES (
    SYS_GUID(),
    SYSTIMESTAMP,
    '{"PONumber":66666,"PONumber1":{"name":"jordon","aa":"fgfddffdfddf","number":23,"hob":["ball","movie","reading",{"pat":[{"aa":"china no.1 !!!","bb":"haHaFDfdgdfgFDgFSD"},9,6,7]}]},"PONumber2":[1,2,3,4],"aa":555,"jdd":"I Love China...","HJM":"You Love Me..."}');
COMMIT;

select po_document from j_purchaseorder;
SELECT json_mergepatch(po_document, '{"PONumber":8888}') FROM j_purchaseorder;
SELECT json_mergepatch(po_document, '{"aa":123456}') FROM j_purchaseorder;
SELECT json_set(po_document, '$.aa', '123456') FROM j_purchaseorder;
SELECT json_set(po_document, '$.PONumber', '8888') FROM j_purchaseorder;
SELECT json_set(po_document, '$.PONumberrrrr', '8888') FROM j_purchaseorder;
SELECT json_set(po_document, '$.PONumber1.hob[*].pat[*].aa') FROM j_purchaseorder;
SELECT json_set(po_document, '$.PONumber2', '[5]') FROM j_purchaseorder;
SELECT json_set(po_document, '$.PONumber2', '[36, 89, 26, true]') FROM j_purchaseorder;
SELECT json_set(po_document, '$.PONumber2', '[]') FROM j_purchaseorder;
SELECT json_set(po_document, '$.PONumber2', '[2]') FROM j_purchaseorder;

select json_query(po_document, '$[0]' error on error) from j_purchaseorder;
SELECT json_set(po_document, '$.[0]', '[5]') FROM j_purchaseorder;

SELECT json_value('[5]', '$') from dual;
SELECT json_value('[36]', '$') from dual;
SELECT json_value('[]', '$') from dual;
SELECT json_value('[2]', '$') from dual;

SELECT json_value('[5]', '$[*]') from dual;
SELECT json_value('[36]', '$[*]') from dual;
SELECT json_value('[]', '$[*]') from dual;
SELECT json_value('[2]', '$[*]') from dual;

SELECT json_value('[5, 7]', '$[*]') from dual;
SELECT json_value('[36, 7]', '$[*]') from dual;
SELECT json_value('[]', '$[*]') from dual;
SELECT json_value('[2, 7]', '$[*]') from dual;

SELECT json_query('[5]', '$') from dual;
SELECT json_query('[36]', '$') from dual;
SELECT json_query('[]', '$') from dual;
SELECT json_query('[2]', '$') from dual;

SELECT json_query('[5]', '$[*]') from dual;
SELECT json_query('[36]', '$[*]') from dual;
SELECT json_query('[]', '$[*]') from dual;
SELECT json_query('[2]', '$[*]') from dual;


SELECT json_value('[1,2,[3,4,{"num":[5,6,7,{"aa":8}]}]]', '$[*].*[*].num.aa') from dual;
SELECT json_value('[1,2,[3,4,{"num":[5,6,7,{"aa":8}]}]]', '$[*].*[*].num[3].aa') from dual;
SELECT json_value('[1,2,[3,4,{"num":[5,6,7,{"aa":8}]}]]', '$[*].*[*].num[*].aa') from dual;
SELECT json_value('[1,2,[3,4,{"num":[5,6,7,{"aa":8}]}]]', '$[*].*[*].*[*].aa') from dual;

SELECT json_value('[1,2,[3,4,{"num":[5,6,7,{"aa":8}]}]]', '$[*].*.num[3].aa') from dual;
SELECT json_value('[1,2,[3,4,{"num":[5,6,7,{"aa":8}]}]]', '$[*].[*].num[3].aa') from dual;
SELECT json_value('[1,2,[3,4,{"num":[5,6,7,{"aa":8}]}]]', '$[*][*].num[3].aa') from dual;
SELECT json_value('[1,2,[3,4,{"num":[5,6,7,{"aa":8}]}]]', '$[*].*[*].num[3].aa') from dual;


--orcale
SELECT json_value('[1,2,[3,4,{"num":[5,6,7,{"aa":8}]}]]', '$[*][*].num.aa') from dual;
SELECT json_value('[1,2,[3,4,{"num":[5,6,7,{"aa":8}]}]]', '$[*][*].num[*].aa') from dual;
SELECT json_value('[1,2,[3,4,{"num":[5,6,7,{"aa":8}]}]]', '$[*][*].*[*].aa') from dual;
SELECT json_value('[1,2,[3,4,{"num":[5,6,7,{"aa":8}]}]]', '$[*][*].num[3].aa') from dual;
SELECT json_value('[1,2,[3,4,{"num":[5,6,7,{"aa":8}]}]]', '$.num[3].aa') from dual;



---------------------------------------------------------------------------------------------------------
--* can not appear alone
truncate table j_purchaseorder;
INSERT INTO j_purchaseorder VALUES (
    SYS_GUID(),
    SYSTIMESTAMP,
    '{"XX":[1111, 2222, 3333]}');
COMMIT;

select json_array(11,22,33) from dual;
select json_array('11','22','33') from dual;
select json_array('11','22','[33,44]', 55) from dual;
select json_array('11','22   ','[11,  11,[22,   22,[33,   33,[   44,   44]]]]') from dual;
select json_array('true','22','false','"true"','"false"') from dual;

select json_array('"11"','22','"33"','"aaBB"') from dual;
select json_array('"11"','"22"','[33,44]') from dual;
select json_array('"11"','"22   "','[11,  11,[22,   "22"     ,[33,   "33",[   44,   44]]]]') from dual;
select json_array('true','22','false','{"GG":[1,2.3,5]}') from dual;

select json_query(json_array('true','22','false','{"GG":[1,2.3,5]}'), '$[*].GG') from dual;
select json_value(json_array('true','22','false','{"GG":[1,2.3,5]}'), '$[*].GG[1]') from dual;

select json_object('{"a":11}','{"b":22}','{"c":33}', '{"fdd":55, "sdds":85}') from dual;
select json_object('{"a":11}','{"b":22}','{"c":33}', '{"aaaa":{"fdd":55, "sdds":85}}') from dual;

select json_query(json_object('{"a":11}','{"b":22}','{"c":33}', '{"aaaa":{"fdd":55, "sdds":85}}'), '$[*].aaaa') from dual;
select json_value(json_object('{"a":11}','{"b":22}','{"c":33}', '{"aaaa":{"fdd":55, "sdds":85}}'), '$[*].aaaa.sdds') from dual;

--error
select json_object('11','22','[33,44]','true') from dual;
select json_object('11','22','[11,11,[22,22,[33,33,[44,44]]]]') from dual;

---------------------------------------------------------------------------------------------------------
--* path expr cluse and filter expr are Reserved
truncate table j_purchaseorder;
INSERT INTO j_purchaseorder VALUES (
    SYS_GUID(),
    SYSTIMESTAMP,
    '{"XX":[1111, 2222, 3333, {"name":"jdd"}]}');
COMMIT;

SELECT json_value(po_document, '$[*].XX[2]') FROM j_purchaseorder;
SELECT json_query(po_document, '$[*].XX') FROM j_purchaseorder;
SELECT json_query(po_document, '$[*].XX[*]') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[*].name.upper()') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[2 , to ].name.upper()') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[2 to 3].name.upper()') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[*].name') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[2 , to ].name') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[2 to 3].name') FROM j_purchaseorder;
SELECT json_query(po_document, '$[*].XX[3]') FROM j_purchaseorder;

SELECT json_value(po_document, '$[*].XX[0]') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)') FROM j_purchaseorder;

--pass
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' null on error) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)'  empty on error) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)'  empty on error error on empty ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)'  empty on error true on empty ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)'  false on error error on empty ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)'  empty on error null on empty ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)'  empty on error error on empty ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)'   false on error null on empty ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' null on error) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' null on empty ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' false on empty ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' null on empty ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' error on error ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' empty on error    ) FROM j_purchaseorder;

SELECT json_value(po_document, '$[1].XX[0]?(@.name > 0)' empty on error error on empty ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[1].XX[0]?(@.name > 0)' empty on error true on empty ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[1].XX[0]?(@.name > 0)' empty on error false on empty ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[1].XX[0]?(@.name > 0)' empty on error null on empty ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[1].XX'  empty on error false on empty ) FROM j_purchaseorder;

SELECT json_value(po_document, '$[1].XX[0]?' empty on error) FROM j_purchaseorder;
SELECT json_value(po_document, '$[1].XX[0]?' null on error) FROM j_purchaseorder;
SELECT json_value(po_document, '$[1].XX[0]?' true on error) FROM j_purchaseorder;
SELECT json_value(po_document, '$[1].XX[0]?' false on error) FROM j_purchaseorder;
SELECT json_value(po_document, '$[1].XX[0]?' error on error) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[*].name.upper()()' empty object on error) FROM j_purchaseorder;

SELECT json_query(po_document, '$[1]' empty on empty) FROM j_purchaseorder;
SELECT json_query(po_document, '$[1]' true on empty) FROM j_purchaseorder;
SELECT json_query(po_document, '$[1]' false on empty) FROM j_purchaseorder;
SELECT json_query(po_document, '$[1]' null on empty) FROM j_purchaseorder;
SELECT json_value(po_document, '$[X]??(@.name > 0)' empty array on error  ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[X]??(@.name > 0)' empty object on error  ) FROM j_purchaseorder;

--error
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' returning numberdd) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' dd numberdd) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' returning number empty) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' dd numberdd) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' returning cc number empty on error error on empty ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' returning number empty) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' returning number false on error gg error on empty ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' returning number empty on error null on) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' returning number empty on error error on empty null on mismatch WITH time) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' returning timestamp with local WRAPPER ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' returning timestamp with time  with WRAPPER ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' returning  varchar2 with time zone without WRAPPER ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' returning date with time zone without WRAPPER ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' date with time zone without WRAPPER ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' zone without WRAPPER ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[0]?(@.name > 0)' error on ) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[*].name' error on error) FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].XX[*].name' number error on error) FROM j_purchaseorder;

---------------------------------------------------------------------------------------------------------
--* path expr path is valid
truncate table j_purchaseorder;
INSERT INTO j_purchaseorder VALUES (
    SYS_GUID(),
    SYSTIMESTAMP,
    '{"XX":[1111, [55, true, {"AA":{"c":76, "d":88}}], 3333, {"name":"jdd"}]}');
COMMIT;

select json_query(po_document, '$[to]') FROM j_purchaseorder;
select json_value(po_document, '$[to].XX[0]') FROM j_purchaseorder;
select json_query(po_document, '$[to].XX[1]') FROM j_purchaseorder;
select json_query(po_document, '$[to].XX[3]') FROM j_purchaseorder;
select json_value(po_document, '$[to].XX[3].name.upper()') FROM j_purchaseorder;
select json_value(po_document, '$[to].XX.name.upper()') FROM j_purchaseorder;
select json_value(po_document, '$[to].XX[3].name') FROM j_purchaseorder;
select json_value(po_document, '$[to].XX.name') FROM j_purchaseorder;
select json_value(po_document, '$[to].XX[1].[0]') FROM j_purchaseorder;
select json_value(po_document, '$[to].XX[1].[1]') FROM j_purchaseorder;
select json_query(po_document, '$[to].XX[1].[2]') FROM j_purchaseorder;
select json_value(po_document, '$[to].XX[1].*[0]') FROM j_purchaseorder;
select json_value(po_document, '$[to].XX[1].*[1]') FROM j_purchaseorder;
select json_query(po_document, '$[to].XX[1].*[2]') FROM j_purchaseorder;


select json_query('[]', '$') from dual;
select json_query('[]', '$[ to 5].[6].[1,1,1,5,6]') from dual;
select json_query('[]', '$%') from dual;
select json_query('[]', '$[5]..') from dual;
select json_query('[]', '$[5].') from dual;
select json_query('[]', '$[ to 5].[].[]') from dual;
select json_query('[]', '$[5],') from dual;
select json_query('[]', '$[5,,,,,]') from dual;
select json_query('[]', '$[ to 5].[8].[1,1,1,5,2]') from dual;
select json_query('[]', '$[ to 5].[6].[1,1,1,5,6]?') from dual;
select * from dual where 123 is json;
select * from dual where null is json;
select * from dual where '"123"' is json;
select * from dual where 'true' is json;

---------------------------------------------------------------------------------------------------------
SELECT JSON_QUERY('{}', '$') from dual;
SELECT JSON_QUERY('[]', '$') from dual;


select json_value(null,'$') from dual;
select length(json_value(null,'$')) from dual;
select 1 from dual where json_value(null,'$') is null;
select 1 from dual where length(json_value(null,'$')) is null;
SELECT JSON_QUERY('{}', '$') from dual;
SELECT JSON_QUERY('[]', '$') from dual;


select json_array('"asd"',221,96,to_clob('{"sddsdsssssssssssssss":56}')) from dual;


select json_value(null,'$') from dual;
SELECT json_value('[5]', '$') from dual;

select * from dual where 'name' is json;
select * from dual where '"name"' is json;

--same as orcale
select json_array(1   ,'[2,3]','[4,5,6]','7','"name"', 'true',null,true) from dual;
select json_array(1   ,'[2,3]','[4,5,6]',null,'7','"name"', 'true',null) from dual;
select json_array(1   ,'[2,3]','[4,5,6]','7','"name"', 'true', 'null') from dual;
select json_array(1   ,'[2,3]' format json,'[4,5,6]' format json,null,'7','"name"', 'true' format json,null) from dual;
select json_array(1   ,'[2,3]' format json,'[4,5,6]' format json,'7','"name"', 'true' format json, 'null') from dual;
select json_array(1,null,765) from dual;
select json_array(1 format json,null,765 format json) from dual;
select json_array(1,null format json,765) from dual;

--same as orcale
select json_array(true) from dual;
select json_array(true format json) from dual;
select json_array('true') from dual;
select json_array('true' format json) from dual;

--same as orcale
select json_array(null) from dual;
select json_array(null format json) from dual;
select json_array('null') from dual;
select json_array('null' format json) from dual;
select json_array(1,null ,3) from dual;
select json_array(1,null format json ,3) from dual;

--same as orcale
select json_array(123) from dual;
select json_array(123 format json) from dual;
select json_array('123') from dual;
select json_array('123' format json) from dual;
select json_array('123.321') from dual;
select json_array('123.321' format json) from dual;

--same as orcale
--select json_array(sysdate) from dual;
--select json_array(sysdate format json) from dual;

--zenith support tstz type
--select json_array(current_timestamp) from dual;
--select json_array(current_timestamp format json) from dual;

--diff cases
select json_array('name') from dual;
select json_array('name' format json) from dual;   --we think orcale output maybe a bug!!!
select json_array('"name"') from dual;             --zenith need add escape char
select json_array('"name"' format json) from dual;

--same as orcale
select json_array(1 format json, json_array(25, 26)) from dual;
select json_array(1 format json, json_array(25, json_array(5,8,9,10))) from dual;
select json_array(1 format json, json_array(json_value('[1,2,3]', '$[2]'), json_array(5,8,9,10))) from dual;
select json_array(1 format json, json_array(json_value('[1,2,3]', '$[2]') format json, json_array(5,8,9,10))) from dual;
select json_array(1 , json_array(json_value('[1,2,3]', '$[2]') format json, json_array(5,8,9,10))) from dual;
select json_array(1 , json_value('[1,2,3]', '$[2]')) from dual;
select json_array(1 , json_value('[1,2,3]', '$[2]') format json) from dual;

select json_value('[1,2,3]', '$[2]') from dual;
select json_array(json_value('[1,2,3]', '$[2]')) from dual;
select json_array(1, json_value('[1,2,3]', '$[2]')) from dual;
select json_array(json_query('[1,2,3]', '$')) from dual;
select json_array(1, json_query('[1,2,3]', '$')) from dual;
select json_array(json_array(json_value('[1,2,3]', '$[2]') format json, json_array(5,8,9,10))) from dual;

select json_array(1 ,'[2,3]','[4,5,6]' format json,'7','"name"', 'true',null) from dual;
select json_array(1,'[2,3]','[4,5,6]','7','"name"', 'true',null) from dual;

select json_array('"asd"' format json, 125 format json, 'true' format json) from dual;
select json_array('"asd"' format json, 5*8 format json, 'true' format json) from dual;
select json_value(json_array('"asd"' format json, 5*8 format json, 'true' format json), '$[1]') from dual;

select json_array(trim('          "asdsfds        "        ') format json, 5*8 format json, 'true' format json) from dual;

--select json_array(current_timestamp);
--select json_array(sysdate, 32, 32 format json) from dual;

--error
select json_array('"asd"' format json   125 format json, 'true' format json);
select json_array('"asd"' format json ,  125 dd format json, 'true' format json);
select json_array('"asd"' format json, 125 format json, 'true' format json,,);
select json_array(5*8 format json, 'true' format json, 8/2 format XX);
select json_array(5*8 format json, 'true' format json, 8/2  XX);

--ok
select json_object(key '"name"' is '"jdd"' format json) from dual;
select json_object('"name"' is '"jdd"' format json) from dual;
select json_object('"name"' is '"jdd"') from dual;
select json_object(key 'null' is '"jdd"' format json) from dual;
select json_object('null' is '"jdd"' format json) from dual;
select json_object('null' is '"jdd"' ) from dual;
select json_object(key 'true' is '"jdd"' format json) from dual;
select json_object('true' is '"jdd"' format json) from dual;
select json_object('true' is '"jdd"' ) from dual;
select json_object(key 'true' is '"jdd"' format json) from dual;
select json_object('false' is '"jdd"' format json) from dual;
select json_object('false' is '"jdd"' ) from dual;

select json_object(key '"name"' is '"jdd"' format json  ,  '"name"' is '"jdd"' format json  ,  '"name"' is '"jdd"') from dual;

select json_object(key '"name"' is '"jdd"' format json, key 'addr' is '{"a":21, "b":98}' format json) from dual;
select json_object('"name"' is '"jdd"' format json, 'addr' is '{"a":21, "b":98}' format json) from dual;
select json_object(key '"name"' is '"jdd"', key 'addr' is '{"a":21, "b":98}') from dual;

select json_object(null is '"jdd"' format json) from dual;
select json_object('name' is null format json, 'name1' is null format json) from dual;

select json_object('true' is '"jdd"' format json , 'false' is json_array(1 format json, json_array(25, json_array(5,8,9,10))) ) from dual;
select json_object('true' is '"jdd"' format json , 'false' is json_array(1 format json, json_array(25, json_array(5,8,9,10))) format json) from dual;

select json_object(key '"name"' is '"jdd"' format json) from dual;
select json_value(json_object(key '"name"' is '"jdd"' format json), '$.name') from dual;
select json_value(json_object(key '"name"' is '"jdd"' format json), '$."name"') from dual;
select json_value(json_object(key '"name"' is '"jdd"' format json), '$.\"name\"') from dual;
select json_value(json_object(key '"name"' is '"jdd"'), '$.name') from dual;

select json_object(key 'name' is '"jdd"' format json) from dual;
select json_value(json_object(key 'name' is '"jdd"' format json), '$.name') from dual;
select json_value(json_object(key 'name' is '"jdd"'), '$.name') from dual;
select json_value(json_object(key 'name' is 'jdd'), '$.name') from dual;

select json_object(key 'null' is '"jdd"' format json) from dual;

--scaler test
select json_object(key 'value' is true) from dual;
select json_object(key 'value' is true format json) from dual;
select json_object(key 'value' is false) from dual;
select json_object(key 'value' is false format json) from dual;
select json_object(key 'value' is 'true') from dual;
select json_object(key 'value' is 'true' format json) from dual;
select json_object(key 'value' is 'false') from dual;
select json_object(key 'value' is 'false' format json) from dual;
select json_object(key 'value' is '"true"') from dual;
select json_object(key 'value' is '"true"' format json) from dual;
select json_object(key 'value' is '"false"') from dual;
select json_object(key 'value' is '"false"' format json) from dual;

select json_object(key 'value' is 123) from dual;
select json_object(key 'value' is 123 format json) from dual;
select json_object(key 'value' is '123') from dual;
select json_object(key 'value' is '123' format json) from dual;
select json_object(key 'value' is '"123"') from dual;
select json_object(key 'value' is '"123"' format json) from dual;
select json_object(key 'value' is '123...85') from dual;
select json_object(key 'value' is '123...85' format json) from dual;
select json_object(key 'value' is '"123...85"') from dual;
select json_object(key 'value' is '"123...85"' format json) from dual;

select json_object(key 'value' is null) from dual;
select json_object(key 'value' is null format json) from dual;
select json_object(key 'value' is 'null') from dual;
select json_object(key 'value' is 'null' format json) from dual;
select json_object(key 'value' is '"null"') from dual;
select json_object(key 'value' is '"null"' format json) from dual;

select json_object(key 'value' is asdf) from dual;
select json_object(key 'value' is asdf format json) from dual;
select json_object(key 'value' is 'asdf') from dual;
select json_object(key 'value' is 'asdf' format json) from dual;
select json_object(key 'value' is '"asdf"') from dual;
select json_object(key 'value' is '"asdf"' format json) from dual;





--error
select json_object(key '"name"'  format json is '"jdd"' format json) from dual;
select json_object(key '"name"'  format  is '"jdd"' format json) from dual;
select json_object(key '"name"'  json  is '"jdd"' format json) from dual;

---------------------------------------------------------------------------------------------------------
SELECT json_mergepatch('{"PONumber":66666,"PONumber1":{"name":"jordon","aa":"fgfddffdfddf","number":23,"hob":["ball","movie","reading",{"pat":[{"aa":"china no.1 !!!","bb":"haHaFDfdgdfgFDgFSD"},9,6,7]}]},"PONumber2":[1,2,3,4],"aa":555,"jdd":"I Love China...","HJM":"You Love Me..."}', '{"aa":123456}') FROM dual;

SELECT json_set('{"PONumber":66666,"PONumber1":{"name":"jordon","aa":"fgfddffdfddf","number":23,"hob":["ball","movie","reading",{"pat":[{"aa":"china no.1 !!!","bb":"haHaFDfdgdfgFDgFSD"},9,6,7]}]},"PONumber2":[1,2,3,4],"aa":555,"jdd":"I Love China...","HJM":"You Love Me..."}', '$.PONumber', '8888') FROM dual;
SELECT json_set('{"PONumber":66666,"PONumber1":{"name":"jordon","aa":"fgfddffdfddf","number":23,"hob":["ball","movie","reading",{"pat":[{"aa":"china no.1 !!!","bb":"haHaFDfdgdfgFDgFSD"},9,6,7]}]},"PONumber2":[1,2,3,4],"aa":555,"jdd":"I Love China...","HJM":"You Love Me..."}', '$.PONumber1.hob[*].pat[*].aa', '123456') FROM dual;

---------------------------------------------------------------------------------------------------------
select json_value('{"asd":256}', '$.asd'error on error null on empty) from dual;
select json_value('{"asd":256}', '$.asd' error on error null on empty) from dual;
select json_value('{"asd":256}', '$.asd' error on error null on empty   ) from dual;
select json_value('{"asd":256}', '$.asd'   error    on    error null    on empty   ) from dual;
select json_value('{"asd":256}', '$....asd' true on error null on empty) from dual;



------------------------------------------  the first param of json_value and json_query is scalar
--null on error and null on empty  are default setting
-------------------------------------------------------------------------
--null
--run same as orcale
select json_value(null, '$') from dual;
select json_value(null, '$' error on error) from dual;
select json_query(null, '$') from dual;
select json_query(null, '$' error on error) from dual;

select 1 from dual where (select json_value(null, '$') from dual) is null;
select 1 from dual where (select json_value(null, '$' error on error) from dual) is null;

--run same as orcale
select json_value('null', '$') from dual;
select json_value('null', '$' error on error) from dual;
select json_query('null', '$') from dual;
select json_query('null', '$' error on error) from dual;

select json_value('"null"', '$') from dual;
select json_value('"null"', '$' error on error) from dual;
select json_query('"null"', '$') from dual;
select json_query('"null"', '$' error on error) from dual;

select json_value('""null""', '$') from dual;
select json_value('""null""', '$' error on error) from dual;
select json_query('""null""', '$') from dual;
select json_query('""null""', '$' error on error) from dual;

--However
select json_array(null, 'null', '"null"') from dual;
--["null","\"null\""]
select json_array(null format json, 'null' format json, '"null"' format json) from dual;
--[null,"null"]


-------------------------------------------------------------------------(SEARCH_POINT_SCALER_TEST)
--number
--orcale: inconsistent datatypes: expected - got NUMBER
--zenith: invalid input syntax for json, JSON syntax error, unexpected scaler value.
select json_value(123, '$') from dual;
select json_value(123, '$' error on error) from dual;
select json_query(123, '$') from dual;
select json_query(123, '$' error on error) from dual;

--run same as orcale
select json_value('123', '$') from dual;
select json_value('123', '$' error on error) from dual;
select json_query('123', '$') from dual;
select json_query('123', '$' error on error) from dual;

--run same as orcale
select json_value('"123"', '$') from dual;
select json_value('"123"', '$' error on error) from dual;
select json_query('"123"', '$') from dual;
select json_query('"123"', '$' error on error) from dual;

--However
select json_array(123, 'true', '"true"') from dual;
--[123,"true","\"true\""]
select json_array(123 format json, 'true' format json, '"true"' format json) from dual;
--[123,true,"true"]


-------------------------------------------------------------------------
--constant string
--run same as orcale
select json_value(asdfg, '$') from dual;
select json_value(asdfg, '$' error on error) from dual;
select json_query(asdfg, '$') from dual;
select json_query(asdfg, '$' error on error) from dual;

select json_value('asdfg', '$') from dual;
select json_value('asdfg', '$' error on error) from dual;
select json_query('asdfg', '$') from dual;
select json_query('asdfg', '$' error on error) from dual;

select json_value('"asdfg"', '$') from dual;
select json_value('"asdfg"', '$' error on error) from dual;
select json_query('"asdfg"', '$') from dual;
select json_query('"asdfg"', '$' error on error) from dual;

--However
select json_array('asdfg', '"asdfg"') from dual;
--["asdfg","\"asdfg\""]
select json_array('asdfg' format json, '"asdfg"' format json) from dual;
--[asdfg,"asdfg"]      --this case we think it a bug.


-------------------------------------------------------------------------
--boolean
--orcale: invalid identifier
select json_value(true, '$') from dual;
select json_value(true, '$' error on error) from dual;
select json_value(false, '$') from dual;
select json_value(false, '$' error on error) from dual;
select json_query(true, '$') from dual;
select json_query(true, '$' error on error) from dual;
select json_query(false, '$') from dual;
select json_query(false, '$' error on error) from dual;

--orcale: JSON syntax error
select json_value('true', '$') from dual;
select json_value('true', '$' error on error) from dual;
select json_value('false', '$') from dual;
select json_value('false', '$' error on error) from dual;
select json_query('true', '$') from dual;
select json_query('true', '$' error on error) from dual;
select json_query('false', '$') from dual;
select json_query('false', '$' error on error) from dual;

--orcale: JSON syntax error
select json_value('"true"', '$') from dual;
select json_value('"true"', '$' error on error) from dual;
select json_value('"false"', '$') from dual;
select json_value('"false"', '$' error on error) from dual;
select json_query('"true"', '$') from dual;
select json_query('"true"', '$' error on error) from dual;
select json_query('"false"', '$') from dual;
select json_query('"false"', '$' error on error) from dual;

--orcale: JSON syntax error
select json_value('false', '$.a.b') from dual;
select json_value('false', '$.a.b' error on error) from dual;
select json_value('false', '$.a.b' null on error) from dual;

select json_value('false', '$.a.b' error on empty) from dual;--doesn't take effect
select json_value('false', '$.a.b' null on empty) from dual;--doesn't take effect
--the first param of json_value and json_query is scalar will raise a json data syntax error


--However
select json_array('true', '"true"') from dual;
--["true","\"true\""]
select json_array('true' format json, '"true"' format json) from dual;
--[true,"true"]

--(ERROR_EMPTY_TEST)
-----------------------------------------------------other cases of error occurs
-------------------------------------------------------------------------
--orcale: JSON_VALUE evaluated to non-scalar value
select json_value('{"asd":256}', '$') from dual;
select json_value('{"asd":256}', '$' error on error) from dual;
select json_value('{"asd":256}', '$' error on empty) from dual;    --doesn't take effect

--orcale: result cannot be returned without array wrapper
select json_query('{"asd":256}', '$.asd') from dual;
select json_query('{"asd":256}', '$.asd' error on error) from dual;
select json_query('{"asd":256}', '$.asd' error on empty) from dual;    --doesn't take effect

--matched data, if the json_value meets the non-scalar value or json_query meets the scalar value will raise error, default seetings are null on error
--not empty reult, empty cl doesn't take effect



-------------------------------------------------------------------------
--you can regards it as error clause or empty clause ,default seetings are null on error, null on empty.
select json_value('{"asd":256}', '$.asda') from dual;
select json_value('{"asd":256}', '$.asda' error on error) from dual;

select json_query('{"asd":256}', '$.asda') from dual;
select json_query('{"asd":256}', '$.asda' error on error) from dual;

--every sql takes effect
select json_value('{"asd":256}', '$.asda' null on error) from dual;
select json_value('{"asd":256}', '$.asda' null on empty) from dual;
select json_value('{"asd":256}', '$.asda' error on error) from dual;
select json_value('{"asd":256}', '$.asda' error on empty) from dual;

--but empty clause has much Higher priority
select json_value('{"asd":256}', '$.asda' error on error null on empty) from dual;
select json_value('{"asd":256}', '$.asda' error on error error on empty) from dual;
select json_value('{"asd":256}', '$.asda' null on error error on empty) from dual;
select json_value('{"asd":256}', '$.asda' null on error null on empty) from dual;


-------------------------------------------------------------------------
--empty clause don't Take effect when json data syntax error occurs
select json_value('{"asd":::::256}', '$') from dual;
select json_value('{"asd":::::256}', '$' error on error) from dual;
select json_value('{"asd":::::256}', '$' error on empty) from dual;    --don't Take effect

select json_query('{"asd"::34::55:256}', '$') from dual;
select json_query('{"asd":::34::256}', '$' error on error) from dual;
select json_query('{"asd":::34::256}', '$' error on empty) from dual;    --don't Take effect


-------------------------------------------------------------------------
--error clause and empty clause don't Take effect when path expr syntax error occurs
select json_value('{"asd":256}', '$[to 7, *].asda') from dual; --- zenith think it invalid.

select json_value('{"asd":256}', '$[ 7, *].asda') from dual;
select json_value('{"asd":256}', '$[ 7, *].asda' error on error) from dual;
select json_value('{"asd":256}', '$[ 7, *].asda' null on empty) from dual;
select json_value('{"asd":256}', '$[ 7[].asda') from dual;
select json_value('{"asd":256}', '$[ 7[].asda' error on error) from dual;
select json_value('{"asd":256}', '$[ 7[].asda' null on empty) from dual;
select json_value('{"asd":256}', '$[ 7].as....da') from dual;
select json_value('{"asd":256}', '$[ 7].as....da' error on error) from dual;
select json_value('{"asd":256}', '$[ 7].as....da' null on empty) from dual;
select json_value('{"asd":256}', '$.a[].sd') from dual;
select json_value('{"asd":256}', '$.a[].sd' error on error) from dual;
select json_value('{"asd":256}', '$.a[].sd' null on empty) from dual;
select json_value('{"asd":"zxcv"}', '$.asd.xxx()' null on error) from dual;
select json_value('{"asd":"zxcv"}', '$.asd.xxx()' null on empty) from dual;

select json_query('{"asd":256}', '[ 7].asda') from dual;
select json_query('{"asd":256}', '[ 7].asda' error on error) from dual;
select json_query('{"asd":256}', '[ 7].asda' null on empty) from dual;
select json_query('{"asd":256}', '[ 7].asda.ff()') from dual;
select json_query('{"asd":256}', '[ 7].asda.ff()' error on error) from dual;
select json_query('{"asd":256}', '[ 7].asda.ff()' null on empty) from dual;



-------------------------------------------------------------------------
--error clause and empty clause don't Take effect when path clause syntax error occurs
select json_value('{"asd":256}', '$' ddss) from dual;
select json_value('{"asd":256}', '$' ddss error on error) from dual;
select json_value('{"asd":256}', '$' ddss null on empty) from dual;

select json_query('{"asd":256}', '$' null to error) from dual;
select json_query('{"asd":256}', '$' error  error) from dual;
select json_query('{"asd":256}', '$' null  empty) from dual;

-------------------------------------------------------------------------
--some empty clause and error clause only apears in json_query
select json_query('{"name":"12345678"}', '$.name1' empty array on empty ) from dual;
select json_query('{"name":"12345678"}', '$.name1' empty on empty ) from dual;
select json_query('{"name":"12345678"}', '$.name1' empty object on empty ) from dual;

select json_value('{"name":"12345678"}', '$.name1' empty array on empty ) from dual; --error clasue syntax
select json_value('{"name":"12345678"}', '$.name1' empty on empty ) from dual; --error clasue syntax
select json_value('{"name":"12345678"}', '$.name1' empty object on empty ) from dual; --error clasue syntax

select json_query('{"name":"12345678"}', '$.name1' empty array on error ) from dual;
select json_query('{"name":"12345678"}', '$.name1' empty on error ) from dual;
select json_query('{"name":"12345678"}', '$.name1' empty object on error ) from dual;
select json_query('{"name":"12345678"}', '$.name1' empty array on error null on empty) from dual; --empty clasue has higher priority
select json_query('{"name":"12345678"}', '$.name1' empty on error null on empty) from dual; --empty clasue has higher priority
select json_query('{"name":"12345678"}', '$.name1' empty object on error null on empty) from dual; --empty clasue has higher priority

select json_value('{"name":"12345678"}', '$.name1' empty array on error ) from dual; --error clasue syntax
select json_value('{"name":"12345678"}', '$.name1' empty on error ) from dual; --error clasue syntax
select json_value('{"name":"12345678"}', '$.name1' empty object on error ) from dual; --error clasue syntax

-------------------------------------------------------------------------
------------------------- IS JSON ---------------------------------------
-------------------------------------------------------------------------

select 1 from dual where '{"name":[1,2,3,"12356"]}' is json;
select 1 from dual where '{"name":[1,2,3,"12356"]}' is not json;

select 1 from dual where '{"name":[1,2,3,"12356":56]}' is json;
select 1 from dual where '{"name":[1,2,3,"12356":56]}' is not json;

select 1 from dual where '{"name":1,2,3,"12356"]}' is json;
select 1 from dual where '{"name":1,2,3,"12356"]}' is not json;

select 1 from dual where '123' is json;
select 1 from dual where '123' is not json;

select 1 from dual where 123 is json;
select 1 from dual where 123 is not json;

select 1 from dual where 'asd' is json;
select 1 from dual where 'asd' is not json;

select json_array(123,'123') from dual;
select json_array(123,'123' format json) from dual;

select 1 from dual where true is json;
select 1 from dual where true is not json;

select 1 from dual where 'true' is json;
select 1 from dual where 'true' is not json;

select 1 from dual where null is json;
select 1 from dual where null is not json;

DROP TABLE j_purchaseorder;
CREATE TABLE j_purchaseorder
   (id          int NOT NULL,
    po_document varchar(4000)
    CONSTRAINT ensure_json CHECK (po_document IS JSON));

truncate table j_purchaseorder;
insert into j_purchaseorder values(1, '{"name":[1,2,3,"12356"]}');
insert into j_purchaseorder values(1, '"name":1,2,3,"12356"]}');
select * from j_purchaseorder;
select po_document from j_purchaseorder where po_document is json;
select po_document from j_purchaseorder where po_document is not json;

DROP TABLE j_purchaseorder;
CREATE TABLE j_purchaseorder
   (id          int NOT NULL,
    po_document varchar(4000)
    CONSTRAINT ensure_json CHECK (po_document IS NOT JSON));

truncate table j_purchaseorder;
insert into j_purchaseorder values(1, '{"name":[1,2,3,"12356"]}');
insert into j_purchaseorder values(1, '"name":1,2,3,"12356"]}');
select * from j_purchaseorder;
select po_document from j_purchaseorder where po_document is json;
select po_document from j_purchaseorder where po_document is not json;

DROP TABLE if exists j_purchaseorder;
CREATE TABLE j_purchaseorder
   (id          int NOT NULL,
    po_document clob
    CONSTRAINT ensure_json CHECK (po_document IS JSON));

truncate table j_purchaseorder;
insert into j_purchaseorder values(1, '{"name":[1,2,3,"12356"]}');
insert into j_purchaseorder values(1, '"name":1,2,3,"12356"]}');
select * from j_purchaseorder;
select po_document from j_purchaseorder where po_document is json;
select po_document from j_purchaseorder where po_document is not json;

DROP TABLE if exists j_purchaseorder;
CREATE TABLE j_purchaseorder
   (id          int NOT NULL,
    po_document clob
    CONSTRAINT ensure_json CHECK (po_document IS NOT JSON));

truncate table j_purchaseorder;
insert into j_purchaseorder values(1, '{"name":[1,2,3,"12356"]}');
insert into j_purchaseorder values(1, '"name":1,2,3,"12356"]}');
select * from j_purchaseorder;
select po_document from j_purchaseorder where po_document is json;
select po_document from j_purchaseorder where po_document is not json;

-------------------------------------------------------------------------
------------------------- RETURNING CLAUSE ------------------------------
-------------------------------------------------------------------------

select json_value('{"name":[1,2,3,"12356"]}', '$.name[3]' returning clob) from dual;
select json_value('{"name":[1,2,3,"12356"]}', '$.name[3]' returning  varchar2) from dual;

select json_value('{"name":[1,2,3,"12356"]}', '$.name' ) from dual;
select json_value('{"name":[1,2,3,"12356"]}', '$.name' returning  varchar2 null on error) from dual;
select json_value('{"name":[1,2,3,"12356"]}', '$.name' returning  varchar2 error on error) from dual;
select json_value('{"name":[1,2,3,"12356"]}', '$.name' returning  varchar2 null on empty) from dual;
select json_value('{"name":[1,2,3,"12356"]}', '$.name' returning  varchar2 error on empty) from dual;

select json_query('{"name":[1,2,3,"12356"]}', '$.name' returning  varchar2 null on error) from dual;
select json_query('{"name":[1,2,3,"12356"]}', '$.name' returning  varchar2 error on error) from dual;
select json_query('{"name":[1,2,3,"12356"]}', '$.name' returning  varchar2 null on empty) from dual;
select json_query('{"name":[1,2,3,"12356"]}', '$.name' returning  varchar2 error on empty) from dual;

select json_query('{"name":[1,2,3,"12356"]}', '$.name1' returning  varchar2 null on error) from dual;
select json_query('{"name":[1,2,3,"12356"]}', '$.name1' returning  varchar2 error on error) from dual;
select json_query('{"name":[1,2,3,"12356"]}', '$.name1' returning  varchar2 null on empty) from dual;
select json_query('{"name":[1,2,3,"12356"]}', '$.name1' returning  varchar2 error on empty) from dual;

select json_value('{"name":[1,2,3,"12356"]}', '$.name' returning  varchar2 true on error) from dual;
select json_value('{"name":[1,2,3,"12356"]}', '$.name' returning  varchar2 false on error) from dual;
select json_value('{"name":[1,2,3,"12356"]}', '$.name' returning  varchar2 true on empty) from dual; --don't Take effect
select json_value('{"name":[1,2,3,"12356"]}', '$.name' returning  varchar2 false on empty) from dual; --don't Take effect

select JSON_value('{"name":"12345678"}', '$.name' returning  varchar2(32768) error on error) from dual;
select JSON_value('{"name":"12345678"}', '$.name' returning  varchar2(32767) error on error) from dual;
select JSON_value('{"name":"12345678"}', '$.name' returning  varchar2(4000) error on error) from dual;
select JSON_value('{"name":"12345678"}', '$.name' returning  varchar2(3900) error on error) from dual;
select JSON_value('{"name":"12345678"}', '$.name' returning  varchar2(10) error on error) from dual;
select JSON_value('{"name":"12345678"}', '$.name' returning  varchar2(9) error on error) from dual;
select JSON_value('{"name":"12345678"}', '$.name' returning  varchar2(8) error on error) from dual;
select JSON_value('{"name":"12345678"}', '$.name' returning  varchar2(7) error on error) from dual;
select JSON_value('{"name":"12345678"}', '$.name' returning  varchar2(3) error on error) from dual;
select JSON_value('{"name":"12345678"}', '$.name' returning  varchar2(0) error on error) from dual;
select JSON_value('{"name":"12345678"}', '$.name' returning  varchar2(-11) error on error) from dual;

select JSON_QUERY('{"name":"12345678"}', '$') from dual;
select JSON_QUERY('{"name":"12345678"}', '$' returning  varchar2(32768) error on error) from dual;
select JSON_QUERY('{"name":"12345678"}', '$' returning  varchar2(32767) error on error) from dual;
select JSON_QUERY('{"name":"12345678"}', '$' returning  varchar2(4000) error on error) from dual;
select JSON_QUERY('{"name":"12345678"}', '$' returning  varchar2(3900) error on error) from dual;
select JSON_QUERY('{"name":"12345678"}', '$' returning  varchar2(10) error on error) from dual;
select JSON_QUERY('{"name":"12345678"}', '$' returning  varchar2(9) error on error) from dual;
select JSON_QUERY('{"name":"12345678"}', '$' returning  varchar2(8) error on error) from dual;
select JSON_QUERY('{"name":"12345678"}', '$' returning  varchar2(7) error on error) from dual;
select JSON_QUERY('{"name":"12345678"}', '$' returning  varchar2(3) error on error) from dual;
select JSON_QUERY('{"name":"12345678"}', '$' returning  varchar2(0) error on error) from dual;
select JSON_QUERY('{"name":"12345678"}', '$' returning  varchar2(-11) error on error) from dual;

-------------------------------------------------------------------------
------------------------- escaped char ----------------------------------
-------------------------------------------------------------------------

select JSON_value('{"name":123}', '$.name')  from dual;
select 1 + JSON_value('{"name":123}', '$.name')  from dual;

select JSON_value('{"name":true}', '$.name')  from dual;
select 1 from dual where JSON_value('{"name":true}', '$.name') = true;
select 1 from dual where (select JSON_value('{"name":true}', '$.name') from dual) = true;

select JSON_value('{"name":"123"}', '$.name')  from dual;
select JSON_value('{"name":123}', '$.name')  from dual;
select 1 + JSON_value('{"name":"123"}', '$.name')  from dual;

select JSON_value('{"name":"true"}', '$.name')  from dual;
select JSON_value('{"name":true}', '$.name')  from dual;

select JSON_value('{"name":"\"123\""}', '$.name')  from dual;
select JSON_value('{"name":"\"123\"t"}', '$.name')  from dual;
select JSON_value('{"name":"\"1\"2\"3\"t"}', '$.name')  from dual;

select JSON_value('{"name":null}', '$.name')  from dual;
select JSON_value('{"name":"null"}', '$.name')  from dual;
select 1 from dual where (select JSON_value('{"name":null}', '$.name' error on error)  from dual) is null;
select 1 from dual where (select JSON_value('{"name":null}', '$.name' error on empty)  from dual) is null;

select JSON_query(null, '$')  from dual;
select JSON_query(null, '$' error on error) from dual;
select JSON_query(null, '$' error on empty) from dual;

select JSON_value('{"name":"a\"sd\"fs"}', '$.name')  from dual;
select JSON_value('{"name":"asdfs"}', '$.name')  from dual;
select JSON_value('{"name":"asd\"fs"}', '$.name')  from dual;
select JSON_value('{"name":"asd"fs"}', '$.name')  from dual;
select JSON_value('{"name":"asd"fs"}', '$.name' error on error)  from dual;
select JSON_value('{"name":"asd\\\"fs"}', '$.name' error on error)  from dual;
select JSON_value('{"name":"asd\"\"\\\\\"\\\\\"fs\""}', '$.name' error on error)  from dual;

select JSON_query('{"name":"a\"sd\"fs"}', '$')  from dual;
select JSON_query('{"name":"asdfs"}', '$')  from dual;
select JSON_query('{"name":"asd\"fs"}', '$')  from dual;
select JSON_query('{"name":"asd"fs"}', '$')  from dual;
select JSON_query('{"name":"asd"fs"}', '$' error on error)  from dual;
select JSON_query('{"name":"asd\\\"fs"}', '$')  from dual;
select JSON_query('{"name":"asd\"\"\\\\\"\\\\\"fs\\"}', '$')  from dual;

-------------------------------------------------------------------------
select 1 from dual where '{\"name\":\"asd\"fs\"}' is json;
select 1 from dual where '{\\\"name\\\":\\\"asd\\\"fs\\\"}' is json;

select JSON_ARRAY('{"name":"asd"fs"}') from dual;
select JSON_ARRAY('{"name":"asd"fs"}' format json) from dual;
select JSON_ARRAY('{"name":"asd\"fs"}') from dual;
select JSON_ARRAY('{"name":"asd\"fs"}' format json ) from dual;
select JSON_ARRAY('{"name":"asd"fs"}', '{"name":"asd"fs"}' format json) from dual;

select JSON_OBJECT(key 'name' is '"asd"fs"') from dual;
select JSON_OBJECT(key 'name' is '"asd"fs"' format json) from dual;
select JSON_OBJECT(key 'name' is '"asd\"fs"') from dual;
select JSON_OBJECT(key 'name' is '"asd\"fs"' format json) from dual;
select JSON_OBJECT(key 'n"am"e'  is '"asd"fs"') from dual;
select JSON_OBJECT(key 'n"am"e'  is '"asd"fs"' format json ) from dual;

-------------------------------------------------------------------------
------------------------- FUNCTION INDEX ------------------------------
-------------------------------------------------------------------------
----------------------------json_value
--normal index
DROP TABLE if exists j_purchaseorder;
CREATE TABLE j_purchaseorder
   (id          int NOT NULL,
    po_document clob
    CONSTRAINT ensure_json CHECK (po_document IS JSON));

truncate table j_purchaseorder;
insert into j_purchaseorder values(1, '{"name":"jdd"}');
insert into j_purchaseorder values(2, '{"name":"123"}');
insert into j_purchaseorder values(3, '{"name":"true"}');
insert into j_purchaseorder values(4, '{"name":"false"}');
insert into j_purchaseorder values(5, '{"namexxx":"false"}');
insert into j_purchaseorder values(6, '{"namexxx":[1,2,3]}');
insert into j_purchaseorder values(7, '{"namexxx":{"number":2563}}');
select * from j_purchaseorder;

drop index if exists xxx_json_test_idx on j_purchaseorder;
create index xxx_json_test_idx on j_purchaseorder(JSON_VALUE(PO_DOCUMENT, '$.name'));


--unique index
DROP TABLE if exists j_purchaseorder;
CREATE TABLE j_purchaseorder
   (id          int NOT NULL,
    po_document varchar(4000)
    CONSTRAINT ensure_json CHECK (po_document IS JSON));
	
drop index if exists xxx_json_test_idx on j_purchaseorder;
create unique index xxx_json_test_idx on j_purchaseorder(JSON_VALUE(PO_DOCUMENT, '$[1]'));

truncate table j_purchaseorder;
insert into j_purchaseorder values(1, '["abc","def","qwe"]');
insert into j_purchaseorder values(2, '["abfewfc","dedfs","qwesaew"]');
insert into j_purchaseorder values(3, '["abteyythc","def","qwergwefe"]');
insert into j_purchaseorder values(4, '["absadsrfewfc","dedssdfs","qwfgvdsesaew"]');
insert into j_purchaseorder values(5, '["abteyyth2334432c","def","qwer543543gwefe"]');

select JSON_value('["abc","def","qwe"]', '$[1]') from dual;
select JSON_value('["abfewfc","dedfs","qwesaew"]', '$[1]') from dual;
select JSON_value('["abteyythc","def","qwergwefe"]', '$[1]') from dual;
select JSON_value('["absadsrfewfc","dedssdfs","qwfgvdsesaew"]', '$[1]') from dual;
select JSON_value('["abteyyth2334432c","def","qwer543543gwefe"]', '$[1]') from dual;
select * from j_purchaseorder;

DROP TABLE if exists j_purchaseorder;

-------------------------------------------------------------------------
------------------------- extra test ------------------------------------
-------------------------------------------------------------------------

SELECT json_value('{"name":123}', '$.name') from dual;
SELECT json_value('{"name":123}', '$[0].name') from dual;
SELECT json_value('{"name":123}', '$[*].name') from dual;

SELECT json_value('{"name":123}', '  $  .   name') from dual;
SELECT json_value('{"name":123}', '  $  [ 0 ]  .  name') from dual;
SELECT json_value('{"name":123}', '  $  [ * ]  .  name') from dual;

--pass 
DROP  TABLE if exists  j_purchaseorder;
CREATE TABLE j_purchaseorder
   (id          RAW (16) NOT NULL,
    date_loaded TIMESTAMP WITH TIME ZONE,
    po_document CLOB
    CONSTRAINT ensure_json CHECK (po_document IS JSON)); 

truncate table j_purchaseorder;
INSERT INTO j_purchaseorder VALUES (
    SYS_GUID(),
    SYSTIMESTAMP,
    '[[[{"name":123},2],[3,4]],[[5,6],[7,8]]]');
COMMIT;

--zenith
SELECT json_value(po_document, '$[0].*[0].*[0].name') FROM j_purchaseorder;
SELECT json_value(po_document, '$[0].[0].[0].name') FROM j_purchaseorder;
SELECT json_value(po_document, '$[to].[to].[to].name') FROM j_purchaseorder;
SELECT json_value(po_document, '$[*].*[*].*[*].name') FROM j_purchaseorder;
SELECT json_value(po_document, '$.*.*.name') FROM j_purchaseorder;

SELECT json_value(po_document, '$ [0] [0] [0] . name') FROM j_purchaseorder;
SELECT json_value(po_document, '$ [*] [*] [*] . name') FROM j_purchaseorder;
SELECT json_value(po_document, '$ [ * ] [  to  , to,  to  ] [*] . name') FROM j_purchaseorder;
SELECT json_value(po_document, '$ [to] [to] [to] . name') FROM j_purchaseorder;
SELECT json_value(po_document, '$ [to]. [to  , to,  to] [to] . name') FROM j_purchaseorder;
SELECT json_value(po_document, '$ [to] [to  , to,  to]. [to] . name') FROM j_purchaseorder;
SELECT json_query(po_document, '$  [0] [0]') FROM j_purchaseorder;
SELECT json_query(po_document, '$  [to] [to]') FROM j_purchaseorder;
SELECT json_query(po_document, '$  [to]  ') FROM j_purchaseorder;
SELECT json_query(po_document, '  $    ') FROM j_purchaseorder;

--orcale, we don't support this syntax, it has Great ambiguity
SELECT json_value(po_document, '$[*].name') FROM j_purchaseorder;
SELECT json_value(po_document, '$[0].name') FROM j_purchaseorder;
SELECT json_value(po_document, '$[to].name') FROM j_purchaseorder;
SELECT json_value(po_document, '$[0][0].name') FROM j_purchaseorder;
SELECT json_value(po_document, '$[0][0][0].name') FROM j_purchaseorder;  -- same as zenith
SELECT json_value(po_document, '$[to][to][to].name') FROM j_purchaseorder;  -- same as zenith
SELECT json_value(po_document, '$[to][to][to][to].name') FROM j_purchaseorder;
SELECT json_value(po_document, '$[0][0][0][0].name') FROM j_purchaseorder;

--error
SELECT json_value(po_document, '$[0][[0][0].name') FROM j_purchaseorder;
SELECT json_value(po_document, '$[0][0]][0].name') FROM j_purchaseorder;
SELECT json_value(po_document, '$[0][][0][0].name') FROM j_purchaseorder;

-------------------------------------------------------------------------
------------------------- final all test --------------------------------
-------------------------------------------------------------------------
---------------------------------------------------------------------1. json data format (plain string)
--invalid single plain string test
select 1 from dual where null is json;
select 1 from dual where asdfdf is json;
select 1 from dual where 'asdfdf' is json;
select 1 from dual where 'htjnyrhbtgregt' is json;
select 1 from dual where 'htjnyrhb343543534dstgregt' is json;
select 1 from dual where '"asdfdf"' is json;
select 1 from dual where '"asdfdfhtjnyrhbtgregt"' is json;
select 1 from dual where '"asdfdfhtjnyrhb343543534dstgregt"' is json;

select json_value('asdfdfasdfdf', '$') from dual;
select json_value('"asdfdfasdfdf"', '$') from dual;
select 1 from dual where json_value('asdfdfasdfdf', '$') is null;
select 1 from dual where json_value('"asdfdfasdfdf"', '$') is null;
select json_value('asdfdfasdfdf', '$' error on error) from dual;
select json_value('"asdfdfasdfdf"', '$' error on error) from dual;

select json_value('asdfd\"\t\'\\fasdfdf', '$') from dual;
select json_value('"asdfd\"\t\'\\fasdfdf"', '$') from dual;
select 1 from dual where json_value('asdfd\"\t\'\\fasdfdf', '$') is null;
select 1 from dual where json_value('"asdfd\"\t\'\\fasdfdf"', '$') is null;
select json_value('asdfd\"\t\'\\fas\"\t\'\\dfdf', '$' error on error) from dual;
select json_value('"asdfd\"\t\'\\fasdf\"\t\'\\df"', '$' error on error) from dual;

--(RETUNING_SIZE_TEST)
--max length test, default 3900
select json_value('{"name":"123456789"}','$.name') from dual;
desc -q select json_value('{"name":"123456789"}','$.name') from dual;
select json_value('{"name":"123456789qwertyuiopasdfghjkl"}','$.name') from dual;
desc -q select json_value('{"name":"123456789qwertyuiopasdfghjkl"}','$.name') from dual;

select json_value('{"name":"123456789"}','$.name' returning varchar2(6)) from dual;
select json_value('{"name":"123456789"}','$.name' returning varchar2(6) error on error) from dual;

select json_value('{"name":"123456789"}','$.name' returning varchar2(9) error on error) from dual;
desc -q select json_value('{"name":"123456789"}','$.name' returning varchar2(9) error on error) from dual;
select json_value('{"name":"123456789"}','$.name' returning varchar2(20) error on error) from dual;
desc -q select json_value('{"name":"123456789"}','$.name' returning varchar2(20) error on error) from dual;

select json_value('{"name":"123456789"}','$.name') from dual;
desc -q select json_value('{"name":"123456789"}','$.name') from dual;
select json_value('{"name":"123456789"}','$.name' returning varchar2(20) error on error) from dual;
desc -q select json_value('{"name":"123456789"}','$.name' returning varchar2(20) error on error) from dual;
select json_value('{"name":"123456789"}','$.name' returning varchar2(3900) error on error) from dual;
desc -q select json_value('{"name":"123456789"}','$.name' returning varchar2(3900) error on error) from dual;
select json_value('{"name":"123456789"}','$.name' returning varchar2(4000) error on error) from dual;
desc -q select json_value('{"name":"123456789"}','$.name' returning varchar2(4000) error on error) from dual;
select json_value('{"name":"123456789"}','$.name' returning varchar2(7000) error on error) from dual;
desc -q select json_value('{"name":"123456789"}','$.name' returning varchar2(7000) error on error) from dual;

select json_value('{"name":"' || lpad('asdds', 9, 'as') || '"}','$.name') from dual;
desc -q select json_value('{"name":"' || lpad('asdds', 9, 'as') || '"}','$.name') from dual;
select json_value('{"name":"' || lpad('asdds', 9, 'as') || '"}','$.name' returning varchar2(20) error on error) from dual;
desc -q select json_value('{"name":"' || lpad('asdds', 9, 'as') || '"}','$.name' returning varchar2(20) error on error) from dual;
select json_value('{"name":"' || lpad('asdds', 9, 'as') || '"}','$.name' returning varchar2(3900) error on error) from dual;
desc -q select json_value('{"name":"' || lpad('asdds', 9, 'as') || '"}','$.name' returning varchar2(3900) error on error) from dual;
select json_value('{"name":"' || lpad('asdds', 9, 'as') || '"}','$.name' returning varchar2(4000) error on error) from dual;
desc -q select json_value('{"name":"' || lpad('asdds', 9, 'as') || '"}','$.name' returning varchar2(4000) error on error) from dual;
select json_value('{"name":"' || lpad('asdds', 9, 'as') || '"}','$.name' returning varchar2(7000) error on error) from dual;
desc -q select json_value('{"name":"' || lpad('asdds', 9, 'as') || '"}','$.name' returning varchar2(7000) error on error) from dual;


--oracle lpad max 4000, zenith lpad max 8000, there has some  differ of lpad
select length(lpad('asdds', 8000, 'as')) from dual;
select length(lpad('asdds', 8888, 'as')) from dual;
select length(lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as')) from dual;
select length(lpad('asdds', 8888, 'as') || lpad('asdds', 8000, 'as')) from dual;
select length('{"name":"' || lpad('asdds', 9990, 'as') || '"}') from dual;
select length('{"name":"' || lpad('asdds', 7990, 'as') || '"}') from dual;
select length('{"name":"' || lpad('asdds', 7989, 'as') || '"}') from dual;
select length('{"name":"' || lpad('asdds', 6666, 'as') || '"}') from dual;
select length('{"name":"' || lpad('asdds', 4000, 'as') || '"}') from dual;
select length('{"name":"' || lpad('asdds', 3990, 'as') || '"}') from dual; 
select length('{"name":"' || lpad('asdds', 3989, 'as') || '"}') from dual;
select length('{"name":"' || lpad('asdds', 3899, 'as') || '"}') from dual;

--there are some different behaviors between oracle and zenith , it caused by lpad() func.
--if first parm of json_value comes from str concat, its length max = 32767
--if first parm of json_value comes from varchar2, its length max = 8000
--if first parm of json_value comes from clob, its length can be bigger
--returning clause default 3900, range is 1 to 32767
select 1 from dual where ('{"name":"' || lpad('asdds', 100, 'as') || '"}') is json;
select length(json_value('{"name":"' || lpad('asdds', 1021, 'as') || '"}', '$.name')) from dual;
select length(json_value('{"name":"' || lpad('asdds', 3900, 'as') || '"}', '$.name')) from dual;
select length(json_value('{"name":"' || lpad('asdds', 3901, 'as') || '"}', '$.name' error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 3901, 'as') || '"}', '$.name' returning varchar2(9999) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 6666, 'as') || '"}', '$.name' returning varchar2(9999) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 7000, 'as') || '"}', '$.name' returning varchar2(9999) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || '"}', '$.name' returning varchar2(9999) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || '"}', '$.name' returning varchar2(20001) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || '"}', '$.name' returning varchar2(32767) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || '"}', '$.name' returning varchar2(32768) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || '"}', '$.name' returning varchar2(40000) error on error)) from dual;

desc -q select json_value('{"name":"' || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || '"}', '$.name' returning varchar2(32767) error on error);
desc -q select json_value('{"name":"' || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || '"}', '$.name' returning varchar2(20001) error on error);
desc -q select json_value('{"name":"' || lpad('asdds', 8000, 'as') || '"}', '$.name' returning varchar2(10000) error on error);
desc -q select json_value('{"name":"' || lpad('asdds', 8000, 'as') || '"}', '$.name' returning varchar2(8001) error on error);
desc -q select json_value('{"name":"' || lpad('asdds', 3500, 'as') || '"}', '$.name' returning varchar2(4000) error on error);
desc -q select json_value('{"name":"' || lpad('asdds', 3500, 'as') || '"}', '$.name' returning varchar2(3900) error on error);
desc -q select json_value('{"name":"' || lpad('asdds', 3500, 'as') || '"}', '$.name' returning varchar2(3800) error on error);

--concat str can reach max length 32767
select length(json_value('{"name":"' || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || '"}', '$.name' returning varchar2(32767) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || '"}', '$.name' returning varchar2(32767) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || lpad('asdds', 756, 'as') || '"}', '$.name' returning varchar2(32767) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || lpad('asdds', 757, 'as') || '"}', '$.name' returning varchar2(32767) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || lpad('asdds', 758, 'as') || '"}', '$.name' returning varchar2(32767) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || lpad('asdds', 759, 'as') || '"}', '$.name' returning varchar2(32767) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || lpad('asdds', 768, 'as') || '"}', '$.name' returning varchar2(32767) error on error)) from dual;

select length(json_value('["' || lpad('name', 8000, 'name') || '","' || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || lpad('asdds', 8000, 'as') || '"]', '$[0]' returning varchar2(32767) error on error)) from dual;

--varchar2 type col can only store 8000
drop table if exists json_length_test;
create table json_length_test(a varchar2(8001));
drop table if exists json_length_test;
create table json_length_test(a varchar2(8000));
insert into json_length_test values('{"name":"' || lpad('asdds', 7989, 'as') || '"}');
insert into json_length_test values('{"name":"' || lpad('asdds', 7990, 'as') || '"}');
select length(a) from  json_length_test;
select length(json_value(a, '$.name' error on error)) from  json_length_test;
select length(json_value(a, '$.name'returning varchar2(7988) error on error)) from  json_length_test;
select length(json_value(a, '$.name'returning varchar2(7989) error on error)) from  json_length_test;
select length(json_value(a, '$.name'returning varchar2(8000) error on error)) from  json_length_test;
drop table if exists json_length_test;

-- clob type col can store more data
drop table if exists json_length_test;
create table json_length_test(a clob);
truncate table json_length_test;
insert into json_length_test values(lpad('asdds', 7989, 'as'));
update json_length_test set a = a || '","' || a;
update json_length_test set a = a || '","' || a;
update json_length_test set a = a || '","' || a;
update json_length_test set a = '["' || a;
update json_length_test set a = a || '"]';
select 1 from json_length_test where a is json;
select length(a) from  json_length_test;
select length(json_value(a, '$.name' error on error)) from  json_length_test;
select length(json_value(a, '$.name'returning varchar2(7988) error on error)) from  json_length_test;
select length(json_value(a, '$.name'returning varchar2(7989) error on error)) from  json_length_test;
select length(json_value(a, '$.name'returning varchar2(8000) error on error)) from  json_length_test;
drop table if exists json_length_test;


--(ESCAPED_STRS_TEST)
--valid string in object/array and escaped str
select json_value('{"name":"asdfdfasdfdf"}', '$.name') from dual;
select length(json_value('{"name":"asdfdfasdfdf"}', '$.name')) from dual;
select json_value('{"name":"\\as\\dfdf\\\\\\asdf\\df"}', '$.name' error on error) from dual;
select length(json_value('{"name":"\\as\\dfdf\\\\\\asdf\\df"}', '$.name' error on error)) from dual;
select json_value('{"name":"\"asdfd\"\"\"fasdfd\"f\""}', '$.name') from dual;
select length(json_value('{"name":"\"asdfd\"\"\"fasdfd\"f\""}', '$.name')) from dual;
select json_value('{"name":"\/\/\/asdf\/\/\/dfasd\/\/\/fdf\/\/\/"}', '$.name') from dual;
select length(json_value('{"name":"\/\/\/asdf\/\/\/dfasd\/\/\/fdf\/\/\/"}', '$.name')) from dual;
select json_value('{"name":"\nasdf\n\ndfasdf\n\ndf\n"}', '$.name') from dual;
select length(json_value('{"name":"\nasdf\n\ndfasdf\n\ndf\n"}', '$.name')) from dual;
select json_value('{"name":"\fas\fdf\fd\f\f\ffa\fsdf\fdf\f\f"}', '$.name') from dual;
select length(json_value('{"name":"\fas\fdf\fd\f\f\ffa\fsdf\fdf\f\f"}', '$.name')) from dual;
select json_value('{"name":"\tasd\tfdf\t\t\tasd\tfd\tf\t"}', '$.name') from dual;
select length(json_value('{"name":"\tasd\tfdf\t\t\tasd\tfd\tf\t"}', '$.name')) from dual;
select json_value('{"name":"\"asd\"fdf\"\"\"\"\"as\"d\"fd\"f\""}', '$.name') from dual;
select length(json_value('{"name":"\"asd\"fdf\"\"\"\"\"as\"d\"fd\"f\""}', '$.name')) from dual;

select json_value('{"name":"\na\ns\ndf\n\ndfasdf\n\ndf"}', '$.name') from dual;
select json_value('{"name":"\na\ns\ndf\n\ndfasdf\n\ndf\n"}', '$.name') from dual;
select json_value('{"name":"\na\ns\ndf\n\ndfasdf\n\ndf\n\n"}', '$.name') from dual;
select json_value('{"name":"\na\ns\ndf\n\ndfasdf\n\ndf\n\n\n"}', '$.name') from dual;

select json_value('{"name":"\bs"}', '$.name') from dual;
select length(json_value('{"name":"\bs"}', '$.name')) from dual;
select json_value('{"name":"\bsx"}', '$.name') from dual;
select length(json_value('{"name":"\bsx"}', '$.name')) from dual;
select json_value('{"name":"\bsaax\b"}', '$.name') from dual;
select length(json_value('{"name":"\bsaax\b"}', '$.name')) from dual;
select json_value('{"name":"a\bsd"}', '$.name') from dual;
select length(json_value('{"name":"a\bsd"}', '$.name')) from dual;
select json_value('{"name":"a\b\bsd"}', '$.name') from dual;
select length(json_value('{"name":"a\b\bsd"}', '$.name')) from dual;

--diff?
select json_value('{"name":"\bsaqqx\b"}', '$.name') from dual;
select length(json_value('{"name":"\bsaqqx\b"}', '$.name')) from dual;
select hex(json_value('{"name":"\bsaqqx\b"}', '$.name')) from dual;
select json_value('{"name":"\bsaqqx\b\b"}', '$.name') from dual;
select length(json_value('{"name":"\bsaqqx\b\b"}', '$.name')) from dual;
select hex(json_value('{"name":"\bsaqqx\b\b"}', '$.name')) from dual;

select json_value('{"name":"\ba\b\bsdfdf\b\basdf\b\bdf\b"}', '$.name') from dual;
select length(json_value('{"name":"\ba\b\bsdfdf\b\basdf\b\bdf\b"}', '$.name')) from dual;
select hex(json_value('{"name":"\ba\b\bsdfdf\b\basdf\b\bdf\b"}', '$.name')) from dual;
select json_value('{"name":"\ras\rdf\rdf\r\r\ras\rd\rf\rxx\r"}', '$.name') from dual;
select length(json_value('{"name":"\ras\rdf\rdf\r\r\ras\rd\rf\rxx\r"}', '$.name')) from dual;
select hex(json_value('{"name":"\ras\rdf\rdf\r\r\ras\rd\rf\rxx\r"}', '$.name')) from dual;
select json_value('{"name":"\ras\rdf\rdf\r\r\ras\rd\rf\rxx"}', '$.name') from dual;
select length(json_value('{"name":"\ras\rdf\rdf\r\r\ras\rd\rf\rxx"}', '$.name')) from dual;
select hex(json_value('{"name":"\ras\rdf\rdf\r\r\ras\rd\rf\rxx"}', '$.name')) from dual;

--\b and \r at end doesn't take effect? actually is same
select json_value('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$.name') from dual;
select json_value('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx\r"}', '$.name') from dual;
select json_value('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx\r\r"}', '$.name') from dual;
select json_value('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx\r\r\r"}', '$.name') from dual;
select json_value('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf"}', '$.name') from dual;
select json_value('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf\b"}', '$.name') from dual;
select json_value('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf\b\b"}', '$.name') from dual;
select json_value('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf\b\b\b"}', '$.name') from dual;

select length(json_value('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$.name')) from dual;
select length(json_value('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx\r"}', '$.name')) from dual;
select length(json_value('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx\r\r"}', '$.name')) from dual;
select length(json_value('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx\r\r\r"}', '$.name')) from dual;
select length(json_value('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf"}', '$.name')) from dual;
select length(json_value('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf\b"}', '$.name')) from dual;
select length(json_value('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf\b\b"}', '$.name')) from dual;
select length(json_value('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf\b\b\b"}', '$.name')) from dual;

select hex(json_value('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$.name')) from dual;
select hex(json_value('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx\r"}', '$.name')) from dual;
select hex(json_value('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx\r\r"}', '$.name')) from dual;
select hex(json_value('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx\r\r\r"}', '$.name')) from dual;
select hex(json_value('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf"}', '$.name')) from dual;
select hex(json_value('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf\b"}', '$.name')) from dual;
select hex(json_value('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf\b\b"}', '$.name')) from dual;
select hex(json_value('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf\b\b\b"}', '$.name')) from dual;

--mixed
select json_value('{"name":"\\a\"s\\d\/f\ndfa\f\nsd\f\\f\tdf"}', '$.name') from dual;
select length(json_value('{"name":"\\a\"s\\d\/f\ndfa\f\nsd\f\\f\tdf"}', '$.name')) from dual;
select json_value('{"name":"\\a\\\"\\s\\d\/f\ndf\na\"\f\n\f\fs\f\f\"d\f\"\\f\\\tdf\\"}', '$.name') from dual;
select length(json_value('{"name":"\\a\\\"\\s\\d\/f\ndf\na\"\f\n\f\fs\f\f\"d\f\"\\f\\\tdf\\"}', '$.name')) from dual;

--chinese char in json data
--only in utf-8
set charset = UTF8;

drop table if exists json_length_test;
create table json_length_test(a varchar2(8000));
insert into json_length_test values('{"name":"我爱华为，\n我爱中国!!!"}');
insert into json_length_test values('{"name":"这里是\n中文测试!!!"}');
insert into json_length_test values('{"name":"\"长风\t破浪\t会有时，直挂\t云帆\t济沧海!!!\""}');

select json_value(a, '$.name') from json_length_test;
select json_value(a, '$.name') from json_length_test;
select json_value(a, '$.name') from json_length_test;
select length(json_value(a, '$.name')) from json_length_test;

drop table if exists json_length_test;

---------------------------------------------------------------------2. json data format (number)
select 1 from dual where 123456 is json;  --oracle    inconsistent datatypes: expected - got NUMBER
select 1 from dual where '123456' is json;
select 1 from dual where '"123456"' is json;
select 1 from dual where '123a456' is json;
select 1 from dual where '"123a456"' is json;

select json_query('[123, -123, 4.5572E+18, -4.5572E+18, 4.5572111112312321E+8, -4.5572111112312321E+8, 45572E-3, -45572E-3]','$') from dual;
select json_query('{"name":45572E-3}', '$') from dual;
select json_query('{"name":"45572E-3"}', '$') from dual;

drop table if exists json_number_test;
create table json_number_test(a int, id varchar(100));
truncate table json_number_test;
insert into json_number_test values(1, '[123456789]');
insert into json_number_test values(2, '[1234567890]');
insert into json_number_test values(3, '[12345678901]');
insert into json_number_test values(4, '{"name":123456789}');
insert into json_number_test values(5, '{"name":1234567890}');
insert into json_number_test values(6, '{"name":12345678901}');
insert into json_number_test values(7, '{"name":"123456789"}');
insert into json_number_test values(8, '{"name":"1234567890"}');
insert into json_number_test values(9, '{"name":"12345678901"}');
insert into json_number_test values(10, '[45572E-3]');
insert into json_number_test values(11, '{"name":45572E-3}');
insert into json_number_test values(12, '{"name":"45572E-3"}');

select * from json_number_test order by a;
select * from json_number_test where json_value(id, '$[0]') = 123456789;
select * from json_number_test where json_value(id, '$[0]') = 1234567890;
select * from json_number_test where json_value(id, '$[0]') = 12345678901;
select * from json_number_test where json_value(id, '$[*].name') = 123456789;
select * from json_number_test where json_value(id, '$[*].name') = 1234567890;
select * from json_number_test where json_value(id, '$[*].name') = 12345678901;
select * from json_number_test where json_value(id, '$[0]') = 1.23456789E+8;
select * from json_number_test where json_value(id, '$[0]') = 1.23456789E+9;
select * from json_number_test where json_value(id, '$[0]') = 1.2345678901E+10;
select * from json_number_test where json_value(id, '$[0]') = 123456.789E+3;
select * from json_number_test where json_value(id, '$[0]') = 123456.789E+4;
select * from json_number_test where json_value(id, '$[0]') = 123456.78901E+5;
select * from json_number_test where json_value(id, '$[0]') = 45572E-3;
select * from json_number_test where json_value(id, '$[*].name') = 45572E-3;
drop table if exists json_number_test;

---------------------------------------------------------------------3. json data format (null/true/false)
select 1 from dual where '' is json;
select 1 from dual where null is json;
select 1 from dual where NULL is json;
select 1 from dual where 'null' is json;
select 1 from dual where 'NULL' is json;
select 1 from dual where '"null"' is json;
select 1 from dual where '"NULL"' is json;

select 1 from dual where json_value('{"name":null}', '$.name') is null;
select 1 from dual where json_value('{"name":NULL}', '$.name') is null;
select 1 from dual where json_value('{"name":"null"}', '$.name') is null;
select 1 from dual where json_value('{"name":"NULL"}', '$.name') is null;

select json_value('{"name":null}', '$.name') from dual;
select json_value('{"name":"null"}', '$.name') from dual;
select json_value('{"name":"NULL"}', '$.name') from dual;
select json_value('{"null":null}', '$.null') from dual;
select json_value('{"null":"null"}', '$.null') from dual;
select json_value('{"null":"NULL"}', '$.null') from dual;

select 1 from dual where true is json;
select 1 from dual where false is json;
select 1 from dual where TRUE is json;
select 1 from dual where FALSE is json;
select 1 from dual where 'true' is json;
select 1 from dual where 'false' is json;
select 1 from dual where 'TRUE' is json;
select 1 from dual where 'FALSE' is json;
select 1 from dual where '"true"' is json;
select 1 from dual where '"false"' is json;
select 1 from dual where '"TRUE"' is json;
select 1 from dual where '"FALSE"' is json;

select json_value('{"name":true}', '$.name') from dual;
select json_value('{"name":TRUE}', '$.name') from dual;
select json_value('{"name":"true"}', '$.name') from dual;
select json_value('{"name":"TRUE"}', '$.name') from dual;

select 1 from dual where json_value('{"name":true}', '$.name') = true;
select 1 from dual where json_value('{"name":TRUE}', '$.name') = true;
select 1 from dual where json_value('{"name":"true"}', '$.name') = true;
select 1 from dual where json_value('{"name":"TRUE"}', '$.name') = true;

select json_value('{"name":false}', '$.name')  from dual;
select json_value('{"name":FALSE}', '$.name')  from dual;
select json_value('{"name":"false"}', '$.name')  from dual;
select json_value('{"name":"FALSE"}', '$.name')  from dual;

select 1 from dual where json_value('{"name":false}', '$.name') = false;
select 1 from dual where json_value('{"name":FALSE}', '$.name') = false;
select 1 from dual where json_value('{"name":"false"}', '$.name') = false;
select 1 from dual where json_value('{"name":"FALSE"}', '$.name') = false;

select 1 from dual where '{"name":"TRUE"}' is json;
select 1 from dual where '{"name":"FALSE"}' is json;

select 1 from dual where '{"name":TRUE}' is json;
select 1 from dual where '{"name":FALSE}' is json;
select 1 from dual where json_value('{"name":TRUE}', '$.name') = 'TRUE';
select 1 from dual where json_value('{"name":FALSE}', '$.name') = 'FALSE';
select 1 from dual where json_value('{"name":TRUE}', '$.name' error on error) = 'TRUE';
select 1 from dual where json_value('{"name":FALSE}', '$.name' error on error) = 'FALSE';

select 1 from dual where sysdate is json;
select 1 from dual where localtimestamp is json;
select 1 from dual where current_timestamp is json;

---------------------------------------------------------------------4. json data format (object)
--valid test
select 1 from dual where '{{}}' is json;
select 1 from dual where '{{{}}}' is json;
select 1 from dual where '{true}' is json;
select 1 from dual where '{"true"}' is json;
select 1 from dual where '{asdsadsa}' is json;
select 1 from dual where '{"asdsadsa"}' is json;
select 1 from dual where '{:asdsadsa}' is json;
select 1 from dual where '{"name":asdsadsa}' is json;
select 1 from dual where '{name":"asdsadsa"}' is json;
select 1 from dual where '{"name":"asdsadsa"]' is json;
select 1 from dual where '{"name" "asdsadsa"}' is json;
select 1 from dual where '{"name":"asds"adsa"}' is json;
select 1 from dual where '{:"asdsadsa"}' is json;
select 1 from dual where '{"name":}' is json;

select 1 from dual where '{}' is json;
select 1 from dual where '{"name":""}' is json;
select 1 from dual where '{"name":"asdsadsa"}' is json;
select 1 from dual where '{"name":"asds\"adsa"}' is json;

--duplicate key test
select 1 from dual where '{"name":"asdsadsa", "name":"gtrhgtr", "name":"56434"}' is json;
select json_value('{"name":"asdsadsa", "name":"gtrhgtr", "name":"56434"}', '$.name' error on error) from dual;

--max level(32) test 
select 1 from dual where '{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":"asdsadsa"}}}}}}}}}}}}}}}}}}}}}}}}}}}}' is json;
select 1 from dual where '{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":"asdsadsa"}}}}}}}}}}}}}}}}}}}}}}}}}}}}}' is json;
select 1 from dual where '{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":"asdsadsa"}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}' is json;
select 1 from dual where '{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":"asdsadsa"}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}' is json;
select 1 from dual where '{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":"asdsadsa"}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}' is json;
select 1 from dual where '{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":"asdsadsa"}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}' is json;
select 1 from dual where '{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":"asdsadsa"}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}' is json;

--max pairs(1024) test
drop table if exists max_pairs_test;
create table max_pairs_test(a clob);
insert into max_pairs_test values ('{"0":1,"1":1,"2":1,"3":1,"4":1,"5":1,"6":1,"7":1,"8":1,"9":1,"10":1,"11":1,"12":1,"13":1,"14":1,"15":1,"16":1,"17":1,"18":1,"19":1,"20":1,"21":1,"22":1,"23":1,"24":1,"25":1,"26":1,"27":1,"28":1,"29":1,"30":1,"31":1,"32":1,"33":1,"34":1,"35":1,"36":1,"37":1,"38":1,"39":1,"40":1,"41":1,"42":1,"43":1,"44":1,"45":1,"46":1,"47":1,"48":1,"49":1,"50":1,"51":1,"52":1,"53":1,"54":1,"55":1,"56":1,"57":1,"58":1,"59":1,"60":1,"61":1,"62":1,"63":1,"64":1,"65":1,"66":1,"67":1,"68":1,"69":1,"70":1,"71":1,"72":1,"73":1,"74":1,"75":1,"76":1,"77":1,"78":1,"79":1,"80":1,"81":1,"82":1,"83":1,"84":1,"85":1,"86":1,"87":1,"88":1,"89":1,"90":1,"91":1,"92":1,"93":1,"94":1,"95":1,"96":1,"97":1,"98":1,"99":1,"a100":1,"101":1,"102":1,"103":1,"104":1,"105":1,"106":1,"107":1,"108":1,"109":1,"110":1,"111":1,"112":1,"113":1,"114":1,"115":1,"116":1,"117":1,"118":1,"119":1,"120":1,"121":1,"122":1,"123":1,"124":1,"125":1,"126":1,"127":1,"128":1,"129":1,"130":1,"131":1,"132":1,"133":1,"134":1,"135":1,"136":1,"137":1,"138":1,"139":1,"140":1,"141":1,"142":1,"143":1,"144":1,"145":1,"146":1,"147":1,"148":1,"149":1,"150":1,"151":1,"152":1,"153":1,"154":1,"155":1,"156":1,"157":1,"158":1,"159":1,"160":1,"161":1,"162":1,"163":1,"164":1,"165":1,"166":1,"167":1,"168":1,"169":1,"170":1,"171":1,"172":1,"173":1,"174":1,"175":1,"176":1,"177":1,"178":1,"179":1,"180":1,"181":1,"182":1,"183":1,"184":1,"185":1,"186":1,"187":1,"188":1,"189":1,"190":1,"191":1,"192":1,"193":1,"194":1,"195":1,"196":1,"197":1,"198":1,"199":1,"200":1,"201":1,"202":1,"203":1,"204":1,"205":1,"206":1,"207":1,"208":1,"209":1,"210":1,"211":1,"212":1,"213":1,"214":1,"215":1,"216":1,"217":1,"218":1,"219":1,"220":1,"221":1,"222":1,"223":1,"224":1,"225":1,"226":1,"227":1,"228":1,"229":1,"230":1,"231":1,"232":1,"233":1,"234":1,"235":1,"236":1,"237":1,"238":1,"239":1,"240":1,"241":1,"242":1,"243":1,"244":1,"245":1,"246":1,"247":1,"248":1,"249":1,"250":1,"251":1,"252":1,"253":1,"254":1,"255":1,"256":1,"257":1,"258":1,"259":1,"260":1,"261":1,"262":1,"263":1,"264":1,"265":1,"266":1,"267":1,"268":1,"269":1,"270":1,"271":1,"272":1,"273":1,"274":1,"275":1,"276":1,"277":1,"278":1,"279":1,"280":1,"281":1,"282":1,"283":1,"284":1,"285":1,"286":1,"287":1,"288":1,"289":1,"290":1,"291":1,"292":1,"293":1,"294":1,"295":1,"296":1,"297":1,"298":1,"299":1,"300":1,"301":1,"302":1,"303":1,"304":1,"305":1,"306":1,"307":1,"308":1,"309":1,"310":1,"311":1,"312":1,"313":1,"314":1,"315":1,"316":1,"317":1,"318":1,"319":1,"320":1,"321":1,"322":1,"323":1,"324":1,"325":1,"326":1,"327":1,"328":1,"329":1,"330":1,"331":1,"332":1,"333":1,"334":1,"335":1,"336":1,"337":1,"338":1,"339":1,"340":1,"341":1,"342":1,"343":1,"344":1,"345":1,"346":1,"347":1,"348":1,"349":1,"350":1,"351":1,"352":1,"353":1,"354":1,"355":1,"356":1,"357":1,"358":1,"359":1,"360":1,"361":1,"362":1,"363":1,"364":1,"365":1,"366":1,"367":1,"368":1,"369":1,"370":1,"371":1,"372":1,"373":1,"374":1,"375":1,"376":1,"377":1,"378":1,"379":1,"380":1,"381":1,"382":1,"383":1,"384":1,"385":1,"386":1,"387":1,"388":1,"389":1,"390":1,"391":1,"392":1,"393":1,"394":1,"395":1,"396":1,"397":1,"398":1,"399":1,"400":1,"401":1,"402":1,"403":1,"404":1,"405":1,"406":1,"407":1,"408":1,"409":1,"410":1,"411":1,"412":1,"413":1,"414":1,');

update max_pairs_test set a = a || '"415":1,"416":1,"417":1,"418":1,"419":1,"420":1,"421":1,"422":1,"423":1,"424":1,"425":1,"426":1,"427":1,"428":1,"429":1,"430":1,"431":1,"432":1,"433":1,"434":1,"435":1,"436":1,"437":1,"438":1,"439":1,"440":1,"441":1,"442":1,"443":1,"444":1,"445":1,"446":1,"447":1,"448":1,"449":1,"450":1,"451":1,"452":1,"453":1,"454":1,"455":1,"456":1,"457":1,"458":1,"459":1,"460":1,"461":1,"462":1,"463":1,"464":1,"465":1,"466":1,"467":1,"468":1,"469":1,"470":1,"471":1,"472":1,"473":1,"474":1,"475":1,"476":1,"477":1,"478":1,"479":1,"480":1,"481":1,"482":1,"483":1,"484":1,"485":1,"486":1,"487":1,"488":1,"489":1,"490":1,"491":1,"492":1,"493":1,"494":1,"495":1,"496":1,"497":1,"498":1,"499":1,"500":1,"501":1,"502":1,"503":1,"504":1,"505":1,"506":1,"507":1,"508":1,"509":1,"510":1,"511":1,"512":1,"513":1,"514":1,"515":1,"516":1,"517":1,"518":1,"519":1,"520":1,"521":1,"522":1,"523":1,"524":1,"525":1,"526":1,"527":1,"528":1,"529":1,"530":1,"531":1,"532":1,"533":1,"534":1,"535":1,"536":1,"537":1,"538":1,"539":1,"540":1,"541":1,"542":1,"543":1,"544":1,"545":1,"546":1,"547":1,"548":1,"549":1,"550":1,"551":1,"552":1,"553":1,"554":1,"555":1,"556":1,"557":1,"558":1,"559":1,"560":1,"561":1,"562":1,"563":1,"564":1,"565":1,"566":1,"567":1,"568":1,"569":1,"570":1,"571":1,"572":1,"573":1,"574":1,"575":1,"576":1,"577":1,"578":1,"579":1,"580":1,"581":1,"582":1,"583":1,"584":1,"585":1,"586":1,"587":1,"588":1,"589":1,"590":1,"591":1,"592":1,"593":1,"594":1,"595":1,"a596":1,"597":1,"598":1,"599":1,"600":1,"601":1,"602":1,"603":1,"604":1,"605":1,"606":1,"607":1,"608":1,"609":1,"610":1,"611":1,"612":1,"613":1,"614":1,"615":1,"616":1,"617":1,"618":1,"619":1,"620":1,"621":1,"622":1,"623":1,"624":1,"625":1,"626":1,"627":1,"628":1,"629":1,"630":1,"631":1,"632":1,"633":1,"634":1,"635":1,"636":1,"637":1,"638":1,"639":1,"640":1,"641":1,"642":1,"643":1,"644":1,"645":1,"646":1,"647":1,"648":1,"649":1,"650":1,"651":1,"652":1,"653":1,"654":1,"655":1,"656":1,"657":1,"658":1,"659":1,"660":1,"661":1,"662":1,"663":1,"664":1,"665":1,"666":1,"667":1,"668":1,"669":1,"670":1,"671":1,"672":1,"673":1,"674":1,"675":1,"676":1,"677":1,"678":1,"679":1,"680":1,"681":1,"682":1,"683":1,"684":1,"685":1,"686":1,"687":1,"688":1,"689":1,"690":1,"691":1,"692":1,"693":1,"694":1,"695":1,"696":1,"697":1,"698":1,"699":1,"700":1,"701":1,"702":1,"703":1,"704":1,"705":1,"706":1,"707":1,"708":1,"709":1,"710":1,"711":1,"712":1,"713":1,"714":1,"715":1,"716":1,"717":1,"718":1,"719":1,"720":1,"721":1,"722":1,"723":1,"724":1,"725":1,"726":1,"727":1,"728":1,"729":1,"730":1,"731":1,"732":1,"733":1,"734":1,"735":1,"736":1,"737":1,"738":1,"739":1,"740":1,"741":1,"742":1,"743":1,"744":1,"745":1,"746":1,"747":1,"748":1,"749":1,"750":1,"751":1,"752":1,"753":1,"754":1,"755":1,"756":1,"757":1,"758":1,"759":1,"760":1,"761":1,';

update max_pairs_test set a = a || '"762":1,"763":1,"764":1,"765":1,"766":1,"767":1,"768":1,"769":1,"770":1,"771":1,"772":1,"773":1,"774":1,"775":1,"776":1,"777":1,"778":1,"779":1,"780":1,"781":1,"782":1,"783":1,"784":1,"785":1,"786":1,"787":1,"788":1,"789":1,"790":1,"791":1,"792":1,"793":1,"794":1,"795":1,"796":1,"797":1,"798":1,"799":1,"800":1,"801":1,"802":1,"803":1,"804":1,"805":1,"806":1,"807":1,"808":1,"809":1,"810":1,"811":1,"812":1,"813":1,"814":1,"815":1,"816":1,"817":1,"818":1,"819":1,"820":1,"821":1,"822":1,"823":1,"824":1,"825":1,"826":1,"827":1,"828":1,"829":1,"830":1,"831":1,"832":1,"833":1,"834":1,"835":1,"836":1,"837":1,"838":1,"839":1,"840":1,"841":1,"842":1,"843":1,"844":1,"845":1,"846":1,"847":1,"848":1,"849":1,"850":1,"851":1,"852":1,"853":1,"854":1,"855":1,"856":1,"857":1,"858":1,"859":1,"860":1,"861":1,"862":1,"863":1,"864":1,"865":1,"866":1,"867":1,"868":1,"869":1,"870":1,"871":1,"872":1,"873":1,"874":1,"875":1,"876":1,"877":1,"878":1,"879":1,"880":1,"881":1,"882":1,"883":1,"884":1,"885":1,"886":1,"887":1,"888":1,"889":1,"890":1,"891":1,"892":1,"893":1,"894":1,"895":1,"896":1,"897":1,"898":1,"899":1,"900":1,"901":1,"902":1,"903":1,"904":1,"905":1,"906":1,"907":1,"908":1,"909":1,"910":1,"911":1,"912":1,"913":1,"914":1,"915":1,"916":1,"917":1,"918":1,"919":1,"920":1,"921":1,"922":1,"923":1,"924":1,"925":1,"926":1,"927":1,"928":1,"929":1,"930":1,"931":1,"932":1,"933":1,"934":1,"935":1,"936":1,"937":1,"938":1,"939":1,"940":1,"941":1,"942":1,"943":1,"944":1,"945":1,"946":1,"947":1,"948":1,"949":1,"950":1,"951":1,"952":1,"953":1,"954":1,"955":1,"956":1,"957":1,"958":1,"959":1,"960":1,"961":1,"962":1,"963":1,"964":1,"965":1,"966":1,"967":1,"968":1,"969":1,"970":1,"971":1,"972":1,"973":1,"974":1,"975":1,"976":1,"977":1,"978":1,"979":1,"980":1,"981":1,"982":1,"983":1,"984":1,"985":1,"986":1,"987":1,"988":1,"989":1,"990":1,"991":1,"992":1,"993":1,"994":1,"995":1,"996":1,"997":1,"998":1,"999":1,"1000":1,"1001":1,"1002":1,"1003":1,"1004":1,"1005":1,"1006":1,"1007":1,"1008":1,"1009":1,"1010":1,"1011":1,"1012":1,"1013":1,"1014":1,"1015":1,"1016":1,"1017":1,"1018":1,"1019":1,"1020":1,"1021":1,"1022":1,"a1023":1}';

select length(a) from max_pairs_test where a is json;
select json_value(a, '$[0].a100') from max_pairs_test;
select json_value(a, '$[0].a596') from max_pairs_test;
select json_value(a, '$[0].a1023') from max_pairs_test;

--
truncate table max_pairs_test;
insert into max_pairs_test values ('{"0":1,"1":1,"2":1,"3":1,"4":1,"5":1,"6":1,"7":1,"8":1,"9":1,"10":1,"11":1,"12":1,"13":1,"14":1,"15":1,"16":1,"17":1,"18":1,"19":1,"20":1,"21":1,"22":1,"23":1,"24":1,"25":1,"26":1,"27":1,"28":1,"29":1,"30":1,"31":1,"32":1,"33":1,"34":1,"35":1,"36":1,"37":1,"38":1,"39":1,"40":1,"41":1,"42":1,"43":1,"44":1,"45":1,"46":1,"47":1,"48":1,"49":1,"50":1,"51":1,"52":1,"53":1,"54":1,"55":1,"56":1,"57":1,"58":1,"59":1,"60":1,"61":1,"62":1,"63":1,"64":1,"65":1,"66":1,"67":1,"68":1,"69":1,"70":1,"71":1,"72":1,"73":1,"74":1,"75":1,"76":1,"77":1,"78":1,"79":1,"80":1,"81":1,"82":1,"83":1,"84":1,"85":1,"86":1,"87":1,"88":1,"89":1,"90":1,"91":1,"92":1,"93":1,"94":1,"95":1,"96":1,"97":1,"98":1,"99":1,"a100":1,"101":1,"102":1,"103":1,"104":1,"105":1,"106":1,"107":1,"108":1,"109":1,"110":1,"111":1,"112":1,"113":1,"114":1,"115":1,"116":1,"117":1,"118":1,"119":1,"120":1,"121":1,"122":1,"123":1,"124":1,"125":1,"126":1,"127":1,"128":1,"129":1,"130":1,"131":1,"132":1,"133":1,"134":1,"135":1,"136":1,"137":1,"138":1,"139":1,"140":1,"141":1,"142":1,"143":1,"144":1,"145":1,"146":1,"147":1,"148":1,"149":1,"150":1,"151":1,"152":1,"153":1,"154":1,"155":1,"156":1,"157":1,"158":1,"159":1,"160":1,"161":1,"162":1,"163":1,"164":1,"165":1,"166":1,"167":1,"168":1,"169":1,"170":1,"171":1,"172":1,"173":1,"174":1,"175":1,"176":1,"177":1,"178":1,"179":1,"180":1,"181":1,"182":1,"183":1,"184":1,"185":1,"186":1,"187":1,"188":1,"189":1,"190":1,"191":1,"192":1,"193":1,"194":1,"195":1,"196":1,"197":1,"198":1,"199":1,"200":1,"201":1,"202":1,"203":1,"204":1,"205":1,"206":1,"207":1,"208":1,"209":1,"210":1,"211":1,"212":1,"213":1,"214":1,"215":1,"216":1,"217":1,"218":1,"219":1,"220":1,"221":1,"222":1,"223":1,"224":1,"225":1,"226":1,"227":1,"228":1,"229":1,"230":1,"231":1,"232":1,"233":1,"234":1,"235":1,"236":1,"237":1,"238":1,"239":1,"240":1,"241":1,"242":1,"243":1,"244":1,"245":1,"246":1,"247":1,"248":1,"249":1,"250":1,"251":1,"252":1,"253":1,"254":1,"255":1,"256":1,"257":1,"258":1,"259":1,"260":1,"261":1,"262":1,"263":1,"264":1,"265":1,"266":1,"267":1,"268":1,"269":1,"270":1,"271":1,"272":1,"273":1,"274":1,"275":1,"276":1,"277":1,"278":1,"279":1,"280":1,"281":1,"282":1,"283":1,"284":1,"285":1,"286":1,"287":1,"288":1,"289":1,"290":1,"291":1,"292":1,"293":1,"294":1,"295":1,"296":1,"297":1,"298":1,"299":1,"300":1,"301":1,"302":1,"303":1,"304":1,"305":1,"306":1,"307":1,"308":1,"309":1,"310":1,"311":1,"312":1,"313":1,"314":1,"315":1,"316":1,"317":1,"318":1,"319":1,"320":1,"321":1,"322":1,"323":1,"324":1,"325":1,"326":1,"327":1,"328":1,"329":1,"330":1,"331":1,"332":1,"333":1,"334":1,"335":1,"336":1,"337":1,"338":1,"339":1,"340":1,"341":1,"342":1,"343":1,"344":1,"345":1,"346":1,"347":1,"348":1,"349":1,"350":1,"351":1,"352":1,"353":1,"354":1,"355":1,"356":1,"357":1,"358":1,"359":1,"360":1,"361":1,"362":1,"363":1,"364":1,"365":1,"366":1,"367":1,"368":1,"369":1,"370":1,"371":1,"372":1,"373":1,"374":1,"375":1,"376":1,"377":1,"378":1,"379":1,"380":1,"381":1,"382":1,"383":1,"384":1,"385":1,"386":1,"387":1,"388":1,"389":1,"390":1,"391":1,"392":1,"393":1,"394":1,"395":1,"396":1,"397":1,"398":1,"399":1,"400":1,"401":1,"402":1,"403":1,"404":1,"405":1,"406":1,"407":1,"408":1,"409":1,"410":1,"411":1,"412":1,"413":1,"414":1,');

update max_pairs_test set a = a || '"415":1,"416":1,"417":1,"418":1,"419":1,"420":1,"421":1,"422":1,"423":1,"424":1,"425":1,"426":1,"427":1,"428":1,"429":1,"430":1,"431":1,"432":1,"433":1,"434":1,"435":1,"436":1,"437":1,"438":1,"439":1,"440":1,"441":1,"442":1,"443":1,"444":1,"445":1,"446":1,"447":1,"448":1,"449":1,"450":1,"451":1,"452":1,"453":1,"454":1,"455":1,"456":1,"457":1,"458":1,"459":1,"460":1,"461":1,"462":1,"463":1,"464":1,"465":1,"466":1,"467":1,"468":1,"469":1,"470":1,"471":1,"472":1,"473":1,"474":1,"475":1,"476":1,"477":1,"478":1,"479":1,"480":1,"481":1,"482":1,"483":1,"484":1,"485":1,"486":1,"487":1,"488":1,"489":1,"490":1,"491":1,"492":1,"493":1,"494":1,"495":1,"496":1,"497":1,"498":1,"499":1,"500":1,"501":1,"502":1,"503":1,"504":1,"505":1,"506":1,"507":1,"508":1,"509":1,"510":1,"511":1,"512":1,"513":1,"514":1,"515":1,"516":1,"517":1,"518":1,"519":1,"520":1,"521":1,"522":1,"523":1,"524":1,"525":1,"526":1,"527":1,"528":1,"529":1,"530":1,"531":1,"532":1,"533":1,"534":1,"535":1,"536":1,"537":1,"538":1,"539":1,"540":1,"541":1,"542":1,"543":1,"544":1,"545":1,"546":1,"547":1,"548":1,"549":1,"550":1,"551":1,"552":1,"553":1,"554":1,"555":1,"556":1,"557":1,"558":1,"559":1,"560":1,"561":1,"562":1,"563":1,"564":1,"565":1,"566":1,"567":1,"568":1,"569":1,"570":1,"571":1,"572":1,"573":1,"574":1,"575":1,"576":1,"577":1,"578":1,"579":1,"580":1,"581":1,"582":1,"583":1,"584":1,"585":1,"586":1,"587":1,"588":1,"589":1,"590":1,"591":1,"592":1,"593":1,"594":1,"595":1,"a596":1,"597":1,"598":1,"599":1,"600":1,"601":1,"602":1,"603":1,"604":1,"605":1,"606":1,"607":1,"608":1,"609":1,"610":1,"611":1,"612":1,"613":1,"614":1,"615":1,"616":1,"617":1,"618":1,"619":1,"620":1,"621":1,"622":1,"623":1,"624":1,"625":1,"626":1,"627":1,"628":1,"629":1,"630":1,"631":1,"632":1,"633":1,"634":1,"635":1,"636":1,"637":1,"638":1,"639":1,"640":1,"641":1,"642":1,"643":1,"644":1,"645":1,"646":1,"647":1,"648":1,"649":1,"650":1,"651":1,"652":1,"653":1,"654":1,"655":1,"656":1,"657":1,"658":1,"659":1,"660":1,"661":1,"662":1,"663":1,"664":1,"665":1,"666":1,"667":1,"668":1,"669":1,"670":1,"671":1,"672":1,"673":1,"674":1,"675":1,"676":1,"677":1,"678":1,"679":1,"680":1,"681":1,"682":1,"683":1,"684":1,"685":1,"686":1,"687":1,"688":1,"689":1,"690":1,"691":1,"692":1,"693":1,"694":1,"695":1,"696":1,"697":1,"698":1,"699":1,"700":1,"701":1,"702":1,"703":1,"704":1,"705":1,"706":1,"707":1,"708":1,"709":1,"710":1,"711":1,"712":1,"713":1,"714":1,"715":1,"716":1,"717":1,"718":1,"719":1,"720":1,"721":1,"722":1,"723":1,"724":1,"725":1,"726":1,"727":1,"728":1,"729":1,"730":1,"731":1,"732":1,"733":1,"734":1,"735":1,"736":1,"737":1,"738":1,"739":1,"740":1,"741":1,"742":1,"743":1,"744":1,"745":1,"746":1,"747":1,"748":1,"749":1,"750":1,"751":1,"752":1,"753":1,"754":1,"755":1,"756":1,"757":1,"758":1,"759":1,"760":1,"761":1,';

update max_pairs_test set a = a || '"762":1,"763":1,"764":1,"765":1,"766":1,"767":1,"768":1,"769":1,"770":1,"771":1,"772":1,"773":1,"774":1,"775":1,"776":1,"777":1,"778":1,"779":1,"780":1,"781":1,"782":1,"783":1,"784":1,"785":1,"786":1,"787":1,"788":1,"789":1,"790":1,"791":1,"792":1,"793":1,"794":1,"795":1,"796":1,"797":1,"798":1,"799":1,"800":1,"801":1,"802":1,"803":1,"804":1,"805":1,"806":1,"807":1,"808":1,"809":1,"810":1,"811":1,"812":1,"813":1,"814":1,"815":1,"816":1,"817":1,"818":1,"819":1,"820":1,"821":1,"822":1,"823":1,"824":1,"825":1,"826":1,"827":1,"828":1,"829":1,"830":1,"831":1,"832":1,"833":1,"834":1,"835":1,"836":1,"837":1,"838":1,"839":1,"840":1,"841":1,"842":1,"843":1,"844":1,"845":1,"846":1,"847":1,"848":1,"849":1,"850":1,"851":1,"852":1,"853":1,"854":1,"855":1,"856":1,"857":1,"858":1,"859":1,"860":1,"861":1,"862":1,"863":1,"864":1,"865":1,"866":1,"867":1,"868":1,"869":1,"870":1,"871":1,"872":1,"873":1,"874":1,"875":1,"876":1,"877":1,"878":1,"879":1,"880":1,"881":1,"882":1,"883":1,"884":1,"885":1,"886":1,"887":1,"888":1,"889":1,"890":1,"891":1,"892":1,"893":1,"894":1,"895":1,"896":1,"897":1,"898":1,"899":1,"900":1,"901":1,"902":1,"903":1,"904":1,"905":1,"906":1,"907":1,"908":1,"909":1,"910":1,"911":1,"912":1,"913":1,"914":1,"915":1,"916":1,"917":1,"918":1,"919":1,"920":1,"921":1,"922":1,"923":1,"924":1,"925":1,"926":1,"927":1,"928":1,"929":1,"930":1,"931":1,"932":1,"933":1,"934":1,"935":1,"936":1,"937":1,"938":1,"939":1,"940":1,"941":1,"942":1,"943":1,"944":1,"945":1,"946":1,"947":1,"948":1,"949":1,"950":1,"951":1,"952":1,"953":1,"954":1,"955":1,"956":1,"957":1,"958":1,"959":1,"960":1,"961":1,"962":1,"963":1,"964":1,"965":1,"966":1,"967":1,"968":1,"969":1,"970":1,"971":1,"972":1,"973":1,"974":1,"975":1,"976":1,"977":1,"978":1,"979":1,"980":1,"981":1,"982":1,"983":1,"984":1,"985":1,"986":1,"987":1,"988":1,"989":1,"990":1,"991":1,"992":1,"993":1,"994":1,"995":1,"996":1,"997":1,"998":1,"999":1,"1000":1,"1001":1,"1002":1,"1003":1,"1004":1,"1005":1,"1006":1,"1007":1,"1008":1,"1009":1,"1010":1,"1011":1,"1012":1,"1013":1,"1014":1,"1015":1,"1016":1,"1017":1,"1018":1,"1019":1,"1020":1,"1021":1,"1022":1,"a1023":1,"1024":1}';

select length(a) from max_pairs_test where a is json;
select json_value(a, '$[0].a100') from max_pairs_test;
select json_value(a, '$[0].a596') from max_pairs_test;
select json_value(a, '$[0].a1023') from max_pairs_test;
drop table if exists max_pairs_test;

---------------------------------------------------------------------4. json data format (array)
--valid test
select 1 from dual where '[[[{[][]},[[]]]]]' is json;
select 1 from dual where '1,1,2,3,4,565,8]' is json;
select 1 from dual where '[1,1,2,3,4,565,8' is json;
select 1 from dual where '[1,1,]2[,3,4,565,8}' is json;
select 1 from dual where '[1,1,2,3,4,565,8}' is json;
select 1 from dual where '[1,1,2,3,[4,565,8]' is json;
select 1 from dual where '[1,1,2,3,{4},565,8]' is json;

select 1 from dual where '[[[{},[[]]]]]' is json;
select 1 from dual where '[1,1,2,3,4,565,8]' is json;
select 1 from dual where '[1.1,1,9.2,3,4,565,8]' is json;
select 1 from dual where '[1.1,true,9.2,false,4,565,null,"jkdsd",[5,[{},58,[],[6],5],9,78],{"asa":"sds"}]' is json;

--max level(32) test 
select 1 from dual where '[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[2]]]]]]]]]]]]]]]]]]]]]]]]]]]' is json;
select 1 from dual where '[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[2]]]]]]]]]]]]]]]]]]]]]]]]]]]]' is json;
select 1 from dual where '[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[2]]]]]]]]]]]]]]]]]]]]]]]]]]]]]' is json;
select 1 from dual where '[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[2]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]' is json;
select 1 from dual where '[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[2]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]' is json;
select 1 from dual where '[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[2]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]' is json;
select 1 from dual where '[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[2]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]' is json;
select 1 from dual where '[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[2]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]' is json;
select 1 from dual where '[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[2]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]' is json;

--max array item num(1024) test 
drop table if exists max_array_items_test;
create table max_array_items_test(a int, b clob);
insert into max_array_items_test values(1, '[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,709,710]');
insert into max_array_items_test values(2, '[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831,832,833,834,835,836,837,838,839,840,841,842,843,844,845,846,847,848,849,850,851,852,853,854,855,856,857,858,859,860,861,862,863,864,865,866,867,868,869,870,871,872,873,874,875,876,877,878,879,880,881,882,883,884,885,886,887,888,889,890,891,892,893,894,895,896,897,898,899,900,901,902,903,904,905,906,907,908,909,910,911,912,913,914,915,916,917,918,919,920,921,922,923,924,925,926,927,928,929,930,931,932,933,934,935,936,937,938,939]');
insert into max_array_items_test values(3, '[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831,832,833,834,835,836,837,838,839,840,841,842,843,844,845,846,847,848,849,850,851,852,853,854,855,856,857,858,859,860,861,862,863,864,865,866,867,868,869,870,871,872,873,874,875,876,877,878,879,880,881,882,883,884,885,886,887,888,889,890,891,892,893,894,895,896,897,898,899,900,901,902,903,904,905,906,907,908,909,910,911,912,913,914,915,916,917,918,919,920,921,922,923,924,925,926,927,928,929,930,931,932,933,934,935,936,937,938,939,940,941,942,943,944,945,946,947,948,949,950,951,952,953,954,955,956,957,958,959,960,961,962,963,964,965,966,967,968,969,970,971,972,973,974,975,976,977,978,979,980,981,982,983,984,985,986,987,988,989,990,991,992,993,994,995,996,997,998,999,1000,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020,1021,1022,1023]');
insert into max_array_items_test values(4, '[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831,832,833,834,835,836,837,838,839,840,841,842,843,844,845,846,847,848,849,850,851,852,853,854,855,856,857,858,859,860,861,862,863,864,865,866,867,868,869,870,871,872,873,874,875,876,877,878,879,880,881,882,883,884,885,886,887,888,889,890,891,892,893,894,895,896,897,898,899,900,901,902,903,904,905,906,907,908,909,910,911,912,913,914,915,916,917,918,919,920,921,922,923,924,925,926,927,928,929,930,931,932,933,934,935,936,937,938,939,940,941,942,943,944,945,946,947,948,949,950,951,952,953,954,955,956,957,958,959,960,961,962,963,964,965,966,967,968,969,970,971,972,973,974,975,976,977,978,979,980,981,982,983,984,985,986,987,988,989,990,991,992,993,994,995,996,997,998,999,1000,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020,1021,1022,1023,1024]');

select length(b) from max_array_items_test where b is json;
select json_value(b, '$[500]') from max_array_items_test;
select json_value(b, '$[800]') from max_array_items_test;
select json_value(b, '$[900]') from max_array_items_test;
drop table if exists max_array_items_test;

---------------------------------------------------------------------5. json data format (varchar2) and mixed test
--varchar2 type col can only store 8000
--boundary test
drop table if exists json_store_test;
create table json_store_test(a varchar2(8001)
    CONSTRAINT ensure1_json CHECK (a IS JSON));
drop table if exists json_store_test;
create table json_store_test(a varchar2(8000)
    CONSTRAINT ensure1_json CHECK (a IS JSON));
insert into json_store_test values('{"name":"' || lpad('asdds', 7989, 'as') || '"}');
insert into json_store_test values('{"name":"' || lpad('asdds', 7990, 'as') || '"}');
select length(a) from  json_store_test;
select length(json_value(a, '$.name' error on error)) from  json_store_test;
select length(json_value(a, '$.name'returning varchar2(7988) error on error)) from  json_store_test;
select length(json_value(a, '$.name'returning varchar2(7989) error on error)) from  json_store_test;
select length(json_value(a, '$.name'returning varchar2(8000) error on error)) from  json_store_test;

--valid test
truncate table json_store_test;
insert into json_store_test values('{"name":"' || lpad('asdds', 7989, 'as') || '"');
insert into json_store_test values('"name":"' || lpad('asdds', 7989, 'as') || '"}');
insert into json_store_test values('{"name":' || lpad('asdds', 7989, 'as') || '}');
insert into json_store_test values('{"name" "' || lpad('asdds', 7989, 'as') || '"}');

--boundary test
drop table if exists json_store_test;
create table json_store_test(a varchar2(8000));
insert into json_store_test values('{"name":"' || lpad('asdds', 7989, 'as') || '"}');
alter table  json_store_test add CONSTRAINT  dsaaaasadsdd check(a is not json);
alter table  json_store_test add CONSTRAINT  dsaaaasadsdd check(a is json);

--(MIXED_TEST)
--mixed type test
truncate table json_store_test;
insert into json_store_test values('{
        "PONumber": 1600,
        "Reference": "ABULL-20140421",
        "Requestor": "Alexis Bull",
        "User": "ABULL",
        "CostCenter": "A50",
        "ShippingInstructions": {
            "name": "Alexis Bull",
            "Address": {
                "street": "200 Sporting Green",
                "city": "South San Francisco",
                "state": "CA",
                "zipCode": 99236,
                "country": "United States of America"
            },
            "Phone": [{
                    "type": "Office",
                    "number": "909-555-7307"
                },
                {
                    "type": "Mobile",
                    "number": "415-555-1234"
                }
            ]
        },
        "Special Instructions": null,
        "AllowPartialShipment": false,
        "LineItems": [{
                "ItemNumber": 1,
                "Part": {
                    "Description": "One Magic Christmas",
                    "UnitPrice": 19.95,
                    "UPCCode": 13131092899
                },
                "Quantity": 9.0
            },
            {
                "ItemNumber": 2,
                "Part": {
                    "Description": "Lethal Weapon",
                    "UnitPrice": 19.95,
                    "UPCCode": 85391628927
                },
                "Quantity": 5.0
            }
        ]
    }
');


select json_value(a, '$.PONumber' error on error) from  json_store_test;
select json_value(a, '$.Reference' error on error) from  json_store_test;
select json_value(a, '$.Requestor' error on error) from  json_store_test;
select json_value(a, '$.User' error on error) from  json_store_test;
select json_value(a, '$.CostCenter' error on error) from  json_store_test;
select json_query(a, '$.ShippingInstructions' error on error) from  json_store_test;
select json_value(a, '$.ShippingInstructions.name' error on error) from  json_store_test;
select json_query(a, '$.ShippingInstructions.Address' error on error) from  json_store_test;
select json_value(a, '$.ShippingInstructions.Address.street' error on error) from  json_store_test;
select json_value(a, '$.ShippingInstructions.Address.city' error on error) from  json_store_test;
select json_value(a, '$.ShippingInstructions.Address.state' error on error) from  json_store_test;
select json_value(a, '$.ShippingInstructions.Address.zipCode' error on error) from  json_store_test;
select json_value(a, '$.ShippingInstructions.Address.country' error on error) from  json_store_test;
select json_query(a, '$.ShippingInstructions.Phone' error on error) from  json_store_test;
select json_query(a, '$.ShippingInstructions.Phone[0]' error on error) from  json_store_test;
select json_value(a, '$.ShippingInstructions.Phone[0].type' error on error) from  json_store_test;
select json_value(a, '$.ShippingInstructions.Phone[0].number' error on error) from  json_store_test;
select json_query(a, '$.ShippingInstructions.Phone[1]' error on error) from  json_store_test;
select json_value(a, '$.ShippingInstructions.Phone[1].type' error on error) from  json_store_test;
select json_value(a, '$.ShippingInstructions.Phone[1].number' error on error) from  json_store_test;
select json_value(a, '$.Special Instructions' error on error error on empty) from  json_store_test;
select json_value(a, '$.AllowPartialShipment' error on error) from  json_store_test;
select json_query(a, '$.LineItems' error on error) from  json_store_test;
select json_query(a, '$.LineItems[0]' error on error) from  json_store_test;
select json_value(a, '$.LineItems[0].ItemNumber' error on error) from  json_store_test;
select json_query(a, '$.LineItems[0].Part' error on error) from  json_store_test;
select json_value(a, '$.LineItems[0].Part.Description' error on error) from  json_store_test;
select json_value(a, '$.LineItems[0].Part.UnitPrice' error on error) from  json_store_test;
select json_value(a, '$.LineItems[0].Part.UPCCode' error on error) from  json_store_test;
select json_value(a, '$.LineItems[0].Quantity' error on error) from  json_store_test;
select json_query(a, '$.LineItems[1]' error on error) from  json_store_test;
select json_value(a, '$.LineItems[1].ItemNumber' error on error) from  json_store_test;
select json_query(a, '$.LineItems[1].Part' error on error) from  json_store_test;
select json_value(a, '$.LineItems[1].Part.Description' error on error) from  json_store_test;
select json_value(a, '$.LineItems[1].Part.UnitPrice' error on error) from  json_store_test;
select json_value(a, '$.LineItems[1].Part.UPCCode' error on error) from  json_store_test;
select json_value(a, '$.LineItems[1].Quantity' error on error) from  json_store_test;

--change format test
select json_query(a, '$.*.Phone[0]' error on error) from  json_store_test;
select json_query(a, '$.*.Phone[1]' error on error) from  json_store_test;
select json_value(a, '$.*.Address.street' error on error) from  json_store_test;
select json_value(a, '$.*.Address.city' error on error) from  json_store_test;
select json_value(a, '$.*.Address.country' error on error) from  json_store_test;
select json_value(a, '$.*.*.street' error on error) from  json_store_test;
select json_value(a, '$.*.*.city' error on error) from  json_store_test;
select json_value(a, '$.*.*.country' error on error) from  json_store_test;
select json_value(a, '$.ShippingInstructions.*[0].type' error on error) from  json_store_test;
select json_value(a, '$.ShippingInstructions.*[0].number' error on error) from  json_store_test;
select json_value(a, '$.*.*[0].type' error on error) from  json_store_test;
select json_value(a, '$.*.*[0].number' error on error) from  json_store_test;
select json_value(a, '$[0].*.*[0].type' error on error) from  json_store_test;
select json_value(a, '$[0].*.*[0].number' error on error) from  json_store_test;
select json_value(a, '$[*].*.*[0].type' error on error) from  json_store_test;
select json_value(a, '$[*].*.*[0].number' error on error) from  json_store_test;

select json_value(a, '$.*[1].*.Description' error on error) from  json_store_test;
select json_value(a, '$.LineItems[1].*.Description' error on error) from  json_store_test;
select json_value(a, '$.*[1].*.Description[0]' error on error) from  json_store_test;
select json_value(a, '$.LineItems[1].*.Description[0]' error on error) from  json_store_test;
select json_value(a, '$.*[1 to].*.Description[0]' error on error) from  json_store_test;
select json_value(a, '$.LineItems[1 to].*.Description[to]' error on error) from  json_store_test;
select json_value(a, '$.*[1].Quantity' error on error) from  json_store_test;
select json_value(a, '$.*[1 to].Quantity' error on error) from  json_store_test;
select json_value(a, '$.*[1 to].Quantity[0]' error on error) from  json_store_test;
select json_value(a, '$[*].*[1 to].Quantity[0]' error on error) from  json_store_test;

select json_value(a, '$.*[0 to 1].*.Description[0]' error on error) from  json_store_test;
select json_value(a, '$.*[ to 1].*.Description[0]' error on error) from  json_store_test;

select json_query(a, '$.*.Phone[0]' error on error) from  json_store_test;

select json_value(a, '$.LineItems[0 to 1].Quantity' error on error) from  json_store_test;
select json_query(a, '$.LineItems[0 to 1]' error on error) from  json_store_test;
select json_query(a, '$.LineItems[0]' error on error) from  json_store_test;
select json_query(a, '$.LineItems[1]' error on error) from  json_store_test;

drop table if exists json_store_test;

---------------------------------------------------------------------5. json data format (clob)

drop table if exists json_store_test;
create table json_store_test(a clob);

--boundary test,max length (1M) todo....
truncate table json_store_test;
insert into json_store_test values(lpad('hello', 8000, 'hello'));
update json_store_test set a = a || '","' || a || '","' || a || '","' || a || '","' || a;
update json_store_test set a = a || '","' || a || '","' || a || '","' || a || '","' || a;
update json_store_test set a = a || '","' || a || '","' || a || '","' || a;
update json_store_test set a = '["' || a;
update json_store_test set a = a || '"]';

alter table  json_store_test add CONSTRAINT  dsaaaadsdd check(a is not json);
alter table  json_store_test add CONSTRAINT  dsaaaadsdd check(a is json);
select length(a) from json_store_test;
select length(json_value(a, '$[0]' error on error)) from json_store_test;
select length(json_value(a, '$[0]' returning varchar2(10000) error on error)) from json_store_test;
select length(json_value(a, '$[10]' error on error)) from json_store_test;
select length(json_value(a, '$[10]' returning varchar2(10000) error on error)) from json_store_test;
select length(json_value(a, '$[60]' error on error)) from json_store_test;
select length(json_value(a, '$[60]' returning varchar2(10000) error on error)) from json_store_test;
select length(json_value(a, '$[100]' error on error)) from json_store_test;
select length(json_value(a, '$[100]' returning varchar2(10000) error on error)) from json_store_test;
select length(json_value(a, '$[1000]' error on error)) from json_store_test;
select length(json_value(a, '$[1000]' returning varchar2(10000) error on error)) from json_store_test;

--exceed 1M data
truncate table json_store_test;
alter table  json_store_test drop CONSTRAINT  dsaaaadsdd;
insert into json_store_test values(lpad('hello', 8000, 'hello'));
update json_store_test set a = a || '","' || a || '","' || a || '","' || a || '","' || a;
update json_store_test set a = a || '","' || a || '","' || a || '","' || a || '","' || a;
update json_store_test set a = a || '","' || a || '","' || a || '","' || a || '","' || a || '","' || a;
update json_store_test set a = '["' || a;
update json_store_test set a = a || '"]';

alter table  json_store_test add CONSTRAINT  dsaaaadsdd check(a is not json);
alter table  json_store_test add CONSTRAINT  dsaaaadsdd check(a is json);
select length(a) from json_store_test;
select length(json_value(a, '$[0]' error on error)) from json_store_test;
select length(json_value(a, '$[0]' returning varchar2(10000) error on error)) from json_store_test;


---------------------------------------------------------------------5. json data format (is [not] json)

select 1 from dual where sysdate is json;
select 1 from dual where localtimestamp is json;
select 1 from dual where current_timestamp is json;

--1:invalid json data,is json: false   is not json:true
select 1 from dual where '{asdasdsadsadsa}' is json;
select 1 from dual where '{asdasdsadsadsa}' is not json;

--2: '' and null, both return null
select 1 from dual where (null is json);
select 1 from dual where (null is not json);
select 1 from dual where ('' is json);
select 1 from dual where ('' is not json);

select 1 from dual where json_value(null, '$') is null;
select 1 from dual where json_value('', '$') is null;

--3:scalar json data(number string true false null),is json: false   is not json:true
SELECT 1 FROM DUAL WHERE '1.23456' IS JSON;
SELECT 1 FROM DUAL WHERE '"Hello"' IS JSON;
SELECT 1 FROM DUAL WHERE 'Hello' IS JSON;
SELECT 1 FROM DUAL WHERE 'true' IS JSON;
SELECT 1 FROM DUAL WHERE 'false' IS JSON;
SELECT 1 FROM DUAL WHERE 'null' IS JSON;

--4:invalid json data,is json: true   is not json:false
SELECT 1 FROM DUAL WHERE '{}' IS JSON;
SELECT 1 FROM DUAL WHERE '{"name":"First Primary School"}' IS JSON;
SELECT 1 FROM DUAL WHERE '[]' IS JSON;
SELECT 1 FROM DUAL WHERE '[1,2,3]' IS JSON;

--is json apply in table
drop table if exists json_valid_test;
create table json_valid_test(a varchar2(4000) check(a is json), b varchar2(4000) check(b is not json), 
    c int, d int, e varchar2(4000));
alter table  json_valid_test add CONSTRAINT  dsadsdd check(c<800 and d >50 and c+d > 80 and e is json);

truncate table json_valid_test;
insert into json_valid_test values('{"say":"hello"}', '{"hehe" "yeh"}', 10, 90, '{"qwer":{"asdf":3243}}');
select * from json_valid_test;
select json_query(a, '$') from json_valid_test;
select json_query(e, '$') from json_valid_test;
select json_query(e, '$.qwer') from json_valid_test;

select json_query(a, '$') from json_valid_test;
select json_query(a, '$') from json_valid_test;
select json_query(a, '$') from json_valid_test;
select json_query(a, '$') from json_valid_test;

-- check constraint violated
insert into json_valid_test values('"say":"hello"}', '{"hehe" "yeh"}', 10, 90, '{"qwer":{"asdf":3243}}');
insert into json_valid_test values('{"say":"hello"}', '{"hehe" "yeh"}', -100, 90, '{"qwer":{"asdf":3243}}');
insert into json_valid_test values('{"say":"hello"}', '{"hehe" "yeh"}', 800, 90, '{"qwer":{"asdf":3243}}');
insert into json_valid_test values('{"say":"hello"}', '{"hehe" "yeh"}', 10, 40, '{"qwer":{"asdf":3243}}');
insert into json_valid_test values('{"say":"hello"}', '{"hehe" : "yeh"}', 10, 90, '{"qwer":{"asdf":3243}}');
insert into json_valid_test values('{"say":"hello"}', '{"hehe" "yeh"}', 10, 90, '{"qwer":{asdf:3243}}');
insert into json_valid_test values('{"say" "hello"}', '{"hehe" "yeh"}', 10, 90, '{"qwer":{"asdf":3243}}');
insert into json_valid_test values('{"say":"hello"}', '{"hehe" : "yeh"}', 10, -10, '{"qwer":{"asdf":3243}}');
insert into json_valid_test values('{"say":"hello"}', '{"hehe"  "yeh"}', 10, 90, '{"qwer":"asdf":3243}}');

SELECT   123456, CASE WHEN ('[1,2,3]' IS JSON) THEN 666      
    ELSE 888
    END
FROM dual;

SELECT   123456, CASE WHEN ('[1,2,3]' IS not JSON) THEN 666      
    ELSE 888
    END
FROM dual;

---------------------------------------------------------------------6. json_value && json_query
----(SEARCH_POINT_SCALER_TEST)
--number
--orcale: inconsistent datatypes: expected - got NUMBER
--zenith: invalid input syntax for json, JSON syntax error, unexpected scaler value.
select json_value(3218569.3218569, '$') from dual;
select json_value(3218569.3218569, '$' error on error) from dual;
select json_query(3218569.3218569, '$') from dual;
select json_query(3218569.3218569, '$' error on error) from dual;

--run same as orcale
select json_value('3218569.3218569', '$') from dual;
select json_value('3218569.3218569', '$' error on error) from dual;
select json_query('3218569.3218569', '$') from dual;
select json_query('3218569.3218569', '$' error on error) from dual;

--run same as orcale
select json_value('"3218569.3218569"', '$') from dual;
select json_value('"3218569.3218569"', '$' error on error) from dual;
select json_query('"3218569.3218569"', '$') from dual;
select json_query('"3218569.3218569"', '$' error on error) from dual;


-------------------------------------------------------------------------
--constant string
--run same as orcale
select json_value(assadfergre4323dfsfdsdfg, '$') from dual;
select json_value(assadfergre4323dfsfdsdfg, '$' error on error) from dual;
select json_query(assadfergre4323dfsfdsdfg, '$') from dual;
select json_query(assadfergre4323dfsfdsdfg, '$' error on error) from dual;

select json_value('assadfergre4323dfsfdsdfg', '$') from dual;
select json_value('assadfergre4323dfsfdsdfg', '$' error on error) from dual;
select json_query('assadfergre4323dfsfdsdfg', '$') from dual;
select json_query('assadfergre4323dfsfdsdfg', '$' error on error) from dual;

select json_value('"assadfergre4323dfsfdsdfg"', '$') from dual;
select json_value('"assadfergre4323dfsfdsdfg"', '$' error on error) from dual;
select json_query('"assadfergre4323dfsfdsdfg"', '$') from dual;
select json_query('"assadfergre4323dfsfdsdfg"', '$' error on error) from dual;


-------------------------------------------------------------------------
--boolean
--orcale: invalid identifier
select json_value(true, '$') from dual;
select json_value(true, '$' error on error) from dual;
select json_value(false, '$') from dual;
select json_value(false, '$' error on error) from dual;
select json_query(true, '$') from dual;
select json_query(true, '$' error on error) from dual;
select json_query(false, '$') from dual;
select json_query(false, '$' error on error) from dual;

--orcale: JSON syntax error
select json_value('true', '$') from dual;
select json_value('true', '$' error on error) from dual;
select json_value('false', '$') from dual;
select json_value('false', '$' error on error) from dual;
select json_query('true', '$') from dual;
select json_query('true', '$' error on error) from dual;
select json_query('false', '$') from dual;
select json_query('false', '$' error on error) from dual;

select json_value(' true ', '$') from dual;
select json_value(' true ', '$' error on error) from dual;
select json_value(' false ', '$') from dual;
select json_value(' false ', '$' error on error) from dual;
select json_query(' true ', '$') from dual;
select json_query(' true ', '$' error on error) from dual;
select json_query(' false ', '$') from dual;
select json_query(' false ', '$' error on error) from dual;

--orcale: JSON syntax error
select json_value('"true"', '$') from dual;
select json_value('"true"', '$' error on error) from dual;
select json_value('"false"', '$') from dual;
select json_value('"false"', '$' error on error) from dual;
select json_query('"true"', '$') from dual;
select json_query('"true"', '$' error on error) from dual;
select json_query('"false"', '$') from dual;
select json_query('"false"', '$' error on error) from dual;

select json_value('   "  true"', '$') from dual;
select json_value('   "  true"', '$' error on error) from dual;
select json_value('   "  false"', '$') from dual;
select json_value('   "  false"', '$' error on error) from dual;
select json_query('   "  true"', '$') from dual;
select json_query('   "  true"', '$' error on error) from dual;
select json_query('   "  false"', '$') from dual;
select json_query('   "  false"', '$' error on error) from dual;

--orcale: JSON syntax error
select json_value('false', '$.a.b') from dual;
select json_value('false', '$.a.b' error on error) from dual;
select json_value('false', '$.a.b' null on error) from dual;

select json_value('false', '$.a.b' error on empty) from dual;--doesn't take effect
select json_value('false', '$.a.b' null on empty) from dual;--doesn't take effect
--the first param of json_value and json_query is scalar will raise a json data syntax error

----(SEARCH_POINT_SCALER_TEST)
select json_value(sysdate, '$' error on error) from dual;
select json_value(localtimestamp, '$' error on error) from dual;
select json_value(current_timestamp, '$' error on error) from dual;

select json_value('{]', '$.a.b') from dual;
select json_value('{]', '$.a.b' error on error) from dual;
select json_value('{{]]]]', '$.a.b') from dual;
select json_value('{{]]]]', '$.a.b' error on error) from dual;
select json_value('{dsfdsfe}', '$.a.b') from dual;
select json_value('{dsfdsfe}', '$.a.b' error on error) from dual;
select json_value('{dsf,dsfe}', '$.a.b') from dual;
select json_value('{dsf,dsfe}', '$.a.b' error on error) from dual;
select json_query('{]', '$.a.b') from dual;
select json_query('{]', '$.a.b' error on error) from dual;
select json_query('{{]]]]', '$.a.b') from dual;
select json_query('{{]]]]', '$.a.b' error on error) from dual;
select json_query('{dsfdsfe}', '$.a.b') from dual;
select json_query('{dsfdsfe}', '$.a.b' error on error) from dual;
select json_query('{dsf,dsfe}', '$.a.b') from dual;
select json_query('{dsf,dsfe}', '$.a.b' error on error) from dual;

--escaped strs test you can search(ESCAPED_STRS_TEST)
--valid test you can search --(MIXED_TEST)
--json data format test you can see above

---------------------------------------------------------------------6. json path expr test

--we are controling the range
select json_value('[]', '$') from dual;
select json_value('{}', '$') from dual;
select json_value('[]', '$' error on error) from dual;
select json_value('{}', '$' error on error) from dual;
select json_query('[]', '$') from dual;
select json_query('{}', '$') from dual;
select json_query('[]', '$' error on error) from dual;
select json_query('{}', '$' error on error) from dual;

--,max level is 32
drop table if exists json_path_expr_test;
create table json_path_expr_test(a varchar2(8000));
alter table  json_path_expr_test add CONSTRAINT  dsaasdassafsdddsdd check(a is json);

truncate table json_path_expr_test;
insert into json_path_expr_test values(
 '[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[2]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]');
insert into json_path_expr_test values(
 '[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[1,[2]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]');

select * from  json_path_expr_test;
select json_query(a, '$') from json_path_expr_test;
select json_query(a, '$[1]') from json_path_expr_test;
select json_query(a, '$[1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;
select json_value(a, '$[1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][0]') from json_path_expr_test;
select json_query(a, '$[1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1][1]') from json_path_expr_test;


truncate table json_path_expr_test;
insert into json_path_expr_test values(
 '{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":"asdsadsa"}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}');
insert into json_path_expr_test values(
 '{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":{"A":"asdsadsa"}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}');

select json_query(a, '$') from json_path_expr_test;
select json_query(a, '$.A') from json_path_expr_test;
select json_query(a, '$.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;
select json_query(a, '$.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A.A') from json_path_expr_test;

--max length
select json_value('[0]','$   .   qqqqqqqqqqqqqqqqqq.    qqqqqqqqqqqqqqqqqq.    qqqqqqqqqqqqqqqqqq.    qqqqqqqqqqqqqqqqqq.    qqqqqqqqqqqqqqqqqq.    qqqqqqqqqqqqqqqqqq.    qqqqqqqqqqqqqqqqqq') from dual;
select json_value('[0]','$   .    qqqqqqqqqqqqqqqqqq.    qqqqqqqqqqqqqqqqqq.    qqqqqqqqqqqqqqqqqq.    qqqqqqqqqqqqqqqqqq.    qqqqqqqqqqqqqqqqqq.    qqqqqqqqqqqqqqqqqq.    qqqqqqqqqqqqqqqqqq.    qqqqqqqqqqqqqqqqqq.    qqqqqqqqqqqqqqqqqq.    qqqqqqqqqqqqqqqqqq.    qqqqqqqqqqqqqqqqqq') from dual;


--max num of arrays indexes
select json_value('[1,2.3,5]', '$[to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to]') from dual;
select json_value('[1,2.3,5]', '$[to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to]') from dual;
select json_value('[1,2.3,5]', '$[to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to]') from dual;
select json_value('[1,2.3,5]', '$[to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to]') from dual;
select json_value('[1,2.3,5]', '$[to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to]') from dual;
select json_value('[1,2.3,5]', '$[to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to]') from dual;
select json_value('[1,2.3,5]', '$[to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to,to]') from dual;

--max stepname 68-1 , The excess will be truncated
select json_value('[{"qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq":123456},2.3,5]', '$[0].qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq') from dual;
select json_value('[{"qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq":123456},2.3,5]', '$[0].qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq') from dual;
select json_value('[{"qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq":123456},2.3,5]', '$[0].qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq') from dual;
select json_value('[{"qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq":123456},2.3,5]', '$[0].qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq') from dual;
select json_value('[{"qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq":123456},2.3,5]', '$[0].qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq') from dual;

select json_value('[{"qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq":123456},2.3,5]', '$[0].qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq') from dual;
select json_value('[{"qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq":123456},2.3,5]', '$[0].qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq') from dual;
select json_value('[{"qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq":123456},2.3,5]', '$[0].qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq') from dual;
select json_value('[{"qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq":123456},2.3,5]', '$[0].qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq') from dual;
select json_value('[{"qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq":123456},2.3,5]', '$[0].qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq') from dual;


---------------------------------------------------------------------6. json path returning test
--size test desc -q you can also search(RETUNING_SIZE_TEST)
select length('{"name":"' || lpad('asdds', 9990, 'as') || '"}') from dual;
select length('{"name":"' || lpad('asdds', 7990, 'as') || '"}') from dual;
select length('{"name":"' || lpad('asdds', 7989, 'as') || '"}') from dual;
select length('{"name":"' || lpad('asdds', 6666, 'as') || '"}') from dual;
select length('{"name":"' || lpad('asdds', 4000, 'as') || '"}') from dual;
select length('{"name":"' || lpad('asdds', 3990, 'as') || '"}') from dual; 
select length('{"name":"' || lpad('asdds', 3989, 'as') || '"}') from dual;
select length('{"name":"' || lpad('asdds', 3199, 'as') || '"}') from dual;

--default return size 3900 of json_value
select length(json_value('{"name":"' || lpad('asdds', 9990, 'as') || '"}', '$.name' error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 7990, 'as') || '"}', '$.name' error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 7989, 'as') || '"}', '$.name' error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 6666, 'as') || '"}', '$.name' error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 4000, 'as') || '"}', '$.name' error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 3990, 'as') || '"}', '$.name' error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 3989, 'as') || '"}', '$.name' error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 3199, 'as') || '"}', '$.name' error on error)) from dual;

--default return size 3900 of json_query
select length(json_query('{"name":"' || lpad('asdds', 9990, 'as') || '"}', '$' error on error)) from dual;
select length(json_query('{"name":"' || lpad('asdds', 7990, 'as') || '"}', '$' error on error)) from dual;
select length(json_query('{"name":"' || lpad('asdds', 7989, 'as') || '"}', '$' error on error)) from dual;
select length(json_query('{"name":"' || lpad('asdds', 6666, 'as') || '"}', '$' error on error)) from dual;
select length(json_query('{"name":"' || lpad('asdds', 4000, 'as') || '"}', '$' error on error)) from dual;
select length(json_query('{"name":"' || lpad('asdds', 3990, 'as') || '"}', '$' error on error)) from dual;
select length(json_query('{"name":"' || lpad('asdds', 3989, 'as') || '"}', '$' error on error)) from dual;
select length(json_query('{"name":"' || lpad('asdds', 3199, 'as') || '"}', '$' error on error)) from dual;

--oracle will output :result of string concatenation is too long
--it is lpad and || matters , not json !!!!
--it is lpad and || matters , not json !!!!
--it is lpad and || matters , not json !!!!
select length('{"name":"' || lpad('asdds', 9999, 'as') || '"}') from dual;
select length(json_value('{"name":"' || lpad('asdds', 9990, 'as') || '"}', '$.name' returning varchar2(10000) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 7990, 'as') || '"}', '$.name' returning varchar2(8000) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 7989, 'as') || '"}', '$.name' returning varchar2(8000) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 6666, 'as') || '"}', '$.name' returning varchar2(7000) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 4000, 'as') || '"}', '$.name' returning varchar2(4001) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 3990, 'as') || '"}', '$.name' returning varchar2(3999) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 3989, 'as') || '"}', '$.name' returning varchar2(4000) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 3199, 'as') || '"}', '$.name' returning varchar2(3200) error on error)) from dual;


select length(json_value('{"name":"' || lpad('asdds', 2990, 'as') || '"}', '$.name' returning varchar2(10000) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 3913, 'as') || '"}', '$.name' returning varchar2(8000) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 1989, 'as') || '"}', '$.name' returning varchar2(8000) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 1666, 'as') || '"}', '$.name' returning varchar2(7000) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 1000, 'as') || '"}', '$.name' returning varchar2(4001) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 3910, 'as') || '"}', '$.name' returning varchar2(3999) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 3989, 'as') || '"}', '$.name' returning varchar2(4000) error on error)) from dual;
select length(json_value('{"name":"' || lpad('asdds', 3199, 'as') || '"}', '$.name' returning varchar2(3200) error on error)) from dual;


--type show
select json_value('{"name":"dsgfbhgfrhvbtrhbyrjwevcwgetbhytebjj"}','$.name') from dual;
desc -q select json_value('{"name":"dsgfbhgfrhvbtrhbyrjwevcwgetbhytebjj"}','$.name') from dual;
select json_value('{"name":"dsgfbhgfrhvbtrhbyrjwevcwgetbhytebjj"}','$.name' returning varchar2(200) error on error) from dual;
desc -q select json_value('{"name":"dsgfbhgfrhvbtrhbyrjwevcwgetbhytebjj"}','$.name' returning varchar2(200) error on error) from dual;
select json_value('{"name":"dsgfbhgfrhvbtrhbyrjwevcwgetbhytebjj"}','$.name' returning varchar2(3900) error on error) from dual;
desc -q select json_value('{"name":"dsgfbhgfrhvbtrhbyrjwevcwgetbhytebjj"}','$.name' returning varchar2(3900) error on error) from dual;
select json_value('{"name":"dsgfbhgfrhvbtrhbyrjwevcwgetbhytebjj"}','$.name' returning varchar2(4000) error on error) from dual;
desc -q select json_value('{"name":"dsgfbhgfrhvbtrhbyrjwevcwgetbhytebjj"}','$.name' returning varchar2(4000) error on error) from dual;
select json_value('{"name":"dsgfbhgfrhvbtrhbyrjwevcwgetbhytebjj"}','$.name' returning varchar2(7000) error on error) from dual;
desc -q select json_value('{"name":"dsgfbhgfrhvbtrhbyrjwevcwgetbhytebjj"}','$.name' returning varchar2(7000) error on error) from dual;

--ok 
select json_value('{"name":"' || lpad('asdds', 35, 'as') || '"}','$.name') from dual;
desc -q select json_value('{"name":"' || lpad('asdds', 35, 'as') || '"}','$.name') from dual;
select json_value('{"name":"' || lpad('asdds', 35, 'as') || '"}','$.name' returning varchar2(20) error on error) from dual;
desc -q select json_value('{"name":"' || lpad('asdds', 35, 'as') || '"}','$.name' returning varchar2(20) error on error) from dual;
select json_value('{"name":"' || lpad('asdds', 35, 'as') || '"}','$.name' returning varchar2(3900) error on error) from dual;
desc -q select json_value('{"name":"' || lpad('asdds', 35, 'as') || '"}','$.name' returning varchar2(3900) error on error) from dual;
select json_value('{"name":"' || lpad('asdds', 35, 'as') || '"}','$.name' returning varchar2(4000) error on error) from dual;
desc -q select json_value('{"name":"' || lpad('asdds', 35, 'as') || '"}','$.name' returning varchar2(4000) error on error) from dual;
select json_value('{"name":"' || lpad('asdds', 35, 'as') || '"}','$.name' returning varchar2(7000) error on error) from dual;
desc -q select json_value('{"name":"' || lpad('asdds', 35, 'as') || '"}','$.name' returning varchar2(7000) error on error) from dual;

--boundary test
select json_value('{"name":"dsgfbhgfrhvbtrhbyrjwevcwgetbhytebjj"}','$.name' returning varchar2(32768) error on error) from dual;
select json_value('{"name":"dsgfbhgfrhvbtrhbyrjwevcwgetbhytebjj"}','$.name' returning varchar2(0) error on error) from dual;
select json_value('{"name":"dsgfbhgfrhvbtrhbyrjwevcwgetbhytebjj"}','$.name' returning varchar2(-1) error on error) from dual;

select json_value('{"name":"dsgfbhgfrhvbtrhbyrjwevcwgetbhytebjj"}','$.name' returning varchar2(32767) error on error) from dual;
select json_value('{"name":"dsgfbhgfrhvbtrhbyrjwevcwgetbhytebjj"}','$.name' returning varchar2(500) error on error) from dual;
select json_value('{"name":"dsgfbhgfrhvbtrhbyrjwevcwgetbhytebjj"}','$.name' returning varchar2(8691) error on error) from dual;

--retur clause in func index
--unique index
DROP TABLE if exists returning_clasu_in_func_test;
CREATE TABLE returning_clasu_in_func_test
   (id          int NOT NULL,
    po_document varchar(4000)
    CONSTRAINT ensure_jsonxxxxx CHECK (po_document IS JSON));


select JSON_value('["abc","def","qwe"]', '$[1]') from dual;
select JSON_value('["abfewfc","dedfs","qwesaew"]', '$[1]') from dual;
select JSON_value('["abteyythc","def","qwergwefe"]', '$[1]') from dual;
select JSON_value('["absadsrfewfc","dedssdfs","qwfgvdsesaew"]', '$[1]') from dual;
select JSON_value('["abteyyth2334432c","def","qwer543543gwefe"]', '$[1]') from dual;

drop index if exists xxx_json_test_idx on returning_clasu_in_func_test;
truncate table returning_clasu_in_func_test;
create unique index xxx_json_test_idx on returning_clasu_in_func_test(JSON_VALUE(PO_DOCUMENT, '$[1]' returning varchar2(500)));
insert into returning_clasu_in_func_test values(1, '["abc","def","qwe"]');
insert into returning_clasu_in_func_test values(2, '["abfewfc","dedfs","qwesaew"]');
insert into returning_clasu_in_func_test values(3, '["abteyythc","def","qwergwefe"]');
insert into returning_clasu_in_func_test values(4, '["absadsrfewfc","dedssdfs","qwfgvdsesaew"]');
insert into returning_clasu_in_func_test values(5, '["abteyyth2334432c","def","qwer543543gwefe"]');
select * from returning_clasu_in_func_test order by id;
select JSON_value(po_document, '$[1]') from returning_clasu_in_func_test order by 1;
select length(JSON_value(po_document, '$[1]')) from returning_clasu_in_func_test order by 1;

drop index if exists xxx_json_test_idx on returning_clasu_in_func_test;
truncate table returning_clasu_in_func_test;
create unique index xxx_json_test_idx on returning_clasu_in_func_test(JSON_VALUE(PO_DOCUMENT, '$[1]' returning varchar2(666)));
insert into returning_clasu_in_func_test values(1, '["abc","def","qwe"]');
insert into returning_clasu_in_func_test values(2, '["abfewfc","dedfs","qwesaew"]');
insert into returning_clasu_in_func_test values(3, '["abteyythc","def","qwergwefe"]');
insert into returning_clasu_in_func_test values(4, '["absadsrfewfc","dedssdfs","qwfgvdsesaew"]');
insert into returning_clasu_in_func_test values(5, '["abteyyth2334432c","def","qwer543543gwefe"]');
select * from returning_clasu_in_func_test;
select JSON_value(po_document, '$[1]') from returning_clasu_in_func_test;
select length(JSON_value(po_document, '$[1]')) from returning_clasu_in_func_test;

drop index if exists xxx_json_test_idx on returning_clasu_in_func_test;
truncate table returning_clasu_in_func_test;
create unique index xxx_json_test_idx on returning_clasu_in_func_test(JSON_VALUE(PO_DOCUMENT, '$[1]' returning varchar2(1024)));
insert into returning_clasu_in_func_test values(1, '["abc","def","qwe"]');
insert into returning_clasu_in_func_test values(2, '["abfewfc","dedfs","qwesaew"]');
insert into returning_clasu_in_func_test values(3, '["abteyythc","def","qwergwefe"]');
insert into returning_clasu_in_func_test values(4, '["absadsrfewfc","dedssdfs","qwfgvdsesaew"]');
insert into returning_clasu_in_func_test values(5, '["abteyyth2334432c","def","qwer543543gwefe"]');
select * from returning_clasu_in_func_test;
select JSON_value(po_document, '$[1]') from returning_clasu_in_func_test order by 1;
select length(JSON_value(po_document, '$[1]')) from returning_clasu_in_func_test order by 1;

drop index if exists xxx_json_test_idx on returning_clasu_in_func_test;
truncate table returning_clasu_in_func_test;
create unique index xxx_json_test_idx on returning_clasu_in_func_test(JSON_VALUE(PO_DOCUMENT, '$[1]' returning varchar2(3900)));
insert into returning_clasu_in_func_test values(1, '["abc","def","qwe"]');
insert into returning_clasu_in_func_test values(2, '["abfewfc","dedfs","qwesaew"]');
insert into returning_clasu_in_func_test values(3, '["abteyythc","def","qwergwefe"]');
insert into returning_clasu_in_func_test values(4, '["absadsrfewfc","dedssdfs","qwfgvdsesaew"]');
insert into returning_clasu_in_func_test values(5, '["abteyyth2334432c","def","qwer543543gwefe"]');
select * from returning_clasu_in_func_test order by id;
select JSON_value(po_document, '$[1]') from returning_clasu_in_func_test order by 1;
select length(JSON_value(po_document, '$[1]')) from returning_clasu_in_func_test order by 1;

drop index if exists xxx_json_test_idx on returning_clasu_in_func_test;
create unique index xxx_json_test_idx on returning_clasu_in_func_test(JSON_VALUE(PO_DOCUMENT, '$[1]' returning varchar2(4100)));

drop index if exists xxx_json_test_idx on returning_clasu_in_func_test;
create unique index xxx_json_test_idx on returning_clasu_in_func_test(JSON_VALUE(PO_DOCUMENT, '$[1]' returning varchar2(8000)));

drop index if exists xxx_json_test_idx on returning_clasu_in_func_test;
create unique index xxx_json_test_idx on returning_clasu_in_func_test(JSON_VALUE(PO_DOCUMENT, '$[1]' returning varchar2(3000)));

drop index if exists xxx_json_test_idx on returning_clasu_in_func_test;
create unique index xxx_json_test_idx on returning_clasu_in_func_test(JSON_VALUE(PO_DOCUMENT, '$[1]' returning varchar2(9999)));

DROP TABLE if exists returning_clasu_in_func_test;

---------------------------------------------------------------------6. json path on error/empty clause test
--yon can also see(ERROR_EMPTY_TEST) and (SEARCH_POINT_SCALER_TEST)


---------------------------------------------------------------------7. json_query test
--(ESCAPED_STRS_TEST)
--valid string in object/array and escaped str
select json_query('{"name":"asdfdfasdfdf"}', '$') from dual;
select length(json_query('{"name":"asdfdfasdfdf"}', '$')) from dual;
select json_query('{"name":"\\as\\dfdf\\\\\\asdf\\df"}', '$' error on error) from dual;
select length(json_query('{"name":"\\as\\dfdf\\\\\\asdf\\df"}', '$' error on error)) from dual;
select json_query('{"name":"\"asdfd\"\"\"fasdfd\"f\""}', '$') from dual;
select length(json_query('{"name":"\"asdfd\"\"\"fasdfd\"f\""}', '$')) from dual;
select json_query('{"name":"\/\/\/asdf\/\/\/dfasd\/\/\/fdf\/\/\/"}', '$') from dual;
select length(json_query('{"name":"\/\/\/asdf\/\/\/dfasd\/\/\/fdf\/\/\/"}', '$')) from dual;
select json_query('{"name":"\nasdf\n\ndfasdf\n\ndf\n"}', '$') from dual;
select length(json_query('{"name":"\nasdf\n\ndfasdf\n\ndf\n"}', '$')) from dual;
select json_query('{"name":"\fas\fdf\fd\f\f\ffa\fsdf\fdf\f\f"}', '$') from dual;
select length(json_query('{"name":"\fas\fdf\fd\f\f\ffa\fsdf\fdf\f\f"}', '$')) from dual;
select json_query('{"name":"\tasd\tfdf\t\t\tasd\tfd\tf\t"}', '$') from dual;
select length(json_query('{"name":"\tasd\tfdf\t\t\tasd\tfd\tf\t"}', '$')) from dual;
select json_query('{"name":"\"asd\"fdf\"\"\"\"\"as\"d\"fd\"f\""}', '$') from dual;
select length(json_query('{"name":"\"asd\"fdf\"\"\"\"\"as\"d\"fd\"f\""}', '$')) from dual;

select json_query('{"name":"\na\ns\ndf\n\ndfasdf\n\ndf"}', '$') from dual;
select json_query('{"name":"\na\ns\ndf\n\ndfasdf\n\ndf\n"}', '$') from dual;
select json_query('{"name":"\na\ns\ndf\n\ndfasdf\n\ndf\n\n"}', '$') from dual;
select json_query('{"name":"\na\ns\ndf\n\ndfasdf\n\ndf\n\n\n"}', '$') from dual;

select json_query('{"name":"\bs"}', '$') from dual;
select length(json_query('{"name":"\bs"}', '$')) from dual;
select json_query('{"name":"\bsx"}', '$') from dual;
select length(json_query('{"name":"\bsx"}', '$')) from dual;
select json_query('{"name":"\bsaax\b"}', '$') from dual;
select length(json_query('{"name":"\bsaax\b"}', '$')) from dual;
select json_query('{"name":"a\bsd"}', '$') from dual;
select length(json_query('{"name":"a\bsd"}', '$')) from dual;
select json_query('{"name":"a\b\bsd"}', '$') from dual;
select length(json_query('{"name":"a\b\bsd"}', '$')) from dual;

select json_query('{"name":"\bsaqqx\b"}', '$') from dual;
select length(json_query('{"name":"\bsaqqx\b"}', '$')) from dual;
select json_query('{"name":"\bsaqqx\b\b"}', '$') from dual;
select length(json_query('{"name":"\bsaqqx\b\b"}', '$')) from dual;

select json_query('{"name":"\ba\b\bsdfdf\b\basdf\b\bdf\b"}', '$') from dual;
select length(json_query('{"name":"\ba\b\bsdfdf\b\basdf\b\bdf\b"}', '$')) from dual;
select json_query('{"name":"\ras\rdf\rdf\r\r\ras\rd\rf\rxx\r"}', '$') from dual;
select length(json_query('{"name":"\ras\rdf\rdf\r\r\ras\rd\rf\rxx\r"}', '$')) from dual;
select json_query('{"name":"\ras\rdf\rdf\r\r\ras\rd\rf\rxx"}', '$') from dual;
select length(json_query('{"name":"\ras\rdf\rdf\r\r\ras\rd\rf\rxx"}', '$')) from dual;

select json_query('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$') from dual;
select json_query('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx\r"}', '$') from dual;
select json_query('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx\r\r"}', '$') from dual;
select json_query('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx\r\r\r"}', '$') from dual;
select json_query('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf"}', '$') from dual;
select json_query('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf\b"}', '$') from dual;
select json_query('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf\b\b"}', '$') from dual;
select json_query('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf\b\b\b"}', '$') from dual;

select length(json_query('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$')) from dual;
select length(json_query('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx\r"}', '$')) from dual;
select length(json_query('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx\r\r"}', '$')) from dual;
select length(json_query('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx\r\r\r"}', '$')) from dual;
select length(json_query('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf"}', '$')) from dual;
select length(json_query('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf\b"}', '$')) from dual;
select length(json_query('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf\b\b"}', '$')) from dual;
select length(json_query('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf\b\b\b"}', '$')) from dual;

select hex(json_query('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$')) from dual;
select hex(json_query('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx\r"}', '$')) from dual;
select hex(json_query('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx\r\r"}', '$')) from dual;
select hex(json_query('{"name":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx\r\r\r"}', '$')) from dual;
select hex(json_query('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf"}', '$')) from dual;
select hex(json_query('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf\b"}', '$')) from dual;
select hex(json_query('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf\b\b"}', '$')) from dual;
select hex(json_query('{"name":"\b\ba\b\bsdfdf\b\basdf\b\bdf\b\b\b"}', '$')) from dual;

--mixed
select json_query('{"name":"\\a\"s\\d\/f\ndfa\f\nsd\f\\f\tdf"}', '$') from dual;
select length(json_query('{"name":"\\a\"s\\d\/f\ndfa\f\nsd\f\\f\tdf"}', '$')) from dual;
select json_query('{"name":"\\a\\\"\\s\\d\/f\ndf\na\"\f\n\f\fs\f\f\"d\f\"\\f\\\tdf\\"}', '$') from dual;
select length(json_query('{"name":"\\a\\\"\\s\\d\/f\ndf\na\"\f\n\f\fs\f\f\"d\f\"\\f\\\tdf\\"}', '$')) from dual;




--when key name has escaped char
--------------------------------------
select json_query('{"na\"me":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$') from dual;
select json_value('{"na\"me":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$.name') from dual;
select json_value('{"na\"me":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$.*') from dual;
select json_value('{"na\"me":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$.na"me') from dual;
select json_value('{"na\"me":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$.na\"me') from dual;

select json_query('{"na\"m\\e":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$') from dual;
select json_value('{"na\"m\\e":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$.name') from dual;
select json_value('{"na\"m\\e":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$.*') from dual;
select json_value('{"na\"m\\e":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$.nam\\e') from dual;
select json_value('{"na\"m\\e":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$.na\"me') from dual;
select json_value('{"na\"m\\e":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$.na\"m\\e') from dual;

select json_query('{"n\ra\"m\\e":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$') from dual;
select json_value('{"n\ra\"m\\e":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$.name') from dual;
select json_value('{"n\ra\"m\\e":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$.*') from dual;
select json_value('{"n\ra\"m\\e":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$.n\ra\"m\\e') from dual;
select json_value('{"n\ra\"m\\e":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$.n\ram\\e') from dual;
select json_value('{"n\ra\"m\\e":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$.n\rame') from dual;
select json_value('{"n\ra\"m\\e":"\r\ra\rs\rdf\rdf\r\r\ras\rd\rf\rxxxx"}', '$.n\ra\"m\\e') from dual;

select json_query('{"title": "Goodbye!","author" : {"givenName" : "John","familyName" : "Doe"},"tags":[ "example", "sample" ],"content": "This will be unchanged"}', '$') from dual;
select json_query('{"title": "Goodbye!","author" : {"givenName" : "John","familyName" : "Doe"},"tags":[ "example", "sample" ],"content": "This will be unchanged"}', '$.author') from dual;
select json_query('{"title": "Goodbye!","aut\\hor" : {"givenName" : "John","familyName" : "Doe"},"tags":[ "example", "sample" ],"content": "This will be unchanged"}', '$.aut\\hor') from dual;
select json_value('{"title": "Goodbye!","author" : {"givenName" : "John","familyName" : "Doe"},"tags":[ "example", "sample" ],"content": "This will be unchanged"}', '$.author.givenName') from dual;
select json_value('{"title": "Goodbye!","aut\\hor" : {"givenName" : "John","familyName" : "Doe"},"tags":[ "example", "sample" ],"content": "This will be unchanged"}', '$.aut\\hor.givenName') from dual;
select json_value('{"title": "Goodbye!","author" : {"givenName" : "John","familyName" : "Doe"},"tags":[ "example", "sample" ],"content": "This will be unchanged"}', '$.tags[0]') from dual;
select json_value('{"title": "Goodbye!","author" : {"givenName" : "John","familyName" : "Doe"},"ta\\gs":[ "example", "sample" ],"content": "This will be unchanged"}', '$.ta\\gs[0]') from dual;

--------------------------------------


---------------------------------------------------------------------8. json_exists test
--first json data is null , return false
--first json data is scaler , treat it as not well-formed JSON data
--first json data is array/object , to match, it is influenced by exist_on_error_clause

drop table if exists json_exists_test;
CREATE TABLE json_exists_test (id int, name VARCHAR2(100));

truncate table json_exists_test;
INSERT INTO json_exists_test VALUES (1, '[{"first":"John"}, {"middle":"Mark"}, {"last":"Smith"}]');
INSERT INTO json_exists_test VALUES (2, '[{"first":"Mary"}, {"last":"Jones"}]');
INSERT INTO json_exists_test VALUES (3, '[{"first":"Jeff"}, {"last":"Williams"}]');
INSERT INTO json_exists_test VALUES (4, '[{"first":"Jean"}, {"middle":"Anne"}, {"last":"Brown"}]');
INSERT INTO json_exists_test VALUES (5, '[{"first":"John"}, {"middle":"Mark"}, {"last":"Smith"}, {"hon":[{"a":123},{"b":894}]}]');
INSERT INTO json_exists_test VALUES (6, NULL);
INSERT INTO json_exists_test VALUES (7, 'NULL');
INSERT INTO json_exists_test VALUES (8, '"NULL"');
INSERT INTO json_exists_test VALUES (9, true);
INSERT INTO json_exists_test VALUES (10, 'true');
INSERT INTO json_exists_test VALUES (11, '"true"');
INSERT INTO json_exists_test VALUES (12, false);
INSERT INTO json_exists_test VALUES (13, 'false');
INSERT INTO json_exists_test VALUES (14, '"false"');
INSERT INTO json_exists_test VALUES (15, 123.456);
INSERT INTO json_exists_test VALUES (16, '123.456');
INSERT INTO json_exists_test VALUES (17, '"123.456"');
INSERT INTO json_exists_test VALUES (18, asdffggr);
INSERT INTO json_exists_test VALUES (19, 'asdffggr');
INSERT INTO json_exists_test VALUES (20, '"asdffggr"');
INSERT INTO json_exists_test VALUES (21, 'This is not well-formed JSON data');

SELECT name FROM json_exists_test WHERE JSON_EXISTS(name, '$[0].first') order by id;
SELECT name FROM json_exists_test WHERE JSON_EXISTS(name, '$[0].first' false ON ERROR) order by id;
SELECT name FROM json_exists_test WHERE JSON_EXISTS(name, '$[0].first' TRUE ON ERROR) order by id; 
SELECT name FROM json_exists_test WHERE JSON_EXISTS(name, '$[0].first' error ON ERROR) order by id;

SELECT name FROM json_exists_test WHERE JSON_EXISTS(name, '$[*].hon[0].a') order by id;
SELECT name FROM json_exists_test WHERE JSON_EXISTS(name, '$[*].hon[0].a' false ON ERROR) order by id;
SELECT name FROM json_exists_test WHERE JSON_EXISTS(name, '$[*].hon[0].a' TRUE ON ERROR) order by id;
SELECT name FROM json_exists_test WHERE JSON_EXISTS(name, '$[*].hon[0].a' error ON ERROR) order by id;
--no this path reurn false
SELECT name FROM json_exists_test WHERE JSON_EXISTS(name, '$[0].first1') order by id;
SELECT name FROM json_exists_test WHERE JSON_EXISTS(name, '$[0].first12') order by id;


SELECT name FROM json_exists_test WHERE JSON_EXISTS(name, '$[1].middle') order by id;
SELECT name FROM json_exists_test WHERE JSON_EXISTS(name, '$[1].middle' false ON ERROR) order by id;
SELECT name FROM json_exists_test WHERE JSON_EXISTS(name, '$[1].middle' TRUE ON ERROR) order by id; 
SELECT name FROM json_exists_test WHERE JSON_EXISTS(name, '$[1].middle' error ON ERROR) order by id;

SELECT name FROM json_exists_test WHERE JSON_EXISTS(name, '$[*].last') order by id;
drop table if exists json_exists_test;

SELECT 1 from dual where  JSON_EXISTS('[{"first":"John"}, {"middle":"Mark"}, {"last":"Smith"}]', '$[0].first');
SELECT 1 from dual where  JSON_EXISTS('[{"first":"John"}, {"first":"Mark"}, {"first":"Smith"}]', '$[0].first');

SELECT 1 from dual where  JSON_EXISTS('[{"first":"John"}, {"middle":"Mark"}, {"last":"Smith"}]', '$[*].first');
SELECT 1 from dual where  JSON_EXISTS('[{"first":"John"}, {"first":"Mark"}, {"first":"Smith"}]', '$[*].first');



SELECT 1 FROM dual WHERE JSON_EXISTS(NULL, '$');
SELECT 1 FROM dual WHERE JSON_EXISTS(NULL, '$' false on error);
SELECT 1 FROM dual WHERE JSON_EXISTS(NULL, '$' true on error);
SELECT 1 FROM dual WHERE JSON_EXISTS(NULL, '$' error on error);
SELECT 1 FROM dual WHERE JSON_EXISTS('NULL', '$');
SELECT 1 FROM dual WHERE JSON_EXISTS('NULL', '$' false on error);
SELECT 1 FROM dual WHERE JSON_EXISTS('NULL', '$' true on error);
SELECT 1 FROM dual WHERE JSON_EXISTS('NULL', '$' error on error);
SELECT 1 FROM dual WHERE JSON_EXISTS('"NULL"', '$');
SELECT 1 FROM dual WHERE JSON_EXISTS('"NULL"', '$' false on error);
SELECT 1 FROM dual WHERE JSON_EXISTS('"NULL"', '$' true on error);
SELECT 1 FROM dual WHERE JSON_EXISTS('"NULL"', '$' error on error);
SELECT 1 FROM dual WHERE JSON_EXISTS(123, '$');
SELECT 1 FROM dual WHERE JSON_EXISTS(123, '$' false on error);
SELECT 1 FROM dual WHERE JSON_EXISTS(123, '$' true on error);
SELECT 1 FROM dual WHERE JSON_EXISTS(123, '$' error on error);
SELECT 1 FROM dual WHERE JSON_EXISTS('123', '$');
SELECT 1 FROM dual WHERE JSON_EXISTS('123', '$' false on error);
SELECT 1 FROM dual WHERE JSON_EXISTS('123', '$' true on error);
SELECT 1 FROM dual WHERE JSON_EXISTS('123', '$' error on error);
SELECT 1 FROM dual WHERE JSON_EXISTS('"123"', '$');
SELECT 1 FROM dual WHERE JSON_EXISTS('"123"', '$' false on error);
SELECT 1 FROM dual WHERE JSON_EXISTS('"123"', '$' true on error);
SELECT 1 FROM dual WHERE JSON_EXISTS('"123"', '$' error on error);


--path error raise error diretly
SELECT 1 FROM dual WHERE JSON_EXISTS('[{"sdfdf":569}]', '$$[0].first');
SELECT 1 FROM dual WHERE JSON_EXISTS('[{"sdfdf":569}]', '[0].first');
SELECT 1 FROM dual WHERE JSON_EXISTS('[{"sdfdf":569}]', '$[].first');
SELECT 1 FROM dual WHERE JSON_EXISTS('[{"sdfdf":569}]', '$$[$X].first');
SELECT 1 FROM dual WHERE JSON_EXISTS('[{"sdfdf":569}]', '$[0]first');

--exist_on_error error raise error diretly
SELECT 1 FROM dual WHERE JSON_EXISTS('[{"sdfdf":569}]', '$[0].first' sdf);
SELECT 1 FROM dual WHERE JSON_EXISTS('[{"sdfdf":569}]', '$[0].first' empty on error);
SELECT 1 FROM dual WHERE JSON_EXISTS('[{"sdfdf":569}]', '$[0].first' on on on);
SELECT 1 FROM dual WHERE JSON_EXISTS('[{"sdfdf":569}]', '$[0].first' error sdfdsg);
SELECT 1 FROM dual WHERE JSON_EXISTS('[{"sdfdf":569}]', '$[0].first' hulahula );


---------------------------------------------------------------------8. json_array test
select json_array(123, '123', '"123"', 'true', '"true"', 'asfsdf', '"asfsdf"') from dual;
select json_array(123, '123' format json, '"123"', 'true', '"true"', 'asfsdf', '"asfsdf"') from dual;
select json_array(123, '123', '"123"' format json, 'true', '"true"', 'asfsdf', '"asfsdf"') from dual;
select json_array(123, '123', '"123"', 'true', '"true"' format json, 'asfsdf', '"asfsdf"') from dual;
select json_array(123, '123', '"123"', 'true' format json, '"true"', 'asfsdf', '"asfsdf"') from dual;
select json_array(123, '123', '"123"', 'true', '"true"', 'asfsdf' format json, '"asfsdf"') from dual;
select json_array(123, '123', '"123"', 'true', '"true"', 'asfsdf', '"asfsdf"' format json) from dual;

select json_array(null, 'null', '"null"') from dual;
select json_array(null  format json, 'null', '"null"') from dual;
select json_array(null, 'null'  format json, '"null"') from dual;
select json_array(null, 'null', '"null"'  format json) from dual;
select json_array(null, 'null', '"null"' null on null) from dual;
select json_array(null  format json, 'null', '"null"' absent on null) from dual;
select json_array(null, 'null'  format json, '"null"' absent on null) from dual;
select json_array(null, 'null', '"null"'  format json absent on null) from dual;
select json_array(null  format json, 'null', '"null"' null on null) from dual;
select json_array(null, 'null'  format json, '"null"' null on null) from dual;
select json_array(null, 'null', '"null"'  format json null on null) from dual;
select json_array(null, 'null', '"null"' null on null returning varchar2(200)) from dual;
select json_array(null  format json, 'null', '"null"' null on null returning varchar2(200)) from dual;
select json_array(null, 'null'  format json, '"null"' null on null returning varchar2(200)) from dual;
select json_array(null, 'null', '"null"'  format json null on null returning varchar2(200)) from dual;
select json_array(null  format json, 'null', '"null"' absent on null returning varchar2(200)) from dual;
select json_array(null, 'null'  format json, '"null"' absent on null returning varchar2(200)) from dual;
select json_array(null, 'null', '"null"'  format json absent on null returning varchar2(200)) from dual;


---------------------------------------------------------------------8. json_object test
select json_object( 'false' is null, 'sdfsd' is 46 returning varchar2(100)) from dual;
select json_object( 'false' is null, 'sdfsd' is 46 null on null returning varchar2(100)) from dual;
select json_object( 'false' is null, 'sdfsd' is 46 absent on null returning varchar2(100)) from dual;
select json_object( 'false' is null, 'sdfsd' is 'true' returning varchar2(100)) from dual;
select json_object( 'false' is null, 'sdfsd' is 'true' format json null on null returning varchar2(100)) from dual;
select json_object( 'false' is null, 'sdfsd' is 'true' format json absent on null returning varchar2(100)) from dual;
select json_object(key 'false' is null, 'sdfsd' is 46 returning varchar2(100)) from dual;
select json_object(key 'false' is null, 'sdfsd' is 46 null on null returning varchar2(100)) from dual;
select json_object(key 'false' is null, 'sdfsd' is 46 absent on null returning varchar2(100)) from dual;
select json_object(key 'false' is null, 'sdfsd' is 'true' returning varchar2(100)) from dual;
select json_object(key 'false' is null, 'sdfsd' is 'true' format json null on null returning varchar2(100)) from dual;
select json_object(key 'false' is null, 'sdfsd' is 'true' format json absent on null returning varchar2(100)) from dual;
select json_object(key 'false' : null, 'sdfsd' is 46 null on null returning clob) from dual;
select json_object(key 'false' is null, 'sdfsd' is 46 null on null returning clob) from dual;
select json_object( 'false' : null, 'sdfsd' : 46 returning varchar2(100)) from dual;
select json_object( 'false' : null, 'sdfsd' : 46 null on null returning varchar2(100)) from dual;
select json_object( 'false' : null, 'sdfsd' : 46 absent on null returning varchar2(100)) from dual;
select json_object( 'false' : null, 'sdfsd' : 'true' returning varchar2(100)) from dual;
select json_object( 'false' : null, 'sdfsd' : 'true' format json null on null returning varchar2(100)) from dual;
select json_object( 'false' : null, 'sdfsd' : 'true' format json absent on null returning varchar2(100)) from dual;

--error
select json_object( 'false' is null, 'sdfsd' is 46 null on null returning varchar2(10)) from dual;
select json_object(key 'false' : null, 'sdfsd' is 46 null on null returning clob) from dual;

 
select json_value('[2,3,4]', '$[2]') from dual;
select json_value('[2,3,4]', '$[2]' true on error) from dual;
select json_value('[2,3,4]', '$[2]' false on error) from dual;
select json_value('[2,3,4]', '$[2]' empty on error) from dual;

select json_query('[2,3,4]', '$') from dual;
select json_query('[2,3,4]', '$' true on error) from dual;
select json_query('[2,3,4]', '$' false on error) from dual;
select json_query('[2,3,4]', '$' empty on error) from dual;


-------------------------------------------------------------------------------------wrapper clause
select json_query('[true,123,"fdfd"]','$[*]') from dual;
select json_query('[true,123,"fdfd"]','$[*]' error on error) from dual;
select json_query('[true,123,"fdfd"]','$[*]' WITHOUT WRAPPER) from dual;
select json_query('[true,123,"fdfd"]','$[*]' WITHOUT ARRAY WRAPPER) from dual;

select json_query('[true,123,"fdfd"]','$[*]' WITH WRAPPER) from dual;
select json_query('[true,123,"fdfd"]','$[*]' WITH ARRAY WRAPPER) from dual;
select json_query('[true,123,"fdfd"]','$[*]' WITH UNCONDITIONAL WRAPPER) from dual;
select json_query('[true,123,"fdfd"]','$[*]' WITH UNCONDITIONAL ARRAY WRAPPER) from dual;

select json_query('[true,123,"fdfd"]','$' WITH CONDITIONAL WRAPPER) from dual;
select json_query('[true,123,"fdfd"]','$' WITH CONDITIONAL ARRAY WRAPPER) from dual;
select json_query('[true,123,"fdfd"]','$' WITH UNCONDITIONAL WRAPPER) from dual;
select json_query('[true,123,"fdfd"]','$' WITH UNCONDITIONAL ARRAY WRAPPER) from dual;
select json_query('{"name":123}','$' WITH CONDITIONAL WRAPPER) from dual;
select json_query('{"name":123}','$' WITH CONDITIONAL ARRAY WRAPPER) from dual;
select json_query('{"name":123}','$' WITH UNCONDITIONAL WRAPPER) from dual;
select json_query('{"name":123}','$' WITH UNCONDITIONAL ARRAY WRAPPER) from dual;

--return null
select json_query('{"name":123}','$.ddd' WITH  WRAPPER ) from dual;
select json_query('{"name":123}','$.ddd' WITH  WRAPPER error on error) from dual;
select json_query('{"name":123}','$.ddd' WITH  WRAPPER error on error null on empty ) from dual;


--extract multiple values on_empty_clause don't tale effect
select json_query('[12,23,454,{"B":123},25]', '$[*]' error  on empty) from dual;
select json_query('[12,23,454,{"B":123},25]', '$[*]' null on empty) from dual;
select json_query('[12,23,454,{"B":123},25]', '$[*]' null  on error error  on empty) from dual;
select json_query('[12,23,454,{"B":123},25]', '$[*]' error on error null on empty) from dual;

select json_value('[12,23,454,{"B":123},25]', '$[*]' error  on empty) from dual;
select json_value('[12,23,454,{"B":123},25]', '$[*]' null on empty) from dual;
select json_value('[12,23,454,{"B":123},25]', '$[*]' null  on error error  on empty) from dual;
select json_value('[12,23,454,{"B":123},25]', '$[*]' error on error null on empty) from dual;

select  json_query('[{"country":0,"cities":["suzhou","shanghai"],"codes":{"suzhou":0,"shanghai":0}}]', '$[*]' WITH WRAPPER ERROR ON ERROR) from dual;
select  json_query('[{"country":0,"cities":["suzhou","shanghai"],"codes":{"suzhou":0,"shanghai":0}}]', '$' WITH WRAPPER ERROR ON ERROR) from dual;
select  json_query('[{"country":0,"cities":["suzhou","shanghai"],"codes":{"suzhou":0,"shanghai":0}}]', '$' WITH UNCONDITIONAL WRAPPER ERROR ON ERROR) from dual;
select  json_query('[{"country":0,"cities":["suzhou","shanghai"],"codes":{"suzhou":0,"shanghai":0}}]', '$' WITH CONDITIONAL WRAPPER ERROR ON ERROR) from dual;

select 1 from dual where '["true",123,"FDFD"]' is json;
select 1 from dual where json_exists('["true",123,"FDFD"]',' $[*]' error on error);
select 1 from dual where '[true,123,"FDFD"]' is json;
select 1 from dual where json_exists('[true,123,"FDFD"]',' $[*]' error on error);
select 1 from dual where '[TRUE,123,"FDFD"]' is json;
select 1 from dual where json_exists('[TRUE,123,"FDFD"]',' $[*]' error on error);




--only scaler and SQL variant
--not jv_array or jv_object
select 1 from dual where json_exists('{"a":"qwertyui"}', '$?(@.a starts with "4qwe")');
select 1 from dual where json_exists('{"a":"qwertyui"}', '$?(@.a starts with "qwe")');
select 1 from dual where json_exists('{"a":"qwertyui"}', '$?(@.a has substring "qwe")');
select 1 from dual where json_exists('{"a":"qwertyui"}', '$?(@.a has substring "qwde")');

select 1 from dual where json_exists('{"a":123, "b":123, "c":58}', '$?(@.a in (@.b, @.c))');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6},{"a":7},{"a":8},{"a":9}]', '$[*]?(exists (@.a))');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6},{"a":7},{"a":8},{"a":9}]', '$[*]?(exists (@.a[0]))');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6},{"a":7},{"a":8},{"a":9}]', '$[*]?(exists (@.a[1]))');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6},{"a":7},{"a":8},{"a":9}]', '$[*]?(exists (@.a[*]))');


select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6},{"a":7},{"a":8},{"a":9}]', '$[*]?(@ in (8,9,5))');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6},{"a":7},{"a":8},{"a":9}]', '$[*]?(@.a in (8,9,5))');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6},{"a":7},{"a":8},{"a":9}]', '$[4]?(@.a in (8,9,5))');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6},{"a":7},{"a":8},{"a":9}]', '$[4].a?(@ in (8,9,5))');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6},{"a":7},{"a":8},{"a":9}]', '$[4].a?(5 in (8,9,5))');


select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6},{"a":7},{"a":8},{"a":9}]', '$[*]?(@.a>5)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6},{"a":7},{"a":8},{"a":9}]', '$[*]?(@.a>10)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6},{"a":7},{"a":8},{"a":9}]', '$[*]?(@.a>10 || @.a < 11)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6},{"a":7},{"a":8},{"a":9}]', '$[*]?((@.a>10)||(@.a < 11))');
select json_query('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6},{"a":7},{"a":8},{"a":9},{"a":true}]', '$[*]?(@.a>5)' WITH WRAPPER) from dual;
select length(json_query('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6},{"a":7},{"a":8},{"a":9},{"a":true}]', '$[*]?(@.a>5)' WITH WRAPPER)) from dual;
select json_query('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6},{"a":7},{"a":8},{"a":9}]', '$[*]?(@.a>7)' WITH WRAPPER) from dual;
select length(json_query('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6},{"a":7},{"a":8},{"a":9}]', '$[*]?(@.a>7)' WITH WRAPPER)) from dual;
select json_query('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6},{"a":7},{"a":8},{"a":9}]', '$[*]' WITH WRAPPER) from dual;
select length(json_query('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6},{"a":7},{"a":8},{"a":9}]', '$[*]' WITH WRAPPER)) from dual;

select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6},{"a":7},{"a":8},{"a":9}]', '         $[*]   ?(@.a>10 || @.a < 11)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6},{"a":7},{"a":8},{"a":9}]', '         $[*]   ?      (@.a>10 || @.a < 11)       ');


--ok
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*].a?( 8 > 5 )');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*].a?(  ( 8 > 5  ) )');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*].a?(   (      ( 8 > 5  )) )');
--error
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*].a?( (8) > 5 )');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*].a?( 8 > (5) )');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*].a?( (8) > (5) )');

--ok
select json_query('[{"a":1},{"a":2},{"a":3}]', '$[*]?( 5 > @.a)' with wrapper) from dual;
select json_query('[{"a":1},{"a":2},{"a":3}]', '$[*]?( 2 > @.a)' with wrapper) from dual;
select json_query('[{"a":1},{"a":2},{"a":3}]', '$[*]?(@.a > 2)' with wrapper ) from dual;
select json_query('[{"a":1},{"a":2},{"a":3}]', '$[*]?( 3 == @.a)' with wrapper) from dual;
select json_query('[{"a":1},{"a":2},{"a":3}]', '$[*]?( 3 >= @.a)' with wrapper) from dual;
select json_query('[{"a":1},{"a":2},{"a":3}]', '$[*]?( 8 <= @.a)' with wrapper error on empty) from dual;
select json_query('[{"a":1},{"a":2},{"a":3}]', '$[*]?( @.a >= 8)' with wrapper error on empty) from dual;
select json_query('[{"a":1}]', '$[*]?( 1 != @.a)' with wrapper error on empty) from dual;
select json_query('[{"a":1}]', '$[*]?( 1 <> @.a)' with wrapper error on empty) from dual;
select json_query('[{"a":1},{"a":2},{"a":3}]', '$[*]?( 8 > 5)' with wrapper) from dual;

select json_query('[{"a":1},{"a":2},{"a":3}]', '$[*]?(@.a > "2")' with wrapper ) from dual;
select json_query('[{"a":1},{"a":2},{"a":3}]', '$[*]?(@.a > "1")' with wrapper ) from dual;
select json_query('[{"a":1},{"a":2},{"a":3}]', '$[*]?(@.a > "4")' with wrapper error on empty) from dual;
select json_query('[{"a":1},{"a":2},{"a":3}]', '$[*]?( "4" > @.a)' with wrapper ) from dual;
select json_query('[{"a":1},{"a":2},{"a":3}]', '$[*]?( "2" > @.a)'  ) from dual;
select json_query('[{"a":1},{"a":2},{"a":3}]', '$[*]?( "2" > "1")'  with wrapper ) from dual;

select json_query('[{"a":1},{"a":2},{"a":3}]', '$[*]?( 3 == @.   a)' with wrapper) from dual;
select json_query('[{"a":1},{"a":2},{"a":3}]', '$[*]?(  @.   a > 2  )' with wrapper) from dual;
select json_query('[{"a":1},{"a":2},{"a":3}]', '$[*]?(  @.   a  >  8)' with wrapper) from dual;

--error
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(@.a (>) 2)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?((@.a) > 2)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(@.a > (2))');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?((@.a) > (2))');

--ok
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(2 > @.a)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?((2 > @.a)   )');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(((2 > @.a)   ))');
--error
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?((2) > @.a)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?((2) > (@.a))');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(2 > (@.a))');


--ok
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(@.a in (1,2,3))');
--error
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(2 in (1,2,3))');


select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?( exists (@.a))');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?( !(exists (@.a)))');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?( !   (exists (@.a)))');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"b":3}]', '$[*]?( exists (@.a))');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"b":3}]', '$[*]?( !(exists (@.a)))');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"b":3}]', '$[*]?( !   (exists (@.a)))');


--error
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(true > 2)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(null > 2)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(false > 2)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(3 > "12A")');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(true > "12A")');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(null > "12A")');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(@.a == @.a)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(@.a > 123c)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(@.a > {"name":25})');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(@.a > qwert)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(@.a > [])');

--ok
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(4 > 2)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(4 != 2)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(true >= true)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(true <= true)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(true == true)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(true != false)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3},{"a":"bbb"}]', '$[*]?(@.a > "a[2sadsfdsfds")');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3},{"a":"bbb"}]', '$[*]?(@.a > "a[2^%]")');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3},{"a":"bbb"}]', '$[*]?(@.a > "a[2{}{}90ss[]dsvfd^%]")');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(@.a > 123)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(@.a > 0)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":"3.123456"}]', '$[*]?(@.a >= 3)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":"3.123456"}]', '$[*]?(@.a >= 4)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(@.a != 2)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3},{"a":null}]', '$[*]?(@.a > null)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3},{"a":null}]', '$[*]?(@.a >= null)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3},{"a":true}]', '$[*]?(@.a > true)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3},{"a":true}]', '$[*]?(@.a >= true)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?(@.a > false)');
select 1 from dual where json_exists('[{"a":1},{"a":2},{"a":3}]', '$[*]?("12B" > "12A")');

--filter clause test
--mixed
select json_query('{"Aaa":{"A":12, "B":13, "c":[14,15,16,17,18]}}', '$.Aaa.c[1 to 3]' with wrapper) as val from dual;
select json_query('{"Aaa":{"A":12, "B":13, "c":[14,15,16,17,18]}}', '$.Aaa.c[*]?(@ > 17)'  with wrapper) as val from dual;
select json_exists('{"Aaa":{"A":12, "B":13, "c":[14,15,16,17,18]}}', '$.Aaa.c[*]?(@ > 18 )') as val from dual;
select json_value('{"Aaa":{"A":12, "B":13, "c":[14,15,16,17,18]}}', '$.*[*].A') as val from dual;
select json_query('[23,true]', '$') as val from dual;
select json_value('[[[24]]]', '$[0][*][to]') as val from dual;
select json_query('[23,true]', '$[*]?(@ == true) ' with wrapper) as val from dual;
select json_query('[23,true]', '$[*]?(@ > true) ' with wrapper) as val from dual;
select json_query('[23,true]', '$[*]?(@ == false) ' with wrapper) as val from dual;
select json_query('[23,true]', '$[*]?(@ > false) ' with wrapper) as val from dual;
select json_query('[23,true]', '$[*]?(@ > true) ' with wrapper error on error) as val from dual;
select json_query('[23,true]', '$[*]?(@ > 2) ' with wrapper) as val from dual;
select json_query('[23,true]', '$[*]?(2            < @) ' with wrapper) as val from dual;
select json_value('[23,true]', '$[*]?(2            < @) ' ) as val from dual;
select json_query('[23,"asd","bfdferf",25,"dhyhytjt"]', '$[*]?("A"            < @) '  with wrapper) as val from dual;
select json_query('[23,"asd","bfdferf",25,"dhyhytjt"]', '$[*]?("z"            < @) '  with wrapper) as val from dual;
select json_query('[23,"asd","bfdferf",25,"dhyhytjt"]', '$[*]?(@ > "A"      ) '  with wrapper) as val from dual;
select json_query('[23,"asd","bfdferf",25,"dhyhytjt"]', '$[*]?(@ > "z"      ) '  with wrapper null on empty) as val from dual;
select json_query('[23,"asd","bfdferf",25,"dhyhytjt"]', '$[*]?(@ > "z"      ) '  with wrapper error on empty) as val from dual;

--single
select json_query('[23,null,"null",true,"zenith","ASD",65]', '$[*]?(null == @) ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65]', '$[*]?(null >= @) ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65]', '$[*]?(null <= @) ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65]', '$[*]?(null >  @) ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65]', '$[*]?(null <  @) ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65]', '$[*]?(@ == null) ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65]', '$[*]?(@ >= null) ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65]', '$[*]?(@ <= null) ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65]', '$[*]?(@ >  null) ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65]', '$[*]?(@ <  null) ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65]', '$[*]?("null" == @) ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65]', '$[*]?("null" >= @) ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65]', '$[*]?("null" <= @) ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65]', '$[*]?("null" >  @) ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65]', '$[*]?("null" <  @) ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65]', '$[*]?(@ == "null") ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65]', '$[*]?(@ >= "null") ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65]', '$[*]?(@ <= "null") ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65]', '$[*]?(@ >  "null") ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65]', '$[*]?(@ <  "null") ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65,{"val":null}]', '$[*]?(@.val ==  null) ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65,{"val":null}]', '$[*]?(@[*].val[*] ==  null) ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65,{"val":{"test":null}}]', '$[*]?(@[*].val[*].test ==  null) ' with wrapper) as val from dual;

select json_query('[23,null,true,"true","zenith","ASD",65]', '$[*]?(true == @) ' with wrapper) as val from dual;
select json_query('[23,null,true,"true","zenith","ASD",65]', '$[*]?(true >= @) ' with wrapper) as val from dual;
select json_query('[23,null,true,"true","zenith","ASD",65]', '$[*]?(true <= @) ' with wrapper) as val from dual;
select json_query('[23,null,true,"true","zenith","ASD",65]', '$[*]?(true >  @) ' with wrapper) as val from dual;
select json_query('[23,null,true,"true","zenith","ASD",65]', '$[*]?(true <  @) ' with wrapper) as val from dual;
select json_query('[23,null,true,"true","zenith","ASD",65]', '$[*]?(@ == true) ' with wrapper) as val from dual;
select json_query('[23,null,true,"true","zenith","ASD",65]', '$[*]?(@ >= true) ' with wrapper) as val from dual;
select json_query('[23,null,true,"true","zenith","ASD",65]', '$[*]?(@ <= true) ' with wrapper) as val from dual;
select json_query('[23,null,true,"true","zenith","ASD",65]', '$[*]?(@ >  true) ' with wrapper) as val from dual;
select json_query('[23,null,true,"true","zenith","ASD",65]', '$[*]?(@ <  true) ' with wrapper) as val from dual;
select json_query('[23,null,true,"true","zenith","ASD",65]', '$[*]?("true" == @) ' with wrapper) as val from dual;
select json_query('[23,null,true,"true","zenith","ASD",65]', '$[*]?("true" >= @) ' with wrapper) as val from dual;
select json_query('[23,null,true,"true","zenith","ASD",65]', '$[*]?("true" <= @) ' with wrapper) as val from dual;
select json_query('[23,null,true,"true","zenith","ASD",65]', '$[*]?("true" >  @) ' with wrapper) as val from dual;
select json_query('[23,null,true,"true","zenith","ASD",65]', '$[*]?("true" <  @) ' with wrapper) as val from dual;
select json_query('[23,null,true,"true","zenith","ASD",65]', '$[*]?(@ == "true") ' with wrapper) as val from dual;
select json_query('[23,null,true,"true","zenith","ASD",65]', '$[*]?(@ >= "true") ' with wrapper) as val from dual;
select json_query('[23,null,true,"true","zenith","ASD",65]', '$[*]?(@ <= "true") ' with wrapper) as val from dual;
select json_query('[23,null,true,"true","zenith","ASD",65]', '$[*]?(@ >  "true") ' with wrapper) as val from dual;
select json_query('[23,null,true,"true","zenith","ASD",65]', '$[*]?(@ <  "true") ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65,{"val":true}]', '$[*]?(@.val ==  true) ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65,{"val":true}]', '$[*]?(@[*].val[*] ==  true) ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65,{"val":{"test":true}}]', '$[*]?(@[*].val[*].test ==  true) ' with wrapper) as val from dual;

select json_query('[23,null,false,"false","zenith","ASD",65]', '$[*]?(false == @) ' with wrapper) as val from dual;
select json_query('[23,null,false,"false","zenith","ASD",65]', '$[*]?(false >= @) ' with wrapper) as val from dual;
select json_query('[23,null,false,"false","zenith","ASD",65]', '$[*]?(false <= @) ' with wrapper) as val from dual;
select json_query('[23,null,false,"false","zenith","ASD",65]', '$[*]?(false >  @) ' with wrapper) as val from dual;
select json_query('[23,null,false,"false","zenith","ASD",65]', '$[*]?(false <  @) ' with wrapper) as val from dual;
select json_query('[23,null,false,"false","zenith","ASD",65]', '$[*]?(@ == false) ' with wrapper) as val from dual;
select json_query('[23,null,false,"false","zenith","ASD",65]', '$[*]?(@ >= false) ' with wrapper) as val from dual;
select json_query('[23,null,false,"false","zenith","ASD",65]', '$[*]?(@ <= false) ' with wrapper) as val from dual;
select json_query('[23,null,false,"false","zenith","ASD",65]', '$[*]?(@ >  false) ' with wrapper) as val from dual;
select json_query('[23,null,false,"false","zenith","ASD",65]', '$[*]?(@ <  false) ' with wrapper) as val from dual;
select json_query('[23,null,false,"false","zenith","ASD",65]', '$[*]?("false" == @) ' with wrapper) as val from dual;
select json_query('[23,null,false,"false","zenith","ASD",65]', '$[*]?("false" >= @) ' with wrapper) as val from dual;
select json_query('[23,null,false,"false","zenith","ASD",65]', '$[*]?("false" <= @) ' with wrapper) as val from dual;
select json_query('[23,null,false,"false","zenith","ASD",65]', '$[*]?("false" >  @) ' with wrapper) as val from dual;
select json_query('[23,null,false,"false","zenith","ASD",65]', '$[*]?("false" <  @) ' with wrapper) as val from dual;
select json_query('[23,null,false,"false","zenith","ASD",65]', '$[*]?(@ == "false") ' with wrapper) as val from dual;
select json_query('[23,null,false,"false","zenith","ASD",65]', '$[*]?(@ >= "false") ' with wrapper) as val from dual;
select json_query('[23,null,false,"false","zenith","ASD",65]', '$[*]?(@ <= "false") ' with wrapper) as val from dual;
select json_query('[23,null,false,"false","zenith","ASD",65]', '$[*]?(@ >  "false") ' with wrapper) as val from dual;
select json_query('[23,null,false,"false","zenith","ASD",65]', '$[*]?(@ <  "false") ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65,{"val":false}]', '$[*]?(@.val ==  false) ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65,{"val":false}]', '$[*]?(@[*].val[*] ==  false) ' with wrapper) as val from dual;
select json_query('[23,null,"null",true,"zenith","ASD",65,{"val":{"test":false}}]', '$[*]?(@[*].val[*].test ==  false) ' with wrapper) as val from dual;

select json_query('[23,null,32.123456,"32.123456",100,"zenith"]', '$[*]?(32.123456 == @ ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"32.123456",100,"zenith"]', '$[*]?(32.123456 >= @ ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"32.123456",100,"zenith"]', '$[*]?(32.123456 <= @ ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"32.123456",100,"zenith"]', '$[*]?(32.123456 >  @ ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"32.123456",100,"zenith"]', '$[*]?(32.123456 <  @ ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"32.123456",100,"zenith"]', '$[*]?(@ == 32.123456 ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"32.123456",100,"zenith"]', '$[*]?(@ >= 32.123456 ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"32.123456",100,"zenith"]', '$[*]?(@ <= 32.123456 ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"32.123456",100,"zenith"]', '$[*]?(@ >  32.123456 ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"32.123456",100,"zenith"]', '$[*]?(@ <  32.123456 ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"32.123456",100,"zenith"]', '$[*]?("32.123456" == @ ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"32.123456",100,"zenith"]', '$[*]?("32.123456" >= @ ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"32.123456",100,"zenith"]', '$[*]?("32.123456" <= @ ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"32.123456",100,"zenith"]', '$[*]?("32.123456" >  @ ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"32.123456",100,"zenith"]', '$[*]?("32.123456" <  @ ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"32.123456",100,"zenith"]', '$[*]?(@ == "32.123456" ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"32.123456",100,"zenith"]', '$[*]?(@ >= "32.123456" ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"32.123456",100,"zenith"]', '$[*]?(@ <= "32.123456" ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"32.123456",100,"zenith"]', '$[*]?(@ >  "32.123456" ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"32.123456",100,"zenith"]', '$[*]?(@ <  "32.123456" ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"32.123456",100,"zenith",{"val":[1,[34]]}]', '$[*]?(@.val[*][to] <  "38.123456" ) ' with wrapper) as val from dual;

select json_query('[23,null,32.123456,"sfdfdgfgdbhgfb",100,"zenith"]', '$[*]?("sfdfdgfgdbhgfb" == @ ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"sfdfdgfgdbhgfb",100,"zenith"]', '$[*]?("sfdfdgfgdbhgfb" >= @ ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"sfdfdgfgdbhgfb",100,"zenith"]', '$[*]?("sfdfdgfgdbhgfb" <= @ ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"sfdfdgfgdbhgfb",100,"zenith"]', '$[*]?("sfdfdgfgdbhgfb" >  @ ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"sfdfdgfgdbhgfb",100,"zenith"]', '$[*]?("sfdfdgfgdbhgfb" <  @ ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"sfdfdgfgdbhgfb",100,"zenith"]', '$[*]?(@ == "sfdfdgfgdbhgfb" ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"sfdfdgfgdbhgfb",100,"zenith"]', '$[*]?(@ >= "sfdfdgfgdbhgfb" ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"sfdfdgfgdbhgfb",100,"zenith"]', '$[*]?(@ <= "sfdfdgfgdbhgfb" ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"sfdfdgfgdbhgfb",100,"zenith"]', '$[*]?(@ >  "sfdfdgfgdbhgfb" ) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"sfdfdgfgdbhgfb",100,"zenith"]', '$[*]?(@ <  "sfdfdgfgdbhgfb" ) ' with wrapper) as val from dual;

--error
select json_query('[23,true]', '$[*]?(@ == @) ' with wrapper) as val from dual;
select json_query('[23,true]', '$[*]?(@ > @) ' with wrapper) as val from dual;
select json_query('[23,true]', '$[*]?(@ < @) ' with wrapper) as val from dual;
select json_query('[23,true]', '$[*]?(true == true) ' with wrapper) as val from dual;
select json_query('[23,true]', '$[*]?(true >= true) ' with wrapper) as val from dual;
select json_query('[23,true]', '$[*]?(true == false) ' with wrapper) as val from dual;
select json_query('[23,true]', '$[*]?(true >= false) ' with wrapper) as val from dual;
select json_query('[23,true]', '$[*]?(true [] false) ' with wrapper) as val from dual;
select json_query('[23,true]', '$[*]?(true != [] false) ' with wrapper) as val from dual;
select json_query('[23,true]', '$[*]?(@123 [] false) ' with wrapper) as val from dual;
select json_query('[23,true]', '$[*]?(125<> == 125) ') as val from dual;
select json_query('[23,true]', '$[*]?(125 == 125) ' with wrapper) as val from dual;
select json_query('[23,true]', '$[*]?(43 == "43") ' with wrapper) as val from dual;
select json_query('[23,true]', '$[*]?(null >= null) ' with wrapper) as val from dual;
select json_query('[23,null,32.123456,"32.123456",100,"zenith",{"val":[1,[34]]}]', '$[*]?(@.val[*][to]?(@ > 9) <  "38.123456" ) ' with wrapper) as val from dual;

--DTS
select json_object('false' is null  , 'dsfds' is 123 ) from dual;
select json_object('false' is 'null' , 'dsfds' is 123 ) from dual;
select json_object('false' is null  , 'dsfds' is 123 ) from dual;

select json_array(1,2,'32432' , null null on null returning clob) from dual;
select json_array(1,2,'32432' , null null on null) from dual;

select json_array(1, null, 2, '32432' null on null returning clob) from dual;
select json_array(1, null, 2, '32432' null on null returning varchar2(100)) from dual;
select json_array(1, null, 2, '32432' null on null) from dual;

select json_object('sdfsd' is 46, 'false' is null returning clob) from dual;
select json_object('sdfsd' is 46, 'false' is null null on null  returning clob) from dual;
select json_object( 'false' is null, 'sdfsd' is 46 returning clob) from dual;
select json_object( 'false' is null, 'sdfsd' is 46 null on null returning clob) from dual;

select json_object('sdfsd' is 46, 'false' is null returning varchar2(100)) from dual;
select json_object('sdfsd' is 46, 'false' is null null on null  returning varchar2(100)) from dual;
select json_object( 'false' is null, 'sdfsd' is 46 returning varchar2(100)) from dual;
select json_object( 'false' is null, 'sdfsd' is 46 null on null returning varchar2(100)) from dual;

select json_array(123, null format json null on null returning varchar2(200)) as val from dual;
select json_array(123, null format json null on null returning clob) as val from dual;
select json_object('name' is 123, 'b' is null returning clob) as val from dual;

select json_value('[]','$.saaaaaaaaaaaaaaaaaaasasadxsadcsafcdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd') as val from dual;
select json_value('[]','$.saaaaaaaaaaaaaaaaaaasasadxsadcsafcddddddddddddddddddddddddddddddddddd') as val from dual;
select length('saaaaaaaaaaaaaaaaaaasasadxsadcsafcddddddddddddddddddddddddddddddddddd') as val from dual;
select json_value('[]','$.saaaaaaaaaaaaaaaaaaasasadxsadcsafcdddddddddddddddddddddddddddddddddd') as val from dual;
select length('saaaaaaaaaaaaaaaaaaasasadxsadcsafcdddddddddddddddddddddddddddddddddd') as val from dual;
select json_value('{"saaaaaaaaaaaaaaaaaaasasadxsadcsafcdddddddddddddddddddddddddddddddddd":123}', '$.saaaaaaaaaaaaaaaaaaasasadxsadcsafcdddddddddddddddddddddddddddddddddd') as val from dual;

drop table if exists t1_json_null_insert;
create table t1_json_null_insert (c1 varchar2(1024) check (c1 is json));
insert into t1_json_null_insert values (NULL);

drop table if exists t1_json_null_insert;
create table t1_json_null_insert (c1 varchar2(1024)  check (c1 is not json));
insert into t1_json_null_insert values (NULL);
drop table if exists t1_json_null_insert;

--====================================================================================
--right, step_name without "" must contains digit or letter or _
select json_value('{"_":"dsds43"}', '$._') from dual;
select json_value('{"_1":"dsds43"}', '$._1') from dual;
select json_value('{"a_1":"dsds43"}', '$.a_1') from dual;

select json_value('{"a1":"dsds43"}', '$.a') from dual;
select json_value('{"a1":"dsds43"}', '$.a1') from dual;
select json_value('{"a_1":"dsds43"}', '$.a_1') from dual;
select json_value('{"a_1":"dsds43"}', '$.a\"_1') from dual;

select json_value('{"1a":"dsds43"}', '$."1a"') from dual;
select json_value('{"a a":123}', '$."a a"') from dual;

--error
select json_value('{"1":"dsds43"}', '$.1') from dual;
select json_value('{"1a":"dsds43"}', '$.1a') from dual;
select json_value('{"1":"dsds43"}', '$.a!') from dual;
select json_value('{"1":"dsds43"}', '$."a!"') from dual;
select json_value('{"a a":123}', '$.a a') from dual;

--====================================================================================
select json_value('{"aaa":"??????"}','$.aaa?(@ == "??????")') from dual;
select json_query('{"aaa":"??????"}','$?(@.aaa == "??????")') from dual;
select json_value('{"aaa":"???\"???"}','$.aaa?(@ == "???\"???")') from dual;
select json_value('{"aaa":"\"???\"???\""}','$.aaa?(@ == "\"???\"???\"")') from dual;
select json_value('{"aaa":"\"??...?\"???\""}','$.aaa?(@ == "\"??...?\"???\"")') from dual;
select length(json_value('{"aaa":"\"??.\b\r\t..?\"???\""}','$.aaa?(@ == "\"??.\b\r\t..?\"???\"")')) from dual;

--right
select json_value('{"a a":123}', '$."a a"') from dual;
select json_value('{"a a":123}', '$."a a"     [  *  ]') from dual;
select json_value('{" a a ":123}', '$." a a "') from dual;
select json_value('{" a \t a ":123}', '$." a \t a "') from dual;
select json_value('{"\" a a \"":123}', '$."\" a a \""') from dual;
select json_value('{" a \t  \" a ":123}', '$." a \t  \" a "') from dual;
select json_value('{" a \t..  \" a ":123}', '$." a \t..  \" a "[0]') from dual;
select json_value('{" a \t..  \" a ":123}', '$  .   " a \t..  \" a "  [0]') from dual;
select json_value('{" a \t..  \" a ":{"    b \\ \b \\ \r   \t":321}}', '$." a \t..  \" a "."    b \\ \b \\ \r   \t"') from dual;
select json_value('{" a \t..  \" a ":{"    b \\ \b \\ \r   \t":321}}', '$   .  " a \t..  \" a "  .  "    b \\ \b \\ \r   \t"') from dual;

--error
select json_value('{"a a":123}', '$." a a "') from dual;
select json_value('{"a a":123}', '$." a a " ""') from dual;
select json_value('{" a a ":123}', '$." a a    "') from dual;
select json_value('{" a a ":123}', '$.\" a a    "') from dual;
select json_value('{" a a ":123}', '$.\" a a    \"') from dual;

select json_query('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6}]', '$[*]?(@.a > 2 && @.a < 6)' with wrapper);
select json_query('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6}]', '$[*]?(!@.a > 3)' with wrapper);
select json_query('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6}]', '$[*]?((!(@.a < 5)))' with wrapper);
select json_query('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6}]', '$[*]?(@.a > 4 || @.a < 2)' with wrapper);
select json_query('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6}]', '$[*]?(!(@.a > 4 || @.a < 2 ))' with wrapper);
select json_query('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6}]', '$[*]?(@.a == 4 || @.a == 2 && @.a != 5)' with wrapper);
select json_query('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6}]', '$[*]?(@.a > 2 && !    @.a >  3)' with wrapper);
select json_query('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6}]', '$[*]?((@.a == 4) || !(((@.a <= 5))))' with wrapper);

--error
select json_query('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6}]', '$[*]?((!&&(@.a < 5)))' with wrapper);
select json_query('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6}]', '$[*]?((!!(@.a < 5)))' with wrapper);
select json_query('[{"a":1},{"a":2},{"a":3},{"a":4},{"a":5},{"a":6}]', '$[*]?((!(6)(@.a < 5)))' with wrapper);

--====================================================================================inner func test
--type()
select json_value('{"name":"jackon"}','$.name.type()') from dual;
select json_value('{"name":123}','$.name.type()') from dual;
select json_value('{"name":true}','$.name.type()') from dual;
select json_value('{"name":null}','$.name.type()') from dual;
select json_value('{"name":[]}','$.name.type()') from dual;
select json_value('{"name":{"sdds":15}}','$.name.type()') from dual;
select json_value('{"name":"jackon"}','$.name.type()?(21 > 1)') from dual;
select json_value('{"name":"jackon"}','$.name.()') from dual;
select json_value('{"name":"jackon"}','$.name.type(34)') from dual;
select json_value('{"name":"jackon"}','.type()') from dual;
select json_value('{"name":"jackon"}','type()') from dual;
select json_value('{"name":[]}','$.name.typex""x()') from dual;

select json_value('{"name":"jackon"}','$.type()') from dual;
select json_query('{"name":"jackon"}','$.type()') from dual;
select json_query('{"name":"jackon"}','$.type()' with wrapper) from dual;
select json_value('{"name":"jackon"}','$.type()?(@.name == "jackon")') from dual;
select json_value('{"name":"jackon"}','$.type()?(@.name == "object")') from dual;
select json_value('{"name":"jackon"}','$.name.type()?(@ == "jackon")') from dual;
select json_value('{"name":"jackon"}','$.name.type()?(@ == "string")') from dual;
select json_value('{"name":"jackon"}','$.name?(@.type() == "string")') from dual;
select json_value('{"name":"jackon"}','$.name.type()') from dual;
select json_value('{"name":"jackon"}','$.name?(@ == "jackon")' error on error) from dual;
select json_value('{"name":"jackon"}','$.name.type()?(@ == "jackon")' error on error) from dual;
select json_value('{"name":"jackon"}','$.name.type()?(@ == "string")' error on error) from dual;

select 1 from dual where json_exists('{"name":"jackon"}','$.name.size()');

select json_query('[1,2,3,4,5,6]','$[*].type()?(@ >2 && @ < 6)' with wrapper) from dual;
select json_query('[1,"2",3,true,5,{"fdsfds":"dsfsd"}]','$[*].type()' with wrapper) from dual;
select json_query('[1,"2",3,true,5,{"fdsfds":"dsfsd"}]','$[*].type()?(@ > 0)' with wrapper) from dual;
select json_query('[1,"2",3,true,5,{"fdsfds":"dsfsd"}]','$[*].  type    (    )    ?(@ > 0)' with wrapper) from dual;

-- DTS202012040HX3EEP0G00
select json_query('{"AAA":{"A":12, "B":13, "C":[14,15,16,17,18]}}', '$.AAA.C[*]?(@ > 17)' with 
array       wrapper) as val from sys_dummy;
select json_query('{"AAA":{"A":12, "B":13, "C":[14,15,16,17,18]}}', '$.AAA.C[*]?(@ > 17)' with 
wrapper) as val from sys_dummy;
select json_query('{"AAA":{"A":12, "B":13, "C":[14,15,16,17,18]}}', '$.AAA.C[*]?(@ > 17)' with 
unconditional       wrapper) as val from sys_dummy;
select json_query('{"AAA":{"A":12, "B":13, "C":[14,15,16,17,18]}}', '$.AAA.C[*]?(@ > 17)' null
on       error) as val from sys_dummy;
select json_query('{"AAA":{"A":12, "B":13, "C":[14,15,16,17,18]}}', '$.AAA.C[*]?(@ > 17)' empty       array
on       error) as val from sys_dummy;
select json_query('{"AAA":{"A":12, "B":13, "C":[14,15,16,17,18]}}', '$.AAA.C[*]?(@ > 17)' null
 on       empty) as val from sys_dummy;
select json_query('{"AAA":{"A":12, "B":13, "C":[14,15,16,17,18]}}', '$.AAA.C[*]?(@ > 17)' empty       
object
    on       empty) as val from sys_dummy;
select json_array(null  format json, 'null', '"null"' absent
 on       null) as val from sys_dummy;
 select json_array(null  format json, 'null', '"null"' null       
 on       null) as val from sys_dummy;
select json_array(null  format json, 'null', '"null"' absent 
on null returning       
 varchar2(200)) as val from sys_dummy;
select 1 from sys_dummy where json_exists('NULL', '$' false        
on        error);

select json_value('{"":"fgbgf"}', '$.""' error on error);
select json_value('{"":{"":{"":{"":"fgbgf"}}}}', '$."".""."".""' error on error);

select json_query('[{"":[null],"":{}},[1,2],[1]]','$[*].""' with conditional wrapper error on error);
select json_query('[{"":[null],"":{}},[1,2],[1]]','$[*].""[*]' with conditional wrapper error on error);
select json_query('[{"":[null],"":{}},[1,2],[1]]','$.*' with conditional wrapper error on error);
select json_query('[{"":[null],"":{}},[1,2],[1]]','$.*[*]' with conditional wrapper error on error);
select json_query('[{"":[null],"":{}},[1,2],[1]]','$[*][*]' with conditional wrapper error on error);
select json_query('[{"":[null],"":{}},[1,2],[1]]','$[*].*[*]' with conditional wrapper error on error);
