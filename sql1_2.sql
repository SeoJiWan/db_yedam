select employee_id, last_name, hire_date, salary, department_id
from employees;

-- where 절의 기본 사용법 --
select employee_id, last_name, hire_date, salary, department_id
from employees
where department_id = 50;
select employee_id, last_name, hire_date, salary, department_id
from employees
where department_id >= 50;
select employee_id, last_name, hire_date, salary, department_id
from employees
where department_id <> 50; --> <> --> 같지 않다.
-- 문자 데이터 비교 --
select employee_id, last_name, hire_date, salary, department_id
from employees
where last_name = 'King'; --> 대소문자 구별
select employee_id, last_name, hire_date, salary, department_id
from employees
where last_name = 'De Haan'; --> 띄어쓰기 구별
select employee_id, last_name, hire_date, salary, department_id
from employees
where last_name <> 'King';
select employee_id, last_name, hire_date, salary, department_id
from employees
where last_name >= 'King'; --> 한글은 영어보다 크다 ...xyz ㄱㄴ...
-- 날짜 데이터 비교 --
select employee_id, last_name, hire_date, salary, department_id
from employees
where hire_date = '97/09/17'; --> 날짜 데이터 타입이 따로 있음
select employee_id, last_name, hire_date, salary, department_id
from employees
where hire_date = '1997/09/17'; --> 날짜 데이터 타입이 따로 있음
select employee_id, last_name, hire_date, salary, department_id
from employees
where hire_date = '1997-09-17';
select employee_id, last_name, hire_date, salary, department_id
from employees
where hire_date = '1997.09.17';
select employee_id, last_name, hire_date, salary, department_id
from employees
where hire_date <> '1997/09/17';
select employee_id, last_name, hire_date, salary, department_id
from employees
where hire_date > '1997/09/17';
-- sql 비교연산자 (in / like / between / is null)--
select employee_id, last_name, hire_date, salary, department_id
from employees
where department_id in (50, 60, 10); --> or 연산자
select employee_id, last_name, hire_date, salary, department_id
from employees
where last_name in ('De Haan', 'Abel');
select employee_id, last_name, hire_date, salary, department_id
from employees
where last_name like 'K%'; --> like 는 % 와 세트
select employee_id, last_name, hire_date, salary, department_id
from employees
where last_name like '%a%';
select employee_id, last_name, hire_date, salary, department_id
from employees
where last_name like '%s';
select employee_id, last_name, hire_date, salary, department_id
from employees
where last_name like '%_a%'; --> 두 번째 글자가 a 인 사람 검색
select employee_id, last_name, hire_date, salary, department_id, job_id
from employees;
select employee_id, last_name, hire_date, salary, department_id
from employees
where last_name like '____'; --> 이름이 네 글자인 사람 검색
select employee_id, last_name, hire_date, salary, department_id, job_id
from employees
where job_id like 'IT\_%' escape '\'; --> 예외처리 --> _ 를 와일드카드로 안쓰겠다
select employee_id, last_name, hire_date, salary, department_id
from employees
where salary between 6000 and 9000; --> between 은 이상, 이하
select employee_id, last_name, hire_date, salary, department_id
from employees
where salary between 9000 and 6000;
select employee_id, last_name, hire_date, salary, department_id
from employees
where last_name between 'Abel' and 'King';
select employee_id, last_name, hire_date, salary, department_id, job_id
from employees
where hire_date between '00/01/01' and '00/12/31';
select employee_id, last_name, hire_date, salary, department_id, job_id
from employees
where department_id is null; --> null 검색은 = null 이 아닌 is null

-- 논리 연산자 (and / or / not) --
select employee_id, last_name, hire_date, salary, department_id, job_id
from employees
where department_id in (50, 60, 80)
and salary > 9000;
select employee_id, last_name, hire_date, salary, department_id, job_id
from employees
where department_id in (50, 60, 80)
or salary > 9000;
select employee_id, last_name, hire_date, salary, department_id, job_id
from employees
where (department_id = 50
or department_id = 60)
and salary > 8000;
select employee_id, last_name, hire_date, salary, department_id
from employees
where department_id not in (50, 60, 80);
select employee_id, last_name, hire_date, salary, department_id
from employees
where last_name not like 'K%'; --> like 는 % 와 세트
select employee_id, last_name, hire_date, salary, department_id
from employees
where salary not between 6000 and 9000; --> 6000미만, 9000초과
select employee_id, last_name, hire_date, salary, department_id, job_id
from employees
where department_id is not null;

-- 결과를 정렬하기 (order by 절 사용) --
select employee_id, last_name, hire_date, salary, department_id, job_id
from employees
where department_id is not null
order by salary; --> default 오름차순
select employee_id, last_name, hire_date, salary, department_id, job_id
from employees
where department_id is not null
order by salary desc; --> 내림차순
select employee_id, last_name, hire_date, salary, department_id, job_id
from employees
where department_id is not null
order by last_name;
select employee_id, last_name, hire_date, salary, department_id, job_id
from employees
where department_id is not null
order by hire_date desc;
select employee_id, last_name, hire_date, salary, department_id, job_id
from employees
where department_id is not null
order by department_id, salary; --> department_id 먼저 정렬 후 같은 department_id 내에서 salary 정렬 
select employee_id, last_name, hire_date, salary, department_id, job_id
from employees
where department_id is not null
order by department_id, salary desc; --> department_id 먼저 정렬 후 같은 department_id 내에서 salary 정렬 
select employee_id, last_name, hire_date, salary * 12 as 연봉, department_id, job_id
from employees
where department_id is not null
order by department_id, 연봉 desc; --> order by 절에는 표현식, alias 전부 가능
select employee_id, last_name, hire_date, salary * 12 as 연봉, department_id, job_id
from employees
where department_id is not null
order by 5, 4 desc; --> order by 절에는 칼럼번호도 올 수 있음, order by 절은 항상 제일 끝 줄에 온다.
select employee_id, last_name, hire_date, salary * 12 as 연봉, department_id, job_id
from employees
where salary * 12 > 120000 --> where 절은 표현식은 가능하지만, alias 는 불가능
order by 5, 4 desc;








