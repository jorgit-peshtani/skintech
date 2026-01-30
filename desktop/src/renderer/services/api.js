import axios from 'axios';

// Admin Backend URL (separate from web/mobile backend)
// Desktop app uses dedicated admin backend on port 3001
const API_URL = 'http://localhost:3001/api';

// Create axios instance
const api = axios.create({
    baseURL: API_URL,
    headers: {
        'Content-Type': 'application/json',
    },
});

// Request interceptor to add auth token
api.interceptors.request.use(
    (config) => {
        const token = localStorage.getItem('admin_token');
        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
    },
    (error) => Promise.reject(error)
);

// Response interceptor for error handling
api.interceptors.response.use(
    (response) => response,
    (error) => {
        if (error.response?.status === 401) {
            // Token expired or invalid
            localStorage.removeItem('admin_token');
            localStorage.removeItem('admin_user');
            window.location.reload();
        }
        return Promise.reject(error);
    }
);

// Auth API
export const authAPI = {
    login: (credentials) => api.post('/auth/login', credentials),
};

// Stats API
export const statsAPI = {
    getDashboard: () => api.get('/admin/stats/dashboard'),
};

// Users API
export const usersAPI = {
    getAll: () => api.get('/admin/users'),
    getById: (id) => api.get(`/admin/users/${id}`),
    toggleStatus: (id) => api.post(`/admin/users/${id}/toggle`),
    create: (userData) => api.post('/admin/users', userData),
    update: (id, userData) => api.put(`/admin/users/${id}`, userData),
    delete: (id) => api.delete(`/admin/users/${id}`),
};

// Products API
export const productsAPI = {
    getAll: () => api.get('/admin/products'),
    create: (productData) => api.post('/admin/products', productData),
    update: (id, productData) => api.put(`/admin/products/${id}`, productData),
    delete: (id) => api.delete(`/admin/products/${id}`),
};

// Orders API
export const ordersAPI = {
    getAll: () => api.get('/admin/orders'),
    getById: (id) => api.get(`/admin/orders/${id}`),
    updateStatus: (id, status) => api.put(`/admin/orders/${id}`, { status }),
    update: (id, orderData) => api.put(`/admin/orders/${id}`, orderData),
    delete: (id) => api.delete(`/admin/orders/${id}`),
};

export default api;
