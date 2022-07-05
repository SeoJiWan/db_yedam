conn / as sysdba
drop user scott cascade
/
create user scott identified by tiger
default tablespace users
temporary tablespace temp
/
grant connect, resource to scott
/
grant create view, create synonym to scott
/
