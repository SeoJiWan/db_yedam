DROP TABLE orders_20 PURGE;

DROP TABLE prod_period PURGE;

DROP TABLE emp5 PURGE;


------------------ DB SYSTEM 시간보기
SELECT
    sysdate,
    systimestamp
FROM
    dual;
--CLIENT 지역시간보기
SELECT
    current_date,
    current_timestamp,
    localtimestamp
FROM
    dual;
    
--세션의 지역 변경 후 시간보기 다시 실습
ALTER SESSION SET time_zone = '-10:00';

SELECT
    sysdate,
    systimestamp
FROM
    dual;

SELECT
    current_date,
    current_timestamp,
    localtimestamp
FROM
    dual;

ALTER SESSION SET time_zone = '+09:00';

--TIMESTAMP 데이터타입 실습
CREATE TABLE orders_20 (
    ord_id        NUMBER(8),
    ord_date      DATE,
    payment_date  TIMESTAMP,
    delivery_date TIMESTAMP WITH TIME ZONE,
    receipt_date  TIMESTAMP WITH LOCAL TIME ZONE
);

INSERT INTO orders_20 VALUES (
    12345678,
    sysdate,
    sysdate + 1 / 24,
    sysdate + 1,
    sysdate + 3
);

COMMIT;

SELECT
    *
FROM
    orders_20;

ALTER SESSION SET time_zone = '-10:00';

SELECT
    current_date,
    current_timestamp,
    localtimestamp
FROM
    dual;

SELECT
    *
FROM
    orders_20;

ALTER SESSION SET time_zone = '+9:00';

ALTER SESSION SET time_zone = '+01:00';

SELECT
    current_date,
    current_timestamp,
    localtimestamp
FROM
    dual;

SELECT
    *
FROM
    orders_20;

ALTER SESSION SET time_zone = '+09:00';

-- 10일 후, 10일 전
SELECT
    sysdate + 10,
    sysdate - 10
FROM
    dual;
-- 10시간 후, 10시간 전
SELECT
    to_char(sysdate +(10 / 24), 'yyyy/mm/dd hh24:mi:ss'),
    to_char((sysdate -(10 / 24)), 'yyyy/mm/dd hh24:mi:ss')
FROM
    dual;
-- 5개월 후
SELECT
    add_months(sysdate, 5)
FROM
    dual;
-- 5년 후
SELECT
    add_months(sysdate, 12 * 5)
FROM
    dual;


--INTERVAL TYPE Test
CREATE TABLE prod_period (
    p_id            NUMBER(2),
    exchange_period INTERVAL DAY TO SECOND, -- ?일, 간격만 저장 (데이터 타입)
    warrant_period  INTERVAL YEAR TO MONTH -- ?달,
);

desc prod_period;

INSERT INTO prod_period VALUES (
    1,
    INTERVAL '15' DAY, -- DAY = '일'
    INTERVAL '3' YEAR -- YEAR = '년'
);

INSERT INTO prod_period VALUES (
    2,
    INTERVAL '7 12:30:00' DAY TO SECOND, -- 7일 12시간 30분
    INTERVAL '10-6' YEAR TO MONTH -- 10년 6개월
);

COMMIT;

SELECT
    *
FROM
    prod_period;

--주문데이터의 교환가능일자 및 보증만료일 조회(수령일기준)
SELECT
    ord_id,
    receipt_date,
    receipt_date + exchange_period,
    receipt_date + warrant_period
FROM
    orders_20,
    prod_period
WHERE
    p_id = 1;

SELECT
    ord_id,
    receipt_date,
    receipt_date + 15,
    add_months(receipt_date, 36)
FROM
    orders_20;

SELECT
    ord_id,
    receipt_date,
    receipt_date + exchange_period,
    receipt_date + warrant_period
FROM
    orders_20,
    prod_period
WHERE
    p_id = 2;



----------------------------------------- 관련함수의 활용 
--실습을 위한 EMP5 테이블 생성 
-- to_yminterval 함수
SELECT
    employee_id,
    last_name,
    hire_date,
    hire_date + to_yminterval('5-0') AS hire_date,
    department_id
FROM
    employees;

CREATE TABLE emp5
    AS
        SELECT
            employee_id,
            last_name,
            hire_date + to_yminterval('5-0') AS hire_date,
            department_id
        FROM
            employees;

SELECT
    *
FROM
    emp5;

--입사일로부터 연도/월/ 추출
-- extract 함수 사용 --> 날짜로 출력   vs   to_char 는 문자형으로 출력
SELECT
    employee_id,
    last_name,
    EXTRACT(YEAR FROM hire_date)
FROM
    emp5;

SELECT
    employee_id,
    last_name,
    EXTRACT(MONTH FROM hire_date)
FROM
    emp5;
    
--day 추출시 날짜 반환
SELECT
    employee_id,
    last_name,
    EXTRACT(DAY FROM hire_date)
FROM
    emp5;
--변환함수 사용과 비교
SELECT
    employee_id,
    last_name,
    to_char(hire_date, 'YYYY')
FROM
    emp5;
--변환함수 사용에서 day로 변환 시 요일 반환
SELECT
    employee_id,
    last_name,
    to_char(hire_date, 'day')
FROM
    emp5;

--TZ_OFFSET 함수로 오프셋 정보보기
SELECT
    tz_offset('Asia/Seoul')
FROM
    dual;

SELECT
    *
FROM
    v$timezone_names
WHERE
    tzname LIKE '%Seoul%';

SELECT
    tz_offset('Asia/Seoul')
FROM
    dual;

SELECT
    *
FROM
    v$timezone_names
WHERE
    tzname LIKE '%Japan%';

SELECT
    tz_offset('Japan')
FROM
    dual;

--EMP5의 hire_date 열의 데이터타입을 timestamp 타입으로 수정
ALTER TABLE emp5 MODIFY
    hire_date TIMESTAMP(0); -- timestamp([정밀도 최대 9까지])

DESC emp5;

SELECT
    *
FROM
    emp5;

--FROM_TZ함수를 사용하여 날짜데이터 옆에 timezone 표시
SELECT
    employee_id,
    last_name,
    from_tz(hire_date, '+09:00') AS hire_date
FROM
    emp5;

--TIMESTAMP 데이터유형관련 변환함수
--TO_TIMESTAMP 함수를 사용하여 문자를 timestamp 타입 데이터로 변환
SELECT
    *
FROM
    emp5
WHERE
    hire_date > to_timestamp('01.01.2000 09:00:00', 'dd.mm.yyyy hh24:mi:ss');
--TO_YMINTERVAL 함수사용으로 주문일로부터 보증기간 구하기
SELECT
    ord_id,
    ord_date,
    ord_date + to_yminterval('3-0')
FROM
    orders_20;
--TO_DSINTERVAL 함수사용으로 주문일로부터 결제가능시간 및 교환가능기간 구하기 --> 3일 (3 00:00:00)
SELECT
    ord_id,
    ord_date,
    to_char(ord_date, 'yyyy/mm/dd hh24:mi:ss'),
    to_char(ord_date + to_dsinterval('0 02:30:00'), 'yyyy/mm/dd hh24:mi:ss') AS 결제가능시간,
    ord_date + to_dsinterval('10 00:00:00')                                  AS 교환가능기간
FROM
    orders_20; 
    
--TO_DSINTERVAL  대신의 방법
SELECT
    ord_id,
    ord_date,
    add_months(ord_date, 36)
FROM
    orders_20;

SELECT
    ord_id,
    to_char(ord_date, 'yyyy/mm/dd hh24:mi:ss'),
    to_char(ord_date + 150 /(24 * 60), 'yyyy/mm/dd hh24:mi:ss') AS 결제가능시간
FROM
    orders_20;  
--Clear Test
DROP TABLE orders_20 PURGE;

DROP TABLE prod_period PURGE;

DROP TABLE emp5 PURGE;