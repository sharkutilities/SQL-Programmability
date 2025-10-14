/********************************************************************
A Set of Utility Functions for Quick Analysis & Validations

SQL is a powerful tool, and basic analysis can be quickly done for
validation and POC development. The functions defined below can be
used globally as per requirement.

Author  : Debmalya Pramanik
Contact : dpramanik.official@gmail.com
Version : v1.0.0

Copywright © [2024] Debmalya Pramanik (ZenithClown)
********************************************************************/

CREATE FUNCTION [dbo].[udf_wma_factors] (
  @p_factor   FLOAT = 0.5
  , @p_decay  FLOAT = 2.0
  , @p_lookup INTEGER = 3
)
RETURNS TABLE AS RETURN (
  -- ? Use Recusrsive CTE to Generate a Series
  WITH [sequenceCTE] AS (
    SELECT 0 AS [n]
    UNION ALL
    SELECT [n] + 1
    FROM [sequenceCTE]
    WHERE [n] + 1 < @p_lookup
  )

  -- ? Calculate the Factor for Each Number in the Series
  SELECT
    [n]
    , @p_factor / POWER(@p_decay, n) AS [factor]
  FROM [sequenceCTE]
);
