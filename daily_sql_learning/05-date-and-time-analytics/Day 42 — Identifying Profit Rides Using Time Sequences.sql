----------------------------------------------------------------------------------------------------------------------
-- GOAL: Find total rides and profit rides for each driver.
----------------------------------------------------------------------------------------------------------------------
-- Profit ride = End location matches next ride’s start.
----------------------------------------------------------------------------------------------------------------------
create table drivers(id varchar(10), start_time time, end_time time, start_loc varchar(10), end_loc varchar(10));
insert into drivers 
values('dri_1', '09:00', '09:30', 'a','b'),('dri_1', '09:30', '10:30', 'b','c'),
	  ('dri_1','11:00','11:30', 'd','e'),('dri_1', '12:00', '12:30', 'f','g'),
	  ('dri_1', '13:30', '14:30', 'c','h'),('dri_2', '12:15', '12:30', 'f','g'),('dri_2', '13:30', '14:30', 'c','h');
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
SELECT * FROM drivers;

-- Using LEAD
WITH Next_starting_location AS (
	SELECT *,
		   LEAD(start_loc, 1) OVER(PARTITION BY id ORDER BY start_time ASC)
			AS Next_start_loc
	FROM drivers)
SELECT id, COUNT(*) AS Total_rides,
	   SUM(CASE WHEN end_loc = Next_start_loc THEN 1 ELSE 0
			END) AS Profit_rides
FROM Next_starting_location
GROUP BY id;

----------------------------------------------------------------------------------------------------------------------
-- Using SELF JOIN
WITH Row_numbers AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY id ORDER BY start_time ASC) 
			AS row_no
	FROM drivers)
SELECT r1.id, COUNT(*) AS Total_rides,
	   COUNT(r2.id) AS Profit_rides
FROM Row_numbers r1
LEFT JOIN Row_numbers r2
	ON r1.id = r2.id
	AND r1.end_loc = r2.start_loc
	AND r1.row_no + 1 = r2.row_no
GROUP BY r1.id;
