# Overview

This project contains SQL queries addressing four business questions related to customer plans, transactions and activity analysis. The queries are written using provided schema involving tables: users_customuser, plans_plan, savings_savingsaccount and withdrawals_withdrawal.

## Question Explanations
---
1. High-Value Customers with Multiple Products
Approach:
- Joined `plans_plan` table twice: once for savings and once for investment plans, linked by `owner_id`
- Counted distinct savings and investment plans per customer
- Took sum of all deposits from savings accounts
- Filtered customers with atleast one savings and one investment plan
- Combined the first and last name fields in a single `name` field
- sorted the result by total deposits in descending order

2. Transaction Frequency Analysis
Approach:
- Calculated total transaction counts and months active per customer based on transaction date
- Computed aveage transaction per month by dividing total transactions by active months
- Used `CASE` logic to categorize customers as High, Medium or low frequency based on the average transactions per month tresholds
- Aggregated counts and average transactions by frequency category for the final result

3. Account Inactivity in the last 1 year
Approach:
- Combined plans from both savings and investment plans
- Retrieved last transaction date per plan and calculated inactivity days based on current date
- Filtered for accounts with no transactions in the last 365 days

4. Customer Lifetime Value (CLV) Estimation
Approach:
- Calculated tenure in months from date joined to today
- Counted total transactions per customer
- Assumed an average profit per customer of 0.1% of transaction amount
- Estimated CLV using the formula: (total transaction / tenure) x 12 x average profit per transaction
- Ordered the result by estimated CLV in descending order to see high value customers at the top

---
## Challenges and Resolutions
- Handling zero or NULL transaction counts:
  Some cusomers had no transactions or incomplete data, which caused `NULL` values or zero counts. Resolved by using `COALESCE` and filtered out zero-tenure cases to avoid division errors
- Date range calculations:
  Calculating tenure and inactivity required careful date arithematic and using appropriate date functions like `DATEDIIFF` and `TIMESTAMPDIFF` to get consistent results. Took a bit of research but was worth it.
- Combining data from multiple product types:
  For cross-product analyses, joining plans and tranactions across savings and investments plans was complex due to different tables and IDs. Used UNION and JOIN strategies to merge data properly.
- Performance consideratons: The queries join large tables and aggregate over many rows, made sure there weren't unnecessary table joins and indexing key columns to minimize runtime.
