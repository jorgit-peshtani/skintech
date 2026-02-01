
import dj_database_url
import os

NEON_URL = "postgresql://neondb_owner:npg_CcFUwx9po1iI@ep-blue-morning-agax7d85-pooler.c-2.eu-central-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require"

print("--- DEBUGGING DATABASE CONFIG ---")

# 1. Test parsing the hardcoded URL
try:
    config = dj_database_url.parse(NEON_URL)
    print("Parsing result:")
    print(f"ENGINE: {config.get('ENGINE')}")
    print(f"NAME: {config.get('NAME')}")
    print(f"HOST: {config.get('HOST')}")
    print("Status: SUCCESS (String is valid)")
except Exception as e:
    print(f"Status: FAILED parsing string. Error: {e}")

# 2. Test environment variable visibility (if run from batch)
env_url = os.environ.get('DATABASE_URL', 'Not Set')
print(f"\nEnvironment DATABASE_URL: {env_url}")
if env_url == 'Not Set' or 'sqlite' in env_url:
    print("WARNING: Python is not seeing the Neon URL in environment variables.")
else:
    print("Environment variable seems correct.")
