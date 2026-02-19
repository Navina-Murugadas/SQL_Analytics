---------------------------------------------------------------------------------------------
-- GOAL: Find monthly retained and churned customers.
---------------------------------------------------------------------------------------------
create table transactions(
order_id int,
cust_id int,
order_date date,
amount int
);

insert into transactions 
values (1,1,'2020-01-15',150),
	   (2,1,'2020-02-10',150),
	   (3,2,'2020-01-16',150),
	   (4,2,'2020-02-25',150),
	   (5,3,'2020-01-10',150),
	   (6,3,'2020-02-20',150),
	   (7,4,'2020-01-20',150),
	   (8,5,'2020-02-20',150);
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
SELECT * FROM transactions;

/* 
-- CUSTOMER RETENTION
Refers to company's ability to turn customers into repeat buyers.
And prevent them from switching to competitor.
It indicates whether your product and quality of your service pleases your existing customers
-- Reward programs (CC companies)
-- Wallet cashback (Paytm/Gpay)
-- Zomato pro/ Swiggy super
 */

SELECT MONTH(t_mon.order_date) AS Month_no,
	   COUNT(DISTINCT l_mon.cust_id) AS Retention_count
FROM transactions t_mon
LEFT JOIN transactions l_mon
	ON t_mon.cust_id = l_mon.cust_id
	AND DATEDIFF(MONTH, t_mon.order_date, l_mon.order_date) = 1
GROUP BY MONTH(t_mon.order_date);


/*
-- CUSTOMER CHURN
Customer churn refers to the percentage of customers who stop using a company's product or service 
during a specific timeframe, indicating customer dissatisfaction or competitive loss.
*/
SELECT MONTH(l_mon.order_date) AS Month_No,
	   COUNT(DISTINCT l_mon.cust_id) AS Churn_count
FROM transactions t_mon
RIGHT JOIN transactions l_mon
	ON t_mon.cust_id = l_mon.cust_id
	AND DATEDIFF(MONTH, l_mon.order_date, t_mon.order_date) = 1
WHERE t_mon.cust_id IS NULL
GROUP BY MONTH(l_mon.order_date);