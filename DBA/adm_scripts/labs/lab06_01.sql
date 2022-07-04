set echo on
set linesize 120
col object_name for a20
col oracle_username for a15
col username for a10
col event for a40
col owner for a15
col name for a20
conn / as sysdba
SELECT session_id, object_id, object_name, oracle_username
FROM v$locked_object  JOIN dba_objects 
USING (object_id)
/
SELECT session_id, owner, name, mode_held
FROM dba_dml_locks 
/
SELECT sid, serial#, username, blocking_session, event
FROM v$session
WHERE username = 'HR' 
/
set echo off