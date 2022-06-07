SELECT
    salary
FROM
    employees
WHERE
    last_name = 'Grant';

SELECT
    * --> 메인쿼리
FROM
    employees
WHERE
        salary > (
            SELECT
                salary
            FROM
                employees
            WHERE
                last_name = 'Grant'
        ) --> 서브쿼리 먼저 실행
    AND hire_date < (
        SELECT
            hire_date
        FROM
            employees
        WHERE
            last_name = 'Grant'
    );

-- Subquery의 기본 사용
SELECT
    salary
FROM
    employees
WHERE
    last_name = 'Abel';

SELECT
    *
FROM
    employees
WHERE
    salary > 11000;

SELECT
    *
FROM
    employees
WHERE
    salary > (
        SELECT
            salary
        FROM
            employees
        WHERE
            last_name = 'Abel'
    );
-- 단일행 서브쿼리(Single Row Subquery) --
SELECT
    last_name,
    job_id,
    salary
FROM
    employees
WHERE
        job_id = (
            SELECT
                job_id
            FROM
                employees
            WHERE
                last_name = 'Matos'
        )
    AND salary > (
        SELECT
            salary
        FROM
            employees
        WHERE
            last_name = 'Matos'
    );

SELECT
    MAX(salary)
FROM
    employees;

SELECT
    last_name,
    job_id,
    salary
FROM
    employees
WHERE
    salary = (
        SELECT
            MAX(salary)
        FROM
            employees
    );

SELECT
    department_id,
    COUNT(*)
FROM
    employees
GROUP BY
    department_id
HAVING --> 그룹을 선택하는 조건 --> where 절 X
    COUNT(*) > (
        SELECT
            COUNT(*)
        FROM
            employees
        WHERE
            department_id = 20
    );

SELECT
    last_name,
    job_id,
    salary
FROM
    employees
WHERE
    salary = (
        SELECT
            MAX(salary)
        FROM
            employees
        WHERE
            department_id = 60
    );              
    
-- 다중 행 서브쿼리(Multiple Row Subquery) --
SELECT
    MAX(salary)
FROM
    employees
GROUP BY
    department_id;

SELECT
    last_name,
    job_id,
    salary
FROM
    employees
WHERE
    salary = (
        SELECT --> 다중행 서브쿼리 --> '=' 연산자와 사용하여 오류발생
            MAX(salary)
        FROM
            employees
        GROUP BY
            department_id
    ); -- > 오류 : single-row subquery returns more than one row.

-- #다중행 연산자
--     단일행               다중행
--       =          ->     in
--      <>          ->     not in
--  >, >=, <, <=    ->     연산자 + any(최소보다 ...), all
SELECT
    last_name,
    job_id,
    salary
FROM
    employees
WHERE
    salary IN (
        SELECT
            MAX(salary)
        FROM
            employees
        GROUP BY
            department_id
    );

SELECT
    salary
FROM
    employees
WHERE
    department_id = 60;

SELECT
    last_name,
    job_id,
    salary
FROM
    employees
WHERE
        salary > (
            SELECT
                salary
            FROM
                employees
            WHERE
                department_id = 60
        )
    AND department_id <> 60;

SELECT
    last_name,
    job_id,
    salary,
    department_id
FROM
    employees
WHERE
    salary > ANY (
        SELECT
            salary
        FROM
            employees
        WHERE
            department_id = 60
    )
    AND department_id <> 60; --> 60번 빼고 볼려고

SELECT
    last_name,
    job_id,
    salary
FROM
    employees
WHERE
    salary > ALL (
        SELECT
            salary
        FROM
            employees
        WHERE
            department_id = 60
    )
    AND department_id <> 60;
    
-- Subquery 사용 시 주의사항 --
SELECT
    last_name,
    job_id,
    salary
FROM
    employees
WHERE
    salary > (
        SELECT
            salary
        FROM
            employees
        WHERE
            last_name = 'Mark' --> 서브쿼리 반환 x -> 메인쿼리도 반환 x
    );

SELECT
    employee_id,
    last_name
FROM
    employees
WHERE
    employee_id IN (
        SELECT
            manager_id
        FROM
            employees
    );

SELECT
    employee_id,
    last_name
FROM
    employees
WHERE
    employee_id NOT IN (
        SELECT
            manager_id
        FROM
            employees
    );

SELECT
    employee_id,
    last_name
FROM
    employees
WHERE
    employee_id NOT IN (
        SELECT
            manager_id
        FROM
            employees
        WHERE
            manager_id IS NOT NULL
    ); 
    --> in 값 안의 null 이 있으면, 그 행은 무시 
    --> not in (x, y ,null) 일때 or 연산이 and 연산으로 바뀌면서 출력결과가 무조건 없음
    --> 해결방법 : 애초에 서브쿼리 안에서 null 이 아닌 값만 in 안에 들어오도록 한다.