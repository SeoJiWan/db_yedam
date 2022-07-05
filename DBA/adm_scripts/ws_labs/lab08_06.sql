set echo on
conn / as sysdba
col policy_name for a15
col sql_bind for a20
col sql_text for a40
SELECT policy_name, scn, sql_text, sql_bind FROM dba_fga_audit_trail
/
set echo off
