# 📦 PROJECT PTTK - HỆ THỐNG QUẢN LÝ BÁN HÀNG

## 📁 CẤU TRÚC PROJECT

```
pttk/
├── MyWebApp/              # Java Web Application (JSP + Servlet)
│   ├── src/
│   │   └── main/
│   │       ├── java/     # Source code Java
│   │       └── webapp/   # JSP files
│   └── pom.xml           # Maven configuration
│
├── scripts.sql           # ⭐ File SQL chính (database + trigger)
├── add_triggers.sql      # File trigger riêng (cài vào DB có sẵn)
├── install_triggers.sh   # Script cài đặt trigger tự động
│
└── Documents/
    ├── HUONG_DAN_SU_DUNG.md              # Hướng dẫn sử dụng hệ thống
    ├── THAY_DOI_LOGIC.md                 # Lịch sử thay đổi logic
    └── TRIGGER_INSTALLATION_GUIDE.md     # Hướng dẫn cài đặt trigger
```

## 🚀 CÁCH SỬ DỤNG

### **1. Tạo Database**

```bash
mysql -u root -p pttk < scripts.sql
```

File này sẽ:
- ✅ Tạo tất cả bảng
- ✅ Thêm dữ liệu mẫu
- ✅ Tạo 6 trigger tự động

### **2. Chạy Web Application**

```bash
cd MyWebApp
mvn clean tomcat7:run
```

Truy cập: `http://localhost:8080/MyWebApp`

### **3. Cài đặt Trigger riêng** (nếu cần)

Nếu đã có database và chỉ muốn thêm trigger:

```bash
./install_triggers.sh
```

hoặc:

```bash
mysql -u root -p pttk < add_triggers.sql
```

## 🔧 TRIGGER TỰ ĐỘNG

Hệ thống có **6 trigger** tự động cập nhật:

### **OrderDetail → Order & Invoice**
- `after_orderdetail_insert` - Tự động cập nhật khi thêm
- `after_orderdetail_update` - Tự động cập nhật khi sửa
- `after_orderdetail_delete` - Tự động cập nhật khi xóa

### **ImportDetail → ImportReceipt**
- `after_importdetail_insert` - Tự động cập nhật khi thêm
- `after_importdetail_update` - Tự động cập nhật khi sửa
- `after_importdetail_delete` - Tự động cập nhật khi xóa

**Kết quả:**
- ✅ `Order.totalAmount` luôn chính xác
- ✅ `Invoice.totalValue` luôn đồng bộ
- ✅ `ImportReceipt.totalValue` luôn đúng

## 📊 CƠ SỞ DỮ LIỆU

### **Các bảng chính:**

**Quản lý người dùng:**
- `User` - Thông tin user
- `Customer` - Khách hàng (kế thừa User)
- `Employee` - Nhân viên (kế thừa User)
- `Manager` - Quản lý (kế thừa Employee)
- `SaleStaff` - Nhân viên bán hàng (kế thừa Employee)

**Quản lý sản phẩm:**
- `Product` - Sản phẩm
- `Supplier` - Nhà cung cấp

**Quản lý nhập hàng:**
- `ImportReceipt` - Phiếu nhập hàng
- `ImportDetail` - Chi tiết phiếu nhập

**Quản lý bán hàng:**
- `Order` - Đơn hàng
- `OrderDetail` - Chi tiết đơn hàng
- `Invoice` - Hóa đơn

## 🎯 TÍNH NĂNG

### **Đã triển khai:**
- ✅ Đăng nhập / Đăng ký
- ✅ Xem danh sách hóa đơn
- ✅ Xem chi tiết hóa đơn
- ✅ Thống kê nhà cung cấp
- ✅ Xem chi tiết phiếu nhập
- ✅ Trigger tự động cập nhật totalAmount/totalValue

### **Đang phát triển:**
- 🔨 Quản lý đơn hàng (thêm/sửa/xóa)
- 🔨 Quản lý nhập hàng
- 🔨 Báo cáo thống kê

## 📝 GHI CHÚ QUAN TRỌNG

### **Về Database:**
1. Database tên: `pttk`
2. Mật khẩu MySQL mặc định: `123` (cần thay đổi trong DatabaseUtil.java)
3. Dữ liệu mẫu đã được thêm sẵn

### **Về Trigger:**
1. Trigger được tạo tự động khi chạy `scripts.sql`
2. Nếu cần cài riêng, dùng `add_triggers.sql`
3. Trigger đảm bảo dữ liệu luôn chính xác

### **Về Web App:**
1. Chạy trên Tomcat 7
2. Port mặc định: 8080
3. Context path: `/MyWebApp`

## 🔗 TÀI LIỆU THAM KHẢO

- **Hướng dẫn sử dụng:** `HUONG_DAN_SU_DUNG.md`
- **Lịch sử thay đổi:** `THAY_DOI_LOGIC.md`
- **Hướng dẫn trigger:** `TRIGGER_INSTALLATION_GUIDE.md`

## 📧 LIÊN HỆ

Nếu có vấn đề, vui lòng kiểm tra các file hướng dẫn hoặc tham khảo code trong `MyWebApp/src/`.

---

**Version:** 1.0  
**Last Updated:** November 8, 2025
