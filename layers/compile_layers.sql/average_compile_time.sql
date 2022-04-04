{{config(
    type='line_chart',
    title='Average Compile Time (Seconds)'
)}}


select timestamp_trunc(collector_tstamp,day) as date, avg(compile_time) as average_compile_seconds
from {{ref('compile_base')}}

group by 1
order by 1 