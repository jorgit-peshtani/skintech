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
                            SkinTech started with a simple question: "What are we really putting on our skin?"
                            In a market flooded with complex chemical names and misleading marketing, our team saw a need for clarity.
                            As a group of passionate developers and innovators, we combined our technical expertise to bridge the gap between
                            dermatological science and daily consumer choices.
                        </p>
                        <p>
                            What began as a collaborative diploma project has evolved into a powerful AI-driven platform.
                            We believe transparency shouldn't be a luxury—it should be the standard. By decoding over 10,000 ingredients
                            instantaneously, SkinTech empowers you to make safer, smarter, and more personalized skincare decisions
                            without needing a chemistry degree.
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
                            <h3>Uendi Peza</h3>
                            <span>CEO and Project Manager</span>
                        </div>
                        <div className="team-member">
                            <div className="member-avatar">
                                <Users size={40} color="#7C7D80" />
                            </div>
                            <h3>Elena Goçi</h3>
                            <span>Graphic Designer & Desktop Backend</span>
                        </div>
                        <div className="team-member">
                            <div className="member-avatar">
                                <Users size={40} color="#7C7D80" />
                            </div>
                            <h3>Eriko Prençe</h3>
                            <span>Android & iOS Developer</span>
                        </div>
                        <div className="team-member">
                            <div className="member-avatar">
                                <Users size={40} color="#7C7D80" />
                            </div>
                            <h3>Edmir Hoxha</h3>
                            <span>Fullstack Developer</span>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    );
};

export default About;
