
import os
import subprocess
import sys

# Hardcoded Neon URL to avoid env var propagation issues
NEON_URL = "postgresql://neondb_owner:npg_CcFUwx9po1iI@ep-blue-morning-agax7d85-pooler.c-2.eu-central-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require"

def main():
    print("=== ROBUST MIGRATION SCRIPT (Python) ===")
    
    # Current directory (should be backend_django)
    cwd = os.getcwd()
    print(f"Working Directory: {cwd}")
    
    dump_file = "local_data_dump.json"
    
    # 1. Cleaning old dump
    if os.path.exists(dump_file):
        try:
            os.remove(dump_file)
            print("Cleaned old dump file.")
        except OSError:
            pass

    # 2. DUMP LOCAL DATA (SQLite)
    # We deliberately remove DATABASE_URL from env to force settings.py to use default SQLite
    env_local = os.environ.copy()
    if 'DATABASE_URL' in env_local:
        del env_local['DATABASE_URL']
        
    print("\n[1/3] Dumping local SQLite data...")
    # Using sys.executable to ensure we use the same python interpreter
    dump_cmd = [
        sys.executable, "manage.py", "dumpdata",  
        "--natural-foreign", "--natural-primary", 
        "-e", "contenttypes", 
        "-e", "auth.Permission", 
        "-e", "admin.LogEntry", 
        "-e", "sessions.Session", 
        "-e", "catalogue.ProductCategoryHierarchy", 
        "--indent", "2", 
        "-o", dump_file
    ]
    
    # Run dump
    try:
        subprocess.run(dump_cmd, env=env_local, check=True)
    except subprocess.CalledProcessError as e:
        print(f"[ERROR] Dump failed with code {e.returncode}")
        print("Possible cause: Print statements in settings.py or database lock.")
        sys.exit(1)
    
    # Verify dump file
    if not os.path.exists(dump_file) or os.path.getsize(dump_file) == 0:
        print("[ERROR] Dump file was not created or is empty!")
        sys.exit(1)
        
    print(f"[SUCCESS] Dump created. Size: {os.path.getsize(dump_file)} bytes")

    # 3. MIGRATE REMOTE (Neon)
    print("\n[2/3] Applying migrations to Neon...")
    env_remote = os.environ.copy()
    env_remote['DATABASE_URL'] = NEON_URL
    
    try:
        subprocess.run([sys.executable, "manage.py", "migrate"], env=env_remote, check=True)
    except subprocess.CalledProcessError:
        print("[ERROR] Migration failed. Check connection string or previous pending migrations.")
        sys.exit(1)

    # 4. LOAD REMOTE (Neon)
    print("\n[3/3] Uploading data to Neon...")
    try:
        subprocess.run([sys.executable, "manage.py", "loaddata", dump_file], env=env_remote, check=True)
    except subprocess.CalledProcessError:
        print("[ERROR] Data load failed.")
        sys.exit(1)

    print("\n=============================================")
    print("   [SUCCESS] MIGRATION COMPLETE!")
    print("=============================================")
    print("Your products are now live in Neon.")

if __name__ == "__main__":
    main()
