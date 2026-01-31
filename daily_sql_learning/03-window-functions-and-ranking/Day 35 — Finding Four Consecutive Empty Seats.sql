create table movie(
seat varchar(50),occupancy int
);
insert into movie values('a1',1),('a2',1),('a3',0),('a4',0),('a5',0),('a6',0),('a7',1),('a8',1),('a9',0),('a10',0),
('b1',0),('b2',0),('b3',0),('b4',1),('b5',1),('b6',1),('b7',1),('b8',0),('b9',0),('b10',0),
('c1',0),('c2',1),('c3',0),('c4',1),('c5',1),('c6',0),('c7',1),('c8',0),('c9',0),('c10',1);

SELECT * FROM movie;

-- There are 3 rows in a movie hall, each with 10 seats in a row.
-- Find 4 consecutive empty seats.
WITH row_seat_ID AS (
	SELECT *,
		   LEFT(seat,1) AS row_id,
		   CAST(SUBSTRING(seat,2,2) AS INT) AS seat_id
	FROM movie),
empty_seats AS (
	SELECT *,
		   MAX(occupancy) OVER(PARTITION BY row_id ORDER BY seat_id
								ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING) 
								AS if_empty,
		   COUNT(occupancy) OVER(PARTITION BY row_id ORDER BY seat_id
								  ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING)
								  AS no_of_empty
	FROM row_seat_ID),
first_empty AS (
	SELECT *
	FROM empty_seats
	WHERE if_empty = 0 
		  AND no_of_empty = 4)
SELECT e.seat, e.occupancy
FROM empty_seats e
INNER JOIN first_empty f
	ON e.row_id = f.row_id
	AND e.seat_id BETWEEN f.seat_id AND f.seat_id + 3;