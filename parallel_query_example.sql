SET max_parallel_workers = 6;
SET max_parallel_workers_per_gather = 6;
SET parallel_leader_participation = off;

CREATE TABLE risk.fixy AS
SELECT *, ST_GeometryType(ST_CollectionExtract(ST_MakeValid(ST_SnapToGrid(geom, .000001)), 3))
FROM risk.test;
