import { useState, useEffect } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';
import { productsAPI } from '../services/api';
import { useCartStore } from '../store/cartStore';
import toast from 'react-hot-toast';
import './ProductDetail.css';

const ProductDetail = () => {
    const { id } = useParams();
    const navigate = useNavigate();
    const [product, setProduct] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [quantity, setQuantity] = useState(1);

    const { addItem } = useCartStore();

    useEffect(() => {
        fetchProduct();
    }, [id]);

    const fetchProduct = async () => {
        try {
            const response = await productsAPI.getProduct(id);
            setProduct(response.data);
        } catch (error) {
            console.error('Error fetching product:', error);
            setError('Failed to load product');
        } finally {
            setLoading(false);
        }
    };

    const handleAddToCart = () => {
        if (!product) return;

        // Ensure we pass the transformed/cleaned product data if needed, but product here comes from API
        // which might use 'title' instead of 'name'. Let's normalize it like in Products.jsx
        const productToAdd = {
            ...product,
            name: product.title || product.name,
            stock_quantity: product.stock || product.stock_quantity,
            image_url: product.image || product.image_url
        };

        addItem(productToAdd, quantity);
        toast.success(`Added ${quantity} ${productToAdd.name} to cart`);
    };

    if (loading) {
        return (
            <div className="container product-detail-loading">
                <div className="loading-spinner">Loading product...</div>
            </div>
        );
    }

    if (error || !product) {
        return (
            <div className="container product-detail-error">
                <div className="error-message">
                    <h2>Product not found</h2>
                    <p>{error}</p>
                    <Link to="/products" className="back-btn">← Back to Products</Link>
                </div>
            </div>
        );
    }

    return (
        <div className="product-detail-page">
            <div className="container">
                {/* Breadcrumb */}
                <div className="breadcrumb">
                    <Link to="/">Home</Link>
                    <span>/</span>
                    <Link to="/products">Products</Link>
                    <span>/</span>
                    <span>{product.category}</span>
                    <span>/</span>
                    <span className="current">{product.name}</span>
                </div>

                <div className="product-detail-grid">
                    {/* Product Image */}
                    <div className="product-image-section">
                        <div className="main-image">
                            <img
                                src={product.image_url || 'https://via.placeholder.com/500x500?text=SkinTech'}
                                alt={product.name}
                                onError={(e) => {
                                    e.target.src = 'https://via.placeholder.com/500x500?text=SkinTech';
                                }}
                            />
                        </div>
                        {product.is_certified && (
                            <div className="certified-badge">
                                <svg viewBox="0 0 20 20" fill="currentColor">
                                    <path fillRule="evenodd" d="M6.267 3.455a3.066 3.066 0 001.745-.723 3.066 3.066 0 013.976 0 3.066 3.066 0 001.745.723 3.066 3.066 0 012.812 2.812c.051.643.304 1.254.723 1.745a3.066 3.066 0 010 3.976 3.066 3.066 0 00-.723 1.745 3.066 3.066 0 01-2.812 2.812 3.066 3.066 0 00-1.745.723 3.066 3.066 0 01-3.976 0 3.066 3.066 0 00-1.745-.723 3.066 3.066 0 01-2.812-2.812 3.066 3.066 0 00-.723-1.745 3.066 3.066 0 010-3.976 3.066 3.066 0 00.723-1.745 3.066 3.066 0 012.812-2.812zm7.44 5.252a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                                </svg>
                                <span>Certified Safe</span>
                            </div>
                        )}
                    </div>

                    {/* Product Info */}
                    <div className="product-info-section">
                        <div className="product-category-tag">{product.category}</div>
                        <div className="product-brand">{product.brand}</div>
                        <h1 className="product-title">{product.name}</h1>

                        <div className="product-price">
                            <span className="current-price">€{parseFloat(product.price).toFixed(2)}</span>
                        </div>

                        {/* Stock Status */}
                        <div className="stock-status">
                            {product.stock_quantity > 0 ? (
                                <span className="in-stock">✓ In Stock ({product.stock_quantity} available)</span>
                            ) : (
                                <span className="out-of-stock">Out of Stock</span>
                            )}
                        </div>

                        {/* Skin Types */}
                        {product.suitable_for_skin_types && product.suitable_for_skin_types.length > 0 && (
                            <div className="skin-types-section">
                                <h3>Suitable for:</h3>
                                <div className="skin-types-list">
                                    {product.suitable_for_skin_types.map((type, idx) => (
                                        <span key={idx} className="skin-type-badge">{type}</span>
                                    ))}
                                </div>
                            </div>
                        )}

                        {/* Target Concerns */}
                        {product.target_concerns && product.target_concerns.length > 0 && (
                            <div className="concerns-section">
                                <h3>Targets:</h3>
                                <div className="concerns-list">
                                    {product.target_concerns.map((concern, idx) => (
                                        <span key={idx} className="concern-badge">{concern}</span>
                                    ))}
                                </div>
                            </div>
                        )}

                        {/* Quantity Selector & Add to Cart */}
                        <div className="purchase-section">
                            <div className="quantity-selector">
                                <button
                                    onClick={() => setQuantity(Math.max(1, quantity - 1))}
                                    disabled={quantity <= 1}
                                >
                                    −
                                </button>
                                <input
                                    type="number"
                                    value={quantity}
                                    onChange={(e) => setQuantity(Math.max(1, parseInt(e.target.value) || 1))}
                                    min="1"
                                    max={product.stock_quantity}
                                />
                                <button
                                    onClick={() => setQuantity(Math.min(product.stock_quantity, quantity + 1))}
                                    disabled={quantity >= product.stock_quantity}
                                >
                                    +
                                </button>
                            </div>
                            <button
                                className="add-to-cart-btn-large"
                                onClick={handleAddToCart}
                                disabled={product.stock_quantity === 0}
                            >
                                Add to Cart
                            </button>
                        </div>

                        {/* Description */}
                        <div className="product-description">
                            <h2>About this product</h2>
                            <p>{product.description || 'Premium skincare product for your daily routine.'}</p>
                        </div>

                        {/* Ingredients */}
                        {product.ingredients && (
                            <div className="product-ingredients">
                                <h2>Ingredients</h2>
                                <p className="ingredients-text">{product.ingredients}</p>
                            </div>
                        )}
                    </div>
                </div>

                {/* Related Products could go here */}
            </div>
        </div>
    );
};

export default ProductDetail;
