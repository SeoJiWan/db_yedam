set echo on
conn / as sysdba
create role sales_r1
/
grant create view, create synonym, create sequence to sales_r1
/
grant sales_r1 to sales
/
conn sales/sales
select * from session_privs
/
select * from hr.employees
/
conn hr/hr
grant select on hr.employees to sales
/
conn sales/sales
select employee_id, last_name from hr.employees
/
update hr.employees
set salary=salary*1.1
/
set echo off