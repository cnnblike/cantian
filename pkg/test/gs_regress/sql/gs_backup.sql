select * from v$backup_process;
backup database full;
select * from v$backup_process;
backup database INCREMENTAL level 2;
backup database INCREMENTAL not-level 2;
backup database INCREMENTAL level a;
backup database INCREMENTAL level 1 INCREMENTAL level 1;
backup database INCREMENTAL level 0;

backup database FORMAT 'nbu';
backup database FORMAT 'nbu:abc';
backup database FORMAT 'nbu:looooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong';
backup database FORMAT 'nbu:abc:/home/a.txt';
backup database FORMAT 'disk:abc:/home/a.txt';
backup database FORMAT 'nbu:abc:/home/a.txt:unexpected';

backup database prepare;
backup database finish not_scn 20;
backup database finish scn -20;
backup database finish scn 20 prepare;
backup database finish scn 20 finish scn 200;

backup database tag abc;
backup database tag 'abc';
backup database tag 'abc' tag 'def';
backup database tag 'loooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong';
backup database tag '';

backup database tag 'abc' finish scn 20 FORMAT 'nbu';
backup database tag 'abc' finish scn 20 full;

backup database incremental level 0 cumulative format '?/cumu_incr0.bak' tag 'test_cumu_incr0';
backup database incremental level 1 cumulative format '?/cumu_incr1.bak' tag 'test_cumu_incr1';
backup database incremental level 1 cumulative format '?/cumu_incr2.bak' tag 'test_cumu_incr2';
backup database incremental level 1 cumulative format '?/cumu_incr3_compress_1.bak' tag 'test_cumu_incr3' as compressed backupset level 1;
backup database incremental level 1 format '?/cumu_incr4_compress_9.bak' tag 'test_cumu_incr4' as compressed backupset level 9;
backup database incremental level 1 format '?/paral_1' parallelism 1;
backup database incremental level 1 format '?/paral_16' parallelism 16;
backup database incremental level 1 format '?/section_128M' parallelism 5 section threshold 128M;
select * from v$backup_process;
backup database incremental level 1 format '?/section_32T' section threshold 32T;
select * from v$backup_process;
select * from dv_backup_process_stats limit 0;

backup database format '?/paral_0' parallelism 0;
backup database format '?/paral_9' parallelism 17;
backup database format '?/section_127M' section threshold 127M;
backup database format '?/section_33T' section threshold 33T;

backup database format '?/paral_1_failed' parallelism 1 section threshold 128M parallelism 1;
backup database format '?/paral_8_failed' parallelism 16 section threshold 32T section threshold 32T;
backup database format '?/exc_spc' exclude for tablespace SYSTEM;
backup database format '?/exc_spc' exclude for tablespace TEMP;
backup database format '?/exc_spc' exclude for tablespace UNDO;
backup database format '?/exc_spc' exclude for tablespace USERS;
backup database format '?/exc_spc' exclude for tablespace TEMP2;
backup database format '?/exc_spc' exclude for tablespace TEMP2_UNDO;
backup database format '?/exc_spc' exclude for tablespace spc1 exclude for tablespace spc2;
backup database format '?/exc_spc' exclude for tablespace bak_invalid_space;

backup database format '?/compress_level_0.bak' as compressed backupset level 0;
backup database format '?/compress_level_10.bak' as compressed backupset level 10;
backup database incremental level 1 cumulative format '?/cumu_incr5_compress_1.bak' tag 'test_cumu_incr5' as zstd compressed backupset level 1;
backup database incremental level 1 format '?/cumu_incr6_compress_9.bak' tag 'test_cumu_incr6' as zstd compressed backupset level 9;
backup database incremental level 1 cumulative format '?/cumu_incr7_compress_1.bak' tag 'test_cumu_incr7' as lz4 compressed backupset level 1;
backup database incremental level 1 format '?/cumu_incr8_compress_9.bak' tag 'test_cumu_incr8' as lz4 compressed backupset level 9;
backup database format '?/compress_bak_0' level 6;
backup database format '?/compress_zstd_level2' as compressed backupset level 2;
backup database format '?/compress_zstd_level10' as zstd compressed backupset level 10;
backup database format '?/compress_zstd_default' as zstd compressed backupset;
backup database format '?/compress_lz4_level2' as lz4 compressed backupset level 2;
backup database format '?/compress_lz4_level10' as lz4 compressed backupset level 10;
backup database format '?/compress_lz4_default' as lz4 compressed backupset;
select base_tag from SYS_BACKUP_SETS where tag = 'test_cumu_incr0';
select base_tag from SYS_BACKUP_SETS where tag = 'test_cumu_incr1';
select base_tag from SYS_BACKUP_SETS where tag = 'test_cumu_incr2';
backup database cumulative format '?/full_cumu';
backup database cumulative incremental level 0 cumulative format '?/cumu_incr3.bak';
validate backupset '?/cumu_incr2.bak';
validate datafile 0 page 1;
validate datafile 3 page 3;
validate datafile 3 block 3;
backup database incremental level 0 format '?/bak_ex_level0' as zstd compressed backupset exclude for tablespace USERS;
backup database format '?/bak_ex_copy' exclude for tablespace USERS copy of tablespace USERS;
backup database format '/root/mkdir_fail';
