set echo on
conn / as sysdba 
AUDIT select ON hr.employees
/
AUDIT update ON hr.employees
/
TRUNCATE TABLE aud$
/
col username for a10
col obj_name for a10
col owner for a10
SELECT username, timestamp, owner, obj_name, action_name FROM dba_audit_trail
/
conn hr/hr
SELECT employee_id, last_name FROM employees
WHERE employee_id = 101
/
SELECT employee_id, last_name, salary FROM employees
WHERE employee_id = 102
/
update employees
set salary = salary*1.1
where employee_id = 107
/
rollback
/
conn / as sysdba
SELECT username, timestamp, owner, obj_name, action_name FROM dba_audit_trail
/
set echo off
