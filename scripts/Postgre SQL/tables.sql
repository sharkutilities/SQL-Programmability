/********************************************************************
A Short Query to get a Table Information - Name, Indexes, Size, etc.

Uses the internal `pg_table` to get the table information like name,
indexes and an internal PostgreSQL function to get the table size.
********************************************************************/

SELECT
	*
	, pg_size_pretty(pg_total_relation_size(
        schemaname || '.' || tablename
    )) AS tablesize
FROM pg_tables WHERE schemaname NOT IN (
    'pg_catalog', 'information_schema'
)
ORDER BY pg_total_relation_size(schemaname || '.' || tablename) DESC
