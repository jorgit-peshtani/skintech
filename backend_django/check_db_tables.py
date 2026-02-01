
import os
import dj_database_url
import psycopg2
from urllib.parse import urlparse

# The exact URL we used
NEON_URL = "postgresql://neondb_owner:npg_CcFUwx9po1iI@ep-blue-morning-agax7d85-pooler.c-2.eu-central-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require"

def check_tables():
    print(f"Connecting to: {NEON_URL.split('@')[1]}") # Print host only for safety
    
    try:
        # Parse config
        config = dj_database_url.parse(NEON_URL)
        
        conn = psycopg2.connect(
            dbname=config['NAME'],
            user=config['USER'],
            password=config['PASSWORD'],
            host=config['HOST'],
            port=config['PORT'],
            sslmode=config.get('OPTIONS', {}).get('sslmode', 'require')
        )
        
        cursor = conn.cursor()
        
        # Query for public tables
        cursor.execute("""
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public'
            ORDER BY table_name;
        """)
        
        tables = cursor.fetchall()
        
        print("\n=== TABLES FOUND IN 'public' SCHEMA ===")
        print(f"Total count: {len(tables)}")
        for table in tables:
            print(f"- {table[0]}")
            
        # Check product count just in case
        try:
            cursor.execute("SELECT count(*) FROM catalogue_product;")
            count = cursor.fetchone()[0]
            print(f"\n[VERIFICATION] Products in catalogue_product: {count}")
        except Exception as e:
            print(f"\n[ERROR] Could not count products: {e}")

        cursor.close()
        conn.close()
        
    except Exception as e:
        print(f"\n[CRITICAL ERROR] Connection failed: {e}")

if __name__ == "__main__":
    check_tables()
