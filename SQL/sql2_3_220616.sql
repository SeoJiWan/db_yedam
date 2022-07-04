--Metadata (data dictionary) : 자동생성, 데이터의 데이터
--- base table

--- data dictionary view
-- 1. DBA_*		(DBA만 접근, DB전체를 대상)
--  2.   ALL_* 	(현재 사용자가 접근가능한 정보)
--  3.     USER_*	(현재 접속한 사용자가 소유하는 정보)
--  --> 접두어 : 제공하는 범위,  * : 항목
--  --> ex.) DBA_TABLES, ALL_TABLES, USER_TABLES

-- 해당 user_tables 의 주인은 관리자
SELECT
    COUNT(*)
FROM
    user_tables;

SELECT
    COUNT(*)
FROM
    all_tables;

SELECT
    COUNT(*)
FROM
    dba_tables; --> error

CREATE TABLE testemp
    AS
        SELECT
            *
        FROM
            employees;

DROP TABLE testemp PURGE;

--Dictionary View Prefix 구분해보기
--Run SQLCommandLine에서 다음을 실행
conn / as sysdba

SELECT
    COUNT(*)
FROM
    user_tables;

SELECT
    COUNT(*)
FROM
    all_tables;

SELECT
    COUNT(*)
FROM
    dba_tables;

conn hr/hr

SELECT
    COUNT(*)
FROM
    user_tables;

SELECT
    COUNT(*)
FROM
    all_tables;

SELECT
    COUNT(*)
FROM
    dba_tables;

SELECT
    comments
FROM
    dictionary
WHERE
    table_name = 'USER_TABLES';

exit
--SQL Developer 실행 후 인사관리로 접속
--Creating Objects For Test
CREATE TABLE emp3_tab
    AS
        SELECT
            *
        FROM
            employees;

CREATE INDEX emp3_empid_ix ON
    emp3_tab (
        employee_id
    );

CREATE VIEW emp3_list_vu AS
    SELECT
        employee_id,
        last_name,
        department_id
    FROM
        emp3_tab
    WHERE
        department_id NOT IN ( 10, 90 );

CREATE SYNONYM emp3 FOR emp3_list_vu;

create sequence emp3_seq
increment by 1
start with 250
nocache
nocycle;

--Dictionary로 부터 사용자 소유 Object 관련 정보 탐색하기
SELECT
    view_name,
    text
FROM
    user_views
WHERE
    view_name LIKE 'EMP3%';

SELECT
    synonym_name,
    table_owner,
    table_name
FROM
    user_synonyms
WHERE
    synonym_name = 'EMP3';

SELECT
    sequence_name,
    increment_by,
    max_value,
    cache_size
FROM
    user_sequences
WHERE
    sequence_name LIKE 'EMP3%';

SELECT
    index_name,
    status
FROM
    user_indexes
WHERE
    index_name LIKE 'EMP3%';

SELECT
    object_name,
    object_type,
    status
FROM
    user_objects
WHERE
    object_name LIKE 'EMP3%';
    
--Table 삭제 후 연관객체의 상태 알아보기
DROP TABLE emp3_tab;

SELECT
    index_name,
    status
FROM
    user_indexes
WHERE
    index_name LIKE 'EMP3%';

SELECT
    object_name,
    object_type,
    status
FROM
    user_objects
WHERE
    object_name LIKE 'EMP3%';
    
--Clear Test
DROP VIEW emp3_list_vu;

DROP SYNONYM emp3;

DROP SEQUENCE emp3_seq;