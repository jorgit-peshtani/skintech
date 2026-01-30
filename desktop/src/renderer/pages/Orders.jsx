import React, { useState, useEffect } from 'react';
import { ordersAPI } from '../services/api';
import './Orders.css';

function Orders() {
    const [orders, setOrders] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [filterStatus, setFilterStatus] = useState('all');

    useEffect(() => {
        loadOrders();
    }, []);

    const loadOrders = async () => {
        try {
            setLoading(true);
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

    const handleUpdateStatus = async (orderId, newStatus) => {
        try {
            await ordersAPI.updateStatus(orderId, newStatus);
            loadOrders(); // Reload to get updated data
        } catch (err) {
            console.error('Failed to update order status:', err);
            alert('Failed to update order status');
        }
    };

    const filteredOrders = orders.filter(order => {
        if (filterStatus === 'all') return true;
        return order.status === filterStatus;
    });

    const getStatusColor = (status) => {
        const colors = {
            pending: 'warning',
            paid: 'info',
            shipped: 'primary',
            delivered: 'success',
            cancelled: 'error'
        };
        return colors[status] || 'default';
    };

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
                <h1>Order Management</h1>
                <p className="orders-subtitle">View and manage all orders</p>
            </div>

            <div className="orders-controls">
                <div className="filter-buttons">
                    <button
                        className={`filter-btn ${filterStatus === 'all' ? 'active' : ''}`}
                        onClick={() => setFilterStatus('all')}
                    >
                        All ({orders.length})
                    </button>
                    <button
                        className={`filter-btn ${filterStatus === 'pending' ? 'active' : ''}`}
                        onClick={() => setFilterStatus('pending')}
                    >
                        Pending ({orders.filter(o => o.status === 'pending').length})
                    </button>
                    <button
                        className={`filter-btn ${filterStatus === 'shipped' ? 'active' : ''}`}
                        onClick={() => setFilterStatus('shipped')}
                    >
                        Shipped ({orders.filter(o => o.status === 'shipped').length})
                    </button>
                    <button
                        className={`filter-btn ${filterStatus === 'delivered' ? 'active' : ''}`}
                        onClick={() => setFilterStatus('delivered')}
                    >
                        Delivered ({orders.filter(o => o.status === 'delivered').length})
                    </button>
                </div>
            </div>

            <div className="orders-table-container">
                <table className="orders-table">
                    <thead>
                        <tr>
                            <th>Order #</th>
                            <th>Date</th>
                            <th>Customer</th>
                            <th>Items</th>
                            <th>Total</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {filteredOrders.map(order => (
                            <tr key={order.id}>
                                <td className="order-number">{order.order_number}</td>
                                <td>{new Date(order.created_at).toLocaleDateString()}</td>
                                <td>User #{order.user_id}</td>
                                <td>{order.items?.length || 0} items</td>
                                <td className="total">${parseFloat(order.total).toFixed(2)}</td>
                                <td>
                                    <span className={`status-badge ${getStatusColor(order.status)}`}>
                                        {order.status}
                                    </span>
                                </td>
                                <td>
                                    <select
                                        className="status-select"
                                        value={order.status}
                                        onChange={(e) => handleUpdateStatus(order.id, e.target.value)}
                                    >
                                        <option value="pending">Pending</option>
                                        <option value="paid">Paid</option>
                                        <option value="shipped">Shipped</option>
                                        <option value="delivered">Delivered</option>
                                        <option value="cancelled">Cancelled</option>
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

            <div className="orders-stats">
                <div className="stat-item">
                    <span className="stat-label">Total Orders</span>
                    <span className="stat-value">{orders.length}</span>
                </div>
                <div className="stat-item">
                    <span className="stat-label">Pending</span>
                    <span className="stat-value">{orders.filter(o => o.status === 'pending').length}</span>
                </div>
                <div className="stat-item">
                    <span className="stat-label">Total Revenue</span>
                    <span className="stat-value">
                        ${orders.reduce((sum, o) => sum + parseFloat(o.total), 0).toFixed(2)}
                    </span>
                </div>
            </div>
        </div>
    );
}

export default Orders;
