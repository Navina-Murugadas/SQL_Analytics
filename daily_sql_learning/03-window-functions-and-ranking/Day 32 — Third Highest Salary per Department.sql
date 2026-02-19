---------------------------------------------------------------------------------------------
-- GOAL: Find employees with the 3rd highest salary per department.
---------------------------------------------------------------------------------------------
-- If a department has < 3 employees, return the lowest-paid employee.
---------------------------------------------------------------------------------------------
CREATE TABLE emp10(
 [emp_id] [int] NULL,
 [emp_name] [varchar](50) NULL,
 [salary] [int] NULL,
 [manager_id] [int] NULL,
 [emp_age] [int] NULL,
 [dep_id] [int] NULL,
 [dep_name] [varchar](20) NULL,
 [gender] [varchar](10) NULL
) ;
insert into emp10 values(1,'Ankit',14300,4,39,100,'Analytics','Female')
insert into emp10 values(2,'Mohit',14000,5,48,200,'IT','Male')
insert into emp10 values(3,'Vikas',12100,4,37,100,'Analytics','Female')
insert into emp10 values(4,'Rohit',7260,2,16,100,'Analytics','Female')
insert into emp10 values(5,'Mudit',15000,6,55,200,'IT','Male')
insert into emp10 values(6,'Agam',15600,2,14,200,'IT','Male')
insert into emp10 values(7,'Sanjay',12000,2,13,200,'IT','Male')
insert into emp10 values(8,'Ashish',7200,2,12,200,'IT','Male')
insert into emp10 values(9,'Mukesh',7000,6,51,300,'HR','Male')
insert into emp10 values(10,'Rakesh',8000,6,50,300,'HR','Male')
insert into emp10 values(11,'Akhil',4000,1,31,500,'Ops','Male');
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
SELECT * FROM emp10;

WITH Salary_ranking AS (
	SELECT *,
		   RANK() OVER(PARTITION BY dep_id ORDER BY salary DESC)
			AS rnk,
           COUNT(*) OVER(PARTITION BY dep_id) 
			AS Dept_count
	FROM emp10)
SELECT sr.emp_id, sr.emp_name, sr.emp_age, sr.salary, 
       sr.manager_id, sr.dep_id, sr.dep_name, sr.gender
FROM Salary_ranking sr
WHERE rnk = 3
   OR (rnk < 3 AND rnk = Dept_count);