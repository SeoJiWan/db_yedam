select tablespace_name, table_name
from dba_tables
where owner='HR';
!ls /u01/app/oracle/oradata/orcl 
drop tablespace sales including contents and datafiles;
@q_tbs
@q_dbf
select tablespace_name, table_name
from dba_tables
where owner='HR';
!ls /u01/app/oracle/oradata/orcl