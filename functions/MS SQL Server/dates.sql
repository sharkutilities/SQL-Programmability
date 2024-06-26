/********************************************************************
A Set of Utility Functions to Work with `DATE`/`DATETIME` Object

Date (or date time) is a crucial and one of the basic data type which
is available with almost all the flavors of SQL. The below function
provides utilities to work. Check the description for more details.

Author  : Debmalya Pramanik
Contact : dpramanik.official@gmail.com
Version : v1.0.0

Copywright © [2024] Debmalya Pramanik
********************************************************************/

CREATE FUNCTION [dbo].[extQuarterName] (@date DATE) RETURNS VARCHAR(7) AS
BEGIN
    DECLARE @resolvedQuarter VARCHAR(7);

    IF @date IS NULL
        SET @resolvedQuarter = NULL;
    ELSE
        SET @resolvedQuarter = CONCAT(DATEPART(YEAR, @date), '-Q', DATEPART(QUARTER, @date));

    RETURN @resolvedQuarter
END;
GO


CREATE FUNCTION [dbo].[extQuarterNameLong] (@date DATE) RETURNS VARCHAR(19) AS
BEGIN
    DECLARE @resolvedQuarter VARCHAR(19);
    DECLARE @_tempQuarterValue INTEGER;

    IF @date IS NULL
        SET @resolvedQuarter = NULL;
    ELSE BEGIN
        SET @_tempQuarterValue = DATEPART(QUARTER, @date);
        SET @resolvedQuarter = CASE
            WHEN @_tempQuarterValue = 1 THEN CONCAT('C.Y. ', @_tempQuarterValue, ' [JAN-MAR]')
            WHEN @_tempQuarterValue = 2 THEN CONCAT('C.Y. ', @_tempQuarterValue, ' [APR-JUN]')
            WHEN @_tempQuarterValue = 3 THEN CONCAT('C.Y. ', @_tempQuarterValue, ' [JUL-SEP]')
            WHEN @_tempQuarterValue = 4 THEN CONCAT('C.Y. ', @_tempQuarterValue, ' [OCT-DEC]')
            END;
    END

    RETURN @resolvedQuarter
END;
GO

CREATE FUNCTION [dbo].[getMonthName] (@date DATE) RETURNS VARCHAR(6) AS
BEGIN
    DECLARE @monthName VARCHAR(6);
    DECLARE @_tempMonthValue INTEGER;

    IF @date IS NULL
        SET @monthName = NULL;
    ELSE BEGIN
        SET @_tempMonthValue = MONTH(@date);

        -- Ref. Link: https://stackoverflow.com/a/1181147/6623589
        SET @monthName = CASE
            WHEN @_tempMonthValue = 1  THEN '01-JAN'
            WHEN @_tempMonthValue = 2  THEN '02-FEB'
            WHEN @_tempMonthValue = 3  THEN '03-MAR'
            WHEN @_tempMonthValue = 4  THEN '04-APR'
            WHEN @_tempMonthValue = 5  THEN '05-MAY'
            WHEN @_tempMonthValue = 6  THEN '06-JUN'
            WHEN @_tempMonthValue = 7  THEN '07-JUL'
            WHEN @_tempMonthValue = 8  THEN '08-AUG'
            WHEN @_tempMonthValue = 9  THEN '09-SEP'
            WHEN @_tempMonthValue = 10 THEN '10-OCT'
            WHEN @_tempMonthValue = 11 THEN '11-NOV'
            WHEN @_tempMonthValue = 12 THEN '12-DEC'
        END;
    END;

    RETURN @monthName
END;
GO
