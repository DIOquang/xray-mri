-- Chỉ định schema (database) để làm việc
USE pttk;

-- 1. XÓA BẢNG NẾU TỒN TẠI (ĐỂ CHẠY LẠI SCRIPT MÀ KHÔNG BỊ LỖI)
-- Phải xóa theo thứ tự ngược lại của khóa ngoại (xóa con trước, cha sau)
DROP TABLE IF EXISTS Invoice;
DROP TABLE IF EXISTS OrderDetail;
DROP TABLE IF EXISTS ImportDetail;
DROP TABLE IF EXISTS `Order`;
DROP TABLE IF EXISTS ImportReceipt;
DROP TABLE IF EXISTS Supplier;
DROP TABLE IF EXISTS SaleStaff;
DROP TABLE IF EXISTS Manager;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS `User`;


-- 2. TẠO BẢNG (THEO THỨ TỰ CHA TRƯỚC, CON SAU)

-- Bảng cha, không có khóa ngoại
CREATE TABLE `User` (
    userID VARCHAR(255) PRIMARY KEY,
    logginname VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(255),
    email VARCHAR(255)
);

CREATE TABLE Product (
    productID VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    unitPrice DECIMAL(15, 2)
);

-- Bảng phụ thuộc vào User
CREATE TABLE Employee (
    employeeID VARCHAR(255) PRIMARY KEY,
    userID VARCHAR(255) NOT NULL UNIQUE,
    FOREIGN KEY (userID) REFERENCES `User`(userID)
);

CREATE TABLE Customer (
    userCustomerID VARCHAR(255) PRIMARY KEY,
    userID VARCHAR(255) NOT NULL UNIQUE,
    FOREIGN KEY (userID) REFERENCES `User`(userID)
);

-- Bảng phụ thuộc vào Employee
CREATE TABLE Manager (
    userManagerID VARCHAR(255) PRIMARY KEY,
    employeeID VARCHAR(255) NOT NULL UNIQUE,
    FOREIGN KEY (employeeID) REFERENCES Employee(employeeID)
);

CREATE TABLE SaleStaff (
    userSaleID VARCHAR(255) PRIMARY KEY,
    employeeID VARCHAR(255) NOT NULL UNIQUE,
    FOREIGN KEY (employeeID) REFERENCES Employee(employeeID)
);

-- Bảng phụ thuộc vào Manager
CREATE TABLE Supplier (
    supplierID VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(255),
    userManagerID VARCHAR(255),
    FOREIGN KEY (userManagerID) REFERENCES Manager(userManagerID)
);

-- Bảng phụ thuộc vào Supplier
CREATE TABLE ImportReceipt (
    importReceiptID VARCHAR(255) PRIMARY KEY,
    importDate DATE,
    totalValue DECIMAL(15, 2),
    status VARCHAR(255),
    supplierID VARCHAR(255),
    FOREIGN KEY (supplierID) REFERENCES Supplier(supplierID)
);

-- Bảng phụ thuộc vào ImportReceipt và Product
CREATE TABLE ImportDetail (
    importDetailID VARCHAR(255) PRIMARY KEY,
    quantity INT,
    importPrice DECIMAL(15, 2),
    importReceiptID VARCHAR(255),
    productID VARCHAR(255),
    FOREIGN KEY (importReceiptID) REFERENCES ImportReceipt(importReceiptID),
    FOREIGN KEY (productID) REFERENCES Product(productID)
);

-- Bảng `Order` (phải dùng dấu ` vì 'Order' là từ khóa)
-- Phụ thuộc vào Customer và SaleStaff
-- KHÔNG liên kết trực tiếp với Supplier (hoạt động bán hàng độc lập với nhập hàng)
CREATE TABLE `Order` (
    orderID VARCHAR(255) PRIMARY KEY,
    orderDate DATE,
    totalAmount DECIMAL(15, 2),
    status VARCHAR(255),
    userCustomerID VARCHAR(255),
    userSaleID VARCHAR(255),
    FOREIGN KEY (userCustomerID) REFERENCES Customer(userCustomerID),
    FOREIGN KEY (userSaleID) REFERENCES SaleStaff(userSaleID)
);

-- Bảng phụ thuộc vào Order và Product
CREATE TABLE OrderDetail (
    orderDetailID VARCHAR(255) PRIMARY KEY,
    quantity INT,
    unitPrice DECIMAL(15, 2), -- Giá tại thời điểm bán
    productID VARCHAR(255),
    orderID VARCHAR(255),
    FOREIGN KEY (productID) REFERENCES Product(productID),
    FOREIGN KEY (orderID) REFERENCES `Order`(orderID)
);

-- Bảng phụ thuộc vào Order (quan hệ 1-1)
CREATE TABLE Invoice (
    invoiceID VARCHAR(255) PRIMARY KEY,
    creationDate DATE,
    totalValue DECIMAL(15, 2),
    status VARCHAR(255),
    orderID VARCHAR(255) NOT NULL UNIQUE,
    FOREIGN KEY (orderID) REFERENCES `Order`(orderID)
);


-- 3. THÊM DỮ LIỆU MẪU (5 BỘ CHO MỖI BẢNG)
-- (Lưu ý: Bảng User và Employee cần nhiều hơn 5 để hỗ trợ các bảng khác)

INSERT INTO `User` (userID, logginname, password, address, phone, email) VALUES
('U001', 'khachA', '123', '123 Duong A', '0901', 'khacha@mail.com'),
('U002', 'khachB', '123', '456 Duong B', '0902', 'khachb@mail.com'),
('U003', 'khachC', '123', '789 Duong C', '0903', 'khachc@mail.com'),
('U004', 'khachD', '123', '111 Duong D', '0904', 'khachd@mail.com'),
('U005', 'khachE', '123', '222 Duong E', '0905', 'khache@mail.com'),
('U006', 'managerA', '123', '333 QL 1', '0801', 'managera@mail.com'),
('U007', 'managerB', '123', '444 QL 2', '0802', 'managerb@mail.com'),
('U008', 'managerC', '123', '555 QL 3', '0803', 'managerc@mail.com'),
('U009', 'managerD', '123', '666 QL 4', '0804', 'managerd@mail.com'),
('U010', 'managerE', '123', '777 QL 5', '0805', 'managere@mail.com'),
('U011', 'saleA', '123', '888 Le Loi', '0701', 'salea@mail.com'),
('U012', 'saleB', '123', '999 Tran Hung Dao', '0702', 'saleb@mail.com'),
('U013', 'saleC', '123', '121 Nguyen Hue', '0703', 'salec@mail.com'),
('U014', 'saleD', '123', '343 Hai Ba Trung', '0704', 'saled@mail.com'),
('U015', 'saleE', '123', '565 Ly Thuong Kiet', '0705', 'salee@mail.com');

INSERT INTO Product (productID, name, description, unitPrice) VALUES
('P001', 'iPhone 15 Pro', 'Titan tu nhien', 25000000.00),
('P002', 'Samsung Galaxy S24', 'AI Phone', 22000000.00),
('P003', 'Dell XPS 15', 'Laptop cho doanh nhan', 35000000.00),
('P004', 'Sony Bravia 55 inch', 'TV 4K OLED', 18000000.00),
('P005', 'Airpods Pro 2', 'Tai nghe chong on', 5500000.00);

INSERT INTO Employee (employeeID, userID) VALUES
('E001', 'U006'),
('E002', 'U007'),
('E003', 'U008'),
('E004', 'U009'),
('E005', 'U010'),
('E006', 'U011'),
('E007', 'U012'),
('E008', 'U013'),
('E009', 'U014'),
('E010', 'U015');

INSERT INTO Customer (userCustomerID, userID) VALUES
('CUS001', 'U001'),
('CUS002', 'U002'),
('CUS003', 'U003'),
('CUS004', 'U004'),
('CUS005', 'U005');

INSERT INTO Manager (userManagerID, employeeID) VALUES
('MAN001', 'E001'),
('MAN002', 'E002'),
('MAN003', 'E003'),
('MAN004', 'E004'),
('MAN005', 'E005');

INSERT INTO SaleStaff (userSaleID, employeeID) VALUES
('SALE001', 'E006'),
('SALE002', 'E007'),
('SALE003', 'E008'),
('SALE004', 'E009'),
('SALE005', 'E010');

INSERT INTO Supplier (supplierID, name, address, phone, userManagerID) VALUES
('SUP001', 'Nha Phan Phoi Samsung', 'KCN Yen Phong, Bac Ninh', '1111', 'MAN001'),
('SUP002', 'Nha Phan Phoi Apple', 'Cupertino, CA (VN)', '2222', 'MAN002'),
('SUP003', 'Nha Phan Phoi Dell', 'KCN Tan Thuan, Q7', '3333', 'MAN001'),
('SUP004', 'Nha Phan Phoi Sony', 'Q1, TPHCM', '4444', 'MAN003'),
('SUP005', 'Nha Phan Phoi Thiet Bi Chung', 'Cho Lon, Q5', '5555', 'MAN002');

-- Import Receipts: Mỗi supplier có 5 receipts
INSERT INTO ImportReceipt (importReceiptID, importDate, totalValue, status, supplierID) VALUES
-- SUP001 - Nha Phan Phoi Samsung
('IR_SUP001_001', '2025-10-05', 440000000.00, 'Completed', 'SUP001'),
('IR_SUP001_002', '2025-10-10', 220000000.00, 'Completed', 'SUP001'),
('IR_SUP001_003', '2025-10-15', 550000000.00, 'Completed', 'SUP001'),
('IR_SUP001_004', '2025-10-20', 330000000.00, 'Completed', 'SUP001'),
('IR_SUP001_005', '2025-10-25', 660000000.00, 'Completed', 'SUP001'),
-- SUP002 - Nha Phan Phoi Apple
('IR_SUP002_001', '2025-10-03', 250000000.00, 'Completed', 'SUP002'),
('IR_SUP002_002', '2025-10-08', 500000000.00, 'Completed', 'SUP002'),
('IR_SUP002_003', '2025-10-13', 375000000.00, 'Completed', 'SUP002'),
('IR_SUP002_004', '2025-10-18', 625000000.00, 'Completed', 'SUP002'),
('IR_SUP002_005', '2025-10-23', 450000000.00, 'Completed', 'SUP002'),
-- SUP003 - Nha Phan Phoi Dell
('IR_SUP003_001', '2025-10-04', 350000000.00, 'Completed', 'SUP003'),
('IR_SUP003_002', '2025-10-09', 525000000.00, 'Completed', 'SUP003'),
('IR_SUP003_003', '2025-10-14', 700000000.00, 'Completed', 'SUP003'),
('IR_SUP003_004', '2025-10-19', 420000000.00, 'Completed', 'SUP003'),
('IR_SUP003_005', '2025-10-24', 875000000.00, 'Completed', 'SUP003'),
-- SUP004 - Nha Phan Phoi Sony
('IR_SUP004_001', '2025-10-06', 180000000.00, 'Completed', 'SUP004'),
('IR_SUP004_002', '2025-10-11', 360000000.00, 'Completed', 'SUP004'),
('IR_SUP004_003', '2025-10-16', 270000000.00, 'Completed', 'SUP004'),
('IR_SUP004_004', '2025-10-21', 450000000.00, 'Completed', 'SUP004'),
('IR_SUP004_005', '2025-10-26', 540000000.00, 'Completed', 'SUP004'),
-- SUP005 - Nha Phan Phoi Thiet Bi Chung
('IR_SUP005_001', '2025-10-07', 55000000.00, 'Completed', 'SUP005'),
('IR_SUP005_002', '2025-10-12', 110000000.00, 'Completed', 'SUP005'),
('IR_SUP005_003', '2025-10-17', 85000000.00, 'Completed', 'SUP005'),
('IR_SUP005_004', '2025-10-22', 127500000.00, 'Completed', 'SUP005'),
('IR_SUP005_005', '2025-10-27', 170000000.00, 'Completed', 'SUP005');

INSERT INTO ImportDetail (importDetailID, quantity, importPrice, importReceiptID, productID) VALUES
-- SUP001 - Samsung
('ID_SUP001_001_1', 20, 22000000.00, 'IR_SUP001_001', 'P002'),
('ID_SUP001_002_1', 10, 22000000.00, 'IR_SUP001_002', 'P002'),
('ID_SUP001_003_1', 15, 22000000.00, 'IR_SUP001_003', 'P002'),
('ID_SUP001_003_2', 10, 22000000.00, 'IR_SUP001_003', 'P002'),
('ID_SUP001_004_1', 15, 22000000.00, 'IR_SUP001_004', 'P002'),
('ID_SUP001_005_1', 30, 22000000.00, 'IR_SUP001_005', 'P002'),
-- SUP002 - Apple
('ID_SUP002_001_1', 10, 25000000.00, 'IR_SUP002_001', 'P001'),
('ID_SUP002_002_1', 10, 25000000.00, 'IR_SUP002_002', 'P001'),
('ID_SUP002_002_2', 5, 45000000.00, 'IR_SUP002_002', 'P006'),
('ID_SUP002_002_3', 5, 5500000.00, 'IR_SUP002_002', 'P005'),
('ID_SUP002_003_1', 15, 25000000.00, 'IR_SUP002_003', 'P001'),
('ID_SUP002_004_1', 10, 25000000.00, 'IR_SUP002_004', 'P001'),
('ID_SUP002_004_2', 10, 32000000.00, 'IR_SUP002_004', 'P008'),
('ID_SUP002_004_3', 5, 5500000.00, 'IR_SUP002_004', 'P005'),
('ID_SUP002_005_1', 10, 45000000.00, 'IR_SUP002_005', 'P006'),
-- SUP003 - Dell
('ID_SUP003_001_1', 10, 35000000.00, 'IR_SUP003_001', 'P003'),
('ID_SUP003_002_1', 15, 35000000.00, 'IR_SUP003_002', 'P003'),
('ID_SUP003_003_1', 20, 35000000.00, 'IR_SUP003_003', 'P003'),
('ID_SUP003_004_1', 12, 35000000.00, 'IR_SUP003_004', 'P003'),
('ID_SUP003_005_1', 10, 35000000.00, 'IR_SUP003_005', 'P003'),
('ID_SUP003_005_2', 10, 55000000.00, 'IR_SUP003_005', 'P010'),
-- SUP004 - Sony
('ID_SUP004_001_1', 10, 18000000.00, 'IR_SUP004_001', 'P004'),
('ID_SUP004_002_1', 20, 18000000.00, 'IR_SUP004_002', 'P004'),
('ID_SUP004_003_1', 15, 18000000.00, 'IR_SUP004_003', 'P004'),
('ID_SUP004_004_1', 10, 18000000.00, 'IR_SUP004_004', 'P004'),
('ID_SUP004_004_2', 10, 28000000.00, 'IR_SUP004_004', 'P007'),
('ID_SUP004_004_3', 5, 8500000.00, 'IR_SUP004_004', 'P009'),
('ID_SUP004_005_1', 15, 28000000.00, 'IR_SUP004_005', 'P007'),
('ID_SUP004_005_2', 10, 8500000.00, 'IR_SUP004_005', 'P009'),
('ID_SUP004_005_3', 5, 18000000.00, 'IR_SUP004_005', 'P004'),
-- SUP005 - Thiet bi chung
('ID_SUP005_001_1', 10, 5500000.00, 'IR_SUP005_001', 'P005'),
('ID_SUP005_002_1', 20, 5500000.00, 'IR_SUP005_002', 'P005'),
('ID_SUP005_003_1', 10, 8500000.00, 'IR_SUP005_003', 'P009'),
('ID_SUP005_004_1', 15, 8500000.00, 'IR_SUP005_004', 'P009'),
('ID_SUP005_005_1', 20, 8500000.00, 'IR_SUP005_005', 'P009');

-- Bổ sung thêm sản phẩm để có nhiều đơn hàng đa dạng hơn
INSERT INTO Product (productID, name, description, unitPrice) VALUES
('P006', 'MacBook Pro M3', 'Laptop cao cap Apple', 45000000.00),
('P007', 'Samsung QLED 65 inch', 'TV 4K QLED', 28000000.00),
('P008', 'iPad Pro 12.9', 'May tinh bang cao cap', 32000000.00),
('P009', 'Sony WH-1000XM5', 'Tai nghe chong on', 8500000.00),
('P010', 'Dell Alienware', 'Laptop gaming', 55000000.00);

-- Thêm nhiều đơn hàng (không cần supplierID - bán từ kho)
INSERT INTO `Order` (orderID, orderDate, totalAmount, status, userCustomerID, userSaleID) VALUES
-- Đơn hàng tháng 10/2025
('ORD001', '2025-10-10', 25000000.00, 'Da giao', 'CUS001', 'SALE001'),
('ORD006', '2025-10-15', 45000000.00, 'Da giao', 'CUS002', 'SALE002'),
('ORD011', '2025-10-20', 32000000.00, 'Da giao', 'CUS003', 'SALE001'),
('ORD016', '2025-10-25', 25000000.00, 'Da giao', 'CUS001', 'SALE003'),
('ORD021', '2025-10-28', 77000000.00, 'Da giao', 'CUS005', 'SALE001'),

('ORD002', '2025-10-11', 44000000.00, 'Da giao', 'CUS002', 'SALE002'),
('ORD007', '2025-10-16', 22000000.00, 'Da giao', 'CUS003', 'SALE003'),
('ORD012', '2025-10-21', 66000000.00, 'Da giao', 'CUS004', 'SALE002'),
('ORD017', '2025-10-26', 28000000.00, 'Da giao', 'CUS002', 'SALE004'),
('ORD022', '2025-10-29', 50000000.00, 'Da giao', 'CUS001', 'SALE002'),

('ORD003', '2025-10-12', 35000000.00, 'Da giao', 'CUS001', 'SALE001'),
('ORD008', '2025-10-17', 70000000.00, 'Da giao', 'CUS004', 'SALE004'),
('ORD013', '2025-10-22', 55000000.00, 'Da giao', 'CUS005', 'SALE003'),
('ORD018', '2025-10-27', 35000000.00, 'Da giao', 'CUS003', 'SALE001'),
('ORD023', '2025-10-30', 90000000.00, 'Da giao', 'CUS002', 'SALE003'),

('ORD004', '2025-10-13', 18000000.00, 'Da giao', 'CUS003', 'SALE003'),
('ORD009', '2025-10-18', 26500000.00, 'Da giao', 'CUS005', 'SALE005'),
('ORD014', '2025-10-23', 36000000.00, 'Da giao', 'CUS001', 'SALE004'),
('ORD019', '2025-10-28', 18000000.00, 'Da giao', 'CUS004', 'SALE002'),
('ORD024', '2025-10-31', 44500000.00, 'Da giao', 'CUS003', 'SALE004'),

('ORD005', '2025-10-14', 5500000.00, 'Da giao', 'CUS004', 'SALE004'),
('ORD010', '2025-10-19', 14000000.00, 'Da giao', 'CUS001', 'SALE005'),
('ORD015', '2025-10-24', 11000000.00, 'Da giao', 'CUS002', 'SALE001'),
('ORD020', '2025-10-29', 16500000.00, 'Da giao', 'CUS005', 'SALE003'),
('ORD025', '2025-10-31', 8500000.00, 'Da giao', 'CUS004', 'SALE005');

INSERT INTO OrderDetail (orderDetailID, quantity, unitPrice, productID, orderID) VALUES
-- Chi tiết các đơn hàng (bán hàng từ kho, không phân biệt supplier)
('OD001', 1, 25000000.00, 'P001', 'ORD001'),
('OD006', 1, 45000000.00, 'P006', 'ORD006'),
('OD011', 1, 32000000.00, 'P008', 'ORD011'),
('OD016', 1, 25000000.00, 'P001', 'ORD016'),
('OD021', 1, 45000000.00, 'P006', 'ORD021'),
('OD021b', 1, 32000000.00, 'P008', 'ORD021'),

('OD002', 2, 22000000.00, 'P002', 'ORD002'),
('OD007', 1, 22000000.00, 'P002', 'ORD007'),
('OD012', 3, 22000000.00, 'P002', 'ORD012'),
('OD017', 1, 28000000.00, 'P007', 'ORD017'),
('OD022', 1, 22000000.00, 'P002', 'ORD022'),
('OD022b', 1, 28000000.00, 'P007', 'ORD022'),

('OD003', 1, 35000000.00, 'P003', 'ORD003'),
('OD008', 2, 35000000.00, 'P003', 'ORD008'),
('OD013', 1, 55000000.00, 'P010', 'ORD013'),
('OD018', 1, 35000000.00, 'P003', 'ORD018'),
('OD023', 1, 35000000.00, 'P003', 'ORD023'),
('OD023b', 1, 55000000.00, 'P010', 'ORD023'),

('OD004', 1, 18000000.00, 'P004', 'ORD004'),
('OD009', 1, 18000000.00, 'P004', 'ORD009'),
('OD009b', 1, 8500000.00, 'P009', 'ORD009'),
('OD014', 2, 18000000.00, 'P004', 'ORD014'),
('OD019', 1, 18000000.00, 'P004', 'ORD019'),
('OD024', 2, 18000000.00, 'P004', 'ORD024'),
('OD024b', 1, 8500000.00, 'P009', 'ORD024'),

('OD005', 1, 5500000.00, 'P005', 'ORD005'),
('OD010', 1, 5500000.00, 'P005', 'ORD010'),
('OD010b', 1, 8500000.00, 'P009', 'ORD010'),
('OD015', 2, 5500000.00, 'P005', 'ORD015'),
('OD020', 2, 8500000.00, 'P009', 'ORD020'),
('OD025', 1, 8500000.00, 'P009', 'ORD025');

INSERT INTO Invoice (invoiceID, creationDate, totalValue, status, orderID) VALUES
-- Hóa đơn cho các đơn hàng
('INV001', '2025-10-10', 25000000.00, 'Da thanh toan', 'ORD001'),
('INV006', '2025-10-15', 45000000.00, 'Da thanh toan', 'ORD006'),
('INV011', '2025-10-20', 32000000.00, 'Da thanh toan', 'ORD011'),
('INV016', '2025-10-25', 25000000.00, 'Da thanh toan', 'ORD016'),
('INV021', '2025-10-28', 77000000.00, 'Da thanh toan', 'ORD021'),

('INV002', '2025-10-11', 44000000.00, 'Da thanh toan', 'ORD002'),
('INV007', '2025-10-16', 22000000.00, 'Da thanh toan', 'ORD007'),
('INV012', '2025-10-21', 66000000.00, 'Da thanh toan', 'ORD012'),
('INV017', '2025-10-26', 28000000.00, 'Da thanh toan', 'ORD017'),
('INV022', '2025-10-29', 50000000.00, 'Da thanh toan', 'ORD022'),

('INV003', '2025-10-12', 35000000.00, 'Da thanh toan', 'ORD003'),
('INV008', '2025-10-17', 70000000.00, 'Da thanh toan', 'ORD008'),
('INV013', '2025-10-22', 55000000.00, 'Da thanh toan', 'ORD013'),
('INV018', '2025-10-27', 35000000.00, 'Da thanh toan', 'ORD018'),
('INV023', '2025-10-30', 90000000.00, 'Da thanh toan', 'ORD023'),

('INV004', '2025-10-13', 18000000.00, 'Da thanh toan', 'ORD004'),
('INV009', '2025-10-18', 26500000.00, 'Da thanh toan', 'ORD009'),
('INV014', '2025-10-23', 36000000.00, 'Da thanh toan', 'ORD014'),
('INV019', '2025-10-28', 18000000.00, 'Da thanh toan', 'ORD019'),
('INV024', '2025-10-31', 44500000.00, 'Da thanh toan', 'ORD024'),

('INV005', '2025-10-14', 5500000.00, 'Da thanh toan', 'ORD005'),
('INV010', '2025-10-19', 14000000.00, 'Da thanh toan', 'ORD010'),
('INV015', '2025-10-24', 11000000.00, 'Da thanh toan', 'ORD015'),
('INV020', '2025-10-29', 16500000.00, 'Da thanh toan', 'ORD020'),
('INV025', '2025-10-31', 8500000.00, 'Da thanh toan', 'ORD025');


-- 4. TẠO TRIGGER TỰ ĐỘNG CẬP NHẬT totalAmount
-- Trigger sẽ tự động tính lại totalAmount của Order mỗi khi OrderDetail thay đổi

DELIMITER $$

-- Trigger 1: Sau khi INSERT OrderDetail mới
DROP TRIGGER IF EXISTS after_orderdetail_insert$$
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
    
    -- Cập nhật Invoice.totalValue nếu đã có invoice
    UPDATE Invoice
    SET totalValue = (
        SELECT totalAmount
        FROM `Order`
        WHERE orderID = NEW.orderID
    )
    WHERE orderID = NEW.orderID;
END$$

-- Trigger 2: Sau khi UPDATE OrderDetail
DROP TRIGGER IF EXISTS after_orderdetail_update$$
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
    
    -- Cập nhật Invoice.totalValue
    UPDATE Invoice
    SET totalValue = (
        SELECT totalAmount
        FROM `Order`
        WHERE orderID = NEW.orderID
    )
    WHERE orderID = NEW.orderID;
END$$

-- Trigger 3: Sau khi DELETE OrderDetail
DROP TRIGGER IF EXISTS after_orderdetail_delete$$
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
    
    -- Cập nhật Invoice.totalValue
    UPDATE Invoice
    SET totalValue = (
        SELECT totalAmount
        FROM `Order`
        WHERE orderID = OLD.orderID
    )
    WHERE orderID = OLD.orderID;
END$$

-- Trigger 4: Sau khi INSERT ImportDetail mới
DROP TRIGGER IF EXISTS after_importdetail_insert$$
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
DROP TRIGGER IF EXISTS after_importdetail_update$$
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
DROP TRIGGER IF EXISTS after_importdetail_delete$$
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