/********************************************************************
A Query for MS-SQL Server to Get Memory Usage Details

The special system table `sys.tables` provides detailed informations
like when the table was created and memory usaages. The following
simple query can be used to fetch data and is ordered based on total
memory used in descending order.

NOTE: This query is not allowed in some version of the MS-SQL server,
for more information check MS-SQL documentation for more information.

Author  : Debmalya Pramanik
Contact : dpramanik.official@gmail.com
Version : v1.0.0

Copywright © [2024] Debmalya Pramanik, sharkutilities
********************************************************************/

SELECT
    t.[name] AS [TABLE_NAME]
    , s.[name] AS [TABLE_SCHEMA]
    , p.[rows] AS [NUM_RECORDS]
    , SUM(a.[total_pages]) * 8 AS [TOTAL_ALLOCATED_SIZE_IN_KB]
    , CAST(SUM(a.[total_pages]) * 8 / 1024.0 AS NUMERIC) AS [TOTAL_ALLOCATED_SIZE_IN_MB]
    , SUM(a.[used_pages]) * 8 AS [TABLE_SIZE_IN_KB]
    , CAST(SUM(a.[used_pages]) * 8 / 1024.0 AS NUMERIC) AS [TABLE_SIZE_IN_MB]
    , (SUM(a.[total_pages]) - SUM(a.[used_pages])) * 8 AS [UNUSED_SPACE_IN_KB]
    , CAST((SUM(a.[total_pages]) - SUM(a.[used_pages])) * 8 / 1024.0 AS NUMERIC) AS [UNUSED_SPACE_IN_MB]
    , CASE
        WHEN SUM(a.[used_pages]) = 0 THEN NULL
        ELSE CAST((1 - CAST((SUM(a.[total_pages]) - SUM(a.[used_pages])) AS NUMERIC) / CAST(SUM(a.[total_pages]) AS NUMERIC)) * 100.0 AS DECIMAL(5, 2))
        END AS [PERCENTAGE_UTILIZED]
    , t.[create_date] AS [TABLE_CREATED_ON]
    , DATEDIFF(day, t.[create_date], CURRENT_TIMESTAMP) AS [NUM_DAYS_OLD]
    , t.[modify_date] AS [TABLE_LAST_MODIFIED_ON]
FROM sys.tables t
INNER JOIN
    sys.indexes i ON t.[object_id] = i.[object_id]
INNER JOIN
    sys.partitions p ON i.[object_id] = p.[object_id] AND i.[index_id] = p.[index_id]
INNER JOIN
    sys.allocation_units a ON p.[partition_id] = a.[container_id]
LEFT OUTER JOIN
    sys.schemas s ON t.[schema_id] = s.[schema_id]
WHERE
    t.[name] NOT LIKE 'sys%' -- ? system tables like `sysdiagrams` is ignored
    AND t.[is_ms_shipped] = 0
    AND i.[object_id] > 255
GROUP BY
    t.[name], s.[name], p.[rows], t.[create_date], t.[modify_date]
ORDER BY [TOTAL_ALLOCATED_SIZE_IN_KB] DESC
