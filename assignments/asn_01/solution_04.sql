-- query (a)
DROP TABLE IF EXISTS A;
CREATE TABLE A (
    row int,
    col int,
    val int,
    PRIMARY KEY(row, col));

DROP TABLE IF EXISTS B;
CREATE TABLE B ( LIKE A );

INSERT INTO A (row,col,val)
    VALUES  
        (1,1,1), 
        (1,2,2),
        (2,1,3), 
        (2,2,4);

INSERT INTO B (row,col,val)
    VALUES      
        (1,1,1), 
        (1,2,2), 
        (1,3,1),
        (2,1,2), 
        (2,2,1), 
        (2,3,2);

TABLE A;
TABLE B;

-- matrix multiplication
SELECT a.row AS row, b.col AS col, SUM(a.val*b.val) AS val
FROM A AS a, B AS b
WHERE a.col = b.row
GROUP BY a.row, b.col
ORDER BY a.row, b.col;


-- query (b)
DROP TABLE IF EXISTS A_sparse;
CREATE TABLE A_sparse (
    row int,
    col int,
    val int,
    PRIMARY KEY(row, col));

DROP TABLE IF EXISTS B_sparse;
CREATE TABLE B_sparse ( LIKE A_sparse );

INSERT INTO A_sparse (row,col,val)
    VALUES  
        (1,1,1), 
        (1,2,3),
        (2,3,7);

INSERT INTO B_sparse (row,col,val)
    VALUES      
        (1,1,4), 
        (1,3,8),
        (2,1,1), 
        (2,2,1), 
        (2,3,10),
        (3,1,3),
        (3,2,6);


SELECT a.row AS row, b.col AS col, SUM(a.val*b.val) AS val
FROM A_sparse AS a, B_sparse AS b
WHERE a.col = b.row
GROUP BY a.row, b.col
ORDER BY a.row, b.col;