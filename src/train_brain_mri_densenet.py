"""
Huấn luyện mô hình DenseNet-121 cho bài toán phân loại u não (MRI) 4 lớp
- Tạo generators cho train/val/test
- Transfer Learning (phase 1) + Fine-tuning (phase 2)
- Tự động lưu checkpoints, best model, final model
- Đánh giá: accuracy/loss, confusion matrix, classification report
- Trực quan: biểu đồ lịch sử huấn luyện, Grad-CAM (một vài ảnh mẫu)

Yêu cầu dữ liệu:
Đặt dữ liệu tại: data/brain_mri/
Cấu trúc thư mục (ví dụ):
    data/brain_mri/
        train/
            glioma/
            meningioma/
            pituitary/
            no_tumor/
        val/
            glioma/
            meningioma/
            pituitary/
            no_tumor/
        test/
            glioma/
            meningioma/
            pituitary/
            no_tumor/

Lưu ý: Tên lớp có thể khác tuỳ dataset. Script sẽ tự động đọc lớp từ thư mục.
"""

import os
import sys
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.applications import DenseNet121
from tensorflow.keras.layers import Dense, GlobalAveragePooling2D, Dropout
from tensorflow.keras.models import Model, load_model
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint

from sklearn.utils.class_weight import compute_class_weight
from sklearn.metrics import classification_report, confusion_matrix

plt.rcParams.update({"figure.max_open_warning": 0})

print("=" * 80)
print("CHƯƠNG TRÌNH HUẤN LUYỆN MÔ HÌNH MRI - DenseNet121 (4 lớp)")
print("=" * 80)
print(f"TensorFlow Version: {tf.__version__}")
print(f"Số GPU khả dụng: {len(tf.config.list_physical_devices('GPU'))}")
print("=" * 80)

# -----------------------------------------------------------------------------
# Cấu hình đường dẫn
# -----------------------------------------------------------------------------
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.abspath(os.path.join(SCRIPT_DIR, '..'))
DATA_ROOT = os.path.join(PROJECT_ROOT, 'data', 'brain_mri')
TRAIN_PATH = os.path.join(DATA_ROOT, 'train')
VAL_PATH = os.path.join(DATA_ROOT, 'val')
TEST_PATH = os.path.join(DATA_ROOT, 'test')
MODELS_DIR = os.path.join(PROJECT_ROOT, 'models')
os.makedirs(MODELS_DIR, exist_ok=True)

REQUIRED_DIRS = [DATA_ROOT, TRAIN_PATH, VAL_PATH, TEST_PATH]
missing = [p for p in REQUIRED_DIRS if not os.path.isdir(p)]
if missing:
    print("\n[ERROR] Thiếu thư mục dữ liệu sau:")
    for p in missing:
        print(f"  - {p}")
    print("\nHãy tải bộ dữ liệu Brain Tumor MRI (Kaggle) và giải nén về data/brain_mri/ đúng cấu trúc.")
    sys.exit(1)

# -----------------------------------------------------------------------------
# Tham số huấn luyện
# -----------------------------------------------------------------------------
IMAGE_SIZE = (224, 224)
BATCH_SIZE = 32
EPOCHS_PHASE_1 = 20
EPOCHS_PHASE_2 = 20

# -----------------------------------------------------------------------------
# Tạo generators
# -----------------------------------------------------------------------------
print("\n[1/7] Tạo ImageDataGenerators...")
train_datagen = ImageDataGenerator(
    rescale=1.0/255,
    rotation_range=20,
    width_shift_range=0.1,
    height_shift_range=0.1,
    zoom_range=0.2,
    horizontal_flip=True,
    fill_mode='nearest'
)
val_test_datagen = ImageDataGenerator(rescale=1.0/255)

train_generator = train_datagen.flow_from_directory(
    TRAIN_PATH,
    target_size=IMAGE_SIZE,
    batch_size=BATCH_SIZE,
    class_mode='categorical',
    shuffle=True
)
validation_generator = val_test_datagen.flow_from_directory(
    VAL_PATH,
    target_size=IMAGE_SIZE,
    batch_size=BATCH_SIZE,
    class_mode='categorical',
    shuffle=False
)
test_generator = val_test_datagen.flow_from_directory(
    TEST_PATH,
    target_size=IMAGE_SIZE,
    batch_size=BATCH_SIZE,
    class_mode='categorical',
    shuffle=False
)

num_classes = train_generator.num_classes
class_indices = train_generator.class_indices
idx_to_class = {v: k for k, v in class_indices.items()}
print(f"   ✓ Số lớp: {num_classes}")
print(f"   ✓ class_indices: {class_indices}")
print(f"   ✓ train/val/test: {train_generator.samples}/{validation_generator.samples}/{test_generator.samples}")

# -----------------------------------------------------------------------------
# Class weights
# -----------------------------------------------------------------------------
print("\n[2/7] Tính class weights...")
classes_unique = np.unique(train_generator.classes)
class_weights_arr = compute_class_weight(
    class_weight='balanced',
    classes=classes_unique,
    y=train_generator.classes
)
train_class_weights = {int(k): float(v) for k, v in zip(classes_unique, class_weights_arr)}
print(f"   ✓ class_weights: {train_class_weights}")

# -----------------------------------------------------------------------------
# Xây dựng mô hình
# -----------------------------------------------------------------------------
print("\n[3/7] Xây dựng mô hình DenseNet121...")
base_model = DenseNet121(weights='imagenet', include_top=False, input_shape=(IMAGE_SIZE[0], IMAGE_SIZE[1], 3))
base_model.trainable = False
x = base_model.output
x = GlobalAveragePooling2D()(x)
x = Dropout(0.5)(x)
x = Dense(512, activation='relu')(x)
x = Dropout(0.5)(x)
outputs = Dense(num_classes, activation='softmax')(x)
model = Model(inputs=base_model.input, outputs=outputs)

model.compile(optimizer=Adam(learning_rate=1e-4),
              loss='categorical_crossentropy',
              metrics=['accuracy'])

print(f"   ✓ Tổng số tham số: {model.count_params():,}")

# -----------------------------------------------------------------------------
# Huấn luyện Phase 1
# -----------------------------------------------------------------------------
print("\n[4/7] Huấn luyện Phase 1 (Transfer Learning)...")
ckpt_phase1_best = os.path.join(MODELS_DIR, 'brain_mri_densenet_transfer_phase1_best.h5')
ckpt_phase1_each = os.path.join(MODELS_DIR, 'brain_mri_transfer_phase1_epoch_{epoch:02d}_valacc_{val_accuracy:.4f}.h5')
callbacks_phase1 = [
    EarlyStopping(monitor='val_loss', patience=5, restore_best_weights=True, verbose=1),
    ModelCheckpoint(ckpt_phase1_best, monitor='val_accuracy', save_best_only=True, verbose=1),
    ModelCheckpoint(ckpt_phase1_each, monitor='val_accuracy', save_best_only=False, verbose=0)
]

history_p1 = model.fit(
    train_generator,
    epochs=EPOCHS_PHASE_1,
    validation_data=validation_generator,
    class_weight=train_class_weights,
    callbacks=callbacks_phase1,
    verbose=1
)

# -----------------------------------------------------------------------------
# Fine-tuning Phase 2
# -----------------------------------------------------------------------------
print("\n[5/7] Huấn luyện Phase 2 (Fine-tuning)...")
base_model.trainable = True
fine_tune_at = len(base_model.layers) // 2
for layer in base_model.layers[:fine_tune_at]:
    layer.trainable = False

model.compile(optimizer=Adam(learning_rate=1e-5),
              loss='categorical_crossentropy',
              metrics=['accuracy'])

ckpt_phase2_best = os.path.join(MODELS_DIR, 'brain_mri_densenet_transfer_phase2_best.h5')
ckpt_phase2_each = os.path.join(MODELS_DIR, 'brain_mri_transfer_phase2_epoch_{epoch:02d}_valacc_{val_accuracy:.4f}.h5')
callbacks_phase2 = [
    EarlyStopping(monitor='val_loss', patience=5, restore_best_weights=True, verbose=1),
    ModelCheckpoint(ckpt_phase2_best, monitor='val_accuracy', save_best_only=True, verbose=1),
    ModelCheckpoint(ckpt_phase2_each, monitor='val_accuracy', save_best_only=False, verbose=0)
]

history_p2 = model.fit(
    train_generator,
    epochs=EPOCHS_PHASE_1 + EPOCHS_PHASE_2,
    initial_epoch=len(history_p1.history['loss']),
    validation_data=validation_generator,
    class_weight=train_class_weights,
    callbacks=callbacks_phase2,
    verbose=1
)

# -----------------------------------------------------------------------------
# Đánh giá trên test set
# -----------------------------------------------------------------------------
print("\n[6/7] Đánh giá mô hình trên tập test...")
results = model.evaluate(test_generator, verbose=0)
print(f"   ✓ Test - Loss: {results[0]:.4f} | Accuracy: {results[1]*100:.2f}%")

print("   Dự đoán trên test set...")
probs = model.predict(test_generator, verbose=0)
y_true = test_generator.classes
y_pred = np.argmax(probs, axis=1)

cm = confusion_matrix(y_true, y_pred)
report = classification_report(y_true, y_pred, target_names=[idx_to_class[i] for i in range(num_classes)])
print("\n===== Classification Report =====\n")
print(report)

# Lưu confusion matrix hình ảnh
plt.figure(figsize=(8, 6))
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues',
            xticklabels=[idx_to_class[i] for i in range(num_classes)],
            yticklabels=[idx_to_class[i] for i in range(num_classes)])
plt.ylabel('Actual')
plt.xlabel('Predicted')
plt.title('Confusion Matrix - Brain MRI (DenseNet121)')
cm_path = os.path.join(MODELS_DIR, 'brain_mri_confusion_matrix.png')
plt.tight_layout()
plt.savefig(cm_path, dpi=300)
plt.close()
print(f"   ✓ Đã lưu: {cm_path}")

# -----------------------------------------------------------------------------
# Vẽ lịch sử huấn luyện
# -----------------------------------------------------------------------------
acc = history_p1.history['accuracy'] + history_p2.history['accuracy']
val_acc = history_p1.history['val_accuracy'] + history_p2.history['val_accuracy']
loss = history_p1.history['loss'] + history_p2.history['loss']
val_loss = history_p1.history['val_loss'] + history_p2.history['val_loss']

plt.figure(figsize=(14,5))
plt.subplot(1,2,1)
plt.plot(acc, label='Train Acc')
plt.plot(val_acc, label='Val Acc')
plt.axvline(x=EPOCHS_PHASE_1-1, color='r', linestyle='--', label='Start Fine-tune')
plt.title('Accuracy')
plt.xlabel('Epoch')
plt.legend()
plt.grid(True, alpha=0.3)

plt.subplot(1,2,2)
plt.plot(loss, label='Train Loss')
plt.plot(val_loss, label='Val Loss')
plt.axvline(x=EPOCHS_PHASE_1-1, color='r', linestyle='--', label='Start Fine-tune')
plt.title('Loss')
plt.xlabel('Epoch')
plt.legend()
plt.grid(True, alpha=0.3)

hist_path = os.path.join(MODELS_DIR, 'brain_mri_training_history.png')
plt.tight_layout()
plt.savefig(hist_path, dpi=300)
plt.close()
print(f"   ✓ Đã lưu: {hist_path}")

# -----------------------------------------------------------------------------
# Grad-CAM (tối giản, lưu vài ảnh demo)
# -----------------------------------------------------------------------------
print("\n[7/7] Tạo Grad-CAM cho vài ảnh mẫu...")

def get_gradcam_heatmap(img_array, model, last_conv_layer_name, pred_index=None):
    grad_model = tf.keras.models.Model([
        model.inputs
    ], [
        model.get_layer(last_conv_layer_name).output, model.output
    ])

    with tf.GradientTape() as tape:
        conv_outputs, predictions = grad_model(img_array, training=False)
        if pred_index is None:
            pred_index = tf.argmax(predictions[0])
        class_channel = predictions[:, pred_index]
    grads = tape.gradient(class_channel, conv_outputs)
    pooled_grads = tf.reduce_mean(grads, axis=(0, 1, 2))
    conv_outputs = conv_outputs[0]
    heatmap = tf.reduce_sum(tf.multiply(pooled_grads, conv_outputs), axis=-1)
    heatmap = tf.maximum(heatmap, 0) / (tf.reduce_max(heatmap) + 1e-8)
    return heatmap.numpy()

# tìm tên last conv layer trong DenseNet121
last_conv = None
for layer in model.layers[::-1]:
    if isinstance(layer, tf.keras.layers.Conv2D):
        last_conv = layer.name
        break
if last_conv is None:
    # fallback cho DenseNet: thường là 'conv5_block16_concat' trước GlobalAveragePooling
    last_conv = 'conv5_block16_concat' if 'conv5_block16_concat' in [l.name for l in model.layers] else model.layers[-3].name

# Lấy vài mẫu từ test set
N = min(4, len(test_generator.filenames))
for i in range(N):
    # Nạp ảnh gốc (đã được generator chuẩn hóa 1/255)
    batch = test_generator[i]
    x_batch, y_batch = batch
    img = x_batch[0:1]
    label_idx = int(np.argmax(y_batch[0]))

    heatmap = get_gradcam_heatmap(img, model, last_conv)
    heatmap = np.uint8(255 * heatmap)
    heatmap = np.stack([heatmap, heatmap, heatmap], axis=-1)

    # Chuyển img về [0,255]
    img_disp = (img[0] * 255).astype('uint8')
    # Resize heatmap và chồng lên ảnh
    import PIL
    from PIL import Image
    hm_img = Image.fromarray(heatmap).resize((img_disp.shape[1], img_disp.shape[0]))
    hm_arr = np.array(hm_img)
    overlay = np.clip(0.4 * hm_arr + 0.6 * img_disp, 0, 255).astype('uint8')

    fig, ax = plt.subplots(1,3, figsize=(10,4))
    ax[0].imshow(img_disp)
    ax[0].set_title(f"Original ({idx_to_class[label_idx]})")
    ax[0].axis('off')
    ax[1].imshow(heatmap, cmap='jet')
    ax[1].set_title('Grad-CAM')
    ax[1].axis('off')
    ax[2].imshow(overlay)
    ax[2].set_title('Overlay')
    ax[2].axis('off')
    out_path = os.path.join(MODELS_DIR, f'brain_mri_gradcam_{i+1}.png')
    plt.tight_layout()
    plt.savefig(out_path, dpi=200)
    plt.close(fig)
    print(f"   ✓ Grad-CAM đã lưu: {out_path}")

# -----------------------------------------------------------------------------
# Lưu model cuối
# -----------------------------------------------------------------------------
final_path_h5 = os.path.join(MODELS_DIR, 'brain_mri_densenet_transfer_phase2_final.h5')
final_path_keras = os.path.join(MODELS_DIR, 'brain_mri_densenet_transfer_phase2_final.keras')
model.save(final_path_h5)
try:
    model.save(final_path_keras)
except Exception as e:
    print(f"Cảnh báo: không lưu được định dạng .keras: {e}")
print("\n" + "=" * 80)
print("HOÀN THÀNH HUẤN LUYỆN MRI - DenseNet121")
print("=" * 80)
print("Các file đã lưu:")
print(f"  • Best Phase 1: {ckpt_phase1_best}")
print(f"  • Best Phase 2: {ckpt_phase2_best}")
print(f"  • Confusion Matrix: {cm_path}")
print(f"  • History: {hist_path}")
print(f"  • Final (h5): {final_path_h5}")
print(f"  • Final (keras): {final_path_keras}")
