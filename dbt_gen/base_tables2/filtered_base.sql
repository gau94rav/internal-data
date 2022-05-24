SELECT
*
from `topcoat-snowplow.dbt_prod_stg_snowplow.base_events` b
left join  `topcoat-snowplow.dbt_prod_snowplow.users` u
on b.user_id = u.user_id and b.instance_name = u.instance_name
where 1=1

--user_id multi_selector filter

  --DO NOTHING