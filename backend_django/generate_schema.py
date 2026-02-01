
import os
import django
from django.core.management import call_command
from io import StringIO

# Force Postgres configuration logic in settings.py implies we need a DATABASE_URL
os.environ['DATABASE_URL'] = "postgres://dummy:dummy@localhost:5432/dummy"
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "skintech_django.settings")

django.setup()

from django.db import connections, DEFAULT_DB_ALIAS
from django.db.migrations.executor import MigrationExecutor

def generate():
    print("Loading migration graph...")
    connection = connections[DEFAULT_DB_ALIAS]
    executor = MigrationExecutor(connection)
    
    # Get all leaf nodes (latest migrations for all apps)
    targets = executor.loader.graph.leaf_nodes()
    
    # CRITICAL: Force the executor to believe NO migrations are applied
    # This ensures we generate the SQL for everything from scratch
    executor.loader.applied_migrations = set()
    
    print(f"Generating SQL using backend: {connection.vendor}")
    if connection.vendor == 'sqlite':
        print("WARNING: Using SQLite backend. The SQL might not work on Postgres!")
        print("Please check if DATABASE_URL is properly configured in settings.py")
    
    # Get the plan to migrate from empty DB to these targets
    plan = executor.migration_plan(targets)

    output_file = "full_schema.sql"
    print(f"Generating SQL for {len(plan)} migrations to {output_file}...")

    with open(output_file, "w", encoding="utf-8") as f:
        f.write("-- DJANGO FULL SCHEMA EXPORT FOR NEON (PostgreSQL)\n")
        f.write("-- Generated automatically. Run this to create all tables.\n\n")
        f.write("BEGIN;\n\n")

        count = 0
        for migration, backwards in plan:
            app_label = migration.app_label
            name = migration.name
            
            # Capture the SQL output for this specific migration
            out = StringIO()
            try:
                call_command('sqlmigrate', app_label, name, stdout=out)
                sql = out.getvalue()
                
                # Only write if there is actual SQL (some Python-only migrations might be empty)
                if sql.strip():
                     f.write(f"-- Migration: {app_label} {name}\n")
                     f.write(sql)
                     f.write("\n\n")
                     count += 1
                     print(f"[{count}/{len(plan)}] Processed {app_label}.{name}")
                else:
                    print(f"[{count}/{len(plan)}] Skipped empty/python {app_label}.{name}")

            except Exception as e:
                print(f"[ERROR] Could not generate SQL for {app_label}.{name}: {e}")
                f.write(f"-- ERROR generating for {app_label} {name}: {e}\n")

        f.write("COMMIT;\n")

    print("\n-----------------------------------------------------------")
    print(f"DONE! Schema saved to: {output_file}")
    print("-----------------------------------------------------------")

if __name__ == "__main__":
    generate()
