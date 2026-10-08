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
