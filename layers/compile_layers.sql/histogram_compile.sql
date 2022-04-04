{{config(
    type='bar_chart',
    title='Compile Time',
    dimensions=[1],
    y_axis='hide',
    x_axis='hide',
    x_title='Percentile',
    y_title='Frequency'
)}}

WITH _filtered_base as (
   SELECT
   cast(compile_time as numeric) as compile_time, count(*) as number
   from `topcoat-snowplow.dbt_prod_snowplow.compile` 
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
   group by 1
   
), percentile as (
select 
compile_time,
number,
PERCENTILE_CONT(compile_time, 0) OVER() AS min,
  PERCENTILE_CONT(compile_time, 0.1) OVER() AS percentile1,
  PERCENTILE_CONT(compile_time, 0.2) OVER() AS percentile2,
  PERCENTILE_CONT(compile_time, 0.3) OVER() AS percentile3,
  PERCENTILE_CONT(compile_time, 0.4) OVER() AS percentile4,
  PERCENTILE_CONT(compile_time, 0.5) OVER() AS median,
  PERCENTILE_CONT(compile_time, 0.9) OVER() AS percentile90,
  PERCENTILE_CONT(compile_time, 1) OVER() AS max,
  count(*)

from _filtered_base
group by 1,2
order by 1
)

SELECT 
case when compile_time <= min then '< 0'
when compile_time <= percentile1 then '< 3.8'
when compile_time <= percentile2 then '< 7.6'
when compile_time <= percentile3 then '< 11.4'
when compile_time <= percentile4 then '< 15.2'
when compile_time <= median then '< 19'
when compile_time <= percentile90 then '< 52.2'
else '< 139' end as compile_group,
sum(number) as total
from  percentile
group by 1 
order by 
  case when compile_group = '< 0' then 1
  when compile_group = '< 3.8' then 2
  when compile_group = '< 7.6' then 3
  when compile_group = '< 11.4' then 4
  when compile_group = '< 15.2' then 5
  when compile_group = '< 19' then 6
  when compile_group = '< 52.2' then 7
  else 8 end