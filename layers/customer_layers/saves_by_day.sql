{{config(
    type='line_chart',
    title='Saves by Day'
)}}


SELECT timestamp_trunc(collector_tstamp,day) as day, count(*) 
FROM {{ ref('features_base')}}
where ide_action_name = 'save button'
group by 1
order by 1 desc