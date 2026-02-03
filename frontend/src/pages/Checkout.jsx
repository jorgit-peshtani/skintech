import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useCartStore } from '../store/cartStore';
import { ordersAPI } from '../services/api';
import Navbar from '../components/Navbar';
import toast from 'react-hot-toast';
import './Checkout.css';

const Checkout = () => {
    const navigate = useNavigate();
    const { items, getCartTotal, clearCart } = useCartStore();
    const cartTotal = getCartTotal();
    const [loading, setLoading] = useState(false);

    const [paymentMethod, setPaymentMethod] = useState('card');

    // Form State
    const [formData, setFormData] = useState({
        full_name: '',
        email: '',
        phone: '',
        address: '',
        city: '',
        zip_code: '',
        country: 'Albania'
    });

    const handleChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setLoading(true);

        // DEMO MODE: Simulate API call
        setTimeout(() => {
            // Save demo order
            const newOrder = {
                id: `ORD-${Math.random().toString(36).substr(2, 9).toUpperCase()}`,
                date: new Date().toISOString(),
                total: (cartTotal + 5.99).toFixed(2),
                status: 'Processing',
                items: [...items]
            };

            const existingOrders = JSON.parse(localStorage.getItem('demo_orders') || '[]');
            localStorage.setItem('demo_orders', JSON.stringify([newOrder, ...existingOrders]));

            toast.success('Order placed successfully! 🎉');
            clearCart();
            navigate('/order-success');
            setLoading(false);
        }, 1500);
    };

    return (
        <div className="checkout-page">
            <div className="container checkout-container">
                <h1>Checkout</h1>
                {/* Debug Info - Remove before production */}
                {/* <p style={{ fontSize: '10px', color: '#888' }}>Items in cart: {items?.length || 0}</p> */}

                {items && items.length > 0 ? (
                    <div className="checkout-grid">
                        {/* Shipping Form */}
                        <div className="checkout-form-section">
                            <h2>Shipping Details</h2>
                            <form onSubmit={handleSubmit} className="checkout-form">
                                <div className="form-group">
                                    <label>Full Name</label>
                                    <input type="text" name="full_name" required value={formData.full_name} onChange={handleChange} placeholder="John Doe" />
                                </div>

                                <div className="form-group-row">
                                    <div className="form-group">
                                        <label>Email</label>
                                        <input type="email" name="email" required value={formData.email} onChange={handleChange} placeholder="john@example.com" />
                                    </div>
                                    <div className="form-group">
                                        <label>Phone</label>
                                        <input type="tel" name="phone" required value={formData.phone} onChange={handleChange} placeholder="+355 69..." />
                                    </div>
                                </div>

                                <div className="form-group">
                                    <label>Address</label>
                                    <input type="text" name="address" required value={formData.address} onChange={handleChange} placeholder="Street name, Apartment..." />
                                </div>

                                <div className="form-group-row">
                                    <div className="form-group">
                                        <label>City</label>
                                        <input type="text" name="city" required value={formData.city} onChange={handleChange} placeholder="Tirana" />
                                    </div>
                                    <div className="form-group">
                                        <label>Zip Code</label>
                                        <input type="text" name="zip_code" required value={formData.zip_code} onChange={handleChange} placeholder="1001" />
                                    </div>
                                </div>

                                {/* Payment Method Section */}
                                <div className="payment-section">
                                    <h3>Payment Method</h3>
                                    <div className="payment-options">
                                        <div
                                            className={`payment-option ${paymentMethod === 'card' ? 'selected' : ''}`}
                                            onClick={() => setPaymentMethod('card')}
                                        >
                                            <div className="payment-icon">💳</div>
                                            <span>Credit Card</span>
                                        </div>
                                        <div
                                            className={`payment-option ${paymentMethod === 'paypal' ? 'selected' : ''}`}
                                            onClick={() => setPaymentMethod('paypal')}
                                        >
                                            <div className="payment-icon">🅿️</div>
                                            <span>PayPal</span>
                                        </div>
                                        <div
                                            className={`payment-option ${paymentMethod === 'cod' ? 'selected' : ''}`}
                                            onClick={() => setPaymentMethod('cod')}
                                        >
                                            <div className="payment-icon">💵</div>
                                            <span>Cash on Delivery</span>
                                        </div>
                                    </div>
                                </div>

                                <button type="submit" className="btn btn-primary place-order-btn" disabled={loading}>
                                    {loading ? 'Processing...' : `Pay €${(cartTotal + 5.99).toFixed(2)} & Place Order`}
                                </button>
                                <p className="secure-note">🔒 Payments are secure and encrypted</p>
                            </form>
                        </div>

                        {/* Order Summary */}
                        <div className="checkout-summary-section">
                            <h2>Order Summary</h2>
                            <div className="summary-items">
                                {items.map(item => (
                                    <div key={item.id} className="summary-item">
                                        <div className="item-info">
                                            <span className="item-qty">{item.quantity}x</span>
                                            <span>{item.title}</span>
                                        </div>
                                        <div className="item-price">
                                            €{(item.price * item.quantity).toFixed(2)}
                                        </div>
                                    </div>
                                ))}
                            </div>
                            <div className="summary-totals">
                                <div className="row">
                                    <span>Subtotal</span>
                                    <span>€{cartTotal.toFixed(2)}</span>
                                </div>
                                <div className="row">
                                    <span>Shipping</span>
                                    <span>€5.99</span>
                                </div>
                                <div className="row total">
                                    <span>Total</span>
                                    <span>€{(cartTotal + 5.99).toFixed(2)}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                ) : (
                    <div className="empty-cart-msg">
                        <h2>Your cart is empty</h2>
                        <button onClick={() => navigate('/products')} className="btn btn-primary">Go Shopping</button>
                    </div>
                )}
            </div>
        </div>
    );
};

export default Checkout;
