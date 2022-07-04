select * from session_privs;
create table test (id number(2));
insert into test
values (1);
select * from test;
rollback;

-- demo 에는 employees 테이블이 없다.
select * from employees;

-- demo 에는 hr.employees 테이블에 접근할 수 있는 권한이 없다. 
--> 인사관리에서 해당 권한 부여 후 실행하면 select 가능
-- 테이블 공유하여 data 노출 우려 --> view 가 필요함
select * from hr.employees;

-- 뷰를 통한 접근 허용
select * from hr.emp_list_vu;
-- hr.emp_list_vu 는 길어서 동의어 사용
-- 뷰는 인사관리 것이지만, 동의어는 데모 것 --> 뷰 권한 회수를 하면 동의어도 select 안됨
create synonym emp for hr.emp_list_vu;
select * from emp;

-- update 권한 부여 X -> 에러발생
update hr.employees
set salary = salary * 1.1;

-- r1 role 을 통한 권한 부여 가능
select * from hr.locations;

-- public 으로 권한 부여 -> demo, r1 에 권한부여 하지 않았는데 실행 가능
select * from hr.dept_loc_join_vu;

-- 공용동의어 사용
select * from d;