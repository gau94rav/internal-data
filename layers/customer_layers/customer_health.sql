{{config(
  type='customer_table',
  title='Customer Health'
)}}


 --one page
 --multiple pages
with c_page as (
select 
created_by as user_id,  
instance_name, 
count(distinct file_name) as page_count
from `topcoat-snowplow.dbt_prod_snowplow.page_files`
where creating_user_type != 'internal'
group by 1,2
),

--filter on a page
f_page as (
select 
created_by as user_id,  
instance_name,
(length(file_contents) - length(REPLACE(file_contents, 'slot=filters', '')))/12 as filter_slots,
case when file_contents like '%filter%' then 'filter' else 'no filter' end as filter,
file_contents
from `topcoat-snowplow.dbt_production.page_files`
where creating_user_type != 'internal'
),

--one layer
c_layer as (
select 
created_by as user_id,  
instance_name, 
count(distinct file_name) as layer_count
from `topcoat-snowplow.dbt_production.layer_files`
where creating_user_type != 'internal'
group by 1,2
),
--filter in a layer
f_layer as (
select 
created_by as user_id,  
instance_name, 
(length(file_contents) - length(REPLACE(file_contents, 'filter', '')))/6 as filter_c,
case when file_contents like '%filter%' then 'filter' else 'no filter' end as filter,
file_contents
from `topcoat-snowplow.dbt_production.layer_files`
where creating_user_type != 'internal'
and viz_type not in ('multi_selector','select_filter')
),
--one ref
--multiple refs
r_layer as (
select 
created_by as user_id,  
instance_name, 
(length(file_contents) - length(REPLACE(file_contents, 'ref(', '')))/4 as ref_c,
case when file_contents like '%ref(%' then 'ref used' else 'no ref' end as ref,
file_contents
from `topcoat-snowplow.dbt_production.layer_files`
where creating_user_type != 'internal'
)

--user group
--multiple active users
--changed theme/custom theme
--connect dbt
--check dag
--custom viz

select distinct
f.user_id,
f.instance_name,
case when pa.page_count >= 1 then true else false end as one_page,
case when pa.page_count > 1 then true else false end as multiple_pages,
case when cl.layer_count >= 1 then true else false end as one_layer,
case when cl.layer_count > 1 then true else false end as multiple_layers,
case when fp.filter='filter' then true else false end as filter_on_page,
case when fl.filter='filter' then true else false end as filter_on_layer,
case when rl.ref='ref used' then true else false end as ref_used

from `topcoat-snowplow.dbt_production.users` f
left join c_page pa
on f.user_id = pa.user_id and f.instance_name = pa.instance_name
left join (select * from f_page where filter = 'filter') fp
on f.user_id = fp.user_id and f.instance_name = fp.instance_name
left join c_layer cl
on f.user_id = cl.user_id and f.instance_name = cl.instance_name
left join (select * from f_layer where filter = 'filter') fl
on f.user_id = fl.user_id and f.instance_name = fl.instance_name
left join (select * from r_layer where ref = 'ref used') rl
on f.user_id = rl.user_id and f.instance_name = rl.instance_name
where f.user_type != 'internal'
and f.user_id != 'slave.of.machine@gmail.com' -- move to dbt
order by instance_name 