select * from employees
where first_name like 'St%'
and first_name like '%en';

select employee_id, last_name, substr(last_name, 1, 3), instr(last_name, 'a')
from employees;

select employee_id, last_name, phone_number, replace(phone_number, '.', '-')
from employees;




-----------------------------------------------------------
--Regular Expression Test
--실습에 필요한 T1 테이블 생성
@c:\db_test\sql_labs\regexp_tab.sql
SELECT * FROM t1;

--REGEXP_LIKE 실습
--fname이 Ste로 시작하고 중간에 v나 ph를 포함하고 en으로 끝나는 데이터 검색하기
SELECT fname, lname
FROM t1
WHERE REGEXP_LIKE (fname, '^Ste(v|ph)en$');

--전화번호의 형식이 XXX.XX.XXXX.XXXXXX 형식인 데이터 검색
SELECT fname, phone
FROM t1
WHERE REGEXP_LIKE (phone, '...\...\.....\.......') ; --> ( \. --> . )

--이전 예제를 숫자만 검색하도록 제한하기 
SELECT fname, phone
FROM t1
WHERE REGEXP_LIKE (phone, '[0-9]{3}\.[0-9]{2}\.[0-9]{4}\.[0-9]{6}');

--전화번호의 "." 으로 구분 된 문자를 "-" 으로 변경
SELECT fname, phone, REGEXP_REPLACE ( phone , '\.' , '-' ) new_format
FROM t1 ;

--전화번호의 형식이 숫자 3-3-4 인 데이터만 지역번호에 괄호를 하고 사이 문자를 "-"로 변경
SELECT fname, phone,
REGEXP_REPLACE (phone, '(\d{3})\.(\d{3})\.(\d{4})','(\1)-\2-\3') new_phone
FROM t1;

--REGEXP_INSTR 함수를 사용하여 주소와 전화번호에서 알파벳이 오는 첫 위치값을 반환, lower(소문자)
SELECT fname, addr, REGEXP_INSTR ( addr, '[[:alpha:]]' ) pos ,
       phone, REGEXP_INSTR ( phone, '[[:alpha:]]') pos
FROM t1;

--REGEXP_SUBSTR 함수를 사용하여 거리이름을 반환(공백과 공백 사이 공백이 아닌~)
SELECT fname, addr, REGEXP_SUBSTR ( addr, ' [^ ]+ ') road
FROM t1;

--RETEXP_SUBSTR 함수와 일반함수 REPLACE를 중첩하여 전화번호 가운데 국번만 출력
SELECT fname, phone,
       REPLACE(REGEXP_SUBSTR(phone,'\.(\d{3})\.'),'.') code
FROM t1;

--위 예제에서 REPLACE 함수를 쓰지 않은 경우의 결과와 비교
SELECT fname, phone,
      REGEXP_SUBSTR(phone,'\.(\d{3})\.') code
FROM t1;

--REGEXP_COUNT 함수를 사용하여 주소에 포함된 a의 개수 표시
SELECT fname, addr, REGEXP_COUNT(addr,'a') cnt
FROM t1;

--REGEXP_SUBSTR 함수 사용으로 서브표현식의 개념 알아보기
--인수의 의미(순서대로 시작위치-발생횟수,대소문자 식별여부, 하위식번호)
SELECT REGEXP_SUBSTR ('0123456789',
                      '(123)(4(56)(78))', 1, 1, 'i', 1 ) "Exp1" ,
       REGEXP_SUBSTR ('0123456789',
                      '(123)(4(56)(78))', 1, 1, 'i', 2 ) "Exp2" ,
       REGEXP_SUBSTR ('0123456789',
                      '(123)(4(56)(78))', 1, 1, 'i', 3 ) "Exp3" ,
       REGEXP_SUBSTR ('0123456789',
                      '(123)(4(56)(78))', 1, 1, 'i', 4 ) "Exp4"
FROM dual;

--REGEXP__INSTR 함수 사용으로 서브표현식의 시작위치 반환하기
--예제의 마지막 인수 "2"를 1~5로 바꿔가며 실행하고 결과비교하기
--인수의 의미(순서대로 시작위치-발생횟수,대소문자 식별여부,반환옵션(0 또는 1)  하위식번호)
SELECT REGEXP_INSTR ('0123456789',
                     '(123)(4(56)(78))', 1, 1, 0, 'i', 2 ) "Position"
FROM dual;
--REGEXP_INSTR 함수의 세 번째 인수인 반환옵션(0 또는1) 실습
--두번째 서브표현식 45678의 다음인 9의 위치 반환
SELECT REGEXP_INSTR ('0123456789',
                     '(123)(4(56)(78))', 1, 1, 1, 'i', 2 ) "Position"
FROM dual;
--세번째 서브표현식 56의 다음인 7의 위치 반환
SELECT REGEXP_INSTR ('0123456789',
                     '(123)(4(56)(78))', 1, 1, 1, 'i', 3 ) "Position"
FROM dual;
--DNA 시퀀스 가운데 gtctcacaaag배열의 gtc 배열 찾기
SELECT REGEXP_INSTR('ccacctttccctccactcctcacgttctcacctgtaaagcgtccctc
cctcatccccatgcccccttaccctgcagggtagagtaggctagaaaccagagagctccaagc
tccatctgtggagaggtgccatccttgggctgcagagagaggagaatttgccccaaagctgcc
tgcagagcttcaccacccttagtctcacaaagccttgagttcatagcatttcttgagttttca
ccctgcccagcaggacactgcagcacccaaagggcttcccaggagtagggttgccctcaagag
gctcttgggtctgatggccacatcctggaattgttttcaagttgatggtcacagccctgaggc
atgtaggggcgtggggatgcgctctgctctgctctcctctcctgaacccctgaaccctctggc
taccccagagcacttagagccag',
'(gtc(tcac)(aaag))',
1, 1, 0, 'i', 1) "Position"
FROM dual;

--DNA 시퀀스 가운데 ccacctttccct배열의 ccct 배열 찾기
SELECT REGEXP_INSTR('ccacctttccctccactcctcacgttctcacctgtaaagcgtccctc
cctcatccccatgcccccttaccctgcagggtagagtaggctagaaaccagagagctccaagc
tccatctgtggagaggtgccatccttgggctgcagagagaggagaatttgccccaaagctgcc
tgcagagcttcaccacccttagtctcacaaagccttgagttcatagcatttcttgagttttca
ccctgcccagcaggacactgcagcacccaaagggcttcccaggagtagggttgccctcaagag
gctcttgggtctgatggccacatcctggaattgttttcaagttgatggtcacagccctgaggc
atgtaggggcgtggggatgcgctctgctctgctctcctctcctgaacccctgaaccctctggc
taccccagagcacttagagccag',
'(ccac(cttt)(ccct))',
1, 1, 0, 'i',
3) "Position"
FROM dual;
--REGEXP_COUNT 함수의 사용으로 소스에서 123 패턴의 발생 횟수 구하기
SELECT REGEXP_COUNT
('1234567812312378945123', '123') As Count
FROM dual;
--REGEXP_COUNT 함수의 사용으로 DNA 배열에서 gtc 패턴의 발생 횟수 구하기
SELECT REGEXP_COUNT(
'ccacctttccctccactcctcacgttctcacctgtaaagcgtccctccctcatccccatgcccccttaccctgcag
ggtagagtaggctagaaaccagagagctccaagctccatctgtggagaggtgccatccttgggctgcagagagaggag
aatttgccccaaagctgcctgcagagcttcaccacccttagtctcacaaagccttgagttcatagcatttcttgagtt
ttcaccctgcccagcaggacactgcagcacccaaagggcttcccaggagtagggttgccctcaagaggctcttgggtc
tgatggccacatcctggaattgttttcaagttgatggtcacagccctgaggcatgtaggggcgtggggatgcgctctg
ctctgctctcctctcctgaacccctgaaccctctggctaccccagagcacttagagccag',
'gtc') AS Count
FROM dual;

--Clear Test
DROP TABLE t1 PURGE;
