DROP TABLE IF EXISTS t;
CREATE TABLE t (
        x int NOT NULL,
        y int NOT NULL
    );
INSERT INTO t VALUES
    (2,1),(5,3),(6,4),(7,6),(9,9);  

DROP TABLE IF EXISTS p;
CREATE TABLE p (
        val int NOT NULL
    );

INSERT INTO p VALUES
    (4),(5),(7),(8),(9);

-- query 1
SELECT t.x AS x
FROM t as t
WHERE t.x IN (
    SELECT p.val AS val
    FROM p AS p
    WHERE p.val > 5
);


WITH 
p_val_more_than_5(val) AS (
    SELECT p.val AS val
    FROM p AS p
    WHERE p.val > 5
)
SELECT t.x AS x
FROM t as t
WHERE t.x IN (SELECT val FROM p_val_more_than_5);

-- query 2
SELECT t.x AS x
FROM t AS t
WHERE t.x IN
    (
        SELECT p.val
        FROM p
        WHERE p.val > t.y
    );
