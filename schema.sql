-- ==========================================================
-- Luxury Housing Analytics: Database Schema Definitions
-- Database: luxury_sales
-- Author: Mohammed Harif
-- ==========================================================

-- Drop existing tables (optional for reset)
DROP TABLE IF EXISTS cleaned_realestate_final;
DROP TABLE IF EXISTS dim_developer;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_possession;

-- ==========================================================
-- Developer Dimension
-- ==========================================================
CREATE TABLE dim_developer (
    Developer_ID INT AUTO_INCREMENT PRIMARY KEY,
    Developer_Name VARCHAR(255) UNIQUE NOT NULL
);

-- ==========================================================
-- Date Dimension
-- ==========================================================
CREATE TABLE dim_date (
    Date DATE PRIMARY KEY,
    Year INT,
    Quarter VARCHAR(10),
    Month INT,
    Month_Name VARCHAR(20),
    Year_Quarter VARCHAR(15)
);

-- ==========================================================
-- Possession Dimension (optional manual mapping)
-- ==========================================================
CREATE TABLE dim_possession (
    Project_Name VARCHAR(255) PRIMARY KEY,
    Possession_Status VARCHAR(50) -- Ready to Move / Under Construction
);

-- ==========================================================
-- Fact Table
-- ==========================================================
CREATE TABLE cleaned_realestate_final (
    Property_ID VARCHAR(100),
    Project_Name VARCHAR(255),
    Developer_Name VARCHAR(255),
    Developer_ID INT,
    Micro_Market VARCHAR(255),
    Booking_Date DATE,
    Purchase_Quarter VARCHAR(20),
    Purchase_Year INT,
    Ticket_Price_Cr DECIMAL(18,3),
    Price_per_Sqft DECIMAL(18,2),
    Unit_Size_Sqft DECIMAL(18,2),
    Configuration VARCHAR(50),
    Amenity_Score DECIMAL(5,2),
    Connectivity_Score DECIMAL(5,2),
    Locality_Infra_Score DECIMAL(5,2),
    Booking_Flag TINYINT,
    Booking_Status VARCHAR(50),
    Transaction_Type VARCHAR(50),
    Sales_Channel VARCHAR(100),
    Buyer_Type VARCHAR(50),
    Buyer_Segment VARCHAR(50),
    Buyer_Comments TEXT,
    Buyer_Comment_Sentiment VARCHAR(20),
    FOREIGN KEY (Developer_ID) REFERENCES dim_developer(Developer_ID)
);
