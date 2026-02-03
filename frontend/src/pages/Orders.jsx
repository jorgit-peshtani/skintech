
import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ShoppingBag, Package, ChevronRight } from 'lucide-react';
import './Orders.css'; // You might need to create this CSS or reuse styles

const Orders = () => {
    const navigate = useNavigate();
    const [orders, setOrders] = useState([]);

    useEffect(() => {
        // Load demo orders from localStorage
        const demoOrders = JSON.parse(localStorage.getItem('demo_orders') || '[]');
        setOrders(demoOrders);
    }, []);

    if (orders.length === 0) {
        return (
            <div className="container orders-empty-container" style={{ padding: '4rem 0', textAlign: 'center' }}>
                <div style={{ background: '#f3f4f6', width: '80px', height: '80px', borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center', margin: '0 auto 1.5rem' }}>
                    <ShoppingBag size={40} color="#9CA3AF" />
                </div>
                <h2>No Orders Yet</h2>
                <p style={{ color: '#6B7280', marginBottom: '2rem' }}>Looks like you haven't placed any orders yet.</p>
                <button onClick={() => navigate('/products')} className="btn btn-primary">Start Shopping</button>
            </div>
        );
    }

    return (
        <div className="container orders-page" style={{ padding: '2rem 0' }}>
            <h1 style={{ marginBottom: '2rem' }}>My Orders</h1>

            <div className="orders-list" style={{ display: 'flex', flexDirection: 'column', gap: '1.5rem' }}>
                {orders.map(order => (
                    <div key={order.id} className="order-card" style={{
                        border: '1px solid #e5e7eb',
                        borderRadius: '1rem',
                        padding: '1.5rem',
                        background: 'white',
                        boxShadow: '0 2px 10px rgba(0,0,0,0.03)'
                    }}>
                        <div className="order-header" style={{
                            display: 'flex',
                            justifyContent: 'space-between',
                            alignItems: 'center',
                            borderBottom: '1px solid #f3f4f6',
                            paddingBottom: '1rem',
                            marginBottom: '1rem'
                        }}>
                            <div>
                                <h3 style={{ margin: 0, fontSize: '1.1rem' }}>Order #{order.id}</h3>
                                <div style={{ fontSize: '0.9rem', color: '#6B7280', marginTop: '0.25rem' }}>
                                    Placed on {new Date(order.date).toLocaleDateString()}
                                </div>
                            </div>
                            <div className="order-status-badge" style={{
                                background: '#DEF7EC',
                                color: '#03543F',
                                padding: '0.5rem 1rem',
                                borderRadius: '2rem',
                                fontWeight: '600',
                                fontSize: '0.85rem'
                            }}>
                                {order.status}
                            </div>
                        </div>

                        <div className="order-items" style={{ marginBottom: '1.5rem' }}>
                            {order.items.map((item, idx) => (
                                <div key={idx} className="order-item-row" style={{ display: 'flex', alignItems: 'center', gap: '1rem', marginBottom: '0.75rem' }}>
                                    <div style={{
                                        width: '50px',
                                        height: '50px',
                                        borderRadius: '0.5rem',
                                        background: '#f3f4f6',
                                        overflow: 'hidden'
                                    }}>
                                        <img src={item.image} alt={item.title} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                                    </div>
                                    <div style={{ flex: 1 }}>
                                        <div style={{ fontWeight: '500' }}>{item.title}</div>
                                        <div style={{ fontSize: '0.85rem', color: '#6B7280' }}>Qty: {item.quantity} × €{item.price}</div>
                                    </div>
                                </div>
                            ))}
                        </div>

                        <div className="order-footer" style={{
                            display: 'flex',
                            justifyContent: 'space-between',
                            alignItems: 'center',
                            paddingTop: '1rem',
                            borderTop: '1px solid #f3f4f6'
                        }}>
                            <div>
                                <span style={{ color: '#6B7280', marginRight: '0.5rem' }}>Total Amount:</span>
                                <span style={{ fontSize: '1.2rem', fontWeight: 'bold' }}>€{order.total}</span>
                            </div>
                            {/* <button className="btn btn-secondary" style={{ padding: '0.5rem 1rem', fontSize: '0.9rem' }}>
                                View Details
                            </button> */}
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );
};

export default Orders;
