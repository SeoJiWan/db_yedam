--Create a Table For Test
DROP TABLE emp2 PURGE;

CREATE TABLE emp2
    AS
        SELECT
            *
        FROM
            employees;

-- 제약조건 확인
SELECT
    table_name,
    constraint_name,
    constraint_type,
    status,
    search_condition
FROM
    user_constraints
WHERE
    table_name = 'EMP2';
    
-- 제약조건 추가
ALTER TABLE emp2 ADD PRIMARY KEY ( employee_id );

ALTER TABLE emp2 ADD CONSTRAINT emp2_email_uk UNIQUE ( email );

SELECT
    table_name,
    constraint_name,
    constraint_type,
    status,
    search_condition
FROM
    user_constraints
WHERE
    table_name = 'EMP2';
    
--Disable a Constraints(PRIMARY KEY) (제약조건 비활성화 - 테이블에는 존재)
ALTER TABLE emp2 DISABLE PRIMARY KEY;

--제약조건에 위반하도록 데이터 수정(PRIMARY KEY 열에 중복데이터생성)
UPDATE emp2
SET
    employee_id = 102
WHERE
    employee_id = 101;

COMMIT;

SELECT
    employee_id
FROM
    emp2
WHERE
    employee_id = 102;
    
--Disable a Constraints(Non Primary Key) (primary key 아닌 제약조건 비활성화)
ALTER TABLE emp2 DISABLE CONSTRAINT emp2_email_uk;
--제약조건 상태확인
SELECT
    table_name,
    constraint_name,
    constraint_type,
    status
FROM
    user_constraints
WHERE
    table_name = 'EMP2';
    
--Enabling a Constraints (제약조건 활성화) -> 기존 데이터 검색 -> 제약조건에 맞는지
ALTER TABLE emp2 ENABLE CONSTRAINT emp2_email_uk;

--잘못된 데이터로 인해 제약조건 활성화에 실패한 경우 해결방법(Exception처리)
ALTER TABLE emp2 ENABLE PRIMARY KEY;

CREATE TABLE exceptions (
    row_id     ROWID,
    owner      VARCHAR2(128),
    table_name VARCHAR2(128),
    constraint VARCHAR2(128)
);

ALTER TABLE emp2 ENABLE PRIMARY KEY EXCEPTIONS INTO exceptions;

SELECT
    *
FROM
    exceptions;

SELECT
    *
FROM
    emp2;

SELECT
    employee_id,
    ROWID
FROM
    emp2
where rowid in (select row_id from exceptions);    

--rowid 값 복사 
UPDATE emp2
SET
    employee_id = 101
WHERE
    ROWID = 'AAAE9QAAEAAAAJ7AAD';
    
--복사한 rowid 값 사용
SELECT
    *
FROM
    emp2
WHERE
    employee_id IN ( 101, 102 );

COMMIT;

-- 기본 키 제약조건 활성화
ALTER TABLE emp2 ENABLE PRIMARY KEY;

SELECT
    table_name,
    constraint_name,
    constraint_type,
    status
FROM
    user_constraints
WHERE
    table_name = 'EMP2';

-- 데이터만 삭제
TRUNCATE TABLE exceptions;


--primary key, unique 제약조건 삭제
ALTER TABLE emp2 DROP PRIMARY KEY;

ALTER TABLE emp2 DROP CONSTRAINT emp2_email_uk;

SELECT
    table_name,
    constraint_name,
    constraint_type,
    status,
    search_condition
FROM
    user_constraints
WHERE
    table_name = 'EMP2';
    
-- 제약조건 지우는 방법 - 꿀팁
select 'alter table emp2 drop constraint ' || constraint_name ||';'
from user_constraints
where table_name = 'EMP2';

alter table emp2 drop constraint SYS_C007085;
alter table emp2 drop constraint SYS_C007086;
alter table emp2 drop constraint SYS_C007087;
alter table emp2 drop constraint SYS_C007088;
    
--Cascading Constraints
--Column Drop 시 추가 옵션
CREATE TABLE test1 (
    a NUMBER PRIMARY KEY,
    b NUMBER,
    c NUMBER,
    d NUMBER,
    CONSTRAINT test1_b_fk FOREIGN KEY ( b )
        REFERENCES test1,
    CONSTRAINT ck1 CHECK ( a > 0
                           AND c > 0 ),
    CONSTRAINT ck2 CHECK ( d > 0 )
);

desc test1

SELECT
    table_name,
    constraint_name,
    constraint_type,
    status,
    search_condition
FROM
    user_constraints
WHERE
    table_name = 'TEST1';

-- 아무랑도 연관이 없는 d 칼럼 --> 삭제 잘됨
ALTER TABLE test1 DROP COLUMN d;

DESC test1

SELECT
    table_name,
    constraint_name,
    constraint_type,
    status
FROM
    user_constraints
WHERE
    table_name = 'TEST1';

-- c 제약조건 : a > 0 and c > 0
ALTER TABLE test1 DROP COLUMN c;

ALTER TABLE test1 DROP COLUMN a;

ALTER TABLE test1 DROP COLUMN a CASCADE CONSTRAINTS;

desc test1

SELECT
    table_name,
    constraint_name,
    constraint_type,
    status
FROM
    user_constraints
WHERE
    table_name = 'TEST1';

ALTER TABLE test1 DROP COLUMN c;

desc test1

SELECT
    table_name,
    constraint_name,
    constraint_type,
    status
FROM
    user_constraints
WHERE
    table_name = 'TEST1';

DESC test1

-- 칼럼이름 및 제약조건 이름 변경 (create table ... rename column .... to ....)
DESC emp2

ALTER TABLE emp2 RENAME COLUMN employee_id TO empid;

desc emp2

ALTER TABLE emp2 ADD CONSTRAINT emp2_pk PRIMARY KEY ( empid );

SELECT
    table_name,
    constraint_name,
    constraint_type,
    status
FROM
    user_constraints
WHERE
    table_name = 'EMP2';

ALTER TABLE emp2 RENAME CONSTRAINT emp2_pk TO emp2_empid_pk;

SELECT
    table_name,
    constraint_name,
    constraint_type,
    status
FROM
    user_constraints
WHERE
    table_name = 'EMP2';
    
--Clean Test
DROP TABLE emp2 PURGE;

DROP TABLE test1 PURGE;