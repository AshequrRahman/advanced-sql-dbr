-- query 1a
-- create table
DROP TABLE IF EXISTS measurements;
CREATE TABLE measurements(
    id serial PRIMARY KEY,
    t numeric,
    m numeric
);

INSERT INTO measurements(t, m) VALUES
    (1,1),
    (1,3),
    (1,5),
    (1,5),
    (2.5,0.8),
    (2.5,2),
    (4,0.5),
    (5.5,3.0),
    (8,2.0),
    (8,6.0),
    (8,8.0),
    (10.5,1),
    (10.5,3),
    (10.5,8);

TABLE measurements;


-- query 1b
SELECT MAX(m.m) AS MaxMeas
FROM measurements AS m
GROUP BY m.t;

-- query 1c
SELECT m.t, AVG(m.m) AS AvgMeas
FROM measurements AS m
GROUP BY m.t;

-- query 1d
SELECT FLOOR(m.t / 5) AS TimeFrame, AVG(m.m) AS AvgMeas
FROM measurements AS m
GROUP BY FLOOR(m.t / 5);

-- query 1e
SELECT m.t, m.m
FROM measurements AS m
WHERE m.m = (
            SELECT MAX(m1.m) AS max_val
            FROM measurements AS m1
        );

