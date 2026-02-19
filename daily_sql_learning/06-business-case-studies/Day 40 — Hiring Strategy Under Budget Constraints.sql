---------------------------------------------------------------------------------------------------
-- GOAL: Hire employees under a fixed budget, prioritizing lowest-paid seniors first, then juniors.
---------------------------------------------------------------------------------------------------
/*
A company wants to hire new employees.  The budget of the company for the salaries is $70000.
The company's criteria for hiring are:
Keep hiring the senior with the smallest salary until you cannot hire any more seniors.
Use the remaining budget to hire the junior with the smallest salary.
Keep hiring the junior with the smallest salary until you cannot hire any more juniors.
Find the seniors and juniors hired under the given conditions.
*/
---------------------------------------------------------------------------------------------------
create table candidates (emp_id int, experience varchar(20), salary int);
insert into candidates values
(1,'Junior',10000),(2,'Junior',15000),(3,'Junior',40000),
(4,'Senior',16000),(5,'Senior',20000),(6,'Senior',50000);
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
SELECT * FROM candidates;

WITH Running_salary AS (
	SELECT *,
		   SUM(salary) OVER(PARTITION BY experience ORDER BY salary ASC) AS running_sal
	FROM candidates),
Seniors AS (
	SELECT *
	FROM Running_salary
	WHERE experience = 'Senior'
	  AND running_sal <= 70000)
SELECT *
FROM Seniors
UNION ALL
SELECT * 
FROM Running_salary
WHERE experience = 'Junior' 
AND running_sal <= 70000 - (SELECT SUM(salary) FROM Seniors);