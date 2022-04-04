{{ config(
    type='donut_chart',
    title='Viz Types'
)}}

select viz_type, count(*)
from {{ref('layer_base')}}
where viz_type is not null
group by 1