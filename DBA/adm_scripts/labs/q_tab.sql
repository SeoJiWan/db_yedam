conn / as sysdba
SELECT tablespace_name, table_name
FROM dba_tables
WHERE owner = 'HR'
/