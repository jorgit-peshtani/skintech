import React from 'react';
import './Sidebar.css';

function Sidebar({ currentPage, onNavigate, onLogout }) {
    const menuItems = [
        { id: 'dashboard', icon: '📊', label: 'Dashboard' },
        { id: 'users', icon: '👥', label: 'Users' },
        { id: 'products', icon: '🛍️', label: 'Products' },
        { id: 'orders', icon: '📦', label: 'Orders' },
    ];

    const user = JSON.parse(localStorage.getItem('admin_user') || '{}');

    return (
        <aside className="sidebar">
            <div className="sidebar-header">
                <div className="logo">
                    <span className="logo-icon">🧴</span>
                    <span className="logo-text">SkinTech</span>
                </div>
                <div className="admin-badge">Admin Panel</div>
            </div>

            <div className="sidebar-user">
                <div className="user-avatar">{user.username?.[0].toUpperCase()}</div>
                <div className="user-info">
                    <div className="user-name">{user.username}</div>
                    <div className="user-role">Administrator</div>
                </div>
            </div>

            <nav className="sidebar-nav">
                {menuItems.map((item) => (
                    <button
                        key={item.id}
                        className={`nav-item ${currentPage === item.id ? 'active' : ''}`}
                        onClick={() => onNavigate(item.id)}
                    >
                        <span className="nav-icon">{item.icon}</span>
                        <span className="nav-label">{item.label}</span>
                    </button>
                ))}
            </nav>

            <div className="sidebar-footer">
                <button className="logout-button" onClick={onLogout}>
                    <span className="nav-icon">🚪</span>
                    <span className="nav-label">Logout</span>
                </button>
            </div>
        </aside>
    );
}

export default Sidebar;
