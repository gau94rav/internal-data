WITH _filtered_base as (
   SELECT
   timestamp_trunc(collector_tstamp,day) as day, 
   cast(compile_time as numeric) as compile_time, 
   count(*) as number
   from `topcoat-snowplow.dbt_prod_snowplow.compile` 
   where 1=1




   group by 1,2
   
), percentile as (
select 
day,
compile_time,
coalesce(number,0) as number,
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
group by 1,2,3
order by 1
),

final_pivot as (SELECT 
day,
case when compile_time <= min then 'm_0'
when compile_time <= percentile1 then 'p_3'
when compile_time <= percentile2 then 'p_7'
when compile_time <= percentile3 then 'p_11'
when compile_time <= percentile4 then 'p_15'
when compile_time <= median then 'm_19'
when compile_time <= percentile90 then 'p_52'
else 'm_139' end as compile_group,
sum(number) as total
from  percentile
group by 1,2 ),

test as (
    SELECT * FROM 
(
  -- #1 from_item
select 
  compile_group, 
  day,
  total
from final_pivot
)
PIVOT
(
  -- #2 aggregate
  sum(total) AS total
  -- #3 pivot_column
  FOR compile_group in ('m_0', 'p_3', 'p_7', 
  'p_11','p_15','m_19','p_52','m_139')
))

SELECT 
day,
coalesce(total_m_0,0) as total_m_0, 
coalesce(total_p_3,0) as total_p_3, 
coalesce(total_p_7,0) as total_p_7, 
coalesce(total_p_11,0) as total_p_11,
coalesce(total_p_15,0) as total_p_15,
coalesce(total_m_19,0) as total_m_19,
coalesce(total_p_52,0) as total_p_52,
coalesce(total_m_139,0) as total_m_139
from test
order by day desc