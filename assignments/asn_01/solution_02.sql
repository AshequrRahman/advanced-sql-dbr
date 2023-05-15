DROP TABLE IF EXISTS R;
CREATE TABLE R(
    a int,
    b int,
    PRIMARY KEY (a,b)
);
INSERT INTO R(a, b) VALUES
    (1, 1),
    (1, 2),
    (1, 4),
    (2, 5),
    (2, 3);

TABLE R;

-- Query 1
SELECT r.a, COUNT(*) AS c
FROM R AS r
WHERE r.b <> 3
GROUP BY r.a;


-- Query 2
SELECT r.a, COUNT(*) AS c
FROM R AS r
GROUP BY r.a
HAVING EVERY(r.b <> 3);