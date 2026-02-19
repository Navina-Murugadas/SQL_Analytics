-----------------------------------------------------------------------------------------------------------------
-- GOAL: Find pairs of trades for the same stock that occurred within 10 seconds & had a price difference > 10%.
-----------------------------------------------------------------------------------------------------------------
Create Table Trade_tbl(
TRADE_ID varchar(20),
Trade_Timestamp time,
Trade_Stock varchar(20),
Quantity int,
Price Float
)

Insert into Trade_tbl Values('TRADE1','10:01:05','ITJunction4All',100,20)
Insert into Trade_tbl Values('TRADE2','10:01:06','ITJunction4All',20,15)
Insert into Trade_tbl Values('TRADE3','10:01:08','ITJunction4All',150,30)
Insert into Trade_tbl Values('TRADE4','10:01:09','ITJunction4All',300,32)
Insert into Trade_tbl Values('TRADE5','10:10:00','ITJunction4All',-100,19)
Insert into Trade_tbl Values('TRADE6','10:10:01','ITJunction4All',-300,19);
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
SELECT * FROM Trade_tbl;

SELECT T1.TRADE_ID AS T1_TradeID, T2.TRADE_ID AS T2_TradeID, 
	   T1.Trade_Timestamp AS T1_Timestamp, T2.Trade_Timestamp AS T2_Timestamp, 
	   T1.Price AS Price_T1, T2.Price AS Price_T2,
	   ROUND(ABS(T1.Price - T2.Price) * 1.0 / T1.Price * 100, 2) AS Price_Difference_Percentage
FROM Trade_tbl T1
INNER JOIN Trade_tbl AS T2
	ON 1=1
WHERE T1.Trade_Timestamp < T2.Trade_Timestamp
	AND DATEDIFF(SECOND, T1.Trade_Timestamp, T2.Trade_Timestamp) <= 10
	AND T1.Trade_Stock = T2.Trade_Stock
	AND ABS(T1.Price - T2.Price) * 1.0 / T1.Price * 100 > 10
ORDER BY T1.TRADE_ID, T2.TRADE_ID;
