select * 
from `topcoat-snowplow.dbt_prod_snowplow.errors`
where 1=1
{% if filter('instance') %}
and instance_name = '{{ filter('instance')}}'
{% endif %}
--user_id multi_selector filter
{% if filter('user_id') == '' or filter('user_id') == None %}
  --DO NOTHING
{% else %}
and user_id in ({{ filter('user_id')|to_sql_list}})
{% endif %}
{% if filter('exclude_internal') == 'true' %}	
AND user_type != 'internal'	
{% endif %}
{% if filter('start_date') %}
and error_time >= '{{ filter('start_date') }}' 
{% endif %}
{% if filter('end_date') %}
and error_time <= '{{ filter('end_date') }}'
{% endif %}

