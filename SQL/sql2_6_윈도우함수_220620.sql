-- TOP-n 쿼리
-- rownum -> 가상열
select rownum as rank, employee_id, last_name, salary
from (select employee_id, last_name, salary
      from employees
      order by salary desc)
where rownum <= 5;      

select rownum as rank, employee_id, last_name, salary
from (select employee_id, last_name, salary
      from employees
      order by salary)
where rownum <= 5;      


-- # window 함수 이점 : 일반컬럼과 그룹함수 컬럼을 같이 볼 수 있다.
--                    group by 절은 일반컬럼 같이 못봄.
--------------------------------------------------------------
-- 그룹 내 순위(RANK) 관련 함수
-- RANK
-- - 순위를 구하는 함수.
-- - 특정 범위(PARTITION) 내에서 순위를 구할 수도 있고, 전체 데이터에 대한 순위를 구할 수도 있다. 
-- - 동일한 값에 대해서는 동일한 순위를 부여하게 된다. 

--사원 데이터에서 급여가 높은 순서를 출력하는 예제
SELECT job_id, last_name, salary, RANK() OVER (ORDER BY salary DESC) ALL_RANK    
FROM     employees ;  
--동일한 급여가 있다면 같은 순위를 부여한다. -> 동률이 있으면 다음 랭크는 동률 수만큼 건너뜀

--사원 데이터에서  업무별로 급여가 높은 순서를 출력하는 예제
SELECT job_id, last_name, salary,RANK() OVER (PARTITION BY job_id ORDER BY salary DESC) JOB_RANK -- job_id 별로 급여 높은 순
FROM     employees ;    
--동일한 급여가 있다면 같은 순위를 부여한다. 
--PARTITION 으로 구분한 JOB_RANK 는 같은 업무 범위 내에서만 순위를 부여한다. 

SELECT department_id, last_name, salary,RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) JOB_RANK 
FROM     employees ;    

SELECT department_id, hire_date, last_name, RANK() OVER (PARTITION BY department_id ORDER BY hire_date) JOB_RANK 
FROM     employees ;    


-- DENSE_RANK
-- RANK와 흡사하지만, 동일한 순위를 하나의 건수로 취급한다. 
-- RANK는 1, 1, 3 순위(1위가 두개 이니 2위 없이 3위 표시) 로 표기하지만, DENSE_RANK는1,1,2  순위를 부여한다. 

SELECT  job_id, last_name, salary,
         RANK()       OVER (ORDER BY salary DESC) ALL_RANK,  
         DENSE_RANK() OVER (ORDER BY salary DESC) DENSE_RANK 
FROM     employees ;          
 
-- ROW_NUMBER
-- RANK, DENSE_RANK 가 동일한 값에 대해서는 동일한 순위를 부여하는데 반해, 
-- ROW_NUMBER 는 동일한 값이라도 고유한 순위를 부여한다. 

SELECT  job_id, last_name, salary,
         RANK()       OVER (ORDER BY salary DESC) ALL_RANK,  
         ROW_NUMBER() OVER (ORDER BY salary DESC) ROW_NUMBER
FROM     employees ;          
--ROW_NUMBER 는 동일한 순위를 배제하기 위해 유니크한 순위를 정한다. 
--동일한 순위에 대해서는 어떤 순서가 정해질지 알 수 없다. (Oracle의 경우 rowid가 적은 행이 먼저 나온다) 이 부분은 데이터베이스 별로 틀린 결과가 나올 수 있으므로, 만일 동일 값에 대한 순서까지 관리하고 싶으면 ROW_NUMBER( ) OVER (ORDER BY salary DESC, last_name) 같이 ORDER BY 절을 이용해 추가적인 정렬 기준을 정의해야 한다.

-- 추가 정렬 기준 정의 예제 
SELECT  job_id, last_name, salary,
         RANK()       OVER (ORDER BY salary DESC) ALL_RANK,  
          ROW_NUMBER( ) OVER (ORDER BY salary DESC, last_name)  ROW_NUMBER
FROM     employees ;  

SELECT  job_id, last_name, salary,
         RANK()       OVER (ORDER BY salary DESC) ALL_RANK,  
          ROW_NUMBER( ) OVER (ORDER BY salary DESC, last_name DESC)  ROW_NUMBER
FROM     employees ;  




------------------------------------------------------------------------------------------------------------------------
-- 그룹 내 집계(AGGREGATE) 관련 함수

-- SUM
-- - SUM 함수를 이용해서 파티션별 윈도우의 합을 구할 수 있다. 
-- - 같은 매니저를 두고 있는 사원들의 급여 합을 구하는 예제

SELECT manager_id, employee_id, last_name, salary, 
       SUM(salary) OVER (PARTITION BY manager_id) MGR_SUM
FROM   employees ;

--OVER 절에 ORDER BY 절을 추가해서 파티션 내 데이터를 정렬하고 이전 급여 데이터까지의 누적값을 출력하는 예제

SELECT manager_id, 
       employee_id, last_name, 
       salary, 
       SUM(salary) OVER (PARTITION BY manager_id ORDER BY salary RANGE UNBOUNDED PRECEDING) MGR_SUM
FROM   employees ;

--RANGE UNBOUNDED PRECEDING ;
-- 현재 행을 기준으로 파티션 내의 첫 번째 행까지 범위를 지정한다. --> 누적 합계
 


-- MAX
-- - 파티션별 윈도우의 최대값을 구할 수 있다. 
-- - 같은 매니저를 두고 있는 사원들의 급여 중 최대값을 구하는 예제

SELECT manager_id, last_name, salary, 
       MAX(salary) OVER (PARTITION BY manager_id) MGR_MAX
FROM   employees ;

--같은 부서내 사원들의 급여 중 최대값을 구하는 문제 
SELECT department_id, last_name, salary, 
       MAX(salary) OVER (PARTITION BY department_id) MGR_MAX
FROM   employees ;


--INLINE VIEW를 이용해서 파티션별 최대값을 가진 행만 추출할 수도 있다.

SELECT manager_id, last_name, salary
FROM   (SELECT manager_id, last_name, salary, 
               MAX(salary) OVER (PARTITION BY manager_id) IV_MAX_SAL
        FROM   employees )
WHERE  salary =  IV_MAX_SAL ;

SELECT department_id, employee_id, last_name, salary
FROM   (SELECT department_id, last_name, salary, employee_id,
               MAX(salary) OVER (PARTITION BY department_id) IV_MAX_SAL
        FROM   employees )
WHERE  salary =  IV_MAX_SAL ;
 

-- MIN
-- -파티션별 윈도우의 최소값을 구할 수 있다. 

--같은 부서에서 근무하는 사원들의  급여 최소값을 같이 구하는 예제

SELECT department_id, last_name, hire_date, salary, 
       MIN(salary) OVER (PARTITION BY department_id) DEPT_MIN
FROM   employees ;
 

-- AVG
-- -소속부서의 평균을 각 사원의 급여와 함께 표시할 수 있다.
SELECT department_id, last_name, hire_date, salary, 
       TRUNC(AVG(salary) OVER (PARTITION BY department_id)) DEPT_MIN
FROM   employees ;

-AVG 함수를 활용하여 파티션별 통계값을 구할 수 있다.
 
--같은 부서에서 근무하는 사원들의 평균 급여를 구하되, 같은 부서 내에서 자기 바로 앞의 사번과 바로 뒤의 사번인 직원을 대상으로만 하는 예제 ( 앞 줄 + 현재행 + 뒷 줄의 합을 3으로 나누는 형식. 만약 앞줄이 없다면 현재행 + 뒷 줄의 합을 2로 나누게 된다)

SELECT department_id, last_name, hire_date, salary, 
       ROUND (AVG(salary) OVER (PARTITION BY department_id ORDER BY hire_date
       ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) ) DEPT_AVG
FROM   employees ;
 

 
COUNT

--사원들을 급여 기준으로 정렬하고, 본인 급여보다 50 이하 적거나, 100 이하로 많은 급여를 받는 인원수를 출력하는 예제

SELECT last_name, salary,
       COUNT(*) OVER (ORDER BY salary RANGE BETWEEN 50 PRECEDING AND 100 FOLLOWING) SIM_CNT
FROM   employees ;

--RANGE BETWEEN 50 PRECEDING AND 100 FOLLOWING ;
-- 현재 행의 급여값을 기준으로 금여가 -50 ~ +100 범위 내에 포함된 모든 행이 대상이 된다. 
-- range는 현재 행의 데이터 값을 기준으로 앞 뒤 데이터 값의 범위를 표시하는 것임.



여기부터 복습 시작~
----------------------------------------------------------------------------------------------------------------------------------------------
-- 그룹 내 행 순서 관련 함수
-- FIRST_VALUE
-- -파티션별 윈도우에서 가장 먼저 나온 값을 구할 수 있다.
-- -sql server 에서는 지원하지 않음.

--부서별 직원들을 연봉이 높은 순서부터 정렬하고, 파티션 내에서 가장 먼저 나온 값을 출력하는 예제

SELECT  department_id, last_name, salary,
        FIRST_VALUE(last_name) OVER (PARTITION BY department_id ORDER BY salary DESC
        ROWS UNBOUNDED PRECEDING) DEPT_RICH
FROM    employees ; 

--부서별 직원들을 연봉이 낮은 순서부터 정렬하고, 파티션 내에서 가장 먼저 나온 값을 출력하는 예제
SELECT  department_id, last_name, salary,
        FIRST_VALUE(last_name) OVER (PARTITION BY department_id ORDER BY salary 
        ROWS UNBOUNDED PRECEDING) DEPT_POOR
FROM    employees ; 

--같은 급여를 받는 사람이 있다면 정렬을 지정해야 한다. 
--FIRST_VALUE 는 공동 등수를 인정하지 않고 처음 나온 행을 처리하기 때문이다. 
--정렬을 추가한 예제. 같은 급여가 있다면 이름 내림차순으로 나오게 된다.

SELECT  department_id, last_name, salary,
        FIRST_VALUE(last_name) OVER (PARTITION BY department_id ORDER BY salary , last_name DESC
        ROWS UNBOUNDED PRECEDING) DEPT_POOR
FROM    employees ; 
 
-- LAST_VALUE
-- -파티션별 윈도우에서 가장 먼저 나중에 나온 값을 구할 수 있다.
-- -sql server 에서는 지원하지 않음.

--부서별 직원들을 연봉이 높은 순서부터 정렬하고, 파티션 내에서 가장 먼저 나중에 나온 값을 출력하는 예제

SELECT  department_id, last_name, salary,
        LAST_VALUE(last_name) OVER (PARTITION BY department_id ORDER BY salary DESC
        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) DEPT_POOR
FROM    employees ; 

--ROW BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
-- 현재 행을 포함해서 파티션 내의 마지막 행까지의 범위를 지정한다. 

SELECT  department_id, last_name, salary,
        LAST_VALUE(last_name) OVER (PARTITION BY department_id ORDER BY salary 
        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) DEPT_RICH
FROM    employees ; 


-- LAG
-- -파티션별 윈도우에서 이전 몇 번째 행의 값을 가져올 수 있다. --> LAG(칼럼, 이전 행, null 대채값)
-- -sql server 에서는 지원하지 않음.

--직원들을 입사일자가 빠른 기준으로 정렬하고, 본인보다 입사일자가 한 명 앞선 사원의 급여를 본인의 급여와 함께 출력하는 예제

SELECT  last_name, hire_date, salary, 
        LAG(salary) OVER (ORDER BY hire_date) as PREV_SAL
FROM    employees 
WHERE   job_id LIKE 'SA%' ;

--PARTITON BY 절을 추가한 예제
SELECT department_id,  last_name, hire_date, salary, 
        LAG(salary) OVER (PARTITION BY department_id ORDER BY hire_date) PREV_SAL
FROM    employees ;

--LAG 함수는 3개의 인수까지 사용할 수 있다. 
--LAG(SALARY, 2, 0) <-- 두 번째 인수는 몇 번째 앞의 행을 가져올지 결정하는 것이고 (디폴트는 1. 여기서는 2을 지정했으니까 2번째 앞에 있는 행을 가져오는 것), 세번째 인수는 파티셧 첫 번째 행의 경우 가져올 데이터가 없어 NULL 값이 들어오는데, 이 경우 다른 값으로 바꾸어줄 수 있다.(NVL과 유사)

SELECT  last_name, hire_date, salary,
        LAG(salary,2,0) OVER (ORDER BY hire_date) PREV_SAL
FROM    employees
WHERE   job_id LIKE  'SA%' ; 
-- LAG(SAL,2,0) : 두 행 앞의 급여를 가져오고, 가져올 값이 없으면 0으로 처리하라.

--부서가 같은 사원들을 입사일별로 정렬한 후 이전 행의 급여와 함께 표시, 이전행이 없으면 0으로 표시
SELECT department_id,  last_name, hire_date, salary,
        LAG(salary,1,0) OVER (PARTITION BY department_id ORDER BY hire_date) PREV_SAL
FROM    employees ;

-- LEAD
-- -파티션별 윈도우에서 이후 몇 번째 행의 값을 가져올 수 있다. 
-- -sql server 에서는 지원하지 않음.

--직원들을 입사일자가 빠른 기준으로 정렬하고, 바로 다음에 입사한 인력의 입사일자를 함께 출력하는 예제

SELECT  last_name, hire_date,
        LEAD(hire_date) OVER (ORDER BY hire_date) NEXTHIRED
FROM    employees ;
--LAG 처럼 LEAD 함수도 3개의 인수까지 사용할 수 있다. 
SELECT department_id, last_name, hire_date,
        LEAD(hire_date) OVER (PARTITION BY department_id ORDER BY hire_date) NEXTHIRED
FROM    employees ;

SELECT department_id, last_name, hire_date,
        LEAD(hire_date, 1, sysdate) OVER (PARTITION BY department_id ORDER BY hire_date) NEXTHIRED
FROM    employees ;




----------------------------------------------------------------------------------------------------------------------------------------------
-- 그룹 내 비율 관련 함수

-- CUME_DIST
-- -파티션별 윈도우의 전체건수에서 현재 행보다 작거나 같은 건수에 대한 누적백분율을 구한다. 
-- -sql server 에서는 지원하지 않음.

--같은 부서 소속 사원들의 집합에서 본인의 급여가 누적 순서상 몇 번재 위치쯤에 있는지 0~1 사이의 값으로 출력하는 예제

SELECT  department_id, last_name, salary,
        CUME_DIST() OVER (PARTITION BY department_id ORDER BY salary DESC) CUME_DIST
FROM    employees ;

--전체 사원 중에서 본인의 급여가 누적 순서상 몇 번재 위치쯤에 있는지 0~1 사이의 값으로 출력하는 예제 (상위 몇 프로?)
SELECT  department_id, last_name, salary,
        CUME_DIST() OVER ( ORDER BY salary DESC) CUME_DIST
FROM    employees ;

 
-- PERCENT_RANK
-- -파티션별 함수를 이용해서 파티션별 윈도우에서 제일 먼저 나오는 것을 0으로, 제일 늦게 나오는 것을 1로 하여, 행의 순서별 백분율을 구한다. (값이 아니라 행의 순서별 백분율)
-- -sql server 에서는 지원하지 않음.

--같은 부서 소속 사원들의 집합에서 본인의 급여가 순서상 몇 번째 위치해 있는지 0과 1 사이의 값으로 출력하는 예제

SELECT  department_id, last_name, salary,
        PERCENT_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) P_R
FROM    employees;

--department_id 80의 경우 3건 이므로 구간을 2가 된다. 
--0과 1 사이를 2개의 구간으로 나누면 0, 0.5, 1이 된다. 
--department_id 50의 경우 5건 이고, 구간은 4.
--0과 1 사이를 4개 구간으로 나누면 0, 0.25, 0.5, 0.75, 1이 된다. 



-- NTILE
-- -파티션별 전체 건수를 ARGUMENT 값으로 N등분한 결과를 구할 수 있다. 

-- -전체 사원을 급여가 높은 순서로 정렬하고, 급여를 기준으로 4개 그룹으로 분류한다. 

SELECT  last_name, salary,
        NTILE(4) OVER (ORDER BY salary DESC) QUAR_TILE
FROM    employees ;

--NTILE(4) 의 의미는 전체 팀원을 4개 조로 나눈다는 의미이다. 
--예를 들어 22명을 4개의 집합으로 나누면 몫이 5, 나머지가 2가 된다. 
--나머지 두 명의 앞의 조부터 할당된다. 


-- RATIO_TO_REPORT 
-- -파티션 내 전체 SUM(컬럼) 값에 대한 행별 컬럼 값의 백분율을 소수점으로 구할 수 있다. 
-- -결과값은 0보다 크고 1이하 의 범위를 가진다. 
-- -개별 ratio 의 합을 구하면 1이 된다. 
-- -sql server 에서는 지원하지 않음.

--세일즈맨 대상으로, 전체 급여에서 본인이 차지하는 비율을 구하는 예제
SELECT  last_name, salary,
        ROUND (RATIO_TO_REPORT(salary) OVER (), 2) P_R
FROM    employees
WHERE   job_id LIKE  'SA%' ;

--전체 사원을 대상으로, 전체 급여에서 본인이 차지하는 비율을 구하는 예제
SELECT  last_name, salary,
        ROUND (RATIO_TO_REPORT(salary) OVER (), 2) P_R
FROM    employees;

