import { create } from 'zustand';
import { authAPI } from '../services/api';

export const useAuthStore = create((set) => ({
    user: null,
    profile: null,
    isAuthenticated: false,
    isLoading: false,
    error: null,

    login: async (credentials) => {
        set({ isLoading: true, error: null });
        try {
            const response = await authAPI.login(credentials);
            const { user, access_token, refresh_token } = response.data;

            localStorage.setItem('access_token', access_token);
            localStorage.setItem('refresh_token', refresh_token);

            set({ user, isAuthenticated: true, isLoading: false });
            return response.data;
        } catch (error) {
            set({ error: error.response?.data?.error || 'Login failed', isLoading: false });
            throw error;
        }
    },

    register: async (userData) => {
        set({ isLoading: true, error: null });
        try {
            const response = await authAPI.register(userData);
            const { user, access_token, refresh_token } = response.data;

            localStorage.setItem('access_token', access_token);
            localStorage.setItem('refresh_token', refresh_token);

            set({ user, isAuthenticated: true, isLoading: false });
            return response.data;
        } catch (error) {
            set({ error: error.response?.data?.error || 'Registration failed', isLoading: false });
            throw error;
        }
    },

    logout: () => {
        localStorage.removeItem('access_token');
        localStorage.removeItem('refresh_token');
        set({ user: null, profile: null, isAuthenticated: false });
    },

    fetchCurrentUser: async () => {
        const token = localStorage.getItem('access_token');
        if (!token) {
            set({ isAuthenticated: false });
            return;
        }

        set({ isLoading: true });
        try {
            const response = await authAPI.getCurrentUser();
            const { user, profile } = response.data;
            set({ user, profile, isAuthenticated: true, isLoading: false });
        } catch (error) {
            localStorage.removeItem('access_token');
            localStorage.removeItem('refresh_token');
            set({ user: null, profile: null, isAuthenticated: false, isLoading: false });
        }
    },

    updateProfile: (profile) => {
        set({ profile });
    },
}));
