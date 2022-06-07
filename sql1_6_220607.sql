-- # JOIN(문법)
--  1. natural join
--  2. join ~ using
--  3. join ~ on
--  4. [left | right | full] outer join

SELECT
    employee_id,
    last_name,
    salary,
    department_id,
    department_name
FROM
         employees
    JOIN departments USING ( department_id );

-- NATURAL JOIN -- --> 컬럼명 같아야 함, FK가 1개일 때만 하면 좋음. 
SELECT
    *
FROM
    departments;

SELECT
    *
FROM
    locations;

SELECT
    department_id,
    department_name,
    location_id,
    city,
    street_address
FROM
         departments
    NATURAL JOIN --> 제약 : 양 테이플의 컬럼의 이름이 같아야한다.
     locations;

SELECT
    employee_id,
    last_name,
    department_id,
    department_name
FROM
         employees
    NATURAL JOIN --> 같은 컬럼이 두개 -> 더 강한 조인이 발생
     departments;
    
-- USING 절을 사용하는 JOIN -- --> 특정 컬럼을 통해 조인
SELECT
    employee_id,
    last_name,
    department_id,
    department_name
FROM
    employees
    JOIN departments USING ( department_id ); --> department_id 가 null 인 값 빼고 19개의 행 출력, 컬럼명이 같아야만 조회 가능

SELECT
    department_id,
    department_name,
    location_id,
    city
FROM
         departments
    JOIN locations USING ( location_id );
    
-- ON절을 사용하는 JOIN -- --> PK, FK 칼럼명이 달라도 사용 가능
SELECT
    employee_id,
    last_name,
    department_id,
    department_name
FROM
    employees
    JOIN departments ON ( employees.department_id = departments.department_id ); -- > 오류 발생, 72line의 department_id 는 누구꺼냐?

SELECT
    employee_id,
    last_name,
    employees.department_id, --> 제약 : on절처럼 select 문에서 칼럼명 앞에 접두어 (테이블명.) 을 써야한다.
    department_name
FROM
         employees
    JOIN departments ON ( employees.department_id = departments.department_id );
    
-- 테이블 이름 별칭 사용 --
SELECT
    employees.employee_id,
    employees.last_name,
    employees.department_id,
    departments.department_name
FROM
    employees
    JOIN departments ON ( employees.department_id = departments.department_id );

SELECT
    e.employee_id,
    e.last_name,
    e.department_id,
    d.department_name
FROM
    employees e --> from 절에 테이블명 다음 약어 사용
    JOIN departments d ON ( e.department_id = d.department_id ); --> 가장 완성되고 흔한 join 문
    
-- WHERE 절 추가 --
SELECT
    e.employee_id,
    e.last_name,
    e.salary,
    e.manager_id,
    e.department_id,
    d.department_name,
    d.manager_id
FROM 
    employees e 
    JOIN departments d ON ( e.department_id = d.department_id ) --> from ~ join ~ on = 세트
WHERE
    e.salary > 9000; --> where 절의 위치 : on 절 다음

SELECT
    e.employee_id,
    e.last_name,
    e.salary,
    e.department_id,
    d.department_name
FROM
         employees e
    JOIN departments d ON ( e.department_id = d.department_id )
                          AND e.salary > 9000; --> where 대신 and 가능
                          
-- INNER JOIN과 OUTER JOIN -- 
--> join 결과를 만족해서 출력된 행 : inner 행, 출력되지 않은 행 : outer 행
--> outer join : 
SELECT
    e.employee_id,
    e.last_name,
    e.department_id,
    d.department_name
FROM
    employees e
    JOIN departments d ON ( e.department_id = d.department_id );

SELECT
    e.employee_id,
    e.last_name,
    e.department_id,
    d.department_name
FROM
    employees   e
    LEFT OUTER JOIN departments d ON ( e.department_id = d.department_id ); -- left는 왼쪽, right는 오른쪽 테이블에 값이 있을 경우 반대 테이블이 조건에 맞지 않아도 null 값으로 가져온다

select employee_id, last_name, department_id
from employees;

select *
from departments;

SELECT
    e.employee_id,
    e.last_name,
    e.department_id,
    d.department_name
FROM
    employees e
    RIGHT OUTER JOIN departments d ON ( e.department_id = d.department_id );

SELECT
    e.employee_id,
    e.last_name,
    e.department_id,
    d.department_name
FROM
    employees   e
    FULL OUTER JOIN departments d ON ( e.department_id = d.department_id );
    
-- USING절에 OUTER 조인하기 --
SELECT
    employee_id,
    last_name,
    department_id,
    department_name
FROM
    employees
    LEFT OUTER JOIN departments USING ( department_id );
    
SELECT
    employee_id,
    last_name,
    department_id,
    department_name
FROM
    employees
    left outer JOIN departments USING ( department_id );
    
-- SELF JOIN --
select employee_id, last_name, manager_id
from employees;

SELECT
    e.employee_id,
    e.last_name,
    e.manager_id,
    m.last_name,
    m.employee_id
FROM
    employees e
    JOIN employees m ON ( e.manager_id = m.employee_id ); --> self join 은 별칭 필수

SELECT
    e.employee_id,
    e.last_name,
    e.manager_id,
    m.last_name
FROM
    employees e
    LEFT OUTER JOIN employees m ON ( e.manager_id = m.employee_id );
    
-- NON-EQUI JOIN --
SELECT
    *
FROM
    job_grades;

SELECT
    e.employee_id,
    e.last_name,
    e.salary,
    j.grade_level
FROM
         employees e
    JOIN job_grades j ON ( e.salary BETWEEN j.lowest_sal AND j.highest_sal );
    
-- 3Way JOIN --
SELECT
    e.employee_id,
    e.last_name,
    d.department_id,
    d.location_id,
    l.city, 
    l.postal_code
FROM
         employees e
    JOIN departments d ON ( e.department_id = d.department_id )
    JOIN locations   l ON ( d.location_id = l.location_id );

SELECT
    e.employee_id,
    e.last_name,
    d.department_id,
    l.city
FROM
    employees   e
    FULL OUTER JOIN departments d ON ( e.department_id = d.department_id )
    JOIN locations   l ON ( d.location_id = l.location_id );
    
--  Cartesian Products --
SELECT
    employee_id,
    city
FROM
         employees
    NATURAL JOIN locations;

SELECT
    employee_id,
    department_name
FROM
         employees
    CROSS JOIN departments; --> 전체 경우
    
-- GROUP함수와 JOIN 응용 --
SELECT
    d.department_name,
    MIN(e.salary),
    MAX(e.salary),
    trunc(AVG(e.salary))
FROM
         employees e
    JOIN departments d ON ( e.department_id = d.department_id )
GROUP BY
    d.department_name;
    

-- join 정리 --
-- #문법
-- 1. natural join
-- 2. join ~ using
-- 3. join ~ on
-- 4. cross join

-- #조인결과에 아우터행을 포함할지 여부
-- 1. inner join
-- 2. outer join (left / right / full)

-- #테이블 수
-- 1. 1개 : self join
-- 2. 3개 : 3 way join

-- #연산자
-- 1. equi join (=)
-- 2. non equi join (ex. between)