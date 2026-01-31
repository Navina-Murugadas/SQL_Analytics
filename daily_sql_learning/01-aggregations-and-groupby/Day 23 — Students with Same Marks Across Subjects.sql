create table exams (student_id int, subject varchar(20), marks int);
delete from exams;
insert into exams values (1,'Chemistry',91),(1,'Physics',91)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80)
,(4,'Chemistry',71),(4,'Physics',54);

SELECT * FROM exams;

-- Find students with same marks in Chemistry and Physics
SELECT student_id
FROM exams
WHERE subject IN ('Chemistry', 'Physics')
GROUP BY student_id
HAVING COUNT(DISTINCT subject) = 2
   AND COUNT(DISTINCT marks) = 1;