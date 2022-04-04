

{{config(
    type='bar_chart',
    title='Saves by Instance'
)}}


SELECT instance_name, count(*) 
FROM {{ ref('features_base')}}
where ide_action_name = 'save button'
group by 1
order by 1 desc
