import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useAuthStore } from '../store/authStore';
import toast from 'react-hot-toast';

const Register = () => {
    const [formData, setFormData] = useState({
        email: '',
        username: '',
        password: '',
        first_name: '',
        last_name: ''
    });
    const navigate = useNavigate();
    const { register, isLoading } = useAuthStore();

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            await register(formData);
            toast.success('Registration successful!');
            navigate('/');
        } catch (error) {
            toast.error(error.response?.data?.error || 'Registration failed');
        }
    };

    return (
        <div className="container" style={{ padding: '4rem 0', maxWidth: '500px' }}>
            <div className="card">
                <h1 style={{ textAlign: 'center', marginBottom: '2rem' }}>Register</h1>
                <form onSubmit={handleSubmit}>
                    <div className="form-group">
                        <label className="form-label">Email</label>
                        <input
                            type="email"
                            className="input"
                            value={formData.email}
                            onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                            required
                        />
                    </div>
                    <div className="form-group">
                        <label className="form-label">Username</label>
                        <input
                            type="text"
                            className="input"
                            value={formData.username}
                            onChange={(e) => setFormData({ ...formData, username: e.target.value })}
                            required
                        />
                    </div>
                    <div className="form-group">
                        <label className="form-label">First Name</label>
                        <input
                            type="text"
                            className="input"
                            value={formData.first_name}
                            onChange={(e) => setFormData({ ...formData, first_name: e.target.value })}
                        />
                    </div>
                    <div className="form-group">
                        <label className="form-label">Last Name</label>
                        <input
                            type="text"
                            className="input"
                            value={formData.last_name}
                            onChange={(e) => setFormData({ ...formData, last_name: e.target.value })}
                        />
                    </div>
                    <div className="form-group">
                        <label className="form-label">Password</label>
                        <input
                            type="password"
                            className="input"
                            value={formData.password}
                            onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                            required
                        />
                    </div>
                    <button type="submit" className="btn btn-primary" style={{ width: '100%', marginTop: '1.5rem' }} disabled={isLoading}>
                        {isLoading ? 'Registering...' : 'Register'}
                    </button>
                </form>
                <p style={{ textAlign: 'center', marginTop: '1rem' }}>
                    Already have an account? <Link to="/login">Login</Link>
                </p>
            </div>
        </div>
    );
};

export default Register;
