SELECT department, year, total, target_total
FROM {{ ref('seed_financial_data') }}
WHERE 1=1

AND CAST(year AS STRING) = CAST(2020 AS STRING)

AND department LIKE '%None%'