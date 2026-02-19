---------------------------------------------------------------------------------------------
-- GOAL: Get median employee age overall & by department.
---------------------------------------------------------------------------------------------
create table empy(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
emp_age int);

insert into empy
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
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
SELECT * FROM empy;

-- MEDIAN USING ROW NUMBER():
WITH rnk AS(
    SELECT *,
        ROW_NUMBER() OVER(ORDER BY emp_age ASC) AS rnk_asc,
        ROW_NUMBER() OVER(ORDER BY emp_age DESC) AS rnk_desc
    FROM empy
)
SELECT AVG(emp_age) AS Emp_Median
FROM rnk
WHERE ABS(rnk_asc - rnk_desc) <= 1;

---------------------------------------------------------------------------------------------
-- MEDIAN USING PERCENTILE_CONT:
/*  SELECT
    PERCENTILE_CONT(<percent_value>)
        WITHIN GROUP (ORDER BY <column>) 
            OVER (PARTITION BY <column>) AS percentile_value
    FROM <table_name>;
*/

-- Overall Median:
SELECT DISTINCT PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY emp_age) OVER() AS Median_overall
FROM empy;

-- For each department:
SELECT DISTINCT department_id, PERCENTILE_CONT(0.5) 
       WITHIN GROUP (ORDER BY emp_age)
       OVER (PARTITION BY department_id) AS Median_Dept
FROM empy;