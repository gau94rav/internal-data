{{ config(
 title='Instance Name',
 type='select_filter',
 output_filters={'dropdown': 'instance'},
 persist_filters=false
)}}
 
SELECT DISTINCT instance_name as instance
FROM `topcoat-snowplow.dbt_prod_snowplow.users`



 
{{ column(
 name='instance',
 tags=['options','labels']
)}}