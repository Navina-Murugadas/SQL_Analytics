---------------------------------------------------------------------------------------------
-- GOAL: Calculate yearly total sales when data is stored as date ranges.
---------------------------------------------------------------------------------------------
create table sales ( 
	product_id int, 
	period_start date, 
	period_end date, 
	average_daily_sales int ); 

insert into sales 
values(1,'2019-01-25','2019-02-28',100),
	  (2,'2018-12-01','2020-01-01',10),
	  (3,'2019-12-01','2020-01-31',1);
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
SELECT * FROM sales;

WITH all_dates AS (
	SELECT MIN(period_start) AS dates, 
		   MAX(period_end) AS date_end
	FROM sales

	UNION ALL

	SELECT DATEADD(DAY, 1, dates) AS dates, date_end 
	FROM all_dates

	WHERE dates < date_end
)
SELECT product_id, 
	   YEAR(dates) AS report_year,
	   SUM(average_daily_sales) AS total_amount
FROM all_dates
INNER JOIN sales
	ON dates BETWEEN period_start AND period_end
GROUP BY product_id, YEAR(dates)
ORDER BY product_id, YEAR(dates)
OPTION (MAXRECURSION 1000);

