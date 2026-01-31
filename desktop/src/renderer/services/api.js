import axios from 'axios';

// Django Simple Backend URL (bypasses Oscar middleware)
// Desktop app now uses simple Django endpoints
const API_URL = 'http://localhost:8000/simple';

// Create axios instance
const api = axios.create({
    baseURL: API_URL,
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
    login: (credentials) => api.post('/login/', credentials),
};

// Stats API (using simple endpoint)
export const statsAPI = {
    getDashboard: () => api.get('/stats/'),
};

// Users API (using simple endpoint)
export const usersAPI = {
    getAll: () => api.get('/users/'),
    getById: (id) => api.get(`/users/${id}/`),
    toggleStatus: (id) => api.post(`/users/${id}/toggle/`),
    create: (userData) => api.post('/users/', userData),
    update: (id, userData) => api.put(`/users/${id}/`, userData),
    delete: (id) => api.delete(`/users/${id}/`),
};

// Products API (Simple endpoints for desktop)
export const productsAPI = {
    getAll: () => api.get('/products/'),
    create: (productData) => api.post('/products/', productData),
    update: (id, productData) => api.post(`/products/${id}/`, productData),
    delete: (id) => api.delete(`/products/${id}/`),
};

// Orders API (Simple endpoints for desktop)
export const ordersAPI = {
    getAll: () => api.get('/orders/'),
    getById: (id) => api.get(`/orders/${id}/`),
    updateStatus: (id, status) => api.put(`/orders/${id}/`, { status }),
    update: (id, orderData) => api.put(`/orders/${id}/`, orderData),
    delete: (id) => api.delete(`/orders/${id}/`),
};

export default api;
