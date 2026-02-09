-- ==========================================================================================
-- 06. Validation & Sanity Checks
-- ==========================================================================================

SELECT COUNT(*) AS users FROM dbo.users_payment_v3;
SELECT COUNT(*) AS txns FROM dbo.transactions_payment_v3;
SELECT COUNT(*) AS flags FROM dbo.risk_flags_payment_v3;

SELECT COUNT(*) AS orphan_txns
FROM dbo.transactions_payment_v3 t
LEFT JOIN dbo.users_payment_v3 u
ON t.user_id = u.user_id
WHERE u.user_id IS NULL;
