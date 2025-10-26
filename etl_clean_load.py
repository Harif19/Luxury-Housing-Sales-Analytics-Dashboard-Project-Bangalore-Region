# src/etl_clean_load.py
# ---------------------
# Luxury Housing Analytics - ETL Script
# Cleans data and loads into MySQL DB

import pandas as pd
import numpy as np
from sqlalchemy import create_engine
from datetime import datetime
import re, os

def clean_and_load(csv_path, db_url=None, table_name="realestate_clean"):
    """Clean housing dataset and optionally load to SQL DB."""
    print("📂 Loading CSV:", csv_path)
    df = pd.read_csv(csv_path, low_memory=False)
    print("✅ Raw shape:", df.shape)

    # ----- CLEANING -----
    df.columns = [c.strip() for c in df.columns]

    def normalize_text(s):
        if pd.isna(s):
            return np.nan
        return " ".join(str(s).strip().title().split())

    for col in ["Builder", "Micro_Market", "Configuration", "Sales_Channel",
                "Buyer_Type", "Possession_Status", "Booking_Status"]:
        if col in df.columns:
            df[col] = df[col].astype(str).replace("nan", np.nan)
            df[col] = df[col].apply(normalize_text)

    def safe_float(x):
        if pd.isna(x): return np.nan
        s = str(x).strip().lower().replace("₹", "").replace(",", "")
        if "cr" in s:
            try: return float(s.replace("cr", "").strip()) * 1e7
            except: return np.nan
        if "lakh" in s or "lac" in s:
            try:
                s2 = re.sub(r"[^\d\.]", "", s)
                return float(s2) * 1e5
            except: return np.nan
        try: return float(re.sub(r"[^\d\.]", "", s))
        except: return np.nan

    if "Ticket_Price_Cr" in df.columns:
        df["Ticket_Price_Rs"] = df["Ticket_Price_Cr"].apply(safe_float)
    else:
        df["Ticket_Price_Rs"] = np.nan

    # Compute price per sqft
    area_col = None
    for ac in ["Carpet_Area_Sqft", "Area_Sqft", "Super_Builtup_Sqft", "Area_Sq.Ft"]:
        if ac in df.columns:
            area_col = ac
            break

    if area_col:
        df[area_col] = pd.to_numeric(df[area_col], errors="coerce")
        df["Price_per_Sqft"] = df["Ticket_Price_Rs"] / df[area_col]
    else:
        df["Price_per_Sqft"] = np.nan

    # Amenity score cleaning
    if "Amenity_Score" in df.columns:
        df["Amenity_Score"] = pd.to_numeric(df["Amenity_Score"], errors="coerce")
        if "Micro_Market" in df.columns:
            df["Amenity_Score"] = df.groupby("Micro_Market")["Amenity_Score"].transform(
                lambda x: x.fillna(x.median()))
        df["Amenity_Score"] = df["Amenity_Score"].fillna(df["Amenity_Score"].median())

    # Booking flag
    if "Booking_Status" in df.columns:
        df["Booking_Flag"] = df["Booking_Status"].apply(
            lambda x: 1 if str(x).lower() in ["booked","confirmed","yes","true","1"] else 0)
    else:
        df["Booking_Flag"] = np.nan

    # Parse Purchase Quarter
    def month_to_quarter(month_int): return (int(month_int)-1)//3 + 1
    def parse_purchase_quarter(val):
        if pd.isna(val): return (np.nan, np.nan)
        s = str(val).strip()
        m = re.search(r"q([1-4])[^\d]*(\d{4})", s, flags=re.I)
        if m:
            return (int(m.group(2)), int(m.group(1)))
        dt = pd.to_datetime(s, errors="coerce")
        if not pd.isna(dt):
            return (dt.year, month_to_quarter(dt.month))
        return (np.nan, np.nan)

    if "Purchase_Quarter" in df.columns:
        parsed = df["Purchase_Quarter"].apply(parse_purchase_quarter)
        df["Purchase_Year"] = parsed.apply(lambda x: x[0] if isinstance(x, tuple) else np.nan)
        df["Quarter_Number"] = parsed.apply(lambda x: x[1] if isinstance(x, tuple) else np.nan)

    # Sentiment score
    def simple_sentiment(text):
        if pd.isna(text) or str(text).strip() == "": return 0.0
        t = str(text).lower()
        pos = sum(1 for w in ["good","great","love","excellent","friendly","positive","affordable","yes","interested"] if w in t)
        neg = sum(1 for w in ["no","not","bad","poor","delay","expensive","complain","negative","dislike","cancel"] if w in t)
        return float(pos - neg)

    if "Buyer_Comments" in df.columns:
        df["Buyer_Comment_Sentiment"] = df["Buyer_Comments"].apply(simple_sentiment)
    else:
        df["Buyer_Comment_Sentiment"] = 0.0

    # Add timestamp
    df["Data_Cleaned_Timestamp"] = datetime.utcnow()

    print("✅ Cleaned shape:", df.shape)

    # Save cleaned CSV backup
    clean_path = os.path.join(os.path.dirname(csv_path), "realestate_cleaned_final.csv")
    df.to_csv(clean_path, index=False)
    print(f"💾 Cleaned CSV saved → {clean_path}")

    # Optional: Load to MySQL DB
    if db_url:
        print("🗄️ Connecting to DB...")
        engine = create_engine(db_url)
        df.to_sql(table_name, con=engine, if_exists="replace", index=False, chunksize=5000, method="multi")
        print(f"✅ Data loaded to table → {table_name}")
    else:
        print("ℹ️ No DB URL provided — skipping database load.")

    print("🎯 ETL process completed successfully.")
    return df


# Allow command-line execution
if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--csv", required=True, help="Path to CSV file")
    parser.add_argument("--db_url", required=False, help="SQLAlchemy connection string")
    parser.add_argument("--table", default="realestate_clean", help="DB table name")
    args = parser.parse_args()

    clean_and_load(args.csv, db_url=args.db_url, table_name=args.table)
