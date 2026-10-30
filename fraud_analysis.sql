-- EDA
-- overview
SELECT 
    COUNT(*) AS total_transaction
FROM
    fraud_raw;

SELECT 
    COUNT(*) AS total_fraud_case
FROM
    fraud_raw
WHERE
    is_fraud = 1;

SELECT 
    ROUND(100 * SUM(is_fraud) / COUNT(*), 2) AS fraud_rate
FROM
    fraud_raw;
    
    
-- fraud or non-fraud check 
SELECT 
    is_fraud,
    COUNT(*) AS total_transaction,
    ROUND(AVG(amt), 2) AS avg_transaction_amount,
    ROUND(MAX(amt), 2) AS max_transaction_amount
FROM
    fraud_raw
GROUP BY is_fraud;

-- data_quality_check.

SELECT 
    COUNT(*) - COUNT(cc_num) AS missing_cc_num,
    COUNT(*) - COUNT(merchant) AS missing_mechant,
    COUNT(*) - COUNT(category) AS missing_category
FROM
    fraud_raw;

SELECT 
    trans_num, COUNT(*)
FROM
    fraud_raw
GROUP BY trans_num
HAVING COUNT(*) > 1;

-- risky_category_analysis.

SELECT 
    category,
    COUNT(*) total_transaction,
    SUM(is_fraud) fraud_case,
    ROUND(100 * SUM(is_fraud) / COUNT(*), 2) fraud_rate
FROM
    fraud_raw
GROUP BY category
ORDER BY fraud_rate DESC;

-- most fraud state analysis
SELECT 
    state, COUNT(*) AS fraud_cases
FROM
    fraud_raw
WHERE
    is_fraud = 1
GROUP BY state
ORDER BY fraud_cases DESC;

-- city analysis

SELECT 
    city, COUNT(*) AS fraud_cases
FROM
    fraud_raw
WHERE
    is_fraud = 1
GROUP BY city
ORDER BY fraud_cases DESC;


-- mercehant analysis

SELECT 
    merchant, COUNT(*) AS fraud_cases
FROM
    fraud_raw
WHERE
    is_fraud = 1
GROUP BY merchant
ORDER BY fraud_cases DESC;

-- gender analysis
SELECT 
    gender, COUNT(*) AS fraud_cases
FROM
    fraud_raw
WHERE
    is_fraud = 1
GROUP BY gender
ORDER BY fraud_cases DESC;

-- job analysis

SELECT 
    job, COUNT(*) AS fraud_cases
FROM
    fraud_raw
WHERE
    is_fraud = 1
GROUP BY job
ORDER BY fraud_cases DESC;

-- Transaction amount analysis
SELECT 
    CASE
        WHEN amt < 50 THEN 'Under 50'
        WHEN amt < 100 THEN '50-99.99'
        WHEN amt < 500 THEN '100-499.99'
        WHEN amt < 1000 THEN '500-999.99'
        ELSE '1000+'
    END AS amount_range,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_cases,
    ROUND(100.0 * SUM(is_fraud) / COUNT(*), 2) AS fraud_rate
FROM
    fraud_raw
GROUP BY amount_range
ORDER BY MIN(amt);

-- Transection hour
SELECT
    HOUR(trans_date_trans_time) AS transaction_hour,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_cases,
    ROUND(
        100.0 * SUM(is_fraud) / COUNT(*), 2
    ) AS fraud_rate
FROM fraud_raw
GROUP BY HOUR(trans_date_trans_time)
ORDER BY transaction_hour;

-- Monthly fraud trend

SELECT
    DATE_FORMAT(trans_date_trans_time, '%Y-%m')
        AS transaction_month,
    SUM(is_fraud) AS fraud_cases
FROM fraud_raw
GROUP BY DATE_FORMAT(trans_date_trans_time, '%Y-%m')
ORDER BY fraud_cases DESC
LIMIT 1;

-- Age group analysis
-- customer age group

select
case
when
TIMESTAMPDIFF(
            YEAR, dob, trans_date_trans_time
        ) < 25 THEN 'Under 25'
        when TIMESTAMPDIFF(
            YEAR, dob, trans_date_trans_time
        ) < 40 THEN '25-39'
        when TIMESTAMPDIFF(
            YEAR, dob, trans_date_trans_time
        ) < 60 THEN '40-59'
        else '60+'
        END AS age_group,

    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_cases,

    COUNT(*) - SUM(is_fraud)
        AS non_fraud_cases,

    ROUND(
        100.0 * SUM(is_fraud) / COUNT(*), 2
    ) AS fraud_rate

FROM fraud_raw
WHERE dob IS NOT NULL
GROUP BY age_group
ORDER BY MIN(
    TIMESTAMPDIFF(YEAR, dob, trans_date_trans_time)
);
-- customer level fraud analysis 
-- Customer-wise Fraud Overview


SELECT
    cc_num,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_cases,

    COUNT(*) - SUM(is_fraud)
        AS non_fraud_cases,

    ROUND(
        100.0 * SUM(is_fraud) / COUNT(*), 2
    ) AS fraud_rate,

    ROUND(
        SUM(CASE
            WHEN is_fraud = 1 THEN amt
            ELSE 0
        END), 2
    ) AS total_fraud_amount

FROM fraud_raw
WHERE cc_num IS NOT NULL
GROUP BY cc_num
ORDER BY fraud_cases DESC;

-- Repeat Fraud Customer Analysis

SELECT
    cc_num,
    SUM(is_fraud) AS fraud_cases,
    ROUND(SUM(
        CASE WHEN is_fraud = 1
             THEN amt ELSE 0
        END
    ), 2) AS total_fraud_amount
FROM fraud_raw
WHERE cc_num IS NOT NULL
GROUP BY cc_num
HAVING SUM(is_fraud) >= 2
ORDER BY fraud_cases DESC;

-- CTE
-- Merchant Category Fraud Summary
WITH category_summary as (
SELECT category,
count(*) as total_transactions,
SUM(is_fraud) as fraud_case,
round(
100.0 * sum(is_fraud) / count(*), 2
) as fraud_rate
from fraud_raw
GROUP BY category
)
SELECT * FROM category_summary
ORDER BY fraud_rate desc;

-- Monthly Fraud Summary 


WITH monthly_summary AS (
    SELECT
        DATE_FORMAT(
            trans_date_trans_time, '%Y-%m'
        ) AS transaction_month,
        COUNT(*) AS total_transactions,
        SUM(is_fraud) AS fraud_cases,
        ROUND(
            100.0 * SUM(is_fraud) / COUNT(*), 2
        ) AS fraud_rate
    FROM fraud_raw
    GROUP BY DATE_FORMAT(
        trans_date_trans_time, '%Y-%m'
    )
)
SELECT *
FROM monthly_summary
WHERE fraud_cases > 0
ORDER BY transaction_month;


-- month

SELECT
    DATE_FORMAT(trans_date_trans_time, '%Y-%m') AS month,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_cases,
    ROUND(100.0 * SUM(is_fraud) / COUNT(*), 2)
        AS fraud_rate
FROM fraud_raw
GROUP BY DATE_FORMAT(trans_date_trans_time, '%Y-%m')
ORDER BY month;

-- Window Functions
-- Rank Merchants by Fraud Cases

WITH merchant_summary AS (
    SELECT
        merchant,
        COUNT(*) AS total_transactions,
        SUM(is_fraud) AS fraud_cases,
        ROUND(
            100.0 * SUM(is_fraud) / COUNT(*), 2
        ) AS fraud_rate
    FROM fraud_raw
    GROUP BY merchant
)
SELECT
    merchant,
    total_transactions,
    fraud_cases,
    fraud_rate,
    DENSE_RANK() OVER (
        ORDER BY fraud_cases DESC
    ) AS fraud_rank
FROM merchant_summary
ORDER BY fraud_rank
LIMIT 20;


-- view
-- Create a Fraud Summary View

CREATE OR REPLACE VIEW vw_fraud_summary AS
SELECT
    category,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_cases,
    ROUND(
        100.0 * SUM(is_fraud) / COUNT(*), 2
    ) AS fraud_rate,
    ROUND(
        SUM(CASE
            WHEN is_fraud = 1 THEN amt
            ELSE 0
        END), 2
    ) AS fraud_amount
FROM fraud_raw
GROUP BY category;

SELECT *
FROM vw_fraud_summary
ORDER BY fraud_rate DESC;


-- Customer Risk Segmentation
-- Rule-Based Customer Segments


WITH customer_summary AS (
    SELECT
        cc_num,
        COUNT(*) AS total_transactions,
        SUM(is_fraud) AS fraud_cases,
        ROUND(
            100.0 * SUM(is_fraud) / COUNT(*), 2
        ) AS fraud_rate
    FROM fraud_raw
    WHERE cc_num IS NOT NULL
    GROUP BY cc_num
)
SELECT
    cc_num,
    total_transactions,
    fraud_cases,
    fraud_rate,
    CASE
        WHEN fraud_cases >= 2
            THEN 'Repeat Fraud-Labeled'
        WHEN fraud_cases = 1
            THEN 'Single Fraud-Labeled'
        ELSE 'No Fraud-Labeled Transactions'
    END AS customer_segment
FROM customer_summary
ORDER BY fraud_cases DESC, fraud_rate DESC;

-- kpi analysis
SELECT
    ROUND(
        SUM(CASE
            WHEN is_fraud = 1 THEN amt
            ELSE 0
        END), 2
    ) AS total_fraud_amount
FROM fraud_raw;

-- SQL Performance Optimization
SHOW INDEX FROM fraud_raw

EXPLAIN
SELECT
    category,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_cases
FROM fraud_raw
GROUP BY category;


