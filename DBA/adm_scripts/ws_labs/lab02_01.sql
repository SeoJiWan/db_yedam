col name for a40
col value for a20
SELECT name, value, issys_modifiable FROM v$parameter
WHERE name LIKE 'job_queue%'
OR name LIKE 'db_block_size'
/
