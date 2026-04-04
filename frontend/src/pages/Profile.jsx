import { useState, useEffect } from 'react';
import { useAuthStore } from '../store/authStore';
import { ordersAPI } from '../services/api';
import { Package, ShoppingBag } from 'lucide-react';
import { Link } from 'react-router-dom';
import './Profile.css';

const Profile = () => {
    const { user } = useAuthStore();
    const [orders, setOrders] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        if (user) {
            ordersAPI.getMyOrders()
                .then(res => setOrders(res.data))
                .catch(err => console.error('Error fetching orders:', err))
                .finally(() => setLoading(false));
        }
    }, [user]);

    if (!user) {
        return (
            <div className="container" style={{ padding: '4rem 0', textAlign: 'center' }}>
                <h2>Please login to view your profile</h2>
                <Link to="/login" className="btn btn-primary" style={{ marginTop: '1rem' }}>
                    Login
                </Link>
            </div>
        );
    }

    return (
        <div className="profile-page">
            <div className="container">
                {/* User Info Card */}
                <div className="profile-header">
                    <div className="profile-avatar">
                        <span>{user.first_name?.[0] || user.username?.[0] || 'U'}</span>
                    </div>
                    <div className="profile-info">
                        <h2>{user.first_name || user.username} {user.last_name}</h2>
                        <p>{user.email}</p>
                    </div>
                </div>

                {/* Orders Section */}
                <div className="orders-section">
                    <h3>
                        <Package size={24} />
                        Order History
                    </h3>

                    {loading ? (
                        <p>Loading orders...</p>
                    ) : orders.length > 0 ? (
                        <div className="orders-list" style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
                            {orders.map((order) => (
                                <div key={order.id} style={{
                                    border: '1px solid #e5e7eb',
                                    borderRadius: '0.75rem',
                                    padding: '1.25rem',
                                    background: 'white',
                                    boxShadow: '0 1px 6px rgba(0,0,0,0.04)'
                                }}>
                                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '0.75rem' }}>
                                        <div>
                                            <strong style={{ fontSize: '1rem' }}>Order {order.number}</strong>
                                            <div style={{ fontSize: '0.85rem', color: '#6B7280', marginTop: '0.15rem' }}>
                                                {new Date(order.date).toLocaleDateString()}
                                            </div>
                                        </div>
                                        <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
                                            <strong style={{ fontSize: '1.1rem' }}>€{parseFloat(order.total).toFixed(2)}</strong>
                                            <span style={{
                                                background: '#DEF7EC',
                                                color: '#03543F',
                                                padding: '0.25rem 0.75rem',
                                                borderRadius: '2rem',
                                                fontSize: '0.8rem',
                                                fontWeight: '600'
                                            }}>
                                                {order.status}
                                            </span>
                                        </div>
                                    </div>

                                    {order.items && order.items.length > 0 && (
                                        <div style={{ borderTop: '1px solid #f3f4f6', paddingTop: '0.75rem' }}>
                                            {order.items.map((item, idx) => (
                                                <div key={idx} style={{ display: 'flex', alignItems: 'center', gap: '0.75rem', marginBottom: '0.5rem' }}>
                                                    <div style={{
                                                        width: '40px', height: '40px', borderRadius: '0.4rem',
                                                        background: '#f3f4f6', overflow: 'hidden', flexShrink: 0
                                                    }}>
                                                        {item.image && <img src={item.image} alt={item.title} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />}
                                                    </div>
                                                    <div style={{ flex: 1 }}>
                                                        <div style={{ fontWeight: '500', fontSize: '0.9rem' }}>{item.title}</div>
                                                        <div style={{ fontSize: '0.8rem', color: '#6B7280' }}>Qty: {item.quantity} × €{parseFloat(item.price).toFixed(2)}</div>
                                                    </div>
                                                </div>
                                            ))}
                                        </div>
                                    )}
                                </div>
                            ))}
                        </div>
                    ) : (
                        <div className="empty-orders">
                            <ShoppingBag size={48} color="#9CA3AF" style={{ margin: '0 auto 1rem', display: 'block' }} />
                            <p>You haven't placed any orders yet.</p>
                            <Link to="/products" className="btn btn-primary" style={{ marginTop: '1rem' }}>
                                Start Shopping
                            </Link>
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
};

export default Profile;
