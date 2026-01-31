import { create } from 'zustand';

export const useCartStore = create((set, get) => ({
    items: JSON.parse(localStorage.getItem('cart')) || [],

    addItem: (product, quantity = 1) => {
        const items = get().items;
        const existingItem = items.find(item => item.id === product.id);

        let newItems;
        if (existingItem) {
            newItems = items.map(item =>
                item.id === product.id
                    ? { ...item, quantity: item.quantity + quantity }
                    : item
            );
        } else {
            newItems = [...items, { ...product, quantity }];
        }

        localStorage.setItem('cart', JSON.stringify(newItems));
        set({ items: newItems });
    },

    removeFromCart: (productId) => {
        const newItems = get().items.filter(item => item.id !== productId);
        localStorage.setItem('cart', JSON.stringify(newItems));
        set({ items: newItems });
    },

    updateQuantity: (productId, quantity) => {
        if (quantity <= 0) {
            get().removeFromCart(productId);
            return;
        }

        const newItems = get().items.map(item =>
            item.id === productId
                ? { ...item, quantity }
                : item
        );

        localStorage.setItem('cart', JSON.stringify(newItems));
        set({ items: newItems });
    },

    clearCart: () => {
        localStorage.removeItem('cart');
        set({ items: [] });
    },

    getCartTotal: () => {
        return get().items.reduce((total, item) => {
            return total + (item.price * item.quantity);
        }, 0);
    },

    getItemCount: () => {
        return get().items.reduce((count, item) => count + item.quantity, 0);
    },
}));
