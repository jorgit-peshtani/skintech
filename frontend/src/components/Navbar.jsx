import { Link, useNavigate } from 'react-router-dom';
import { ShoppingCart, User, Scan, LogOut, Menu, X } from 'lucide-react';
import { useState } from 'react';
import { useAuthStore } from '../store/authStore';
import { useCartStore } from '../store/cartStore';
import './Navbar.css';

const Navbar = () => {
    const [isMenuOpen, setIsMenuOpen] = useState(false);
    const navigate = useNavigate();
    const { isAuthenticated, user, logout } = useAuthStore();
    const itemCount = useCartStore((state) => state.getItemCount());

    const handleLogout = () => {
        logout();
        navigate('/');
    };

    return (
        <nav className="navbar">
            <div className="container">
                <div className="navbar-content">
                    {/* Logo */}
                    <Link to="/" className="navbar-logo">
                        <div className="logo-icon">ST</div>
                        <span className="logo-text">SkinTech</span>
                    </Link>

                    {/* Desktop Navigation */}
                    <div className="navbar-links">
                        <Link to="/" className="nav-link">Home</Link>
                        <Link to="/products" className="nav-link">Products</Link>
                        {isAuthenticated && (
                            <Link to="/scanner" className="nav-link">
                                <Scan size={18} />
                                <span>Scanner</span>
                            </Link>
                        )}
                    </div>

                    {/* Actions */}
                    <div className="navbar-actions">
                        {isAuthenticated ? (
                            <>
                                <Link to="/cart" className="nav-icon-btn">
                                    <ShoppingCart size={20} />
                                    {itemCount > 0 && (
                                        <span className="cart-badge">{itemCount}</span>
                                    )}
                                </Link>
                                <Link to="/profile" className="nav-icon-btn">
                                    <User size={20} />
                                </Link>
                                <button onClick={handleLogout} className="nav-icon-btn">
                                    <LogOut size={20} />
                                </button>
                            </>
                        ) : (
                            <>
                                <Link to="/login" className="btn btn-ghost btn-sm">
                                    Login
                                </Link>
                                <Link to="/register" className="btn btn-primary btn-sm">
                                    Sign Up
                                </Link>
                            </>
                        )}

                        {/* Mobile Menu Toggle */}
                        <button
                            className="mobile-menu-btn"
                            onClick={() => setIsMenuOpen(!isMenuOpen)}
                        >
                            {isMenuOpen ? <X size={24} /> : <Menu size={24} />}
                        </button>
                    </div>
                </div>

                {/* Mobile Menu */}
                {isMenuOpen && (
                    <div className="mobile-menu">
                        <Link to="/" className="mobile-link" onClick={() => setIsMenuOpen(false)}>
                            Home
                        </Link>
                        <Link to="/products" className="mobile-link" onClick={() => setIsMenuOpen(false)}>
                            Products
                        </Link>
                        {isAuthenticated && (
                            <>
                                <Link to="/scanner" className="mobile-link" onClick={() => setIsMenuOpen(false)}>
                                    Scanner
                                </Link>
                                <Link to="/cart" className="mobile-link" onClick={() => setIsMenuOpen(false)}>
                                    Cart {itemCount > 0 && `(${itemCount})`}
                                </Link>
                                <Link to="/profile" className="mobile-link" onClick={() => setIsMenuOpen(false)}>
                                    Profile
                                </Link>
                                <button onClick={handleLogout} className="mobile-link">
                                    Logout
                                </button>
                            </>
                        )}
                        {!isAuthenticated && (
                            <>
                                <Link to="/login" className="mobile-link" onClick={() => setIsMenuOpen(false)}>
                                    Login
                                </Link>
                                <Link to="/register" className="mobile-link" onClick={() => setIsMenuOpen(false)}>
                                    Sign Up
                                </Link>
                            </>
                        )}
                    </div>
                )}
            </div>
        </nav>
    );
};

export default Navbar;
