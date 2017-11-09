CREATE OR REPLACE FUNCTION tables_have_same_columns(table_a TEXT, table_b TEXT)
  RETURNS BOOLEAN LANGUAGE plpgsql AS
$BODY$
    DECLARE
          rec RECORD;
        query TEXT;

    BEGIN
        query := FORMAT($$SELECT a.column_name AS a_col, b.column_name AS b_col
                            FROM (SELECT column_name FROM information_schema.columns WHERE table_schema || '.' || table_name = '%s') a
                            FULL OUTER JOIN (SELECT column_name as column_name FROM information_schema.columns WHERE table_schema || '.' || table_name = '%s') b
                           USING (column_name);$$, table_a, table_b);

        FOR rec IN EXECUTE query LOOP
            IF rec.a_col IS NULL THEN
                RETURN FALSE;
            ELSIF rec.b_col IS NULL THEN
                RETURN FALSE;
            END IF;
        END LOOP;

        RETURN TRUE;
    END
$BODY$;
