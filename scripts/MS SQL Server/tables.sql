SELECT
	[TABLE_CATALOG],
	[TABLE_SCHEMA],
	[TABLE_NAME]
FROM [INFORMATION_SCHEMA].[TABLES]
WHERE [TABLE_TYPE] = 'BASE TABLE'
ORDER BY [TABLE_NAME]
