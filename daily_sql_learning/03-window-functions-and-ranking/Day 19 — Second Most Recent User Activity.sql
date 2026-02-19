---------------------------------------------------------------------------------------------
-- GOAL: Get each user’s 2nd latest activity.  If a user has only one activity - return that.
---------------------------------------------------------------------------------------------
create table UserActivity
(
username      varchar(20) ,
activity      varchar(20),
startDate     Date   ,
endDate      Date
);

insert into UserActivity values 
('Alice','Travel','2020-02-12','2020-02-20')
,('Alice','Dancing','2020-02-21','2020-02-23')
,('Alice','Travel','2020-02-24','2020-02-28')
,('Bob','Travel','2020-02-11','2020-02-18');
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
SELECT * FROM UserActivity;

WITH ranking AS (
	SELECT *, 
	   COUNT(*) OVER(PARTITION BY username) 
			AS total_activities,
	   RANK() OVER(PARTITION BY username
				   ORDER BY startDate DESC)
			AS rnk
	FROM UserActivity )
SELECT *
FROM ranking
WHERE total_activities = 1 
	OR rnk = 2;