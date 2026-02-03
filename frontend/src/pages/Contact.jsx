import { useState } from 'react';
import toast from 'react-hot-toast';
import { Mail, MapPin, Phone, Send } from 'lucide-react';
import './Contact.css';

const Contact = () => {
    const [formData, setFormData] = useState({
        name: '',
        email: '',
        subject: '',
        message: ''
    });

    const handleSubmit = (e) => {
        e.preventDefault();
        // Here you would typically call an API
        console.log('Contact form submitted:', formData);
        toast.success('Message sent! We will get back to you soon.');
        setFormData({ name: '', email: '', subject: '', message: '' });
    };

    const handleChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    return (
        <div className="contact-page">
            <div className="contact-header">
                <div className="container">
                    <h1>Get in Touch</h1>
                    <p>Have questions about a product or need help with the scanner? We're here for you.</p>
                </div>
            </div>

            <div className="container contact-container">
                <div className="contact-wrapper">
                    {/* Contact Info Sidebar */}
                    <div className="contact-info">
                        <h2>Contact Information</h2>
                        <div className="info-item">
                            <Mail className="icon" />
                            <div>
                                <h3>Email</h3>
                                <p>support@skintech.com</p>
                            </div>
                        </div>
                        <div className="info-item">
                            <Phone className="icon" />
                            <div>
                                <h3>Phone</h3>
                                <p>+355 69 123 4567</p>
                            </div>
                        </div>
                        <div className="info-item">
                            <MapPin className="icon" />
                            <div>
                                <h3>Office</h3>
                                <p>Rruga Hermann Gmeiner, Sauk, Albania</p>
                            </div>
                        </div>
                    </div>

                    {/* Contact Form */}
                    <div className="contact-form-wrapper">
                        <form onSubmit={handleSubmit} className="contact-form">
                            <div className="form-group">
                                <label>Name</label>
                                <input
                                    type="text"
                                    name="name"
                                    value={formData.name}
                                    onChange={handleChange}
                                    required
                                    placeholder="Your Name"
                                />
                            </div>
                            <div className="form-group">
                                <label>Email</label>
                                <input
                                    type="email"
                                    name="email"
                                    value={formData.email}
                                    onChange={handleChange}
                                    required
                                    placeholder="your@email.com"
                                />
                            </div>
                            <div className="form-group">
                                <label>Subject</label>
                                <input
                                    type="text"
                                    name="subject"
                                    value={formData.subject}
                                    onChange={handleChange}
                                    required
                                    placeholder="How can we help?"
                                />
                            </div>
                            <div className="form-group">
                                <label>Message</label>
                                <textarea
                                    name="message"
                                    value={formData.message}
                                    onChange={handleChange}
                                    required
                                    rows="5"
                                    placeholder="Write your message here..."
                                ></textarea>
                            </div>
                            <button type="submit" className="btn btn-primary submit-btn">
                                <Send size={18} />
                                Send Message
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Contact;
