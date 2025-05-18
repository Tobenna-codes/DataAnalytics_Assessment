-- Find users who have both savings and investment plans, and total deposits
SELECT 
	u.id AS owner_id,
    CONCAT(COALESCE(u.first_name, ''), ' ', COALESCE(u.last_name, '')) AS name,
    COUNT(DISTINCT s.id) AS savings_count,	 -- Count of unique savings transactions
    COUNT(DISTINCT p.id) AS investment_count,  -- Count of unique investment plans
    ROUND(SUM(s.amount), 2) AS total_deposits    -- Sum of all savings deposits(to 2 decimial place)
FROM users_customuser u
JOIN savings_savingsaccount s 
    ON u.id = s.owner_id 
    AND s.amount > 0    -- Ensure savings is funded
JOIN plans_plan p 
    ON u.id = p.owner_id 
    AND p.amount > 0    -- Ensure investment plan is funded
    AND p.is_a_fund = 1
GROUP BY u.id, u.first_name, u.last_name
HAVING savings_count > 0 AND investment_count > 0   -- Ensure both exist
ORDER BY total_deposits DESC;