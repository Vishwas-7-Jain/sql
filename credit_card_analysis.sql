/*
Project: Credit Card Transaction Analysis
Description: SQL-based analysis of credit card transactions to derive business insights
*/

------------------------------------------------------------
-- 1. Top 5 Cities by Total Spend Contribution
------------------------------------------------------------
WITH city_spend AS (
    SELECT city, SUM(amount) AS spend
    FROM cc_transactions
    GROUP BY city
),
total_spend AS (
    SELECT SUM(amount) AS total_cc_spend
    FROM cc_transactions
)
SELECT TOP 5 
    cs.city,
    cs.spend,
    CAST(ROUND((cs.spend * 100.0 / ts.total_cc_spend), 2) AS DECIMAL(10,2)) AS contribution_percentage
FROM city_spend cs
CROSS JOIN total_spend ts
ORDER BY cs.spend DESC;


------------------------------------------------------------
-- 2. Highest Spend Month for Each Card Type
------------------------------------------------------------
WITH monthly_spend AS (
    SELECT 
        card_type,
        DATEPART(YEAR, transaction_date) AS spend_year,
        DATEPART(MONTH, transaction_date) AS spend_month,
        SUM(amount) AS total_spend
    FROM cc_transactions
    GROUP BY 
        card_type,
        DATEPART(YEAR, transaction_date),
        DATEPART(MONTH, transaction_date)
),
ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY card_type ORDER BY total_spend DESC) AS rn
    FROM monthly_spend
)
SELECT *
FROM ranked
WHERE rn = 1;


------------------------------------------------------------
-- 3. Transaction When Cumulative Spend Reaches 1,000,000
------------------------------------------------------------
WITH cte AS (
    SELECT *,
        SUM(amount) OVER (
            PARTITION BY card_type 
            ORDER BY transaction_date, transaction_id
        ) AS cum_spend
    FROM cc_transactions
),
filtered AS (
    SELECT *,
        RANK() OVER (PARTITION BY card_type ORDER BY cum_spend) AS rn
    FROM cte
    WHERE cum_spend >= 1000000
)
SELECT *
FROM filtered
WHERE rn = 1;


------------------------------------------------------------
-- 4. City with Lowest % Spend for Gold Card
------------------------------------------------------------
SELECT TOP 1
    city,
    SUM(CASE WHEN card_type = 'Gold' THEN amount ELSE 0 END) * 1.0
    / SUM(amount) AS gold_ratio
FROM cc_transactions
GROUP BY city
HAVING SUM(CASE WHEN card_type = 'Gold' THEN amount ELSE 0 END) > 0
ORDER BY gold_ratio ASC;


------------------------------------------------------------
-- 5. Highest and Lowest Expense Type per City
------------------------------------------------------------
WITH city_expense AS (
    SELECT 
        city,
        exp_type,
        SUM(amount) AS city_spend
    FROM cc_transactions
    GROUP BY city, exp_type
),
ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY city ORDER BY city_spend DESC) AS highest_rank,
        RANK() OVER (PARTITION BY city ORDER BY city_spend ASC) AS lowest_rank
    FROM city_expense
)
SELECT 
    city,
    MAX(CASE WHEN highest_rank = 1 THEN exp_type END) AS highest_expense_type,
    MAX(CASE WHEN lowest_rank = 1 THEN exp_type END) AS lowest_expense_type
FROM ranked
GROUP BY city;


------------------------------------------------------------
-- 6. Female Spend Contribution by Expense Type
------------------------------------------------------------
SELECT 
    exp_type,
    SUM(CASE WHEN gender = 'F' THEN amount ELSE 0 END) * 1.0 
    / SUM(amount) AS female_contribution
FROM cc_transactions
GROUP BY exp_type
ORDER BY female_contribution DESC;


------------------------------------------------------------
-- 7. Highest Month-over-Month Growth (Jan 2014)
------------------------------------------------------------
WITH monthly_spend AS (
    SELECT 
        card_type,
        exp_type,
        DATEPART(YEAR, transaction_date) AS year_val,
        DATEPART(MONTH, transaction_date) AS month_val,
        SUM(amount) AS total_spend
    FROM cc_transactions
    GROUP BY 
        card_type,
        exp_type,
        DATEPART(YEAR, transaction_date),
        DATEPART(MONTH, transaction_date)
),
lagged AS (
    SELECT *,
        LAG(total_spend) OVER (
            PARTITION BY card_type, exp_type 
            ORDER BY year_val, month_val
        ) AS prev_month_spend
    FROM monthly_spend
)
SELECT TOP 1 *,
    (total_spend - prev_month_spend) AS mom_growth
FROM lagged
WHERE prev_month_spend IS NOT NULL
    AND year_val = 2014
    AND month_val = 1
ORDER BY mom_growth DESC;


------------------------------------------------------------
-- 8. Weekend Spend per Transaction Ratio by City
------------------------------------------------------------
SELECT TOP 1
    city,
    SUM(amount) * 1.0 / COUNT(transaction_id) AS spend_per_transaction
FROM cc_transactions
WHERE DATENAME(WEEKDAY, transaction_date) IN ('Saturday', 'Sunday')
GROUP BY city
ORDER BY spend_per_transaction DESC;


------------------------------------------------------------
-- 9. Fastest City to Reach 500 Transactions
------------------------------------------------------------
WITH cte AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY city 
            ORDER BY transaction_date, transaction_id
        ) AS txn_rank
    FROM cc_transactions
)
SELECT TOP 1
    city,
    DATEDIFF(DAY, MIN(transaction_date), MAX(transaction_date)) AS days_taken
FROM cte
WHERE txn_rank IN (1, 500)
GROUP BY city
HAVING COUNT(*) = 2
ORDER BY days_taken ASC;
