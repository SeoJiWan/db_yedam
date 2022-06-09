desc employees;

-- 1번 HR
-- dbms 가 빈 공간으로 데이터를 넣어준다. --> 튜플의 무순서
-- 진행중인 트랜잭션은 자기자신만 볼 수 있다.
INSERT INTO departments VALUES (
    70,
    'Public Relations',
    100,
    1700
);

SELECT
    *
FROM
    departments;

-- << rollback >> --
ROLLBACK;

SELECT
    *
FROM
    departments;

-- << insert >> --
INSERT INTO departments VALUES (
    70,
    'Public Relations',
    100,
    1700
);

SELECT
    *
FROM
    departments;

COMMIT;

--특별한 값 입력
--SYSDATE 입력
INSERT INTO employees VALUES (
    113,
    'Louis',
    'Popp',
    'LPOPP',
    '515.124.4567',
    sysdate,
    'AC_ACCOUNT',
    6900,
    NULL,
    205,
    110
);
--TO_DATE 함수 사용
INSERT INTO employees VALUES (
    114,
    'Den',
    'Raphealy',
    'DRAPHEAL',
    '515.127.4561',
    TO_DATE('02 03, 99', 'MM DD, YY'),-- YY --> 2099년
    'SA_REP',
    11000,
    0.2,
    100,
    60
);

INSERT INTO employees VALUES (
    115,
    'Mark',
    'Kim',
    'MKIM',
    '515.127.4562',
    TO_DATE('02 03, 99', 'MM DD, RR'),-- RR --> 1999년
    'SA_REP',
    13000,
    0.25,
    100,
    60
);

SELECT
    *
FROM
    employees;

SELECT
    employee_id,
    last_name,
    to_char(hire_date, 'yyyy/mm/dd') AS hire_date
FROM
    employees;
    
-- << 다른 테이블로 행 복사 >> --
-- 빈 테이블 복사 (칼럼만)
-- DDL (create / alter / drop / truncate) --> 사용 시 자동 커밋
CREATE TABLE sales_reps
    AS
        SELECT
            employee_id id,
            last_name   name,
            salary,
            commission_pct
        FROM
            employees
        WHERE
            1 = 2;

desc sales_reps;

SELECT
    *
FROM
    sales_reps;

--치환변수 사용(40, Human Resource, 2500 입력)
INSERT INTO departments (
    department_id,
    department_name,
    location_id
) VALUES (
    &department_id,
    '&department_name',
    &location
);

COMMIT;

SELECT
    *
FROM
    employees;

SELECT
    *
FROM
    departments;

-- << update >> --
UPDATE employees
SET
    salary = 7000
WHERE
    employee_id = 304; --> 0개 업데이트

SELECT
    *
FROM
    employees;

UPDATE employees
SET
    salary = salary * 1.1
WHERE
    employee_id = 104;

ROLLBACK;

-- 서브쿼리를 사용한 UPDATE
UPDATE employees
SET
    job_id = (
        SELECT
            job_id
        FROM
            employees
        WHERE
            employee_id = 205
    ),
    salary = (
        SELECT
            salary
        FROM
            employees
        WHERE
            employee_id = 205
    )
WHERE
    employee_id = 113;

UPDATE employees
SET
    department_id = (
        SELECT
            department_id
        FROM
            departments
        WHERE
            department_name LIKE '%Public%'
    )
WHERE
    employee_id = 115;

COMMIT;

                                              
--DELETE
DELETE FROM departments
WHERE
    department_name = 'Finance';

DELETE FROM employees
WHERE
    department_id = (
        SELECT
            department_id
        FROM
            departments
        WHERE
            department_name LIKE '%Public%'
    );

COMMIT;

delete from departments; --> dbms 가 막음 

select * 
from employees
join departments using(department_id);

select * from departments;

--DELETE 와 TRUNCATE
SELECT * FROM sales_reps;
DELETE FROM sales_reps;
SELECT * FROM sales_reps;
ROLLBACK;
SELECT * FROM sales_reps;
TRUNCATE TABLE sales_reps; --> DDL --> 자동 커밋 --> rollback 안먹음.
SELECT * FROM sales_reps;
ROLLBACK;
SELECT * FROM sales_reps;
INSERT INTO sales_reps
SELECT employee_id, last_name, salary, commission_pct
FROM   employees
WHERE  job_id LIKE '%REP%';
SELECT * FROM sales_reps;
COMMIT;



----------------------
delete from employees;

create table bigemp
as
select * from employees;

select *
from bigemp;

delete from bigemp;

rollback;

insert into bigemp
select * from bigemp;

commit;

update bigemp
set salary = salary * 1.1;  

rollback;

delete bigemp; --> undo date 생성 O --> 오래 걸림

select *
from bigemp;

commit;

truncate table bigemp; --> undo data 생성 X --> 오래안걸림
