#!/bin/bash

echo "========================================="
echo "THÊM TRIGGER TỰ ĐỘNG CẬP NHẬT totalAmount"
echo "========================================="
echo ""
echo "Script này sẽ tạo 6 trigger:"
echo ""
echo "Cho OrderDetail → Order & Invoice:"
echo "1. after_orderdetail_insert - Tự động cập nhật khi thêm OrderDetail"
echo "2. after_orderdetail_update - Tự động cập nhật khi sửa OrderDetail"
echo "3. after_orderdetail_delete - Tự động cập nhật khi xóa OrderDetail"
echo ""
echo "Cho ImportDetail → ImportReceipt:"
echo "4. after_importdetail_insert - Tự động cập nhật khi thêm ImportDetail"
echo "5. after_importdetail_update - Tự động cập nhật khi sửa ImportDetail"
echo "6. after_importdetail_delete - Tự động cập nhật khi xóa ImportDetail"
echo ""
echo "Nhập password MySQL của user root:"

# Chạy SQL file
mysql -u root -p pttk < add_triggers.sql

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Đã tạo trigger thành công!"
    echo ""
    echo "Bạn có thể test trigger bằng cách chạy:"
    echo "mysql -u root -p pttk"
    echo "Sau đó thực hiện:"
    echo "  INSERT INTO OrderDetail VALUES ('OD_TEST', 2, 1000000, 'P001', 'ORD001');"
    echo "  SELECT orderID, totalAmount FROM \`Order\` WHERE orderID='ORD001';"
else
    echo ""
    echo "✗ Có lỗi xảy ra. Vui lòng kiểm tra lại."
fi
