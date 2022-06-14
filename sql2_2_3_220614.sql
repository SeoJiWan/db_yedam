--Create Index with the Create Table statement
DROP TABLE emp2 PURGE; -- 영구삭제

CREATE TABLE emp2 (
    empid         NUMBER(6) PRIMARY KEY,
    empname       VARCHAR2(30),
    salary        NUMBER(6),
    department_id NUMBER(3)
);

SELECT
    table_name,
    constraint_name,
    constraint_type,
    status
FROM
    user_constraints
WHERE
    table_name = 'EMP2';

SELECT
    table_name,
    index_name
FROM
    user_indexes
WHERE
    table_name = 'EMP2';

ALTER TABLE emp2 DISABLE PRIMARY KEY;

SELECT
    table_name,
    constraint_name,
    constraint_type,
    status
FROM
    user_constraints
WHERE
    table_name = 'EMP2';

SELECT
    table_name,
    index_name
FROM
    user_indexes
WHERE
    table_name = 'EMP2';

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

SELECT
    table_name,
    index_name
FROM
    user_indexes
WHERE
    table_name = 'EMP2';

DROP TABLE emp2 PURGE;

CREATE TABLE emp2 (
    empid         NUMBER(6)
        PRIMARY KEY
            USING INDEX ( -- 수동으로 이름을 정해서 인덱스 생성
                CREATE INDEX emp2_empid_idx ON
                    emp2 (
                        empid
                    )
            ),
    empname       VARCHAR2(30),
    salary        NUMBER(6),
    department_id NUMBER(3)
);

SELECT
    table_name,
    constraint_name,
    constraint_type,
    status
FROM
    user_constraints
WHERE
    table_name = 'EMP2';

SELECT
    table_name,
    index_name
FROM
    user_indexes
WHERE
    table_name = 'EMP2';

ALTER TABLE emp2 DISABLE PRIMARY KEY;

SELECT
    table_name,
    constraint_name,
    constraint_type,
    status
FROM
    user_constraints
WHERE
    table_name = 'EMP2';

-- 수동으로 제약조건 생성하고 인덱스 비활성화 해도 인덱스 살아있음.
SELECT
    table_name,
    index_name
FROM
    user_indexes
WHERE
    table_name = 'EMP2';

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

SELECT
    table_name,
    index_name
FROM
    user_indexes
WHERE
    table_name = 'EMP2';
    
--Function Based Indexes
CREATE INDEX emp_sal_ix ON
    employees (
        salary
    );
-- index 사용 모니터링
ALTER INDEX emp_sal_ix MONITORING USAGE;

SELECT
    *
FROM
    employees
WHERE
    salary * 12 > 80000;

SELECT
    *
FROM
    v$object_usage;

DROP INDEX emp_sal_ix;

-- 함수 기반 인덱스 -> 칼럼자리에 식
CREATE INDEX emp_annsal_ix ON
    employees ( salary * 12 );

ALTER INDEX emp_annsal_ix MONITORING USAGE;

SELECT
    *
FROM
    employees
WHERE
    salary * 12 > 80000;

SELECT
    *
FROM
    v$object_usage;
    
--Clear Test
DROP INDEX emp_annsal_ix;

--Drop Table with Recyclebin
show recyclebin; -- 휴지통에 있는것 보기

-- 객체 : 테이블, 인덱스, 뷰, 시노님, 시퀀스 --> 테이블 삭제 시 인덱스 같이 삭제

-- 휴지통 비우기
PURGE RECYCLEBIN;

show recyclebin;

-- 테이블 삭제시 인덱스도 삭제
DROP TABLE emp2;

desc emp2

SELECT
    *
FROM
    emp2;

show recyclebin;

-- 휴지통에 있는 것 복구 --> drop table 만 가능, alter, truncate 는 flashback 안됨
FLASHBACK TABLE emp2 TO BEFORE DROP;

desc emp2

SELECT
    *
FROM
    emp2;

show recyclebin;

-- 휴지통으로 안가고 영구삭제
DROP TABLE emp2 PURGE;

show recyclebin;

-- 영구삭제하여 flashback 안됨
FLASHBACK TABLE emp2 TO BEFORE DROP;

show recyclebin;


-- 연습
create table test (id number(5) primary key,
                   name varchar(10) unique,
                   address varchar(20));

create index add_idx on test (address);

select table_name, index_name 
from user_indexes
where table_name = 'TEST';

SELECT
    table_name,
    constraint_name,
    constraint_type,
    status
FROM
    user_constraints
WHERE
    table_name = 'TEST';

drop table test;

drop table test purge;

show recyclebin;

FLASHBACK TABLE test TO BEFORE DROP;