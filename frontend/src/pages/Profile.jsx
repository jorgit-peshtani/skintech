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
                        <div className="loading-spinner">
                            <p>Loading your orders...</p>
                        </div>
                    ) : orders.length > 0 ? (
                        <div className="orders-list">
                            {orders.map((order) => (
                                <div key={order.id} className="order-card">
                                    <div className="order-card-header">
                                        <div className="order-main-info">
                                            <div className="order-number">Order #{order.number}</div>
                                            <div className="order-date">
                                                Placed on {new Date(order.date).toLocaleDateString()}
                                            </div>
                                        </div>
                                        
                                        <div className="order-meta">
                                            <div className="order-total">
                                                €{parseFloat(order.total).toFixed(2)}
                                            </div>
                                            <span className={`status-badge status-${order.status?.toLowerCase().replace(/ /g, '-') || 'pending'}`}>
                                                {order.status || 'Pending'}
                                            </span>
                                        </div>
                                    </div>

                                    {order.items && order.items.length > 0 && (
                                        <div className="order-items-list">
                                            {order.items.map((item, idx) => (
                                                <div key={idx} className="order-item">
                                                    <div className="order-item-image">
                                                        {item.image ? (
                                                            <img src={item.image} alt={item.title} />
                                                        ) : (
                                                            <div className="placeholder-image">
                                                                <ShoppingBag size={20} />
                                                            </div>
                                                        )}
                                                    </div>
                                                    <div className="order-item-details">
                                                        <div className="order-item-name">{item.title}</div>
                                                        <div className="order-item-meta">
                                                            Qty: {item.quantity} × €{parseFloat(item.price).toFixed(2)}
                                                        </div>
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
                            <ShoppingBag size={48} />
                            <p>You haven't placed any orders yet.</p>
                            <Link to="/products" className="btn btn-primary">
                                Explore Products
                            </Link>
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
};

export default Profile;
