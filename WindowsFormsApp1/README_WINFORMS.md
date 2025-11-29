# 📚 HỆ THỐNG QUẢN LÝ THƯ VIỆN PHÂN TÁN

## 🎯 Giới thiệu đề tài

Đề tài mô phỏng hệ thống **quản lý thư viện phân tán**, bao gồm nhà xuất bản, sách, tác giả, độc giả và việc mượn sách. Ứng dụng được triển khai trong môi trường cơ sở dữ liệu phân tán trên **SQL Server**, cho phép người dùng thực hiện CRUD và 3 truy vấn toàn cục minh họa các mức trong suốt.

---

## 📊 Lược đồ cơ sở dữ liệu (Global Schema)

```sql
NhaXB(MaNXB, TenNXB, ThanhPho)
Sach(MaSach, TenSach, NamXB, MaNXB, MaTG)
DocGia(MaDG, TenDG, DoiTuong)
TacGia(MaTG, TenTG, ChuyenMon)
Muon(MaDG, MaSach, NgayMuon, NgayTra)
```

### Ý nghĩa các bảng:

- **NhaXB**: Thông tin nhà xuất bản (mã, tên, thành phố).
- **Sach**: Thông tin sách (mã, tên, năm xuất bản, nhà xuất bản, tác giả).
- **DocGia**: Thông tin độc giả (mã, tên, đối tượng: HS/SV).
- **TacGia**: Thông tin tác giả (mã, tên, chuyên môn: Điện tử hoặc Máy tính).
- **Muon**: Quan hệ giữa độc giả và sách, gồm ngày mượn và ngày trả.

### Ràng buộc chính:

- `Sach.MaNXB` → `NhaXB.MaNXB`
- `Sach.MaTG` → `TacGia.MaTG`
- `Muon.MaDG` → `DocGia.MaDG`
- `Muon.MaSach` → `Sach.MaSach`

---

## 🏗️ Mô hình triển khai

- **Hệ quản trị CSDL**: SQL Server 2022
- **Kiến trúc**: 3 SQL Server Instances (SQLEXPRESS06, SQLEXPRESS07, SQLEXPRESS08)
  - **SQLEXPRESS06** (Port 1436): Server mẹ - chứa views toàn cục và stored procedures
  - **SQLEXPRESS07** (Port 1437): Site 1 - chứa dữ liệu mảnh 1
  - **SQLEXPRESS08** (Port 1438): Site 2 - chứa dữ liệu mảnh 2
- **Công nghệ kết nối**: Linked Servers
- **Ứng dụng**: Windows Forms (.NET Framework 4.8)
- **Phân mảnh dữ liệu**:
  - NhaXB: Theo ThanhPho ('T1' → Site1, 'T2' → Site2)
  - TacGia: Theo ChuyenMon ('Điện tử' → Site1, 'Máy tính' → Site2)
  - DocGia: Theo DoiTuong ('HS' → Site1, 'SV' → Site2)
  - Sach: Derived từ TacGia (theo vị trí của tác giả)
  - Muon: Derived từ DocGia (theo vị trí của độc giả)

---

## 💻 Ứng dụng Windows Forms

### Chức năng chính:

#### 🔹 5 Form CRUD (Quản lý danh mục)

| Form                  | Bảng tương ứng | Chức năng chính                                      |
| --------------------- | -------------- | ---------------------------------------------------- |
| **Form Nhà xuất bản** | NhaXB          | Thêm, sửa, xóa, xem danh sách nhà xuất bản           |
| **Form Sách**         | Sach           | Quản lý sách (tích hợp ComboBox chọn NXB và Tác giả) |
| **Form Tác giả**      | TacGia         | Quản lý tác giả với validation chuyên môn            |
| **Form Độc giả**      | DocGia         | Quản lý độc giả với validation đối tượng HS/SV       |
| **Form Mượn sách**    | Muon           | Quản lý phiếu mượn trả với DateTimePicker            |

**Đặc điểm kỹ thuật:**

- Tất cả CRUD thực hiện qua **Stored Procedures** (SP*INSERT*_, SP*UPDATE*_, SP*DELETE*\*)
- View toàn cục (V\_\*) tự động gộp dữ liệu từ 2 sites bằng **UNION ALL**
- Hiển thị cột **SiteLocation** để biết dữ liệu đến từ site nào
- Validation logic: Kiểm tra giá trị phân mảnh (T1/T2, HS/SV, Điện tử/Máy tính)

#### 🔹 3 Form Truy vấn toàn cục

**Query 1: Số lượng sách năm 1998 theo nhà xuất bản**

- **Input**: TextBox nhập tên nhà xuất bản
- **Output**: Tổng số sách khác nhau năm 1998
- **SQL**: `SP_Query1_SachNam1998`
  ```sql
  SELECT COUNT(DISTINCT s.TenSach) AS SoLuongSach
  FROM V_Sach s
  JOIN V_NhaXB n ON s.MaNXB = n.MaNXB
  WHERE n.TenNXB = @TenNXB AND s.NamXB = 1998
  ```

**Query 2: Sách của tác giả được mượn trong khoảng thời gian**

- **Input**: ComboBox chọn tác giả
- **Output**: Danh sách sách được mượn từ 01/01/1999 - 30/06/1999
- **SQL**: `SP_Query2_SachTacGiaMuon`
  ```sql
  SELECT DISTINCT s.MaSach, s.TenSach
  FROM V_Sach s
  JOIN V_Muon m ON s.MaSach = m.MaSach
  WHERE s.MaTG = @MaTG
    AND m.NgayMuon BETWEEN '1999-01-01' AND '1999-06-30'
  ```

**Query 3: Cập nhật thành phố NXB KHKT**

- **Mô tả**: Sửa thành phố từ 'T2' thành 'T1' cho NXB 'KHKT'
- **Chức năng**: Button "Thực hiện" → Hiển thị trước/sau cập nhật
- **SQL**: `SP_Query3_UpdateThanhPhoKHKT`
  ```sql
  UPDATE SITE2_SERVER.ThuVien_Site2.dbo.NhaXB_Site2
  SET ThanhPho = N'T1'
  WHERE TenNXB = N'KHKT' AND ThanhPho = N'T2'
  ```

---

## 🔍 Mức trong suốt được thể hiện

| Mức                      | Ý nghĩa                                              | Biểu hiện trong đồ án                                                                               |
| ------------------------ | ---------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| **Trong suốt phân mảnh** | Người dùng thao tác như thể chỉ có một bảng duy nhất | Các view toàn cục (V_NhaXB, V_Sach, V_TacGia, V_DocGia, V_Muon) sử dụng UNION ALL                   |
| **Trong suốt vị trí**    | Người dùng không cần biết dữ liệu ở site nào         | View tham chiếu trực tiếp: `SITE1_SERVER.ThuVien_Site1.dbo.*` và `SITE2_SERVER.ThuVien_Site2.dbo.*` |
| **Trong suốt sao chép**  | Xử lý dữ liệu phân tán tự động                       | Stored Procedures tự động định tuyến INSERT/UPDATE/DELETE đến đúng site                             |

---

## 🚀 Cách sử dụng ứng dụng

### Bước 1: Cài đặt cơ sở dữ liệu

1. Làm theo hướng dẫn trong `SQLScripts/HUONG_DAN_CHAY_SCRIPTS.md`
2. Đảm bảo chạy đủ 6 scripts cơ bản theo đúng thứ tự (01-06)
3. **Insert dữ liệu mẫu**:
   - Chạy `07A_XoaDuLieuCu.sql` (xóa dữ liệu cũ - nếu cần)
   - Chạy `07_InsertData.sql` (insert 4 NXB + 4 TG + 4 DG + 5 Sach + 5 Muon)
   - **Khuyến nghị**: Dùng SQL Server Management Studio để tránh lỗi encoding
4. Kiểm tra dữ liệu: `SELECT * FROM V_NhaXB` → phải có 4 rows với tiếng Việt hiển thị chính xác

### Bước 2: Cấu hình kết nối

1. Mở file `DatabaseHelper.cs`
2. Kiểm tra connection string:
   ```csharp
   private static string connectionString =
       @"Data Source=DESKTOP-4EOK9DU\SQLEXPRESS06,1436;
         Initial Catalog=ThuVien_Central;
         User ID=sa;Password=123456;";
   ```
3. Thay đổi tên máy và mật khẩu nếu cần

### Bước 3: Chạy ứng dụng

1. Build solution trong Visual Studio (Ctrl+Shift+B)
2. Run ứng dụng (F5)
3. Menu chính sẽ hiển thị 4 menu:
   - **Hệ thống**: Giới thiệu đề tài, Thoát
   - **Quản lý danh mục**: 5 form CRUD
   - **Truy vấn toàn cục**: 3 query đặc biệt
   - **Thoát**: Đóng ứng dụng

### Bước 4: Thử nghiệm

1. **Kiểm tra dữ liệu mẫu**:
   - Vào form Nhà xuất bản → Xem danh sách → Phải có 4 NXB (Giáo dục, Trẻ, KHKT, Đại học Quốc Gia)
   - Kiểm tra tiếng Việt hiển thị chính xác (không bị ���, Ã, Ä, v.v.)
2. **Test CRUD**: Mở form Nhà xuất bản → Thêm/Sửa/Xóa
3. **Test Query**: Chạy Query 1 với tên NXB "Giáo dục" (có dấu!)
4. **Kiểm tra phân tán**: Xem cột "SiteLocation" trong DataGridView
5. **Test Query 3**: Toggle NXB KHKT từ T1↔T2 (bidirectional)

---

## 📂 Cấu trúc project

```
WindowsFormsApp1/
│
├── SQLScripts/                     # Thư mục SQL Scripts
│   ├── 00_README.txt              # Hướng dẫn tổng quan
│   ├── 01_Server_Con1_CreateDB.sql # Tạo DB trên Site1
│   ├── 02_Server_Con2_CreateDB.sql # Tạo DB trên Site2
│   ├── 03_Server_Me_CreateDB.sql   # Tạo DB trên Server mẹ
│   ├── 04_Server_Me_LinkedServers.sql # Cấu hình Linked Servers
│   ├── 05_Server_Me_Views_And_Triggers.sql # Views toàn cục
│   ├── 06_Server_Me_StoredProcedures.sql # Stored Procedures
│   ├── 07_InsertData.sql           # Dữ liệu mẫu
│   ├── 08_TestQueries.sql          # Test 3 queries
│   ├── 09_KiemTraNhanh.sql         # Kiểm tra nhanh hệ thống
│   ├── 10_KiemTraVaFixLoi.sql      # Chẩn đoán lỗi
│   ├── CauHinhFirewall.bat         # Mở firewall ports
│   ├── KiemTraServices.ps1         # Kiểm tra SQL Services
│   └── HUONG_DAN_CHAY_SCRIPTS.md   # Hướng dẫn chi tiết
│
├── DatabaseHelper.cs               # Class kết nối CSDL
├── FormMain.cs                     # Form menu chính
├── FormAbout.cs                    # Form giới thiệu đề tài
│
├── Forms CRUD/
│   ├── FormNhaXB.cs               # Quản lý Nhà xuất bản
│   ├── FormSach.cs                # Quản lý Sách
│   ├── FormMuon.cs                # Quản lý Mượn sách
│   └── FormsOther.cs              # FormTacGia, FormDocGia
│
├── Forms Query/
│   ├── FormQuery1.cs              # Query số lượng sách 1998
│   ├── FormQuery2.cs              # Query sách tác giả mượn
│   └── FormQuery3.cs              # Query update thành phố NXB
│
├── App.config                      # Configuration file
├── Program.cs                      # Entry point
└── README_WINFORMS.md             # File này

```

---

## 🎓 Kết quả đạt được

✅ **Phân tán dữ liệu**: 3 instances SQL Server với Linked Servers  
✅ **Trong suốt phân mảnh**: View toàn cục UNION ALL  
✅ **Trong suốt vị trí**: Stored Procedures tự động định tuyến  
✅ **CRUD hoàn chỉnh**: 5 bảng với đầy đủ thao tác  
✅ **Truy vấn phân tán**: 3 queries minh họa JOIN qua nhiều sites  
✅ **Giao diện thân thiện**: Windows Forms trực quan, dễ sử dụng  
✅ **Validation dữ liệu**: Kiểm tra ràng buộc phân mảnh  
✅ **Documentation**: Hướng dẫn đầy đủ SQL + Application

---

## 🛠️ Công nghệ sử dụng

- **Database**: SQL Server 2022
- **Language**: C# (.NET Framework 4.8)
- **UI**: Windows Forms
- **Data Access**: ADO.NET (SqlClient)
- **Architecture**: 3-tier (Presentation → Business Logic → Data Access)
- **Distributed Tech**: Linked Servers, Views, Stored Procedures

---

## 👨‍💻 Tác giả

**Đồ án môn học 10: Cơ sở dữ liệu phân tán**  
Năm học: 2024-2025

---

## 📞 Hỗ trợ

Nếu gặp vấn đề khi triển khai, vui lòng:

1. Đọc kỹ file `HUONG_DAN_CHAY_SCRIPTS.md`
2. Chạy script `10_KiemTraVaFixLoi.sql` để chẩn đoán
3. Kiểm tra phần "Xử lý lỗi thường gặp" trong hướng dẫn
