-- 치환변수 (&변수명)--
select employee_id, last_name, department_id, salary
from employees
where department_id = &부서번호;

select employee_id, last_name, department_id, salary
from employees
where last_name = '&사원이름'; --> 문자열은 '&변수명' 필요 (single quotation)

select employee_id, last_name, department_id, salary, &column_name || '@epnt.co.kr' as email
from employees;

select employee_id, last_name, department_id, salary, &column_name
from employees
order by &column_name; --> 변수명이 같아도 다르게 취급

select employee_id, last_name, department_id, salary, &&column_name --> && 는 변수를 저장
from employees
order by &column_name;

define column_name;
undefine column_name;

-- 문자 함수 --
select last_name, email, job_id
from employees;

select upper(last_name), lower(email), initcap(job_id)
from employees;

select *
from employees
where lower(last_name) = 'king'; --> last_name 칼럼을 소문자로 바꿔서 검색

select upper('oracle database'), lower('ORACLE DATABASE'), initcap('ORACLE DATABASE')
from dual; --> 오라클이 제공하는 더미 테이블

select 1234 + 1234
from dual;

select employee_id, concat(first_name, last_name) as fullname, salary
from employees;

select employee_id, concat(concat(first_name, ' '), last_name) as fullname, salary
from employees;

select employee_id, last_name, concat(email, '@epnt.co.kr') as email
from employees;

select substr('oracle database', 1, 6), substr('oracle database', 8, 4), substr('oracle database', 8), substr('oracle database', -4, 4)
from dual;

select employee_id, last_name,substr(last_name, 1, 3)
from employees
where substr(last_name, -1, 1) = 's';

select employee_id, last_name,substr(last_name, 1, 3)
from employees
where last_name like '%s';

select employee_id, last_name, length(last_name)
from employees;

select length('oracle database'), length('오라클 데이터베이스') --> 데이터 길이 비교
from dual;

select lengthb('oracle database'), lengthb('오라클 데이터베이스') --> 데이터 크기 비교 (영어한글자 1byte, 한글한글자 2~3byte)
from dual;

select employee_id, last_name, instr(last_name, 'a') --> 'a' 가 처음으로 나온 위치 값
from employees;

select *
from employees
where instr(last_name, 'a') = 0; --> 'a'가 이름에 없는 employee 출력

select *
from employees
where last_name not like '%a%';

select employee_id, rpad(last_name, 10, '#'), lpad(salary, 10, '*') --> last_name을 포함하여 '*'을 오른쪽에 추가하여 총 10자로 만듬
from employees;

select trim('o' from 'oracle database') --> 접두어, 접미어 자르기만 가능
from dual;

select trim('w' from 'window'), --> 접두, 접미 w 다 자름
        trim(leading 'w' from 'window'), --> 접두어만
        trim(trailing 'w' from 'window') --> 접미어만
        from dual;
        
select employee_id, last_name, phone_number
from employees;

select employee_id, last_name, concat('+82', trim(leading '0' from phone_number))
from employees;

select trim('0' from '00000123001122') --> 연속된 접두어 '0' 다 자름
from dual;

select trim('01' from '01010123001122') --> 한 문자만 지정 가능
from dual;

select ltrim('01010123001122', '01') --> 접두에서 반복되는 '0' 또는 '1' 자르기 (ltrim : 왼쪽부터)
from dual;

select rtrim(ltrim('010101230011220101010101', '01'), '01')
from dual;

select replace('Jack and Jue', 'J', 'Bl') --> string 에서 'J' 를 'Bl' 로 바꿈
from dual;

select employee_id, last_name, replace(last_name, substr(last_name, 2, 2), '**')
from employees;

-- 숫자함수 --
SELECT ROUND(45.923,2), ROUND(45.923), ROUND(45.923,-1) --> 인수가 없으면 소수점아래 1의자리에서 반올림
FROM   DUAL;

SELECT TRUNC(45.923,2), TRUNC(45.923), TRUNC(45.923,-1)
FROM   DUAL;

SELECT last_name, salary, MOD(salary, 5000)
FROM   employees
WHERE  job_id = 'SA_REP';

-- 날짜연산 --
SELECT sysdate --> 데이터베이스 서버시간
FROM dual;

SELECT sysdate, sysdate+10, sysdate + 20 --> 날짜 더하기, 빼기 가능 (정수)
FROM dual;

SELECT employee_id, last_name, hire_date, sysdate-hire_date AS 근무일수
FROM employees;

SELECT employee_id, last_name, hire_date, trunc(sysdate-hire_date) AS 근무일수
FROM employees;

SELECT last_name, ROUND((SYSDATE-hire_date)/7) AS WEEKS
FROM   employees;

-- 날짜함수 --
SELECT employee_id, last_name, hire_date, MONTHS_BETWEEN(sysdate, hire_date) AS 근무기간
FROM employees;

SELECT employee_id, last_name, TRUNC(MONTHS_BETWEEN(sysdate, hire_date))AS 근무기간
FROM employees;

SELECT ADD_MONTHS(sysdate, 3), LAST_DAY(sysdate)
FROM dual;

SELECT NEXT_DAY(sysdate, '금요일'), NEXT_DAY(sysdate, '금'), NEXT_DAY(sysdate, 7), NEXT_DAY(sysdate, 3)
FROM dual;      

SELECT NEXT_DAY(sysdate, 'FRIDAY') --> 'friday' 는 인식 못함
FROM dual;

SELECT sysdate, ROUND(sysdate, 'year'), ROUND(sysdate, 'month'), ROUND(sysdate, 'dd'), ROUND(sysdate, 'day')
FROM dual;       

SELECT sysdate, TRUNC(sysdate, 'year'), TRUNC(sysdate, 'month'), TRUNC(sysdate, 'dd'), TRUNC(sysdate, 'day')
FROM dual;

-- 문제 -- 
select last_name, hire_date, last_day(hire_date) + 5 as 첫급여일, next_day(add_months(hire_date, 3), 6) as 업무검토일
from employees;