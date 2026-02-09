-- ==========================================================================================
-- 02. User Population (500 Users)
-- ==========================================================================================

;WITH nums AS (
    SELECT TOP 500
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO dbo.users_payment_v3
SELECT
    10000 + n AS user_id,
    CONCAT('User_', 10000 + n),
    CASE
        WHEN n % 4 = 0 THEN 'India'
        WHEN n % 4 = 1 THEN 'US'
        WHEN n % 4 = 2 THEN 'UK'
        ELSE 'Canada'
    END,
    DATEADD(DAY, -(n % 180), '2024-06-30')
FROM nums;
