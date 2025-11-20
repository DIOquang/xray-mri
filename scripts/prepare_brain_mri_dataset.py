#!/usr/bin/env python3
"""
Chuẩn bị dữ liệu Brain MRI cho huấn luyện DenseNet-121 (4 lớp)

- Nguồn đầu vào: data/brain_mri_raw/{Training,Testing}/<class>/*.jpg|png
- Đầu ra: data/brain_mri/{train,val,test}/<class>/* theo tỉ lệ 70/15/15

Sử dụng:
    python scripts/prepare_brain_mri_dataset.py \
        --raw-dir data/brain_mri_raw \
        --out-dir data/brain_mri \
        --train 0.7 --val 0.15 --test 0.15 \
        --seed 42

Nếu đã có sẵn phân chia khác, script sẽ ghi đè thư mục đích (xóa trước khi tạo).
"""

import argparse
import os
import shutil
from pathlib import Path
import random

ALLOWED_EXT = {'.jpg', '.jpeg', '.png', '.bmp'}


def collect_images(raw_dir: Path):
    sources = []
    for split in ['Training', 'Testing']:
        split_dir = raw_dir / split
        if not split_dir.is_dir():
            continue
        for cls in sorted(os.listdir(split_dir)):
            cls_dir = split_dir / cls
            if not cls_dir.is_dir():
                continue
            for p in cls_dir.rglob('*'):
                if p.is_file() and p.suffix.lower() in ALLOWED_EXT:
                    sources.append((cls, p))
    return sources


def split_and_copy(sources, out_dir: Path, ratios, seed=42):
    random.seed(seed)
    # Group by class
    by_class = {}
    for cls, p in sources:
        by_class.setdefault(cls, []).append(p)

    # Prepare output dirs
    if out_dir.exists():
        shutil.rmtree(out_dir)
    for split in ['train', 'val', 'test']:
        (out_dir / split).mkdir(parents=True, exist_ok=True)

    for cls, files in by_class.items():
        random.shuffle(files)
        n = len(files)
        n_train = int(n * ratios['train'])
        n_val = int(n * ratios['val'])
        n_test = n - n_train - n_val
        splits = {
            'train': files[:n_train],
            'val': files[n_train:n_train + n_val],
            'test': files[n_train + n_val:]
        }
        for split, paths in splits.items():
            target = out_dir / split / cls
            target.mkdir(parents=True, exist_ok=True)
            for src in paths:
                dst = target / src.name
                shutil.copy2(src, dst)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--raw-dir', type=str, default='data/brain_mri_raw')
    parser.add_argument('--out-dir', type=str, default='data/brain_mri')
    parser.add_argument('--train', type=float, default=0.7)
    parser.add_argument('--val', type=float, default=0.15)
    parser.add_argument('--test', type=float, default=0.15)
    parser.add_argument('--seed', type=int, default=42)
    args = parser.parse_args()

    ratios = {'train': args.train, 'val': args.val, 'test': args.test}
    if abs(sum(ratios.values()) - 1.0) > 1e-6:
        raise ValueError('Tổng tỉ lệ phải bằng 1.0')

    raw_dir = Path(args.raw_dir)
    out_dir = Path(args.out_dir)
    if not raw_dir.is_dir():
        raise FileNotFoundError(f'Không tìm thấy thư mục raw: {raw_dir}')

    print(f'✔ Thu thập ảnh từ: {raw_dir}')
    sources = collect_images(raw_dir)
    if not sources:
        raise RuntimeError('Không tìm thấy ảnh trong thư mục raw.')
    print(f'  • Tổng số ảnh: {len(sources)}')
    print(f'✔ Tạo split với tỉ lệ: train={ratios["train"]}, val={ratios["val"]}, test={ratios["test"]}')
    split_and_copy(sources, out_dir, ratios, seed=args.seed)
    print(f'✔ Hoàn tất. Dữ liệu nằm tại: {out_dir}')


if __name__ == '__main__':
    main()
