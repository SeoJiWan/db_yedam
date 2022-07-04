set echo on
conn hr/hr
DROP TABLE bigemp purge
/
CREATE TABLE bigemp AS SELECT * FROM employees
/
ALTER TABLE bigemp MODIFY (employee_id NUMBER)
/
DECLARE
n NUMBER;
BEGIN
FOR n IN 1..15
LOOP
INSERT INTO bigemp SELECT * FROM bigemp;
END LOOP;
COMMIT;
END; 
/
SELECT COUNT(*) FROM bigemp
/
set echo off