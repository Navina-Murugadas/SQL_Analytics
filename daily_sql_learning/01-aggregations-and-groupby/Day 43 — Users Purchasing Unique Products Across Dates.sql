----------------------------------------------------------------------------------------------------
-- GOAL: Find users who purchased on multiple dates where no product repeats across different days.
----------------------------------------------------------------------------------------------------
create table purchase_history
(userid int
,productid int
,purchasedate date
);
SET DATEFORMAT dmy;
insert into purchase_history values
(1,1,'23-01-2012'),(1,2,'23-01-2012'),(1,3,'25-01-2012'),
(2,1,'23-01-2012'),(2,2,'23-01-2012'),(2,2,'25-01-2012'),(2,4,'25-01-2012'),
(3,4,'23-01-2012'),(3,1,'23-01-2012'),(4,1,'23-01-2012'),(4,2,'25-01-2012');
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
SELECT * FROM purchase_history;

WITH Distinct_dates_prods AS (
	SELECT userid,
		   COUNT(DISTINCT purchasedate) AS Distinct_dates,
		   COUNT(productid) AS Total_products,
		   COUNT(DISTINCT productid) AS Total_dist_prods
	FROM purchase_history
	GROUP BY userid)
SELECT userid
FROM Distinct_dates_prods
WHERE Distinct_dates > 1
	AND Total_dist_prods = Total_products;