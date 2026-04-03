import './About.css';

const PrivacyPolicy = () => (
    <div className="about-page" style={{ minHeight: '80vh' }}>
        <div className="about-hero">
            <div className="container">
                <h1>Privacy Policy</h1>
                <p>Last updated: April 2026</p>
            </div>
        </div>
        <div className="about-content">
            <div className="container">
                <div style={{ maxWidth: '800px', margin: '0 auto', lineHeight: '1.8', color: '#5e5f61' }}>
                    <section style={{ marginBottom: '2rem' }}>
                        <h2 style={{ color: '#7C7D80', fontSize: '1.4rem', marginBottom: '1rem' }}>1. Information We Collect</h2>
                        <p>We collect information you provide directly, such as your name, email address, and password when you create an account. We also collect usage data to improve your experience.</p>
                    </section>
                    <section style={{ marginBottom: '2rem' }}>
                        <h2 style={{ color: '#7C7D80', fontSize: '1.4rem', marginBottom: '1rem' }}>2. How We Use Your Information</h2>
                        <p>Your information is used to provide and improve our services, personalize your recommendations, send transactional emails, and ensure platform security. We do not sell your data to third parties.</p>
                    </section>
                    <section style={{ marginBottom: '2rem' }}>
                        <h2 style={{ color: '#7C7D80', fontSize: '1.4rem', marginBottom: '1rem' }}>3. Data Security</h2>
                        <p>We implement industry-standard security measures including encryption and secure servers to protect your personal information from unauthorized access.</p>
                    </section>
                    <section style={{ marginBottom: '2rem' }}>
                        <h2 style={{ color: '#7C7D80', fontSize: '1.4rem', marginBottom: '1rem' }}>4. Cookies</h2>
                        <p>We use cookies to maintain your login session and understand how you use our platform. You can disable cookies in your browser settings, though some features may not function correctly.</p>
                    </section>
                    <section style={{ marginBottom: '2rem' }}>
                        <h2 style={{ color: '#7C7D80', fontSize: '1.4rem', marginBottom: '1rem' }}>5. Contact Us</h2>
                        <p>If you have questions about this policy, please contact us at <a href="mailto:support@skintech.com" style={{ color: '#B0C7DD' }}>support@skintech.com</a>.</p>
                    </section>
                </div>
            </div>
        </div>
    </div>
);

export default PrivacyPolicy;
