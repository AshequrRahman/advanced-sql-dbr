/*
DROP TABLE IF EXISTS allcards_json;
CREATE TABLE allcards_json (
    data jsonb
);

\copy allcards_json FROM 'assignments/asn_04/ALLCards.json/AllCards.json';

--SELECT * FROM allcards_json;
*/

-- query (a)
DROP TABLE IF EXISTS mtj;
CREATE TABLE mtj (
    name text PRIMARY KEY,
    mana_cost text,
    cmc numeric,
    type text,
    text text,
    power text,
    toughness text
);

SELECT objs.*
FROM jsonb_each((TABLE allcards_json)) AS objs
LIMIT 2;

INSERT INTO mtj
    SELECT  objs.value->>'name', 
            objs.value->>'manaCost',
            (objs.value->>'cmc')::numeric,
            objs.value->>'type',
            objs.value->>'text',
            objs.value->>'power',
            objs.value->>'toughness'
    FROM jsonb_each((TABLE allcards_json)) AS objs;

SELECT * FROM mtj LIMIT 10;

-- query (b)
SELECT m.*
FROM mtj AS m
WHERE  
        (CASE WHEN translate(m.power,'"', '') LIKE '%*%' THEN '0'
            ELSE translate(m.power,'"', '') END) ::numeric > 14
        OR
        (CASE WHEN translate(m.toughness,'"', '') LIKE '%*%' THEN '0'
            ELSE translate(m.toughness,'"', '') END) ::numeric > 14
        OR
        (CASE WHEN translate(m.power,'"', '') LIKE '%*%' THEN '0'
            ELSE translate(m.power,'"', '') END) ::numeric < 
        (CASE WHEN translate(m.toughness,'"', '') LIKE '%*%' THEN '0'
            ELSE translate(m.toughness,'"', '') END) ::numeric
ORDER BY m.cmc DESC NULLS LAST
LIMIT 5;

-- query (c)
SELECT COUNT(*)
FROM mtj AS m
WHERE mana_cost IN ('{U}', '{U}{U}', '{U}{U}{U}');

-- query (d)
SELECT array_to_json(array_agg(row_to_json(m))) :: jsonb
FROM  (
        SELECT m_sub.name
        FROM mtj as m_sub
        WHERE m_sub.text LIKE '%Recover%' AND m_sub.cmc <= 2
    ) AS m(name);

SELECT array_to_json(array_agg(row_to_json(m))) :: jsonb
FROM (
    SELECT (objs.value->'name') AS name
    FROM jsonb_each((TABLE allcards_json)) AS objs
    WHERE objs.value->>'text' LIKE '%Recover%' 
            AND (objs.value->>'cmc')::numeric <= 2
    ) AS m(name)


