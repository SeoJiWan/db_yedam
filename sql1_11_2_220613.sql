-- create sequence
-- cache n | nocache 옵션 --> 메모리를 미리 잡아먹느냐 마느냐, cache n --> 메모리를 안쓰고 종료하면 재시작시 메모리길이의 다음꺼부터 시작
-- sequence 는 어떤 테이블꺼다 라는게 없음. -> sharable 
-- nextval : 다음에 쓸 값
-- curval : 최근에 쓴 값
-- sequence 수정 : alter 사용

--시퀀스의 생성
CREATE SEQUENCE dept_deptid_seq INCREMENT BY 10 START WITH 250 MAXVALUE 9999 NOCACHE NOCYCLE;

-- 시퀀스 데이터 딕셔너리 확인
SELECT
    sequence_name,
    increment_by,
    cache_size,
    last_number
FROM
    user_sequences
WHERE
    sequence_name LIKE 'DEPT%';

INSERT INTO departments (
    department_id,
    department_name,
    location_id
) VALUES (
    dept_deptid_seq.NEXTVAL, --> 시퀀스로 department_id 삽입
    'Support',
    2500
);

SELECT
    *
FROM
    departments;

ROLLBACK;

INSERT INTO departments (
    department_id,
    department_name,
    location_id
) VALUES (
    dept_deptid_seq.NEXTVAL, --> 시퀀스는 rollback 해도 이전에 사용한 것 사용안함. --> 260 삽입
    'Support',
    2500
);

SELECT
    *
FROM
    departments;

COMMIT;

--시퀀스 수정
ALTER SEQUENCE dept_deptid_seq INCREMENT BY 20 MAXVALUE 999999 NOCACHE NOCYCLE;

SELECT
    sequence_name,
    increment_by,
    cache_size,
    last_number --> 다음번에 할당할 값
FROM
    user_sequences
WHERE
    sequence_name LIKE 'DEPT%';

DROP SEQUENCE dept_deptid_seq;



-- 인덱스 --> 엄청 많이 쓰임
-- create index empid_ix on emp(id); --> id column 이 index key column
-- row_id : 행의 위치값
-- index 와 row_id 객체 생성
-- index 객체를 비트리검색 --> 성능이 좋음
-- 데이터를 빠르게 검색할 수 있게 도와주는 객체
-- primary key 나 unique 제약조건은 인덱스를 자동생성한다.
-- 자동생성된 인덱스 테이블은 drop, join 등 일반 테이블처럼 못쓴다.

--자동 인덱스 생성
DROP TABLE emp;

CREATE TABLE emp (
    empno    NUMBER(6) PRIMARY KEY,
    ename    VARCHAR2(25) NOT NULL,
    email    VARCHAR2(50)
        CONSTRAINT emp_mail_nn NOT NULL
        CONSTRAINT emp_mail_uk UNIQUE,
    phone_no CHAR(11) NOT NULL,
    job      VARCHAR2(20),
    salary   NUMBER(8) CHECK ( salary > 2000 ),
    deptno   NUMBER(4)
);

--제약조건 관련 딕셔너리 정보 보기
SELECT
    constraint_name,
    constraint_type,
    search_condition
FROM
    user_constraints
WHERE
    table_name = 'EMP';
    
-- primary key, unique 제약조건만 인덱스 생성
SELECT
    table_name,
    index_name
FROM
    user_indexes
WHERE
    table_name = 'EMP';
    
--수동으로 인덱스 생성
CREATE INDEX emp_ename_idx ON
    emp (
        ename
    );

SELECT
    table_name,
    index_name
FROM
    user_indexes
WHERE
    table_name = 'EMP';
    
--인덱스 삭제
DROP INDEX emp_email_uk; --> 자동으로 만들어진 인덱스는 삭제불가

DROP INDEX emp_ename_idx;

SELECT
    table_name,
    index_name
FROM
    user_indexes
WHERE
    table_name = 'EMP';

SELECT
    table_name,
    index_name
FROM
    user_indexes
WHERE
    table_name = 'EMPLOYEES';



-- 동의어
CREATE OR REPLACE VIEW dept_sum_vu (
    name,
    minsal,
    maxsal,
    avgsal
) AS
    SELECT
        d.department_name,
        MIN(e.salary),
        MAX(e.salary),
        trunc(AVG(e.salary))
    FROM
             employees e
        JOIN departments d ON ( e.department_id = d.department_id )
    GROUP BY
        d.department_name;
   
--동의어 생성
SELECT
    *
FROM
    dept_sum_vu;

CREATE SYNONYM d_sum FOR dept_sum_vu;

SELECT
    *
FROM
    d_sum;
    
--동의어 관련 데이터딕셔너리 보기
SELECT
    synonym_name,
    table_owner,
    table_name
FROM
    user_synonyms;
    
--동의어 삭제
DROP SYNONYM d_sum;

-- 테이블 삭제시 Index 객체만 사라짐
DROP TABLE emp;

--테이블 삭제 시 기타 객체들에 대한 정보 확인하기 --> 6/21시험 10번문제
-- table 생성
CREATE TABLE test (
    empno    NUMBER(6) PRIMARY KEY,
    ename    VARCHAR2(25) NOT NULL,
    email    VARCHAR2(50)
        CONSTRAINT emp_mail_nn NOT NULL
        CONSTRAINT emp_mail_uk UNIQUE,
    phone_no CHAR(11) NOT NULL,
    job      VARCHAR2(20),
    salary   NUMBER(8) CHECK ( salary > 2000 ),
    deptno   NUMBER(4)
);
-- 인덱스 생성
CREATE INDEX test_job_ix ON
    test (
        job
    );
-- 시퀀스 생성
CREATE SEQUENCE test_no_seq
                INCREMENT BY 1
                START WITH 301
                NOCACHE
                NOCYCLE;
                CREATE VIEW test_sum_vu
AS
SELECT empno, ename, job, deptno
FROM
test;
-- 동의어 생성
CREATE SYNONYM t FOR test_sum_vu;

SELECT
    table_name,
    index_name
FROM
    user_indexes
WHERE
    table_name = 'TEST';

SELECT
    object_name,
    object_type,
    status
FROM
    user_objects
WHERE
    object_name LIKE 'TEST%'
    OR object_name = 'T';

DROP TABLE test;

SELECT
    table_name,
    index_name
FROM
    user_indexes
WHERE
    table_name = 'TEST';
-- 테이블 삭제시 index 객체만 사라지고 view, synonym 은 남아는 있으나 status = invalid 상태로 되어있음.
SELECT
    object_name,
    object_type,
    status
FROM
    user_objects
WHERE
    object_name LIKE 'TEST%'
    OR object_name = 'T';

DROP SEQUENCE test_no_seq;

DROP VIEW test_sum_vu;

DROP SYNONYM t;
