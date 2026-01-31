create table ordersx
(
order_id int,
customer_id int,
product_id int,
);

insert into ordersx VALUES 
(1, 1, 1),
(1, 1, 2),
(1, 1, 3),
(2, 2, 1),
(2, 2, 2),
(2, 2, 4),
(3, 1, 5);

create table products (
id int,
name varchar(10)
);
insert into products VALUES 
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');

SELECT * FROM ordersx;
SELECT * FROM products;


SELECT o1.order_id, o1.product_id AS p1, o2.product_id AS p2
FROM ordersx o1
INNER JOIN ordersx o2
	ON o1.order_id = o2.order_id  -- SELF JOIN (CARTESIAN PRODUCTS)
	AND o1.product_id > o2.product_id -- TO AVOID DUPLICATES
-- order_id 3 has only one product_id.  Hence not needed to check for combo


SELECT o1.product_id AS p1, o2.product_id AS p2,
	   COUNT(*) AS purchase_freq
FROM ordersx o1
INNER JOIN ordersx o2
	ON o1.order_id = o2.order_id
	AND o1.product_id > o2.product_id
GROUP BY o1.product_id, o2.product_id;


-- SELECT pr1.name AS p1, pr2.name AS p2,
SELECT pr1.name + ' ' + pr2.name AS pair,
	   COUNT(*) AS purchase_freq
FROM ordersx o1
INNER JOIN ordersx o2
	ON o1.order_id = o2.order_id
INNER JOIN products pr1
	ON o1.product_id = pr1.id
INNER JOIN products pr2
	ON o2.product_id = pr2.id
	AND o1.product_id < o2.product_id
GROUP BY pr1.name, pr2.name;
