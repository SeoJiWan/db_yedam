set echo on
conn  / as sysdba
drop user sales cascade
/
create user sales identified by sales
/
col username for a15
col default_tablespace for a15
select username, default_tablespace, profile from dba_users
where username='SALES'
/
conn sales/sales 
conn / as sysdba
grant create session, create table to sales
/
conn sales/sales
select * from session_privs
/
create table customer
(id number(3),
name varchar2(20))
/
insert into customer
values(101, 'Mark')
/
conn / as sysdba
alter user sales quota 5m on users
/
conn sales/sales
insert into customer
values(101, 'Mark')
/
commit
/
set echo off