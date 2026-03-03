----------------------------------------------------------------------------------------------------
-- GOAL: Merge overlapping event date ranges for each hall and return consolidated booking periods.
----------------------------------------------------------------------------------------------------
create table hall_events
(
hall_id integer,
start_date date,
end_date date
);
delete from hall_events
insert into hall_events values 
(1,'2023-01-13','2023-01-14')
,(1,'2023-01-14','2023-01-17')
,(1,'2023-01-15','2023-01-17')
,(1,'2023-01-18','2023-01-25')
,(2,'2022-12-09','2022-12-23')
,(2,'2022-12-13','2022-12-17')
,(3,'2022-12-01','2023-01-30');
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
SELECT * FROM hall_events;

WITH eventid AS (
	SELECT *,
		   ROW_NUMBER() OVER(ORDER BY hall_id, start_date) AS event_id
	FROM hall_events
),
overlap_rec AS (
	SELECT hall_id, start_date, end_date, event_id, 1 AS overlap_flag
	FROM eventid e
	WHERE event_id = 1

	UNION ALL

	SELECT e.hall_id, e.start_date, e.end_date, e.event_id,
		   CASE WHEN e.hall_id = o.hall_id
				AND (o.start_date BETWEEN e.start_date AND e.end_date
						OR e.start_date BETWEEN o.start_date AND o.end_date)
				THEN 0 ELSE 1 
			END + overlap_flag AS overlap_flag
	FROM overlap_rec o
	INNER JOIN eventid e
			ON o.event_id + 1 = e.event_id
)
SELECT hall_id, MIN(start_date) AS start_date, MAX(end_date) AS end_date, overlap_flag AS merge_flag
FROM overlap_rec
GROUP BY hall_id, overlap_flag;