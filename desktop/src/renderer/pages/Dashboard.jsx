import React, { useState, useEffect } from 'react';
import { statsAPI } from '../services/api';
import './Dashboard.css';

function Dashboard() {
    const [stats, setStats] = useState({
        users: { total: 0, new: 0, active: 0 },
        products: { total: 0, categories: 0, outOfStock: 0 },
        orders: { total: 0, pending: 0, completed: 0, revenue: 0 },
        scans: { total: 0, today: 0, positive: 0, negative: 0 },
    });
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [lastUpdate, setLastUpdate] = useState(new Date());

    useEffect(() => {
        loadDashboard();
    }, []);

    const loadDashboard = async (silent = false) => {
        try {
            if (!silent) setLoading(true);

            const response = await statsAPI.getDashboard();
            setStats(response.data);
            setLastUpdate(new Date());
            setError('');
        } catch (err) {
            console.error('Failed to load dashboard:', err);
            if (!silent) {
                setError('Failed to load dashboard data');
            }
        } finally {
            if (!silent) setLoading(false);
        }
    };

    if (loading) {
        return (
            <div className="dashboard-loading">
                <div className="spinner"></div>
                <p>Loading dashboard...</p>
            </div>
        );
    }

    if (error) {
        return (
            <div className="dashboard-error">
                <p>{error}</p>
                <button onClick={() => loadDashboard()}>Retry</button>
            </div>
        );
    }

    return (
        <div className="dashboard">
            <div className="dashboard-header">
                <div>
                    <h1>Dashboard</h1>
                    <p className="dashboard-subtitle">
                        Overview • Last updated: {lastUpdate.toLocaleTimeString()} • Click 🔄 to refresh
                    </p>
                </div>
                <button className="refresh-btn" onClick={() => loadDashboard()} title="Refresh now">
                    🔄
                </button>
            </div>

            <div className="stats-grid">
                {/* Users Stats */}
                <div className="stat-card users">
                    <div className="stat-header">
                        <span className="stat-icon">👥</span>
                        <h3>Users</h3>
                    </div>
                    <div className="stat-main">
                        <div className="stat-value">{stats.users.total}</div>
                        <div className="stat-label">Total Users</div>
                    </div>
                    <div className="stat-details">
                        <div className="stat-item">
                            <span className="stat-badge new">{stats.users.new} New</span>
                        </div>
                        <div className="stat-item">
                            <span className="stat-badge active">{stats.users.active} Active</span>
                        </div>
                    </div>
                </div>

                {/* Products Stats */}
                <div className="stat-card products">
                    <div className="stat-header">
                        <span className="stat-icon">🛍️</span>
                        <h3>Products</h3>
                    </div>
                    <div className="stat-main">
                        <div className="stat-value">{stats.products.total}</div>
                        <div className="stat-label">Total Products</div>
                    </div>
                    <div className="stat-details">
                        <div className="stat-item">
                            <span className="stat-badge">{stats.products.categories} Categories</span>
                        </div>
                        <div className="stat-item">
                            <span className="stat-badge warning">{stats.products.outOfStock} Out of Stock</span>
                        </div>
                    </div>
                </div>

                {/* Orders Stats */}
                <div className="stat-card orders">
                    <div className="stat-header">
                        <span className="stat-icon">📦</span>
                        <h3>Orders</h3>
                    </div>
                    <div className="stat-main">
                        <div className="stat-value">{stats.orders.total}</div>
                        <div className="stat-label">Total Orders</div>
                    </div>
                    <div className="stat-details">
                        <div className="stat-item">
                            <span className="stat-badge pending">{stats.orders.pending} Pending</span>
                        </div>
                        <div className="stat-item">
                            <span className="stat-badge success">{stats.orders.completed} Completed</span>
                        </div>
                    </div>
                </div>

                {/* Scans Stats */}
                <div className="stat-card scans">
                    <div className="stat-header">
                        <span className="stat-icon">🔬</span>
                        <h3>AI Scans</h3>
                    </div>
                    <div className="stat-main">
                        <div className="stat-value">{stats.scans.total}</div>
                        <div className="stat-label">Total Scans</div>
                    </div>
                    <div className="stat-details">
                        <div className="stat-item">
                            <span className="stat-badge today">{stats.scans.today} Today</span>
                        </div>
                        <div className="stat-item">
                            <span className="stat-badge success">{stats.scans.positive} Safe</span>
                        </div>
                    </div>
                </div>
            </div>

            {/* Revenue Card */}
            <div className="revenue-card">
                <div className="revenue-header">
                    <span className="stat-icon">💰</span>
                    <h3>Revenue</h3>
                </div>
                <div className="revenue-value">${stats.orders.revenue.toLocaleString()}</div>
                <div className="revenue-label">Total Revenue</div>
                <div className="revenue-pulse"></div>
            </div>
        </div>
    );
}

export default Dashboard;
