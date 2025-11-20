"""
Flask API for Medical Image Classification
Supports both X-ray Pneumonia and Brain MRI Tumor Classification
"""

from flask import Flask, request, jsonify, render_template
from flask_cors import CORS
from werkzeug.utils import secure_filename
import tensorflow as tf
import numpy as np
from PIL import Image
import os
import io

app = Flask(__name__)
CORS(app)

# Configuration
UPLOAD_FOLDER = 'uploads'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg'}
MAX_FILE_SIZE = 16 * 1024 * 1024  # 16MB

os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = MAX_FILE_SIZE

# Load models
XRAY_MODEL_PATH = 'models/best_model_phase1.h5'
MRI_MODEL_PATH = 'models/brain_mri_densenet_transfer_phase2_best.h5'

print("Loading models...")
try:
    xray_model = tf.keras.models.load_model(XRAY_MODEL_PATH)
    print("✓ X-ray model loaded")
except Exception as e:
    print(f"✗ Failed to load X-ray model: {e}")
    xray_model = None

try:
    mri_model = tf.keras.models.load_model(MRI_MODEL_PATH)
    print("✓ MRI model loaded")
except Exception as e:
    print(f"✗ Failed to load MRI model: {e}")
    mri_model = None

# Class labels
XRAY_CLASSES = {0: 'NORMAL', 1: 'PNEUMONIA'}
MRI_CLASSES = {0: 'Glioma', 1: 'Meningioma', 2: 'No Tumor', 3: 'Pituitary'}


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


def preprocess_image(image_bytes, target_size=(224, 224)):
    """Preprocess image for model prediction"""
    img = Image.open(io.BytesIO(image_bytes)).convert('RGB')
    img = img.resize(target_size)
    img_array = np.array(img) / 255.0
    img_array = np.expand_dims(img_array, axis=0)
    return img_array


@app.route('/')
def index():
    """Serve the web interface"""
    return render_template('index.html')


@app.route('/api')
def api_info():
    return jsonify({
        'status': 'online',
        'version': '1.0.0',
        'models': {
            'xray': 'available' if xray_model else 'unavailable',
            'mri': 'available' if mri_model else 'unavailable'
        },
        'endpoints': {
            'health': '/health',
            'predict_xray': '/predict/xray',
            'predict_mri': '/predict/mri'
        }
    })


@app.route('/health')
def health():
    return jsonify({
        'status': 'healthy',
        'models_loaded': {
            'xray': xray_model is not None,
            'mri': mri_model is not None
        }
    })


@app.route('/predict/xray', methods=['POST'])
def predict_xray():
    """Predict pneumonia from chest X-ray image"""
    if xray_model is None:
        return jsonify({'error': 'X-ray model not loaded'}), 503
    
    if 'file' not in request.files:
        return jsonify({'error': 'No file provided'}), 400
    
    file = request.files['file']
    
    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400
    
    if not allowed_file(file.filename):
        return jsonify({'error': 'Invalid file type. Allowed: png, jpg, jpeg'}), 400
    
    try:
        # Read and preprocess image
        image_bytes = file.read()
        img_array = preprocess_image(image_bytes)
        
        # Make prediction
        prediction = xray_model.predict(img_array, verbose=0)
        predicted_class = int(prediction[0][0] > 0.5)
        confidence = float(prediction[0][0] if predicted_class == 1 else 1 - prediction[0][0])
        
        result = {
            'prediction': XRAY_CLASSES[predicted_class],
            'confidence': round(confidence * 100, 2),
            'probabilities': {
                'NORMAL': round((1 - float(prediction[0][0])) * 100, 2),
                'PNEUMONIA': round(float(prediction[0][0]) * 100, 2)
            },
            'model': 'DenseNet-121',
            'task': 'pneumonia_detection'
        }
        
        return jsonify(result)
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/predict/mri', methods=['POST'])
def predict_mri():
    """Predict brain tumor type from MRI image"""
    if mri_model is None:
        return jsonify({'error': 'MRI model not loaded'}), 503
    
    if 'file' not in request.files:
        return jsonify({'error': 'No file provided'}), 400
    
    file = request.files['file']
    
    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400
    
    if not allowed_file(file.filename):
        return jsonify({'error': 'Invalid file type. Allowed: png, jpg, jpeg'}), 400
    
    try:
        # Read and preprocess image
        image_bytes = file.read()
        img_array = preprocess_image(image_bytes)
        
        # Make prediction
        prediction = mri_model.predict(img_array, verbose=0)
        predicted_class = int(np.argmax(prediction[0]))
        confidence = float(np.max(prediction[0]))
        
        probabilities = {
            MRI_CLASSES[i]: round(float(prediction[0][i]) * 100, 2)
            for i in range(len(MRI_CLASSES))
        }
        
        result = {
            'prediction': MRI_CLASSES[predicted_class],
            'confidence': round(confidence * 100, 2),
            'probabilities': probabilities,
            'model': 'DenseNet-121',
            'task': 'brain_tumor_classification'
        }
        
        return jsonify(result)
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/models/info')
def models_info():
    """Get information about loaded models"""
    info = {
        'xray_model': {
            'available': xray_model is not None,
            'path': XRAY_MODEL_PATH,
            'classes': list(XRAY_CLASSES.values()),
            'accuracy': '84.46%',
            'architecture': 'DenseNet-121'
        },
        'mri_model': {
            'available': mri_model is not None,
            'path': MRI_MODEL_PATH,
            'classes': list(MRI_CLASSES.values()),
            'accuracy': '97.73%',
            'architecture': 'DenseNet-121'
        }
    }
    return jsonify(info)


if __name__ == '__main__':
    print("\n" + "="*60)
    print("Medical Image Classification API")
    print("="*60)
    print(f"X-ray Model: {'✓ Loaded' if xray_model else '✗ Not loaded'}")
    print(f"MRI Model: {'✓ Loaded' if mri_model else '✗ Not loaded'}")
    print("="*60)
    print("\nEndpoints:")
    print("  GET  /              - API info")
    print("  GET  /health        - Health check")
    print("  POST /predict/xray  - Predict pneumonia")
    print("  POST /predict/mri   - Predict brain tumor")
    print("  GET  /models/info   - Model information")
    print("\nStarting server...")
    print("="*60 + "\n")
    
    app.run(debug=True, host='0.0.0.0', port=5000)
