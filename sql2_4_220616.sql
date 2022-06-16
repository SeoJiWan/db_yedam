--인라인뷰 : from 절에 쓰는 서브쿼리

--default 값 지정안하고 insert default 하면 null 값 삽입

--multi table insert : insert ... into ... values ...
--		         into ... values ...
--		         into ... values ...
--		         select ... from ... where ...
--> 한번 select문 한것을 여러테이블에 삽입


-- @ : 스크립트 실행 명령문
@c:\db_test\sql_labs\cre_minstab.sql 

UPDATE employees
SET
    salary = 10500
WHERE
    employee_id = 206;

COMMIT;

SELECT
    *
FROM
    tab;


-- Subquery의 다양한 활용법
SELECT
    l.location_id,
    l.city,
    l.country_id,
    c.region_id,
    r.region_name
FROM
         locations l
    JOIN countries c ON ( l.country_id = c.country_id )
    JOIN regions   r ON ( c.region_id = r.region_id )
WHERE
    region_name = 'Europe';
------------------------------
-- using 절은 공통 칼럼으로 조인 --> 칼럼을 구분 (c.region_id 이런식으로) 해주면 에러 발생
SELECT
    l.location_id,
    l.city,
    l.country_id,
    c.region_id
FROM
         locations l
    JOIN countries c ON ( l.country_id = c.country_id )
    JOIN regions USING ( region_id )
WHERE
    region_name = 'Europe';

SELECT
    *
FROM
    locations;

SELECT
    *
FROM
    countries;

SELECT
    *
FROM
    regions;

desc countries;

SELECT
    department_name,
    city
FROM
         departments
    NATURAL JOIN (
        SELECT
            l.location_id,
            l.city,
            l.country_id
        FROM
                 locations l
            JOIN countries c ON ( l.country_id = c.country_id )
            JOIN regions USING ( region_id )
        WHERE
            region_name = 'Europe'
    );

SELECT
    *
FROM
    departments;

INSERT INTO (
    SELECT
        l.location_id,
        l.city,
        l.country_id
    FROM
             locations l
        JOIN countries c ON ( l.country_id = c.country_id )
        JOIN regions USING ( region_id )
    WHERE
        region_name = 'Europe'
) VALUES (
    3300,
    'Cradiff',
    'UK'
);

SELECT
    *
FROM
    locations;

desc locations;
    
--명시적 DEFAULT 값 기능
DROP TABLE dept3 PURGE;

CREATE TABLE dept3
    AS
        SELECT
            *
        FROM
            departments;
            
--DEPT3 테이블의 manager_id 열에 기본값정의
ALTER TABLE dept3 MODIFY
    manager_id DEFAULT '9999';

SELECT
    *
FROM
    dept3;
    
--DML 작업시 DEFAULT 값 사용하기
INSERT INTO dept3 (
    department_id,
    department_name,
    manager_id
) VALUES (
    300,
    'Engneering', DEFAULT
);

UPDATE dept3
SET
    manager_id = DEFAULT
WHERE
    department_id = 10;

SELECT
    *
FROM
    dept3;

COMMIT;

--Subquery를 사용한 INSERT 복습
DROP TABLE sales_reps PURGE;

CREATE TABLE sales_reps
    AS
        SELECT
            employee_id,
            last_name,
            salary,
            commission_pct
        FROM
            employees
        WHERE
            1 = 2;

SELECT
    *
FROM
    sales_reps;

INSERT INTO sales_reps
    SELECT
        employee_id,
        last_name,
        salary,
        commission_pct
    FROM
        employees
    WHERE
        job_id LIKE '%REP%';
        


-- Unconditional Insert Test (조건이 없다)
SELECT
    employee_id empid,
    hire_date   hiredate,
    salary      sal,
    manager_id  mgr
FROM
    employees
WHERE
    employee_id > 200;

INSERT ALL 
INTO sal_history VALUES (
    empid,
    hiredate,
    sal
) INTO mgr_history VALUES (
    empid,
    mgr,
    sal
) SELECT
      employee_id empid,
      hire_date   hiredate,
      salary      sal,
      manager_id  mgr
  FROM
      employees
  WHERE
      employee_id > 200;

SELECT
    *
FROM
    sal_history;

SELECT
    *
FROM
    mgr_history;

ROLLBACK;

--조건 ALL INSERT
INSERT
    ALL WHEN sal > 10000 THEN -- 이 조건 만족시 해당 행 실행
        INTO sal_history
        VALUES (
            empid,
            hiredate,
            sal
        )
        WHEN mgr > 200 THEN -- 이 조건 만족시 해당 행 실행
            INTO mgr_history
            VALUES (
                empid,
                mgr,
                sal
            )
SELECT
    employee_id empid,
    hire_date   hiredate,
    salary      sal,
    manager_id  mgr
FROM
    employees
WHERE
    employee_id > 200;

SELECT
    *
FROM
    sal_history;

SELECT
    *
FROM
    mgr_history;

COMMIT;

--조건 FIRST INSERT
SELECT
    department_id  deptid,
    SUM(salary)    sal,
    MAX(hire_date) hiredate
FROM
    employees
GROUP BY
    department_id;

INSERT
    FIRST WHEN sal > 25000 THEN -- first : 첫번째 조건을 만족하는 행은 첫번째 테이블에만 삽입, 두번째부터는 insert all 하고 똑같이 동작
        INTO special_sal
        VALUES (
            deptid,
            sal
        )
        WHEN hiredate LIKE ( '10%' ) THEN -- hiredate 가 10으로 시작하는 것이 있지만 first 조건으로 들어가버려서 아무행도 안들어감
            INTO hiredate_history_10
            VALUES (
                deptid,
                hiredate
            )
        WHEN hiredate LIKE ( '09%' ) THEN
            INTO hiredate_history_09
            VALUES (
                deptid,
                hiredate
            )
    ELSE
        INTO hiredate_history
    VALUES (
        deptid,
        hiredate
    )
SELECT
    department_id  deptid,
    SUM(salary)    sal,
    MAX(hire_date) hiredate
FROM
    employees
GROUP BY
    department_id;

SELECT
    *
FROM
    special_sal;

SELECT
    *
FROM
    hiredate_history_10;

SELECT
    *
FROM
    hiredate_history_09;

SELECT
    *
FROM
    hiredate_history;

COMMIT;

---------------------------------피벗 INSERT
DESC sales_source_data

-- 성질이 같은 컬럼의 경우 테이블을 만들어 행으로 정리한다.
SELECT
    *
FROM
    sales_source_data;

--피벗구조의 새로운 테이블 생성
CREATE TABLE sales_data (
    sales_no    NUMBER(8),
    employee_id NUMBER(6),
    week_id     NUMBER(2),
    sales       NUMBER(8, 2)
);

select * from sales_data;

--피벗 INSERT 실행하기
INSERT ALL INTO sales_data VALUES (
    1,
    employee_id,
    week_id,
    sales_mon
) INTO sales_data VALUES (
    1,
    employee_id,
    week_id,
    sales_tue
) INTO sales_data VALUES (
    1,
    employee_id,
    week_id,
    sales_wed
) INTO sales_data VALUES (
    1,
    employee_id,
    week_id,
    sales_thur
) INTO sales_data VALUES (
    1,
    employee_id,
    week_id,
    sales_fri
) SELECT
      employee_id,
      week_id,
      sales_mon,
      sales_tue,
      sales_wed,
      sales_thur,
      sales_fri
  FROM
      sales_source_data;

SELECT
    *
FROM
    sales_source_data;
    
SELECT
    *
FROM
    sales_data;

--시퀀스생성 및 sales 번호(sales_no) 변경
CREATE SEQUENCE sales_data_seq
START WITH 101
INCREMENT BY 1
NOCACHE
NOCYCLE;

UPDATE sales_data
SET sales_no = sales_data_seq.nextval;

commit;

SELECT * FROM sales_data;

--정규화가 완료된 테이블 활용
SELECT employee_id, SUM(sales) FROM sales_data
WHERE week_id = 6
GROUP BY employee_id
ORDER by 1;

COMMIT;

-----------------------------------  MERGE 문 테스트
--실습을 위한 emp13 테이블 생성
@c:\db_test\sql_labs\cre_emp13.sql 
--정보확인(4명의 사원, 200번 부서, commission_pct가 모두 0.4)
SELECT * FROM emp13;

SELECT * FROM employees;

SELECT employee_id, commission_pct, department_id
FROM employees
WHERE employee_id IN (200,149,174, 176);

--MERGE 문 실행
MERGE INTO emp13 c -- 대상 테이블
     USING employees e 
     ON (c.employee_id = e.employee_id) -- 중복 행 식별
     WHEN MATCHED THEN -- 동일한 행이 있으면 (emp13의 4명)
     UPDATE SET
       c.last_name      = e.last_name, -- c.last_name 을 e.last_name으로 대체
       c.job_id         = e.job_id,
       c.salary         = e.salary,
       c.department_id  = e.department_id
      DELETE WHERE (e.commission_pct IS NULL) --employees에서 commission_pct가 null인 행은 제외됨
   WHEN NOT MATCHED THEN -- 동일한 행 없으면
     INSERT VALUES(e.employee_id, e.last_name,e.job_id, -- emp13 에 values(...) 삽입
          e.salary, e.commission_pct, e.department_id);
COMMIT;
SELECT * FROM emp13;

------------------------------------------------ Flashback 기술 TEST
--실습 전 Flashback Transaction Query를 위한 환경설정
--Run SQL CommandLine 실행
conn / as sysdba

-- flashback 사용 위한 설정 (관리자로 접속)
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA ( PRIMARY KEY ) COLUMNS;
GRANT EXECUTE ON dbms_flashback TO hr;
GRANT SELECT ANY TRANSACTION TO hr;

--Flashback Query Test (뭘 빠르게 되돌린다?)
-- DML --> commit 전 : rollback --> undo data가 있기 때문에 가능
       --> commit 후 : flashback 
       
-- flashback query : undo data 제공, 시간을 콕 집어서 확인       |
-- flashback verions : undo data 제공      | --> 3분전으로 되돌려
-- flashback transaction : undo data 제공  |
-- flashback table : 유료버전

-- flashback query
------ as of times 구문 활용
SELECT
    salary
FROM
    employees
WHERE
    employee_id = 178;

UPDATE employees
SET
    salary = 12000
WHERE
    employee_id = 178; --> 7700 은 undo data

COMMIT;

SELECT
    salary
FROM
    employees
WHERE
    employee_id = 178;

SELECT
    salary
FROM
    employees AS OF TIMESTAMP sysdate - 5 / ( 24 * 60 )
WHERE
    employee_id = 178;

UPDATE employees
SET
    salary = (
        SELECT
            salary
        FROM
            employees AS OF TIMESTAMP sysdate - 5 / ( 24 * 60 )
        WHERE
            employee_id = 178
    )
WHERE
    employee_id = 178;

SELECT
    salary
FROM
    employees
WHERE
    employee_id = 178;

COMMIT;

--Flashback Versions Query Test
-- from 테이블명 VERSIONS BETWEEN TIMESTAMP MINVALUE AND MAXVALUE 구문 용
UPDATE employees
SET
    salary = 10000
WHERE
    employee_id = 178;

COMMIT;

SELECT
    salary
FROM
    employees
WHERE
    employee_id = 178;

SELECT
    versions_starttime,
    versions_endtime,
    salary,
    versions_xid
FROM
    employees VERSIONS BETWEEN TIMESTAMP MINVALUE AND MAXVALUE
WHERE
    employee_id = 178;

--Flashback Transaction Query
--Flashback Versions Query 결과의 급여 7000의 versions_xid 값 복사 --> 12000 으로 돌아가고 싶으면 12000 후의 트랜잭션을 언두
--예시 0A001B004C020000
SELECT
    undo_sql
FROM
    flashback_transaction_query
WHERE
    xid = '06001F00BE010000';
    
--조회결과의 undo_sql 문장을 복사에서 실행 후 복원된 값 확인
--예시
UPDATE "HR"."EMPLOYEES"
SET
    "SALARY" = '7000'
WHERE
    ROWID = 'AAAE/TAAEAAAAGWABO';

update "HR"."EMPLOYEES" set "SALARY" = '12000' where ROWID = 'AAAE5oAAEAAAADNABO';

SELECT
    salary
FROM
    employees
WHERE
    employee_id = 178;

COMMIT;

SELECT
    versions_starttime,
    versions_endtime,
    salary,
    versions_xid
FROM
    employees VERSIONS BETWEEN TIMESTAMP MINVALUE AND MAXVALUE
WHERE
    employee_id = 178;