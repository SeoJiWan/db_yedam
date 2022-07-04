-- SQL 활용 시험
-- 1.
create table prof (
    profno number(4) primary key,
    name varchar2(15) constraint prof_name_nn not null
                      constraint prof_name_uk unique,
    id varchar2(15) not null,
    hiredate date,
    pay number(4),
    deptno number(4));
    
-- 2.
alter table prof add 
constraint prof_deptno_fk foreign key (deptno) 
references departments (department_id);

-- 3.
select table_name, constraint_name, constraint_type, search_condition, status
from user_constraints 
where table_name = 'PROF';

-- 4-1.
insert into prof
values (1001, '차은우', 'c1001', '17/03/01', 800, 10);
insert into prof
values (1002, '김제니', 'k1002', '20/11/28', 750, 20);
insert into prof (profno, name, id, hiredate)
values (1003, '손담비', 's1003', '21/03/02');

commit;

select * from prof;

-- 4-2.
update prof set pay = 1100
where profno = 1001;

-- 4-3.
commit;

-- 5-1.
create index prof_id_ix on prof (id);

-- 5-2.
select index_name
from user_indexes
where table_name = 'PROF';

-- 5-3.
select count(*)
from user_indexes
where table_name = 'PROF';

-- 6-1.
alter table prof add gender char(3);

-- 6-2.
alter table prof modify name varchar2(20);

desc prof;
select * from prof;

-- 7-1.
create view prof_list_vu
as
select profno as 교수번호, name as 교수이름, id as ID
from prof;

select * from prof_list_vu;

-- 7-2.
create synonym p_vu for prof_list_vu;

select * from p_vu;

-- 7-3.
create sequence prof_no_seq
                start with 1005
                increment by 1
                nocache
                nocycle;
                
-- 8-1.
create or replace view prof_list_vu
as 
select profno as 교수번호, name as 교수이름, id as ID, hiredate as 입사일
from prof;

select * from prof_list_vu;

-- 8-2.
alter sequence prof_no_seq increment by 2;

select * from user_sequences;

-- conn sys /
-- 9-1.
create user test identified by t2460;

-- 9-2.
grant connect, resource to test;

-- 9-3.
grant create view to test;

-- 9-4.
grant select on hr.prof_list_vu to test;

-- 10-1.
drop table prof purge;

show recyclebin;

-- 10-2.
-- 인덱스는 테이블 따라 함께 삭제됨.
select object_name, object_type, status
from user_objects
where object_name like 'PROF%' or object_name = 'P_VU';           