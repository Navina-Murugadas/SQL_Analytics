CREATE TABLE STORES (
Store varchar(10),
Quarter varchar(10),
Amount int);

INSERT INTO STORES (Store, Quarter, Amount)
VALUES ('S1', 'Q1', 200),
('S1', 'Q2', 300),
('S1', 'Q4', 400),
('S2', 'Q1', 500),
('S2', 'Q3', 600),
('S2', 'Q4', 700),
('S3', 'Q1', 800),
('S3', 'Q2', 750),
('S3', 'Q3', 900);

SELECT * FROM STORES;

-- Find the missing quarter.

-- Using CAST & GROUP BY:
SELECT Store,
	   'Q'+ CAST(10 - SUM(CAST(RIGHT(Quarter, 1) AS INT)) AS CHAR(2)) AS Q_no
FROM STORES
GROUP BY Store;

-- Using RECURSIVE CTE:
WITH quar AS (
	SELECT DISTINCT Store, 1 AS Q_no
	FROM STORES
	UNION ALL
	SELECT Store, Q_no + 1 AS Q_no
	FROM quar
	WHERE Q_no < 4),
quarts AS (
	SELECT Store, 'Q' + CAST(Q_no AS CHAR(1)) AS Q_no
	FROM quar)
SELECT qu.* 
FROM quarts qu
LEFT JOIN STORES S
	ON qu.Store = S.Store
	AND qu.Q_no = S.Quarter
WHERE S.Store IS NULL
ORDER BY Store;

-- Using CROSS JOIN:
WITH quarters AS (
	SELECT DISTINCT s1.Store, s2.Quarter AS Q_no
	FROM STORES s1, STORES s2)
SELECT q.Store, q.Q_no
FROM quarters q
LEFT JOIN STORES s
	ON q.Store = s.Store
	AND q.Q_no = s.Quarter
WHERE s.Quarter IS NULL;