# 🧠 SQL Pipeline — Payments Fraud & Risk Analysis

This directory contains the **end-to-end SQL pipeline** used to simulate, detect, and analyze fraud and risk patterns in a global payments system.

The SQL scripts are designed to be **modular, reproducible, and production-aligned**, reflecting how AML and Risk teams build and validate fraud monitoring logic.

---

## 📂 Execution Order (Important)

Run the SQL files **in the order listed below**:

<img width="355" height="268" alt="Screenshot 2026-02-10 034123" src="https://github.com/user-attachments/assets/b8144bcf-a528-40f8-93c8-601846fb4a4c" />


Each script depends on the outputs of the previous step.

---

## 📄 File Descriptions

### 1️⃣ `01_schema_setup.sql`
**Purpose:** Database & schema creation  

- Creates database and core tables
- Defines primary and foreign key constraints
- Enforces referential integrity between users, transactions, and risk flags

---

### 2️⃣ `02_user_generation.sql`
**Purpose:** User population  

- Generates 500 synthetic users
- Assigns randomized signup dates
- Distributes users across multiple countries
- Ensures realistic onboarding patterns

---

### 3️⃣ `03_transaction_generation.sql`
**Purpose:** Transaction simulation  

- Generates variable transaction volumes per user (4–29)
- Assigns payment methods (CARD / BANK / WALLET)
- Randomizes amounts and transaction dates
- Creates realistic baseline behavior before fraud injection

---

### 4️⃣ `04_risk_behavior_injection.sql`
**Purpose:** Fraud behavior simulation  

Injects realistic fraud signals into the dataset:
- Elevated failure rates for risky users
- High-value transaction spikes
- Same-day transaction bursts (velocity fraud)
- Behavioral skewing while maintaining realistic distributions

This step ensures **non-uniform, non-synthetic-looking data**.

---

### 5️⃣ `05_risk_flag_generation.sql`
**Purpose:** Risk flag derivation  

Generates explainable AML flags using aggregated user behavior:
- **High Transaction Amount** (top percentile thresholds)
- **Velocity Fraud** (multiple same-day transactions)
- **Multiple Failed Transactions** (failure ratio + volume)

Flag logic is **rule-based, transparent, and auditable**, aligning with compliance standards.

---

### 6️⃣ `06_validation_checks.sql`
**Purpose:** Data quality & integrity checks  

- Verifies record counts
- Detects orphaned transactions
- Confirms successful pipeline execution
- Acts as a final sanity check before analysis

---

### 7️⃣ `Payments_Risk_Fraud_Analysis.sql`
**Purpose:** Fraud & risk analytics (20 queries)

Includes analytical queries covering:
- Failed transaction patterns
- Outlier detection
- Velocity fraud identification
- GAP & ISLAND analysis
- User-level success & failure rates
- Country-level risk exposure
- Composite user risk scoring

This file represents how analysts **extract actionable insights** from monitoring data.

---

## 🧩 Design Principles

- Modular SQL (easy to debug & extend)
- Explainable logic (AML-friendly)
- Realistic fraud prevalence (~8%)
- Minimal false positives
- Scalable design for larger datasets

---

## 👔 Role Alignment

This SQL pipeline is suitable for:
- AML Analyst
- Risk Analyst
- Compliance Analyst
- Payments / Fraud Analyst
- Senior Data Analyst

It also demonstrates **Team Lead–level system thinking** through:
- Risk calibration
- Behavioral modeling
- Validation discipline

---

## 🚀 Notes

- Scripts are written for **SQL Server**
- Uses CTEs, window functions, and analytical logic
- Designed to be readable, auditable, and interview-ready

---
