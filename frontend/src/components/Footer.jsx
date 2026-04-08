import { Link } from 'react-router-dom';
import { Mail, Phone, MapPin } from 'lucide-react';
import './Footer.css';

const Footer = () => {
    return (
        <footer className="footer">
            <div className="container">
                <div className="footer-content">
                    {/* Company Info */}
                    <div className="footer-section">
                        <div className="footer-logo">
                            <div className="logo-icon">ST</div>
                            <span className="logo-text">SkinTech</span>
                        </div>
                        <p className="footer-description">
                            AI-powered skincare analysis and personalized product recommendations
                            for healthier, more beautiful skin.
                        </p>

                    </div>

                    {/* Quick Links */}
                    <div className="footer-section">
                        <h4 className="footer-title">Quick Links</h4>
                        <ul className="footer-links">
                            <li><Link to="/">Home</Link></li>
                            <li><Link to="/products">Products</Link></li>
                            <li><Link to="/scanner">Scanner</Link></li>
                            <li><Link to="/about">About Us</Link></li>
                        </ul>
                    </div>

                    {/* Support */}
                    <div className="footer-section">
                        <h4 className="footer-title">Support</h4>
                        <ul className="footer-links">
                            <li><Link to="/faq">FAQ</Link></li>
                            <li><Link to="/privacy">Privacy Policy</Link></li>
                            <li><Link to="/terms">Terms of Service</Link></li>
                        </ul>
                    </div>

                    {/* Contact */}
                    <div className="footer-section">
                        <h4 className="footer-title">Contact Us</h4>
                        <ul className="footer-contact">
                            <li>
                                <Mail size={18} />
                                <span>support@skintech.com</span>
                            </li>
                            <li>
                                <Phone size={18} />
                                <span>+355 69 123 4567</span>
                            </li>
                            <li>
                                <MapPin size={18} />
                                <span>Tirana, Albania</span>
                            </li>
                        </ul>
                    </div>
                </div>

                <div className="footer-bottom">
                    <p>&copy; 2026 SkinTech. All rights reserved.</p>
                    <p>Made with ❤️ for healthier skin</p>
                </div>
            </div>
        </footer>
    );
};

export default Footer;
