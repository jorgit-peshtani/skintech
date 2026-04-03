from django.db import migrations


class Migration(migrations.Migration):
    """
    Sets a database-level DEFAULT of FALSE on the analytics_tracked column
    of the order_order table. This column exists in the DB (added by Oscar)
    but is not exposed as a model field in this Oscar version, so the ORM
    never includes it in INSERT statements. A DB-level default fixes this.
    """

    dependencies = [
        ('accounts', '0001_initial'),
    ]

    operations = [
        migrations.RunSQL(
            sql="ALTER TABLE order_order ALTER COLUMN analytics_tracked SET DEFAULT FALSE;",
            reverse_sql="ALTER TABLE order_order ALTER COLUMN analytics_tracked DROP DEFAULT;",
        ),
    ]
