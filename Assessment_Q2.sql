-- Classify users by how often they transact on savings
WITH customer_monthly_transactions AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), MAX(s.transaction_date)) + 1 AS active_months
    FROM savings_savingsaccount s
    GROUP BY s.owner_id
),
customer_avg_frequency AS (
    SELECT
        owner_id,
        total_transactions,
        active_months,
        ROUND(total_transactions / active_months, 2) AS avg_transactions_per_month
    FROM customer_monthly_transactions
),
categorized_customers AS (
    SELECT 
        CASE 
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_transactions_per_month
    FROM customer_avg_frequency
)
-- Summarize the result by category
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM categorized_customers
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');