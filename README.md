# 💳 Credit Card Transaction Analysis using SQL

## 📌 Project Overview

This project analyzes credit card transaction data to derive meaningful business insights using SQL. The analysis focuses on spending patterns across cities, customer segments, card types, and expense categories.

⸻

## 🎯 Objectives

* Identify high-value cities contributing to overall spends
* Analyze spending behavior across different card types
* Track cumulative spending milestones
* Understand gender-based contribution in spending
* Detect growth trends and anomalies

⸻

## 🗂️ Dataset Description

The dataset cc_transactions contains the following columns:

* transaction_id – Unique transaction identifier
* transaction_date – Date of transaction
* amount – Transaction amount
* card_type – Type of card (Gold, Silver, Platinum, Signature)
* exp_type – Expense category (Fuel, Bills, Shopping, etc.)
* gender – Customer gender (M/F)
* city – City where transaction occurred

⸻

##📊 Key Analyses & Insights

### 1. Top 5 Cities by Spend Contribution

Identifies cities contributing the most to total credit card spends.

👉 Business Use: Helps in targeted marketing and regional strategy.

⸻

### 2. Highest Spend Month per Card Type

Finds peak spending months for each card category.

👉 Business Use: Useful for campaign timing and promotions.

⸻

### 3. Milestone Tracking – ₹1,000,000 Spend

Tracks when each card type reaches cumulative spend of 1M.

👉 Business Use: Helps identify high-value customer segments.

⸻

### 4. Lowest Gold Card Spend Contribution by City

Identifies cities with minimal gold card usage.

👉 Business Use: Opportunity for premium card penetration.

⸻

### 5. Highest & Lowest Expense Type per City

Determines dominant and least popular spending categories.

👉 Business Use: Enables localized marketing strategies.

⸻

### 6. Female Spend Contribution by Category

Analyzes gender-based spending contribution.

👉 Business Use: Helps in customer segmentation and targeting.

⸻

### 7. Month-over-Month Growth Analysis (Jan 2014)

Finds highest growth in spend across card and expense combinations.

👉 Business Use: Detects emerging trends and seasonal spikes.

⸻

### 8. Weekend Spending Efficiency

Identifies cities with highest spend per transaction on weekends.

👉 Business Use: Helps optimize weekend campaigns.

⸻

### 9. Fastest City to Reach 500 Transactions

Measures transaction velocity across cities.

👉 Business Use: Indicates adoption and engagement levels.

⸻

## 🛠️ Tools Used

* SQL Server (T-SQL)
* Window Functions (RANK, LAG, ROW_NUMBER)
* Aggregations & CTEs

⸻

## 🚀 Key Learnings

* Advanced use of window functions for analytical queries
* Translating business problems into SQL logic
* Deriving actionable insights from raw transaction data

⸻

## 📌 Future Enhancements

* Build dashboard in Power BI / Tableau
* Add Python-based EDA & visualization
* Create predictive models for spend forecasting

⸻

## 👤 Author

Vishwas Jain
