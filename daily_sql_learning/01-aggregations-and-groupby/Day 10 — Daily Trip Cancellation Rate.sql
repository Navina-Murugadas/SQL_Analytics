---------------------------------------------------------------------------------------------
-- GOAL: Find daily cancellation rate (exclude banned users).
---------------------------------------------------------------------------------------------
Create table  Trips (id int, client_id int, driver_id int, city_id int, status varchar(50), request_at varchar(50));

Create table Users (users_id int, banned varchar(50), role varchar(50));

insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('1', '1', '10', '1', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('3', '3', '12', '6', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('5', '1', '10', '1', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('6', '2', '11', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('7', '3', '12', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('8', '2', '12', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('9', '3', '10', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03');


insert into Users (users_id, banned, role) values ('1', 'No', 'client');
insert into Users (users_id, banned, role) values ('2', 'Yes', 'client');
insert into Users (users_id, banned, role) values ('3', 'No', 'client');
insert into Users (users_id, banned, role) values ('4', 'No', 'client');
insert into Users (users_id, banned, role) values ('10', 'No', 'driver');
insert into Users (users_id, banned, role) values ('11', 'No', 'driver');
insert into Users (users_id, banned, role) values ('12', 'No', 'driver');
insert into Users (users_id, banned, role) values ('13', 'No', 'driver');
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
SELECT * FROM Trips;
SELECT * FROM Users;

SELECT request_at, 
	COUNT(CASE WHEN status IN ('cancelled_by_client', 'cancelled_by_driver')
		 THEN 1 END) AS cancelled_trip_count,
	COUNT(*) AS total_trips,
	(1.0 * COUNT(CASE WHEN status IN ('cancelled_by_client', 'cancelled_by_driver')
		 THEN 1 END)/COUNT(1)) * 100 AS Cancellation_Rate
FROM Trips t
INNER JOIN Users ua
	ON t.client_id = ua.users_id
INNER JOIN Users ub
	ON t.driver_id = ub.users_id
WHERE ua.banned = 'No' AND ub.banned = 'No'
	AND request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY request_at;

------------------------------------------------------------------------------------------------
WITH Trip_users AS (
SELECT request_at AS Day, 
	CASE WHEN status IN ('cancelled_by_client', 'cancelled_by_driver')
		 THEN 1 END AS cancelled_trip_count
FROM Trips t
INNER JOIN Users ua
	ON t.client_id = ua.users_id
INNER JOIN Users ub
	ON t.driver_id = ub.users_id
WHERE ua.banned = 'No' AND ub.banned = 'No'
    AND request_at BETWEEN '2013-10-01' AND '2013-10-03'
)
SELECT Day, ROUND(1.0 * COUNT(cancelled_trip_count)/COUNT(*), 2) AS Cancellation_Rate
FROM Trip_users
GROUP BY Day;