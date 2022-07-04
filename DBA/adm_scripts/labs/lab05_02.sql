set echo on
conn / as sysdba
create tablespace salestbs
datafile '/u01/app/oracle/oradata/orcl/salestbs01.dbf' size 10m
/
alter user sales default tablespace salestbs
/
conn sales/sales
create table orders
(ord_no number(4),
prod_no varchar2(6))
/
select table_name, tablespace_name from user_tables
/
set echo off