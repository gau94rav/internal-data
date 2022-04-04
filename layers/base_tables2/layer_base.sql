select *
from `topcoat-snowplow.dbt_prod_snowplow.layer_files` fe
where 1=1
{% if filter('instance') %}
and instance_name = '{{ filter('instance')}}'
{% endif %}
--user_id multi_selector filter
{% if filter('user_id') == '' or filter('user_id') == None %}
  --DO NOTHING
{% else %}
and last_edited_by in ({{ filter('user_id')|to_sql_list}})
{% endif %}

{% if filter('exclude_internal') == 'true' %}	
AND editing_user_type != 'internal'	
{% endif %}
{% if filter('start_date') %}
and last_edited >= '{{ filter('start_date') }}' 
{% endif %}
{% if filter('end_date') %}
and last_edited <= '{{ filter('end_date') }}'
{% endif %}