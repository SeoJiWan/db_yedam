set linesize 120
col tablespace_name for a20
col file_name for a50
SELECT tablespace_name, status, contents, extent_management 
FROM dba_tablespaces
/
SELECT tablespace_name, file_name, bytes/1024/1024 AS filesize 
FROM dba_data_files
/