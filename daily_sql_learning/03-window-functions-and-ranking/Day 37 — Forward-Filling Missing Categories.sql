---------------------------------------------------------------------------------------------
-- GOAL: Fill NULL category values by carrying forward the last known category.
---------------------------------------------------------------------------------------------
create table brands 
(
category varchar(20),
brand_name varchar(20)
);

insert into brands values
('chocolates','5-star')
,(null,'dairy milk')
,(null,'perk')
,(null,'eclair')
,('Biscuits','britannia')
,(null,'good day')
,(null,'boost');
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
SELECT * FROM brands;

WITH Ranking AS (
    SELECT *,
           ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS rnk
    FROM brands),
Next_NotNull AS (
    SELECT *,
           LEAD(rnk,1) OVER(ORDER BY rnk) AS Lead_rnk
    FROM Ranking
    WHERE category IS NOT NULL)
SELECT n.category, r.brand_name
FROM Ranking r
INNER JOIN Next_NotNull n
    ON r.rnk >= n.rnk 
    AND (r.rnk <= n.Lead_rnk - 1 OR
         n.Lead_rnk IS NULL)