select tablespace_name, sum(bytes)/1024/1024 tbs_size
from dba_data_files
group by tablespace_name
/
