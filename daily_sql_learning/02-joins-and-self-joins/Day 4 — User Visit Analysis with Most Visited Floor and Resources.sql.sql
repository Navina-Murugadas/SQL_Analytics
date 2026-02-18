create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries 
values ('A','Bangalore','A@gmail.com',1,'CPU'),
	   ('A','Bangalore','A1@gmail.com',1,'CPU'),
	   ('A','Bangalore','A2@gmail.com',2,'DESKTOP'),
	   ('B','Bangalore','B@gmail.com',2,'DESKTOP'),
	   ('B','Bangalore','B1@gmail.com',2,'DESKTOP'),
	   ('B','Bangalore','B2@gmail.com',1,'MONITOR');

select * from entries;

-- Goal: For each person: most-visited floor, total visits, and unique resources used.
SELECT name, floor, COUNT(1) as no_of_times_visited
FROM entries
GROUP BY name, floor;

WITH most_visited AS (
SELECT name, floor, COUNT(1) as no_of_times_visited,
	RANK() OVER(PARTITION BY name ORDER BY COUNT(1) DESC) AS rn
FROM entries
GROUP BY name, floor
),
total_no_visits AS (SELECT name, COUNT(1) AS total_visits
					FROM entries
					GROUP BY name),
distinct_resources AS (
	SELECT DISTINCT name, resources
	FROM entries),
resources_used AS (
	SELECT name, STRING_AGG(resources, ',') AS used_resources
	FROM distinct_resources
	GROUP BY name)
SELECT mv.name, floor AS most_visited_floor, total_visits, used_resources
FROM most_visited mv
INNER JOIN total_no_visits tv
	ON mv.name = tv.name
INNER JOIN resources_used ru
	ON mv.name = ru.name
WHERE rn=1;