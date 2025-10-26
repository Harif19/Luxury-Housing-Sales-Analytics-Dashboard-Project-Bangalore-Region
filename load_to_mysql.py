# ==========================================================
# 🏡 Luxury Housing Analytics — Load Cleaned CSV to MySQL
# Author: Mohammed Harif
# ==========================================================

import pandas as pd
from sqlalchemy import create_engine
import pymysql

# ✅ Step 1: File Path
csv_path = r"C:\Luxury Housing Analytics\data\cleaned_realestate_final_filled.csv"

# ✅ Step 2: MySQL Connection Details
DB_USER = "harif"
DB_PASS = "root"
DB_HOST = "127.0.0.1"
DB_PORT = "3306"
DB_NAME = "luxury_sales"
TABLE_NAME = "cleaned_realestate_final"

# ✅ Step 3: Load CSV
print("📂 Reading CSV file from:", csv_path)
df = pd.read_csv(csv_path)
print(f"✅ Data loaded successfully! Shape: {df.shape}")

# ✅ Step 4: Create MySQL Connection (SQLAlchemy Engine)
connection_string = f"mysql+pymysql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine = create_engine(connection_string)

# ✅ Step 5: Upload to MySQL
try:
    df.to_sql(
        name=TABLE_NAME,
        con=engine,
        if_exists="replace",  # use "append" if you don’t want to overwrite
        index=False,
        chunksize=1000,
        method="multi"
    )
    print("🚀 Data successfully loaded into MySQL!")
    print(f"📊 Table Name: {TABLE_NAME}")
    print(f"🗄️ Database: {DB_NAME}")

except Exception as e:
    print("❌ Error while loading data into MySQL:", e)

