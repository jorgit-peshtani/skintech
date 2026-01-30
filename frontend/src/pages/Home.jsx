import { Link } from 'react-router-dom';
import { Sparkles, Scan, ShoppingBag, Heart } from 'lucide-react';
import './Home.css';

const Home = () => {
    return (
        <div className="home">
            {/* Hero Section */}
            <section className="hero">
                <div className="container">
                    <div className="hero-content">
                        <div className="hero-text">
                            <h1 className="hero-title">
                                Discover Your Perfect
                                <span className="gradient-text"> Skincare</span>
                            </h1>
                            <p className="hero-description">
                                AI-powered ingredient analysis and personalized product recommendations
                                for your unique skin needs. Shop certified cosmetics with confidence.
                            </p>
                            <div className="hero-actions">
                                <Link to="/scanner" className="btn btn-primary btn-lg">
                                    <Scan size={20} />
                                    Scan Product
                                </Link>
                                <Link to="/products" className="btn btn-secondary btn-lg">
                                    <ShoppingBag size={20} />
                                    Browse Products
                                </Link>
                            </div>
                        </div>
                        <div className="hero-image">
                            <div className="hero-card">
                                <div className="floating-icon icon-1">
                                    <Sparkles size={32} />
                                </div>
                                <div className="floating-icon icon-2">
                                    <Heart size={32} />
                                </div>
                                <div className="floating-icon icon-3">
                                    <Scan size={32} />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            {/* Features Section */}
            <section className="features">
                <div className="container">
                    <h2 className="section-title">Why Choose SkinTech?</h2>
                    <div className="features-grid">
                        <div className="feature-card">
                            <div className="feature-icon">
                                <Scan size={32} />
                            </div>
                            <h3>AI-Powered Scanning</h3>
                            <p>
                                Upload product labels and get instant ingredient analysis with
                                safety ratings and skin compatibility scores.
                            </p>
                        </div>

                        <div className="feature-card">
                            <div className="feature-icon">
                                <Sparkles size={32} />
                            </div>
                            <h3>Personalized Recommendations</h3>
                            <p>
                                Get product suggestions tailored to your skin type, concerns,
                                and preferences using advanced ML algorithms.
                            </p>
                        </div>

                        <div className="feature-card">
                            <div className="feature-icon">
                                <ShoppingBag size={32} />
                            </div>
                            <h3>Certified Products</h3>
                            <p>
                                Shop from our curated collection of scientifically verified
                                and certified cosmetic products.
                            </p>
                        </div>

                        <div className="feature-card">
                            <div className="feature-icon">
                                <Heart size={32} />
                            </div>
                            <h3>Skin Health First</h3>
                            <p>
                                Make informed decisions with detailed ingredient information
                                and dermatological insights.
                            </p>
                        </div>
                    </div>
                </div>
            </section>

            {/* CTA Section */}
            <section className="cta">
                <div className="container">
                    <div className="cta-content">
                        <h2>Ready to Transform Your Skincare Routine?</h2>
                        <p>Join thousands of users who trust SkinTech for their skincare needs</p>
                        <Link to="/register" className="btn btn-accent btn-lg">
                            Get Started Free
                        </Link>
                    </div>
                </div>
            </section>
        </div>
    );
};

export default Home;
