create table emp_10(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
emp_age int);

insert into emp_10
values (1, 'Ankit', 100,10000, 4, 39);
insert into emp_10
values (2, 'Mohit', 100, 15000, 5, 48);
insert into emp_10
values (3, 'Vikas', 100, 12000,4,37);
insert into emp_10
values (4, 'Rohit', 100, 14000, 2, 16);
insert into emp_10
values (5, 'Mudit', 200, 20000, 6,55);
insert into emp_10
values (6, 'Agam', 200, 12000,2, 14);
insert into emp_10
values (7, 'Sanjay', 200, 9000, 2,13);
insert into emp_10
values (8, 'Ashish', 200,5000,2,12);
insert into emp_10
values (9, 'Mukesh',300,6000,6,51);
insert into emp_10
values (10, 'Rakesh',500,7000,6,50);

SELECT * FROM emp_10;

-- List employees name along with Manager and Senior Manager names
-- (Senior Manager is Manager's manager)
SELECT ee.emp_id, ee.emp_name AS Employee, 
	   em.emp_name AS Manager, 
	   esm.emp_name AS Senior_Manager
FROM emp_10 ee
LEFT JOIN emp_10 em
	ON ee.manager_id = em.emp_id
LEFT JOIN emp_10 esm
	ON em.manager_id = esm.emp_id
