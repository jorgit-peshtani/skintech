import React, { useState, useEffect } from 'react';
import { ordersAPI } from '../services/api';
import './Orders.css';

const STATUS_OPTIONS = ['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'];

function Orders() {
    const [orders, setOrders] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [searchTerm, setSearchTerm] = useState('');
    const [filterStatus, setFilterStatus] = useState('all');
    const [updatingId, setUpdatingId] = useState(null);

    useEffect(() => {
        loadOrders();
    }, []);

    const loadOrders = async () => {
        try {
            setLoading(orders.length === 0);
            const response = await ordersAPI.getAll();
            setOrders(response.data);
            setError('');
        } catch (err) {
            console.error('Failed to load orders:', err);
            setError('Failed to load orders');
        } finally {
            setLoading(false);
        }
    };

    const handleStatusChange = async (orderId, newStatus) => {
        setUpdatingId(orderId);
        try {
            await ordersAPI.updateStatus(orderId, newStatus);
            setOrders(prev =>
                prev.map(o => o.id === orderId ? { ...o, status: newStatus } : o)
            );
        } catch (err) {
            alert('Failed to update order status');
        } finally {
            setUpdatingId(null);
        }
    };

    const filteredOrders = orders.filter(order => {
        const matchesSearch =
            (order.order_number || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
            (order.user_email || '').toLowerCase().includes(searchTerm.toLowerCase());
        if (filterStatus === 'all') return matchesSearch;
        return matchesSearch && order.status?.toLowerCase() === filterStatus.toLowerCase();
    });

    if (loading) {
        return (
            <div className="orders-loading">
                <div className="spinner"></div>
                <p>Loading orders...</p>
            </div>
        );
    }

    if (error) {
        return (
            <div className="orders-error">
                <p>{error}</p>
                <button onClick={loadOrders}>Retry</button>
            </div>
        );
    }

    return (
        <div className="orders-page">
            <div className="orders-header">
                <div>
                    <h1>Order Management</h1>
                    <p className="orders-subtitle">Track and manage all customer orders</p>
                </div>
                <div className="header-actions">
                    <button className="refresh-btn" onClick={loadOrders}>Refresh</button>
                </div>
            </div>

            <div className="orders-controls">
                <input
                    type="text"
                    className="search-input"
                    placeholder="Search by order number or customer email..."
                    value={searchTerm}
                    onChange={e => setSearchTerm(e.target.value)}
                />
                <div className="filter-buttons">
                    {['all', ...STATUS_OPTIONS].map(s => (
                        <button
                            key={s}
                            className={`filter-btn ${filterStatus === s ? 'active' : ''}`}
                            onClick={() => setFilterStatus(s)}
                        >
                            {s === 'all' ? `All (${orders.length})` : s}
                        </button>
                    ))}
                </div>
            </div>

            <div className="orders-table-container">
                <table className="orders-table">
                    <thead>
                        <tr>
                            <th>Order #</th>
                            <th>Customer</th>
                            <th>Items</th>
                            <th>Total</th>
                            <th>Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        {filteredOrders.map(order => (
                            <tr key={order.id}>
                                <td><strong>{order.order_number}</strong></td>
                                <td>{order.user_email || 'Guest'}</td>
                                <td>
                                    {order.items && order.items.length > 0 ? (
                                        <ul className="order-items-list">
                                            {order.items.map((item, idx) => (
                                                <li key={idx}>
                                                    {item.title} × {item.quantity}
                                                </li>
                                            ))}
                                        </ul>
                                    ) : (
                                        <span className="no-items">—</span>
                                    )}
                                </td>
                                <td className="price">€{parseFloat(order.total || 0).toFixed(2)}</td>
                                <td>{order.created_at ? new Date(order.created_at).toLocaleDateString() : '—'}</td>
                                <td>
                                    <select
                                        className={`status-select status-${(order.status || 'pending').toLowerCase()}`}
                                        value={order.status || 'Pending'}
                                        onChange={e => handleStatusChange(order.id, e.target.value)}
                                        disabled={updatingId === order.id}
                                    >
                                        {STATUS_OPTIONS.map(s => (
                                            <option key={s} value={s}>{s}</option>
                                        ))}
                                    </select>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>

                {filteredOrders.length === 0 && (
                    <div className="no-results">
                        <p>No orders found</p>
                    </div>
                )}
            </div>
        </div>
    );
}

export default Orders;
