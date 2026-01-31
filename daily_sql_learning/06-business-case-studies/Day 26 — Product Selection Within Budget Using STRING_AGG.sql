create table productsx
(
product_id varchar(20) ,
cost int
);
insert into productsx values ('P1',200),('P2',300),('P3',500),('P4',800);

create table customer_budget
(
customer_id int,
budget int
);

insert into customer_budget values (100,400),(200,800),(300,1500);

SELECT * FROM productsx;
SELECT * FROM customer_budget;

-- Find how many products falls into customer budget along with the list of products.
-- In case of clash, choose the less costly product.
WITH running_cost AS (
	SELECT *,
		   SUM(cost) OVER(ORDER BY cost ASC) AS r_cost
	FROM productsx)
SELECT cb.customer_id, cb.budget,
	   COUNT(*) AS No_of_prods,
	   STRING_AGG(product_id, ',') AS List_of_prods
FROM customer_budget cb
LEFT JOIN running_cost rc
	ON rc.r_cost < cb.budget
GROUP BY cb.customer_id, cb.budget;