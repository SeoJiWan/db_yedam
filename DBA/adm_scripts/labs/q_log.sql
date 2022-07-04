SELECT group#, members, sequence#, status,
       TO_CHAR(first_time, 'rr/mm/dd hh24:mi:ss') AS first_time
FROM v$log
/
