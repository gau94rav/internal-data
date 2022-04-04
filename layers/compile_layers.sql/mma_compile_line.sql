{{config(
    type='line_chart',
    title='Compile Time - Average & Median'
)}}
with av_c as (
select 
timestamp_trunc(collector_tstamp,day) as day, 
round(avg(compile_time),2) as c_avg
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
),
-- , mode_c as (

-- select distinct
-- day,
-- compile_time as c_mode,
-- freq,
-- row_number() over(partition by day order by freq desc) as rn
-- from (
--   select 
--   timestamp_trunc(collector_tstamp,day) as day,
--   compile_time,
--   count(*) as freq
--   from `topcoat-snowplow.dbt_production.compile`
--   group by 1,2
-- )
--  order by 1 desc
--  ),
 med_c as (select distinct
  timestamp_trunc(collector_tstamp,day) as day,
  PERCENTILE_CONT(compile_time, 0.5) OVER(partition by timestamp_trunc(collector_tstamp,day)) AS c_median
FROM `topcoat-snowplow.dbt_prod_snowplow.compile`
order by 1 desc)

select 
a.day,
c_avg,
--c_mode,
c_median
from av_c a
--left join (select * from mode_c where rn=1) m
--on a.day = m.day
left join med_c me
on me.day = a.day 
order by 1 desc

{{column(
    name='c_avg',
    label='Average'
)}}



{{column(
    name='c_median',
    label='Median'
)}}