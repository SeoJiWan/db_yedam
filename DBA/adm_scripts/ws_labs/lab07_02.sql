set echo on
conn / as sysdba
create undo tablespace undo2
Datafile '/u01/app/oracle/oradata/orcl/undo2.dbf' size 10m
/
select tablespace_name, status, contents From dba_tablespaces
/
select tablespace_name, segment_name, status From dba_rollback_segs
/
show parameter undo_tablespace
alter system set undo_tablespace=undo2
/
show parameter undo_tablespace
select tablespace_name, segment_name, status  from dba_rollback_segs
/
set echo off