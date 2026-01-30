import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { productsAPI } from '../services/api';
import './Products.css';

const Products = () => {
    const [products, setProducts] = useState([]);
    const [loading, setLoading] = useState(true);
    const [selectedCategory, setSelectedCategory] = useState('All');
    const [categories, setCategories] = useState([]);
    const [searchTerm, setSearchTerm] = useState('');

    useEffect(() => {
        fetchCategories();
        fetchProducts();
    }, []);

    const fetchCategories = async () => {
        try {
            const response = await productsAPI.getCategories();
            setCategories(['All', ...(response.data.categories || [])]);
        } catch (error) {
            console.error('Error fetching categories:', error);
            setCategories(['All']);
        }
    };

    const fetchProducts = async () => {
        try {
            const params = {};
            if (selectedCategory && selectedCategory !== 'All') {
                params.category = selectedCategory;
            }
            if (searchTerm) {
                params.search = searchTerm;
            }

            const response = await productsAPI.getProducts(params);
            console.log('Products:', response.data);
            setProducts(response.data.products || []);
        } catch (error) {
            console.error('Error fetching products:', error);
            setProducts([]);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        if (!loading) {
            fetchProducts();
        }
    }, [selectedCategory, searchTerm]);

    if (loading) {
        return (
            <div className="products-page">
                <div className="container">
                    <div className="loading">Loading products...</div>
                </div>
            </div>
        );
    }

    return (
        <div className="products-page">
            <div className="container">
                <div className="products-header">
                    <h1>Skincare Products</h1>
                    <p className="subtitle">Discover our curated selection of premium skincare</p>
                </div>

                {/* Search and Filters */}
                <div className="products-controls">
                    <input
                        type="text"
                        className="search-input"
                        placeholder="Search products..."
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />

                    <div className="category-filters">
                        {categories.map(category => (
                            <button
                                key={category}
                                className={`category-btn ${selectedCategory === category ? 'active' : ''}`}
                                onClick={() => setSelectedCategory(category)}
                            >
                                {category}
                            </button>
                        ))}
                    </div>
                </div>

                {/* Products Grid */}
                {products.length === 0 ? (
                    <div className="no-products">
                        <p>No products found{selectedCategory !== 'All' ? ` in ${selectedCategory}` : ''}.</p>
                    </div>
                ) : (
                    <>
                        <div className="products-count">
                            Showing {products.length} product{products.length !== 1 ? 's' : ''}
                        </div>
                        <div className="products-grid">
                            {products.map(product => (
                                <div key={product.id} className="product-card">
                                    <div className="product-image">
                                        <img
                                            src={product.image_url || 'https://via.placeholder.com/300x300?text=SkinTech'}
                                            alt={product.name}
                                            onError={(e) => {
                                                e.target.src = 'https://via.placeholder.com/300x300?text=SkinTech';
                                            }}
                                        />
                                        <span className="product-category">{product.category}</span>
                                    </div>
                                    <div className="product-info">
                                        <div className="product-brand">{product.brand}</div>
                                        <h3 className="product-name">{product.name}</h3>
                                        <p className="product-description">
                                            {product.description
                                                ? product.description.substring(0, 120) + '...'
                                                : 'Premium skincare product'}
                                        </p>
                                        {product.suitable_for_skin_types && product.suitable_for_skin_types.length > 0 && (
                                            <div className="product-skin-types">
                                                {product.suitable_for_skin_types.slice(0, 3).map((type, idx) => (
                                                    <span key={idx} className="skin-type-tag">{type}</span>
                                                ))}
                                            </div>
                                        )}
                                        <div className="product-footer">
                                            <div className="product-price">${parseFloat(product.price).toFixed(2)}</div>
                                            <button className="add-to-cart-btn">Add to Cart</button>
                                        </div>
                                    </div>
                                </div>
                            ))}
                        </div>
                    </>
                )}
            </div>
        </div>
    );
};

export default Products;
