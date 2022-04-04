select 
case when date_diff(current_timestamp, last_seen, day) = 0 then 'Today' 
when date_diff(current_timestamp, last_seen, day) = 1 then 'Yesterday' 
else concat(date_diff(current_timestamp, last_seen, day),' Days Ago')
end as value,
last_seen,
user_id
from {{ ref('user_base') }}
order by 2 DESC