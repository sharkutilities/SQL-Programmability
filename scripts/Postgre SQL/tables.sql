SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE table_schema NOT IN ('pg_catalog', 'information_schema')
ORDER BY
	table_schema
	, table_name
