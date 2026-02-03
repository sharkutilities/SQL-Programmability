/********************************************************************
Function Related to Array in PostgreSQL DB using Native Functionality

PostgreSQL provides many default functions for array, which can be
extended to perform various other checks. The function lists are
mentioned as below.

  * public.array_equals : Function to check if all the values in an
    array has all unique values, returns boolean. The function tries
    to convert all the components of the array to a `VARCHAR(128)[]`
    which is an added step to make it generic (however, maybe skipped
    in production database with large input array of varied type).

Copyright © [2026] Debmalya Pramanik (ZenithClown)
********************************************************************/

CREATE OR REPLACE FUNCTION public.array_equals(check_array VARCHAR(128)[])
RETURNS BOOLEAN
LANGUAGE plpgsql AS
$$
BEGIN
  RETURN CARDINALITY(ARRAY(SELECT DISTINCT UNNEST(check_array::VARCHAR(128)[]))) = CARDINALITY(check_array::VARCHAR(128)[]);
END;
$$
