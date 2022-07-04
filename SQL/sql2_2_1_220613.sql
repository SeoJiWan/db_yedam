--Create a Table For Test
DROP TABLE dept80 PURGE;
-- 테이블 복사 --> 데이터까지 복사
CREATE TABLE dept80
    AS
        SELECT
            employee_id,
            last_name,
            salary * 12 AS annsal,
            hire_date
        FROM
            employees
        WHERE
            department_id = 80;

desc dept80;

SELECT
    *
FROM
    dept80;
    
--Adding a Column (컬럼 추가) --> null 값 삽입
ALTER TABLE dept80 ADD email VARCHAR2(30);

--Adding a Column with DEFAULT value (컬럼추가) --> default 값 'Not Yet' 삽입
ALTER TABLE dept80 ADD job VARCHAR2(10) DEFAULT 'Not Yet';

desc dept80;

SELECT
    *
FROM
    dept80;
    
desc dept80;

--modifying a Column (칼럼 유형 수정)
ALTER TABLE dept80 MODIFY
    last_name VARCHAR2(30);

desc dept80;

-- null 값이 들었던 추가한 email 칼럼에 default 값 'None' 추가
ALTER TABLE dept80 MODIFY
    email DEFAULT 'None';

SELECT
    *
FROM
    dept80;
-- update 를 통해 default 를 email 로 업데이트
UPDATE dept80
SET
    email = DEFAULT;

SELECT
    *
FROM
    dept80;

COMMIT;

--Dropping a Column (컬럼 삭제)
ALTER TABLE dept80 DROP COLUMN hire_date;

desc dept80;

SELECT
    *
FROM
    dept80;

-- 사용자에게 보이지 않게, 실제 데이터는 삭제X
ALTER TABLE dept80 SET UNUSED COLUMN annsal;

ALTER TABLE dept80 SET UNUSED COLUMN email;

desc dept80

SELECT
    *
FROM
    dept80;
-- 실제 사용하지 않는 데이터까지 다 삭제 -> 이 시점에 테이블의 용량이 줄어듬
ALTER TABLE dept80 DROP UNUSED COLUMNS;

--Clear Test
DROP TABLE dept80 PURGE;