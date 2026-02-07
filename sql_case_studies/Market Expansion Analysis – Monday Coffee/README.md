
# ☕ Market Expansion Analysis – Monday Coffee
<img width="1920" height="1080" alt="Monday_Coffee_Banner" src="https://github.com/user-attachments/assets/870f46d7-7937-4f06-a50d-3fb40306aba5" />

**SQL Case Study | Business Recommendation | India**

This project analyzes historical sales data for **Monday Coffee** to recommend the **top three Indian cities** for opening new coffee shops. The analysis focuses on revenue performance, customer spending behavior, rental cost efficiency, and market potential using SQL.

---

## 📌 Business Objective

Monday Coffee aims to expand its physical presence by opening **three new coffee shops** in major Indian cities.

The objective of this analysis is to **identify the most profitable and scalable cities** for Phase-1 expansion by evaluating:
- Revenue performance  
- Customer base and spending behavior  
- Rental cost impact  
- Estimated coffee-consuming population  

All recommendations are derived from **data-driven SQL analysis**.

---

## 🗂️ Dataset Overview

The dataset consists of four relational tables:

- **city** – City demographics, population, estimated rent, and rank  
- **customers** – Customer information and city mapping  
- **products** – Coffee product catalog and pricing  
- **sales** – Transactional sales data (date, revenue, rating)

The schema follows a **normalized relational design** to ensure accurate aggregation and scalable analysis.

---

## 🧱 Database Schema

The database uses `sales` as the fact table and `city`, `customers`, and `products` as dimension tables.

**Key relationships:**
- One city → Many customers  
- One customer → Many sales  
- One product → Many sales  

This structure prevents double counting and enables city-level performance analysis.

---

## 📊 Key Metrics & Assumptions

### Assumptions
- **25% of the city population** is estimated to be potential coffee consumers  
- Rental cost is treated as a fixed city-level operational factor  

### Metrics Used
- Total Revenue  
- Total Customers  
- Average Sales per Customer  
- Estimated Coffee Consumers  
- Average Rent per Customer  

These metrics balance **market size, profitability, and cost efficiency**.

---

## 🧠 Analytical Approach

The analysis was performed using **SQL Server**, leveraging:
- Common Table Expressions (CTEs)
- Window functions
- City-level aggregations

Key analyses include:
- Revenue by city
- Customer distribution
- Product performance
- Monthly sales trends
- Rent vs revenue efficiency
- Market potential comparison across cities

---

## 📈 Market Potential Analysis

A final aggregated query was used to compare all cities across:
- Total revenue  
- Total customers  
- Estimated rent  
- Estimated coffee consumers  
- Average sales per customer  

This output served as the foundation for the expansion recommendation.

---

## ✅ Final Recommendation

### **Selected Cities for Phase-1 Expansion**
1. **Pune** – Performance-led expansion city  
2. **Chennai** – Balanced growth market  
3. **Bangalore** – Premium urban market  

### **Rationale**
- **Pune** demonstrates the highest revenue and strongest rent efficiency.  
- **Chennai** offers a strong balance between customer spending and market scalability.  
- **Bangalore** supports premium positioning, with higher rent offset by high customer willingness to pay.

### **Deferred Cities**
- **Delhi** – High potential but lower current monetization efficiency  
- **Jaipur** – Cost-efficient but limited scalability for flagship expansion  

---

## 📉 Business Impact

This data-driven expansion strategy is expected to:
- Maximize revenue per store  
- Optimize rent-to-revenue efficiency  
- Reduce expansion risk in Phase-1  
- Strengthen brand presence in premium and high-growth markets  

---

## 🛠️ Skills Demonstrated

- Advanced SQL (CTEs, Window Functions, Aggregations)
- Market Expansion & Profitability Analysis
- Business KPI Design
- Cost vs Revenue Trade-off Analysis
- Data-Driven Strategic Decision Making

---

## 📎 Project Files

- 📄 Market Expansion Analysis – Monday Coffee (PDF)  
- 🗃️ SQL schema and queries  
- 🖼️ Final market potential output screenshots  

---

## 📬 Author

**Navina M**  
Aspiring Data Analyst | Business Analyst | Risk Analyst  

---

⭐ If you found this project insightful, feel free to star the repository!
