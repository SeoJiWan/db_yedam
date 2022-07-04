set echo on
ALTER TABLESPACE test
ADD DATAFILE '/u01/app/oracle/oradata/orcl/test02.dbf' SIZE 10M
/
SELECT tablespace_name, file_name, bytes/1024/1024 AS filesize 
FROM dba_data_files
/
ALTER DATABASE DATAFILE '/u01/app/oracle/oradata/orcl/test01.dbf' RESIZE 30M
/
SELECT tablespace_name, file_name, bytes/1024/1024 AS filesize 
FROM dba_data_files
/
SELECT tablespace_name, COUNT(*) AS datafiles, SUM(bytes)/1024/1024 AS filesize
FROM dba_data_files
GROUP BY tablespace_name
/
set echo off