-- ==========================================================================================
-- 04. Risk Behavior Injection
-- ==========================================================================================

UPDATE dbo.transactions_payment_v3
SET status =
    CASE
        WHEN user_id % 13 = 0 AND ABS(CHECKSUM(NEWID())) % 100 < 60 THEN 'FAILED'
        WHEN user_id % 7 = 0 AND ABS(CHECKSUM(NEWID())) % 100 < 35 THEN 'FAILED'
        WHEN ABS(CHECKSUM(NEWID())) % 100 < 10 THEN 'FAILED'
        ELSE 'SUCCESS'
    END;

UPDATE dbo.transactions_payment_v3
SET amount =
    CASE
        WHEN user_id % 13 = 0 THEN 20000 + ABS(CHECKSUM(NEWID())) % 60000
        WHEN user_id % 7 = 0 THEN 5000 + ABS(CHECKSUM(NEWID())) % 15000
        ELSE 100 + ABS(CHECKSUM(NEWID())) % 5000
    END
WHERE amount IS NOT NULL;

UPDATE dbo.transactions_payment_v3
SET txn_date =
    CASE
        WHEN user_id % 13 = 0 THEN '2025-01-15'
        WHEN user_id % 7 = 0 THEN DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 2, '2025-01-14')
        ELSE DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 30, '2025-01-01')
    END;

UPDATE dbo.transactions_payment_v3
SET txn_type =
    CASE
        WHEN user_id % 13 = 0 THEN 'CARD'      -- common fraud vector
        WHEN user_id % 7 = 0 THEN 'WALLET'
        ELSE txn_type
    END;

UPDATE dbo.users_payment_v3
SET country =
    CASE
        WHEN ABS(CHECKSUM(NEWID())) % 4 = 0 THEN 'India'
        WHEN ABS(CHECKSUM(NEWID())) % 4 = 1 THEN 'US'
        WHEN ABS(CHECKSUM(NEWID())) % 4 = 2 THEN 'UK'
        ELSE 'Canada'
    END;

UPDATE dbo.transactions_payment_v3
SET amount = NULL
WHERE txn_id IN (50014, 52837, 53957, 54412, 54896, 51542)  
