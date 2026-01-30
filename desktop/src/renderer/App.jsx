import React, { useState, useEffect } from 'react';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import Users from './pages/Users';
import Products from './pages/Products';
import Orders from './pages/Orders';
import Sidebar from './components/Sidebar';
import './App.css';

function App() {
    const [isAuthenticated, setIsAuthenticated] = useState(false);
    const [currentPage, setCurrentPage] = useState('dashboard');
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        // Check if user is already logged in
        const token = localStorage.getItem('admin_token');
        const user = localStorage.getItem('admin_user');

        if (token && user) {
            setIsAuthenticated(true);
        }
        setLoading(false);
    }, []);

    const handleLogin = (user, token) => {
        localStorage.setItem('admin_token', token);
        localStorage.setItem('admin_user', JSON.stringify(user));
        setIsAuthenticated(true);
    };

    const handleLogout = () => {
        localStorage.removeItem('admin_token');
        localStorage.removeItem('admin_user');
        setIsAuthenticated(false);
        setCurrentPage('dashboard');
    };

    const renderPage = () => {
        switch (currentPage) {
            case 'dashboard':
                return <Dashboard />;
            case 'users':
                return <Users />;
            case 'products':
                return <Products />;
            case 'orders':
                return <Orders />;
            default:
                return <Dashboard />;
        }
    };

    if (loading) {
        return (
            <div className="app-loading">
                <div className="spinner"></div>
                <p>Loading...</p>
            </div>
        );
    }

    if (!isAuthenticated) {
        return <Login onLogin={handleLogin} />;
    }

    return (
        <div className="app">
            <Sidebar
                currentPage={currentPage}
                onNavigate={setCurrentPage}
                onLogout={handleLogout}
            />
            <main className="main-content">
                <div className="content-wrapper">
                    {renderPage()}
                </div>
            </main>
        </div>
    );
}

export default App;
