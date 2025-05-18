-- CTE for last savings transactions
WITH savings_last_txn AS (
    SELECT 
        plan_id,
        owner_id,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    WHERE amount > 0  -- assuming inflow transactions are positive amounts
    GROUP BY plan_id, owner_id
),

-- CTE for last investment (plans) created
plans_last_txn AS (
    SELECT
        id AS plan_id,
        owner_id,
        last_charge_date AS last_transaction_date
    FROM plans_plan
    WHERE amount > 0  -- assuming investment involves funding amount
),

-- Combine both savings and investment plans
combined_plans AS (
    SELECT 
        s.plan_id,
        s.owner_id,
        'Savings' AS type,
        s.last_transaction_date
    FROM savings_last_txn s

    UNION ALL

    SELECT 
        p.plan_id,
        p.owner_id,
        'Investment' AS type,
        p.last_transaction_date
    FROM plans_last_txn p
),

-- Filter inactive plans
inactive_accounts AS (
    SELECT 
        plan_id,
        owner_id,
        type,
        last_transaction_date,
        DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days
    FROM combined_plans
    WHERE last_transaction_date IS NULL OR last_transaction_date < CURDATE() - INTERVAL 365 DAY
)

SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM inactive_accounts
ORDER BY inactivity_days DESC;
