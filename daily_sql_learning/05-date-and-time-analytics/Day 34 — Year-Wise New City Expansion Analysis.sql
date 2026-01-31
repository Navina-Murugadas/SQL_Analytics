create table business_city (
business_date date,
city_id int
);
delete from business_city;
insert into business_city
values(cast('2020-01-02' as date),3),(cast('2020-07-01' as date),7),(cast('2021-01-01' as date),3),(cast('2021-02-03' as date),19)
,(cast('2022-12-01' as date),3),(cast('2022-12-15' as date),3),(cast('2022-02-28' as date),12);

SELECT * FROM business_city;

-- Identify yearwise count of new cities where UDAAN started their operations
WITH Buss_Year AS (
	SELECT DATEPART(YEAR, business_date) AS Business_yr, city_id
	FROM business_city)
SELECT by1.Business_yr,
	   COUNT(*) AS New_Cities
FROM Buss_Year by1
LEFT JOIN Buss_Year by2
	ON by1.Business_yr > by2.Business_yr
	AND by1.city_id = by2.city_id
WHERE by2.city_id IS NULL
GROUP BY by1.Business_yr;


-- Identify yearwise count of new cities where UDAAN started their operations
WITH Buss_Year AS (
	SELECT DATEPART(YEAR, business_date) AS Business_yr, city_id
	FROM business_city)
SELECT by1.Business_yr,
	   COUNT(CASE WHEN by2.city_id IS NULL THEN by1.city_id END) AS New_Cities
FROM Buss_Year by1
LEFT JOIN Buss_Year by2
	ON by1.Business_yr > by2.Business_yr
	AND by1.city_id = by2.city_id
GROUP BY by1.Business_yr;

