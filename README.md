# 🏙️ Luxury Housing Sales Analytics Dashboard — Bangalore Region

**Author:** Mohammed Harif  
**Tools Used:**  Python  |   MySQL  |  Power BI  |  ⚙️ DAX  |  SQLAlchemy  |  Pandas  
**Dataset Size:**  100 000 + rows  
**Database:**  luxury_sales  

---

## 🧭 Project Overview

Bangalore’s luxury housing market is rapidly expanding, with demand varying across builders and micro-markets.  
This project builds a **complete data analytics pipeline** — from **data cleaning in Python** to **SQL storage** and an **interactive Power BI dashboard** — providing real-time insights into builder performance, pricing, booking conversions, and buyer behavior.

---

## 🎯 Objectives

- Clean, normalize, and enrich raw housing data using Python ETL  
- Load processed data into a MySQL database  
- Build a Power BI dashboard with live SQL connection  
- Create KPI metrics, filters, maps, and correlation visuals  
- Generate data-driven insights for decision-makers in real-estate firms  

---

## ⚙️ Tech Stack

| Layer | Tool / Library | Purpose |
|-------|----------------|----------|
| ETL / Cleaning | Python (pandas, numpy, dotenv, SQLAlchemy) | Data preprocessing |
| Database | MySQL 5.7 / 8.0 | Centralized data warehouse |
| Visualization | Power BI (DirectQuery) | Dashboard & KPIs |
| Language | DAX / SQL | Measures & aggregations |
| Version Control | Git + GitHub | Collaboration & backup |

---

##  End-to-End Architecture


Raw CSV
↓
Python ETL (etl_clean_load.py)
↓
MySQL Database (luxury_sales)
↓
Power BI Direct Connection
↓
Interactive Dashboard + DAX Insights


## Database Schema

| Table | Description |
|--------|-------------|
| cleaned_realestate_final | Fact table – all property records |
| dim_developer | Developer dimension |
| dim_date | Date dimension (for time analysis) |
| dim_possession (optional) | Derived possession status (“Ready to Move”, “Under Construction”) |

---

## Python Scripts

| File | Description |
|------|-------------|
| `etl_clean_load.py` | Cleans raw data, creates features, loads into MySQL |
| `load_to_mysql.py` | Writes cleaned CSV to `luxury_sales` database |
| `Housing Project.ipynb` | Jupyter Notebook – prototype exploration & cleaning |

---

## SQL Scripts

| File | Purpose |
|------|----------|
| `validation_queries.sql` | Row count, revenue checks, conversion rates |
| `schema.sql` | Table definitions |
| `aggregations.sql` | Analytical queries for cross-checking Power BI data |

---

##  Power BI Dashboard

**Pages & Visuals**

| Page | Visuals / Filters |
|------|--------------------|
| Overview | KPI Cards + Slicers (Builder  |  Quarter  |  Market) |
| Market Trends | Line Chart – Bookings by Quarter & Market |
| Builder Performance | Bar Chart – Revenue & Avg Ticket Size |
| Amenity Impact | Scatter Plot – Amenity Score vs Conversion |
| Booking Conversion | 100 % Stacked Column – Market vs Booking Status |
| Configuration Demand | Donut Chart – Configuration vs Bookings |
| Buyer Insights | Clustered Column – Possession Status vs Buyer Type |
| Geographical Insights | Map – Micro Market with bubbles by Bookings |
| Top Performers | Top 5 Builders + Dynamic Text Insights |

### 🔹 Dynamic DAX Insight 


## 📈 Key KPI Measures (Examples)

| KPI | DAX Formula |
|------|--------------|
| **Total Projects** | `DISTINCTCOUNT(Project_Name)` |
| **Total Bookings** | `COUNTROWS(FILTER(cleaned_realestate_final, Booking_Flag = 1))` |
| **Total Revenue (Cr)** | `SUM(Ticket_Price_Cr)` |
| **Booking Conversion %** | `DIVIDE([Total Bookings],[Total Projects],0)` |
| **Avg Price/Sqft** | `AVERAGE(Price_per_Sqft)` |

---

##  Business Insights

- Bookings rose 12 % in Q3 2024, led by Sobha & Prestige.  
- Whitefield & Electronic City = 40 % of total revenue.  
- Puravankara highest revenue but lower conversion (36 %).  
- 3 BHK = 65 % of bookings (most in-demand).  
- High Amenity Score →  +18 – 22 % conversion boost.  
- Ready-to-Move appeals to End-Users; Under-Construction to Investors.
