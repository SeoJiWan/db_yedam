-- exam_sql_1.pdf --
-- Practice 1
-- 1.
describe departments;

SELECT
    *
FROM
    departments;

-- 2.
describe employees;

SELECT
    employee_id,
    last_name,
    job_id,
    hire_date AS startdate
FROM
    employees;
    
-- 3.
SELECT DISTINCT
    job_id
FROM
    employees;

-- 4.
SELECT
    employee_id AS "Emp #",
    last_name   AS "Employee",
    job_id      AS "Job",
    hire_date   AS "Hire Date"
FROM
    employees;
    
-- 5.
SELECT
    job_id
    || ', '
    || last_name AS "Employee and Title"
FROM
    employees;

-- Practice 2
-- 1.
SELECT
    last_name,
    salary
FROM
    employees
WHERE
    salary > 12000;

-- 2.
SELECT
    last_name,
    department_id
FROM
    employees
WHERE
    employee_id = 176;

-- 3.
SELECT
    last_name,
    salary
FROM
    employees
WHERE
    salary NOT BETWEEN 5000 AND 12000;

-- 4.
SELECT
    last_name,
    job_id,
    hire_date
FROM
    employees
--where last_name = 'Matos' or last_name = 'Taylor'
WHERE
    last_name IN ( 'Matos', 'Taylor' )
ORDER BY
    3;

-- 5.
SELECT
    last_name,
    department_id
FROM
    employees
WHERE
    department_id IN ( 20, 50 )
ORDER BY
    1;

-- 6.
SELECT
    last_name,
    salary,
    department_id
FROM
    employees
WHERE
    salary BETWEEN 5000 AND 12000
    AND department_id IN ( 20, 50 );

-- 7.
SELECT
    last_name,
    hire_date
FROM
    employees
--where hire_date between '04/01/01' and '04/12/31'
WHERE
    hire_date LIKE '04%';

-- 8.
SELECT
    last_name,
    job_id
FROM
    employees
WHERE
    manager_id IS NULL;

-- 9.
SELECT
    last_name,
    salary,
    commission_pct
FROM
    employees
WHERE
    commission_pct IS NOT NULL
ORDER BY
    2 DESC,
    3 DESC;

-- 10.
SELECT
    last_name
FROM
    employees
WHERE
    last_name LIKE '__a%';

-- 11.
SELECT
    last_name
FROM
    employees
WHERE
    last_name LIKE '%a%'
    AND last_name LIKE '%e%';

-- 12.
SELECT
    last_name,
    job_id,
    salary
FROM
    employees
WHERE
    job_id IN ( 'SA_REP', 'ST_CLEAK' )
    AND salary NOT IN ( 2500, 3500, 7000 );

-- 13.
SELECT
    last_name,
    salary,
    commission_pct
FROM
    employees
WHERE
    commission_pct * 100 > 20;

-- Practice 3
-- 1.
SELECT
    sysdate,
    current_date
FROM
    dual;

-- 2.
SELECT
    employee_id,
    last_name,
    salary,
    salary * 1.15 AS "New Salary"
FROM
    employees;

-- 3.
SELECT
    employee_id,
    last_name,
    salary,
    salary * 1.15 AS "New Salary",
    salary * 0.15 AS "Increase"
FROM
    employees;

-- 5.
SELECT
    last_name,
    length(last_name) AS length
FROM
    employees
WHERE
    last_name LIKE 'J%'
    OR last_name LIKE 'A%'
    OR last_name LIKE 'M%'
ORDER BY
    1;

-- 6.
SELECT
    last_name,
    round(months_between(sysdate, hire_date)) AS months_worked
FROM
    employees;

-- 7.
SELECT
    last_name,
    lpad(salary, 15, '$')
FROM
    employees;

-- 8.
SELECT
    last_name,
    trunc((sysdate - hire_date) / 7) AS tenure
FROM
    employees
WHERE
    department_id = 90
ORDER BY
    tenure DESC;

-- Practice 4
-- 1.
SELECT
    last_name
    || ' earns '
    || salary
    || ' monthly but wants '
    || salary * 3
    || '.' AS "Dream Salaries"
FROM
    employees;

SELECT
    last_name
    || ' earns '
    || to_char(salary, '$99,999.00')
    || ' monthly but wants '
    || to_char(salary * 3, '$99,999.00')
    || '.' "Dream Salaries"
FROM
    employees;

SELECT
    concat(concat(concat(concat(last_name, ' earns '), salary), ' monthly but wants '), salary * 3)
FROM
    employees;

-- 2.
SELECT
    last_name,
    lpad(salary, 15, '$')
FROM
    employees;

-- 3.
SELECT
    last_name,
    hire_date,
    to_char(next_day(add_months(hire_date, 6), 2), 'yyyy.mm.dd day') AS review
FROM
    employees;

-- 4.
SELECT
    last_name,
    hire_date,
    to_char(hire_date, 'day') AS day
FROM
    employees
ORDER BY
    to_char(hire_date - 1, 'd');

SELECT
    to_char(hire_date - 1, 'd'),
    to_char(hire_date - 1, 'day')
FROM
    employees;

-- 5.
SELECT
    last_name,
    nvl(to_char(commission_pct, '0.9'), 'No Commission') --> nvl 占쌉쇽옙 占쏙옙占쏙옙 占쏙옙 占식띰옙占쏙옙姑占� 타占쏙옙占쏙옙 占쏙옙占싣억옙 占쏙옙
FROM
    employees;

-- 6.
SELECT
    rpad(last_name, 8)
    || ' '
    || rpad(' ', salary / 1000 + 1, '*') AS emp_and_their_sal
FROM
    employees
ORDER BY
    salary DESC;

-- 7.
SELECT
    last_name,
    job_id,
    decode(job_id, 'AD_PRES', 'A', 'ST_MAN', 'B',
           'IT_PROG', 'C', 'SA_REP', 'D', 'ST_CLERK',
           'E', 0) grade
FROM
    employees;

SELECT
    last_name,
    job_id,
    CASE
        WHEN job_id = 'AD_PRES'  THEN
            'A'
        WHEN job_id = 'ST_MAN'   THEN
            'B'
        WHEN job_id = 'IT_PROG'  THEN
            'C'
        WHEN job_id = 'SA_REP'   THEN
            'D'
        WHEN job_id = 'ST_CLERK' THEN
            'E'
        ELSE
            '0'
    END AS grade
FROM
    employees;

-- Pratice 5.
-- 4.
SELECT
    round(MAX(salary)) AS "Maximum",
    round(MIN(salary)) AS "Minimum",
    round(SUM(salary)) AS "Sum",
    round(AVG(salary)) AS "Average"
FROM
    employees;

-- 5.
SELECT
    job_id,
    round(MAX(salary)) AS "Maximum",
    round(MIN(salary)) AS "Minimum",
    round(SUM(salary)) AS "Sum",
    round(AVG(salary)) AS "Average"
FROM
    employees
group by job_id;

-- 6.
select count(*)
from employees
group by job_id;

-- 7.
select count(distinct manager_id) as "Number of Managers"
from employees;

select manager_id
from employees;

-- 8.
select max(salary) - min(salary) as difference
from employees;

-- 9.
select manager_id, min(salary)
from employees
where manager_id is not null
group by manager_id
having min(salary) > 6000
order by min(salary) desc;

select department_id, min(salary)
from employees
group by department_id
having min(salary) > 7000;

-- 10.
select job_id, 
        sum(decode(department_id, 20, salary)) as "Dept 20",
        sum(decode(department_id, 50, salary)) as "Dept 50",
        sum(decode(department_id, 80, salary)) as "Dept 80",
        sum(decode(department_id, 90, salary)) as "Dept 90",
        sum(salary) as "Total"
from employees
group by job_id;

-- Pratice 6.
-- 1.
select location_id, street_address, city, state_province, country_name
from locations
natural join countries;

-- 2.
select last_name, department_id, department_name
from employees
natural join departments;

select e.last_name, e.department_id, d.department_name
from employees e
left outer join departments d on (e.department_id = d.department_id);

-- 3.
select e.last_name, e.job_id, e.department_id, d.department_name, l.city
from employees e
join departments d on (e.department_id = d.department_id)
join locations l on (d.location_id = l.location_id)
where l.city = 'Toronto';

-- 4.
select  e.last_name as "Employee", 
        e.employee_id as "Emp#",
        m.last_name as "Manager",
        m.employee_id as "Mgr#"
from employees e
join employees m on (e.manager_id = m.employee_id);

-- 5.
select  e.last_name as "Employee", 
        e.employee_id as "Emp#",
        m.last_name as "Manager",
        m.employee_id as "Mgr#"
from employees e
left outer join employees m on (e.manager_id = m.employee_id)
order by 2;

-- 6.
select e.last_name, e.department_id, c.last_name, d.department_name
from employees e
join employees c on (e.department_id = c.department_id)
join departments d on (e.department_id = d.department_id)
order by 2, 1, 3;

select last_name, department_id
from employees
order by 2;

-- 7.
desc job_grades;

select e.last_name, e.job_id, d.department_name, e.salary, j.grade_level
from employees e
join departments d on (e.department_id = d.department_id)
join job_grades j on (e.salary between j.lowest_sal and j.highest_sal);


-- Pratice &
-- 1.
select last_name, hire_date
from employees
where department_id = (select department_id
                       from employees
                       where last_name = 'Zlotkey')
and last_name <> 'Zlotkey';    

-- 2.
select employee_id, last_name
from employees
where salary > (select avg(salary)
                from employees)
order by salary;

