select * from session_privs;

-- demo 에 객체 권한 부여 -> 객체 권한은 select 문을 만들어서 준다.
grant select on hr.employees to demo;

grant select on hr.locations to r1;

create view emp_list_vu
as
select employee_id 사원번호, 
       first_name || ' ' || last_name 사원이름,
       email,
       phone_number 전화번호,
       department_id 부서번호
from employees
where department_id <> 90;
  
select * from emp_list_vu;

revoke select on hr.employees from demo;

grant select on hr.emp_list_vu to demo;

-- 뷰 수정
create or replace view emp_list_vu
as
select employee_id 사원번호, 
       first_name || ' ' || last_name 사원이름,
       job_id 직급,
       email,
       phone_number 전화번호,
       department_id 부서번호
from employees
where department_id <> 90;

revoke select on hr.emp_list_vu from demo;
grant select on hr.emp_list_vu to demo;

desc departments;
desc locations;
-- 1. departments 와 locations 를 조인하여 부서번호, 부서이름, 도시이름이 출력되는 select 문 작성
select d.department_id 부서번호,
       d.department_name 부서이름,
       l.city 도시
from departments d
join locations l on (d.location_id = l.location_id);

-- 2. departments 와 locations 를 조인하여 부서번호, 부서이름, 도시이름이 출력되는 select 문 작성된 결과를 dept_loc_join_vu 라는 이름의 뷰로 정의
create or replace view dept_loc_join_vu
as
select d.department_id 부서번호,
       d.department_name 부서이름,
       l.city 도시
from departments d
join locations l on (d.location_id = l.location_id);

select * from dept_loc_join_vu;

-- 3. dept_loc_join_vu 뷰의 public 권한 부여 --> 아무나 봐라
grant select on hr.dept_loc_join_vu to public;

-- 권환 확인 : 동의어 vs 공용 동의어 --> 동의어는 인사관리에서 만들고 인사관리것이지만, 공용 동의어는 인사관리에서 만들지만 인사관리것이 아니라 공통소유임.
select * from session_privs;
-- public synonym 생성
create public synonym d for hr.dept_loc_join_vu;
