import React, { useState, useEffect } from 'react';
import { productsAPI } from '../services/api';
import './Products.css';

function Products() {
    const [products, setProducts] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [searchTerm, setSearchTerm] = useState('');
    const [filterCategory, setFilterCategory] = useState('all');
    const [showModal, setShowModal] = useState(false);
    const [modalMode, setModalMode] = useState('add');
    const [selectedProduct, setSelectedProduct] = useState(null);
    const [formData, setFormData] = useState({
        title: '',
        description: '',
        price: '',
        category: '',
        brand: '',
        stock: '',
        image_url: ''
    });

    useEffect(() => {
        loadProducts();
    }, []);

    const loadProducts = async () => {
        try {
            setLoading(products.length === 0);
            const response = await productsAPI.getAll();
            setProducts(response.data);
            setError('');
        } catch (err) {
            console.error('Failed to load products:', err);
            setError('Failed to load products');
        } finally {
            setLoading(false);
        }
    };

    const handleAddProduct = () => {
        setModalMode('add');
        setSelectedProduct(null);
        setFormData({
            title: '',
            description: '',
            price: '',
            category: '',
            brand: '',
            stock: '',
            image_url: ''
        });
        setShowModal(true);
    };

    const handleEditProduct = (product) => {
        setModalMode('edit');
        setSelectedProduct(product);
        setFormData({
            title: product.title || '',
            description: product.description || '',
            price: product.price || '',
            category: product.category || '',
            brand: product.brand || '',
            stock: product.stock || 0,
            image_url: product.image || ''
        });
        setShowModal(true);
    };

    const handleDeleteProduct = async (productId, productName) => {
        if (!confirm(`Delete "${productName}"? This cannot be undone.`)) return;

        try {
            await productsAPI.delete(productId);
            alert('Product deleted successfully');
            loadProducts();
        } catch (err) {
            alert(err.response?.data?.error || 'Failed to delete product');
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();

        try {
            // Create FormData object for file upload
            const data = new FormData();
            data.append('title', formData.title);
            data.append('description', formData.description || '');
            data.append('price', formData.price);
            data.append('stock', formData.stock);
            data.append('category', formData.category || '');
            data.append('brand', formData.brand || '');

            // Append image file if selected
            if (formData.imageFile) {
                data.append('image', formData.imageFile);
            } else if (formData.image_url) {
                // If it's a remote URL and no new file selected, send it to preserve/restore
                // Only send if it's not a blob (blobs are local only, but if we have blob we usually have imageFile)
                if (!formData.image_url.startsWith('blob:')) {
                    data.append('image_url', formData.image_url);
                }
            }

            if (modalMode === 'add') {
                await productsAPI.create(data);
                // alert('Product created successfully');
            } else {
                await productsAPI.update(selectedProduct.id, data);
                // alert('Product updated successfully');
            }
            setShowModal(false);
            loadProducts();
            // Clear form state
            setFormData({ title: '', description: '', price: '', stock: '', category: '', image_url: '', imageFile: null });
        } catch (err) {
            console.error('Error saving product:', err);
            alert(err.response?.data?.error || 'Failed to save product');
        }
    };

    const categories = ['all', ...new Set(products.map(p => p.category).filter(Boolean))];

    const filteredProducts = products.filter(product => {
        const matchesSearch = (product.title || '').toLowerCase().includes(searchTerm.toLowerCase());
        if (filterCategory === 'all') return matchesSearch;
        return matchesSearch && product.category === filterCategory;
    });

    if (loading) {
        return (
            <div className="products-loading">
                <div className="spinner"></div>
                <p>Loading products...</p>
            </div>
        );
    }

    if (error) {
        return (
            <div className="products-error">
                <p>{error}</p>
                <button onClick={loadProducts}>Retry</button>
            </div>
        );
    }

    return (
        <div className="products-page">
            <div className="products-header">
                <div>
                    <h1>Product Management</h1>
                    <p className="products-subtitle">Manage catalog • Click 🔄 to refresh</p>
                </div>
                <div className="header-actions">
                    <button className="refresh-btn" onClick={() => loadProducts()} title="Refresh">
                        🔄
                    </button>
                    <button className="add-product-btn" onClick={handleAddProduct}>
                        ➕ Add Product
                    </button>
                </div>
            </div>

            <div className="products-controls">
                <input
                    type="text"
                    className="search-input"
                    placeholder="Search products..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                />

                <select
                    className="category-select"
                    value={filterCategory}
                    onChange={(e) => setFilterCategory(e.target.value)}
                >
                    {categories.map(cat => (
                        <option key={cat} value={cat}>
                            {cat === 'all' ? 'All Categories' : cat}
                        </option>
                    ))}
                </select>
            </div>

            <div className="products-table-container">
                <table className="products-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Product</th>
                            <th>Brand</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Stock</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {filteredProducts.map(product => (
                            <tr key={product.id}>
                                <td>#{product.id}</td>
                                <td className="product-name">
                                    {product.image && (
                                        <img src={product.image} alt={product.title} className="product-image" />
                                    )}
                                    <span>{product.title}</span>
                                </td>
                                <td>
                                    <span className="brand-text">{product.brand || '-'}</span>
                                </td>
                                <td>
                                    <span className="category-badge">{product.category || 'Uncategorized'}</span>
                                </td>
                                <td className="price">${parseFloat(product.price || 0).toFixed(2)}</td>
                                <td>
                                    <span className={`stock-badge ${product.stock > 0 ? 'in-stock' : 'out-of-stock'}`}>
                                        {product.stock || 0} units
                                    </span>
                                </td>
                                <td className="action-buttons">
                                    <button className="btn-edit" onClick={() => handleEditProduct(product)}>
                                        ✏️
                                    </button>
                                    <button className="btn-delete" onClick={() => handleDeleteProduct(product.id, product.title)}>
                                        🗑️
                                    </button>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>

                {filteredProducts.length === 0 && (
                    <div className="no-results">
                        <p>No products found</p>
                    </div>
                )}
            </div>

            {/* Product Modal */}
            {showModal && (
                <div className="modal-overlay" onClick={() => setShowModal(false)}>
                    <div className="modal-content" onClick={(e) => e.stopPropagation()}>
                        <div className="modal-header">
                            <h2>{modalMode === 'add' ? 'Add Product' : 'Edit Product'}</h2>
                            <button className="modal-close" onClick={() => setShowModal(false)}>✕</button>
                        </div>
                        <form onSubmit={handleSubmit}>
                            <div className="form-group">
                                <label>Product Name</label>
                                <input
                                    type="text"
                                    value={formData.title || ''}
                                    onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                                    required
                                />
                            </div>
                            <div className="form-group">
                                <label>Brand</label>
                                <input
                                    type="text"
                                    value={formData.brand || ''}
                                    onChange={(e) => setFormData({ ...formData, brand: e.target.value })}
                                    placeholder="e.g. CeraVe, Ordinary"
                                />
                            </div>
                            <div className="form-group">
                                <label>Description</label>
                                <textarea
                                    value={formData.description || ''}
                                    onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                                    rows="3"
                                />
                            </div>
                            <div className="form-row">
                                <div className="form-group">
                                    <label>Price ($)</label>
                                    <input
                                        type="number"
                                        step="0.01"
                                        value={formData.price || ''}
                                        onChange={(e) => setFormData({ ...formData, price: e.target.value })}
                                        required
                                    />
                                </div>
                                <div className="form-group">
                                    <label>Stock Quantity</label>
                                    <input
                                        type="number"
                                        value={formData.stock || ''}
                                        onChange={(e) => setFormData({ ...formData, stock: e.target.value })}
                                        required
                                    />
                                </div>
                            </div>
                            <div className="form-group">
                                <label>Category</label>
                                <input
                                    type="text"
                                    value={formData.category || ''}
                                    onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                                    placeholder="e.g., Cleanser, Moisturiser, Sunscreen"
                                />
                            </div>
                            <div className="form-group">
                                <label>Image URL</label>
                                <div className="file-input-group">
                                    <input
                                        type="text"
                                        value={formData.image_url || ''}
                                        onChange={(e) => setFormData({ ...formData, image_url: e.target.value })}
                                        placeholder="Enter image URL or browse..."
                                    />
                                    <input
                                        type="file"
                                        id="image-file-input"
                                        accept="image/*"
                                        value=""
                                        style={{ display: 'none' }}
                                        onChange={(e) => {
                                            const file = e.target.files[0];
                                            if (file) {
                                                // Create a local file path
                                                const filePath = URL.createObjectURL(file);
                                                setFormData({ ...formData, image_url: filePath, imageFile: file });
                                            }
                                        }}
                                    />
                                    <button
                                        type="button"
                                        className="browse-btn"
                                        onClick={() => document.getElementById('image-file-input').click()}
                                    >
                                        📁 Browse
                                    </button>
                                </div>
                            </div>
                            <div className="modal-actions">
                                <button type="button" className="btn-cancel" onClick={() => setShowModal(false)}>Cancel</button>
                                <button type="submit" className="btn-save">{modalMode === 'add' ? 'Create' : 'Update'}</button>
                            </div>
                        </form>
                    </div>
                </div>
            )}
        </div>
    );
}

export default Products;
