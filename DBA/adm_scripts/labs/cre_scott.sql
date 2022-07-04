drop user scott cascade
/
create user scott identified by tiger
default tablespace users
temporary tablespace temp
/
grant connect, resource to scott
/