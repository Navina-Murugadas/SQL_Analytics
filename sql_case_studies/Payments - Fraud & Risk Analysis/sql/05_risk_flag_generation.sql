-- ==========================================================================================
-- 05. Risk Flag Generation Logic
-- ==========================================================================================

WITH base AS (
    SELECT
        user_id,
        COUNT(*) AS total_txns,
        SUM(CASE WHEN status = 'FAILED' THEN 1 ELSE 0 END) AS failed_txns,
        MAX(amount) AS max_amount,
        MAX(CASE WHEN daily_cnt >= 4 THEN 1 ELSE 0 END) AS has_velocity,
        MIN(txn_date) AS first_txn_date
    FROM (
        SELECT *,
               COUNT(*) OVER (PARTITION BY user_id, txn_date) AS daily_cnt
        FROM dbo.transactions_payment_v3
    ) t
    GROUP BY user_id
),
thresholds AS (
    SELECT DISTINCT
        PERCENTILE_CONT(0.95)
        WITHIN GROUP (ORDER BY max_amount) OVER () AS high_amt_cutoff
    FROM base
)
INSERT INTO dbo.risk_flags_payment_v3
(flag_id, user_id, flag_reason, flagged_date)
SELECT
    ROW_NUMBER() OVER (ORDER BY b.user_id) + 90000,
    b.user_id,
    CASE
        WHEN b.max_amount >= t.high_amt_cutoff AND b.total_txns >= 10
            THEN 'High Transaction Amount'
        WHEN b.has_velocity = 1 AND b.total_txns >= 12
            THEN 'Velocity Fraud'
        WHEN b.failed_txns >= 6 AND b.failed_txns * 1.0 / b.total_txns >= 0.30
            THEN 'Multiple Failed Transactions'
    END,
    b.first_txn_date
FROM base b
CROSS JOIN thresholds t
WHERE
    (b.max_amount >= t.high_amt_cutoff AND b.total_txns >= 10)
 OR (b.has_velocity = 1 AND b.total_txns >= 12)
 OR (b.failed_txns >= 6 AND b.failed_txns * 1.0 / b.total_txns >= 0.30);
