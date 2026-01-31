create table call_details  (
call_type varchar(10),
call_number varchar(12),
call_duration int
);

insert into call_details
values ('OUT','181868',13),('OUT','2159010',8)
,('OUT','2159010',178),('SMS','4153810',1),('OUT','2159010',152),('OUT','9140152',18),('SMS','4162672',1)
,('SMS','9168204',1),('OUT','9168204',576),('INC','2159010',5),('INC','2159010',4),('SMS','2159010',1)
,('SMS','4535614',1),('OUT','181868',20),('INC','181868',54),('INC','218748',20),('INC','2159010',9)
,('INC','197432',66),('SMS','2159010',1),('SMS','4535614',1);

SELECT * FROM call_details;

/* 
Write a SQL query to determine the phone numbers that satisfy the below conditions:
1) The number has both incoming and outgoing calls
2) The sum of duration of outgoing calls should be greater than the sum of duration of incoming calls.
*/

-- Using CTE and Filter:
WITH Inc_Out_Calls AS (
	SELECT call_number,
		   SUM(CASE WHEN call_type = 'OUT' THEN call_duration ELSE NULL END)
			AS Outgoing_calls,
		   SUM(CASE WHEN call_type = 'INC' THEN call_duration ELSE NULL END)
			AS Incoming_calls
	FROM call_details
	GROUP BY call_number)
SELECT call_number
FROM Inc_Out_Calls
WHERE Outgoing_calls IS NOT NULL
  AND Incoming_calls IS NOT NULL
  AND Outgoing_calls > Incoming_calls;


-- Using HAVING clause:
SELECT call_number
FROM call_details
GROUP BY call_number
HAVING SUM(CASE WHEN call_type = 'OUT' THEN call_duration ELSE NULL END) > 0
   AND SUM(CASE WHEN call_type = 'INC' THEN call_duration ELSE NULL END) > 0
   AND SUM(CASE WHEN call_type = 'OUT' THEN call_duration ELSE NULL END) > 
          SUM(CASE WHEN call_type = 'INC' THEN call_duration ELSE NULL END);


-- Using CTE and JOIN:
WITH Outgoing_calls AS (
	SELECT call_number,
		   SUM(call_duration) AS Out_duration
	FROM call_details
	WHERE call_type = 'OUT'
	GROUP BY call_number),
Incoming_calls AS (
	SELECT call_number,
		   SUM(call_duration) AS Inc_duration
	FROM call_details
	WHERE call_type = 'INC'
	GROUP BY call_number)
SELECT oc.call_number
FROM Outgoing_calls oc
INNER JOIN Incoming_calls ic
	ON oc.call_number = ic.call_number
WHERE oc.Out_duration > ic.Inc_duration;
 