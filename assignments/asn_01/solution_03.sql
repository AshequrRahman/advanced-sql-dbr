-- create the table
DROP TABLE IF EXISTS production;
CREATE TABLE production (
    item char(20) NOT NULL,
    step int NOT NULL,
    completion timestamp, -- NULL means incomplete
    PRIMARY KEY (item, step));

INSERT INTO production VALUES
    ('TIE', 1, '1977/03/02 04:12'),
    ('TIE', 2, '1977/12/29 05:55'),
    ('AT-AT', 1, '1978/01/03 14:12'),
    ('AT-AT', 2, NULL),
    ('DSII', 1, NULL),
    ('DSII', 2, '1979/05/26 20:05'),
    ('DSII', 3, '1979/04/04 17:12');

TABLE production;

-- query
SELECT p.item AS item
FROM production AS p
GROUP BY p.item
HAVING EVERY(p.completion IS NOT NULL); 