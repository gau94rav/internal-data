SELECT
*
from `topcoat-snowplow.dbt_prod_stg_snowplow.base_events` b
left join  `topcoat-snowplow.dbt_prod_snowplow.users` u
on b.user_id = u.user_id and b.instance_name = u.instance_name
where 1=1
{% if filter('instance') %}
and b.instance_name = '{{ filter('instance')}}'
{% endif %}
--user_id multi_selector filter
{% if filter('user_id') == '' or filter('user_id') == None %}
  --DO NOTHING
{% else %}
and b.user_id in ({{ filter('user_id')|to_sql_list}})
{% endif %}

{% if filter('exclude_internal') == 'true' %}	
AND user_type != 'internal'	
{% endif %}
{% if filter('start_date') %}
and collector_tstamp >= '{{ filter('start_date') }}' 
{% endif %}
{% if filter('end_date') %}
and collector_tstamp <= '{{ filter('end_date') }}'
{% endif %}
