-- Create and Use Database ecommerce_project
CREATE DATABASE ecommerce_project;
USE ecommerce_project;

-- Create three Tables
-- Create Table for Users
CREATE Table users(
	user_id VARCHAR(50) PRIMARY KEY,
    device_type VARCHAR(50),
    traffic_source VARCHAR(50),
	user_type VARCHAR(50),
    location VARCHAR(50)
);

-- Create Table – transactions (from cleaned_transactions.csv)
CREATE Table transactions (
	user_id VARCHAR(20),
    order_id VARCHAR(20) PRIMARY KEY,
    order_amount FLOAT,
	`timestamp` DATETIME
);

-- Create Table – clickstream (from cleaned_clickstream.csv)
CREATE Table clickstream (
	user_id VARCHAR(20),
	session_id VARCHAR(20),
    `timestamp` datetime,
    page_name VARCHAR(20),
    event_type VARCHAR(20),
    product_id VARCHAR(20)
);


-- Check for the CSV Tables imported 					
SELECT * FROM users LIMIT 5;
SELECT * FROM transactions LIMIT 5;
SELECT * FROM clickstream LIMIT 5;

-- KPI analysis Steps

-- Step 1: Analyze Conversion. Aim: Find out how many users actually bought something
-- Count how many unique users are in the users table
SELECT 
	COUNT(DISTINCT user_id) AS total_users
FROM users; -- 199 distinct total users

-- Count total buyers i.e those who made at least one transaction (transactions table)
SELECT 
	COUNT(DISTINCT order_id) AS total_buyers
FROM transactions; -- 134 distinct total buyers

-- To calculate the conversion rate. i.e the percentage of users who made a purchase out of all users who visited the site
-- Using the users and transaction tables

SELECT 
	ROUND(COUNT(DISTINCT t.user_id) / COUNT(DISTINCT u.user_id) * 100, 2) as conversion_rate
FROM users u
LEFT JOIN transactions t
	ON u.user_id = t.user_id; -- Conversion is 50.75%

-- Step 2: Total Revenue 
-- How much money did we make from all confirmed purchases? i.e sum of all order_amount values in the transactions table
SELECT 
	ROUND(SUM(order_amount), 2) as total_revenue
FROM transactions; -- Total revenue from all purchases $20078.97

-- Average Order Value (AOV) from the transaction table
SELECT 
	ROUND(AVG(order_amount), 2) as Average_Order_Value
FROM transactions; -- The Average Order Value is $149.84

-- Max/Min order value from the transaction table 
SELECT 
	MIN(order_amount) as Minimum_order_amount,
    MAX(order_amount) as Maximum_order_amount
FROM transactions; -- The Min and max order amount are 24.49 and 299.61 respectively

-- Step 3: Funnel Drop-Offs
-- To understand how many users reached each page (clickstream table) in the funnel and where they dropped off
SELECT 
	page_name,
	COUNT(DISTINCT user_id) as Users_reached
FROM clickstream
GROUP BY page_name
ORDER BY Users_reached;

-- To get the users with confirm orders (i.e from Transaction table they will have user id)
SELECT 
	COUNT(DISTINCT user_id)
FROM transactions;-- Funnel Breakdown with User Counts:
-- Homepage: 200 users, Product Page: 200 user, Cart: 200 users, Checkout: 200 users, Purchase Page: 198 users, 
-- Confirmed Orders: 101 users. Minimal drop-off through the funnel until the purchase step. A significant drop occurs 
-- between reaching the purchase page (198 users) and completing the transaction (101), suggesting potential friction at 
-- the final conversion stage.

-- Step 4: Segment Analysis — To uncover who the best customers are based on: Device, traffic source, ,location and user type.alter

-- A.Conversion Rate by Device Type
SELECT 
    u.device_type,
    COUNT(DISTINCT t.user_id) AS buyers,
    COUNT(DISTINCT u.user_id) AS total_users,
    ROUND(COUNT(DISTINCT t.user_id) / COUNT(DISTINCT u.user_id) * 100, 2) AS conversion_rate
FROM users u
LEFT JOIN transactions t ON u.user_id = t.user_id
GROUP BY u.device_type;
-- Conversion by Device:
-- Desktop: 33 buyers / 63 users → 52.38%
-- Mobile: 33 buyers / 70 users → 47.14%
-- Tablet: 35 buyers / 66 users → 53.03%
-- Insight: Tablets convert best, mobile lags slightly. UX improvements may help mobile.

-- B.Revenue by Location (Country)
SELECT
	location,
    ROUND(SUM(order_amount), 2) as total_revenue
FROM users u
JOIN transactions t
	ON u.user_id = t.user_id
GROUP BY location
ORDER BY total_revenue DESC
LIMIT 5;
-- Top 5 revenue-generating countries:
-- Kuwait: $1,010.31
-- Tanzania: $875.41
-- Rwanda: $844.62
-- US Minor Outlying Islands: $645.17
-- Montserrat: $482.06

--  C: AOV by traffic source
SELECT
	traffic_source,
    COUNT(DISTINCT t.user_id) AS buyers,
    ROUND(AVG(order_amount),2) AS AOV_by_traffic_source
FROM users u
JOIN transactions t
	ON u.user_id = t.user_id
GROUP BY traffic_source
ORDER BY AOV_by_traffic_source desc;
-- AOV by Traffic Source:
-- paid_search: 16 buyers, $167.44 AOV
-- direct: 26 buyers, $155.60 AOV
-- social: 21 buyers, $149.39 AOV
-- organic: 19 buyers, $143.85 AOV
-- email: 19 buyers, $133.03 AOV
-- Paid Search leads in spend; Email has room to grow.

-- D. Segment by user_type: Analyze AOV for new vs. returning users
SELECT
    u.user_type,
    COUNT(DISTINCT t.user_id) AS buyers,
    ROUND(AVG(t.order_amount), 2) AS average_order_value
FROM users u
JOIN transactions t
    ON u.user_id = t.user_id
GROUP BY u.user_type
ORDER BY average_order_value DESC;
-- AOV by User Type:
-- returning: 45 buyers, AOV = $144.84
-- new: 56 buyers, AOV = $153.33
-- Insight: New users spent slightly more on average. Consider reinforcing conversion offers at first visit.

-- Step 5: Time-Based Insights
-- Step A: Purchase Hour & Day Analysis
SELECT 
	HOUR(timestamp) AS purchase_hour,
    COUNT(*) AS total_purchases
FROM transactions
GROUP BY purchase_hour
ORDER BY purchase_hour;

--  Purchases by Day of the Week
SELECT 
	DAYNAME(timestamp) AS purchase_day,
    COUNT(*) AS total_purchases
FROM transactions
GROUP BY purchase_day
ORDER BY FIELD (purchase_day, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- Purchases by Hour:
-- Peak hour = 20:00 (16 purchases) and high activity between 12:00 and 21:00 → best time for campaigns
-- Purchases by Day:
-- Friday: 47 purchases, Wednesday: 44 purchases and Thursday: 43 purchases
-- Insight: Mid-to-late week drives the most conversions — ideal for email or promo timing.

-- Step 5B: Time to Convert (also known as funnel duration)
-- First interaction timestamp per user (first session/page load)
SELECT
	user_id,
	MIN(timestamp) as first_touch
FROM clickstream
GROUP BY user_id;

-- Calculate time to convert (in hours) for each user who made a purchase
SELECT 
    t.user_id,
    ft.first_touch,
    t.timestamp AS purchase_time,
    TIMESTAMPDIFF(HOUR, ft.first_touch, t.timestamp) AS hours_to_convert
FROM transactions t
JOIN (
    SELECT 
        user_id,
        MIN(timestamp) AS first_touch
    FROM clickstream
    GROUP BY user_id
) ft ON t.user_id = ft.user_id;

-- Summary  stats for time-to-convert (in hours)
SELECT
    MIN(hours_to_convert) AS min_time,
    MAX(hours_to_convert) AS max_time,
    ROUND(AVG(hours_to_convert), 2) AS avg_time
FROM (
    SELECT 
        TIMESTAMPDIFF(HOUR, ft.first_touch, t.timestamp) AS hours_to_convert
    FROM transactions t
    JOIN (
        SELECT user_id, MIN(timestamp) AS first_touch
        FROM clickstream
        GROUP BY user_id
    ) ft ON t.user_id = ft.user_id
) AS conversion_data;

-- To Count of users by time-to-convert buckets
SELECT
    CASE 
        WHEN hours_to_convert <= 1 THEN '≤ 1 hour'
        WHEN hours_to_convert <= 12 THEN '1–12 hrs'
        WHEN hours_to_convert <= 24 THEN '12–24 hrs'
        WHEN hours_to_convert <= 48 THEN '1–2 days'
        ELSE '> 2 days'
    END AS conversion_bucket,
    COUNT(*) AS user_count
FROM (
    SELECT 
        TIMESTAMPDIFF(HOUR, ft.first_touch, t.timestamp) AS hours_to_convert
    FROM transactions t
    JOIN (
        SELECT user_id, MIN(timestamp) AS first_touch
        FROM clickstream
        GROUP BY user_id
    ) ft ON t.user_id = ft.user_id
) AS conversion_data
GROUP BY conversion_bucket
ORDER BY FIELD(conversion_bucket, '≤ 1 hour', '1–12 hrs', '12–24 hrs', '1–2 days', '> 2 days');

-- Time-to-Convert Distribution (in Hours)
-- ≤ 1 hour       → 11 users
-- 1–12 hrs       → 33 users
-- 12–24 hrs      → 13 users
-- 1–2 days       → 40 users
-- > 2 days       → 37 users
-- Insight: 33% of users convert within 12 hours.Most users (77/134) convert after 1 day → consider reminder emails and urgency tactics.

/* E-Commerce Funnel KPI Summary
Step 1: Conversion Rate
- Total Users: 200
- Purchasers: 101
- Conversion Rate: 50.75%
Step 2: Revenue
- Total Revenue: $20,078.97
- AOV: $149.84
...
Step 5: Time-to-Convert
- Avg. conversion time: 28.83 hrs
- 33% of users converted in ≤12 hours
End of KPI Summary
*/







