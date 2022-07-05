set echo on
conn / as sysdba
grant execute on dbms_fga to hr
/
conn  hr/hr
begin
     dbms_fga.add_policy(
     object_name => 'EMPLOYEES', 
     policy_name => 'FGA_EMPS', 
     audit_column => 'EMPLOYEE_ID, SALARY',
     statement_types => 'SELECT, UPDATE',
     audit_column_opts => DBMS_FGA.ALL_COLUMNS);
     end;
    /
set echo off
