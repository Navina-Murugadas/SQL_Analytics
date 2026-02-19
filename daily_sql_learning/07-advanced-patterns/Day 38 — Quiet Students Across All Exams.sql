-------------------------------------------------------------------------------------------------------------------------
-- GOAL: Identify students who are “quiet” in all exams.
-------------------------------------------------------------------------------------------------------------------------
-- Report the students (student_id, student_name) being "quiet" in ALL exams.
-- Quite student - Who took atleast one exam & didn't score neither the high score nor the low score in any of the exams.
-- Don't return the student who has never taken any exam.
-- Return the result table ordered by student_id.
-------------------------------------------------------------------------------------------------------------------------
create table students1
(
student_id int,
student_name varchar(20)
);

insert into students1 values
(1,'Daniel'),(2,'Jade'),(3,'Stella'),(4,'Jonathan'),(5,'Will');

create table exams1
(
exam_id int,
student_id int,
score int);

insert into exams1 values
(10,1,70),(10,2,80),(10,3,90),(20,1,80),(30,1,70),(30,3,80),(30,4,90),(40,1,60)
,(40,2,70),(40,4,80);
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
SELECT * FROM students1;
SELECT * FROM exams1;

WITH Min_Max AS (
	SELECT exam_id,
		   MIN(score) AS Min_Score,
		   MAX(score) AS Max_Score
	FROM exams1
	GROUP BY exam_id),
Qualified AS (
	SELECT e.*, m.Min_Score, m.Max_Score,
		   CASE WHEN score = Min_Score OR
					 score = Max_Score
				THEN 1 ELSE 0
		   END AS Not_qualified
	FROM exams1 e
	INNER JOIN Min_Max m
		ON e.exam_id = m.exam_id)
SELECT q.student_id, s.student_name
FROM Qualified q
INNER JOIN students1 s
	ON q.student_id = s.student_id
GROUP BY q.student_id, s.student_name
HAVING MAX(Not_qualified) = 0
