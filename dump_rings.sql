DO $$
    -- explodes multipolygons into a table of rings
    DECLARE
        ring RECORD;
        ring_path INTEGER;

        geom_input GEOMETRY;        
        ring_geom GEOMETRY;
        part GEOMETRY;
    BEGIN
        DROP TABLE IF EXISTS public.rings;
        CREATE TABLE public.rings(ring GEOMETRY, kind TEXT);

        -- select each row in the table
        FOR geom_input IN SELECT geom FROM public.junk LOOP

            -- for each geometry, dump the multipart geometry into single-part polygons
            FOR part IN EXECUTE(FORMAT($o$SELECT (ST_Dump('%s')).geom; $o$, geom_input)) LOOP

                -- for each ring of each single-part feature (outputs as a polygon)
                FOR ring in EXECUTE(FORMAT($o$SELECT ST_DumpRings('%s') as dump; $o$, part)) LOOP
                    ring_geom   := ST_ExteriorRing((ring.dump).geom);
                    ring_path   := (ring.dump).path[1];
                    IF ring_path = 0 THEN
                        INSERT INTO public.rings(ring, kind) VALUES(ring_geom, 'exterior');
                    ELSE
                        INSERT INTO public.rings(ring, kind) VALUES(ring_geom, 'interior');
                    END IF;        
                END LOOP;            
            END LOOP;
        END LOOP;
    END
$$;
