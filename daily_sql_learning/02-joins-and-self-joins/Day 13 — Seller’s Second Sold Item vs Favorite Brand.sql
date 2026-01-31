create table userss (
    user_id int,
    join_date date,
    favorite_brand varchar(50)
);

create table orderss (
    order_id int,
    order_date date,
    item_id int,
    buyer_id int,
    seller_id int
);

create table itemss (
    item_id int,
    item_brand varchar(50)
);

insert into userss values (1,'2019-01-01','Lenovo'),(2,'2019-02-09','Samsung'),(3,'2019-01-19','LG'),(4,'2019-05-21','HP');
insert into orderss values (1,'2019-08-01',4,1,2),(2,'2019-08-02',2,1,3),(3,'2019-08-03',3,2,3),(4,'2019-08-04',1,4,2),(5,'2019-08-04',1,3,4),(6,'2019-08-05',2,2,4);
insert into itemss values (1,'Samsung'),(2,'Lenovo'),(3,'LG'),(4,'HP');

SELECT * FROM orderss;
SELECT * FROM userss;
SELECT * FROM itemss;

-- Write SQL query to find for each seller, whether the brand of the second item (by date) they sold is their fav.
-- If a seller sold less than two items, report the answer for that seller as 'No'
-- Output should be either 'Yes' or 'No'

WITH seller_ranking AS (
    SELECT *,
    RANK() OVER(PARTITION BY seller_id 
                ORDER BY order_date ASC)
                AS rnk
    FROM orderss
)
SELECT u.user_id, 
    CASE WHEN i.item_brand = u.favorite_brand
         THEN 'Yes' ELSE 'No' 
         END AS fav_brand  
FROM userss u
LEFT JOIN seller_ranking sr
    ON sr.seller_id = u.user_id
    AND rnk = 2
LEFT JOIN itemss i
    ON sr.item_id = i.item_id