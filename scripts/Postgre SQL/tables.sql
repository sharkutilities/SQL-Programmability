/********************************************************************
A Short Query to get Table Information - Name, Indexes, Size, etc.

Uses the internal `pg_table` to get the table information like name,
indexes, and an internal PostgreSQL function to get the table size.
********************************************************************/

SELECT
	*
	, pg_size_pretty(pg_total_relation_size(
        schemaname || '.' || tablename
    )) AS tablesize
FROM pg_tables WHERE schemaname NOT IN (
    'pg_catalog', 'information_schema', 'cron', '_timescaledb_cache',
	'_timescaledb_catalog', '_timescaledb_config', '_timescaledb_functions',
	'_timescaledb_internal', 'timescaledb_experimental', 'timescaledb_information'
)
ORDER BY pg_total_relation_size(schemaname || '.' || tablename) DESC

/********************************************************************
Query for HyperTable (https://github.com/timescale/timescaledb) Size

A ``hypertable`` is a unique table created by the ``TimeScaleDB``
extension of PostgreSQL that provides unique functionalities. To get
the total size of such a table, use the built-in function.
********************************************************************/

SELECT pg_size_pretty(hypertable_size('{schema}.{table}'));

/********************************************************************
Query for HyperTable + PG Table Size (Combined PostgreSQL DB)
********************************************************************/

SELECT
    *
    , pg_size_pretty(
	    pg_total_relation_size(schemaname || '.' || tablename)
	    + COALESCE(hypertable_size(
	        schemaname || '.' || tablename
	    ), 0)
    ) AS tablesize
FROM pg_tables WHERE schemaname NOT IN (
    'pg_catalog', 'information_schema', 'cron', '_timescaledb_cache',
    '_timescaledb_catalog', '_timescaledb_config', '_timescaledb_functions',
    '_timescaledb_internal', 'timescaledb_experimental', 'timescaledb_information'
)
ORDER BY (
    pg_total_relation_size(schemaname || '.' || tablename)
    + COALESCE(hypertable_size(
        schemaname || '.' || tablename
    ), 0)
) DESC

/********************************************************************
Display All Objects of the Database Excluding Extension Objects
********************************************************************/

SELECT
    nsp.nspname AS schemaname
    , obj.object_kind
    , obj.object_name
FROM (
    SELECT
        relnamespace AS object_schema
        , CASE relkind
            WHEN 'v' THEN 'view'
            WHEN 'm' THEN 'materialized view'
            ELSE 'table' END AS object_kind
        , relname AS object_name
    FROM pg_catalog.pg_class c
    WHERE
        relkind IN ('r', 'p', 'v', 'm')
        AND NOT EXISTS (
            SELECT 1 FROM pg_catalog.pg_depend d
            WHERE d.objid = c.oid AND d.deptype = 'e'
        )

    UNION ALL

    SELECT
        typnamespace
        , CASE typtype
            WHEN 'd' THEN 'domain'
            ELSE 'enum' END
        , typname
    FROM pg_catalog.pg_type t
    WHERE
        typtype IN ('d', 'e')
        AND NOT EXISTS (
            SELECT 1 FROM pg_catalog.pg_depend d
            WHERE d.objid = t.oid AND d.deptype = 'e'
        )
    
    UNION ALL
    
    SELECT
        pronamespace
        , CASE prokind
            WHEN 'p' THEN 'procedure'
            ELSE 'function' END
        , (
            proname || '(' ||
            PG_GET_FUNCTION_IDENTITY_ARGUMENTS(oid) || ')'
        )
    FROM pg_catalog.pg_proc p
    WHERE NOT EXISTS (
        SELECT 1 FROM pg_catalog.pg_depend d
        WHERE d.objid = p.oid AND d.deptype = 'e'
    )

    UNION ALL

    SELECT
        rel.relnamespace
        , 'trigger'
        , trg.tgname || ' ON ' || rel.relname
    FROM pg_catalog.pg_trigger trg
    JOIN pg_catalog.pg_class rel ON
        rel.oid = trg.tgrelid
    WHERE
        NOT trg.tgisinternal
        AND NOT EXISTS (
            SELECT 1 FROM pg_catalog.pg_depend d
            WHERE d.objid = trg.oid AND d.deptype = 'e'
        )
) obj

JOIN pg_catalog.pg_namespace nsp ON
    nsp.oid = obj.object_schema

WHERE nsp.nspname NOT IN (
    'pg_catalog', 'information_schema', 'cron', '_timescaledb_cache',
    '_timescaledb_catalog', '_timescaledb_config', '_timescaledb_functions',
    '_timescaledb_internal', 'timescaledb_experimental', 'timescaledb_information'
)

ORDER BY
    nsp.nspname
    , obj.object_kind
    , obj.object_name
