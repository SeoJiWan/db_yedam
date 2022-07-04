-- GROUP 함수의 기본 사용 --
SELECT
    AVG(salary),
    MAX(salary),
    MIN(salary),
    SUM(salary)
FROM
    employees;

SELECT
    AVG(salary),
    MAX(salary),
    MIN(salary),
    SUM(salary)
FROM
    employees
WHERE
    department_id = 60;

SELECT
    MIN(last_name),
    MAX(last_name)
FROM
    employees;

SELECT
    MIN(hire_date),
    MAX(hire_date)
FROM
    employees;

SELECT
    COUNT(*), --> count 함수는 * 사용 가능
    COUNT(department_id), --> null값 빼고 세아림
    COUNT(DISTINCT department_id) --> count 함수는 distinct(중복제거) 사용 가능
FROM
    employees;

SELECT
    AVG(commission_pct), --> null 값 빼고 계산
    AVG(nvl(commission_pct, 0)) --> null값을 0으로 하고 계산
FROM
    employees;
    
--GROUP BY 절의 사용
SELECT
    department_id,
    SUM(salary),
    COUNT(*)
FROM
    employees;

SELECT
    department_id, --> group by 절에 있는 칼럼만 select 할 수 있음.
    SUM(salary),
    COUNT(*)
FROM
    employees
GROUP BY
    department_id;

SELECT
    department_id,
    SUM(salary),
    COUNT(*)
FROM
    employees
GROUP BY
    department_id
ORDER BY
    1;

SELECT
    department_id,
    job_id,
    SUM(salary),
    COUNT(*)
FROM
    employees
GROUP BY
    department_id, --> department_id 로 그룹화 하고
    job_id --> 같은 department_id 내에서 job_id 로 한번 더 그룹화
ORDER BY
    1,
    2;

SELECT
    department_id,
    job_id,
    SUM(salary),
    COUNT(*)
FROM
    employees
WHERE
    department_id >= 50
GROUP BY
    department_id,
    job_id
ORDER BY
    1,
    2;
    
-- HAVING 절의 사용 --
SELECT
    department_id,
    job_id,
    SUM(salary),
    COUNT(*)
FROM
    employees
WHERE
    COUNT(*) <> 1 --> 그룹 만들기 전이라 조건이 성립할 수 없음. --> group by 절 뒤에 having 절로 적어야함 
GROUP BY
    department_id,
    job_id
ORDER BY
    1,
    2;

SELECT
    department_id,
    job_id,
    SUM(salary),
    COUNT(*)
FROM
    employees
where
    department_id <> 90
GROUP BY
    department_id,
    job_id
HAVING --> 그룹을 선택할 수 있는 조건, having절은 group by 절이 필수다.
    COUNT(*) <> 1
ORDER BY
    1,
    2;
    
-- GROUP 함수의 중첩 --
SELECT
    MAX(SUM(salary))
FROM
    employees
GROUP BY
    department_id;

SELECT
    department_id,
    MAX(SUM(salary))
FROM
    employees
GROUP BY
    department_id;
    
select 
    department_id,
    sum(salary)
from
    employees
group by
    department_id
having sum(salary) = (select max(sum(salary))
                      from employees
                      group by department_id);