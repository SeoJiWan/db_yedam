set echo on
conn / as sysdba
show parameter audit_trail
SELECT privilege, success, failure FROM dba_priv_audit_opts
/
SELECT audit_option, success, failure FROM dba_stmt_audit_opts
/
SELECT owner, object_name, sel, ins, upd, del FROM dba_obj_audit_opts
/
set echo off
