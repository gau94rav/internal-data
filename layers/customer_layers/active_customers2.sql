{{config(
    type='big_number',
    title='Active Users'
)
}}

select count(distinct user_id) as value
from {{ref('user_base')}}
where last_seen >= (timestamp_sub(current_timestamp, INTERVAL 7 DAY))