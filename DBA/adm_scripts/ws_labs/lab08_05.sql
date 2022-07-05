set echo on
conn hr/hr
SELECT salary FROM employees
WHERE last_name ='Fay'
/
SELECT employee_id, last_name  FROM employees
/
SELECT employee_id, last_name, salary FROM employees 
WHERE employee_id = 174
/
SELECT employee_id, last_name,  job_id FROM employees
WHERE last_name='Abel'
/
select * 
from employees
/
update employees
set salary = 5600
Where employee_id=200
/
rollback
/
set echo off
