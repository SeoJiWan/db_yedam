-- id : demo, pw : demo 인 사용자 생성
-- 새 접속으로 demo로 만들려나 안됨 -> session 권한이 없음
create user demo identified by demo 
default tablespace users;
-- session 권한 부여 --> 새접속 가능
grant create session to demo;
-- table 생성 권한 부여 --> table 생성 안됨 -> 왜? 메모리공간도 부여해야함.
grant create table to demo;
-- role 생성 --> role 은 생성만 하고 grant를 role에다가 해줌
create role r1;
grant create view, create synonym to r1;
grant r1 to demo;
grant create sequence to r1;
-- UNLIMITED TABLESPACE --> table 공간생성 권한
grant UNLIMITED TABLESPACE to demo;
-- 권한을 부여하지 않으면 demo 는 접속조차 하지못한다. 
--> 테이블 하나를 만들기 위해 권한 3개를 부여해야한다.
--> 이것이 시스템권한이다.


-- 공용 동의어 권한부여
grant create public synonym to hr;

select object_name, object_type, owner
from dba_objects
where object_name = 'DUAL';

drop role r1;
-- 자기 객체를 갖고 있는 유저는 못지움 --> cacade 옵션으로 해결
drop user demo cascade;