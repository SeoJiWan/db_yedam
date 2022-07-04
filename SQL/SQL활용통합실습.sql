-- #SQL활용통합실습
--1.
create table member (user_id number(6) primary key,
                     user_name varchar2(20) constraint member_uname_nn not null,
                     passwd varchar2(10) constraint member_pw_nn not null,
                     id_num varchar2(13) constraint member_idnum_uk unique
                                         constraint member_idnum_nn not null,
                     phone varchar(13),
                     address varchar(25),
                     reg_date date,
                     interest varchar2(15));
                     
select * from member;    

--2.
create table board (no number(4) primary key,
                    subject varchar2(50) constraint board_sub_nn not null,
                    content varchar2(2000),
                    cre_date date,
                    user_id number(6) constraint board_uid_fk references member (user_id));

select * from board;

select table_name, constraint_name, constraint_type, status, search_condition
from user_constraints;

--3.
create sequence board_no_seq
                start with 1
                increment by 1
                nocache
                nocycle;
                
--4.
INSERT INTO member
VALUES (101,'송성광','1111','7906021234567', '051-123-1234','부산 수정동',sysdate,'DB');
INSERT INTO member
VALUES (102,'김영균','2222','7903022341567','051-321-1234','창원 사림동',sysdate,'internet');
INSERT INTO member
VALUES (103,'전인하','3333','7901041324668','051-345-3456','부산 동삼동',sysdate,'java');

INSERT INTO board
VALUES (board_no_seq.nextval,'제목1','내용1',sysdate,101);
INSERT INTO board
VALUES (board_no_seq.nextval,'제목2','내용2',sysdate,102);
INSERT INTO board
VALUES (board_no_seq.nextval,'제목3','내용3',sysdate,103);

select * from member;
select * from board;

--5.
alter table member add email varchar2(50);

select * from member;

--6.
alter table member add country varchar2(20) default 'Korea';

select * from member;

--7.
alter table member drop column id_num;

select * from member;

select table_name, constraint_name, constraint_type, status, search_condition -- id_num 에 해당하는 제약조건도 사라짐
from user_constraints;

--8.
alter table member modify address varchar(50);

desc member;

--9.
create index board_userid_ix on board (user_id);

select table_name, index_name
from user_indexes;

--10.
select * from member;

create view member_addr_phone_list_vu
as
select user_id, user_name, phone, address
from member;

select * from member_addr_phone_list_vu;

--11.
select * from board;

create view board_list_vu
as
select no, subject, user_id
from board;

select * from board_list_vu;

--12.
create synonym m for member_addr_phone_list_vu;
select * from m;

create synonym b for board_list_vu;
select * from b;

--13.
create or replace view board_list_vu
as 
select no, subject, user_id, cre_date
from board;

select * from b;

--14.
select table_name, constraint_name, constraint_type, status, search_condition
from user_constraints;

select table_name, index_name, index_type, status
from user_indexes;

select object_name, object_type, status
from user_objects;

--15.
drop table member cascade constraints; --> 제약조건이 다른 테이블과 묶여있는 테이블 삭제시 cascade constraints 옵션 사용

--16.
select table_name, constraint_name, constraint_type, status, search_condition
from user_constraints
where table_name = 'MEMBER';

select object_name, object_type, status
from user_objects;

--17.
drop table board;

drop view board_list_vu;

drop synonym m;

select 'drop' || ' ' || object_type || ' ' || object_name || ';'
from user_objects;

drop SEQUENCE BOARD_NO_SEQ;
drop VIEW MEMBER_ADDR_PHONE_LIST_VU;
drop SYNONYM B;

select object_name, object_type, status
from user_objects;



