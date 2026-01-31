import axios from 'axios';

// Use environment variable for API URL - works for both local and production
// Django Oscar backend (port 8000)
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000';

console.log('API URL:', API_URL); // For debugging deployment

// Create axios instance
const api = axios.create({
    baseURL: `${API_URL}/api`,
    headers: {
        'Content-Type': 'application/json',
    },
});

// Request interceptor to add auth token
api.interceptors.request.use(
    (config) => {
        const token = localStorage.getItem('access_token');
        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
    },
    (error) => Promise.reject(error)
);

// Response interceptor to handle token refresh
api.interceptors.response.use(
    (response) => response,
    async (error) => {
        const originalRequest = error.config;

        if (error.response?.status === 401 && !originalRequest._retry) {
            originalRequest._retry = true;

            try {
                const refreshToken = localStorage.getItem('refresh_token');
                const response = await axios.post(`${API_URL}/api/auth/refresh`, {}, {
                    headers: {
                        Authorization: `Bearer ${refreshToken}`,
                    },
                });

                const { access_token } = response.data;
                localStorage.setItem('access_token', access_token);

                originalRequest.headers.Authorization = `Bearer ${access_token}`;
                return api(originalRequest);
            } catch (refreshError) {
                localStorage.removeItem('access_token');
                localStorage.removeItem('refresh_token');
                window.location.href = '/login';
                return Promise.reject(refreshError);
            }
        }

        return Promise.reject(error);
    }
);

// Auth API
export const authAPI = {
    register: (data) => api.post('/auth/register', data),
    login: (data) => api.post('/auth/login', data),
    getCurrentUser: () => api.get('/auth/me'),
    changePassword: (data) => api.post('/auth/change-password', data),
};

// Products API - Custom web endpoint with full details
export const productsAPI = {
    getProducts: (params) => api.get('/web/products/', { params }),
    getProduct: (id) => api.get(`/web/products/${id}/`),
    getCategories: () => api.get('/web/products/categories'),
    getBrands: () => api.get('/web/products/brands'),
    getReviews: (productId, params) => api.get(`/products/${productId}/reviews`, { params }),
    createReview: (productId, data) => api.post(`/products/${productId}/reviews`, data),
    createProduct: (data) => api.post('/web/products/', data),
    updateProduct: (id, data) => api.put(`/web/products/${id}/`, data),
};

// Scan API
export const scanAPI = {
    uploadScan: (formData) => api.post('/scan/upload', formData, {
        headers: {
            'Content-Type': 'multipart/form-data',
        },
    }),
    analyzeText: (data) => api.post('/scan/analyze-text', data),
    getScanHistory: (params) => api.get('/scan/history', { params }),
    getScan: (id) => api.get(`/scan/${id}`),
    deleteScan: (id) => api.delete(`/scan/${id}`),
};

// Recommendations API
export const recommendationsAPI = {
    getRecommendations: (params) => api.get('/recommendations', { params }),
    getPopular: (params) => api.get('/recommendations/popular', { params }),
};

// Orders API
export const ordersAPI = {
    createOrder: (data) => api.post('/orders', data),
    getOrders: (params) => api.get('/orders', { params }),
    getOrder: (id) => api.get(`/orders/${id}`),
    processPayment: (id, data) => api.post(`/orders/${id}/payment`, data),
    cancelOrder: (id) => api.post(`/orders/${id}/cancel`),
};

// Users API
export const usersAPI = {
    getProfile: () => api.get('/users/profile'),
    updateProfile: (data) => api.put('/users/profile', data),
    updatePreferences: (data) => api.put('/users/preferences', data),
    getStats: () => api.get('/users/stats'),
};

export default api;
