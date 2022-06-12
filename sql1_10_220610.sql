--#DDL
--1. create
--2. drop
--3. truncate
--4. rename
--5. comment

--스키마 : 특정유저가 소유하는 객체 모음
--인사관리는 hr 스키마


/*
< Datatype (Oracle) >
## Small Size Data ##
#숫자
number(p[,s])       -->     ex.) number(6)   ->  999,999
                                 number(8,2) ->  999,999.99
                                 number(2,2) ->  1미만의 수
                                 p 의 최댓값 : 38 (최대 자릿수 38자리)
                                 
#날짜
date : 고정길이       -->     ex.) 22/06/10           ->  2022/06/10 00:00:00
                                 22/06/10 15:08:10  ->  2022/06/10/ 15:05:10
datedtime
--> timestamp
--> timestamp with time zome
--> timestamp with local time zoen
--> interval year to month
--> interval day to second

#문자
char(n) : 최대 2000Byte 까지의 고정길이 문자데이터 타입          -->     ex.) char(10) 에 'oracle'        ->    oracle____ ( oracle(6Byte) + 빈 공간(4Byte))                            
varchar2(n) : 최대 4000Byte 까지의 가변길이 문자데이터 타입      -->     ex.) varchar2(10) 에 'oracle'    ->    oracle ( orcale(6Byte)만 차지 )

#이진
raw(n) : 최대 2000Byte 까지의 이진데이터 타입
   
                                
## Large Size Data (4000Byte 초과 ~ 최대 4GB) ##
#문자
long, clob

#이진
long raw, blob, bfile
*/

desc employees;

SELECT
    employee_id,
    ROWID
FROM
    employees;

-- AAAE5oAAEAAAADNAAA
-- AAAE5o | AAE | AAAADN | AAA --> rowid
-- table | file | block | row

SELECT
    *
FROM
    employees
WHERE
    ROWID = 'AAAE5oAAEAAAADNAAA';

SELECT
    *
FROM
    dept;

SELECT
    deptno,
    dname,
    ROWID
FROM
    dept;


/*
# constraint
not null
unique
primary key ~ 한 테이블에 한 개, not null + unique
foreign key ~ 어떤 primary key 를 참조하는 키 (primary key 를 가진 테이플이 부모테이블)
check

#KEY
아이디, 전화번호, 주소, 주민등록번호 칼럼이 있는데
키가 될만한 칼럼은 뭐가 있을까?                              주민등록번호, 아이디, 전화번호 - 슈퍼키
유일성, 최소성을 만족하는 기본키가 되기위한 후보가 뭐가 있을까?    주민등록번호, 아이디 - 후보키
후보중에서 더 최소성을 만족시키는게 뭐가 있을까?                 아이디 - 기본키
기본키가 못된 후보키?                                      주민등록번호 - 대체키
*/

/*
on delete set null -> 부모가 사라졌는데 자식은 살아남고 null값
on delete set cascate -> 부모가 사라지면 자식도 사라짐, 자식테이블의 해당 fk 행도 삭제
*/


-- 실습
--테이블 생성과 삭제
CREATE TABLE dept (
    deptno NUMBER(2),
    dname  VARCHAR2(14),
    loc    VARCHAR2(13)
);
         
--기본값 테스트
INSERT INTO dept (
    deptno,
    dname
) VALUES (
    10,
    '기획부'
);

INSERT INTO dept VALUES (
    20,
    '영업부',
    '서울'
);

COMMIT;

SELECT
    *
FROM
    dept;

--기본키와 기본값 열을 포함하는 테이블 생성
DROP TABLE dept;

CREATE TABLE dept (
    deptno      NUMBER(2) PRIMARY KEY,
    dname       VARCHAR2(14),
    loc         VARCHAR2(13),
    create_date DATE DEFAULT sysdate
);
                                      
--기본값 테스트
INSERT INTO dept (
    deptno,
    dname
) VALUES (
    10,
    '기획부'
);

INSERT INTO dept VALUES (
    20,
    '영업부',
    '서울',
    '19/03/14'
);

COMMIT;

SELECT
    *
FROM
    dept;

--여러가지 제약조건을 포함하는 테이블 생성
CREATE TABLE emp (
    empno    NUMBER(6) PRIMARY KEY,
    ename    VARCHAR2(25) NOT NULL, --> 이름을 안넣으면 constraint 생략가능
    email    VARCHAR2(50)
        CONSTRAINT emp_mail_nn NOT NULL --> 이름을 넣으려면 constraint
        CONSTRAINT emp_mail_uk UNIQUE,
    phone_no CHAR(11) NOT NULL,
    job      VARCHAR2(20),
    salary   NUMBER(8) CHECK ( salary > 2000 ),
    deptno   NUMBER(4)
        REFERENCES dept ( deptno ) -- foreign key 없어도 됨
);

--제약조건 관련 딕셔너리 정보 보기
SELECT
    constraint_name,
    constraint_type,
    search_condition
FROM
    user_constraints -- 이 사용자가 만든 제약조건을 담은 테이플
WHERE
    table_name = 'EMP';

SELECT
    cc.column_name,
    c.constraint_name,
    c.constraint_type,
    c.search_condition
FROM
         user_constraints c
    JOIN user_cons_columns cc ON ( c.constraint_name = cc.constraint_name )
WHERE
    c.table_name = 'EMP';

SELECT
    table_name,
    index_name
FROM
    user_indexes
WHERE
    table_name IN ( 'DEPT', 'EMP' );
    
--DML을 수행하며 제약조건 테스트하기

desc emp;

INSERT INTO emp VALUES (
    NULL,
    '김수현',
    'shkim@naver.com',
    '01023456789',
    '회사원',
    3500,
    NULL
); --> X

INSERT INTO emp VALUES (
    1234,
    '김수현',
    'shkim@naver.com',
    '01023456789',
    '회사원',
    3500,
    NULL
); --> O

INSERT INTO emp VALUES (
    1223,
    '박나래',
    'nrpark@gmail.com',
    '01054359876',
    NULL,
    1800, --> 급여 2000 이하
    20
); --> X

INSERT INTO emp VALUES (
    1223,
    '박나래',
    'nrpark@gmail.com',
    '01054359876',
    NULL,
    7800,
    20
);

COMMIT;

SELECT
    *
FROM
    emp;

select * from dept;

UPDATE emp
SET
    deptno = 30
WHERE
    empno = 1234;

UPDATE emp
SET
    deptno = 10
WHERE
    empno = 1234;

COMMIT;

DELETE FROM dept
WHERE
    deptno = 10;

SELECT
    *
FROM
    emp;