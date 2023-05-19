/*
DROP TABLE IF EXISTS raw;
CREATE TABLE raw (
  data jsonb
);

\copy raw FROM 'assignments/asn_04/earthquakes/earthquakes.json';
*/
DROP TABLE IF EXISTS earthquakes;
CREATE TABLE earthquakes ( 
  title text, 
  quake jsonb 
);

INSERT INTO earthquakes(title,quake)
SELECT e['properties']['title'] :: text AS title, e :: jsonb AS quake
FROM   raw AS r, 
       LATERAL jsonb_path_query(r.data, '$.features[*]') AS e;

--DROP TABLE IF EXISTS raw;
SELECT * FROM earthquakes LIMIT 2;

-- Distance between two positions on earth.
CREATE OR REPLACE FUNCTION haversine(lat_p1 float,
                                     lon_p1 float,
                                     lat_p2 float,
                                     lon_p2 float) RETURNS float AS $$
  SELECT 2 * 6371000 * asin(sqrt(sin(radians(lat_p2 - lat_p1) / 2) ^ 2 +
                                 cos(radians(lat_p1)) *
                                 cos(radians(lat_p2)) *
                                 sin(radians(lon_p2 - lon_p1) / 2) ^ 2)) AS dist;
$$ LANGUAGE SQL IMMUTABLE;

-- query (a)
SELECT e.title, jsonb_array_element(e.quake->'geometry'->'coordinates', 2)::numeric
FROM earthquakes AS e
LIMIT 2;

WITH depth_info(title, depth) AS (
    SELECT e.title, 
            jsonb_array_element(e.quake->'geometry'->'coordinates', 2)::numeric
    FROM earthquakes AS e
)
SELECT depth_info.title AS title, depth_info.depth AS depth
FROM depth_info AS depth_info
where depth_info.depth = (SELECT MAX(d.depth) FROM depth_info AS d)
      OR depth_info.depth = (SELECT MIN(d.depth) FROM depth_info AS d);

-- query (b)
WITH title_date_magn(title, date, magnitude) AS (
    SELECT e.title, 
            to_timestamp((e.quake->'properties'->>'time')::numeric/1000)::date,
            (e.quake->'properties'->>'mag')::numeric
    FROM earthquakes AS e
)

SELECT tdm.title, tdm.date, tdm.magnitude
FROM title_date_magn AS tdm
INNER JOIN (
    SELECT tdm.date AS date, MAX(tdm.magnitude) AS magnitude
    FROM title_date_magn as tdm
    GROUP BY tdm.date
) AS max_magn ON    max_magn.date = tdm.date 
                AND max_magn.magnitude = tdm.magnitude;  

-- query (c)

WITH
dist_from_sand(title, dist) AS (
    SELECT e.title,
            haversine(
    jsonb_array_element(e.quake->'geometry'->'coordinates', 1)::float,
    jsonb_array_element(e.quake->'geometry'->'coordinates', 0)::float,
    48.534542::float,
    9.071296::float
        )
    FROM earthquakes AS e
)
SELECT dfs.title, dfs.dist 
FROM dist_from_sand AS dfs
WHERE dfs.dist = (
    SELECT MIN(dfs_sub.dist)
    FROM dist_from_sand AS dfs_sub
);