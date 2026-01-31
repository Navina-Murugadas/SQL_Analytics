create table players_location
(
name varchar(20),
city varchar(20)
);
delete from players_location;
insert into players_location
values ('Sachin','Mumbai'),('Virat','Delhi') , ('Rahul','Bangalore'),('Rohit','Mumbai'),('Mayank','Bangalore');

SELECT * FROM players_location;

/*
Display each city as a separate column
Within each city, players must be sorted alphabetically
The alphabetically 1st player from every city should belong to Group 1
The alphabetically 2nd player from every city should belong to Group 2
Continue grouping in this manner for all remaining players
If a city has fewer players, leave the cell blank (NULL)
*/

WITH Group_number AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY city ORDER BY name ASC)
				AS grp_no
	FROM players_location)
SELECT 
	MAX(CASE WHEN city = 'Bangalore' THEN name 
		END) AS Bangalore,
	MAX(CASE WHEN city = 'Delhi' THEN name
		END) AS Delhi,
	MAX(CASE WHEN city = 'Mumbai' THEN name
		END) AS Mumbai
FROM Group_number
GROUP BY grp_no
ORDER BY grp_no;
