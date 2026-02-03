import React from 'react';
import { Link } from 'react-router-dom';
import { CheckCircle } from 'lucide-react';
import './OrderSuccess.css';

const OrderSuccess = () => {
    return (
        <div className="success-page">
            <div className="container success-container">
                <div className="success-card">
                    <CheckCircle size={80} color="#10B981" className="success-icon" />
                    <h1>Order Placed Successfully!</h1>
                    <p>Thank you for your purchase. Your order has been received and is being processed.</p>

                    <div className="success-actions">
                        <Link to="/profile" className="btn btn-secondary">View Order Status</Link>
                        <Link to="/products" className="btn btn-primary">Continue Shopping</Link>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default OrderSuccess;
