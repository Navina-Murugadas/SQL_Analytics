USE payments_fraud_risk;

SELECT * FROM users_payment_v3;
SELECT * FROM transactions_payment_v3;
SELECT * FROM risk_flags_payment_v3;

---------------------------------------------------------------------------------------------------
-- 1) Users with more than 1 failed transaction
SELECT user_id, COUNT(*) AS failed_txn_count
FROM transactions_payment_v3 
WHERE status = 'FAILED'
GROUP BY user_id
HAVING COUNT(*) > 1
ORDER BY failed_txn_count DESC;

---------------------------------------------------------------------------------------------------
-- 2) Total transactions per user
SELECT user_id, COUNT(*) AS total_txn_count
FROM transactions_payment_v3
GROUP BY user_id
ORDER BY total_txn_count DESC;

---------------------------------------------------------------------------------------------------
-- 3) Total success amount per user
SELECT user_id, CAST(ROUND(SUM(amount)/1000000, 2) AS DECIMAL(10,2)) AS total_success_amount_Millions
FROM transactions_payment_v3
WHERE status = 'SUCCESS'
GROUP BY user_id
ORDER BY total_success_amount_Millions DESC;

---------------------------------------------------------------------------------------------------
-- 4) FAILED transactions with NULL amount (data quality)
SELECT user_id, txn_id, txn_date
FROM transactions_payment_v3
WHERE status = 'FAILED' 
  AND amount IS NULL;

---------------------------------------------------------------------------------------------------
-- 5) Users with atleast 2 FAILED txns AND total amount > 100000
SELECT user_id, COUNT(*) AS failed_txn_count,
	   CAST(ROUND(SUM(amount)/1000000, 2) AS DECIMAL(10,2)) AS total_failed_amount_Millions
FROM transactions_payment_v3
WHERE status = 'FAILED'
GROUP BY user_id
HAVING COUNT(*) >= 2
   AND SUM(amount) > 100000

---------------------------------------------------------------------------------------------------
-- 6) Latest transaction per user
WITH latest_txn AS (
	SELECT *,
		   RANK() OVER (PARTITION BY user_id ORDER by txn_date DESC) AS txn_date_rnk
	FROM transactions_payment_v3)
SELECT * 
FROM latest_txn
WHERE txn_date_rnk = 1

---------------------------------------------------------------------------------------------------
-- 7) Users who transacted after being flagged
WITH flagged_users AS (
	SELECT t.user_id, t.txn_id, r.flagged_date, t.txn_date
	FROM transactions_payment_v3 t
	INNER JOIN risk_flags_payment_v3 r
		ON t.user_id = r.user_id
	WHERE t.txn_date > r.flagged_date)
SELECT DISTINCT user_id
FROM flagged_users;

---------------------------------------------------------------------------------------------------
-- 8) Transactions above user’s average (Outliers)
WITH Average_txn AS (
	SELECT *,
		   AVG(amount) OVER(PARTITION BY user_id) AS avg_amt
	FROM transactions_payment_v3)
SELECT user_id, txn_id, txn_date, amount, avg_amt
FROM Average_txn
WHERE amount > 2*avg_amt;

---------------------------------------------------------------------------------------------------
-- 9) Rank transactions per user by amount
SELECT *,
	   RANK() OVER (PARTITION BY user_id ORDER BY amount DESC) AS amt_rnk
FROM transactions_payment_v3
WHERE amount IS NOT NULL;

---------------------------------------------------------------------------------------------------
-- 10) Running total per user
SELECT *,
	   SUM(amount) OVER (PARTITION BY user_id ORDER BY txn_date
			ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM transactions_payment_v3
WHERE amount IS NOT NULL;

---------------------------------------------------------------------------------------------------
-- 11) Difference between current and previous transaction amount
SELECT *,
	   LAG(amount) OVER (PARTITION BY user_id ORDER BY txn_date) AS prev_amt,
	   amount - LAG(amount) OVER (PARTITION BY user_id ORDER BY txn_date) AS amt_diff
FROM transactions_payment_v3;

---------------------------------------------------------------------------------------------------
-- 12) Users with atleast 3 consecutive FAILED transactions (GAP & ISLAND)
WITH rnks AS (
	SELECT *,
		   ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY txn_date) AS rnk_date,
		   ROW_NUMBER() OVER(PARTITION BY user_id, status ORDER BY txn_date) AS rnk_status
	FROM transactions_payment_v3)
SELECT DISTINCT user_id
FROM rnks
WHERE status = 'FAILED'
GROUP BY user_id, rnk_date - rnk_status
HAVING COUNT(*) >= 3;

---------------------------------------------------------------------------------------------------
-- 13) Velocity fraud (Multiple txns same day)
SELECT user_id, txn_date, COUNT(*) AS daily_txn_count
FROM transactions_payment_v3
GROUP BY user_id, txn_date
HAVING COUNT(*) >= 3;

---------------------------------------------------------------------------------------------------
-- 14) High-risk users based on country + amount
SELECT country, CAST(ROUND(SUM(amount)/1000000, 2) AS DECIMAL(10,2)) AS total_amt_Millions
FROM transactions_payment_v3 t
INNER JOIN users_payment_v3 u
	ON t.user_id = u.user_id
GROUP BY country
ORDER BY total_amt_Millions DESC;

---------------------------------------------------------------------------------------------------
-- 15) Transactions with missing critical fields
SELECT *
FROM transactions_payment_v3
WHERE amount IS NULL
   OR status IS NULL
   OR txn_date IS NULL;

---------------------------------------------------------------------------------------------------
-- 16) User-Level Transaction Success & Failure Rate
WITH success_failure_txn AS (
	SELECT user_id,
		   COUNT(*) AS total_txn,
		   SUM(CASE WHEN status = 'SUCCESS' THEN 1 ELSE 0 END) AS success_txn,
		   SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed_txn
	FROM transactions_payment_v3
	GROUP BY user_id)
SELECT user_id, total_txn,
	   CAST(ROUND((success_txn * 100.0) / total_txn, 2) AS DECIMAL(10,2)) AS success_rate,
	   CAST(ROUND((failed_txn * 100.0) / total_txn, 2) AS DECIMAL(10,2)) AS failure_rate
FROM success_failure_txn
ORDER BY failure_rate DESC;

---------------------------------------------------------------------------------------------------
-- 17) High-Value Transaction Risk - AML / threshold-based anomaly
SELECT user_id, txn_id, amount, txn_date, status
FROM transactions_payment_v3
WHERE amount > 50000;

---------------------------------------------------------------------------------------------------
-- 18) Time-Based Fraud Patterns - Unusual transaction times
SELECT DATEPART(WEEK, txn_date) AS txn_week,
	   SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed_txn_count
FROM transactions_payment_v3
GROUP BY DATEPART(WEEK, txn_date)
ORDER BY failed_txn_count DESC;

---------------------------------------------------------------------------------------------------
-- 19) Country-Level Risk Exposure - Geographic risk profiling
SELECT country, COUNT(*) AS total_txn_count,
	   SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed_txn_count,
	   CAST(ROUND((SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS DECIMAL(10,2)) 
			AS failure_rate,
	   CAST(ROUND(SUM(amount)/1000000, 2) AS DECIMAL(10,2)) AS total_amt_Millions,
	   CAST(ROUND(SUM(CASE WHEN status = 'FAILED' THEN amount ELSE 0 END)/1000000, 2)
			AS DECIMAL(10,2)) AS failed_amt_Millions
FROM transactions_payment_v3 t
INNER JOIN users_payment_v3 u
	ON t.user_id = u.user_id
GROUP BY country
ORDER BY failure_rate DESC, total_amt_Millions DESC;

---------------------------------------------------------------------------------------------------
-- 20) Composite User Risk Score
WITH risk_signals AS (
    SELECT
        user_id,
        SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed_txns,
        SUM(CASE WHEN amount >= 25000 THEN 1 ELSE 0 END) AS high_value_txns,
        COUNT(*) AS total_txns
    FROM dbo.transactions_payment_v3
    GROUP BY user_id
)
SELECT
    user_id,
    failed_txns,
    high_value_txns,
    total_txns,
    (failed_txns * 2 + high_value_txns * 3) AS risk_score
FROM risk_signals
WHERE (failed_txns * 2 + high_value_txns * 3) >= 25
ORDER BY risk_score DESC;

---------------------------------------------------------------------------------------------------
