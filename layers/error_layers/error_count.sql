{{config(
    type='bar_chart',
    title='Error Class by Instance'
   
)}}

with errors as (select instance_name, error_class, count(*) as total
from `topcoat-snowplow.dbt_prod_snowplow.errors`
where 1=1
{% if filter('instance') %}
and instance_name = '{{ filter('instance')}}'
{% endif %}
{% if filter('user_id') %}
and user_id = '{{ filter('user_id')}}'
{% endif %}
{% if filter('exclude_internal') == 'true' %}	
AND user_type != 'internal'	
{% endif %}

group by 1,2
)

SELECT * FROM
(
  -- #1 from_item
select 
  instance_name, 
  error_class, 
  total
from errors
)
PIVOT
(
  -- #2 aggregate
  sum(total) AS total
  -- #3 pivot_column
  FOR error_class in ('javascript', 'sql','dbt')
)