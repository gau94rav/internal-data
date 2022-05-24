SELECT count(distinct (concat(file_name,instance_name))) as value
FROM {{ ref('files_base') }}