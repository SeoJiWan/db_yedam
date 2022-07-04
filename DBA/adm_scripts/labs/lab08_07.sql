set echo on
conn / as sysdba
truncate table fga_log$
/
SELECT policy_name, scn, sql_text, sql_bind FROM dba_fga_audit_trail
/
exec dbms_fga.drop_policy('HR','EMPLOYEES','FGA_EMPS');
set echo off
