CREATE TABLE users_payoneer (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(50),
    country VARCHAR(30),
    signup_date DATE
);

INSERT INTO users_payoneer VALUES
(101, 'Alice', 'India', '2024-01-01'),
(102, 'Bob', 'India', '2024-01-05'),
(103, 'Charlie', 'US', '2024-02-10'),
(104, 'David', 'UK', '2024-02-15'),
(105, 'Eva', 'India', '2024-03-01');


CREATE TABLE transactions_payoneer (
    txn_id INT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(10,2),
    status VARCHAR(10),   -- SUCCESS / FAILED
    txn_type VARCHAR(20), -- CARD / BANK / WALLET
    txn_date DATE,
    FOREIGN KEY (user_id) REFERENCES users_payoneer(user_id)
);

INSERT INTO transactions_payoneer VALUES
(1, 101, 500, 'FAILED', 'CARD', '2025-01-01'),
(2, 101, 700, 'FAILED', 'CARD', '2025-01-02'),
(3, 101, 300, 'FAILED', 'CARD', '2025-01-03'),
(4, 101, 400, 'SUCCESS', 'CARD', '2025-01-04'),

(5, 102, 200, 'FAILED', 'BANK', '2025-01-01'),
(6, 102, 600, 'FAILED', 'BANK', '2025-01-02'),
(7, 102, 800, 'SUCCESS', 'BANK', '2025-01-03'),

(8, 103, 100, 'FAILED', 'WALLET', '2025-01-01'),
(9, 103, 200, 'FAILED', 'WALLET', '2025-01-02'),
(10,103, 300, 'FAILED', 'WALLET', '2025-01-03'),
(11,103, 400, 'FAILED', 'WALLET', '2025-01-04'),

(12,104, NULL, 'FAILED', 'CARD', '2025-01-02'),
(13,104, 5000, 'SUCCESS', 'CARD', '2025-01-05'),

(14,105, 1000, 'SUCCESS', 'CARD', '2025-01-01'),
(15,105, 8000, 'SUCCESS', 'CARD', '2025-01-02'),
(16,105, 45000, 'SUCCESS', 'CARD', '2025-01-03');


CREATE TABLE risk_flags_payoneer (
    flag_id INT PRIMARY KEY,
    user_id INT,
    flag_reason VARCHAR(50),
    flagged_date DATE
);

INSERT INTO risk_flags_payoneer VALUES
(1, 101, 'Multiple Failed Transactions', '2025-01-03'),
(2, 103, 'Velocity Fraud', '2025-01-04'),
(3, 105, 'High Transaction Amount', '2025-01-03');

SELECT * FROM users_payoneer;
SELECT * FROM transactions_payoneer;
SELECT * FROM risk_flags_payoneer;

---------------------------------------------------------------------------------------------------------
-- Q1. Users with more than 1 FAILED transaction
SELECT user_id, COUNT(*)
FROM transactions_payoneer
WHERE status = 'FAILED'
GROUP BY user_id
HAVING COUNT(*) > 1;

---------------------------------------------------------------------------------------------------------
-- Q2. Total transactions per user
SELECT user_id, COUNT(*) AS Total_transactions
FROM transactions_payoneer
GROUP BY user_id;

---------------------------------------------------------------------------------------------------------
-- Q3. Total SUCCESS amount per user
SELECT user_id, COUNT(*) AS Total_Success
FROM transactions_payoneer
WHERE status = 'SUCCESS'
GROUP BY user_id;

---------------------------------------------------------------------------------------------------------
-- Q4. FAILED transactions with NULL amount (data quality)
SELECT user_id, txn_id
FROM transactions_payoneer
WHERE status = 'FAILED'
    AND amount IS NULL;

---------------------------------------------------------------------------------------------------------
-- Q5. Users with atleast 2 FAILED txns AND total amount > 1000
SELECT t.user_id, SUM(t.amount) AS Total_amt
FROM transactions_payoneer t
INNER JOIN (
    SELECT user_id, COUNT(*) AS Failed_transactions
    FROM transactions_payoneer
    WHERE status = 'FAILED'
    GROUP BY user_id
    HAVING COUNT(*) >= 2) a
ON t.user_id = a.user_id
GROUP BY t.user_id
HAVING SUM(t.amount) > 1000;

---------------------------------------------------------------------------------------------------------
-- Q6. Latest transaction per user
WITH Latest_ranking AS (
    SELECT *,
           RANK() OVER(PARTITION BY user_id ORDER BY txn_date DESC) 
            AS rnk_date
    FROM transactions_payoneer)
SELECT user_id, amount, status, txn_type, txn_date
FROM Latest_ranking
WHERE rnk_date = 1;

---------------------------------------------------------------------------------------------------------
-- Q7. Users who transacted after being flagged
SELECT tp.user_id, txn_date
FROM transactions_payoneer tp
INNER JOIN risk_flags_payoneer rp
    ON tp.user_id = rp.user_id
    AND tp.txn_date > rp.flagged_date;

---------------------------------------------------------------------------------------------------------
-- Q8. Transactions above user’s average (outliers)
WITH Above_avg_trans AS (
    SELECT *,
           AVG(amount) OVER(PARTITION BY user_id) AS Avg_trans_amt
    FROM transactions_payoneer
    WHERE amount IS NOT NULL)
SELECT user_id, txn_id, amount, Avg_trans_amt
FROM Above_avg_trans
WHERE amount > Avg_trans_amt;

---------------------------------------------------------------------------------------------------------
-- Q9. Rank transactions per user by amount
SELECT user_id, txn_id, amount,
       RANK() OVER(PARTITION BY user_id ORDER BY amount DESC) AS rnk_desc
FROM transactions_payoneer
WHERE amount IS NOT NULL;

---------------------------------------------------------------------------------------------------------
-- Q10. Running total per user
SELECT user_id, txn_date, amount,
       SUM(amount) OVER(PARTITION BY user_id ORDER BY txn_date
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Running_total
FROM transactions_payoneer
WHERE amount IS NOT NULL;

---------------------------------------------------------------------------------------------------------
-- Q11. Difference between current and previous transaction amount
SELECT user_id, txn_id, amount, txn_date,
       LAG(amount) OVER(PARTITION BY user_id ORDER BY txn_date ASC) AS Lag_amount,
       amount - LAG(amount) OVER(PARTITION BY user_id ORDER BY txn_date ASC)
FROM transactions_payoneer;

---------------------------------------------------------------------------------------------------------
-- Q12. Users with atleast 3 consecutive FAILED transactions (GAP & ISLAND)
WITH Ranking_date AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY txn_date) AS rnk_date,
           ROW_NUMBER() OVER(PARTITION BY user_id, status ORDER BY txn_date) AS rnk_status_date,
           ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY txn_date) - 
            ROW_NUMBER() OVER(PARTITION BY user_id, status ORDER BY txn_date) AS rnk_diff
    FROM transactions_payoneer)
SELECT DISTINCT user_id
FROM Ranking_date
WHERE status = 'FAILED'
GROUP BY user_id, rnk_diff
HAVING COUNT(*) >= 3;

---------------------------------------------------------------------------------------------------------
-- Q13. Velocity fraud (multiple txns same day)
SELECT user_id, txn_date, COUNT(*) AS No_of_txns
FROM transactions_payoneer
GROUP BY user_id, txn_date
HAVING COUNT(*) >= 3;

---------------------------------------------------------------------------------------------------------
-- Q14. High-risk users based on country + amount
SELECT up.country, SUM(amount) AS Total_amt
FROM transactions_payoneer tp
INNER JOIN users_payoneer up
    ON tp.user_id = up.user_id
GROUP BY up.country

---------------------------------------------------------------------------------------------------------
-- Q15. Transactions with missing critical fields
SELECT *
FROM transactions_payoneer
WHERE amount IS NULL 
   OR status IS NULL
   OR txn_date IS NULL;

---------------------------------------------------------------------------------------------------------
-- Q16. Users flagged but never reviewed again
SELECT rp.user_id, flagged_date, flag_reason
FROM risk_flags_payoneer rp
LEFT JOIN transactions_payoneer tp
    ON rp.user_id = tp.user_id
    AND tp.txn_date > rp.flagged_date
WHERE tp.txn_id IS NULL;

---------------------------------------------------------------------------------------------------------