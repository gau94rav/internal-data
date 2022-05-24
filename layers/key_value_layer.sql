SELECT 'SEVERITY LEVEL' as key, 'High' as value
UNION ALL
SELECT 'SEVERITY LEVEL' as key, 'Medium' as value
UNION ALL
SELECT 'SEVERITY LEVEL' as key, 'Low' as value
UNION ALL
SELECT 'STATUS' as key, 'Open' as value
UNION ALL
SELECT 'STATUS' as key, 'Ignored' as value
UNION ALL
SELECT 'PRIORITY SCORE' as key, 'Ignored' as value

{{column(
    name='key',
    tags=["keys"]
)}}
{{column(
    name='value',
    tags=["values"]
)}}