import React, { useState } from 'react';
import { authAPI } from '../services/api';
import './Login.css';

function Login({ onLogin }) {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');

    const handleSubmit = async (e) => {
        e.preventDefault();
        setError('');
        setLoading(true);

        try {
            const response = await authAPI.login({ email, password });
            const { user, access_token } = response.data;

            // Only allow admin users (check is_admin field from backend)
            if (!user.is_admin) {
                setError('Access denied. Admin privileges required.');
                setLoading(false);
                return;
            }

            onLogin(user, access_token);
        } catch (err) {
            console.error('Login error:', err);
            setError(err.response?.data?.error || 'Login failed. Please try again.');
        } finally {
            setLoading(false);
        }
    };

    const useDemoAccount = () => {
        setEmail('admin@skintech.com');
        setPassword('admin123');
    };

    return (
        <div className="login-container">
            <div className="login-background"></div>
            <div className="login-box">
                <div className="login-header">
                    <h1>SkinTech Admin</h1>
                    <p>Control Panel</p>
                </div>

                <form onSubmit={handleSubmit} className="login-form">
                    {error && <div className="error-message">{error}</div>}

                    <div className="form-group">
                        <label>Email</label>
                        <input
                            type="email"
                            value={email}
                            onChange={(e) => setEmail(e.target.value)}
                            placeholder="admin@skintech.com"
                            required
                            autoFocus
                        />
                    </div>

                    <div className="form-group">
                        <label>Password</label>
                        <input
                            type="password"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            placeholder="Enter password"
                            required
                        />
                    </div>

                    <button type="submit" className="login-button" disabled={loading}>
                        {loading ? 'Logging in...' : 'Login'}
                    </button>

                    <button type="button" className="demo-button" onClick={useDemoAccount}>
                        Use Demo Account
                    </button>
                </form>

                <div className="login-footer">
                    <p>© 2026 SkinTech. All rights reserved.</p>
                </div>
            </div>
        </div>
    );
}

export default Login;
