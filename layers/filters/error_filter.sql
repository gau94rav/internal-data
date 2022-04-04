{{ config( 
    type='multi_selector',  
    output_filters={'selected_items': 'error_class'},  
    title='Error Class',  
    persist_filters=false
)}} 

SELECT distinct error_class
from `topcoat-snowplow.dbt_prod_snowplow.errors`
ORDER BY 1
 
{{ column(
 name='error_class',
 tags=['names','ids']
)}} 