SELECT
	pubname
	, pubowner::regrole AS pubowner
FROM pg_publication
