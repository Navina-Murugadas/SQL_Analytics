-- ==========================================================================================
-- 1. Database & Table Creation
-- ==========================================================================================
CREATE DATABASE payments_fraud_risk;
USE payments_fraud_risk;

DROP TABLE IF EXISTS risk_flags_payment_v3;
DROP TABLE IF EXISTS transactions_payment_v3;
DROP TABLE IF EXISTS users_payment_v3;

CREATE TABLE dbo.users_payment_v3 (
    user_id INT NOT NULL PRIMARY KEY,
    user_name VARCHAR(50),
    country VARCHAR(30),
    signup_date DATE
);

CREATE TABLE dbo.transactions_payment_v3 (
    txn_id INT NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    amount DECIMAL(10,2),
    status VARCHAR(10),
    txn_type VARCHAR(20),
    txn_date DATE,
    CONSTRAINT fk_transactions_users_v3
        FOREIGN KEY (user_id) REFERENCES dbo.users_payment_v3(user_id)
);

CREATE TABLE dbo.risk_flags_payment_v3 (
    flag_id INT NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    flag_reason VARCHAR(50),
    flagged_date DATE,
    CONSTRAINT fk_risk_users_v3
        FOREIGN KEY (user_id) REFERENCES dbo.users_payment_v3(user_id)
);