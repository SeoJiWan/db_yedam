set echo on
conn / as sysdba
show parameter undo
select tablespace_name, status, contents From dba_tablespaces
/
select tablespace_name, segment_name, status From dba_rollback_segs
/
set echo off