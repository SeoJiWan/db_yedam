--# DB보안
--1.시스템 보안
-- ㅁ 사용자를 생성, 암호를 설정
--    create user 사용자이름 identified by 암호;
--    alter user 사용자이름 identified by 암호;
--    drop user 사용자이름 cascade;
--    Role 사용하여 계정에 권한부여
-- ㅁ 시스템 권한 부여 : 데이터베이스에 ~를 할 수 있는
--    ex.) create session, create table, create view, create synonym
--2.데이터 보안
-- ㅁ 뷰와 동의어를 활용 -> 사용자는 실제 data에 접근 X
-- ㅁ 객체 권한 부여 (테이블, 뷰, 인덱스 ...) : ~의 ~을 사용(select, insert, update) 할 수 있는
--    ex.) select on hr.employees, update on hr.departments

--# Role (롤)
--: 시스템 보안 + 데이터 보안을 쉽고 동적으로 하기위해 생성하는 이름이 있는 권한의 묶음

--# 권한 (롤)부여, 회수 SQL (DCL : Data Control Language)
--1.권한 부여
-- grant 권한, ... to 대상 (사용자, 롤, public)
-- [with admin option]
-- [with grant option]
--2.권한 회수
-- revoke 권한, ... from 대상 (사용자, 롤, public)

--# 권한 옵션
-- grant 권한... to 대상
-- [with admin option] -> system 권한, role 
--   dba ---> hr ---> demo
--        r1      r1      --> revoke 시 hr 만 권환 회수
-- [with grant option] -> object 권한
--   hr ---> scott ---> demo
--      empvu     empvu   --> revoke 시 연계권환 회수로 scott, demo 다 회수




