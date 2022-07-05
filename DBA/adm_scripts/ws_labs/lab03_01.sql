set echo on
conn / as sysdba
GRANT create database link TO hr
/
GRANT create view, create synonym TO hr
/
conn hr/hr
CREATE DATABASE LINK yd00xe_remote_hr
CONNECT TO hr IDENTIFIED BY hr
USING 'yd00xe'
/
SELECT * FROM member@yd00xe_remote_hr
/
set echo off