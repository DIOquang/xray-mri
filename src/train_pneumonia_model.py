"""
Script huấn luyện mô hình DenseNet-121 để phát hiện viêm phổi từ ảnh X-ray
"""

import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.applications import DenseNet121
from tensorflow.keras.layers import Dense, GlobalAveragePooling2D, Dropout
from tensorflow.keras.models import Model
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint
import numpy as np
import matplotlib.pyplot as plt
import os
from sklearn.utils.class_weight import compute_class_weight
from sklearn.metrics import classification_report, confusion_matrix
import seaborn as sns

print("=" * 80)
print("CHƯƠNG TRÌNH HUẤN LUYỆN MÔ HÌNH PHÁT HIỆN VIÊM PHỔI")
print("=" * 80)
print(f"TensorFlow Version: {tf.__version__}")
print(f"Số GPU khả dụng: {len(tf.config.list_physical_devices('GPU'))}")
print("=" * 80)

# ============================================================================
# BƯỚC 1: CẤU HÌNH ĐƯỜNG DẪN VÀ THAM SỐ
# ============================================================================
print("\n[1/8] Cấu hình đường dẫn và tham số...")

# Xác định đường dẫn tuyệt đối tới thư mục dự án và dữ liệu để tránh lỗi khi thay đổi CWD
PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
DATA_ROOT = os.path.join(PROJECT_ROOT, 'data', 'chest_xray')
TRAIN_PATH = os.path.join(DATA_ROOT, 'train')
VAL_PATH = os.path.join(DATA_ROOT, 'val')
TEST_PATH = os.path.join(DATA_ROOT, 'test')

# Kiểm tra sự tồn tại của thư mục dữ liệu
for p, name in [(DATA_ROOT, 'DATA_ROOT'), (TRAIN_PATH, 'TRAIN_PATH'), (VAL_PATH, 'VAL_PATH'), (TEST_PATH, 'TEST_PATH')]:
    if not os.path.isdir(p):
        raise FileNotFoundError(f"Không tìm thấy {name}: {p}")

IMAGE_SIZE = (224, 224)
BATCH_SIZE = 32
EPOCHS_PHASE_1 = 10
EPOCHS_PHASE_2 = 10

print(f"   ✓ PROJECT_ROOT: {PROJECT_ROOT}")
print(f"   ✓ DATA_ROOT: {DATA_ROOT}")
print(f"   ✓ Kích thước ảnh: {IMAGE_SIZE}")
print(f"   ✓ Batch size: {BATCH_SIZE}")
print(f"   ✓ Epochs giai đoạn 1: {EPOCHS_PHASE_1}")
print(f"   ✓ Epochs giai đoạn 2: {EPOCHS_PHASE_2}")

# ============================================================================
# BƯỚC 2: TẠO DATA GENERATORS
# ============================================================================
print("\n[2/8] Tạo data generators...")

train_datagen = ImageDataGenerator(
    rescale=1./255,
    rotation_range=20,
    width_shift_range=0.2,
    height_shift_range=0.2,
    shear_range=0.2,
    zoom_range=0.2,
    horizontal_flip=True,
    fill_mode='nearest'
)

val_test_datagen = ImageDataGenerator(rescale=1./255)

train_generator = train_datagen.flow_from_directory(
    TRAIN_PATH,
    target_size=IMAGE_SIZE,
    batch_size=BATCH_SIZE,
    class_mode='binary',
    shuffle=True
)

validation_generator = val_test_datagen.flow_from_directory(
    VAL_PATH,
    target_size=IMAGE_SIZE,
    batch_size=BATCH_SIZE,
    class_mode='binary',
    shuffle=False
)

test_generator = val_test_datagen.flow_from_directory(
    TEST_PATH,
    target_size=IMAGE_SIZE,
    batch_size=BATCH_SIZE,
    class_mode='binary',
    shuffle=False
)

print(f"   ✓ Tổng số ảnh training: {train_generator.samples}")
print(f"   ✓ Tổng số ảnh validation: {validation_generator.samples}")
print(f"   ✓ Tổng số ảnh test: {test_generator.samples}")
print(f"   ✓ Các lớp: {train_generator.class_indices}")

# ============================================================================
# BƯỚC 3: TÍNH TOÁN CLASS WEIGHTS
# ============================================================================
print("\n[3/8] Tính toán class weights để xử lý mất cân bằng dữ liệu...")

class_weights = compute_class_weight(
    'balanced',
    classes=np.unique(train_generator.classes),
    y=train_generator.classes
)

train_class_weights = dict(enumerate(class_weights))
print(f"   ✓ Class weights: {train_class_weights}")

# ============================================================================
# BƯỚC 4: XÂY DỰNG MÔ HÌNH DENSENET-121
# ============================================================================
print("\n[4/8] Xây dựng mô hình DenseNet-121...")

# Tải base model
base_model = DenseNet121(weights='imagenet', include_top=False, input_shape=(224, 224, 3))
base_model.trainable = False

# Xây dựng các lớp phân loại
x = base_model.output
x = GlobalAveragePooling2D()(x)
x = Dropout(0.5)(x)
x = Dense(256, activation='relu')(x)
x = Dropout(0.5)(x)
predictions = Dense(1, activation='sigmoid')(x)

model = Model(inputs=base_model.input, outputs=predictions)

# Compile mô hình
model.compile(
    optimizer=Adam(learning_rate=1e-4),
    loss='binary_crossentropy',
    metrics=['accuracy']
)

print(f"   ✓ Tổng số tham số: {model.count_params():,}")
print(f"   ✓ Số tham số trainable: {sum([tf.size(w).numpy() for w in model.trainable_weights]):,}")

# ============================================================================
# BƯỚC 5: HUẤN LUYỆN GIAI ĐOẠN 1 - TRANSFER LEARNING
# ============================================================================
print("\n[5/8] Bắt đầu huấn luyện giai đoạn 1 (Transfer Learning)...")
print("   Chỉ huấn luyện các lớp phân loại mới, giữ nguyên base model")

callbacks_phase1 = [
    EarlyStopping(monitor='val_loss', patience=5, restore_best_weights=True, verbose=1)
]

history_phase1 = model.fit(
    train_generator,
    epochs=EPOCHS_PHASE_1,
    validation_data=validation_generator,
    class_weight=train_class_weights,
    callbacks=callbacks_phase1,
    verbose=1
)

print("   ✓ Hoàn thành giai đoạn 1")

# ============================================================================
# BƯỚC 6: HUẤN LUYỆN GIAI ĐOẠN 2 - FINE-TUNING
# ============================================================================
print("\n[6/8] Bắt đầu huấn luyện giai đoạn 2 (Fine-tuning)...")

# Mở băng một phần base model
base_model.trainable = True
fine_tune_at = len(base_model.layers) // 2

for layer in base_model.layers[:fine_tune_at]:
    layer.trainable = False

print(f"   Mở băng {len(base_model.layers) - fine_tune_at} lớp cuối")

# Compile lại với learning rate thấp hơn
model.compile(
    optimizer=Adam(learning_rate=1e-5),
    loss='binary_crossentropy',
    metrics=['accuracy']
)

print(f"   ✓ Số tham số trainable sau khi mở băng: {sum([tf.size(w).numpy() for w in model.trainable_weights]):,}")

callbacks_phase2 = [
    EarlyStopping(monitor='val_loss', patience=5, restore_best_weights=True, verbose=1),
    ModelCheckpoint('../models/pneumonia_densenet121_best.h5', 
                    monitor='val_accuracy', 
                    save_best_only=True, 
                    verbose=1)
]

total_epochs = EPOCHS_PHASE_1 + EPOCHS_PHASE_2
history_phase2 = model.fit(
    train_generator,
    epochs=total_epochs,
    initial_epoch=len(history_phase1.history['loss']),
    validation_data=validation_generator,
    class_weight=train_class_weights,
    callbacks=callbacks_phase2,
    verbose=1
)

print("   ✓ Hoàn thành giai đoạn 2")

# ============================================================================
# BƯỚC 7: ĐÁNH GIÁ MÔ HÌNH
# ============================================================================
print("\n[7/8] Đánh giá mô hình trên tập test...")

# Đánh giá
test_loss, test_accuracy = model.evaluate(test_generator, verbose=0)
print(f"   ✓ Test Loss: {test_loss:.4f}")
print(f"   ✓ Test Accuracy: {test_accuracy:.4f}")

# Dự đoán
print("\n   Đang tạo dự đoán trên tập test...")
Y_pred = model.predict(test_generator, verbose=0)
y_pred = (Y_pred > 0.5).astype(int).flatten()

# Ma trận nhầm lẫn
print("\n   Ma trận nhầm lẫn:")
cm = confusion_matrix(test_generator.classes, y_pred)
target_names = list(test_generator.class_indices.keys())
print(f"\n   {'':15} {'Predicted ' + target_names[0]:20} {'Predicted ' + target_names[1]:20}")
print(f"   {'Actual ' + target_names[0]:15} {cm[0][0]:20} {cm[0][1]:20}")
print(f"   {'Actual ' + target_names[1]:15} {cm[1][0]:20} {cm[1][1]:20}")

# Báo cáo phân loại
print("\n   Báo cáo phân loại chi tiết:")
print(classification_report(test_generator.classes, y_pred, target_names=target_names))

# Vẽ biểu đồ
print("\n   Tạo biểu đồ kết quả...")

# Kết hợp history từ 2 giai đoạn
acc = history_phase1.history['accuracy'] + history_phase2.history['accuracy']
val_acc = history_phase1.history['val_accuracy'] + history_phase2.history['val_accuracy']
loss = history_phase1.history['loss'] + history_phase2.history['loss']
val_loss = history_phase1.history['val_loss'] + history_phase2.history['val_loss']

plt.figure(figsize=(14, 5))

# Biểu đồ accuracy
plt.subplot(1, 2, 1)
plt.plot(acc, label='Training Accuracy')
plt.plot(val_acc, label='Validation Accuracy')
plt.axvline(x=EPOCHS_PHASE_1 - 1, color='r', linestyle='--', label='Start Fine-Tuning')
plt.legend(loc='lower right')
plt.title('Training and Validation Accuracy')
plt.xlabel('Epoch')
plt.ylabel('Accuracy')
plt.grid(True, alpha=0.3)

# Biểu đồ loss
plt.subplot(1, 2, 2)
plt.plot(loss, label='Training Loss')
plt.plot(val_loss, label='Validation Loss')
plt.axvline(x=EPOCHS_PHASE_1 - 1, color='r', linestyle='--', label='Start Fine-Tuning')
plt.legend(loc='upper right')
plt.title('Training and Validation Loss')
plt.xlabel('Epoch')
plt.ylabel('Loss')
plt.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('../models/training_history.png', dpi=300, bbox_inches='tight')
print("   ✓ Biểu đồ đã được lưu tại: ../models/training_history.png")

# Vẽ ma trận nhầm lẫn
plt.figure(figsize=(8, 6))
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues', 
            xticklabels=target_names, 
            yticklabels=target_names,
            cbar_kws={'label': 'Count'})
plt.ylabel('Actual')
plt.xlabel('Predicted')
plt.title('Confusion Matrix - Pneumonia Detection')
plt.tight_layout()
plt.savefig('../models/confusion_matrix.png', dpi=300, bbox_inches='tight')
print("   ✓ Ma trận nhầm lẫn đã được lưu tại: ../models/confusion_matrix.png")

# ============================================================================
# BƯỚC 8: LƯU MÔ HÌNH
# ============================================================================
print("\n[8/8] Lưu mô hình cuối cùng...")

MODEL_SAVE_PATH = '../models/pneumonia_densenet121_final.h5'
model.save(MODEL_SAVE_PATH)
print(f"   ✓ Mô hình đã được lưu tại: {MODEL_SAVE_PATH}")

# ============================================================================
# HOÀN THÀNH
# ============================================================================
print("\n" + "=" * 80)
print("HOÀN THÀNH QUAY TRÌNH HUẤN LUYỆN!")
print("=" * 80)
print(f"\nKết quả cuối cùng:")
print(f"   • Test Accuracy: {test_accuracy*100:.2f}%")
print(f"   • Test Loss: {test_loss:.4f}")
print(f"\nCác file đã được lưu:")
print(f"   • Mô hình tốt nhất: ../models/pneumonia_densenet121_best.h5")
print(f"   • Mô hình cuối cùng: ../models/pneumonia_densenet121_final.h5")
print(f"   • Biểu đồ huấn luyện: ../models/training_history.png")
print(f"   • Ma trận nhầm lẫn: ../models/confusion_matrix.png")
print("=" * 80)
