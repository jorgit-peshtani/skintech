from datetime import datetime
from extensions import db, bcrypt
from sqlalchemy import Enum
import enum

class SkinType(enum.Enum):
    NORMAL = "normal"
    DRY = "dry"
    OILY = "oily"
    COMBINATION = "combination"
    SENSITIVE = "sensitive"

class SkinConcern(enum.Enum):
    ACNE = "acne"
    AGING = "aging"
    DARK_SPOTS = "dark_spots"
    REDNESS = "redness"
    DRYNESS = "dryness"
    OILINESS = "oiliness"
    SENSITIVITY = "sensitivity"
    WRINKLES = "wrinkles"

class User(db.Model):
    __tablename__ = 'users'
    
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(120), unique=True, nullable=False, index=True)
    username = db.Column(db.String(80), unique=True, nullable=False, index=True)
    password_hash = db.Column(db.String(255), nullable=False)
    first_name = db.Column(db.String(80))
    last_name = db.Column(db.String(80))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    is_active = db.Column(db.Boolean, default=True)
    is_admin = db.Column(db.Boolean, default=False)
    
    # Relationships
    profile = db.relationship('UserProfile', backref='user', uselist=False, cascade='all, delete-orphan')
    orders = db.relationship('Order', backref='user', lazy='dynamic', cascade='all, delete-orphan')
    reviews = db.relationship('Review', backref='user', lazy='dynamic', cascade='all, delete-orphan')
    scans = db.relationship('ProductScan', backref='user', lazy='dynamic', cascade='all, delete-orphan')
    
    def set_password(self, password):
        self.password_hash = bcrypt.generate_password_hash(password).decode('utf-8')
    
    def check_password(self, password):
        return bcrypt.check_password_hash(self.password_hash, password)
    
    def to_dict(self):
        return {
            'id': self.id,
            'email': self.email,
            'username': self.username,
            'first_name': self.first_name,
            'last_name': self.last_name,
            'created_at': self.created_at.isoformat(),
            'is_active': self.is_active,
            'is_admin': self.is_admin
        }

class UserProfile(db.Model):
    __tablename__ = 'user_profiles'
    
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    skin_type = db.Column(Enum(SkinType))
    date_of_birth = db.Column(db.Date)
    phone = db.Column(db.String(20))
    
    # Address
    address_line1 = db.Column(db.String(200))
    address_line2 = db.Column(db.String(200))
    city = db.Column(db.String(100))
    state = db.Column(db.String(100))
    postal_code = db.Column(db.String(20))
    country = db.Column(db.String(100))
    
    # Preferences
    preferences = db.Column(db.JSON)  # Store as JSON: {"concerns": [], "ingredients_to_avoid": []}
    
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'skin_type': self.skin_type.value if self.skin_type else None,
            'date_of_birth': self.date_of_birth.isoformat() if self.date_of_birth else None,
            'phone': self.phone,
            'address': {
                'line1': self.address_line1,
                'line2': self.address_line2,
                'city': self.city,
                'state': self.state,
                'postal_code': self.postal_code,
                'country': self.country
            },
            'preferences': self.preferences or {}
        }

class Product(db.Model):
    __tablename__ = 'products'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(200), nullable=False)
    brand = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text)
    category = db.Column(db.String(100))  # moisturizer, cleanser, serum, etc.
    price = db.Column(db.Numeric(10, 2), nullable=False)
    stock_quantity = db.Column(db.Integer, default=0)
    image_url = db.Column(db.String(500))
    ingredients = db.Column(db.Text)  # Comma-separated ingredient list
    is_certified = db.Column(db.Boolean, default=False)
    is_active = db.Column(db.Boolean, default=True)
    
    # Metadata
    suitable_for_skin_types = db.Column(db.JSON)  # List of skin types
    target_concerns = db.Column(db.JSON)  # List of skin concerns
    
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    reviews = db.relationship('Review', backref='product', lazy='dynamic', cascade='all, delete-orphan')
    order_items = db.relationship('OrderItem', backref='product', lazy='dynamic')
    
    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'brand': self.brand,
            'description': self.description,
            'category': self.category,
            'price': float(self.price),
            'stock_quantity': self.stock_quantity,
            'image_url': self.image_url,
            'ingredients': self.ingredients,
            'is_certified': self.is_certified,
            'suitable_for_skin_types': self.suitable_for_skin_types or [],
            'target_concerns': self.target_concerns or [],
            'average_rating': self.get_average_rating(),
            'review_count': self.reviews.count()
        }
    
    def get_average_rating(self):
        reviews = self.reviews.all()
        if not reviews:
            return 0
        return sum(r.rating for r in reviews) / len(reviews)

class Ingredient(db.Model):
    """Ingredient model for cosmetic ingredients database"""
    __tablename__ = 'ingredient'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(200), nullable=False, unique=True)
    scientific_name = db.Column(db.String(300))
    description = db.Column(db.Text)
    safety_rating = db.Column(db.Integer, default=5)  # 1-10 scale
    effects = db.Column(db.JSON)  # Dictionary of effects on different skin types
    warnings = db.Column(db.JSON)  # List of warnings
    
    # New fields for scientific classification (Phase 1 requirement)
    scientific_studies = db.Column(db.JSON)  # References to scientific studies
    dermatologist_notes = db.Column(db.Text)  # Expert dermatological notes
    certification_status = db.Column(db.String(50))  # EU/FDA/ISO certification
    allergen_level = db.Column(db.Integer, default=0)  # 0-10 scale (0=none, 10=high)
    comedogenic_rating = db.Column(db.Integer, default=0)  # 0-5 scale (0=non-comedogenic)
    recommended_concentration = db.Column(db.String(50))  # e.g., "0.5-2%"
    contraindications = db.Column(db.JSON)  # List of conditions to avoid
    
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    is_active = db.Column(db.Boolean, default=True)
    is_admin = db.Column(db.Boolean, default=False)
    
    def to_dict(self, detailed=False):
        """Serialize ingredient to dictionary"""
        basic_data = {
            'id': self.id,
            'name': self.name,
            'scientific_name': self.scientific_name,
            'description': self.description,
            'safety_rating': self.safety_rating,
            'effects': self.effects,
            'warnings': self.warnings
        }
        
        if detailed:
            # Include scientific data for detailed views
            basic_data.update({
                'scientific_studies': self.scientific_studies,
                'dermatologist_notes': self.dermatologist_notes,
                'certification_status': self.certification_status,
                'allergen_level': self.allergen_level,
                'comedogenic_rating': self.comedogenic_rating,
                'recommended_concentration': self.recommended_concentration,
                'contraindications': self.contraindications
            })
        
        return basic_data

class ProductScan(db.Model):
    __tablename__ = 'product_scans'
    
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    image_path = db.Column(db.String(500))
    extracted_text = db.Column(db.Text)
    identified_ingredients = db.Column(db.JSON)  # List of ingredient IDs
    analysis_result = db.Column(db.JSON)  # Detailed analysis
    overall_rating = db.Column(db.Integer)  # 1-10
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'image_path': self.image_path,
            'extracted_text': self.extracted_text,
            'identified_ingredients': self.identified_ingredients or [],
            'analysis_result': self.analysis_result or {},
            'overall_rating': self.overall_rating,
            'created_at': self.created_at.isoformat()
        }

class Order(db.Model):
    __tablename__ = 'orders'
    
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    order_number = db.Column(db.String(50), unique=True, nullable=False, index=True)
    status = db.Column(db.String(50), default='pending')  # pending, paid, shipped, delivered, cancelled
    
    # Pricing
    subtotal = db.Column(db.Numeric(10, 2), nullable=False)
    tax = db.Column(db.Numeric(10, 2), default=0)
    shipping_cost = db.Column(db.Numeric(10, 2), default=0)
    total = db.Column(db.Numeric(10, 2), nullable=False)
    
    # Shipping address
    shipping_address = db.Column(db.JSON)
    
    # Payment
    payment_method = db.Column(db.String(50))  # stripe, paypal
    payment_id = db.Column(db.String(200))
    payment_status = db.Column(db.String(50), default='pending')
    
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    items = db.relationship('OrderItem', backref='order', lazy='dynamic', cascade='all, delete-orphan')
    
    def to_dict(self):
        return {
            'id': self.id,
            'order_number': self.order_number,
            'status': self.status,
            'subtotal': float(self.subtotal),
            'tax': float(self.tax),
            'shipping_cost': float(self.shipping_cost),
            'total': float(self.total),
            'shipping_address': self.shipping_address,
            'payment_method': self.payment_method,
            'payment_status': self.payment_status,
            'items': [item.to_dict() for item in self.items],
            'created_at': self.created_at.isoformat(),
            'updated_at': self.updated_at.isoformat()
        }

class OrderItem(db.Model):
    __tablename__ = 'order_items'
    
    id = db.Column(db.Integer, primary_key=True)
    order_id = db.Column(db.Integer, db.ForeignKey('orders.id'), nullable=False)
    product_id = db.Column(db.Integer, db.ForeignKey('products.id'), nullable=False)
    quantity = db.Column(db.Integer, nullable=False)
    price = db.Column(db.Numeric(10, 2), nullable=False)  # Price at time of order
    
    def to_dict(self):
        return {
            'id': self.id,
            'product': self.product.to_dict() if self.product else None,
            'quantity': self.quantity,
            'price': float(self.price),
            'subtotal': float(self.price * self.quantity)
        }

class Review(db.Model):
    __tablename__ = 'reviews'
    
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    product_id = db.Column(db.Integer, db.ForeignKey('products.id'), nullable=False)
    rating = db.Column(db.Integer, nullable=False)  # 1-5
    title = db.Column(db.String(200))
    comment = db.Column(db.Text)
    is_verified_purchase = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    def to_dict(self):
        return {
            'id': self.id,
            'user': {
                'id': self.user.id,
                'username': self.user.username
            },
            'rating': self.rating,
            'title': self.title,
            'comment': self.comment,
            'is_verified_purchase': self.is_verified_purchase,
            'created_at': self.created_at.isoformat()
        }
