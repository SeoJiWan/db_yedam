-- exam_sql_1.pdf --
-- Practice 1
-- 1.
describe departments;
select *
from departments;

-- 2.
describe employees;
select
    employee_id,
    last_name,
    job_id,
    hire_date as STARTDATE
from 
    employees;
    
-- 3.
select distinct job_id
from employees;

-- 4.
select
    employee_id as "Emp #",
    last_name as "Employee",
    job_id as "Job",
    hire_date as "Hire Date"
from 
    employees;
    
-- 5.
select job_id || ', ' || last_name as "Employee and Title"
from employees;

-- Practice 2
-- 1.
select last_name, salary
from employees
where salary > 12000;

-- 2.
select last_name, department_id
from employees
where employee_id = 176;

-- 3.
select last_name, salary
from employees
where salary not between 5000 and 12000;

-- 4.
select last_name, job_id, hire_date
from employees
--where last_name = 'Matos' or last_name = 'Taylor'
where last_name in ('Matos', 'Taylor')
order by 3;

-- 5.
select last_name, department_id
from employees
where department_id in (20, 50)
order by 1;

-- 6.
select last_name, salary, department_id
from employees
where salary between 5000 and 12000
and department_id in (20, 50);

-- 7.
select last_name, hire_date
from employees
--where hire_date between '04/01/01' and '04/12/31'
where hire_date like '04%';

-- 8.
select last_name, job_id
from employees
where manager_id is null;

-- 9.
select last_name, salary, commission_pct
from employees
where commission_pct is not null
order by 2 desc, 3 desc;

-- 10.
select last_name
from employees
where last_name like '__a%';

-- 11.
select last_name
from employees
where last_name like '%a%'
and last_name like '%e%';

-- 12.
select last_name, job_id, salary
from employees
where job_id in ('SA_REP', 'ST_CLEAK')
and salary not in (2500, 3500, 7000);

-- 13.
select last_name, salary, commission_pct
from employees
where commission_pct * 100 > 20;

-- Practice 3
-- 1.

