set echo on
conn / as sysdba
alter tablespace test read only
/
conn hr/hr
select count(*) from sawon;
update sawon
     Set salary = salary *1.1
/
update employees
     Set salary = salary *1.1
/
rollback
/
drop table buseo
/
conn / as sysdba
ALTER TABLESPACE test READ WRITE
/
ALTER TABLESPACE test OFFLINE
/
conn hr/hr
select count(*) from sawon
/
select count(*) from employees
/
conn / as sysdba
ALTER TABLESPACE test ONLINE
/
set echo off