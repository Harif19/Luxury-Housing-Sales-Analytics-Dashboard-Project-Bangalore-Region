-- ==========================================================
-- 🏗️ Luxury Housing Analytics Project
-- Validation & Business Insight Queries
-- Database  : luxury_sales
-- Table     : realestate_clean
-- Developer : Mohammed Harif
-- ==========================================================

USE luxury_sales;

-- ==========================================================
-- 1️⃣ ROW COUNT VALIDATION
-- Check total number of records loaded into MySQL
-- ==========================================================
SELECT COUNT(*) AS total_records FROM realestate_clean;


-- ==========================================================
-- 2️⃣ TOP DEVELOPERS BY REVENUE
-- Identify which developers generate the highest ticket value
-- ==========================================================
SELECT Developer_Name, 
       SUM(Ticket_Price_Rs) AS total_revenue, 
       COUNT(*) AS total_projects
FROM realestate_clean
WHERE Ticket_Price_Rs IS NOT NULL
GROUP BY Developer_Name
ORDER BY total_revenue DESC
LIMIT 10;


-- ==========================================================
-- 3️⃣ BOOKING CONVERSION BY MICRO MARKET
-- Analyze market-level conversion performance
-- ==========================================================
SELECT Micro_Market,
       COUNT(*) AS total_projects,
       SUM(COALESCE(Booking_Flag,0)) AS booked,
       ROUND(100*SUM(COALESCE(Booking_Flag,0))/COUNT(*),2) AS booking_conversion
FROM realestate_clean
GROUP BY Micro_Market
ORDER BY booking_conversion DESC
LIMIT 10;


-- ==========================================================
-- 4️⃣ AMENITY IMPACT ON BOOKINGS
-- Correlation between Amenity Score and booking success
-- ==========================================================
SELECT ROUND(Amenity_Score,0) AS Amenity_Group,
       COUNT(*) AS total_projects,
       ROUND(100*SUM(COALESCE(Booking_Flag,0))/COUNT(*),2) AS booking_rate
FROM realestate_clean
GROUP BY Amenity_Group
ORDER BY Amenity_Group;


-- ==========================================================
-- 5️⃣ CONFIGURATION DEMAND
-- Identify most demanded house configurations
-- ==========================================================
SELECT Configuration,
       COUNT(*) AS total_projects
FROM realestate_clean
GROUP BY Configuration
ORDER BY total_projects DESC;


-- ==========================================================
-- 6️⃣ QUARTERLY SALES TREND
-- Track real estate activity over fiscal quarters
-- ==========================================================
SELECT Purchase_Year,
       Quarter_Number,
       COUNT(*) AS total_sales
FROM realestate_clean
GROUP BY Purchase_Year, Quarter_Number
ORDER BY Purchase_Year, Quarter_Number;


-- ==========================================================
-- 7️⃣ BUYER TYPE DISTRIBUTION
-- Understand distribution of buyer categories
-- ==========================================================
SELECT Buyer_Type,
       COUNT(*) AS buyer_count,
       ROUND(100*COUNT(*) / (SELECT COUNT(*) FROM realestate_clean),2) AS pct_share
FROM realestate_clean
GROUP BY Buyer_Type
ORDER BY buyer_count DESC;


-- ==========================================================
-- 8️⃣ SENTIMENT ANALYSIS IMPACT
-- Measure sentiment vs. price & amenity averages
-- ==========================================================
SELECT ROUND(Buyer_Comment_Sentiment,0) AS Sentiment_Score_Group,
       COUNT(*) AS total,
       ROUND(AVG(Amenity_Score),2) AS avg_amenity,
       ROUND(AVG(Price_per_Sqft),2) AS avg_price
FROM realestate_clean
GROUP BY Sentiment_Score_Group
ORDER BY Sentiment_Score_Group;


-- ==========================================================
-- 9️⃣ TOP MICRO MARKETS BY AVERAGE PRICE
-- Evaluate high-value micro-markets
-- ==========================================================
SELECT Micro_Market,
       ROUND(AVG(Price_per_Sqft),2) AS avg_price_per_sqft,
       ROUND(AVG(Ticket_Price_Rs)/1e7,2) AS avg_ticket_price_cr,
       COUNT(*) AS listings
FROM realestate_clean
GROUP BY Micro_Market
ORDER BY avg_price_per_sqft DESC
LIMIT 10;


-- ==========================================================
-- 🔟 DATA COMPLETENESS CHECK
-- Identify null distribution for key fields
-- ==========================================================
SELECT 
    SUM(CASE WHEN Developer_Name IS NULL THEN 1 ELSE 0 END) AS null_developer,
    SUM(CASE WHEN Micro_Market IS NULL THEN 1 ELSE 0 END) AS null_market,
    SUM(CASE WHEN Ticket_Price_Rs IS NULL THEN 1 ELSE 0 END) AS null_price,
    SUM(CASE WHEN Amenity_Score IS NULL THEN 1 ELSE 0 END) AS null_amenity,
    SUM(CASE WHEN Booking_Flag IS NULL THEN 1 ELSE 0 END) AS null_booking
FROM realestate_clean;


-- ==========================================================
-- 🧾 END OF VALIDATION QUERIES
-- ==========================================================
