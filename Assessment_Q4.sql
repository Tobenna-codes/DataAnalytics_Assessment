-- Estimate CLV = (total_transaction / tenure) * 12 * profit_per_transaction
SELECT 
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,  -- Months since signup
    COUNT(s.id) AS total_transactions,  -- Total number of savings transactions
    ROUND(
        IF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) > 0,
           (COUNT(s.id) / TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())) * 12 * (0.001 * AVG(s.amount)),  -- CLV formula
           0), 2	-- Round the result of the CLV calculation to 2 decimal places
		) AS estimated_clv
FROM users_customuser u
LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id
GROUP BY u.id
HAVING total_transactions > 0  -- Only show users with at least 1 transaction
ORDER BY estimated_clv DESC;