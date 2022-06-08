-- #집합
-- 1. union [all] --> all 옵션은 중복제거를 하지 않음
-- 2. intersect
-- 3. minus

--실습에 사용되는 추가 테이블
SELECT
    *
FROM
    job_history;
    
-- << union (합집합) >> -- 
--> sql 에서 집합은 정적인게 아니다. 각 칼럼의 데이터가 전부 같아야 중복이다. 
SELECT
    employee_id
FROM
    employees
UNION
SELECT
    employee_id
FROM
    job_history;

SELECT
    employee_id,
    department_id --> 에러 : 칼럼 수가 같아야함
FROM
    employees
UNION
SELECT
    employee_id
FROM
    job_history;

SELECT
    employee_id,
    department_id
FROM
    employees
UNION
SELECT
    employee_id,
    job_id --> 에러 : 컬럼의 데이터타입이 같아야 한다.
FROM
    job_history;
    
-- 각 테이블의 n번재 칼럼이 상호관계가 있어야함, 자동정렬됨 --> order by 절 쓰면 안좋음, join, order by 절은 cpu 사용량이 많다.
SELECT
    employee_id,
    department_id
FROM
    employees
UNION
SELECT
    employee_id,
    department_id
FROM
    job_history;
    
-- 칼럼 명은 첫 번째 테이블의 칼럼명 따라감.
SELECT
    employee_id AS 사번,
    department_id
FROM
    employees
UNION
SELECT
    employee_id,
    department_id AS 부서번호
FROM
    job_history;
    
-- << UNION ALL >> --
SELECT
    employee_id
FROM
    employees
UNION
SELECT
    employee_id
FROM
    job_history;

SELECT
    employee_id
FROM
    employees
UNION ALL
SELECT
    employee_id
FROM
    job_history;
    
    
-- << INTERSECT >> --
SELECT
    employee_id
FROM
    employees
INTERSECT
SELECT
    employee_id
FROM
    job_history;

SELECT
    employee_id,
    job_id
FROM
    employees
INTERSECT
SELECT
    employee_id,
    job_id
FROM
    job_history;
    
    
-- << MINUS >> --
-- job_history 테이블에는 없고, employees 테이블에만 있는 사번 ==> 부서이동을 한 번도 하지 않은 사원
SELECT
    employee_id
FROM
    employees
MINUS
SELECT
    employee_id
FROM
    job_history;
    
-- ex) subquery 이용 --> 부서이동을 한 번도 하지 않은 사람의 이름, 부서번호, 업무 출력
select last_name, department_id, job_id
from employees
where employee_id in (select employee_id
                     from employees
                     minus
                     select employee_id
                     from job_history);

-- job_history 에만 있는 사번 --> 퇴사한 사원
SELECT
    employee_id
FROM
    job_history
MINUS
SELECT
    employee_id
FROM
    employees;
    
    
-- << COLUMN수와 DATATYPE 매칭시키기 >> --
-- 칼럼 개수 불일치하지만, 필요시는 타입만 맞춰주고 null 값 삽입
SELECT
    employee_id,
    hire_date,
    to_char(NULL) AS department_name
FROM
    employees
UNION
SELECT
    department_id,
    to_date(NULL),
    department_name
FROM
    departments;

SELECT
    employee_id,
    salary,
    to_char(NULL) AS department_name
FROM
    employees
UNION
SELECT
    department_id,
    - 1,
    department_name
FROM
    departments;
--COLUMN수와 DATATYPE 매칭시키기 응용
SELECT
    department_id,
    job_id,
    COUNT(*),
    SUM(salary)
FROM
    employees
GROUP BY
    department_id,
    job_id;

SELECT
    department_id,
    COUNT(*),
    SUM(salary)
FROM
    employees
GROUP BY
    department_id;

SELECT
    COUNT(*),
    SUM(salary)
FROM
    employees;
--
SELECT
    department_id,
    job_id,
    COUNT(*),
    SUM(salary)
FROM
    employees
GROUP BY
    department_id,
    job_id
UNION
SELECT
    department_id,
    to_char(NULL),
    COUNT(*),
    SUM(salary)
FROM
    employees
GROUP BY
    department_id
UNION
SELECT
    to_number(NULL),
    to_char(NULL),
    COUNT(*),
    SUM(salary)
FROM
    employees
ORDER BY
    1,
    2;