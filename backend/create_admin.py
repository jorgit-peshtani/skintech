from app import create_app
from models import User, UserProfile, Product, Ingredient
from extensions import db
from datetime import datetime

app = create_app()

def create_admin_user():
    """Create an admin user for the desktop app"""
    with app.app_context():
        # Check if admin already exists
        admin = User.query.filter_by(email='admin@skintech.com').first()
        
        if admin:
            print("✅ Admin user already exists")
            print(f"   Email: {admin.email}")
            print(f"   Username: {admin.username}")
            print(f"   Is Admin: {admin.is_admin}")
            return admin
        
        # Create admin user
        admin = User(
            email='admin@skintech.com',
            username='admin',
            first_name='Admin',
            last_name='User',
            is_admin=True,
            is_active=True
        )
        admin.set_password('admin123')
        
        # Create admin profile
        admin_profile = UserProfile(user=admin)
        
        db.session.add(admin)
        db.session.add(admin_profile)
        db.session.commit()
        
        print("✅ Admin user created successfully!")
        print(f"   Email: admin@skintech.com")
        print(f"   Password: admin123")
        print(f"   Username: {admin.username}")
        
        return admin

def create_demo_user():
    """Create a demo user for testing"""
    with app.app_context():
        # Check if demo user exists
        demo = User.query.filter_by(email='demo@skintech.com').first()
        
        if demo:
            print("✅ Demo user already exists")
            return demo
        
        # Create demo user
        demo = User(
            email='demo@skintech.com',
            username='demo',
            first_name='Demo',
            last_name='User',
            is_admin=False,
            is_active=True
        )
        demo.set_password('demo123')
        
        demo_profile = UserProfile(user=demo)
        
        db.session.add(demo)
        db.session.add(demo_profile)
        db.session.commit()
        
        print("✅ Demo user created successfully!")
        print(f"   Email: demo@skintech.com")
        print(f"   Password: demo123")
        
        return demo

if __name__ == '__main__':
    print("\n" + "="*60)
    print("Creating Admin and Demo Users")
    print("="*60 + "\n")
    
    create_admin_user()
    print()
    create_demo_user()
    
    print("\n" + "="*60)
    print("Setup Complete!")
    print("="*60)
    print("\nYou can now login to the desktop app with:")
    print("  Admin: admin@skintech.com / admin123")
    print("  Demo:  demo@skintech.com  / demo123")
    print()
