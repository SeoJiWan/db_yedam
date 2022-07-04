SELECT * 
from employees;
select * 
from departments;
select location_id, department_name 
from departments;
select location_id, department_name 
from departments;

--표현식(expression) --
SELECT employee_id, last_name, salary, salary*12
from employees;
SELECT employee_id, last_name, salary, salary+100*12, (salary+100)*12
from employees;
SELECT employee_id, last_name, salary, salary*12 annual_salary
from employees;
SELECT employee_id, last_name, salary, salary*12
from employees;
SELECT employee_id empno, last_name empname, salary, salary*12 "Annual Salary"
from employees;

-- 연결연산자(||) --
select employee_id, first_name, last_name
from employees;
select employee_id, first_name || ' ' || last_name as full_name
from employees;
select employee_id, first_name || ' ' || last_name as full_name, email || '@epnt.co.kr' as email
from employees;
select last_name || ' : ' || salary
from employees;
select last_name || '''s salary : ' || salary
from employees;
select last_name || q'['s salary : ]'  || salary
from employees;

-- DISTINCT 중복제거--
select department_id
from employees;
select distinct department_id
from employees;
select distinct department_id, job_id
from employees;
--select distinct department_id, distinct job_id  --> 에러 --> distinct 는 한번만 사용
--from employees;

-- NULL값 (아무것도 저장되지 않은 상태, 0 또는 공백과 다른 상태) --
select employee_id, last_name, manager_id, commission_pct, department_id
from employees;
select employee_id, last_name, salary, commission_pct, salary + salary * commission_pct as 실급여 -- null 연산은 null 이다.
from employees;

-- 테이블 구조 (열 구조) --
describe employees;
desc departments;









