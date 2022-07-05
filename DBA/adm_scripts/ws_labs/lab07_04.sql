set echo on
conn / as sysdba
ALTER SYSTEM SET undo_tablespace=undotbs1
/
show parameter undo_tablespace
UPDATE hr.bigemp
SET employee_id =rownum
/
commit
/
DROP TABLESPACE undo2 INCLUDING CONTENTS AND DATAFILES
/
!ls $ORACLE_BASE/oradata/orcl
set echo off