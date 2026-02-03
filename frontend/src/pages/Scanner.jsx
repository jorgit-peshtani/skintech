import { useState, useRef } from 'react';
import { Upload, Camera, FileText, Loader2, AlertCircle, CheckCircle2, X } from 'lucide-react';
import { scanAPI } from '../services/api';
import { useAuthStore } from '../store/authStore';
import toast from 'react-hot-toast';
import './Scanner.css';

const Scanner = () => {
    const [scanMode, setScanMode] = useState('upload'); // 'upload' or 'text'
    const [selectedFile, setSelectedFile] = useState(null);
    const [preview, setPreview] = useState(null);
    const [textInput, setTextInput] = useState('');
    const [isScanning, setIsScanning] = useState(false);
    const [scanResult, setScanResult] = useState(null);
    const [isDragging, setIsDragging] = useState(false);
    const fileInputRef = useRef(null);
    const { user } = useAuthStore();

    const handleFileSelect = (file) => {
        if (!file) return;

        if (!file.type.startsWith('image/')) {
            toast.error('Please select an image file');
            return;
        }

        setSelectedFile(file);
        const reader = new FileReader();
        reader.onloadend = () => setPreview(reader.result);
        reader.readAsDataURL(file);
    };

    const handleDragOver = (e) => {
        e.preventDefault();
        setIsDragging(true);
    };

    const handleDragLeave = () => setIsDragging(false);

    const handleDrop = (e) => {
        e.preventDefault();
        setIsDragging(false);
        const file = e.dataTransfer.files[0];
        handleFileSelect(file);
    };

    const handleUploadClick = () => fileInputRef.current?.click();

    const handleScanImage = async () => {
        if (!selectedFile) {
            toast.error('Please select an image first');
            return;
        }

        if (!user) {
            toast.error('Please login to scan products');
            return;
        }

        setIsScanning(true);
        setScanResult(null);

        try {
            const formData = new FormData();
            formData.append('image', selectedFile);

            const response = await scanAPI.uploadScan(formData);
            setScanResult(response.data);
            toast.success('Scan completed successfully!');
        } catch (error) {
            console.error('Scan error:', error);
            toast.error(error.response?.data?.error || 'Failed to scan product');
        } finally {
            setIsScanning(false);
        }
    };

    const handleTextAnalysis = async () => {
        if (!textInput.trim()) {
            toast.error('Please enter ingredients');
            return;
        }

        if (!user) {
            toast.error('Please login to analyze ingredients');
            return;
        }

        setIsScanning(true);
        setScanResult(null);

        try {
            const response = await scanAPI.analyzeText({ text: textInput });
            setScanResult(response.data);
            toast.success('Analysis completed!');
        } catch (error) {
            console.error('Analysis error:', error);
            toast.error(error.response?.data?.error || 'Failed to analyze ingredients');
        } finally {
            setIsScanning(false);
        }
    };

    const clearScan = () => {
        setSelectedFile(null);
        setPreview(null);
        setTextInput('');
        setScanResult(null);
    };

    const getSafetyColor = (rating) => {
        // EWG-style scoring: 1-2 (Excellent), 3-5 (Good), 6-7 (Moderate), 8-10 (Poor/High Hazard)
        const score = parseFloat(rating);
        if (score <= 3) return 'safety-excellent';
        if (score <= 5) return 'safety-good';
        if (score <= 7) return 'safety-moderate';
        return 'safety-poor';
    };

    return (
        <div className="scanner-page">
            <div className="container">
                {/* Header */}
                <div className="scanner-header">
                    <h1>AI-Powered Ingredient Scanner</h1>
                    <p className="scanner-subtitle">
                        Upload a product label or enter ingredients to get instant safety analysis
                    </p>
                </div>

                {/* Mode Switch */}
                <div className="scan-mode-switch">
                    <button
                        className={`mode-btn ${scanMode === 'upload' ? 'active' : ''}`}
                        onClick={() => setScanMode('upload')}
                    >
                        <Camera size={20} />
                        Upload Image
                    </button>
                    <button
                        className={`mode-btn ${scanMode === 'text' ? 'active' : ''}`}
                        onClick={() => setScanMode('text')}
                    >
                        <FileText size={20} />
                        Enter Text
                    </button>
                </div>

                <div className="scanner-content">
                    {/* Upload Mode */}
                    {scanMode === 'upload' && (
                        <div className="upload-section">
                            {!preview ? (
                                <div
                                    className={`drop-zone ${isDragging ? 'dragging' : ''}`}
                                    onDragOver={handleDragOver}
                                    onDragLeave={handleDragLeave}
                                    onDrop={handleDrop}
                                    onClick={handleUploadClick}
                                >
                                    <Upload size={48} className="upload-icon" />
                                    <h3>Drag & drop product image here</h3>
                                    <p>or click to browse</p>
                                    <input
                                        ref={fileInputRef}
                                        type="file"
                                        accept="image/*"
                                        onChange={(e) => handleFileSelect(e.target.files[0])}
                                        style={{ display: 'none' }}
                                    />
                                </div>
                            ) : (
                                <div className="preview-section">
                                    <button className="clear-btn" onClick={clearScan}>
                                        <X size={20} />
                                    </button>
                                    <img src={preview} alt="Preview" className="preview-image" />
                                    <button
                                        className="btn btn-primary scan-btn"
                                        onClick={handleScanImage}
                                        disabled={isScanning}
                                    >
                                        {isScanning ? (
                                            <>
                                                <Loader2 size={20} className="spinner" />
                                                Scanning...
                                            </>
                                        ) : (
                                            'Scan Product'
                                        )}
                                    </button>
                                </div>
                            )}
                        </div>
                    )}

                    {/* Text Mode */}
                    {scanMode === 'text' && (
                        <div className="text-section">
                            <div className="text-input-container">
                                <label className="form-label">Enter Ingredients (comma separated)</label>
                                <textarea
                                    className="ingredient-textarea"
                                    placeholder="Example: Aqua, Glycerin, Niacinamide, Hyaluronic Acid, Retinol..."
                                    value={textInput}
                                    onChange={(e) => setTextInput(e.target.value)}
                                    rows={8}
                                />
                            </div>
                            <button
                                className="btn btn-primary scan-btn"
                                onClick={handleTextAnalysis}
                                disabled={isScanning || !textInput.trim()}
                            >
                                {isScanning ? (
                                    <>
                                        <Loader2 size={20} className="spinner" />
                                        Analyzing...
                                    </>
                                ) : (
                                    'Analyze Ingredients'
                                )}
                            </button>
                        </div>
                    )}

                    {/* Results Section */}
                    {scanResult && (
                        <div className="results-section">
                            <h2>Analysis Results</h2>

                            {/* Overall Safety Score */}
                            <div className={`safety-card ${getSafetyColor(scanResult.overall_safety_score)}`}>
                                <div className="safety-score">
                                    <span className="score-value">{scanResult.overall_safety_score}</span>
                                    <span className="score-label">/10</span>
                                </div>
                                <div className="safety-info">
                                    <h3>Overall Safety Rating</h3>
                                    <p>{scanResult.safety_assessment}</p>
                                </div>
                            </div>

                            {(() => {
                                const ingredients = scanResult.identified_ingredients || scanResult.ingredients || [];
                                return (
                                    <div className="ingredients-results">
                                        <h3>Detected Ingredients ({ingredients.length})</h3>

                                        {ingredients.length > 0 && (
                                            <div className="ingredients-summary">
                                                <p><strong>Found:</strong> {ingredients.map(i => i.name).join(', ')}</p>
                                            </div>
                                        )}

                                        {ingredients.length > 0 ? (
                                            <div className="ingredient-list">
                                                {[...ingredients]
                                                    .sort((a, b) => (b.safety_rating || 0) - (a.safety_rating || 0))
                                                    .map((ingredient, index) => (
                                                        <div key={index} className="ingredient-item">
                                                            <div className="ingredient-header">
                                                                <h4>{ingredient.name}</h4>
                                                                <span className={`safety-badge ${getSafetyColor(ingredient.safety_rating || 5)}`}>
                                                                    Risk: {ingredient.safety_rating || 5}/10
                                                                </span>
                                                            </div>
                                                            {ingredient.description && (
                                                                <p className="ingredient-desc">{ingredient.description}</p>
                                                            )}
                                                            {ingredient.effects && Object.keys(ingredient.effects).length > 0 && (
                                                                <div className="effects">
                                                                    <strong>Effects:</strong>
                                                                    <ul>
                                                                        {Object.entries(ingredient.effects).map(([skinType, effect]) => (
                                                                            <li key={skinType}>
                                                                                <span className="skin-type">{skinType}:</span> {effect}
                                                                            </li>
                                                                        ))}
                                                                    </ul>
                                                                </div>
                                                            )}
                                                            {ingredient.warnings && ingredient.warnings.length > 0 && (
                                                                <div className="warnings">
                                                                    <AlertCircle size={16} />
                                                                    <span>{ingredient.warnings.join(', ')}</span>
                                                                </div>
                                                            )}
                                                        </div>
                                                    ))}
                                            </div>
                                        ) : (
                                            <p className="no-results">No ingredients detected. Please try again with a clearer image.</p>
                                        )}
                                    </div>
                                );
                            })()}

                            {/* Recommendations */}
                            {scanResult.recommendations && scanResult.recommendations.length > 0 && (
                                <div className="recommendations-box">
                                    <h3>
                                        <CheckCircle2 size={20} />
                                        Recommendations
                                    </h3>
                                    <ul>
                                        {scanResult.recommendations.map((rec, index) => (
                                            <li key={index}>{rec}</li>
                                        ))}
                                    </ul>
                                </div>
                            )}
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
};

export default Scanner;
