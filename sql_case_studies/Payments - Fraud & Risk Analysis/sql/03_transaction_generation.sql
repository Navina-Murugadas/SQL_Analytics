-- ==========================================================================================
-- 03. Transaction Generation (4–29 txns/user)
-- ==========================================================================================

WITH user_txn_plan AS (
    SELECT
        user_id,
        CASE
            WHEN ABS(CHECKSUM(user_id)) % 100 < 10 THEN 20 + ABS(CHECKSUM(user_id)) % 10
            WHEN ABS(CHECKSUM(user_id)) % 100 < 40 THEN 10 + ABS(CHECKSUM(user_id)) % 6
            ELSE 4 + ABS(CHECKSUM(user_id)) % 5
        END AS txn_count
    FROM dbo.users_payment_v3
)
INSERT INTO dbo.transactions_payment_v3
(txn_id, user_id, amount, status, txn_type, txn_date)
SELECT
    ROW_NUMBER() OVER (ORDER BY u.user_id, n.n) + 50000,
    u.user_id,
    50 + ABS(CHECKSUM(NEWID())) % 50000,
    CASE WHEN ABS(CHECKSUM(NEWID())) % 100 < 18 THEN 'FAILED' ELSE 'SUCCESS' END,
    CASE WHEN ABS(CHECKSUM(NEWID())) % 3 = 0 THEN 'CARD'
         WHEN ABS(CHECKSUM(NEWID())) % 3 = 1 THEN 'BANK'
         ELSE 'WALLET' END,
    DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 30, '2025-01-01')
FROM user_txn_plan u
CROSS APPLY (
    SELECT TOP (u.txn_count) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects
) n;
