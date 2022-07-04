set echo on
conn hr/hr
UPDATE bigemp
SET employee_id =rownum
/
set echo off