SELECT
collector_tstamp, 
cast(compile_time as numeric) as ct, 
count(*) as number
from `topcoat-snowplow.dbt_production.base_events` b
left join  `topcoat-snowplow.dbt_production.users` u
on b.user_id = u.user_id and b.instance_name = u.instance_name
where compile_time is not null
group by 1,2