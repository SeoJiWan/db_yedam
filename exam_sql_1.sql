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
select sysdate, current_date
from dual;

-- 2.
select employee_id, last_name, salary, salary * 1.15 as "New Salary"
from employees;

-- 3.
select employee_id, last_name, salary, salary * 1.15 as "New Salary", salary * 0.15 as "Increase"
from employees;

-- 5.
select last_name, length(last_name) as length
from employees
where last_name like 'J%'
or last_name like 'A%'
or last_name like 'M%'
order by 1;

-- 6.
select last_name, round(months_between(sysdate, hire_date)) as months_worked
from employees;

-- 7.
select last_name, lpad(salary, 15, '$')
from employees;

-- 8.
select last_name, trunc((sysdate - hire_date) / 7) as tenure
from employees
where department_id = 90
order by tenure desc;

-- Practice 4
-- 1.
select last_name || ' earns ' || salary || ' monthly but wants '|| salary  * 3 || '.' as "Dream Salaries"
from employees;

SELECT last_name || ' earns ' || TO_CHAR(salary, '$99,999.00') || ' monthly but wants ' || TO_CHAR(salary * 3, '$99,999.00') || '.' "Dream Salaries"
FROM employees;

select concat(concat(concat(concat(last_name, ' earns '), salary), ' monthly but wants '), salary * 3)
from employees;

-- 2.
select last_name, lpad(salary, 15, '$')
from employees;

-- 3.
select last_name, hire_date, to_char(next_day(add_months(hire_date, 6), 2), 'yyyy.mm.dd day') as review
from employees;

-- 4.
select last_name, hire_date, to_char(hire_date, 'day') as day
from employees
order by to_char(hire_date - 1, 'd');

select to_char(hire_date - 1, 'd'), to_char(hire_date - 1, 'day')
from employees;

-- 5.
select last_name, nvl(to_char(commission_pct, '0.9'), 'No Commission') --> nvl 함수 안의 두 파라미터는 타입이 같아야 함
from employees;

-- 6.
select rpad(last_name, 8) || ' ' || rpad(' ', salary/1000+1, '*') as emp_and_their_sal
from employees
order by salary desc;

-- 7.
select last_name, job_id, decode(job_id, 
                                'AD_PRES', 'A', 
                                'ST_MAN', 'B', 
                                'IT_PROG', 'C', 
                                'SA_REP', 'D', 
                                'ST_CLERK', 'E',
                                            0) GRADE
from employees;

select last_name, job_id,
        case when job_id = 'AD_PRES' then 'A'
             when job_id = 'ST_MAN' then 'B'
             when job_id = 'IT_PROG' then 'C'
             when job_id = 'SA_REP' then 'D'
             when job_id = 'ST_CLERK' then 'E'
             else '0' end as grade
from employees;

