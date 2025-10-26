-- ==========================================================
-- Luxury Housing Analytics: Aggregation Queries
-- Cross-check Power BI KPIs and visual calculations
-- ==========================================================

-- 1. Total Rows and Booking Counts
SELECT 
    COUNT(*) AS Total_Records,
    SUM(Booking_Flag) AS Total_Bookings,
    ROUND(AVG(Price_per_Sqft), 2) AS Avg_Price_Sqft
FROM cleaned_realestate_final;

-- 2. Top Builders by Total Revenue
SELECT 
    Developer_Name,
    SUM(Ticket_Price_Cr) AS Total_Revenue_Cr,
    COUNT(*) AS Total_Bookings,
    ROUND(AVG(Ticket_Price_Cr), 2) AS Avg_Ticket_Size_Cr
FROM cleaned_realestate_final
WHERE Booking_Flag = 1
GROUP BY Developer_Name
ORDER BY Total_Revenue_Cr DESC
LIMIT 10;

-- 3. Booking Conversion by Micro Market
SELECT 
    Micro_Market,
    SUM(Booking_Flag) AS Booked_Units,
    COUNT(*) AS Total_Units,
    ROUND(SUM(Booking_Flag) / COUNT(*) * 100, 2) AS Booking_Conversion_Percent
FROM cleaned_realestate_final
GROUP BY Micro_Market
ORDER BY Booking_Conversion_Percent DESC;

-- 4. Quarterly Booking Trends
SELECT 
    Purchase_Quarter,
    SUM(Booking_Flag) AS Total_Bookings,
    ROUND(AVG(Price_per_Sqft), 2) AS Avg_Price_Sqft
FROM cleaned_realestate_final
GROUP BY Purchase_Quarter
ORDER BY Purchase_Quarter;

-- 5. Configuration Demand
SELECT 
    Configuration,
    SUM(Booking_Flag) AS Total_Bookings,
    ROUND(SUM(Booking_Flag) / (SELECT SUM(Booking_Flag) FROM cleaned_realestate_final) * 100, 2) AS Share_Percent
FROM cleaned_realestate_final
GROUP BY Configuration
ORDER BY Total_Bookings DESC;

-- 6. Sales Channel Efficiency
SELECT 
    Sales_Channel,
    SUM(Booking_Flag) AS Bookings,
    COUNT(*) AS Leads,
    ROUND(SUM(Booking_Flag) / COUNT(*) * 100, 2) AS Conversion_Percent
FROM cleaned_realestate_final
GROUP BY Sales_Channel
ORDER BY Conversion_Percent DESC;

-- 7. Amenity Impact
SELECT 
    ROUND(AVG(Amenity_Score), 2) AS Avg_Amenity_Score,
    ROUND(AVG(Connectivity_Score), 2) AS Avg_Connectivity_Score,
    ROUND(SUM(Booking_Flag) / COUNT(*) * 100, 2) AS Conversion_Percent
FROM cleaned_realestate_final;

-- 8. Buyer Type Distribution
SELECT 
    Buyer_Type,
    SUM(Booking_Flag) AS Booked,
    COUNT(*) AS Total,
    ROUND(SUM(Booking_Flag) / COUNT(*) * 100, 2) AS Conversion_Percent
FROM cleaned_realestate_final
GROUP BY Buyer_Type
ORDER BY Conversion_Percent DESC;

-- 9. Sentiment Impact (optional)
SELECT 
    Buyer_Comment_Sentiment,
    COUNT(*) AS Total_Comments,
    ROUND(SUM(Booking_Flag) / COUNT(*) * 100, 2) AS Conversion_Percent
FROM cleaned_realestate_final
GROUP BY Buyer_Comment_Sentiment
ORDER BY Conversion_Percent DESC;

-- 10. Market-Level Summary
SELECT 
    Micro_Market,
    SUM(Ticket_Price_Cr) AS Revenue_Cr,
    SUM(Booking_Flag) AS Bookings,
    ROUND(AVG(Price_per_Sqft), 2) AS Avg_Price_Sqft,
    COUNT(DISTINCT Developer_Name) AS Active_Developers
FROM cleaned_realestate_final
GROUP BY Micro_Market
ORDER BY Revenue_Cr DESC;
