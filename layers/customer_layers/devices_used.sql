{{config(
    type='table',
    title='Devices and Browsers'
)}}

SELECT user_id, os_family, os_version, device_family, device_class,
agent_name_version as browser_version, device_brand, layout_engine_name_version
FROM `topcoat-snowplow.dbt_prod_snowplow.devices` 
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
