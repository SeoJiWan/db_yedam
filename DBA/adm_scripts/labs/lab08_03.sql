set echo on
conn / as sysdba
NOAUDIT select ON hr.employees
/
NOAUDIT update ON hr.employees
/
TRUNCATE TABLE aud$
/
conn hr/hr
select employee_id, salary from employees
where employee_id = 103
/
update employees
set salary = salary*1.1
where employee_id = 103
/
rollback
/
conn / as sysdba
SELECT username, timestamp, owner, obj_name, action_name FROM dba_audit_trail
/
set echo off
