create table tbl_orders (
order_id integer,
order_date date
);
insert into tbl_orders
values (1,'2022-10-21'),(2,'2022-10-22'),
(3,'2022-10-25'),(4,'2022-10-25');

-- Snapshot @ 12:00 am
select * into tbl_orders_copy from  tbl_orders;

-- Inserting new data
insert into tbl_orders
values (5,'2022-10-26'),(6,'2022-10-26');

SELECT * FROM tbl_orders;

-- Deleting the records
delete from tbl_orders where order_id=1;

SELECT * FROM tbl_orders;

/*
Scenario:
There is a live production system with a table ("ORDERS") that captures order information in real-time.
We wish to capture "delfas" from this table (inserts and deletes) by leveraging a nightly copy of the
table. There are no timestamps that can be used for delta processing.

ORDER
ORDER_ID (Primary Key)
This table processes 10,000 transactions per day, including INSERTs, UPDATEs, and DELETEs. The
DELETEs are physical, so the records will no longer exist in the table.
Every day at 12:00AM, a snapshot (copy) of this table created and is an exact copy of the table at that
time.

ORDER_COPY
ORDER_ID (Primary Key)
Requirement:
Write a query that (as efficiently as possible) will return only new INSERTs into ORDER since the
snapshot was taken (record is in ORDER, but not ORDER_COPY) OR only new DELETEs from ORDER since
the snapshot was taken (record is in ORDER_COPY, but not ORDER).

The query should return the Primary Key (ORDER_ID) and a single character
("INSERT_OR_DELETE_FLAG") of "I" if it is an INSERT, or "D" if it is a DELETE.
For example, consider the Ven Diagram below depicting Inserts and Deletes and the desired result set:

Rule - Not to use minus, union, merge, union all ... exist and not exist can be used.
*/

SELECT * FROM tbl_orders;
SELECT * FROM tbl_orders_copy;


SELECT COALESCE(o.order_id, c.order_id) AS order_id,
	   CASE WHEN o.order_id IS NULL THEN 'D'
	        WHEN c.order_id IS NULL THEN 'I'
	   END AS Action_taken
FROM tbl_orders o
FULL OUTER JOIN tbl_orders_copy c
	ON o.order_id = c.order_id
WHERE o.order_id IS NULL
   OR c.order_id IS NULL;
