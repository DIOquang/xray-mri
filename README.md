# X-Ray & MRI Medical Image Classification

Dự án Deep Learning phân loại hình ảnh y tế sử dụng **DenseNet-121** với Transfer Learning để:
- 🫁 **Phân loại X-ray ngực**: Phát hiện viêm phổi (Pneumonia vs Normal)
- 🧠 **Phân loại MRI não**: Phân loại u não (Glioma, Meningioma, Pituitary, No Tumor)

## 📊 Kết quả

### Model X-ray Pneumonia Classification
- **Test Accuracy**: 84.46%
- **Precision (PNEUMONIA)**: 94%
- **Recall (PNEUMONIA)**: 81%
- **F1-Score (Weighted)**: 85%
- **Training**: 2 epochs (Phase 1)

### Model Brain MRI Classification ⭐
- **Test Accuracy**: **97.73%** 🔥
- **Precision (Weighted)**: 98%
- **Recall (Weighted)**: 98%
- **F1-Score (Weighted)**: 98%
- **Training**: Phase 1 (20 epochs) + Phase 2 (20 epochs)
- **Classes**: 4 loại (Glioma, Meningioma, Pituitary, No Tumor)

## 🏗️ Kiến trúc

### DenseNet-121 với 2-Phase Training

**Phase 1: Transfer Learning**
- Freeze toàn bộ DenseNet-121 backbone (pretrained trên ImageNet)
- Train chỉ classification head
- Learning rate: 1e-4
- Epochs: 15

**Phase 2: Fine-tuning** (optional)
- Unfreeze top 50% layers của backbone
- Train với learning rate thấp hơn: 1e-5
- Epochs: 15

### Model Architecture
```
Input (224x224x3)
    ↓
DenseNet-121 Backbone (ImageNet weights)
    ↓
GlobalAveragePooling2D
    ↓
Dropout(0.5)
    ↓
Dense(512, relu)
    ↓
Dropout(0.5)
    ↓
Dense(num_classes, softmax)
```

## 📁 Cấu trúc thư mục

```
xray-mri/
├── data/
│   ├── chest_xray/          # Dataset X-ray ngực
│   │   ├── train/           # 5216 ảnh
│   │   ├── val/             # 16 ảnh
│   │   └── test/            # 624 ảnh
│   └── brain_mri/           # Dataset MRI não
│       ├── train/           # ~4916 ảnh
│       ├── val/             # ~1053 ảnh
│       └── test/            # ~1054 ảnh
├── models/                  # Saved models (.h5, .keras)
├── notebooks/
│   ├── 01_pneumonia_classification_densenet.ipynb
│   └── 02_brain_mri_classification_densenet.ipynb
├── src/
│   ├── train_pneumonia_model.py
│   └── train_brain_mri_densenet.py
├── scripts/
│   └── prepare_brain_mri_dataset.py
└── requirements.txt
```

## 🚀 Cài đặt

### 1. Clone repository
```bash
git clone https://github.com/DIOquang/xray-mri.git
cd xray-mri
```

### 2. Tạo virtual environment
```bash
python -m venv .venv
source .venv/bin/activate  # MacOS/Linux
# .venv\Scripts\activate   # Windows
```

### 3. Cài đặt dependencies
```bash
pip install -r requirements.txt
```

### 4. Download datasets

**X-ray Dataset** (Kaggle):
```bash
kaggle datasets download -d paultimothymooney/chest-xray-pneumonia
unzip chest-xray-pneumonia.zip -d data/
```

**Brain MRI Dataset** (Kaggle):
```bash
kaggle datasets download -d masoudnickparvar/brain-tumor-mri-dataset
unzip brain-tumor-mri-dataset.zip -d data/brain_mri_raw/
python scripts/prepare_brain_mri_dataset.py
```

## 💻 Sử dụng

### Training với Jupyter Notebooks

#### X-ray Pneumonia Classification
```bash
jupyter notebook notebooks/01_pneumonia_classification_densenet.ipynb
```

#### Brain MRI Classification
```bash
jupyter notebook notebooks/02_brain_mri_classification_densenet.ipynb
```

### Training với Python Scripts

#### X-ray Model
```bash
python src/train_pneumonia_model.py
```

#### MRI Model
```bash
python src/train_brain_mri_densenet.py
```

## 📈 Data Augmentation

Training sử dụng các kỹ thuật augmentation:
- ✅ Rotation: ±20°
- ✅ Width/Height Shift: 10%
- ✅ Zoom: ±20%
- ✅ Horizontal Flip
- ✅ Rescaling: 1/255

## 🎯 Callbacks & Training Strategy

- **ModelCheckpoint**: 
  - Lưu best model theo `val_accuracy`
  - Lưu checkpoint mỗi epoch
- **EarlyStopping**: 
  - Patience = 5 epochs
  - Monitor `val_loss`
  - Restore best weights
- **Class Weights**: 
  - Tự động tính toán để xử lý imbalanced data
- **AccuracyThreshold** (custom):
  - Dừng training khi đạt ngưỡng accuracy mong muốn

## 📊 Evaluation Metrics

Model được đánh giá với:
- ✅ Accuracy & Loss curves
- ✅ Confusion Matrix
- ✅ Classification Report (Precision, Recall, F1-Score)
- ✅ Test Set Performance
- 🔜 Grad-CAM Visualization (upcoming)

## 🛠️ Tech Stack

- **Framework**: TensorFlow 2.20.0 / Keras
- **Architecture**: DenseNet-121
- **Data Processing**: ImageDataGenerator
- **Visualization**: Matplotlib, Seaborn
- **Metrics**: scikit-learn
- **Environment**: Python 3.13

## 📦 Requirements

```
tensorflow>=2.20.0
keras>=3.12.0
numpy>=2.3.5
pandas>=2.3.3
matplotlib>=3.10.7
seaborn>=0.13.2
scikit-learn>=1.7.2
pillow>=12.0.0
kaggle>=1.7.4
```

## 🎓 Model Training Results

### X-ray Pneumonia Model

**Training History** (Phase 1 - 2 epochs):
- Epoch 1: val_accuracy = 75.00%
- Epoch 2: val_accuracy = 87.50% ✅ (stopped at threshold)

**Test Set Performance**:
```
              precision    recall  f1-score   support

      NORMAL       0.74      0.91      0.81       234
   PNEUMONIA       0.94      0.81      0.87       390

    accuracy                           0.84       624
   macro avg       0.84      0.86      0.84       624
weighted avg       0.86      0.84      0.85       624
```

**Confusion Matrix**:
- True Negatives (NORMAL): 213
- False Positives: 21
- False Negatives: 76
- True Positives (PNEUMONIA): 314

---

### Brain MRI Model 🏆

**Training History**:
- **Phase 1** (20 epochs): val_accuracy từ 62.26% → 86.60%
- **Phase 2** (20 epochs): val_accuracy từ 91.92% → **97.15%**
- **Best epoch**: 39 với val_accuracy = 97.15%

**Test Set Performance** (97.73% accuracy):
```
              precision    recall  f1-score   support

      glioma       0.98      0.97      0.98       244
  meningioma       0.98      0.95      0.96       248
     notumor       0.99      0.99      0.99       300
   pituitary       0.96      1.00      0.98       265

    accuracy                           0.98      1057
   macro avg       0.98      0.98      0.98      1057
weighted avg       0.98      0.98      0.98      1057
```

**Confusion Matrix Highlights**:
- Glioma: 237/244 correct (97.13%)
- Meningioma: 236/248 correct (95.16%)
- No Tumor: 297/300 correct (99.00%)
- Pituitary: 265/265 correct (100%!) 🎯

**Visualizations Generated**:
- ✅ Training history curves (accuracy & loss)
- ✅ Confusion matrix heatmap
- ✅ Grad-CAM visualizations (4 samples)

## 🔬 Future Work

- [x] Complete Brain MRI model training ✅
- [x] Implement Grad-CAM visualization ✅
- [ ] Add model explainability features (LIME, SHAP)
- [ ] Deploy models with Flask/FastAPI
- [ ] Create web interface for predictions
- [ ] Experiment with other architectures (ResNet-50, EfficientNet)
- [ ] Ensemble methods
- [ ] Model quantization for mobile deployment
- [ ] Real-time inference optimization

## 📝 License

This project is for educational purposes.

## 👤 Author

- GitHub: [@DIOquang](https://github.com/DIOquang)
- Repository: [xray-mri](https://github.com/DIOquang/xray-mri)

## 🙏 Acknowledgments

- **Datasets**:
  - [Chest X-Ray Images (Pneumonia)](https://www.kaggle.com/datasets/paultimothymooney/chest-xray-pneumonia) by Paul Mooney
  - [Brain Tumor MRI Dataset](https://www.kaggle.com/datasets/masoudnickparvar/brain-tumor-mri-dataset) by Masoud Nickparvar
- **Pre-trained Model**: DenseNet-121 from Keras Applications

---

⭐ Nếu project này hữu ích, hãy cho một star trên GitHub!
