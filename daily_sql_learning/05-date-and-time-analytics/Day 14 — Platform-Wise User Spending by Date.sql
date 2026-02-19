-------------------------------------------------------------------------------------------------------------------
-- GOAL: Per day - Count users + spend by mobile only, desktop only, and both.
-------------------------------------------------------------------------------------------------------------------
/*
-- USER PURCHASE PLATFORM
-- The table logs the spending history of users that make purchases from an online shopping website.
-- Write a SQL query to find the total number of users and total amount spent using mobile only, desktop only and
   both mobile and desktop together for each date. 
*/
-------------------------------------------------------------------------------------------------------------------
create table spending 
(
user_id int,
spend_date date,
platform varchar(10),
amount int
);

insert into spending 
values(1,'2019-07-01','mobile',100),
	  (1,'2019-07-01','desktop',100),
	  (2,'2019-07-01','mobile',100),
	  (2,'2019-07-02','mobile',100),
	  (3,'2019-07-01','desktop',100),
	  (3,'2019-07-02','desktop',100);
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
SELECT * FROM spending;

WITH platforms AS (
	SELECT spend_date, user_id,
		MAX(platform) AS platform,
		SUM(amount) AS amt
	FROM spending
	GROUP BY user_id, spend_date
	HAVING(COUNT(DISTINCT platform)) = 1
	UNION ALL
	SELECT spend_date, user_id, 'both' AS platform, SUM(amount) AS amt
	FROM spending
	GROUP BY user_id, spend_date
	HAVING(COUNT(DISTINCT platform)) = 2
	UNION ALL
	SELECT DISTINCT spend_date, NULL AS user_id, 'both' AS platform, 0 AS amt
	FROM spending
)
SELECT spend_date, platform, 
	SUM(amt) AS total_amount,
	COUNT(DISTINCT user_id) AS total_users
FROM platforms p
GROUP BY spend_date, platform
ORDER BY spend_date, platform DESC;
