select event, total_waits
from v$system_event
where total_waits <> 0
order by 2 desc
/
