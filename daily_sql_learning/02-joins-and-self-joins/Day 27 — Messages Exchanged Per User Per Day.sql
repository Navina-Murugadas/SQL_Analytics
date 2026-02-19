---------------------------------------------------------------------------------------------
-- GOAL: Find the total number of messages exchanged per day between each pair of users
---------------------------------------------------------------------------------------------
-- AMAZON SQL INTERVIEW QUESTION FOR BIE POSITION
-- Regardless of sender/receiver direction.
---------------------------------------------------------------------------------------------
CREATE TABLE subscriber (
 sms_date date ,
 sender varchar(20) ,
 receiver varchar(20) ,
 sms_no int
);
-- insert some values
INSERT INTO subscriber VALUES ('2020-4-1', 'Avinash', 'Vibhor',10);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Avinash',20);
INSERT INTO subscriber VALUES ('2020-4-1', 'Avinash', 'Pawan',30);
INSERT INTO subscriber VALUES ('2020-4-1', 'Pawan', 'Avinash',20);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Pawan',5);
INSERT INTO subscriber VALUES ('2020-4-1', 'Pawan', 'Vibhor',8);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Deepak',50);
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
SELECT * FROM subscriber;

WITH sorted_SR AS (
	SELECT *,
		   CASE WHEN sender < receiver THEN sender ELSE receiver
			END AS Sent_by,
		   CASE WHEN sender > receiver THEN sender ELSE receiver
			END AS Received_by
	FROM subscriber)
SELECT sms_date, Sent_by, Received_by,
	   SUM(sms_no) AS Total_msgs
FROM sorted_SR
GROUP BY sms_date, Sent_by, Received_by;