-- Supermarket Sales Analysis -- SQL Queries
-- Dataset: data/supermarket_sales.csv (load into any SQL engine, e.g. SQLite/Postgres/BigQuery)
-- Table assumed name: sales

-- 1. Revenue and profit by branch/city
SELECT
    Branch,
    City,
    COUNT(*)                           AS num_transactions,
    ROUND(SUM(Total), 2)               AS total_revenue,
    ROUND(SUM("Gross income"), 2)      AS total_gross_income,
    ROUND(AVG(Total), 2)               AS avg_transaction_value
FROM sales
GROUP BY Branch, City
ORDER BY total_revenue DESC;

-- 2. Revenue and profit by product line
SELECT
    "Product line",
    COUNT(*)                                       AS num_transactions,
    ROUND(SUM(Total), 2)                           AS total_revenue,
    ROUND(SUM("Gross income"), 2)                  AS total_gross_income,
    ROUND(AVG("Customer stratification rating"), 2) AS avg_rating
FROM sales
GROUP BY "Product line"
ORDER BY total_revenue DESC;

-- 3. Top customer segments by revenue (customer type x gender x payment method)
SELECT
    "Customer type",
    Gender,
    Payment,
    COUNT(*)               AS num_transactions,
    ROUND(AVG(Total), 2)   AS avg_spend,
    ROUND(SUM(Total), 2)   AS total_revenue
FROM sales
GROUP BY "Customer type", Gender, Payment
ORDER BY total_revenue DESC
LIMIT 10;

-- 4. Revenue by day of week (requires a Weekday column derived from Date,
--    or use your engine's date function, e.g. STRFTIME('%w', Date) in SQLite)
SELECT
    Weekday,
    ROUND(SUM(Total), 2) AS total_revenue
FROM sales
GROUP BY Weekday
ORDER BY total_revenue DESC;

-- 5. Monthly revenue trend by branch (window function example)
SELECT
    Branch,
    Month,
    ROUND(SUM(Total), 2) AS monthly_revenue,
    ROUND(
        SUM(SUM(Total)) OVER (PARTITION BY Branch ORDER BY Month), 2
    ) AS running_total_revenue
FROM sales
GROUP BY Branch, Month
ORDER BY Branch, Month;

-- 6. Payment method mix (share of transactions)
SELECT
    Payment,
    COUNT(*) AS num_transactions,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM sales), 1) AS pct_of_transactions
FROM sales
GROUP BY Payment
ORDER BY num_transactions DESC;
