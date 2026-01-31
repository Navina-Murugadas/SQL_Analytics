CREATE TABLE booking_table(
   Booking_id       VARCHAR(3) NOT NULL 
  ,Booking_date     date NOT NULL
  ,User_id          VARCHAR(2) NOT NULL
  ,Line_of_business VARCHAR(6) NOT NULL
);
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b1','2022-03-23','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b2','2022-03-27','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b3','2022-03-28','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b4','2022-03-31','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b5','2022-04-02','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b6','2022-04-02','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b7','2022-04-06','u5','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b8','2022-04-06','u6','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b9','2022-04-06','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b10','2022-04-10','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b11','2022-04-12','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b12','2022-04-16','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b13','2022-04-19','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b14','2022-04-20','u5','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b15','2022-04-22','u6','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b16','2022-04-26','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b17','2022-04-28','u2','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b18','2022-04-30','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b19','2022-05-04','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b20','2022-05-06','u1','Flight');
;
CREATE TABLE user_table(
   User_id VARCHAR(3) NOT NULL
  ,Segment VARCHAR(2) NOT NULL
);
INSERT INTO user_table(User_id,Segment) VALUES ('u1','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u2','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u3','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u4','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u5','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u6','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u7','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u8','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u9','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u10','s3');

SELECT * FROM booking_table;
SELECT * FROM user_table;
---------------------------------------------------------------------------------------------------------

-- Find the no of users made bookings by each segment, & no of users who made flight bookings in the month of Apr 2022.
SELECT u.Segment,
	   COUNT(DISTINCT u.User_id) AS No_of_Users,
	   COUNT(DISTINCT CASE WHEN b.Line_of_business = 'Flight' 
				AND b.Booking_date >= '2022-04-01' AND b.Booking_date < '2022-05-01' 
				THEN b.User_id 
				END) AS No_of_Flight_Booking_Users_April_2022
FROM user_table u
LEFT JOIN booking_table b
	ON u.User_id = b.User_id
GROUP BY u.Segment;

---------------------------------------------------------------------------------------------------------
-- Identify users whose first booking was a hotel booking.
WITH Rank_of_Bookings AS (
SELECT *,
	   RANK() OVER(PARTITION BY User_id ORDER BY Booking_date ASC) AS Booking_Rank
FROM booking_table)
SELECT User_id, Line_of_business, Booking_date, Booking_Rank 
FROM Rank_of_Bookings
WHERE Booking_Rank = 1
  AND Line_of_business = 'Hotel';

-- Using FIRST_VALUE()
WITH Booking_first AS (
SELECT *,
	   FIRST_VALUE(Line_of_business) OVER(PARTITION BY User_id ORDER BY Booking_date ASC) AS First_Booking_LoB
FROM booking_table)
SELECT DISTINCT User_id
FROM Booking_first
WHERE First_Booking_LoB = 'Hotel'

---------------------------------------------------------------------------------------------------------
-- Calculate the days between first & last booking for each user.
SELECT User_id,
	   MIN(Booking_date), MAX(Booking_date),
	   DATEDIFF(DAY, MIN(Booking_date), MAX(Booking_date)) AS Days_Between_First_and_Last_Booking
FROM booking_table
GROUP BY User_id;

---------------------------------------------------------------------------------------------------------
-- Count the number of flight and hotel bookings in each of the user segments for the year 2022.
SELECT Segment,
	   SUM(CASE WHEN b.Line_of_business = 'Flight' 
				  THEN 1 ELSE 0
		     END) AS No_of_Flight_Bookings_2022,
	   SUM(CASE WHEN b.Line_of_business = 'Hotel' 
				  THEN 1 ELSE 0
		     END) AS No_of_Hotel_Bookings_2022
FROM booking_table b
INNER JOIN user_table u
	ON b.User_id = u.User_id
WHERE DATEPART(YEAR, b.Booking_date) = 2022
GROUP BY u.Segment;

---------------------------------------------------------------------------------------------------------