{{config(
    type='line_chart',
    title='Files Created'
)}}


select timestamp_trunc(create_date,day), count(distinct (concat(file_name,instance_name)))
from {{ref('files_base')}}
where create_date is not null
--where created_date >= (timestamp_sub(current_timestamp, INTERVAL 7 DAY))
group by 1
order by 1 desc