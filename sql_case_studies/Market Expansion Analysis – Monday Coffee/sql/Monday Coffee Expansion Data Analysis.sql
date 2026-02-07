USE monday_coffee;

------------------------------------------------------------------------------------------------------------------------------
-- COFFEE CONSUMERS COUNT:
-- 1) How many people in each city are estimated to consume coffee, given that 25% of the population does.
SELECT city_name, population, city_rank,
	   CAST(ROUND((population * 0.25)/1000000 , 2) AS DECIMAL(10,2)) AS Estimated_coffee_consumers_In_Millions
FROM city
ORDER BY Estimated_coffee_consumers_In_Millions DESC;

------------------------------------------------------------------------------------------------------------------------------
-- TOTAL REVENUE FROM COFFEE SALES:
-- 2) What is the total revenue generated from coffee sales across all cities in the last quarter of 2023.
SELECT SUM(total) AS Total_revenue_Q4_2023
FROM sales
WHERE YEAR(sale_date) = 2023
  AND DATEPART(QUARTER, sale_date) = 4; 

---------------------------------------------------------------------------------------------------------------
-- 3) What is the total revenue generated from coffee sales across each city in the last quarter of 2023.
SELECT ci.city_name, 
	   SUM(total) AS Total_revenue_Q4_2023
FROM sales s
INNER JOIN customers c
	ON s.customer_id = c.customer_id
INNER JOIN city ci
	ON c.city_id = ci.city_id
WHERE YEAR(s.sale_date) = 2023 
  AND DATEPART(QUARTER, s.sale_date) = 4
GROUP BY ci.city_name
ORDER BY Total_revenue_Q4_2023 DESC;

------------------------------------------------------------------------------------------------------------------------------
-- SALES COUNT FOR EACH PRODUCT:
-- 4) How many units of each coffee product have been sold?
SELECT p.product_name,
	   COUNT(s.sale_id) AS Total_units_sold
FROM products p
LEFT JOIN sales s
	ON p.product_id = s.product_id
GROUP BY p.product_name
ORDER BY Total_units_sold DESC;

------------------------------------------------------------------------------------------------------------------------------
-- AVERAGE SALES AMOUNT PER CITY:
-- 5) What is the average sales amount per customer inn each city?
SELECT ci.city_name,
	   SUM(total) AS Total_revenue,
	   COUNT(DISTINCT c.customer_id) AS Number_of_customers,
	   ROUND(SUM(total)/COUNT(DISTINCT c.customer_id), 2) AS Avg_Sales_per_Customer
FROM sales s
INNER JOIN customers c
	ON s.customer_id = c.customer_id
INNER JOIN city ci
	ON c.city_id = ci.city_id
GROUP BY ci.city_name
ORDER BY Avg_Sales_per_Customer DESC;

------------------------------------------------------------------------------------------------------------------------------
-- CITY POPULATION AND COFFEE CONSUMERS:
-- 6) Provide a list of cities along with their populations and estimated coffee consumers.
-- Return city_name, total_current_customers, Estimated_coffee_consumers (25%)
WITH Est_Coffee_cx AS (
SELECT city_name,
	   CAST(ROUND((population * 0.25)/1000000 , 2) AS DECIMAL(10,2)) AS Estimated_coffee_consumers_In_Millions
FROM city),
Current_customers AS (
SELECT ci.city_name, 
	   COUNT(DISTINCT c.customer_id) AS Total_current_customers
FROM sales s
INNER JOIN customers c
	ON s.customer_id = c.customer_id
INNER JOIN city ci
	ON c.city_id = ci.city_id
GROUP BY ci.city_name)

SELECT ecx.*, cc.Total_current_customers
FROM Est_Coffee_cx ecx
INNER JOIN Current_customers cc
	ON ecx.city_name = cc.city_name
ORDER BY ecx.Estimated_coffee_consumers_In_Millions DESC;

------------------------------------------------------------------------------------------------------------------------------
-- TOP SELLING PRODUCTS BY CITY
-- 7) What are the top 3 selling products in each city based on sales volume?
WITH City_Product_Sales AS (
SELECT ci.city_name,
	   p.product_name,
	   COUNT(s.sale_id) AS Units_sold,
	   DENSE_RANK() OVER (PARTITION BY ci.city_name ORDER BY COUNT(s.sale_id) DESC) AS Product_Rank
FROM sales s
INNER JOIN customers c
	ON s.customer_id = c.customer_id
INNER JOIN city ci
	ON c.city_id = ci.city_id
INNER JOIN products p
	ON s.product_id = p.product_id
GROUP BY ci.city_name, p.product_name)
SELECT city_name, product_name, Units_sold, Product_Rank
FROM City_Product_Sales
WHERE Product_Rank <= 3

------------------------------------------------------------------------------------------------------------------------------
-- CUSTOMER SEGMENTATION BY CITY:
-- 8) How many unique customers are there in each city who have purchased coffee products?
SELECT ci.city_name,
	   COUNT(DISTINCT c.customer_id) AS Unique_customers
FROM city ci
LEFT JOIN customers c
	ON ci.city_id = c.city_id
GROUP BY ci.city_name
ORDER BY Unique_customers DESC;

------------------------------------------------------------------------------------------------------------------------------
-- AVERAGE SALE VS RENT:
-- 9) Find each city and their average sale per customer and average rent per customer.
WITH Avg_Sale_Per_Customer AS (
	SELECT ci.city_name,
		   SUM(s.total) AS Total_revenue,
		   COUNT(DISTINCT c.customer_id) AS Number_of_customers,
		   ROUND(SUM(s.total)/COUNT(DISTINCT c.customer_id), 2) AS Avg_Sales_per_Customer
	FROM sales s
	INNER JOIN customers c
		ON s.customer_id = c.customer_id
	INNER JOIN city ci
		ON c.city_id = ci.city_id
	GROUP BY ci.city_name),
City_Rent AS (
	SELECT city_name, estimated_rent
	FROM city)
SELECT cr.city_name, 
	   cr.estimated_rent,
	   asp.Number_of_customers,
	   asp.Avg_Sales_per_Customer,
	   ROUND(cr.estimated_rent/Number_of_customers, 2) AS Avg_Rent_per_Customer
FROM City_Rent cr
INNER JOIN Avg_Sale_Per_Customer asp
	ON cr.city_name = asp.city_name
ORDER BY asp.Avg_Sales_per_Customer DESC;

------------------------------------------------------------------------------------------------------------------------------
-- MONTHLY SALES TRENDS:
-- 10) Sales growth rate: Calculate the percentage growth (or decline) in sales for each city over different time periods (monthly).
WITH Sales_Trends AS (
    SELECT ci.city_name,
           YEAR(sale_date) AS Sales_yr,
           MONTH(sale_date) AS Sales_mo,
           SUM(s.total) AS Total_revenue
    FROM sales s
    INNER JOIN customers c
        ON s.customer_id = c.customer_id
    INNER JOIN city ci
        ON c.city_id = ci.city_id
    GROUP BY ci.city_name, YEAR(sale_date), MONTH(sale_date)
),
Monthly_Growth AS (
	SELECT city_name AS city,
		   Sales_yr,
		   Sales_mo,
		   Total_revenue AS Current_month_sales,
		   LAG(Total_revenue, 1) 
			   OVER (
				   PARTITION BY city_name 
				   ORDER BY Sales_yr, Sales_mo
			   ) AS Previous_month_sales
	FROM Sales_Trends)
SELECT city,
	   Sales_yr,
	   Sales_mo,
	   Current_month_sales,
	   Previous_month_sales,
	   CASE 
		   WHEN Previous_month_sales IS NULL THEN NULL
		   ELSE ROUND(((Current_month_sales - Previous_month_sales) / Previous_month_sales) * 100, 2)
	   END AS Growth_rate_percentage
FROM Monthly_Growth
WHERE Previous_month_sales IS NOT NULL
ORDER BY city, Sales_yr, Sales_mo;

------------------------------------------------------------------------------------------------------------------------------
/* MARKET POTENTIAL ANALYSIS:
-- 11) Identify top 3 cities based on highest sales, returns city name, total sales, total rent, 
       total customers, estimated coffee consumers, and average sales per customer. */
WITH Top_Cities AS (
SELECT ci.city_name,
	   SUM(s.total) AS Total_revenue,
	   COUNT(DISTINCT c.customer_id) AS Total_customers,
	   ROUND(SUM(s.total)/COUNT(DISTINCT c.customer_id), 2) AS Avg_Sales_per_Customer
FROM sales s
INNER JOIN customers c
	ON s.customer_id = c.customer_id
INNER JOIN city ci
	ON c.city_id = ci.city_id
GROUP BY ci.city_name),
Estimated_Coffee_Consumers AS (
	SELECT ci.city_name,
		   ci.estimated_rent AS Total_rent,
		   CAST(ROUND((population * 0.25)/1000000 , 2) AS DECIMAL(10,2)) AS Estimated_coffee_consumers_In_Millions
	FROM city ci)
SELECT t.city_name AS City, Total_revenue, Total_rent, Total_customers, 
	   Estimated_coffee_consumers_In_Millions, Avg_Sales_per_Customer,
	   CAST(ROUND((Total_rent/Total_customers), 2) AS DECIMAL(10,2)) AS Avg_Rent_per_Customer
FROM Top_Cities t
INNER JOIN Estimated_Coffee_Consumers e
	ON t.city_name = e.city_name
ORDER BY Total_revenue DESC;

------------------------------------------------------------------------------------------------------------------------------