select count(distinct instance_name) as value
from {{ ref('user_base') }}
where last_seen >= (timestamp_sub(current_timestamp, INTERVAL 7 DAY))