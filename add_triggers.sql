-- Tạo TRIGGER tự động cập nhật totalAmount và totalValue
-- Chạy file này sau khi đã có database pttk với dữ liệu

USE pttk;

DELIMITER $$

-- Xóa trigger cũ nếu tồn tại
DROP TRIGGER IF EXISTS after_orderdetail_insert$$
DROP TRIGGER IF EXISTS after_orderdetail_update$$
DROP TRIGGER IF EXISTS after_orderdetail_delete$$
DROP TRIGGER IF EXISTS after_importdetail_insert$$
DROP TRIGGER IF EXISTS after_importdetail_update$$
DROP TRIGGER IF EXISTS after_importdetail_delete$$

-- Trigger 1: Sau khi INSERT OrderDetail mới
CREATE TRIGGER after_orderdetail_insert
AFTER INSERT ON OrderDetail
FOR EACH ROW
BEGIN
    UPDATE `Order`
    SET totalAmount = (
        SELECT COALESCE(SUM(quantity * unitPrice), 0)
        FROM OrderDetail
        WHERE orderID = NEW.orderID
    )
    WHERE orderID = NEW.orderID;
    
    UPDATE Invoice
    SET totalValue = (
        SELECT totalAmount
        FROM `Order`
        WHERE orderID = NEW.orderID
    )
    WHERE orderID = NEW.orderID;
END$$

-- Trigger 2: Sau khi UPDATE OrderDetail
CREATE TRIGGER after_orderdetail_update
AFTER UPDATE ON OrderDetail
FOR EACH ROW
BEGIN
    UPDATE `Order`
    SET totalAmount = (
        SELECT COALESCE(SUM(quantity * unitPrice), 0)
        FROM OrderDetail
        WHERE orderID = NEW.orderID
    )
    WHERE orderID = NEW.orderID;
    
    UPDATE Invoice
    SET totalValue = (
        SELECT totalAmount
        FROM `Order`
        WHERE orderID = NEW.orderID
    )
    WHERE orderID = NEW.orderID;
END$$

-- Trigger 3: Sau khi DELETE OrderDetail
CREATE TRIGGER after_orderdetail_delete
AFTER DELETE ON OrderDetail
FOR EACH ROW
BEGIN
    UPDATE `Order`
    SET totalAmount = (
        SELECT COALESCE(SUM(quantity * unitPrice), 0)
        FROM OrderDetail
        WHERE orderID = OLD.orderID
    )
    WHERE orderID = OLD.orderID;
    
    UPDATE Invoice
    SET totalValue = (
        SELECT totalAmount
        FROM `Order`
        WHERE orderID = OLD.orderID
    )
    WHERE orderID = OLD.orderID;
END$$

-- ========================================
-- TRIGGER CHO ImportDetail → ImportReceipt
-- ========================================

-- Trigger 4: Sau khi INSERT ImportDetail mới
CREATE TRIGGER after_importdetail_insert
AFTER INSERT ON ImportDetail
FOR EACH ROW
BEGIN
    UPDATE ImportReceipt
    SET totalValue = (
        SELECT COALESCE(SUM(quantity * importPrice), 0)
        FROM ImportDetail
        WHERE importReceiptID = NEW.importReceiptID
    )
    WHERE importReceiptID = NEW.importReceiptID;
END$$

-- Trigger 5: Sau khi UPDATE ImportDetail
CREATE TRIGGER after_importdetail_update
AFTER UPDATE ON ImportDetail
FOR EACH ROW
BEGIN
    UPDATE ImportReceipt
    SET totalValue = (
        SELECT COALESCE(SUM(quantity * importPrice), 0)
        FROM ImportDetail
        WHERE importReceiptID = NEW.importReceiptID
    )
    WHERE importReceiptID = NEW.importReceiptID;
END$$

-- Trigger 6: Sau khi DELETE ImportDetail
CREATE TRIGGER after_importdetail_delete
AFTER DELETE ON ImportDetail
FOR EACH ROW
BEGIN
    UPDATE ImportReceipt
    SET totalValue = (
        SELECT COALESCE(SUM(quantity * importPrice), 0)
        FROM ImportDetail
        WHERE importReceiptID = OLD.importReceiptID
    )
    WHERE importReceiptID = OLD.importReceiptID;
END$$

DELIMITER ;

-- Kiểm tra trigger đã được tạo
SHOW TRIGGERS;

-- ========================================
-- TEST TRIGGER
-- ========================================

-- Test trigger OrderDetail
-- INSERT INTO OrderDetail VALUES ('OD_TEST', 1, 1000000.00, 'P001', 'ORD001');

-- Kiểm tra kết quả Order
-- SELECT o.orderID, o.totalAmount, SUM(od.quantity * od.unitPrice) as calculated
-- FROM `Order` o
-- LEFT JOIN OrderDetail od ON o.orderID = od.orderID
-- WHERE o.orderID = 'ORD001'
-- GROUP BY o.orderID;

-- Test trigger ImportDetail
-- INSERT INTO ImportDetail VALUES ('ID_TEST', 5, 3000000.00, 'P003', 'IR001');

-- Kiểm tra kết quả ImportReceipt
-- SELECT ir.importReceiptID, ir.totalValue, SUM(id.quantity * id.importPrice) as calculated
-- FROM ImportReceipt ir
-- LEFT JOIN ImportDetail id ON ir.importReceiptID = id.importReceiptID
-- WHERE ir.importReceiptID = 'IR001'
-- GROUP BY ir.importReceiptID;
