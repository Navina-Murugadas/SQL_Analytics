---------------------------------------------------------------------------------------------
-- GOAL: Count new vs returning customers for each order date.
---------------------------------------------------------------------------------------------
create table customer_orders (
	order_id integer, customer_id integer, 
	order_date date, order_amount integer
);

insert into customer_orders 
values(1,100,cast('2022-01-01' as date),2000),
	  (2,200,cast('2022-01-01' as date),2500),
	  (3,300,cast('2022-01-01' as date),2100),
	  (4,100,cast('2022-01-02' as date),2000),
	  (5,400,cast('2022-01-02' as date),2200),
	  (6,500,cast('2022-01-02' as date),2700),
	  (7,100,cast('2022-01-03' as date),3000),
	  (8,400,cast('2022-01-03' as date),1000),
	  (9,600,cast('2022-01-03' as date),3000);
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
select * from customer_orders;

WITH first_od AS(
SELECT customer_id, MIN(order_date) AS first_order_date
FROM customer_orders
GROUP BY customer_id
)
SELECT co.order_date,
	SUM(CASE WHEN co.order_date = fo.first_order_date 
	    THEN 1 ELSE 0 END) AS new_customers,
	SUM(CASE WHEN co.order_date != fo.first_order_date 
		THEN 1 ELSE 0 END) AS repeat_customers
FROM customer_orders co
INNER JOIN first_od AS fo
ON co.customer_id = fo.customer_id
GROUP BY co.order_date;