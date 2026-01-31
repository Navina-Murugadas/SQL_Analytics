create table users_prime
(
user_id integer,
name varchar(20),
join_date date
);
insert into users_prime
values (1, 'Jon', CAST('2-14-20' AS date)), 
(2, 'Jane', CAST('2-14-20' AS date)), 
(3, 'Jill', CAST('2-15-20' AS date)), 
(4, 'Josh', CAST('2-15-20' AS date)), 
(5, 'Jean', CAST('2-16-20' AS date)), 
(6, 'Justin', CAST('2-17-20' AS date)),
(7, 'Jeremy', CAST('2-18-20' AS date));

create table events_prime
(
user_id integer,
type varchar(10),
access_date date
);

insert into events_prime values
(1, 'Pay', CAST('3-1-20' AS date)), 
(2, 'Music', CAST('3-2-20' AS date)), 
(2, 'P', CAST('3-12-20' AS date)),
(3, 'Music', CAST('3-15-20' AS date)), 
(4, 'Music', CAST('3-15-20' AS date)), 
(1, 'P', CAST('3-16-20' AS date)), 
(3, 'P', CAST('3-22-20' AS date));

SELECT * FROM users_prime;
SELECT * FROM events_prime;

/*
-- Amazon Prime Subscription Rate
Given the following two tables, return the fraction of users, rounded to decimal places,
who accessed Amazon Music and upgraded to Prime membership within the first 30 days of signing up.
*/

/* SELECT u.*, e.type, e.access_date,
	   DATEDIFF(DAY, join_date, access_date) AS Date_diff, */
SELECT
	COUNT(DISTINCT u.user_id) AS Distinct_users,
	COUNT(DISTINCT
		  CASE WHEN DATEDIFF(DAY, join_date, access_date) <= 30
			   THEN u.user_id
			   END ) AS Opted_prime,
	1.0 * COUNT(DISTINCT CASE WHEN DATEDIFF(DAY, join_date, access_date) <= 30 THEN u.user_id END)/
		COUNT(DISTINCT u.user_id) * 100 AS Ratio_AMusic
FROM users_prime u
LEFT JOIN events_prime e
	ON u.user_id = e.user_id
	AND e.type = 'P'
WHERE u.user_id IN (
	SELECT user_id
	FROM events_prime
	WHERE type = 'Music'
)
