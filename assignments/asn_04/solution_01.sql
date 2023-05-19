DROP TABLE IF EXISTS P_SRC;
SELECT p.a, p.b * 2, p.c, p.d, p.e, p.f
FROM (VALUES    (1,'2'::money,4 ,41+1::real,1::real,NULL),
                (2,'5.72' ,1.32,2 ,2 ,NULL),
                (3,'2'::money,5.77,3 ,3 ,NULL)
    ) AS p(a,b,c,d,e,f)
WHERE p.c < 5.5;

DROP TABLE IF EXISTS P;
CREATE TABLE P (
    a int,
    b money,
    c numeric,
    d real,
    e real,
    f text
);

INSERT INTO P VALUES    
        (1,'2',4 ,41+1,1,NULL),
        (2,'5.72' ,1.32,2 ,2 ,NULL),
        (3,'2'::money,5.77,3 ,3 ,NULL);

SELECT p.a, p.b * 2, p.c, p.d, p.e, p.f
FROM P AS p
WHERE p.c < 5.5;