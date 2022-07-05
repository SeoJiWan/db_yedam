set echo on
DROP TABLESPACE test
INCLUDING CONTENTS AND DATAFILES
/
DROP TABLE hr.sawon
/
DROP TABLE hr.buseo
/
CREATE TABLESPACE test
DATAFILE '/u01/app/oracle/oradata/orcl/test01.dbf' SIZE 10M
/
SELECT tablespace_name, status, contents, extent_management 
FROM dba_tablespaces
/
SELECT tablespace_name, file_name, bytes/1024/1024 AS filesize 
FROM dba_data_files
/
conn hr/hr
CREATE TABLE sawon
      TABLESPACE test 
AS SELECT * FROM employees
/
CREATE TABLE buseo
      (id number(6),
      Name varchar2(20))
      TABLESPACE test
/
SELECT tablespace_name, table_name FROM 
user_tables
/
conn / as sysdba
set echo off