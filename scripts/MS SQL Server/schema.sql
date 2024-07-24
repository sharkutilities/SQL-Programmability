/********************************************************************
A Simple Set of Queries to Fetch Table Details for MS-SQL Server

The special system table `INFORMATION_SCHEMA.COLUMNS` provides detail
information regarding a table like name, schema, column names, data
types, etc. to be querid.

Author  : Debmalya Pramanik
Contact : dpramanik.official@gmail.com
Version : v1.0.1

Copywright © [2024] Debmalya Pramanik
********************************************************************/

SELECT
    TABLE_CATALOG     -- ? parent level, database name
    , TABLE_SCHEMA    -- ? schema name (specifically for ms-sql server)
    , TABLE_NAME
    , COLUMN_NAME
    , ORDINAL_POSITION
    , COLUMN_DEFAULT
    , IS_NULLABLE
    , DATA_TYPE
FROM [INFORMATION_SCHEMA].[COLUMNS]
WHERE
    TABLE_NAME = ? -- ! use table name like: N'tablename'
