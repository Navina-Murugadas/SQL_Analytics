---------------------------------------------------------------------------------------------
-- GOAL: Identify seat numbers that are part of 3 continuous empty seats (Y).
---------------------------------------------------------------------------------------------
create table bms (seat_no int ,is_empty varchar(10));
insert into bms values
(1,'N')
,(2,'Y')
,(3,'N')
,(4,'Y')
,(5,'Y')
,(6,'Y')
,(7,'N')
,(8,'Y')
,(9,'Y')
,(10,'Y')
,(11,'Y')
,(12,'N')
,(13,'Y')
,(14,'Y');
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
SELECT * FROM bms;

-- Using Lead/Lag:
WITH emptiness AS (
	SELECT *,
	   LAG(is_empty, 1) OVER(ORDER BY seat_no) AS prev_1,
	   LAG(is_empty, 2) OVER(ORDER BY seat_no) AS prev_2,
	   LEAD(is_empty, 1) OVER(ORDER BY seat_no) AS next_1,
	   LEAD(is_empty, 2) OVER(ORDER BY seat_no) AS next_2
	FROM bms)
SELECT seat_no
FROM emptiness
WHERE is_empty = 'Y' AND prev_1 = 'Y' AND prev_2 = 'Y'
   OR is_empty = 'Y' AND prev_1 = 'Y' AND next_1 = 'Y'
   OR is_empty = 'Y' AND next_1 = 'Y' AND next_2 = 'Y';

---------------------------------------------------------------------------------------------
-- Using CASE WHEN:
WITH emptiness AS (
	SELECT *,
		SUM(CASE WHEN is_empty = 'Y' THEN 1 ELSE 0 END)
				OVER(ORDER BY seat_no
				ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
				AS prev_2,
		SUM(CASE WHEN is_empty = 'Y' THEN 1 ELSE 0 END)
				OVER(ORDER BY seat_no
				ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) 
				AS prev_next,
		SUM(CASE WHEN is_empty = 'Y' THEN 1 ELSE 0 END)
				OVER(ORDER BY seat_no
				ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING)
				AS next_2
	FROM bms)
SELECT seat_no
FROM emptiness
WHERE prev_2 = 3 OR prev_next = 3 OR next_2 = 3;

---------------------------------------------------------------------------------------------
-- Using ROW_NUMBER:
WITH Row_No AS (
	SELECT *,
	   ROW_NUMBER() OVER(ORDER BY is_empty ASC)
			AS rownum,
	   seat_no - ROW_NUMBER() OVER(ORDER BY is_empty)
			AS diff_ro
	FROM bms
	WHERE is_empty = 'Y')
SELECT seat_no
FROM Row_No
WHERE diff_ro IN (
	SELECT diff_ro
	FROM Row_no
	GROUP BY diff_ro
	HAVING COUNT(*) >= 3); 
