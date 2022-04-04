{{config(
    type='table',
    title='Errors'
   
)}}

select * 
from `topcoat-snowplow.dbt_prod_snowplow.errors`
where 1=1
{% if filter('error_class') %}    
AND error_class IN ({{ filter('error_class') | to_sql_list }} )

{% endif %}
{% if filter('exclude_internal') == 'true' %}	
AND user_type != 'internal'	
{% endif %}
order by 1 desc

