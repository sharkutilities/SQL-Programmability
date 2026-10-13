/********************************************************************
Set of Date/Date-Time Function(s) for PostgreSQL Database
/--------------------------------------------------------------------

The PostgreSQL data type ``date``, ``timestamp`` and ``timestamptz``
related functions to enhance core capabilities in the database.
********************************************************************/

CREATE OR REPLACE FUNCTION public.generate_date_series (
    p_gte_date    DATE
    , p_lte_date  DATE
    , p_step_size INTERVAL DEFAULT INTERVAL '1 day'
) RETURNS TABLE (step_date DATE)
LANGUAGE plpgsql IMMUTABLE AS
$$
BEGIN

    /****************************************************************
    Return the dates from a start date to an end date, both included,
    one row for each step of the given interval.

    ``GENERATE_SERIES()`` called on two dates resolves to its
    ``TIMESTAMPTZ`` form, which depends on the session time zone and
    is only ``STABLE``. The bounds are cast to ``TIMESTAMP`` instead,
    so the series is the same in every session and the function can
    be ``IMMUTABLE``.

        p_gte_date (From Date): The first date of the series.

        p_lte_date (To Date): The last date the series may reach; it
            is returned only when a step lands on it. An end date
            before the start date raises an error.

        p_step_size (Step Size): The interval between two dates, one
            day by default. A NULL step, or one that adds up to zero
            such as ``'1 day -24 hours'``, raises an error. Each step
            is added to the previous date, so a monthly series from
            the 31st falls to the 28th in February and stays there. A
            step with a time part is added to midnight and the time
            is dropped afterwards, so ``'12 hours'`` repeats dates and
            ``'1 day 30 minutes'`` can miss the end date.

    Return Value: One ``step_date`` row for each step, in order from
    the start date. No rows are returned when either date is NULL, or
    when the step is negative and the two dates differ.
    *****************************************************************/

    IF p_step_size IS NULL OR p_step_size = INTERVAL '0' THEN
        RAISE EXCEPTION 'Step must be a non-zero interval';
    END IF;

    IF p_lte_date < p_gte_date THEN
        RAISE EXCEPTION 'End date is before start date';
    END IF;

    RETURN QUERY
    SELECT gs::DATE FROM GENERATE_SERIES(
        p_gte_date::TIMESTAMP, p_lte_date::TIMESTAMP, p_step_size
    ) AS gs;

END;
$$;
