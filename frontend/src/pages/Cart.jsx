import { Link, useNavigate } from 'react-router-dom';
import { Trash2, Plus, Minus, ShoppingBag, ArrowRight } from 'lucide-react';
import { useCartStore } from '../store/cartStore';
import { useAuthStore } from '../store/authStore';
import toast from 'react-hot-toast';
import './Cart.css';

const Cart = () => {
    const navigate = useNavigate();
    const { user } = useAuthStore();
    const { items, removeFromCart, updateQuantity, getCartTotal, getItemCount } = useCartStore();

    const cartTotal = getCartTotal();
    const itemCount = getItemCount();

    const handleQuantityChange = (productId, newQuantity) => {
        if (newQuantity < 1) return;
        updateQuantity(productId, newQuantity);
    };

    const handleRemoveItem = (productId, productName) => {
        removeFromCart(productId);
        toast.success(`${productName} removed from cart`);
    };

    const handleCheckout = () => {
        if (!user) {
            toast.error('Please login to checkout');
            navigate('/login');
            return;
        }

        if (items.length === 0) {
            toast.error('Your cart is empty');
            return;
        }

        navigate('/checkout');
    };

    if (items.length === 0) {
        return (
            <div className="cart-page">
                <div className="container">
                    <div className="empty-cart">
                        <ShoppingBag size={64} className="empty-icon" />
                        <h2>Your Cart is Empty</h2>
                        <p>Add some products to get started!</p>
                        <Link to="/products" className="btn btn-primary">
                            Browse Products
                        </Link>
                    </div>
                </div>
            </div>
        );
    }

    return (
        <div className="cart-page">
            <div className="container">
                <div className="cart-header">
                    <h1>Shopping Cart</h1>
                    <span className="item-count">{itemCount} {itemCount === 1 ? 'item' : 'items'}</span>
                </div>

                <div className="cart-content">
                    {/* Cart Items */}
                    <div className="cart-items">
                        {items.map((item) => (
                            <div key={item.id} className="cart-item">
                                <div className="item-image">
                                    <img
                                        src={item.image_url || '/images/placeholder-product.jpg'}
                                        alt={item.name}
                                    />
                                </div>

                                <div className="item-details">
                                    <h3>{item.name}</h3>
                                    <p className="item-brand">{item.brand}</p>
                                    {item.suitable_for_skin_types && (
                                        <div className="item-tags">
                                            {item.suitable_for_skin_types.slice(0, 3).map((type) => (
                                                <span key={type} className="tag">{type}</span>
                                            ))}
                                        </div>
                                    )}
                                </div>

                                <div className="item-quantity">
                                    <button
                                        className="qty-btn"
                                        onClick={() => handleQuantityChange(item.id, item.quantity - 1)}
                                        disabled={item.quantity <= 1}
                                    >
                                        <Minus size={16} />
                                    </button>
                                    <span className="qty-value">{item.quantity}</span>
                                    <button
                                        className="qty-btn"
                                        onClick={() => handleQuantityChange(item.id, item.quantity + 1)}
                                    >
                                        <Plus size={16} />
                                    </button>
                                </div>

                                <div className="item-price">
                                    <span className="price">€{(item.price * item.quantity).toFixed(2)}</span>
                                    <span className="price-per-unit">€{item.price} each</span>
                                </div>

                                <button
                                    className="remove-btn"
                                    onClick={() => handleRemoveItem(item.id, item.name)}
                                    title="Remove from cart"
                                >
                                    <Trash2 size={20} />
                                </button>
                            </div>
                        ))}
                    </div>

                    {/* Cart Summary */}
                    <div className="cart-summary">
                        <h2>Order Summary</h2>

                        <div className="summary-row">
                            <span>Subtotal</span>
                            <span>€{cartTotal.toFixed(2)}</span>
                        </div>

                        <div className="summary-row">
                            <span>Shipping</span>
                            <span className="shipping-info">
                                {cartTotal >= 50 ? (
                                    <span className="free-shipping">FREE</span>
                                ) : (
                                    `€${(5.99).toFixed(2)}`
                                )}
                            </span>
                        </div>

                        {cartTotal < 50 && (
                            <div className="shipping-note">
                                Add €{(50 - cartTotal).toFixed(2)} more for free shipping!
                            </div>
                        )}

                        <div className="summary-row">
                            <span>Tax (estimated)</span>
                            <span>€{(cartTotal * 0.1).toFixed(2)}</span>
                        </div>

                        <div className="summary-divider"></div>

                        <div className="summary-row total">
                            <span>Total</span>
                            <span>€{(cartTotal + (cartTotal >= 50 ? 0 : 5.99) + (cartTotal * 0.1)).toFixed(2)}</span>
                        </div>

                        <button className="btn btn-primary checkout-btn" onClick={handleCheckout}>
                            Proceed to Checkout
                            <ArrowRight size={20} />
                        </button>

                        <Link to="/products" className="continue-shopping">
                            Continue Shopping
                        </Link>

                        {/* Secure Checkout Badges */}
                        <div className="security-badges">
                            <div className="badge">🔒 Secure Checkout</div>
                            <div className="badge">✓ SSL Encrypted</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Cart;
