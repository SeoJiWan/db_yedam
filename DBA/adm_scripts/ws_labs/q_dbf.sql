col tablespace_name for a15
col file_name for a50
set linesize 120
SELECT tablespace_name, file_name, bytes/1024/1024 AS file_size 
FROM dba_data_files
/