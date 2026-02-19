----------------------------------------------------------------------------------------------------
-- GOAL: Find the highest-value order for each salesperson.
----------------------------------------------------------------------------------------------------
CREATE TABLE [dbo].[int_orders](
 [order_number] [int] NOT NULL,
 [order_date] [date] NOT NULL,
 [cust_id] [int] NOT NULL,
 [salesperson_id] [int] NOT NULL,
 [amount] [float] NOT NULL
) ON [PRIMARY];

INSERT INTO [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) 
VALUES (30, CAST('1995-07-14' AS Date), 9, 1, 460),
	   (10, CAST('1996-08-02' AS Date), 4, 2, 540), 
	   (40, CAST('1998-01-29' AS Date), 7, 2, 2400),
	   (50, CAST('1998-02-03' AS Date), 6, 7, 600),
	   (60, CAST('1998-03-02' AS Date), 6, 7, 720),
	   (70, CAST('1998-05-06' AS Date), 9, 7, 150),
	   (20, CAST('1999-01-30' AS Date), 4, 8, 1800);
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
SELECT * FROM [int_orders];

-- Using RANK()
WITH Largest_order_value AS (
	SELECT *,
		   RANK() OVER(PARTITION BY salesperson_id ORDER BY amount DESC) AS Largest_odr
	FROM [int_orders])
SELECT lv.order_number, lv.order_date, lv.cust_id, lv.salesperson_id, lv.amount 
FROM Largest_order_value lv
WHERE Largest_odr = 1
ORDER BY order_number ASC;

----------------------------------------------------------------------------------------------------
-- Get the result without using sub query, CTE, window functions, temp tables.
SELECT a.order_number, a.order_date, a.cust_id, a.salesperson_id, a.amount
FROM [int_orders] a
LEFT JOIN [int_orders] b
	ON a.salesperson_id = b.salesperson_id
GROUP BY a.order_number, a.order_date, a.cust_id, a.salesperson_id, a.amount
HAVING a.amount = MAX(b.amount);

