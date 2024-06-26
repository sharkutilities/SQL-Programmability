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
