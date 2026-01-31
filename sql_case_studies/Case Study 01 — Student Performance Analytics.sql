CREATE TABLE [students](
 [studentid] [int] NULL,
 [studentname] [nvarchar](255) NULL,
 [subject] [nvarchar](255) NULL,
 [marks] [int] NULL,
 [testid] [int] NULL,
 [testdate] [date] NULL
)
data:
insert into students values (2,'Max Ruin','Subject1',63,1,'2022-01-02');
insert into students values (3,'Arnold','Subject1',95,1,'2022-01-02');
insert into students values (4,'Krish Star','Subject1',61,1,'2022-01-02');
insert into students values (5,'John Mike','Subject1',91,1,'2022-01-02');
insert into students values (4,'Krish Star','Subject2',71,1,'2022-01-02');
insert into students values (3,'Arnold','Subject2',32,1,'2022-01-02');
insert into students values (5,'John Mike','Subject2',61,2,'2022-11-02');
insert into students values (1,'John Deo','Subject2',60,1,'2022-01-02');
insert into students values (2,'Max Ruin','Subject2',84,1,'2022-01-02');
insert into students values (2,'Max Ruin','Subject3',29,3,'2022-01-03');
insert into students values (5,'John Mike','Subject3',98,2,'2022-11-02');

SELECT * FROM students;
---------------------------------------------------------------------------------------------------------
-- 1) Get the list of students who scored above the average marks in each subject.
WITH Average_Marks AS (
	SELECT subject, AVG(marks) AS Avg_marks
	FROM students
	GROUP BY subject)
SELECT *
FROM students s
INNER JOIN Average_Marks am
	ON s.subject = am.subject
	AND s.marks > am.Avg_marks;

---------------------------------------------------------------------------------------------------------
-- 2) Get the percentage of students who scored more than 90 in any subject amongst all the students.
WITH Above90 AS (
	SELECT COUNT(DISTINCT CASE WHEN marks > 90 
						THEN studentid END) AS Student_cnt,
		   COUNT(DISTINCT studentid) AS Total_students
	FROM students)
SELECT (1.0*Student_cnt/Total_students)*100 AS Percentage_Above90
FROM Above90;

---------------------------------------------------------------------------------------------------------
-- 3) Get the second highest and second lowest marks for each subject.
WITH marks_rnk AS (
	SELECT *,
		   RANK() OVER(PARTITION BY subject 
						ORDER BY marks ASC) AS rnk_asc,
		   RANK() OVER(PARTITION BY subject
						ORDER BY marks DESC) AS rnk_desc
	FROM students)
SELECT subject,
	   SUM(CASE WHEN rnk_desc = 2 THEN marks ELSE NULL
			END) AS second_highest_mark,
	   SUM(CASE WHEN rnk_asc = 2 THEN marks ELSE NULL
			END) AS second_lowest_mark
FROM marks_rnk
GROUP BY subject;

---------------------------------------------------------------------------------------------------------
-- 4) For each student and test, identify if their marks increased or decreased from previous test.
WITH compare_marks AS (
	SELECT *,
		   LAG(marks,1) OVER(PARTITION BY studentid
								ORDER BY testdate, subject)
				AS prev_marks
	FROM students)
SELECT *,
	   CASE WHEN marks > prev_marks THEN 'Increased' 
	        WHEN marks < prev_marks THEN 'Decreased'
			ELSE 'No changes'
	   END AS Performance_status
FROM compare_marks;

---------------------------------------------------------------------------------------------------------