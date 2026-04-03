import './About.css';

const TermsOfService = () => (
    <div className="about-page" style={{ minHeight: '80vh' }}>
        <div className="about-hero">
            <div className="container">
                <h1>Terms of Service</h1>
                <p>Last updated: April 2026</p>
            </div>
        </div>
        <div className="about-content">
            <div className="container">
                <div style={{ maxWidth: '800px', margin: '0 auto', lineHeight: '1.8', color: '#5e5f61' }}>
                    <section style={{ marginBottom: '2rem' }}>
                        <h2 style={{ color: '#7C7D80', fontSize: '1.4rem', marginBottom: '1rem' }}>1. Acceptance of Terms</h2>
                        <p>By accessing or using SkinTech, you agree to be bound by these Terms of Service and our Privacy Policy. If you do not agree, please do not use our platform.</p>
                    </section>
                    <section style={{ marginBottom: '2rem' }}>
                        <h2 style={{ color: '#7C7D80', fontSize: '1.4rem', marginBottom: '1rem' }}>2. Use of the Platform</h2>
                        <p>You agree to use SkinTech only for lawful purposes. You must not misuse the platform, attempt unauthorized access, or engage in any activity that disrupts service for other users.</p>
                    </section>
                    <section style={{ marginBottom: '2rem' }}>
                        <h2 style={{ color: '#7C7D80', fontSize: '1.4rem', marginBottom: '1rem' }}>3. Account Responsibility</h2>
                        <p>You are responsible for maintaining the confidentiality of your account credentials. You agree to notify us immediately of any unauthorized use of your account.</p>
                    </section>
                    <section style={{ marginBottom: '2rem' }}>
                        <h2 style={{ color: '#7C7D80', fontSize: '1.4rem', marginBottom: '1rem' }}>4. Product Information</h2>
                        <p>Product information provided on SkinTech is for informational purposes only and does not constitute medical or dermatological advice. Always consult a healthcare professional for skin concerns.</p>
                    </section>
                    <section style={{ marginBottom: '2rem' }}>
                        <h2 style={{ color: '#7C7D80', fontSize: '1.4rem', marginBottom: '1rem' }}>5. Changes to Terms</h2>
                        <p>We reserve the right to update these terms at any time. Continued use of SkinTech following any changes constitutes your acceptance of the new terms.</p>
                    </section>
                    <section style={{ marginBottom: '2rem' }}>
                        <h2 style={{ color: '#7C7D80', fontSize: '1.4rem', marginBottom: '1rem' }}>6. Contact</h2>
                        <p>Questions about these terms? Contact us at <a href="mailto:support@skintech.com" style={{ color: '#B0C7DD' }}>support@skintech.com</a>.</p>
                    </section>
                </div>
            </div>
        </div>
    </div>
);

export default TermsOfService;
