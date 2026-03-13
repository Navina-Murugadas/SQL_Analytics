----------------------------------------------------------------------------------------------------------------------
-- GOAL: Find departments whose average salary is lower than the average salary of employees in all other departments.
----------------------------------------------------------------------------------------------------------------------
create table empl(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
emp_age int);

insert into empl
values
(1, 'Ankit', 100,10000, 4, 39),
(2, 'Mohit', 100, 15000, 5, 48),
(3, 'Vikas', 100, 10000,4,37),
(4, 'Rohit', 100, 5000, 2, 16),
(5, 'Mudit', 200, 12000, 6,55),
(6, 'Agam', 200, 12000,2, 14),
(7, 'Sanjay', 200, 9000, 2,13),
(8, 'Ashish', 200,5000,2,12),
(9, 'Mukesh',300,6000,6,51),
(10, 'Rakesh',300,7000,6,50);
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
SELECT * FROM empl;

WITH emp_agg AS (
	SELECT department_id, AVG(salary) AS dep_avg, 
	   COUNT(*) AS no_of_emp,
	   SUM(salary) AS sum_sal
	FROM empl
	GROUP BY department_id
),
average_salary AS (
	SELECT e1.department_id, e1.dep_avg,
		   SUM(e2.no_of_emp) AS num_of_emp, 
		   SUM(e2.sum_sal) total_sal,
		   SUM(e2.sum_sal)/SUM(e2.no_of_emp) AS avg_sal
	FROM emp_agg e1
	INNER JOIN emp_agg e2
		ON e1.department_id != e2.department_id
	GROUP BY e1.department_id, e1.dep_avg
)
SELECT * 
FROM average_salary
WHERE dep_avg < avg_sal;
