import './About.css';

const FAQ = () => {
    const faqs = [
        {
            q: 'What is SkinTech?',
            a: 'SkinTech is an AI-powered skincare platform that helps you analyze product ingredients and find personalized product recommendations.'
        },
        {
            q: 'How does the ingredient scanner work?',
            a: 'You can upload a photo of any product label. Our AI reads and analyzes the ingredients list, identifying potentially harmful or beneficial compounds for your skin.'
        },
        {
            q: 'Is my account data secure?',
            a: 'Yes. We use industry-standard encryption to protect all personal data. We never sell your information to third parties.'
        },
        {
            q: 'Can I use SkinTech without creating an account?',
            a: 'You can browse products freely without an account. To use the scanner, save favorites, or make purchases, you will need to register.'
        },
        {
            q: 'How do I contact support?',
            a: 'You can reach us at support@skintech.com or via our Contact page.'
        },
    ];

    return (
        <div className="about-page" style={{ minHeight: '80vh' }}>
            <div className="about-hero">
                <div className="container">
                    <h1>Frequently Asked Questions</h1>
                    <p>Find answers to the most common questions about SkinTech.</p>
                </div>
            </div>

            <div className="about-content">
                <div className="container">
                    <div style={{ maxWidth: '800px', margin: '0 auto' }}>
                        {faqs.map((item, i) => (
                            <div key={i} style={{
                                background: 'white',
                                borderRadius: '12px',
                                padding: '1.5rem 2rem',
                                marginBottom: '1rem',
                                border: '1px solid rgba(176,199,221,0.3)',
                                boxShadow: '0 2px 8px rgba(0,0,0,0.05)'
                            }}>
                                <h3 style={{ color: '#7C7D80', marginBottom: '0.5rem', fontSize: '1.1rem' }}>{item.q}</h3>
                                <p style={{ color: '#5e5f61', lineHeight: '1.7', margin: 0 }}>{item.a}</p>
                            </div>
                        ))}
                    </div>
                </div>
            </div>
        </div>
    );
};

export default FAQ;
