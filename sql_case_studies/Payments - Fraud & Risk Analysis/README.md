# 💳 Payments Fraud & Risk Analysis  
### SQL Case Study — Fraud Detection, Risk Scoring & AML Analytics

---

## 📌 Project Overview

This case study simulates a **real-world payments fraud & risk monitoring system**, designed to reflect how **AML Analysts, Risk Analysts, Compliance Analysts, and Data Analysts** investigate suspicious user behavior using SQL.

The project covers:
- User transaction behavior analysis  
- Fraud pattern detection (velocity, high-value, failure patterns)  
- Risk flag generation & validation  
- User-level composite risk scoring  
- Country-level risk exposure analysis  

The dataset, logic, and outputs are intentionally designed to be **realistic, scalable, and interview-aligned**.

---

## 🧠 Business Context

A global payments platform processes thousands of transactions daily across multiple countries.  
The risk team needs to:

- Detect **potential fraud patterns**
- Identify **high-risk users**
- Understand **geographic risk exposure**
- Support **investigation & compliance workflows**

This case study replicates that environment using **synthetic but realistic data** and **production-style SQL logic**.

---

## 📂 Repository Structure

<img width="462" height="826" alt="Screenshot 2026-02-10 033919" src="https://github.com/user-attachments/assets/7fe3c36b-02d7-442d-afb8-00c22709b814" />

---

## 🧾 Dataset Summary

| Entity | Count |
|------|------|
| Users | 500 |
| Transactions | ~4,900 |
| Risk Flags | ~40 |

### Key Characteristics
- Variable transaction frequency per user (light, medium, heavy)
- Realistic success vs failure ratios
- High-value spikes, velocity bursts, and failure streaks
- Controlled and explainable fraud prevalence (~8%)

---

## 🏗️ SQL Pipeline Breakdown

### 1️⃣ Schema Setup
- Relational tables with primary & foreign key constraints
- Referential integrity enforced

📄 `01_schema_setup.sql`

---

### 2️⃣ User Generation
- 500 users
- Randomized signup dates
- Balanced country distribution (India, US, UK, Canada)

📄 `02_user_generation.sql`

---

### 3️⃣ Transaction Generation
- 4–29 transactions per user
- Mixed payment methods (CARD / BANK / WALLET)
- Distributed transaction dates

📄 `03_transaction_generation.sql`

---

### 4️⃣ Risk Behavior Injection
Introduces **realistic fraud behavior**:
- Higher failure rates for risky users
- Amount spikes for high-risk profiles
- Same-day transaction bursts (velocity fraud)

📄 `04_risk_behavior_injection.sql`

---

### 5️⃣ Risk Flag Generation
Flags users based on **data-driven rules**:
- **High Transaction Amount** (top 5%)
- **Velocity Fraud**
- **Multiple Failed Transactions**

📄 `05_risk_flag_generation.sql`

---

### 6️⃣ Validation Checks
- Orphan record detection
- Row count verification
- Data sanity checks

📄 `06_validation_checks.sql`

---

### 7️⃣ Fraud & Risk Analysis Queries (20 Queries)

📄 `Payments_Risk_Fraud_Analysis.sql`

Covers:
- Failed transaction patterns
- Outlier detection
- Velocity fraud
- GAP & ISLAND analysis
- Country-level risk exposure
- Composite user risk scoring

---

## 📊 Key Analytical Insights

### 🔹 Time-Based Fraud
- Certain weeks show **spikes in failed transactions**, indicating attack windows

### 🔹 Geographic Risk
- Canada & US show higher failure rates and transaction volumes
- Supports geo-based risk segmentation

### 🔹 User Risk Scoring
- Composite score combines:
  - Failed transactions
  - High-value transactions
- Produces a **prioritized investigation list**

### 🔹 Operational Realism
- Only ~8% users flagged
- Multiple flag reasons exist
- No artificial uniformity in behavior

---

## 🧠 Operational Impact

This analysis enables:
- **Investigation prioritization**
- **Reduced false positives**
- **Risk-based monitoring**
- **Actionable AML workflows**

The outputs can directly feed:
- Case management tools
- Alerting systems
- Compliance reviews

---

## 🎯 Skills Demonstrated

- Advanced SQL (CTEs, Window Functions, Ranking, GAP & ISLAND)
- Fraud & AML domain understanding
- Risk rule design
- Data modeling & validation
- Business-driven analytics

---

## 👔 Role Alignment

This project is well-aligned for:
- AML Analyst  
- Risk Analyst  
- Compliance Analyst  
- Payments / Fraud Analyst  
- Senior Data Analyst  

It also demonstrates **Team Lead–level thinking** in:
- Risk calibration
- Data realism
- Operational impact

---

## 📎 Case Study Document

📄 **Full Case Study (PDF):**  
`case-study/Payment_Fraud_Risk_Analysis.pdf`

Includes:
- Executive summary
- Methodology
- SQL logic explanation
- Insights & recommendations

---

## 🚀 How to Use

1. Run SQL files in order (`01` → `06`)
2. Execute analysis queries
3. Review PDF for insights
4. Explore CSVs for validation

---

## 🏁 Final Note

This case study is designed to **withstand senior interviewer scrutiny**.  
It prioritizes **realism over volume** and **insight over vanity metrics**.

