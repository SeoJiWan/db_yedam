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
JOIN 
    departments 
USING 
    ( department_id );

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
    city
FROM
    departments
NATURAL JOIN 
    locations;

SELECT
    employee_id,
    last_name,
    department_id,
    department_name
FROM
    employees
NATURAL JOIN 
    departments;
    
-- USING 절을 사용하는 JOIN --
SELECT
    employee_id,
    last_name,
    department_id,
    department_name
FROM
         employees
    JOIN departments USING ( department_id );

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
    JOIN departments ON ( employees.department_id = departments.department_id );

SELECT
    employee_id,
    last_name,
    employees.department_id,
    department_name
FROM
         employees
    JOIN departments ON ( employees.department_id = departments.department_id );
--테이블 이름 별칭 사용
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
         employees e
    JOIN departments d ON ( e.department_id = d.department_id );
--WHERE 절 추가
SELECT
    e.employee_id,
    e.last_name,
    e.salary,
    e.department_id,
    d.department_name
FROM
         employees e
    JOIN departments d ON ( e.department_id = d.department_id )
WHERE
    e.salary > 9000;

SELECT
    e.employee_id,
    e.last_name,
    e.salary,
    e.department_id,
    d.department_name
FROM
         employees e
    JOIN departments d ON ( e.department_id = d.department_id )
                          AND e.salary > 9000;
--INNER JOIN과 OUTER JOIN
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
    LEFT OUTER JOIN departments d ON ( e.department_id = d.department_id );

SELECT
    e.employee_id,
    e.last_name,
    e.department_id,
    d.department_name
FROM
    employees   e
    RIGHT OUTER JOIN departments d ON ( e.department_id = d.department_id );

SELECT
    e.employee_id,
    e.last_name,
    e.department_id,
    d.department_name
FROM
    employees   e
    FULL OUTER JOIN departments d ON ( e.department_id = d.department_id );
--USING절에 OUTER 조인하기
SELECT
    employee_id,
    last_name,
    department_id,
    department_name
FROM
    employees
    LEFT OUTER JOIN departments USING ( department_id );
--SELF JOIN
SELECT
    e.employee_id,
    e.last_name,
    e.manager_id,
    m.last_name
FROM
         employees e
    JOIN employees m ON ( e.manager_id = m.employee_id );

SELECT
    e.employee_id,
    e.last_name,
    e.manager_id,
    m.last_name
FROM
    employees e
    LEFT OUTER JOIN employees m ON ( e.manager_id = m.employee_id );
--NON-EQUI JOIN
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
--3Way JOIN
SELECT
    e.employee_id,
    e.last_name,
    d.department_id,
    l.city
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
--Cartesian Products
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
    CROSS JOIN departments;
--GROUP함수와 JOIN 응용
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