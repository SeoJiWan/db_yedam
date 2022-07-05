alter tablespace sales offline;

select COUNT(*) from hr.employees;

select COUNT(*) from hr.emp2;

@q_tbs 

alter tablespace sales online;

alter tablespace sales read only;

update hr.emp2
set salary = salary*1.1;

@q_tbs

alter tablespace sales read write;

@q_tbs

update hr.emp2
set salary=salary*1.1;
rollback;
