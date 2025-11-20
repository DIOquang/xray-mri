# 🚀 Deployment Guide

Hướng dẫn deploy Medical Image Classification API và Web Interface.

## 📋 Prerequisites

- Python 3.13+
- Virtual environment đã cài đặt
- Models đã được train (`.h5` files trong `models/`)

## 🔧 Local Deployment

### 1. Cài đặt Dependencies

```bash
# Activate virtual environment
source .venv/bin/activate  # macOS/Linux
# .venv\Scripts\activate   # Windows

# Install Flask dependencies
pip install flask flask-cors werkzeug
```

### 2. Start Flask Server

```bash
python app.py
```

Server sẽ chạy tại: `http://localhost:5000`

### 3. Open Web Interface

Mở trình duyệt và truy cập:
```
http://localhost:5000
```

### 4. Test API

```bash
# Basic health check
python test_api.py

# Test with images
python test_api.py data/chest_xray/test/NORMAL/image.jpg data/brain_mri/test/glioma/image.jpg
```

## 📡 API Endpoints

### GET /
Web interface (HTML)

### GET /api
API information

### GET /health
Health check
```json
{
  "status": "healthy",
  "models_loaded": {
    "xray": true,
    "mri": true
  }
}
```

### POST /predict/xray
Predict pneumonia from X-ray image

**Request**:
- Method: POST
- Content-Type: multipart/form-data
- Body: `file` (image file)

**Response**:
```json
{
  "prediction": "PNEUMONIA",
  "confidence": 94.5,
  "probabilities": {
    "NORMAL": 5.5,
    "PNEUMONIA": 94.5
  },
  "model": "DenseNet-121",
  "task": "pneumonia_detection"
}
```

### POST /predict/mri
Predict brain tumor type from MRI image

**Request**:
- Method: POST
- Content-Type: multipart/form-data
- Body: `file` (image file)

**Response**:
```json
{
  "prediction": "Glioma",
  "confidence": 98.3,
  "probabilities": {
    "Glioma": 98.3,
    "Meningioma": 1.2,
    "No Tumor": 0.3,
    "Pituitary": 0.2
  },
  "model": "DenseNet-121",
  "task": "brain_tumor_classification"
}
```

### GET /models/info
Get model information

## 🐳 Docker Deployment (Optional)

### 1. Create Dockerfile

```dockerfile
FROM python:3.13-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
```

### 2. Build & Run

```bash
docker build -t medical-ai-api .
docker run -p 5000:5000 medical-ai-api
```

## ☁️ Cloud Deployment

### AWS EC2

1. Launch EC2 instance (t2.medium recommended)
2. SSH vào instance
3. Clone repository
4. Install dependencies
5. Run với gunicorn:

```bash
pip install gunicorn
gunicorn -w 4 -b 0.0.0.0:5000 app:app
```

### Heroku

1. Create `Procfile`:
```
web: gunicorn app:app
```

2. Deploy:
```bash
heroku create medical-image-ai
git push heroku main
```

### Google Cloud Run

1. Create `Dockerfile` (as above)
2. Deploy:
```bash
gcloud run deploy medical-ai \
  --source . \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

## 🔒 Security Considerations

⚠️ **Important**: This is a demo application. For production:

1. **Add authentication**: JWT tokens, API keys
2. **Rate limiting**: Prevent abuse
3. **HTTPS**: Use SSL/TLS certificates
4. **Input validation**: Strict file type/size checks
5. **Error handling**: Don't expose internal errors
6. **Logging**: Track all predictions
7. **Model versioning**: Track which model version was used
8. **Compliance**: HIPAA, GDPR if handling real medical data

## 📊 Monitoring

### Health Check

```bash
curl http://localhost:5000/health
```

### Logs

Flask logs requests automatically. For production, use:
- **ELK Stack** (Elasticsearch, Logstash, Kibana)
- **Prometheus + Grafana**
- **AWS CloudWatch**

## 🚦 Performance Optimization

### 1. Model Optimization
```python
# Convert to TensorFlow Lite
import tensorflow as tf

converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]
tflite_model = converter.convert()
```

### 2. Caching
```python
from flask_caching import Cache

cache = Cache(app, config={'CACHE_TYPE': 'simple'})

@cache.memoize(timeout=300)
def predict_cached(image_hash):
    # Prediction logic
    pass
```

### 3. Load Balancing
Use nginx để distribute requests:

```nginx
upstream medical_ai {
    server 127.0.0.1:5000;
    server 127.0.0.1:5001;
    server 127.0.0.1:5002;
}
```

## 📱 Mobile App Integration

API có thể được tích hợp với:
- **React Native**
- **Flutter**
- **Swift (iOS)**
- **Kotlin (Android)**

Example (React Native):
```javascript
const FormData = require('form-data');

async function predictXray(imageUri) {
  const formData = new FormData();
  formData.append('file', {
    uri: imageUri,
    type: 'image/jpeg',
    name: 'xray.jpg',
  });
  
  const response = await fetch('http://api.example.com/predict/xray', {
    method: 'POST',
    body: formData,
  });
  
  return await response.json();
}
```

## 🧪 Testing

### Unit Tests
```python
import pytest

def test_health_endpoint():
    response = app.test_client().get('/health')
    assert response.status_code == 200
```

### Load Testing
```bash
# Install Apache Bench
apt-get install apache2-utils

# Test 1000 requests, 10 concurrent
ab -n 1000 -c 10 http://localhost:5000/health
```

## 📄 License & Disclaimer

⚠️ **Medical Disclaimer**: 
This application is for **research and educational purposes only**. It is **NOT** intended for clinical use or medical diagnosis. Always consult qualified healthcare professionals for medical advice.

## 🆘 Troubleshooting

### Model fails to load
```bash
# Check model files exist
ls -lh models/*.h5

# Verify TensorFlow version
python -c "import tensorflow as tf; print(tf.__version__)"
```

### Out of memory
```python
# Reduce batch size or use model quantization
# Set memory growth for GPU
gpus = tf.config.list_physical_devices('GPU')
if gpus:
    tf.config.experimental.set_memory_growth(gpus[0], True)
```

### Slow predictions
- Use GPU if available
- Batch multiple predictions
- Use TensorFlow Lite
- Cache frequent predictions

## 📞 Support

- GitHub Issues: [github.com/DIOquang/xray-mri/issues](https://github.com/DIOquang/xray-mri/issues)
- Email: [Your email]

---

**Last Updated**: November 20, 2025
