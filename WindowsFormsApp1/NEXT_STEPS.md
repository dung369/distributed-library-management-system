# 📋 CÁC BƯỚC TIẾP THEO

## ✅ Hoàn thành

- ✅ Đã tạo 3 SQL Server instances (ports 1436/1437/1438)
- ✅ Đã tạo 8 SQL scripts (01-08, bao gồm 07A xóa dữ liệu cũ)
- ✅ Đã xây dựng 13 forms Windows (FormMain + 5 CRUD + 3 Query + FormAbout)
- ✅ Đã fix tất cả lỗi biên dịch (CS0111, CS0260, CS0103, CS0029)
- ✅ Đã implement FormQuery3 với chức năng toggle bidirectional (T1↔T2)
- ✅ Đã xóa các file không cần thiết (Form1, InsertSampleData.cs)
- ✅ Đã chuyển sang phương pháp insert dữ liệu bằng SQL scripts (07_InsertData.sql)
- ✅ Đã tạo cấu trúc báo cáo (BAO_CAO_DO_AN.md, BAO_CAO_CHUONG_2.md)

---

## 🔜 CẦN LÀM TIẾP

### ⚡ BƯỚC 1: Test Unicode Encoding (QUAN TRỌNG NHẤT!)

**Mục tiêu:** Đảm bảo tiếng Việt hiển thị 100% chính xác

**Các bước thực hiện:**

1. **Mở SQL Server Management Studio (SSMS)**

   - Connect đến: `DESKTOP-4EOK9DU\SQLEXPRESS06,1436`
   - Authentication: SQL Server
   - Login: sa
   - Password: 123456

2. **Xóa dữ liệu cũ (nếu có)**

   ```sql
   -- File → Open → Chọn "07A_XoaDuLieuCu.sql"
   -- Nhấn F5 để execute
   ```

3. **Insert dữ liệu mẫu mới**

   ```sql
   -- File → Open → Chọn "07_InsertData.sql"
   -- Nhấn F5 để execute
   ```

4. **Kiểm tra kết quả trong SSMS**

   ```sql
   SELECT * FROM V_NhaXB ORDER BY SiteLocation
   -- Phải thấy: "Giáo dục", "Trẻ", "KHKT", "Đại học Quốc Gia"
   -- KHÔNG được thấy: "Gi��o d???c", "Tr���", v.v.

   SELECT * FROM V_TacGia ORDER BY SiteLocation
   -- Phải thấy: "Nguyễn Văn A", "Trần Thị B", "Lê Văn C", "Phạm Thị D"

   SELECT * FROM V_DocGia ORDER BY SiteLocation
   -- Phải thấy: "Hoàng Văn Nam", "Nguyễn Thị Lan", v.v.

   SELECT * FROM V_Sach ORDER BY MaSach
   -- Phải thấy: "Cơ sở Điện tử", "Lập trình C++", v.v.
   ```

5. **Chạy Windows Forms Application**

   - Mở Visual Studio
   - Nhấn F5 để build và run
   - Vào menu: **Quản lý danh mục → Nhà xuất bản**
   - Kiểm tra DataGridView:
     - ✅ TenNXB phải hiển thị: "Giáo dục", "Trẻ", "KHKT", "Đại học Quốc Gia"
     - ✅ ThanhPho phải hiển thị: "T1", "T2"
     - ✅ SiteLocation phải hiển thị: "Site1", "Site2"

6. **Test thêm/sửa dữ liệu có dấu**

   - Trong form Nhà xuất bản, click "Thêm mới"
   - Nhập: MaNXB = "NXB99", TenNXB = "Văn hóa Sài Gòn", ThanhPho = "T1"
   - Click "Lưu"
   - Kiểm tra lại DataGridView → phải thấy "Văn hóa Sài Gòn" chính xác

7. **Test FormQuery1 với tên có dấu**
   - Vào menu: **Truy vấn toàn cục → Query 1**
   - Chọn ComboBox: "Giáo dục" (có dấu!)
   - Click "Thực hiện"
   - Phải thấy kết quả không lỗi

**Kết quả mong đợi:**

- ✅ Tất cả chữ tiếng Việt hiển thị chính xác trong SSMS
- ✅ Tất cả chữ tiếng Việt hiển thị chính xác trong Windows Forms
- ✅ Không có ký tự lỗi kiểu: ���, Ã, Ä, â€¦, v.v.

**Nếu vẫn bị lỗi encoding:**

- Đọc file `HUONG_DAN_INSERT_UNICODE.md`
- Báo cáo lỗi cụ thể: ký tự nào bị lỗi, ở đâu (SSMS hay app)

---

### 📝 BƯỚC 2: Hoàn thiện Báo cáo (Chương 3-6)

**File cần tạo:** `BAO_CAO_CHUONG_3_6.md`

**Nội dung cần viết:**

#### **Chương 3: Quy trình thực hiện (8-10 trang)**

- 3.1. Phân công nhiệm vụ (bảng: Thành viên, Công việc, Tiến độ)
- 3.2. Quy trình triển khai hệ thống
  - Sơ đồ workflow: Yêu cầu → Thiết kế → Cài đặt → Test
  - Mô tả từng bước chi tiết
- 3.3. Công cụ và môi trường phát triển
  - SQL Server 2022
  - Visual Studio 2022
  - Windows Forms .NET Framework 4.8
  - ADO.NET SqlClient
- 3.4. Lịch trình thực hiện (Gantt chart hoặc timeline)

#### **Chương 4: Sản phẩm Demo (12-15 trang)**

- 4.1. Kiến trúc hệ thống
  - Sơ đồ 3 tiers: Presentation → Business Logic → Data Access
  - Sơ đồ phân tán: Server mẹ + 2 Sites + Linked Servers
  - Sơ đồ phân mảnh dữ liệu (horizontal fragmentation)
- 4.2. Thiết kế cơ sở dữ liệu
  - Lược đồ toàn cục (global schema): 5 bảng
  - Lược đồ phân mảnh (fragmentation schema): Site1 vs Site2
  - Sơ đồ ER (Entity-Relationship Diagram)
  - Danh sách Stored Procedures (15 SPs)
  - Danh sách Views (5 views)
- 4.3. Giao diện ứng dụng (screenshots)
  - FormMain (menu chính)
  - 5 form CRUD (với ảnh chụp màn hình thực tế)
  - 3 form Query (với ảnh kết quả truy vấn)
  - FormAbout
- 4.4. Hướng dẫn sử dụng
  - Cài đặt SQL Server
  - Chạy 8 scripts theo thứ tự
  - Chạy ứng dụng Windows Forms
  - Demo các chức năng CRUD
  - Demo 3 truy vấn toàn cục

#### **Chương 5: Kết quả và Đánh giá (5-7 trang)**

- 5.1. Kết quả đạt được so với mục tiêu ban đầu
  - ✅ Phân tán dữ liệu: 3 instances SQL Server
  - ✅ Trong suốt phân mảnh: Views UNION ALL
  - ✅ Trong suốt vị trí: Stored Procedures
  - ✅ CRUD hoàn chỉnh: 5 bảng
  - ✅ Truy vấn phân tán: 3 queries
  - ✅ Giao diện thân thiện: Windows Forms
- 5.2. Ưu điểm của giải pháp
  - Scalability: Dễ mở rộng thêm sites
  - Performance: Phân tán load
  - Maintainability: Code rõ ràng, dễ bảo trì
  - User-friendly: Giao diện trực quan
- 5.3. Hạn chế và khó khăn gặp phải
  - Unicode encoding issues (đã fix)
  - Linked Server configuration phức tạp
  - Debugging phân tán khó khăn
  - Transaction consistency across sites
- 5.4. Ứng dụng thực tế
  - Hệ thống thư viện nhiều chi nhánh
  - Chuỗi nhà sách
  - Trường học đa cơ sở

#### **Chương 6: Kết luận và Hướng phát triển (3-5 trang)**

- 6.1. Tổng kết
  - Đồ án đã hoàn thành đầy đủ yêu cầu
  - Minh họa 3 mức trong suốt
  - Demo được CRUD + Queries trên CSDLPT
- 6.2. Bài học kinh nghiệm
  - Kỹ năng: SQL Server, Linked Servers, Windows Forms, ADO.NET
  - Teamwork: Phân công, quản lý tiến độ
  - Problem-solving: Debug lỗi phân tán, Unicode
- 6.3. Hướng phát triển trong tương lai
  - Thêm chức năng: Thống kê, báo cáo, tìm kiếm nâng cao
  - Web-based: Chuyển sang ASP.NET Core
  - Mobile app: Xamarin hoặc React Native
  - Cloud: Deploy lên Azure SQL Database
  - Security: Authentication, Authorization, Encryption
  - Performance: Caching, Indexing, Query optimization

---

### 📊 BƯỚC 3: Tạo Hình ảnh minh họa

**Các sơ đồ cần vẽ:**

1. **Sơ đồ kiến trúc hệ thống**

   - 3 SQL Server instances (vẽ bằng draw.io hoặc Visio)
   - Linked Servers: Mẹ ↔ Site1, Mẹ ↔ Site2
   - Windows Forms App → Connect đến Server mẹ

2. **Sơ đồ phân mảnh dữ liệu**

   - Horizontal Fragmentation:
     - NhaXB: T1 → Site1, T2 → Site2
     - TacGia: Điện tử → Site1, Máy tính → Site2
     - DocGia: HS → Site1, SV → Site2
     - Sach: Derived từ TacGia
     - Muon: Derived từ DocGia

3. **Sơ đồ ER (Entity-Relationship)**

   - 5 entities: NhaXB, TacGia, DocGia, Sach, Muon
   - Relationships: 1-N, N-M

4. **Screenshots ứng dụng**
   - Chụp màn hình FormMain
   - Chụp màn hình 5 form CRUD (mỗi form 2-3 ảnh: danh sách, thêm, sửa)
   - Chụp màn hình 3 form Query (với kết quả thực tế)
   - Paste vào Word với caption: "Hình 4.1: Form Nhà xuất bản"

---

### 📦 BƯỚC 4: Đóng gói dự án

**Cấu trúc thư mục nộp:**

```
DOANPT_Nhom[X]_MSSV/
│
├── 01_SourceCode/
│   ├── WindowsFormsApp1.sln
│   ├── WindowsFormsApp1/
│   │   ├── *.cs files
│   │   ├── SQLScripts/
│   │   └── bin/Debug/WindowsFormsApp1.exe
│   └── README.txt (hướng dẫn chạy code)
│
├── 02_Documentation/
│   ├── BaoCao_DoanPT.docx (30-50 trang, Times New Roman 13pt)
│   ├── BaoCao_DoanPT.pdf
│   ├── README_WINFORMS.md
│   ├── HUONG_DAN_CHAY_SCRIPTS.md
│   └── HUONG_DAN_INSERT_UNICODE.md
│
├── 03_Demo/
│   ├── Screenshots/ (10-15 ảnh)
│   ├── Video_Demo.mp4 (5-10 phút, tùy chọn)
│   └── Slides_Presentation.pptx
│
└── README_SUBMIT.txt (tổng quan về đồ án)
```

**Checklist trước khi nộp:**

- [ ] Source code build thành công (0 errors, 0 warnings)
- [ ] Đã test trên máy sạch (clean machine)
- [ ] Báo cáo Word có đầy đủ 6 chương
- [ ] Báo cáo có danh sách hình ảnh, bảng biểu
- [ ] Báo cáo có tài liệu tham khảo (IEEE format)
- [ ] File .exe chạy được standalone
- [ ] SQL scripts đầy đủ 8 files
- [ ] README hướng dẫn cài đặt đầy đủ
- [ ] Screenshots rõ nét, có caption

---

## ⚠️ LƯU Ý QUAN TRỌNG

### 1. Unicode Encoding

- **LUÔN LUÔN** dùng N'' prefix cho chuỗi tiếng Việt trong SQL
  ```sql
  EXEC SP_INSERT_NHAXB 'NXB01', N'Giáo dục', N'T1'  -- ĐÚNG ✅
  EXEC SP_INSERT_NHAXB 'NXB01', 'Giáo dục', 'T1'    -- SAI ❌
  ```
- Khuyến nghị dùng SSMS để chạy `07_InsertData.sql`
- Nếu dùng sqlcmd có thể gặp lỗi encoding → Chuyển sang SSMS

### 2. Thứ tự chạy Scripts

```
Bắt buộc theo thứ tự: 01 → 02 → 03 → 04 → 05 → 06
Insert dữ liệu: 07A (xóa cũ) → 07 (insert mới)
Test: 08 (tùy chọn)
```

### 3. Kết nối Database

- Port 1436: Server mẹ (ThuVien_Central)
- Port 1437: Site 1 (ThuVien_Site1)
- Port 1438: Site 2 (ThuVien_Site2)
- Linked Server names: `SITE1_SERVER`, `SITE2_SERVER` (KHÔNG phải IP)

### 4. Validation Logic

- NhaXB.ThanhPho ∈ {'T1', 'T2'}
- TacGia.ChuyenMon ∈ {'Điện tử', 'Máy tính'}
- DocGia.DoiTuong ∈ {'HS', 'SV'}
- Sach.NamXB: 1900 ≤ năm ≤ năm hiện tại
- Muon: NgayTra > NgayMuon

---

## 🎯 Ưu tiên thực hiện

| Ưu tiên        | Bước                       | Ước lượng thời gian |
| -------------- | -------------------------- | ------------------- |
| **CAO NHẤT**   | 1. Test Unicode Encoding   | 30 phút             |
| **CAO**        | 2. Viết Chương 3-6 báo cáo | 4-6 giờ             |
| **TRUNG BÌNH** | 3. Tạo sơ đồ, screenshots  | 2-3 giờ             |
| **THẤP**       | 4. Đóng gói, kiểm tra cuối | 1 giờ               |

**Tổng thời gian ước lượng:** 8-11 giờ

---

## 📞 Khi gặp vấn đề

1. **Build lỗi**: Xóa `bin/` và `obj/`, rebuild (Ctrl+Shift+B)
2. **Kết nối lỗi**: Kiểm tra SQL Server services, firewall, TCP/IP enabled
3. **Unicode lỗi**: Dùng SSMS thay vì sqlcmd, kiểm tra N'' prefix
4. **Linked Server lỗi**: Chạy lại `04_Server_Me_LinkedServers.sql`
5. **Data lỗi**: Chạy `07A_XoaDuLieuCu.sql` → `07_InsertData.sql`

---

**Bắt đầu ngay từ BƯỚC 1! Test Unicode là quan trọng nhất! 🚀**
