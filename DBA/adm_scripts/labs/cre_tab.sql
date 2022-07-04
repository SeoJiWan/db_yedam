conn hr/hr
drop table test1 purge
/
drop table test2 purge
/
drop table emp1 purge
/
drop table emp2 purge
/
CREATE TABLE test1
(id number(4),
name varchar2(20))
/
CREATE TABLE test2
(id number(4),
name varchar2(20))
TABLESPACE insa
/
CREATE TABLE emp1
AS
SELECT * FROM employees
/
CREATE TABLE emp2
TABLESPACE insa
AS
SELECT * FROM employees
/