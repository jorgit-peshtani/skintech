import { useState, useEffect } from 'react';
import { useAuthStore } from '../store/authStore';
import { ordersAPI } from '../services/api';
import { Package, User, Calendar, Clock, ArrowRight } from 'lucide-react';
import toast from 'react-hot-toast';
import { Link } from 'react-router-dom';
import './Profile.css';

const Profile = () => {
    const { user } = useAuthStore();
    const [orders, setOrders] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchOrders = async () => {
            try {
                // DEMO MODE: Load from localStorage
                const demoOrders = JSON.parse(localStorage.getItem('demo_orders') || '[]');
                setOrders(demoOrders);
            } catch (error) {
                console.error('Error fetching orders:', error);
            } finally {
                setLoading(false);
            }
        };

        if (user) {
            fetchOrders();
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
                        <h2>{user.first_name} {user.last_name}</h2>
                        <p>{user.email}</p>
                        <p className="text-muted">Member since {new Date(user.date_joined || Date.now()).toLocaleDateString()}</p>
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
                        <div className="orders-table-container">
                            <table className="orders-table">
                                <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Date</th>
                                        <th>Total</th>
                                        <th>Status</th>
                                        <th>Items</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {orders.map((order) => (
                                        <tr key={order.id}>
                                            <td>#{order.id}</td>
                                            <td>
                                                <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                                                    <Calendar size={14} className="text-muted" />
                                                    {new Date(order.date).toLocaleDateString()}
                                                </div>
                                            </td>
                                            <td><strong>€{order.total}</strong></td>
                                            <td>
                                                <span className={`status-badge status-${(order.status || 'pending').toLowerCase()}`}>
                                                    {order.status}
                                                </span>
                                            </td>
                                            <td>{order.items?.length || 0} items</td>
                                            <td>
                                                <button className="btn btn-sm btn-outline-primary">
                                                    View Details
                                                </button>
                                            </td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    ) : (
                        <div className="empty-orders">
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
