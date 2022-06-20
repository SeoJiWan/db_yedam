-- # Standard join
--  - {table} join ... {table}

-- # Non Standard join
--  - from {table}, {table}
--    where {column} = {column};


--Equi Join
SELECT e.employee_id, e.last_name, e.department_id, d.department_name
FROM employees e JOIN departments d
ON (e.department_id = d.department_id);

SELECT e.employee_id, e.last_name, e.department_id, d.department_name
FROM employees e , departments d
WHERE e.department_id = d.department_id;

--추가조건
SELECT e.employee_id, e.last_name, e.department_id, d.department_name
FROM employees e JOIN departments d
ON (e.department_id = d.department_id)
WHERE salary > 8000;

SELECT e.employee_id, e.last_name, e.department_id, d.department_name
FROM employees e , departments d
WHERE e.department_id = d.department_id
AND e.salary > 8000;

--Outer Join
SELECT e.employee_id, e.last_name, e.department_id, d.department_name
FROM employees e LEFT OUTER JOIN departments d
ON (e.department_id = d.department_id);

SELECT e.employee_id, e.last_name, e.department_id, d.department_name
FROM employees e , departments d
WHERE e.department_id = d.department_id(+);

SELECT e.employee_id, e.last_name, e.department_id, d.department_name
FROM employees e RIGHT OUTER JOIN departments d
ON (e.department_id = d.department_id);

SELECT e.employee_id, e.last_name, e.department_id, d.department_name
FROM employees e , departments d
WHERE e.department_id(+) = d.department_id;

SELECT e.employee_id, e.last_name, e.department_id, d.department_name
FROM employees e FULL OUTER JOIN departments d
ON (e.department_id = d.department_id);

SELECT e.employee_id, e.last_name, e.department_id, d.department_name
FROM employees e , departments d
WHERE e.department_id(+) = d.department_id
UNION
SELECT e.employee_id, e.last_name, e.department_id, d.department_name
FROM employees e , departments d
WHERE e.department_id = d.department_id(+);

-- 사원과 부서테이블을 조인한 결과 아우터행만 표시하시오.
SELECT e.employee_id, e.last_name, e.department_id, d.department_name
FROM employees e LEFT OUTER JOIN departments d
ON (e.department_id = d.department_id)
MINUS
SELECT e.employee_id, e.last_name, e.department_id, d.department_name
FROM employees e JOIN departments d
ON (e.department_id = d.department_id);



--Non Equi Join
SELECT e.employee_id, e.last_name, e.salary, j.grade_level
FROM employees e JOIN job_grades j
ON (e.salary BETWEEN j.lowest_sal AND j.highest_sal);

SELECT * from job_grades;

SELECT e.employee_id, e.last_name, e.salary, j.grade_level
FROM employees e , job_grades j
WHERE e.salary BETWEEN j.lowest_sal AND j.highest_sal;



--Self Join
SELECT e.employee_id, e.last_name, e.manager_id, m.last_name
FROM employees e JOIN employees m
ON (e.manager_id = m.employee_id);

SELECT e.employee_id, e.last_name, e.manager_id, m.last_name
FROM employees e, employees m
WHERE e.manager_id = m.employee_id;

--3Way Join
SELECT e.employee_id, e.last_name, e.department_id, d.department_name, l.city
FROM employees e JOIN departments d
ON (e.department_id = d.department_id)
JOIN locations l
ON (d.location_id = l.location_id);

SELECT e.employee_id, e.last_name, e.department_id, d.department_name, l.city
FROM employees e ,departments d, locations l
WHERE e.department_id = d.department_id
AND d.location_id = l.location_id;

--Cross Join
SELECT last_name, department_name
FROM employees CROSS JOIN departments;

SELECT last_name, department_name
FROM employees ,departments;