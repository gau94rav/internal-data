{{ config(
 title='User Email',
 type='multi_selector',
 output_filters={'selected_items': 'user_id'},
 persist_filters=false
)}}
 
SELECT DISTINCT user_id 
FROM `topcoat-snowplow.dbt_prod_snowplow.users`
where 1=1
{% if filter('instance') %}
and instance_name = '{{ filter('instance')}}'
{% endif %}




 
{{ column(
 name='user_id',
 tags=['names','ids']
)}}