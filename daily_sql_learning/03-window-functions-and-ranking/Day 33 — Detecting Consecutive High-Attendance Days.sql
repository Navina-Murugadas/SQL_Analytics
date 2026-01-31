create table stadium (
id int,
visit_date date,
no_of_people int
);

insert into stadium
values (1,'2017-07-01',10)
,(2,'2017-07-02',109)
,(3,'2017-07-03',150)
,(4,'2017-07-04',99)
,(5,'2017-07-05',145)
,(6,'2017-07-06',1455)
,(7,'2017-07-07',199)
,(8,'2017-07-08',188);

SELECT * FROM stadium;

-- Display the records which have 3 or more consecutive rows
-- With the amount of people more than 100(inclusive) each day
WITH Grouping_ppl AS (
	SELECT *,
		   ROW_NUMBER() OVER(ORDER BY visit_date ASC)
			AS visit_order,
		   id - ROW_NUMBER() OVER(ORDER BY visit_date ASC) 
			AS diff
	FROM stadium
	WHERE no_of_people >= 100)
SELECT id, visit_date, no_of_people
FROM Grouping_ppl
WHERE diff IN (
	SELECT diff
	FROM Grouping_ppl
	GROUP BY diff
	HAVING COUNT(*) >= 3);
