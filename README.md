# 📚 HỆ THỐNG QUẢN LÝ THƯ VIỆN PHÂN TÁN

> **Đề tài:** Xây dựng hệ thống quản lý thư viện phân tán với SQL Server và Windows Forms  
> **Công nghệ:** SQL Server 2022 + .NET Framework 4.8 + Windows Forms  
> **Kiến trúc:** 3-Tier Architecture với Distributed Database  

---

## 📋 MỤC LỤC

- [1. Giới thiệu](#1-giới-thiệu)
- [2. Kiến trúc hệ thống](#2-kiến-trúc-hệ-thống)
- [3. Lược đồ cơ sở dữ liệu](#3-lược-đồ-cơ-sở-dữ-liệu)
- [4. Phân mảnh dữ liệu](#4-phân-mảnh-dữ-liệu)
- [5. Cấu trúc dự án](#5-cấu-trúc-dự-án)
- [6. Chức năng hệ thống](#6-chức-năng-hệ-thống)
- [7. Cài đặt và triển khai](#7-cài-đặt-và-triển-khai)
- [8. Hướng dẫn sử dụng](#8-hướng-dẫn-sử-dụng)
- [9. Kỹ thuật sử dụng](#9-kỹ-thuật-sử-dụng)

---

## 1. GIỚI THIỆU

### 1.1. Mục tiêu đề tài

Xây dựng hệ thống quản lý thư viện phân tán cho phép:
- Quản lý thông tin nhà xuất bản, sách, tác giả, độc giả
- Quản lý việc mượn/trả sách
- Thực hiện các truy vấn phân tán đa site
- Minh họa các mức trong suốt của CSDL phân tán

### 1.2. Đặc điểm nổi bật

✅ **Phân tán dữ liệu**: Dữ liệu được phân mảnh ngang trên 2 sites  
✅ **Trong suốt phân mảnh**: Người dùng không cần biết dữ liệu lưu ở đâu  
✅ **Stored Procedures**: Toàn bộ logic CRUD qua stored procedures  
✅ **Linked Servers**: Kết nối giữa các SQL Server instances  
✅ **Unicode hỗ trợ**: Đầy đủ tiếng Việt có dấu  

---

## 2. KIẾN TRÚC HỆ THỐNG

### 2.1. Kiến trúc 3-Tier

```
┌─────────────────────────────────────────────────────────┐
│         PRESENTATION LAYER (Client)                      │
│         Windows Forms Application                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌─────────┐│
│  │FormNhaXB │  │FormSach  │  │FormMuon  │  │Queries  ││
│  └──────────┘  └──────────┘  └──────────┘  └─────────┘│
└───────────────────────┬─────────────────────────────────┘
                        │ ADO.NET
┌───────────────────────▼─────────────────────────────────┐
│      APPLICATION/BUSINESS LOGIC LAYER                    │
│      SQL Server Central (Port 1436)                      │
│      ┌────────────────────────────────────────────┐    │
│      │ Stored Procedures (15 SPs)                 │    │
│      │ Global Views (5 Views)                     │    │
│      │ Linked Servers (SITE1_SERVER, SITE2_SERVER)│    │
│      └────────────────────────────────────────────┘    │
└─────────────┬─────────────────────┬─────────────────────┘
              │                     │
┌─────────────▼──────────┐   ┌────▼──────────────────────┐
│   DATA LAYER (Site 1)  │   │   DATA LAYER (Site 2)     │
│   SQL Server (Port 1437)│   │   SQL Server (Port 1438)  │
│   Database: ThuVien_Site1│  │ Database: ThuVien_Site2  │
│   - NhaXB_Site1         │   │   - NhaXB_Site2          │
│   - TacGia_Site1        │   │   - TacGia_Site2         │
│   - Sach_Site1          │   │   - Sach_Site2           │
│   - DocGia_Site1        │   │   - DocGia_Site2         │
│   - Muon_Site1          │   │   - Muon_Site2           │
└─────────────────────────┘   └──────────────────────────┘
```

### 2.2. Các SQL Server Instances

| Instance | Port | Database | Vai trò |
|----------|------|----------|---------|
| SQLEXPRESS06 | 1436 | ThuVien_Central | Server Mẹ - Views, SPs, Linked Servers |
| SQLEXPRESS07 | 1437 | ThuVien_Site1 | Site 1 - Mảnh 1 (T1, Điện tử, HS) |
| SQLEXPRESS08 | 1438 | ThuVien_Site2 | Site 2 - Mảnh 2 (T2, Máy tính, SV) |

---

## 3. LƯỢC ĐỒ CƠ SỞ DỮ LIỆU

### 3.1. Global Schema

```sql
NhaXB(MaNXB, TenNXB, ThanhPho)
    - MaNXB: char(5), PRIMARY KEY
    - TenNXB: nvarchar(50), NOT NULL
    - ThanhPho: nvarchar(30), NOT NULL ('T1' hoặc 'T2')

TacGia(MaTG, TenTG, ChuyenMon)
    - MaTG: char(5), PRIMARY KEY
    - TenTG: nvarchar(50), NOT NULL
    - ChuyenMon: nvarchar(30), NOT NULL ('Điện tử' hoặc 'Máy tính')

DocGia(MaDG, TenDG, DoiTuong)
    - MaDG: char(5), PRIMARY KEY
    - TenDG: nvarchar(50), NOT NULL
    - DoiTuong: nvarchar(10), NOT NULL ('HS' hoặc 'SV')

Sach(MaSach, TenSach, NamXB, MaNXB, MaTG)
    - MaSach: char(5), PRIMARY KEY
    - TenSach: nvarchar(100), NOT NULL
    - NamXB: int, NOT NULL
    - MaNXB: char(5), FOREIGN KEY → NhaXB(MaNXB)
    - MaTG: char(5), FOREIGN KEY → TacGia(MaTG)

Muon(MaDG, MaSach, NgayMuon, NgayTra)
    - MaDG: char(5), FOREIGN KEY → DocGia(MaDG)
    - MaSach: char(5), FOREIGN KEY → Sach(MaSach)
    - NgayMuon: datetime, NOT NULL
    - NgayTra: datetime, NULL
    - PRIMARY KEY (MaDG, MaSach, NgayMuon)
```

### 3.2. Quan hệ giữa các bảng

```
TacGia ────┐
           │
           ├──► Sach ────► Muon ◄──── DocGia
           │
NhaXB ─────┘
```

---

## 4. PHÂN MẢNH DỮ LIỆU

### 4.1. Chiến lược phân mảnh

| Bảng | Loại phân mảnh | Thuộc tính | Site 1 | Site 2 |
|------|----------------|------------|--------|--------|
| **NhaXB** | Horizontal (Primary) | ThanhPho | T1 | T2 |
| **TacGia** | Horizontal (Primary) | ChuyenMon | Điện tử | Máy tính |
| **DocGia** | Horizontal (Primary) | DoiTuong | HS | SV |
| **Sach** | Horizontal (Derived) | Theo TacGia | TG ở Site1 | TG ở Site2 |
| **Muon** | Horizontal (Derived) | Theo DocGia | DG ở Site1 | DG ở Site2 |

### 4.2. Ví dụ phân mảnh

**Site 1 (ThuVien_Site1):**
- NXB01 (Giáo dục, T1)
- NXB02 (Trẻ, T1)
- TG01 (Nguyễn Văn A, Điện tử)
- TG02 (Trần Thị B, Điện tử)
- DG01 (Học sinh Nguyễn C, HS)
- DG02 (Học sinh Lê D, HS)

**Site 2 (ThuVien_Site2):**
- NXB03 (KHKT, T2)
- NXB04 (Đại học Quốc Gia, T2)
- TG03 (Phạm Văn C, Máy tính)
- TG04 (Hoàng Thị D, Máy tính)
- DG03 (Sinh viên Mai E, SV)
- DG04 (Sinh viên Văn F, SV)

---

## 5. CẤU TRÚC DỰ ÁN

### 5.1. Cấu trúc thư mục

```
WindowsFormsApp1/
├── SQLScripts/                          # SQL Scripts
│   ├── 01_Server_Con1_CreateDB.sql     # Tạo DB Site 1
│   ├── 02_Server_Con2_CreateDB.sql     # Tạo DB Site 2
│   ├── 03_Server_Me_CreateDB.sql       # Tạo DB Central
│   ├── 04_Server_Me_LinkedServers.sql  # Cấu hình Linked Servers
│   ├── 05_Server_Me_Views_And_Triggers.sql  # Tạo Views
│   ├── 06_Server_Me_StoredProcedures.sql    # Tạo 18 SPs
│   ├── 07_InsertData.sql               # Insert dữ liệu mẫu
│   ├── 07A_XoaDuLieuCu.sql            # Xóa dữ liệu cũ
│   ├── 07B_FixUnicode.sql             # Fix Unicode
│   ├── 13_TestAll_Complete.sql        # Test queries
│   ├── 14_Enable_Remote_Access_All_Servers.sql  # Remote access
│   └── Update_SP_DELETE_NHAXB.sql     # Update SP xóa NXB
│
├── Properties/                          # Assembly Info
│   ├── AssemblyInfo.cs
│   ├── Resources.Designer.cs
│   └── Settings.Designer.cs
│
├── bin/Debug/                           # Build output
├── obj/Debug/                           # Temporary build files
│
├── App.config                           # App configuration
├── DatabaseHelper.cs                    # Database access layer
├── FormMain.cs                          # Main menu form
├── FormNhaXB.cs                         # CRUD Nhà xuất bản
├── FormTacGia.cs                        # CRUD Tác giả (chưa hoàn thiện)
├── FormSach.cs                          # CRUD Sách
├── FormDocGia.cs                        # CRUD Độc giả (chưa hoàn thiện)
├── FormMuon.cs                          # CRUD Mượn sách
├── FormQuery1.cs                        # Query 1: Sách năm 1998
├── FormQuery2.cs                        # Query 2: Sách tác giả mượn
├── FormQuery3.cs                        # Query 3: Update thành phố KHKT
├── FormsOther.cs                        # Forms khác (stub)
├── FormAbout.cs                         # About form
├── Program.cs                           # Entry point
│
├── README.md                            # File này
├── README_WINFORMS.md                   # Hướng dẫn chi tiết
├── PROJECT_STATUS.md                    # Trạng thái dự án
├── CAC_BUOC_CHUAN_BI.md                # Hướng dẫn chuẩn bị
├── SO_DO_CAU_TRUC_HE_THONG.md          # Sơ đồ hệ thống
├── HUONG_DAN_GUI_APP.md                # Hướng dẫn gửi app
├── HUONG_DAN_INSERT_UNICODE.md         # Hướng dẫn Unicode
├── NEXT_STEPS.md                        # Các bước tiếp theo
└── SUMMARY_CHANGES.md                   # Tóm tắt thay đổi
```

### 5.2. Các file SQL Scripts

| File | Mô tả | Chạy trên |
|------|-------|-----------|
| 01_Server_Con1_CreateDB.sql | Tạo database ThuVien_Site1 | SQLEXPRESS07:1437 |
| 02_Server_Con2_CreateDB.sql | Tạo database ThuVien_Site2 | SQLEXPRESS08:1438 |
| 03_Server_Me_CreateDB.sql | Tạo database ThuVien_Central | SQLEXPRESS06:1436 |
| 04_Server_Me_LinkedServers.sql | Tạo Linked Servers | SQLEXPRESS06:1436 |
| 05_Server_Me_Views_And_Triggers.sql | Tạo 5 Views toàn cục | SQLEXPRESS06:1436 |
| 06_Server_Me_StoredProcedures.sql | Tạo 18 Stored Procedures | SQLEXPRESS06:1436 |
| 07_InsertData.sql | Insert dữ liệu mẫu | SQLEXPRESS06:1436 |

### 5.3. Các Windows Forms

| Form | Chức năng | Trạng thái |
|------|-----------|------------|
| FormMain.cs | Menu chính | ✅ Hoàn thành |
| FormNhaXB.cs | CRUD Nhà xuất bản | ✅ Hoàn thành |
| FormSach.cs | CRUD Sách | ✅ Hoàn thành |
| FormMuon.cs | CRUD Mượn sách | ✅ Hoàn thành |
| FormQuery1.cs | Query sách năm 1998 | ✅ Hoàn thành |
| FormQuery2.cs | Query sách tác giả mượn | ✅ Hoàn thành |
| FormQuery3.cs | Update thành phố KHKT | ✅ Hoàn thành |
| FormAbout.cs | Thông tin về | ✅ Hoàn thành |
| FormTacGia.cs | CRUD Tác giả | ⚠️ Stub |
| FormDocGia.cs | CRUD Độc giả | ⚠️ Stub |

---

## 6. CHỨC NĂNG HỆ THỐNG

### 6.1. Quản lý Nhà Xuất Bản (FormNhaXB)

**Chức năng:**
- ✅ Xem danh sách NXB từ cả 2 sites
- ✅ Thêm NXB mới (tự động phân mảnh theo thành phố)
- ✅ Sửa thông tin NXB
- ✅ Xóa NXB (cascade delete: xóa cả sách và phiếu mượn liên quan)

**Stored Procedures:**
- `SP_INSERT_NHAXB`: Insert vào Site1 nếu T1, Site2 nếu T2
- `SP_UPDATE_NHAXB`: Update ở site tương ứng
- `SP_DELETE_NHAXB`: Xóa cascade (Muon → Sach → NXB)

### 6.2. Quản lý Sách (FormSach)

**Chức năng:**
- ✅ Xem danh sách sách từ cả 2 sites
- ✅ Thêm sách mới (tự động phân mảnh theo tác giả)
- ✅ Sửa thông tin sách
- ✅ Xóa sách (cascade delete: xóa cả phiếu mượn)

**Stored Procedures:**
- `SP_INSERT_SACH`: Insert vào site của tác giả
- `SP_UPDATE_SACH`: Update ở site tương ứng
- `SP_DELETE_SACH`: Xóa cascade (Muon → Sach)

### 6.3. Quản lý Mượn Sách (FormMuon)

**Chức năng:**
- ✅ Xem danh sách phiếu mượn từ cả 2 sites
- ✅ Thêm phiếu mượn mới (tự động phân mảnh theo độc giả)
- ✅ Sửa thông tin phiếu mượn
- ✅ Xóa phiếu mượn

**Stored Procedures:**
- `SP_INSERT_MUON`: Insert vào site của độc giả
- `SP_UPDATE_MUON`: Update ở site tương ứng
- `SP_DELETE_MUON`: Delete ở site tương ứng

### 6.4. Truy vấn 1: Sách xuất bản năm 1998 (FormQuery1)

**Mô tả:** Tìm tất cả sách xuất bản năm 1998 trên cả 2 sites

**Mức trong suốt:** Trong suốt phân mảnh

**Query:**
```sql
SELECT MaSach, TenSach, NamXB, MaNXB, MaTG, SiteLocation
FROM V_Sach
WHERE NamXB = 1998
ORDER BY TenSach
```

### 6.5. Truy vấn 2: Sách và tác giả đang được mượn (FormQuery2)

**Mô tả:** Tìm tất cả sách đang được mượn cùng thông tin tác giả

**Mức trong suốt:** Trong suốt phân mảnh + Trong suốt vị trí

**Query:**
```sql
SELECT DISTINCT s.MaSach, s.TenSach, tg.TenTG, tg.ChuyenMon, 
       s.SiteLocation as SachSite, tg.SiteLocation as TacGiaSite
FROM V_Sach s
INNER JOIN V_TacGia tg ON s.MaTG = tg.MaTG
WHERE EXISTS (
    SELECT 1 FROM V_Muon m 
    WHERE m.MaSach = s.MaSach AND m.NgayTra IS NULL
)
ORDER BY s.TenSach
```

### 6.6. Truy vấn 3: Cập nhật thành phố NXB KHKT (FormQuery3)

**Mô tả:** Chuyển đổi thành phố của NXB "KHKT" giữa T1 ↔ T2

**Mức trong suốt:** Trong suốt phân mảnh + Trong suốt nhân bản

**Thao tác:**
- Xem thành phố hiện tại của NXB "KHKT"
- Click nút "Chuyển đổi thành phố" để chuyển T1→T2 hoặc T2→T1
- Hệ thống tự động update trên đúng site

---

## 7. CÀI ĐẶT VÀ TRIỂN KHAI

### 7.1. Yêu cầu hệ thống

**Phần mềm:**
- Windows 10/11
- SQL Server 2019/2022
- .NET Framework 4.8
- Visual Studio 2019/2022 (để build)
- SQL Server Management Studio (SSMS)

**Phần cứng:**
- CPU: 2 cores trở lên
- RAM: 4GB trở lên
- Disk: 2GB trống

### 7.2. Các bước cài đặt

#### Bước 1: Cài đặt SQL Server

1. Cài đặt 3 SQL Server Instances:
   - SQLEXPRESS06 (Port 1436)
   - SQLEXPRESS07 (Port 1437)
   - SQLEXPRESS08 (Port 1438)

2. Cấu hình SQL Server:
```sql
-- Enable TCP/IP
-- Enable SQL Server Authentication
-- Set sa password = 123456
-- Enable Remote Connections
```

3. Cấu hình Firewall:
```powershell
New-NetFirewallRule -DisplayName "SQL 1436" -Direction Inbound -Protocol TCP -LocalPort 1436 -Action Allow
New-NetFirewallRule -DisplayName "SQL 1437" -Direction Inbound -Protocol TCP -LocalPort 1437 -Action Allow
New-NetFirewallRule -DisplayName "SQL 1438" -Direction Inbound -Protocol TCP -LocalPort 1438 -Action Allow
New-NetFirewallRule -DisplayName "SQL Browser" -Direction Inbound -Protocol UDP -LocalPort 1434 -Action Allow
```

#### Bước 2: Chạy SQL Scripts

Chạy các script theo thứ tự:

1. **Tạo databases trên 2 sites con:**
```powershell
sqlcmd -S localhost\SQLEXPRESS07,1437 -U sa -P 123456 -i "SQLScripts\01_Server_Con1_CreateDB.sql"
sqlcmd -S localhost\SQLEXPRESS08,1438 -U sa -P 123456 -i "SQLScripts\02_Server_Con2_CreateDB.sql"
```

2. **Tạo database trên server mẹ:**
```powershell
sqlcmd -S localhost\SQLEXPRESS06,1436 -U sa -P 123456 -i "SQLScripts\03_Server_Me_CreateDB.sql"
```

3. **Tạo Linked Servers:**
```powershell
sqlcmd -S localhost\SQLEXPRESS06,1436 -U sa -P 123456 -i "SQLScripts\04_Server_Me_LinkedServers.sql"
```

4. **Tạo Views:**
```powershell
sqlcmd -S localhost\SQLEXPRESS06,1436 -U sa -P 123456 -i "SQLScripts\05_Server_Me_Views_And_Triggers.sql"
```

5. **Tạo Stored Procedures:**
```powershell
sqlcmd -S localhost\SQLEXPRESS06,1436 -U sa -P 123456 -i "SQLScripts\06_Server_Me_StoredProcedures.sql"
```

6. **Insert dữ liệu mẫu:**
```powershell
sqlcmd -S localhost\SQLEXPRESS06,1436 -U sa -P 123456 -i "SQLScripts\07_InsertData.sql"
```

#### Bước 3: Build ứng dụng

1. Mở `WindowsFormsApp1.sln` trong Visual Studio
2. Chọn Configuration: **Release**
3. Build → Rebuild Solution
4. File .exe sẽ ở: `bin\Release\WindowsFormsApp1.exe`

#### Bước 4: Cấu hình kết nối

Nếu chạy trên máy khác (remote), sửa file `App.config`:

```xml
<appSettings>
    <add key="ServerIP" value="172.20.10.6" />  <!-- IP của server -->
</appSettings>
```

### 7.3. Kiểm tra cài đặt

Chạy script test:
```powershell
sqlcmd -S localhost\SQLEXPRESS06,1436 -U sa -P 123456 -i "SQLScripts\13_TestAll_Complete.sql"
```

Kết quả mong đợi:
- ✅ 5 Views tạo thành công
- ✅ 18 Stored Procedures tạo thành công
- ✅ Dữ liệu mẫu insert thành công
- ✅ 3 queries chạy thành công

---

## 8. HƯỚNG DẪN SỬ DỤNG

### 8.1. Khởi động ứng dụng

1. Chạy `WindowsFormsApp1.exe`
2. Màn hình menu chính hiện ra với các chức năng:
   - Quản lý Nhà Xuất Bản
   - Quản lý Sách
   - Quản lý Mượn Sách
   - Truy vấn 1, 2, 3
   - Thoát

### 8.2. Quản lý Nhà Xuất Bản

**Thêm NXB mới:**
1. Click "Quản lý Nhà Xuất Bản"
2. Nhập Mã NXB (VD: NXB05)
3. Nhập Tên NXB (VD: Kim Đồng)
4. Nhập Thành phố (T1 hoặc T2)
5. Click "Thêm"

**Sửa NXB:**
1. Click chọn dòng trong DataGridView
2. Sửa thông tin trong các textbox
3. Click "Sửa"

**Xóa NXB:**
1. Click chọn dòng trong DataGridView
2. Click "Xóa"
3. Xác nhận xóa

⚠️ **Lưu ý:** Xóa NXB sẽ xóa cascade tất cả sách và phiếu mượn liên quan

### 8.3. Quản lý Mượn Sách

**Thêm phiếu mượn:**
1. Click "Quản lý Mượn Sách"
2. Chọn độc giả từ ComboBox
3. Chọn sách từ ComboBox
4. Chọn ngày mượn và ngày trả
5. Click "Thêm"

**Trả sách:**
1. Click chọn phiếu mượn trong DataGridView
2. Sửa ngày trả
3. Click "Sửa"

### 8.4. Thực hiện truy vấn

**Query 1 - Sách năm 1998:**
1. Click "Truy vấn 1"
2. Xem danh sách sách xuất bản năm 1998

**Query 2 - Sách tác giả đang mượn:**
1. Click "Truy vấn 2"
2. Xem danh sách sách và tác giả đang được mượn

**Query 3 - Chuyển thành phố KHKT:**
1. Click "Truy vấn 3"
2. Xem thành phố hiện tại của NXB KHKT
3. Click "Chuyển đổi thành phố"
4. Xác nhận chuyển đổi

---

## 9. KỸ THUẬT SỬ DỤNG

### 9.1. Database Access Layer (DatabaseHelper)

**Singleton Pattern:**
```csharp
public class DatabaseHelper
{
    private static string connectionString = 
        "Data Source=localhost\\SQLEXPRESS06,1436;" +
        "Initial Catalog=ThuVien_Central;" +
        "User ID=sa;Password=123456;";
}
```

**Các phương thức chính:**

1. **ExecuteQuery** - Thực thi SELECT, trả về DataTable
```csharp
DataTable dt = DatabaseHelper.ExecuteQuery(
    "SELECT * FROM V_NhaXB ORDER BY MaNXB"
);
```

2. **ExecuteNonQuery** - Thực thi INSERT/UPDATE/DELETE qua Stored Procedure
```csharp
SqlParameter[] parameters = new SqlParameter[] {
    new SqlParameter("@MaNXB", "NXB05"),
    new SqlParameter("@TenNXB", "Kim Đồng"),
    new SqlParameter("@ThanhPho", "T1")
};
bool success = DatabaseHelper.ExecuteNonQuery("SP_INSERT_NHAXB", parameters);
```

3. **ExecuteStoredProcedure** - Gọi SP và trả về DataTable
```csharp
DataTable dt = DatabaseHelper.ExecuteStoredProcedure(
    "SP_Query1_SachNam1998", null
);
```

### 9.2. Stored Procedures Logic

**Ví dụ SP_INSERT_NHAXB:**
```sql
CREATE PROCEDURE SP_INSERT_NHAXB
    @MaNXB char(5),
    @TenNXB nvarchar(50),
    @ThanhPho nvarchar(30)
AS
BEGIN
    IF @ThanhPho = 'T1'
        INSERT INTO SITE1_SERVER.ThuVien_Site1.dbo.NhaXB_Site1
        VALUES (@MaNXB, @TenNXB, @ThanhPho)
    ELSE IF @ThanhPho = 'T2'
        INSERT INTO SITE2_SERVER.ThuVien_Site2.dbo.NhaXB_Site2
        VALUES (@MaNXB, @TenNXB, @ThanhPho)
END
```

**Ví dụ SP_DELETE_NHAXB (Cascade):**
```sql
CREATE PROCEDURE SP_DELETE_NHAXB
    @MaNXB char(5),
    @ThanhPho nvarchar(30) = NULL
AS
BEGIN
    IF @ThanhPho = 'T1'
    BEGIN
        -- Xóa phiếu mượn liên quan
        DELETE FROM SITE1_SERVER.ThuVien_Site1.dbo.Muon_Site1 
        WHERE MaSach IN (
            SELECT MaSach FROM SITE1_SERVER.ThuVien_Site1.dbo.Sach_Site1 
            WHERE MaNXB = @MaNXB
        )
        -- Xóa sách liên quan
        DELETE FROM SITE1_SERVER.ThuVien_Site1.dbo.Sach_Site1 
        WHERE MaNXB = @MaNXB
        -- Xóa NXB
        DELETE FROM SITE1_SERVER.ThuVien_Site1.dbo.NhaXB_Site1 
        WHERE MaNXB = @MaNXB
    END
    -- Tương tự cho T2
END
```

### 9.3. Global Views (Transparency)

**Ví dụ V_NhaXB:**
```sql
CREATE VIEW V_NhaXB AS
    SELECT MaNXB, TenNXB, ThanhPho, 'SITE1' as SiteLocation
    FROM SITE1_SERVER.ThuVien_Site1.dbo.NhaXB_Site1
    UNION ALL
    SELECT MaNXB, TenNXB, ThanhPho, 'SITE2' as SiteLocation
    FROM SITE2_SERVER.ThuVien_Site2.dbo.NhaXB_Site2
```

**Người dùng query:**
```sql
SELECT * FROM V_NhaXB  -- Không cần biết dữ liệu ở đâu
```

### 9.4. Linked Servers Configuration

```sql
-- Tạo Linked Server đến Site 1
EXEC sp_addlinkedserver 
    @server = 'SITE1_SERVER',
    @srvproduct = '',
    @provider = 'SQLNCLI',
    @datasrc = 'DESKTOP-4EOK9DU\SQLEXPRESS07,1437'

-- Cấu hình login
EXEC sp_addlinkedsrvlogin 
    @rmtsrvname = 'SITE1_SERVER',
    @useself = 'false',
    @rmtuser = 'sa',
    @rmtpassword = '123456'
```

### 9.5. Unicode Support

**SQL Scripts:**
- Sử dụng tiền tố `N` cho chuỗi Unicode
- Collation: `Vietnamese_CI_AS`

```sql
INSERT INTO NhaXB_Site1 VALUES 
    (N'NXB01', N'Giáo dục', N'T1'),
    (N'NXB02', N'Trẻ', N'T1')
```

**C# Code:**
- SqlParameter tự động xử lý Unicode
- Không cần encoding đặc biệt

```csharp
new SqlParameter("@TenNXB", "Giáo dục")  // OK
```

### 9.6. Tại sao không dùng Trigger?

**Lý do:**

1. **Stored Procedures đã đủ**: Logic phân mảnh được xử lý hoàn toàn trong SP
2. **Đơn giản hơn**: Không cần trigger để bắt sự kiện trên views
3. **Dễ bảo trì**: Logic tập trung ở một nơi (SP), không phân tán
4. **Hiệu năng**: SP trực tiếp nhanh hơn trigger trên view
5. **Người dùng không thao tác trực tiếp trên views**: Chỉ thao tác qua Windows Forms

**Luồng dữ liệu:**
```
User → Form → DatabaseHelper → Stored Procedure → Site1/Site2
```

Không có thao tác:
```
User → View → Trigger → Site1/Site2  ❌ (Không cần)
```

---

## 10. TROUBLESHOOTING

### 10.1. Lỗi kết nối SQL Server

**Lỗi:** "Cannot connect to server"

**Giải pháp:**
1. Kiểm tra SQL Server đang chạy:
```powershell
Get-Service | Where-Object {$_.Name -like "*SQL*"}
```

2. Kiểm tra TCP/IP đã enable:
   - SQL Server Configuration Manager
   - SQL Server Network Configuration
   - Protocols for SQLEXPRESS06
   - TCP/IP → Enabled

3. Kiểm tra firewall:
```powershell
Get-NetFirewallRule | Where-Object {$_.DisplayName -like "*SQL*"}
```

### 10.2. Lỗi Linked Server

**Lỗi:** "Could not find server 'SITE1_SERVER'"

**Giải pháp:**
```sql
-- Kiểm tra linked servers
SELECT * FROM sys.servers WHERE is_linked = 1

-- Xóa và tạo lại
EXEC sp_dropserver 'SITE1_SERVER', 'droplogins'
-- Chạy lại script 04_Server_Me_LinkedServers.sql
```

### 10.3. Lỗi Unicode

**Lỗi:** Hiển thị dấu hỏi thay vì tiếng Việt

**Giải pháp:**
1. Chạy script `07B_FixUnicode.sql`
2. Đảm bảo tất cả INSERT có tiền tố `N`
3. Kiểm tra collation database:
```sql
SELECT DATABASEPROPERTYEX('ThuVien_Central', 'Collation')
-- Nên là: Vietnamese_CI_AS
```

### 10.4. Lỗi Stored Procedure

**Lỗi:** "Procedure or function 'SP_INSERT_NHAXB' has too many arguments specified"

**Giải pháp:**
1. Kiểm tra version SP trên server:
```sql
SELECT OBJECT_DEFINITION(OBJECT_ID('SP_INSERT_NHAXB'))
```

2. Chạy lại script `06_Server_Me_StoredProcedures.sql` để update SP mới nhất

### 10.5. Lỗi xóa dữ liệu

**Lỗi:** "The DELETE statement conflicted with the REFERENCE constraint"

**Giải pháp:**
1. Chạy script `Update_SP_DELETE_NHAXB.sql` để cập nhật SP xóa cascade
2. Hoặc xóa thủ công theo thứ tự: Muon → Sach → NXB

---

## 11. TÀI LIỆU THAM KHẢO

### 11.1. File tài liệu kèm theo

- `README_WINFORMS.md` - Hướng dẫn chi tiết Windows Forms
- `PROJECT_STATUS.md` - Trạng thái dự án
- `SO_DO_CAU_TRUC_HE_THONG.md` - Sơ đồ kiến trúc chi tiết
- `CAC_BUOC_CHUAN_BI.md` - Hướng dẫn chuẩn bị triển khai
- `HUONG_DAN_GUI_APP.md` - Hướng dẫn gửi app cho người khác
- `HUONG_DAN_INSERT_UNICODE.md` - Hướng dẫn xử lý Unicode
- `NEXT_STEPS.md` - Các bước tiếp theo để hoàn thiện

### 11.2. Tài liệu tham khảo bên ngoài

1. **SQL Server Distributed Database:**
   - https://docs.microsoft.com/en-us/sql/relational-databases/linked-servers/

2. **Windows Forms Documentation:**
   - https://docs.microsoft.com/en-us/dotnet/desktop/winforms/

3. **ADO.NET:**
   - https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/

---

## 12. THÔNG TIN LIÊN HỆ

**Sinh viên thực hiện:**
- Họ tên: [Tên sinh viên]
- MSSV: [Mã số sinh viên]
- Lớp: [Lớp]
- Email: [Email]

**Giảng viên hướng dẫn:**
- Họ tên: [Tên giảng viên]
- Email: [Email]

**Trường:** [Tên trường]  
**Khoa:** [Tên khoa]  
**Môn học:** Cơ sở dữ liệu phân tán  
**Học kỳ:** [Học kỳ - Năm học]

---

## 13. GIẤY PHÉP

Dự án này được phát triển phục vụ mục đích học tập. Mọi sử dụng cho mục đích thương mại cần xin phép tác giả.

---

## 14. CHANGELOG

### Version 1.0.0 (Hiện tại)
- ✅ Hoàn thành database 3 instances
- ✅ Hoàn thành 8 SQL scripts
- ✅ Hoàn thành 5 Windows Forms chính
- ✅ Hoàn thành 18 Stored Procedures
- ✅ Hoàn thành 3 queries phân tán
- ✅ Hỗ trợ Unicode đầy đủ
- ✅ Cascade delete cho NXB/Sach

### Todo - Version 2.0.0
- ⚠️ Hoàn thiện FormTacGia, FormDocGia
- ⚠️ Thêm form báo cáo/thống kê
- ⚠️ Thêm phân quyền người dùng
- ⚠️ Thêm transaction rollback
- ⚠️ Thêm audit log

---

**🎉 Cảm ơn bạn đã sử dụng hệ thống!**

*Tài liệu được cập nhật lần cuối: [Ngày tháng năm hiện tại]*
