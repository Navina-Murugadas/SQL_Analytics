create table covid(city varchar(50),days date,cases int);
delete from covid;
insert into covid values('DELHI','2022-01-01',100);
insert into covid values('DELHI','2022-01-02',200);
insert into covid values('DELHI','2022-01-03',300);

insert into covid values('MUMBAI','2022-01-01',100);
insert into covid values('MUMBAI','2022-01-02',100);
insert into covid values('MUMBAI','2022-01-03',300);

insert into covid values('CHENNAI','2022-01-01',100);
insert into covid values('CHENNAI','2022-01-02',200);
insert into covid values('CHENNAI','2022-01-03',150);

insert into covid values('BANGALORE','2022-01-01',100);
insert into covid values('BANGALORE','2022-01-02',300);
insert into covid values('BANGALORE','2022-01-03',200);
insert into covid values('BANGALORE','2022-01-04',400);

SELECT * FROM covid;

-- Find cities where the covid cases are increasing continuously
WITH rnks AS (
	SELECT *,
		   RANK() OVER(PARTITION BY CITY ORDER BY days ASC) 
				AS rnk_days,
		   RANK() OVER(PARTITION BY CITY ORDER BY cases ASC)
				AS rnk_cases,
		   RANK() OVER(PARTITION BY CITY ORDER BY days ASC) - 
			RANK() OVER(PARTITION BY CITY ORDER BY cases ASC) AS rnk_diff
	FROM covid)
SELECT city
FROM rnks
GROUP BY city
HAVING COUNT(DISTINCT rnk_diff) = 1
	AND MAX(rnk_diff) = 0;