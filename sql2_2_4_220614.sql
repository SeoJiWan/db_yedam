--Creating a Temporary Table
-- > temporary table 테이블명 on commit delete rows --> 커밋시 테이블 삭제
CREATE GLOBAL TEMPORARY TABLE emp_temp1 ON COMMIT DELETE ROWS
    AS
        SELECT
            employee_id,
            last_name,
            salary
        FROM
            employees;

--> temporary table 테이블명 on commit preserve rows --> 세션 종료시 테이블 삭제
CREATE GLOBAL TEMPORARY TABLE emp_temp2 ON COMMIT PRESERVE ROWS
    AS
        SELECT
            employee_id,
            last_name,
            salary
        FROM
            employees;
            
select * from emp_temp1;

select * from emp_temp2; --> session 종료 후 데이터 없어짐

--SQL Developer 종료 후 재실행
--Using a Temporary Table
SELECT
    *
FROM
    emp_temp1;

SELECT
    *
FROM
    emp_temp2;

INSERT INTO emp_temp1
    SELECT
        employee_id,
        last_name,
        salary
    FROM
        employees
    WHERE
        department_id = 50;

INSERT INTO emp_temp2
    SELECT
        employee_id,
        last_name,
        salary
    FROM
        employees
    WHERE
        department_id IN ( 80, 90 );

SELECT
    *
FROM
    emp_temp1;

SELECT
    *
FROM
    emp_temp2;

COMMIT;

SELECT
    *
FROM
    emp_temp1;

SELECT
    *
FROM
    emp_temp2;
    
-- temporary table 쓰는 이유 
-- : 다른 부서에서 같은 테이블에 작업을 하고 싶을때 각 temporary table 에서 작업 후
-- 나중에 서브쿼리로 머지함

drop table emp_temp1;
drop table emp_temp2;
