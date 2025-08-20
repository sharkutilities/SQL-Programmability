/********************************************************************
A Function to Replace Multiple Words from a String (Long Description)

Create a looping function that can replace multiple words in a string
using the REGEXP_REPLACE function. This function is beneficial to
remove stop words (or common terms that do not provide any
additional value) from long description columns. The function thus
mimics the ``nltk.stopwords`` functionality using the native PSQL
query, thus reducing Python dependency. However, unlike the stopwords
module, default words are not defined and must be passed as an array.

NOTE: Recommended to use a shorter list for multi-replace as long
list can overwhelm the system runtime.

The replace function uses Regular Expressions, thus if you need to
remove the word "is" then you should pass ``\s(is)\s`` instead, else
any and all occurrences of "is" will be removed.

.. code-block::sql

  SELECT public.multireplace(
    'Hi, this is a long string containing many stop words.',
    ARRAY['is', '\s{2,}']
  )

  >> Hi, th a long string containing many stop words.

  -- use correct regular expression notation like:
  SELECT public.multireplace(
    'Hi, this is a long string containing many stop words.',
    ARRAY['\s(is)\s', '\s{2,}']
  )

  >> Hi, this a long string containing many stop words.

Also, we have added the expression to remove multiple spaces from the
resultant query - which should always be at the last as the regular
expressions are iterated in the given sequence.

Copyright © [2025] Debmalya Pramanik (ZenithClown)
********************************************************************/

CREATE OR REPLACE FUNCTION public.multireplace(
  p_in_text VARCHAR(512)
  , p_words VARCHAR(32)[]
  , p_newvl VARCHAR(16) DEFAULT ' '
) RETURNS VARCHAR(512)
LANGUAGE plpgsql AS
$$

DECLARE
  p_word VARCHAR(512);

BEGIN
  FOREACH p_word IN ARRAY p_words
  LOOP
    p_in_text := REGEXP_REPLACE(p_in_text, p_word, p_newvl, 'gi');
  END LOOP;
RETURN p_in_text;
END $$;
