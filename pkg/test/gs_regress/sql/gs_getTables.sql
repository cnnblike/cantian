SELECT NULL AS TABLE_CAT , 
 k.owner as TABLE_SCHEM , 
 k.OBJECT_NAME as TABLE_NAME , 
 k.object_type as TABLE_TYPE , 
 '' as REMARKS , 
 null as TYPE_CAT , 
 null as TYPE_SCHEM , 
 null as TYPE_NAME , 
 null as SELF_REFERENCING_COL_NAME , 
 null as REF_GENERATION 
 from ALL_OBJECTS k where k.owner like 'p00318643_1' and k.object_name like 'tttt' and k.object_type in ( 'TABLE' );