CREATE table activity
(
user_id varchar(20),
event_name varchar(20),
event_date date,
country varchar(20)
);
delete from activity;
insert into activity values (1,'app-installed','2022-01-01','India')
,(1,'app-purchase','2022-01-02','India')
,(2,'app-installed','2022-01-01','USA')
,(3,'app-installed','2022-01-01','USA')
,(3,'app-purchase','2022-01-03','USA')
,(4,'app-installed','2022-01-03','India')
,(4,'app-purchase','2022-01-03','India')
,(5,'app-installed','2022-01-03','SL')
,(5,'app-purchase','2022-01-03','SL')
,(6,'app-installed','2022-01-04','Pakistan')
,(6,'app-purchase','2022-01-04','Pakistan');

SELECT * FROM activity;
---------------------------------------------------------------------------------------------------------
-- 1) Find total active users each day:
SELECT event_date, 
	   COUNT(DISTINCT user_id) AS active_users
FROM activity
GROUP BY event_date;

---------------------------------------------------------------------------------------------------------
-- 2) Find total active users each week:
SELECT DATEPART(WEEK, event_date) AS Week_no,
	   COUNT(DISTINCT user_id) AS active_users
FROM activity
GROUP BY DATEPART(WEEK, event_date);

---------------------------------------------------------------------------------------------------------
-- 3) Find total number of users datewise, who made the purchase and installed the app same date.
WITH dist_events AS (
	SELECT user_id, event_date, 
		   COUNT(DISTINCT event_name) AS Distinct_events
	FROM activity
	GROUP BY user_id, event_date
	HAVING COUNT(DISTINCT event_name) = 2),
dist_dates AS (
	SELECT DISTINCT event_date
	FROM activity
)
SELECT dd.event_date, 
       COUNT(de.user_id) AS Distinct_events
FROM dist_events de
RIGHT JOIN dist_dates dd
	ON dd.event_date = de.event_date
GROUP BY dd.event_date;

---------------------------------------------------------------------------------------------------------
-- 4) Percentage of paid users in India, USA, and any other country should be tagged as Others
WITH Users_paid AS (
	SELECT CASE WHEN country IN ('India', 'USA')
			    THEN country
			    ELSE 'Others'
			    END AS Country,
	   COUNT(DISTINCT user_id) AS P_users
	FROM activity
	WHERE event_name = 'app-purchase'
	GROUP BY CASE WHEN country IN ('India', 'USA')
			    THEN country
			    ELSE 'Others'
			    END),
Users_paidTotal AS (
	SELECT SUM(P_users) AS Pd_users
	FROM Users_paid)
SELECT Country,
	   (1.0*P_users/Pd_users)*100 AS 'Paid_users %'
FROM Users_paid, Users_paidTotal;

---------------------------------------------------------------------------------------------------------
-- 5) Among all the users who installed the app on the given day, how many did purchase the very next day
WITH prev_records AS (
		SELECT *,
	   LAG(event_name, 1) 
		OVER(PARTITION BY user_id
			 ORDER BY event_date)
	    AS prev_event,
	   LAG(event_date, 1)
		OVER(PARTITION BY user_id
			 ORDER BY event_date)
		AS prev_date
	FROM activity),
all_dates AS (
	SELECT DISTINCT event_date
	FROM activity),
finalized_users AS (
	SELECT event_date,
	   COUNT(DISTINCT user_id) AS Count
	FROM prev_records
	WHERE event_name = 'app-purchase'
		AND prev_event = 'app-installed'
		AND DATEDIFF(DAY, prev_date, event_date) = 1
	GROUP BY event_date)
SELECT ad.event_date, 
	   ISNULL(fu.Count, 0) AS User_count
FROM finalized_users fu
RIGHT JOIN all_dates ad
	ON ad.event_date = fu.event_date;

---------------------------------------------------------------------------------------------------------


