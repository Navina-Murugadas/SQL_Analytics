# 📊 Dataset Overview — Payments Fraud & Risk Analysis

This directory contains the **final curated datasets** used for fraud detection and risk analysis in the Payments Fraud & Risk Analysis case study.

All datasets are **synthetic but behaviorally realistic**, designed to simulate how transaction data appears in real payment systems while preserving analytical integrity.

---

## 📁 Files Included

<img width="366" height="197" alt="Screenshot 2026-02-10 034257" src="https://github.com/user-attachments/assets/b988d750-f934-4885-9365-29a28110015c" />


---

## 🧾 Dataset Descriptions

### 1️⃣ `users_payment_v3.csv`
**User master data**

Contains one record per user with basic demographic and onboarding information.

**Key fields:**
- `user_id` – Unique user identifier
- `user_name` – Synthetic user name
- `country` – User country (India, US, UK, Canada)
- `signup_date` – Account creation date

**Purpose:**
- User segmentation
- Geographic risk analysis
- Joining point for transaction and risk data

---

### 2️⃣ `transactions_payment_v3.csv`
**Payment transaction data**

Contains all payment transactions performed by users.

**Key fields:**
- `txn_id` – Unique transaction identifier
- `user_id` – Reference to users table
- `amount` – Transaction amount
- `status` – `SUCCESS` or `FAILED`
- `txn_type` – Payment method (CARD / BANK / WALLET)
- `txn_date` – Transaction date

**Key characteristics:**
- Variable transaction frequency per user
- Realistic failure rates
- High-value transaction spikes
- Same-day transaction bursts (velocity patterns)
- Includes limited null values for data quality checks

**Purpose:**
- Fraud pattern detection
- Risk signal extraction
- Behavioral analysis
- Time-series analysis

---

### 3️⃣ `risk_flags_payment_v3.csv`
**Derived risk & fraud flags**

Contains users flagged for potential fraud based on behavioral rules.

**Key fields:**
- `flag_id` – Unique flag identifier
- `user_id` – Flagged user
- `flag_reason` – Risk category
  - High Transaction Amount
  - Velocity Fraud
  - Multiple Failed Transactions
- `flagged_date` – Date when risk was first observed

**Purpose:**
- Investigation prioritization
- Alert generation simulation
- AML & compliance workflows

---

## 📊 Dataset Scale

| Dataset | Records |
|------|------|
| Users | 500 |
| Transactions | ~4,900 |
| Risk Flags | ~40 |

Only a **small, realistic subset of users (~8%)** are flagged to avoid artificial over-flagging.

---

## 🔍 Data Design Principles

- Referential integrity preserved across datasets
- Fraud behavior injected in a controlled manner
- Non-uniform user behavior (no artificial patterns)
- Designed to support advanced SQL analytics
- Suitable for AML, Risk, and Compliance use cases

---

## ⚠️ Disclaimer

All data in this directory is **synthetic** and created **strictly for educational and portfolio purposes**.  
No real customer or transaction data is used.

---

