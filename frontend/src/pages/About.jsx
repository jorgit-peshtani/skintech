import './About.css';
import { Shield, Sparkles, Heart, Users } from 'lucide-react';

const About = () => {
    return (
        <div className="about-page">
            {/* Header */}
            <header className="about-header">
                <div className="container">
                    <h1 className="about-title">Revolutionizing Skincare with AI</h1>
                    <p className="about-subtitle">
                        We blend dermatological science with artificial intelligence to help you
                        find the perfect products for your unique skin.
                    </p>
                </div>
            </header>

            {/* Mission Section */}
            <section className="mission-section">
                <div className="container">
                    <div className="mission-grid">
                        <div className="mission-card">
                            <Sparkles className="mission-icon" size={40} />
                            <h3>Innovation</h3>
                            <p>Using cutting-edge computer vision to analyze ingredients instantly.</p>
                        </div>
                        <div className="mission-card">
                            <Shield className="mission-icon" size={40} />
                            <h3>Safety</h3>
                            <p>We flag potential allergens and explain complex chemical names in plain English.</p>
                        </div>
                        <div className="mission-card">
                            <Heart className="mission-icon" size={40} />
                            <h3>Personalization</h3>
                            <p>No two skins are alike. Our algorithms tailor recommendations just for you.</p>
                        </div>
                    </div>
                </div>
            </section>

            {/* Story Section */}
            <section className="story-section">
                <div className="container">
                    <div className="story-content">
                        <h2>Our Story</h2>
                        <p>
                            SkinTech began when our founders realized how confusing cosmetic labels typically are.
                            With thousands of chemical names and marketing Jargon, finding safe and effective products
                            was a guessing game.
                        </p>
                        <p>
                            We set out to build a tool that empowers consumers. By combining a database of over
                            10,000 ingredients with verified scientific research, we created the SkinTech Scanner—your
                            personal dermatologist in your pocket.
                        </p>
                    </div>
                </div>
            </section>

            {/* Team Section Placeholder */}
            <section className="team-section">
                <div className="container">
                    <h2>Meet the Team</h2>
                    <div className="team-grid">
                        <div className="team-member">
                            <div className="member-avatar">
                                <Users size={40} color="#7C7D80" />
                            </div>
                            <h3>Sarah Johnson</h3>
                            <span>Lead Dermatologist</span>
                        </div>
                        <div className="team-member">
                            <div className="member-avatar">
                                <Users size={40} color="#7C7D80" />
                            </div>
                            <h3>David Chen</h3>
                            <span>AI Engineer</span>
                        </div>
                        <div className="team-member">
                            <div className="member-avatar">
                                <Users size={40} color="#7C7D80" />
                            </div>
                            <h3>Maria Garcia</h3>
                            <span>Product Head</span>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    );
};

export default About;
