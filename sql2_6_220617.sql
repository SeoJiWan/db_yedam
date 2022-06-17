--Multiple Column Subquery 실습에 필요한 EMPL_DEMO 테이블 생성
@C:\db_test\sql_labs\cre_empl.sql 

SELECT
    COUNT(*)
FROM
    empl_demo;

desc empl_demo;
    
--쌍비교 서브쿼리 실행
SELECT
    first_name,
    manager_id,
    department_id
FROM
    empl_demo
WHERE
    first_name = 'John';
  
-- m    d  
-- 108	100
-- 123	50
-- 100	80

SELECT
    first_name,
    manager_id,
    department_id
FROM
    empl_demo
WHERE
    ( manager_id, department_id ) IN ( --> 매니저번호와 부서번호 쌍으로 봄
        SELECT
            manager_id, department_id
        FROM
            empl_demo
        WHERE
            first_name = 'John'
    )
AND first_name <> 'John';
    
--비쌍비교 서브쿼리 실행
SELECT
    first_name,
    manager_id,
    department_id
FROM
    empl_demo
WHERE
    manager_id IN (
        SELECT
            manager_id
        FROM
            empl_demo
        WHERE
            first_name = 'John'
    )
    AND department_id IN (
        SELECT
            department_id
        FROM
            empl_demo
        WHERE
            first_name = 'John'
    )
AND first_name <> 'John';

SELECT first_name, manager_id, department_id
FROM empl_demo
WHERE manager_id IN (100, 108, 123)      
and department_id IN (50, 80, 100)
AND first_name <> 'John';


--CASE 문에 사용된 서브쿼리
SELECT
    employee_id,
    last_name,
    (
        CASE
            WHEN department_id = (
                SELECT
                    department_id
                FROM
                    departments
                WHERE
                    location_id = 1800
            ) THEN
                'Canada'
            ELSE
                'USA'
        END
    ) AS location
FROM
    employees;

--ORDER BY 절에 사용된 서브쿼리
SELECT
    employee_id,
    last_name
FROM
    employees e
ORDER BY
    (
        SELECT
            department_name
        FROM
            departments d
        WHERE
            e.department_id = d.department_id
    );
    
--Correlated(상호관련) Subquery 실습 --> 메인쿼리와 서브쿼리가 독립적이지 않음.
--자신의 소속부서의 평균급여와 비교해서 자신의 급여가 부서의 평균급여보다 많은 직원 구하기
select employee_id, salary, department_id
from employees order by employee_id;

select avg(salary)
from employees
where department_id = &deptid;

SELECT
    last_name,
    salary,
    department_id
FROM
    employees o
WHERE
    salary > (
        SELECT
            AVG(salary)
        FROM
            employees i
        WHERE
            i.department_id = o.department_id
    );
    
--위 문장을 인라인뷰(In-line view)로 대체 ---> sql 튜닝
SELECT
    a.last_name,
    a.department_id,
    a.salary,
    b.avgsal
FROM
         employees a
    JOIN (
        SELECT
            department_id,
            AVG(salary) avgsal
        FROM
            employees
        GROUP BY
            department_id
    ) b ON ( a.department_id = b.department_id )
WHERE
    a.salary > b.avgsal;
    
--EXISTS/NOT EXISTS 연산자 실습
SELECT
    employee_id,
    last_name,
    job_id,
    department_id
FROM
    employees o
WHERE
    EXISTS (
        SELECT
            'X' -- x플래그
        FROM
            employees
        WHERE
            manager_id = o.employee_id
    );

SELECT
    employee_id,
    last_name,
    job_id,
    department_id
FROM
    employees o
WHERE
    NOT EXISTS (
        SELECT
            'X'
        FROM
            employees
        WHERE
            manager_id = o.employee_id
    );
    
    
--상호관련 UPDATE와 상호관련 DELETE
DROP TABLE emp6;

CREATE TABLE emp6
    AS
        SELECT
            employee_id,
            last_name,
            salary
        FROM
            employees
        WHERE
            department_id IN ( 50, 60, 80 );

ALTER TABLE emp6 ADD job_id VARCHAR2(10);

SELECT
    *
FROM
    emp6;

UPDATE emp6
SET
    job_id = (
        SELECT
            job_id
        FROM
            employees
        WHERE
            emp6.employee_id = employee_id
    );

SELECT
    *
FROM
    emp6;

COMMIT;

DELETE FROM emp6
WHERE
    employee_id IN (
        SELECT
            employee_id
        FROM
            job_history
        WHERE
            employee_id = emp6.employee_id
    );

COMMIT;

-------------------------------------------- WITH 절 예제
--이전 인라인뷰를 사용하는 문장을  WITH 절로 변환
WITH 
avg_sal AS (SELECT department_id, TRUNC(AVG(salary)) avgsal
                  FROM employees
                 GROUP BY department_id),
emp_sal AS (SELECT employee_id, last_name, salary, department_id
                 FROM employees)
SELECT employee_id, last_name, salary, avgsal
FROM avg_sal JOIN emp_sal
USING (department_id)
WHERE avg_sal.avgsal < emp_sal.salary;

--WITH 문을 사용하여 부서별 평균급여 및 관리 리전을 함께 표시
WITH 
avgsal AS (SELECT department_id, TRUNC(AVG(salary)) avgsal
                  FROM employees
                 GROUP BY department_id),
dept_loc AS (SELECT department_id, department_name, city
              FROM departments JOIN locations
              USING (location_id)),
region_list AS (SELECT city, country_name AS country, region_name AS region
                FROM locations JOIN countries
                USING (country_id)
                JOIN regions
                 USING (region_id))
SELECT department_id, avgsal, r.region
FROM avgsal JOIN (SELECT department_id, region
                   FROM dept_loc JOIN region_list
                   USING (city)) r
using(department_id);

------------------------------------------
SELECT
        d.department_name,
        SUM(e.salary) AS dept_total,
        count(*)
    FROM
             employees e
        JOIN departments d ON e.department_id = d.department_id
    GROUP BY
        d.department_name;
                        
select * from employees;


WITH dept_costs AS (
    SELECT
        d.department_name,
        SUM(e.salary) AS dept_total
    FROM
             employees e
        JOIN departments d ON e.department_id = d.department_id
    GROUP BY
        d.department_name
), avg_cost AS (
    SELECT
        SUM(dept_total) / COUNT(*) AS dept_avg
    FROM
        dept_costs
)
SELECT
    *
FROM
    dept_costs
WHERE
    dept_total > (
        SELECT
            dept_avg
        FROM
            avg_cost
    )
ORDER BY
    department_name;

--Clear Test
DROP TABLE empl_demo PURGE;

DROP TABLE emp6 PURGE;