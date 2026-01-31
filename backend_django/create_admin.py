"""
Script to create admin user for Django Oscar
"""
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'skintech_django.settings')
django.setup()

from django.contrib.auth import get_user_model

User = get_user_model()

# Create admin user if doesn't exist
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser(
        username='admin',
        email='admin@skintech.com',
        password='admin123'
    )
    print("✅ Created admin user:")
    print("   Username: admin")
    print("   Password: admin123")
    print("   Email: admin@skintech.com")
else:
    print("⚠️  Admin user already exists")

# Show all users
print(f"\n👥 Total users in database: {User.objects.count()}")
for user in User.objects.all():
    print(f"   - {user.username} ({user.email}) - {'Active' if user.is_active else 'Inactive'}")
