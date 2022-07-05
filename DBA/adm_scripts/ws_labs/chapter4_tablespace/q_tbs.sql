col tablespace_name for a10
set linesize 120
SELECT tablespace_name, contents, status
FROM dba_tablespaces;
