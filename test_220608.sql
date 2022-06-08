-- 1.
describe employees;

-- 2.
SELECT
    employee_id,
    last_name,
    salary,
    department_id
FROM
    employees
WHERE
    salary BETWEEN 5000 AND 9000
    AND department_id = 60;

 -- 3.
SELECT
    employee_id,
    last_name,
    hire_date,
    substr(email, 0, 3),
    instr(email, 'E') AS "0 : 미포함",
    length(email)
FROM
    employees
WHERE
    hire_date > '99/01/01';
 
 -- 4.
SELECT
    last_name,
    hire_date,
    add_months(hire_date, 6)                  AS "입사 6개월 후 날짜",
    next_day(hire_date, 6)                    AS "입사 후 첫 금요일",
    trunc(months_between(sysdate, hire_date)) AS "총 근무 개월",
    last_day(hire_date)                       AS "첫 급여일"
FROM
    employees;

-- 5.
SELECT
    employee_id,
    last_name,
    to_char(salary, '$99,999,999') AS "급여"
FROM
    employees
ORDER BY
    salary DESC;

-- 6.
SELECT
    employee_id,
    first_name,
    job_id,
    salary,
    department_id
FROM
    employees
WHERE
    commission_pct IS NOT NULL
    AND job_id LIKE '%REP%';

-- 7. --> 부서번호 칼럼 빼먹음,,
SELECT
    COUNT(*)           AS "인원수",
    SUM(salary)        AS "총급여",
    round(AVG(salary)) AS "평균급여",
    MIN(salary)        AS "최소급여",
    MAX(salary)        AS "최대급여"
FROM
    employees
GROUP BY
    department_id
HAVING
    COUNT(*) <> 1;

-- 8.
SELECT
    employee_id,
    last_name,
    department_id,
    CASE department_id
        WHEN 20 THEN
            'Canada'
        WHEN 80 THEN
            'UK'
        ELSE
            'USA'
    END AS "근무지역"
FROM
    employees;

-- 9.
SELECT
    e.employee_id,
    e.last_name,
    e.department_id,
    d.department_name
FROM
    employees   e
    LEFT OUTER JOIN departments d ON ( e.department_id = d.department_id );

-- 10.
SELECT
    employee_id,
    last_name,
    salary,
    job_id
FROM
    employees
WHERE
    salary = (
        SELECT
            MAX(salary)
        FROM
            employees
        WHERE
            department_id = 50
    );
