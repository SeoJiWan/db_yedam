--계층쿼리
--하향식(Top-Down)
SELECT employee_id, last_name, job_id, manager_id
FROM employees
START WITH employee_id = 100
CONNECT BY PRIOR employee_id = manager_id; -- 현재 행 (prior 없는행)   -- prior 가 붙은 행이 더 높은쪽이면 top down

--102번을 시작점으로 하향식 검색
SELECT employee_id, last_name, job_id, manager_id
FROM employees
START WITH employee_id = 102
CONNECT BY PRIOR employee_id = manager_id; --> (이전 행의 employee_id = 현재 행의 manager_id)

--LEVEL열의 표시
SELECT LEVEL, employee_id, last_name, job_id, manager_id
FROM employees
START WITH employee_id = 100
CONNECT BY PRIOR employee_id = manager_id;
order by level;

SELECT LEVEL, employee_id, last_name, job_id, manager_id
FROM employees
START WITH employee_id = 102
CONNECT BY PRIOR employee_id = manager_id;

--상향식(Bottom-Up) 검색 --> prior 를 자식행에 붙임
SELECT LEVEL, employee_id, last_name, job_id, manager_id
FROM employees
START WITH employee_id = 144
CONNECT BY  employee_id = PRIOR manager_id;

--결과를 입체적으로 출력하는 방법
SELECT LPAD(employee_id||last_name, LENGTH(employee_id||last_name)+(LEVEL*2)-2, '_') AS org_chart
FROM   employees 
START WITH employee_id = 100
CONNECT BY  PRIOR employee_id= manager_id ;

--계층쿼리 관련 함수
--CONNECT_BY_ISLEAF : 해당 행이 LEAF 이면 1을 반환
SELECT LPAD(employee_id||last_name, LENGTH(employee_id||last_name)+(LEVEL*2)-2,'_') 
       AS org_chart, CONNECT_BY_ISLEAF AS isleaf
FROM   employees 
START WITH employee_id = 100
CONNECT BY  PRIOR employee_id= manager_id ;

--상향식 검색에서의 LEAF
SELECT LPAD(employee_id||last_name, LENGTH(employee_id||last_name)+(LEVEL*2)-2,'_') 
       AS org_chart, CONNECT_BY_ISLEAF AS isleaf
FROM   employees 
START WITH employee_id = 144
CONNECT BY   employee_id= PRIOR manager_id ;

--SYS_CONNECT_BY_PATH : Root에서 현재 행까지의 경로 표시
SELECT LPAD(employee_id||last_name, LENGTH(employee_id||last_name)+(LEVEL*2)-2,'_') 
       AS org_chart,  SYS_CONNECT_BY_PATH(employee_id,'/') path
FROM   employees 
START WITH employee_id = 100
CONNECT BY  PRIOR employee_id= manager_id ;

--CONNECT_BY_ROOT : 현재 결과에서의 ROOT 행 표시
SELECT LPAD(employee_id||last_name, LENGTH(employee_id||last_name)+(LEVEL*2)-2,'_') 
       AS org_chart,  CONNECT_BY_ROOT(last_name) isroot
FROM   employees 
START WITH employee_id = 100
CONNECT BY  PRIOR employee_id= manager_id ;

--특정 가지 제거
SELECT LPAD(employee_id||last_name, LENGTH(employee_id||last_name)+(LEVEL*2)-2,'_') 
       AS org_chart
FROM   employees 
WHERE employee_id <> 101
START WITH employee_id = 100
CONNECT BY  PRIOR employee_id= manager_id ;

SELECT LPAD(employee_id||last_name, LENGTH(employee_id||last_name)+(LEVEL*2)-2,'_') 
       AS org_chart
FROM   employees 
START WITH employee_id = 100
CONNECT BY  PRIOR employee_id= manager_id 
AND employee_id <> 101;


-------------------------------------------------------------------------------------------------


--GROUP BY 확장
SELECT COUNT(*)  인원수, SUM(salary) 총급여, TRUNC(AVG(salary)) 평균급여
FROM employees;

SELECT department_id, COUNT(*)  인원수, SUM(salary) 총급여, TRUNC(AVG(salary)) 평균급여
FROM employees
GROUP BY department_id
ORDER BY 1;

SELECT department_id, job_id, COUNT(*)  인원수, SUM(salary) 총급여, TRUNC(AVG(salary)) 평균급여
FROM employees
GROUP BY department_id, job_id
ORDER BY 1;

SELECT department_id, job_id, COUNT(*)  인원수, SUM(salary) 총급여, TRUNC(AVG(salary)) 평균급여
FROM employees
GROUP BY department_id, job_id
UNION
SELECT department_id, TO_CHAR(null),  COUNT(*)  인원수,  SUM(salary) 총급여, TRUNC(AVG(salary)) 평균급여
FROM employees
GROUP BY department_id
UNION
SELECT TO_NUMBER(NULL), TO_CHAR(NULL), COUNT(*)  인원수, SUM(salary) 총급여, TRUNC(AVG(salary)) 평균급여
FROM employees
ORDER BY 1,2;

-- 1. group by department_id, job_id
-- 2. group by department_id,
-- 3. group by x
SELECT department_id, job_id, COUNT(*)  인원수, SUM(salary) 총급여, TRUNC(AVG(salary)) 평균급여
FROM employees
GROUP BY ROLLUP(department_id, job_id)
ORDER BY 1;

-- 모든 조합 -> 2^n 개수
-- 단점 : 너무 데이터가 많이 나옴. --> 보고싶은것만 볼 수 없음
SELECT department_id, job_id, COUNT(*)  인원수, SUM(salary) 총급여, TRUNC(AVG(salary)) 평균급여
FROM employees
GROUP BY CUBE(department_id, job_id)
ORDER BY 1;

-- 보고싶은것만 보자
SELECT department_id, job_id, manager_id, COUNT(*)  인원수, SUM(salary) 총급여, TRUNC(AVG(salary)) 평균급여
FROM employees
GROUP BY GROUPING SETS((department_id, job_id), (job_id, manager_id), ())
ORDER BY 1;
