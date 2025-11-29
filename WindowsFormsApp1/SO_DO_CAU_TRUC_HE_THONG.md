# SƠ ĐỒ CẤU TRÚC HỆ THỐNG QUẢN LÝ THƯ VIỆN PHÂN TÁN

## 1. KIẾN TRÚC TỔNG QUAN (3-TIER)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        PRESENTATION TIER (CLIENT)                        │
│                      Windows Forms Application (.NET 4.8)                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐│
│  │  FormMain    │  │  FormNhaXB   │  │  FormTacGia  │  │  FormDocGia  ││
│  │  (Menu)      │  │  (CRUD)      │  │  (CRUD)      │  │  (CRUD)      ││
│  └──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘│
│                                                                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐│
│  │  FormSach    │  │  FormMuon    │  │  FormQuery1  │  │  FormQuery2  ││
│  │  (CRUD)      │  │  (CRUD)      │  │  (Query)     │  │  (Query)     ││
│  └──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘│
│                                                                           │
│  ┌──────────────┐  ┌──────────────┐                                     │
│  │  FormQuery3  │  │  FormAbout   │                                     │
│  │  (Query)     │  │  (Info)      │                                     │
│  └──────────────┘  └──────────────┘                                     │
│                                                                           │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │            DatabaseHelper.cs (Singleton Pattern)                 │    │
│  │  - ExecuteQuery(string query)                                    │    │
│  │  - ExecuteNonQuery(string query)                                 │    │
│  │  - ExecuteStoredProcedure(string spName, SqlParameter[])        │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                                                                           │
└───────────────────────────┬───────────────────────────────────────────────┘
                            │
                            │ ADO.NET SqlClient
                            │ Connection String:
                            │ Server=DESKTOP-4EOK9DU\SQLEXPRESS06,1436
                            │ Database=ThuVien_Central
                            │ User=sa, Password=123456
                            │
┌───────────────────────────▼───────────────────────────────────────────────┐
│                   APPLICATION/BUSINESS LOGIC TIER                          │
│                SQL Server Central (SQLEXPRESS06, Port 1436)                │
│                        Database: ThuVien_Central                           │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  ┌──────────────────────────────────────────────────────────────────┐    │
│  │                     GLOBAL VIEWS (Transparency)                   │    │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌────────────┐ │    │
│  │  │  V_NhaXB   │  │  V_TacGia  │  │  V_DocGia  │  │  V_Sach    │ │    │
│  │  │ UNION ALL  │  │ UNION ALL  │  │ UNION ALL  │  │ UNION ALL  │ │    │
│  │  │ Site1+Site2│  │ Site1+Site2│  │ Site1+Site2│  │ Site1+Site2│ │    │
│  │  └────────────┘  └────────────┘  └────────────┘  └────────────┘ │    │
│  │  ┌────────────┐                                                  │    │
│  │  │  V_Muon    │                                                  │    │
│  │  │ UNION ALL  │                                                  │    │
│  │  │ Site1+Site2│                                                  │    │
│  │  └────────────┘                                                  │    │
│  └──────────────────────────────────────────────────────────────────┘    │
│                                                                            │
│  ┌──────────────────────────────────────────────────────────────────┐    │
│  │                 STORED PROCEDURES (Routing Logic)                 │    │
│  │  INSERT (5 SPs):                                                  │    │
│  │  - SP_INSERT_NHAXB (route by ThanhPho: T1→Site1, T2→Site2)      │    │
│  │  - SP_INSERT_TACGIA (route by ChuyenMon: ĐT→Site1, MT→Site2)    │    │
│  │  - SP_INSERT_DOCGIA (route by DoiTuong: HS→Site1, SV→Site2)     │    │
│  │  - SP_INSERT_SACH (derived from TacGia's site)                   │    │
│  │  - SP_INSERT_MUON (derived from DocGia's site)                   │    │
│  │                                                                   │    │
│  │  UPDATE (5 SPs):                                                  │    │
│  │  - SP_UPDATE_NHAXB (can move Site1↔Site2 if ThanhPho changes)   │    │
│  │  - SP_UPDATE_TACGIA (can move Site1↔Site2 if ChuyenMon changes) │    │
│  │  - SP_UPDATE_DOCGIA (can move Site1↔Site2 if DoiTuong changes)  │    │
│  │  - SP_UPDATE_SACH (can move if MaTG changes)                     │    │
│  │  - SP_UPDATE_MUON (dates only, no site change)                   │    │
│  │                                                                   │    │
│  │  DELETE (5 SPs):                                                  │    │
│  │  - SP_DELETE_NHAXB (check FK, delete from correct site)          │    │
│  │  - SP_DELETE_TACGIA (check FK, delete from correct site)         │    │
│  │  - SP_DELETE_DOCGIA (check FK, delete from correct site)         │    │
│  │  - SP_DELETE_SACH (check FK, delete from correct site)           │    │
│  │  - SP_DELETE_MUON (delete from correct site)                     │    │
│  └──────────────────────────────────────────────────────────────────┘    │
│                                                                            │
│  ┌──────────────────────────────────────────────────────────────────┐    │
│  │                    LINKED SERVERS CONFIGURATION                   │    │
│  │  ┌────────────────────────────────────────────────────────────┐  │    │
│  │  │ SITE1_SERVER                                                │  │    │
│  │  │ - Server: DESKTOP-4EOK9DU\SQLEXPRESS07,1437                │  │    │
│  │  │ - Database: ThuVien_Site1                                   │  │    │
│  │  │ - Provider: SQLNCLI                                         │  │    │
│  │  │ - Authentication: SQL (sa/123456)                           │  │    │
│  │  └────────────────────────────────────────────────────────────┘  │    │
│  │  ┌────────────────────────────────────────────────────────────┐  │    │
│  │  │ SITE2_SERVER                                                │  │    │
│  │  │ - Server: DESKTOP-4EOK9DU\SQLEXPRESS08,1438                │  │    │
│  │  │ - Database: ThuVien_Site2                                   │  │    │
│  │  │ - Provider: SQLNCLI                                         │  │    │
│  │  │ - Authentication: SQL (sa/123456)                           │  │    │
│  │  └────────────────────────────────────────────────────────────┘  │    │
│  └──────────────────────────────────────────────────────────────────┘    │
│                                                                            │
└────────────┬─────────────────────────────────┬───────────────────────────┘
             │                                 │
             │ Linked Server                   │ Linked Server
             │ (TCP/IP)                        │ (TCP/IP)
             │                                 │
┌────────────▼──────────────┐   ┌──────────────▼─────────────────┐
│       DATA TIER           │   │       DATA TIER                 │
│  SQL Server Site1         │   │  SQL Server Site2               │
│  (SQLEXPRESS07, Port 1437)│   │  (SQLEXPRESS08, Port 1438)      │
│  Database: ThuVien_Site1  │   │  Database: ThuVien_Site2        │
├───────────────────────────┤   ├─────────────────────────────────┤
│                           │   │                                 │
│ ┌───────────────────────┐ │   │ ┌───────────────────────────┐   │
│ │  NhaXB_Site1          │ │   │ │  NhaXB_Site2              │   │
│ │  PK: MaNXB            │ │   │ │  PK: MaNXB                │   │
│ │  CHECK: ThanhPho='T1' │ │   │ │  CHECK: ThanhPho='T2'     │   │
│ │  ─────────────────    │ │   │ │  ─────────────────        │   │
│ │  NXB01 | Giáo dục |T1 │ │   │ │  NXB03 | KHKT     |T2     │   │
│ │  NXB02 | Trẻ      |T1 │ │   │ │  NXB04 | ĐH QG    |T2     │   │
│ └───────────────────────┘ │   │ └───────────────────────────┘   │
│                           │   │                                 │
│ ┌───────────────────────┐ │   │ ┌───────────────────────────┐   │
│ │  TacGia_Site1         │ │   │ │  TacGia_Site2             │   │
│ │  PK: MaTG             │ │   │ │  PK: MaTG                 │   │
│ │  CHECK: ChuyenMon=    │ │   │ │  CHECK: ChuyenMon=        │   │
│ │         'Điện tử'     │ │   │ │         'Máy tính'        │   │
│ │  ───────────────────  │ │   │ │  ───────────────────      │   │
│ │  TG001 | Nguyễn VĂ|ĐT │ │   │ │  TG002 | Trần TB |MT     │   │
│ │  TG003 | Lê VĂ C  |ĐT │ │   │ │  TG004 | Phạm TĐ |MT     │   │
│ └───────────────────────┘ │   │ └───────────────────────────┘   │
│                           │   │                                 │
│ ┌───────────────────────┐ │   │ ┌───────────────────────────┐   │
│ │  DocGia_Site1         │ │   │ │  DocGia_Site2             │   │
│ │  PK: MaDG             │ │   │ │  PK: MaDG                 │   │
│ │  CHECK: DoiTuong='HS' │ │   │ │  CHECK: DoiTuong='SV'     │   │
│ │  ───────────────────  │ │   │ │  ───────────────────      │   │
│ │  DG001 | Trần VX |HS  │ │   │ │  DG003 | Lê VZ   |SV     │   │
│ │  DG002 | Nguyễn TY|HS │ │   │ │  DG004 | Phạm TW |SV     │   │
│ └───────────────────────┘ │   │ └───────────────────────────┘   │
│                           │   │                                 │
│ ┌───────────────────────┐ │   │ ┌───────────────────────────┐   │
│ │  Sach_Site1           │ │   │ │  Sach_Site2               │   │
│ │  PK: MaSach           │ │   │ │  PK: MaSach               │   │
│ │  FK: MaNXB→NhaXB_S1   │ │   │ │  FK: MaNXB→NhaXB_S2       │   │
│ │  FK: MaTG→TacGia_S1   │ │   │ │  FK: MaTG→TacGia_S2       │   │
│ │  (Derived from TacGia)│ │   │ │  (Derived from TacGia)    │   │
│ │  ───────────────────  │ │   │ │  ───────────────────      │   │
│ │  S0001 |CB Điện tử|... │ │   │ │  S0002 |Lập C++  |...    │   │
│ │  S0003 |Mạch số  |... │ │   │ │  S0004 |Cấu trúc |...    │   │
│ │  S0005 |Vi xử lý |... │ │   │ │                           │   │
│ └───────────────────────┘ │   │ └───────────────────────────┘   │
│                           │   │                                 │
│ ┌───────────────────────┐ │   │ ┌───────────────────────────┐   │
│ │  Muon_Site1           │ │   │ │  Muon_Site2               │   │
│ │  PK: MaDG,MaSach,     │ │   │ │  PK: MaDG,MaSach,         │   │
│ │      NgayMuon         │ │   │ │      NgayMuon             │   │
│ │  FK: MaDG→DocGia_S1   │ │   │ │  FK: MaDG→DocGia_S2       │   │
│ │  FK: MaSach→Sach_S1   │ │   │ │  FK: MaSach→Sach_S2       │   │
│ │  (Derived from DocGia)│ │   │ │  (Derived from DocGia)    │   │
│ │  ───────────────────  │ │   │ │  ───────────────────      │   │
│ │  DG001|S0001|1999-... │ │   │ │  DG003|S0002|1999-...     │   │
│ │  DG001|S0003|1999-... │ │   │ │  DG004|S0004|1999-...     │   │
│ │  DG002|S0003|1999-... │ │   │ │                           │   │
│ └───────────────────────┘ │   │ └───────────────────────────┘   │
│                           │   │                                 │
│  Data Count:              │   │  Data Count:                    │
│  - NhaXB: 2 rows          │   │  - NhaXB: 2 rows                │
│  - TacGia: 2 rows         │   │  - TacGia: 2 rows               │
│  - DocGia: 2 rows         │   │  - DocGia: 2 rows               │
│  - Sach: 3 rows           │   │  - Sach: 2 rows                 │
│  - Muon: 3 rows           │   │  - Muon: 2 rows                 │
│  TOTAL: 12 rows           │   │  TOTAL: 10 rows                 │
└───────────────────────────┘   └─────────────────────────────────┘

                GRAND TOTAL (Central View): 22 rows
                (Site1: 12 rows + Site2: 10 rows = 22 rows)
```

---

## 2. PHÂN MẢNH DỮ LIỆU (FRAGMENTATION SCHEMA)

```
┌──────────────────────────────────────────────────────────────────┐
│              FRAGMENTATION DISTRIBUTION DIAGRAM                   │
└──────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                    HORIZONTAL FRAGMENTATION                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  BẢNG: NHAXB                                                         │
│  ├─ Tiêu chí: ThanhPho (Thành phố)                                  │
│  ├─ Site1: WHERE ThanhPho = 'T1' (Thành phố 1)                      │
│  │   └─ NXB01, NXB02                                                │
│  └─ Site2: WHERE ThanhPho = 'T2' (Thành phố 2)                      │
│      └─ NXB03, NXB04                                                │
│                                                                      │
│  BẢNG: TACGIA                                                        │
│  ├─ Tiêu chí: ChuyenMon (Chuyên môn)                                │
│  ├─ Site1: WHERE ChuyenMon = 'Điện tử'                              │
│  │   └─ TG001, TG003                                                │
│  └─ Site2: WHERE ChuyenMon = 'Máy tính'                             │
│      └─ TG002, TG004                                                │
│                                                                      │
│  BẢNG: DOCGIA                                                        │
│  ├─ Tiêu chí: DoiTuong (Đối tượng)                                  │
│  ├─ Site1: WHERE DoiTuong = 'HS' (Học sinh)                         │
│  │   └─ DG001, DG002                                                │
│  └─ Site2: WHERE DoiTuong = 'SV' (Sinh viên)                        │
│      └─ DG003, DG004                                                │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                    DERIVED FRAGMENTATION                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  BẢNG: SACH (Derived from TACGIA)                                   │
│  ├─ Logic: Sách lưu cùng site với Tác giả                           │
│  ├─ Site1: Sách của TG001, TG003 (Điện tử)                          │
│  │   ├─ S0001 (TG001, NXB01) - Cơ bản Điện tử                       │
│  │   ├─ S0003 (TG003, NXB02) - Mạch số                              │
│  │   └─ S0005 (TG001, NXB01) - Vi xử lý                             │
│  └─ Site2: Sách của TG002, TG004 (Máy tính)                         │
│      ├─ S0002 (TG002, NXB03) - Lập trình C++                        │
│      └─ S0004 (TG004, NXB04) - Cấu trúc dữ liệu                     │
│                                                                      │
│  BẢNG: MUON (Derived from DOCGIA)                                   │
│  ├─ Logic: Phiếu mượn lưu cùng site với Độc giả                     │
│  ├─ Site1: Phiếu mượn của DG001, DG002 (Học sinh)                   │
│  │   ├─ (DG001, S0001, 1999-01-15) → Trần Văn X mượn CB Điện tử     │
│  │   ├─ (DG001, S0003, 1999-03-20) → Trần Văn X mượn Mạch số        │
│  │   └─ (DG002, S0003, 1999-05-10) → Nguyễn Thị Y mượn Mạch số      │
│  └─ Site2: Phiếu mượn của DG003, DG004 (Sinh viên)                  │
│      ├─ (DG003, S0002, 1999-02-25) → Lê Văn Z mượn Lập trình C++    │
│      └─ (DG004, S0004, 1999-04-15) → Phạm Thị W mượn Cấu trúc DL    │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 3. DATA FLOW (LUỒNG DỮ LIỆU)

```
┌─────────────────────────────────────────────────────────────────────┐
│                        INSERT OPERATION FLOW                         │
└─────────────────────────────────────────────────────────────────────┘

Example: INSERT NhaXB (Thành phố T1)

┌─────────────┐
│   Client    │
│ FormNhaXB   │
└──────┬──────┘
       │ 1. User nhập: MaNXB='NXB05', TenNXB='Văn học', ThanhPho='T1'
       │ 2. Click button "Thêm"
       ▼
┌──────────────────────────────────┐
│   DatabaseHelper.cs              │
│   ExecuteStoredProcedure(        │
│     "SP_INSERT_NHAXB",           │
│     parameters: [                │
│       @MaNXB='NXB05',            │
│       @TenNXB='Văn học',         │
│       @ThanhPho='T1'             │
│     ]                            │
│   )                              │
└──────┬───────────────────────────┘
       │ 3. ADO.NET SqlClient gửi request đến Central
       ▼
┌──────────────────────────────────────────────────────────┐
│   Central Server (Port 1436)                             │
│   SP_INSERT_NHAXB được thực thi                          │
│                                                          │
│   BEGIN                                                  │
│     IF @ThanhPho = 'T1'                                  │
│     BEGIN                                                │
│       INSERT INTO SITE1_SERVER.ThuVien_Site1.dbo.NhaXB_Site1│
│       VALUES (@MaNXB, @TenNXB, @ThanhPho)                │
│     END                                                  │
│     ELSE IF @ThanhPho = 'T2'                             │
│     BEGIN                                                │
│       INSERT INTO SITE2_SERVER.ThuVien_Site2.dbo.NhaXB_Site2│
│       VALUES (@MaNXB, @TenNXB, @ThanhPho)                │
│     END                                                  │
│   END                                                    │
│                                                          │
└──────┬───────────────────────────────────────────────────┘
       │ 4. Linked Server routing: ThanhPho='T1' → SITE1_SERVER
       ▼
┌──────────────────────────────────┐
│   Site1 (Port 1437)              │
│   ThuVien_Site1.dbo.NhaXB_Site1  │
│                                  │
│   INSERT VALUES                  │
│   ('NXB05', 'Văn học', 'T1')     │
│                                  │
│   CHECK constraint:              │
│   ✓ ThanhPho = 'T1' (PASS)       │
│                                  │
│   Row inserted successfully!     │
└──────────────────────────────────┘
       │ 5. Return success
       ▼
┌──────────────────────────────────┐
│   Client                         │
│   MessageBox.Show(               │
│     "Thêm thành công!"           │
│   )                              │
│   LoadData() → Reload DataGridView│
└──────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────────┐
│                        SELECT OPERATION FLOW                         │
└─────────────────────────────────────────────────────────────────────┘

Example: SELECT * FROM V_NhaXB

┌─────────────┐
│   Client    │
│ FormNhaXB   │
└──────┬──────┘
       │ 1. Form_Load()
       │ 2. LoadData()
       ▼
┌──────────────────────────────────┐
│   DatabaseHelper.cs              │
│   ExecuteQuery(                  │
│     "SELECT * FROM V_NhaXB       │
│      ORDER BY SiteLocation, MaNXB"│
│   )                              │
└──────┬───────────────────────────┘
       │ 3. Query gửi đến Central
       ▼
┌──────────────────────────────────────────────────────────┐
│   Central Server (Port 1436)                             │
│   View V_NhaXB được thực thi                             │
│                                                          │
│   SELECT MaNXB, TenNXB, ThanhPho, 'SITE1' AS SiteLocation│
│   FROM SITE1_SERVER.ThuVien_Site1.dbo.NhaXB_Site1        │
│   UNION ALL                                              │
│   SELECT MaNXB, TenNXB, ThanhPho, 'SITE2' AS SiteLocation│
│   FROM SITE2_SERVER.ThuVien_Site2.dbo.NhaXB_Site2        │
│                                                          │
└──────┬───────────────────────┬───────────────────────────┘
       │                       │
       │ 4a. Query Site1       │ 4b. Query Site2
       ▼                       ▼
┌────────────────┐      ┌────────────────┐
│   Site1        │      │   Site2        │
│   NhaXB_Site1  │      │   NhaXB_Site2  │
│   ────────────│      │   ────────────│
│   NXB01|Giáo dục│T1│  │   NXB03|KHKT  |T2│
│   NXB02|Trẻ    |T1│  │   NXB04|ĐH QG |T2│
└────────┬───────┘      └────────┬───────┘
         │                       │
         │ 5a. Return 2 rows     │ 5b. Return 2 rows
         └───────────┬───────────┘
                     │
                     ▼
         ┌────────────────────────────┐
         │   Central: UNION ALL       │
         │   Kết hợp 2 resultsets     │
         │   ────────────────────     │
         │   NXB01|Giáo dục|T1|SITE1  │
         │   NXB02|Trẻ    |T1|SITE1  │
         │   NXB03|KHKT   |T2|SITE2  │
         │   NXB04|ĐH QG  |T2|SITE2  │
         └────────────┬───────────────┘
                      │ 6. Return 4 rows
                      ▼
         ┌────────────────────────────┐
         │   Client                   │
         │   DataGridView.DataSource  │
         │   = DataTable (4 rows)     │
         │                            │
         │   Display in grid          │
         └────────────────────────────┘
```

---

## 4. DEPLOYMENT DIAGRAM (SƠ ĐỒ TRIỂN KHAI)

```
┌─────────────────────────────────────────────────────────────────────┐
│                    LOCALHOST DEPLOYMENT                              │
│              (Single Machine, 3 SQL Server Instances)                │
└─────────────────────────────────────────────────────────────────────┘

    ┌─────────────────────────────────────────────────────┐
    │        DESKTOP-4EOK9DU (Windows 10/11)              │
    │        IP: 127.0.0.1 (localhost)                    │
    ├─────────────────────────────────────────────────────┤
    │                                                     │
    │  ┌────────────────────────────────────────────┐    │
    │  │  Windows Forms Application                 │    │
    │  │  WindowsFormsApp1.exe                      │    │
    │  │  Framework: .NET 4.8                       │    │
    │  │  Process: Running on main thread           │    │
    │  └────────┬───────────────────────────────────┘    │
    │           │ Connection: localhost,1436              │
    │  ─────────┼─────────────────────────────────────   │
    │           │                                         │
    │  ┌────────▼───────────────────────────────────┐    │
    │  │  SQL Server Instance 1                     │    │
    │  │  Name: SQLEXPRESS06                        │    │
    │  │  Port: 1436 (TCP/IP)                       │    │
    │  │  Database: ThuVien_Central                 │    │
    │  │  Service: Running                          │    │
    │  │  Memory: ~200 MB                           │    │
    │  └────────┬───────────┬───────────────────────┘    │
    │           │           │                            │
    │  Linked  │           │ Linked Server              │
    │  Server  │           │ SITE2_SERVER               │
    │  SITE1_  │           │ localhost,1438             │
    │  SERVER  │           │                            │
    │  local   │           │                            │
    │  host,   │           │                            │
    │  1437    │           │                            │
    │  ─────   │  ─────────┼─────────────────────────   │
    │     │    │           │                            │
    │  ┌──▼────▼──────┐ ┌──▼─────────────────────────┐  │
    │  │ SQL Server   │ │  SQL Server Instance 3      │  │
    │  │ Instance 2   │ │  Name: SQLEXPRESS08         │  │
    │  │ Name:        │ │  Port: 1438 (TCP/IP)        │  │
    │  │ SQLEXPRESS07 │ │  Database: ThuVien_Site2    │  │
    │  │ Port: 1437   │ │  Service: Running           │  │
    │  │ Database:    │ │  Memory: ~150 MB            │  │
    │  │ ThuVien_Site1│ │  Tables: 5 (NhaXB_Site2,    │  │
    │  │ Service:     │ │           TacGia_Site2,     │  │
    │  │ Running      │ │           DocGia_Site2,     │  │
    │  │ Memory:      │ │           Sach_Site2,       │  │
    │  │ ~150 MB      │ │           Muon_Site2)       │  │
    │  │ Tables: 5    │ │  Data: 10 rows total        │  │
    │  │ (NhaXB_Site1,│ │                             │  │
    │  │  TacGia_Site1│ │                             │  │
    │  │  DocGia_Site1│ │                             │  │
    │  │  Sach_Site1, │ │                             │  │
    │  │  Muon_Site1) │ │                             │  │
    │  │ Data: 12 rows│ │                             │  │
    │  └──────────────┘ └─────────────────────────────┘  │
    │                                                     │
    │  ───────────────────────────────────────────────   │
    │  Windows Firewall Rules:                            │
    │  - Allow inbound TCP 1436 (SQLEXPRESS06)            │
    │  - Allow inbound TCP 1437 (SQLEXPRESS07)            │
    │  - Allow inbound TCP 1438 (SQLEXPRESS08)            │
    │                                                     │
    │  Total Memory Usage: ~500 MB (3 SQL instances)      │
    │  Total Storage: ~200 MB (databases + logs)          │
    └─────────────────────────────────────────────────────┘
```

---

## 5. ER DIAGRAM (ENTITY RELATIONSHIP)

```
┌─────────────────────────────────────────────────────────────────────┐
│                    ENTITY RELATIONSHIP DIAGRAM                       │
│                      (Toàn cục - Global Schema)                      │
└─────────────────────────────────────────────────────────────────────┘

                    ┌──────────────────────┐
                    │       NHAXB          │
                    ├──────────────────────┤
                    │ MaNXB (PK)           │
                    │ TenNXB               │
                    │ ThanhPho             │
                    └──────────┬───────────┘
                               │
                               │ 1
                               │
                               │ xuất bản
                               │
                               │ N
                    ┌──────────▼───────────┐
                    │       SACH           │
                    ├──────────────────────┤
                    │ MaSach (PK)          │◄────┐
                    │ TenSach              │     │
                    │ NamXB                │     │
                    │ MaNXB (FK)           │     │
                    │ MaTG (FK)            │     │
                    └──────────┬───────────┘     │
                               ▲                 │
                               │                 │
                               │ N               │
                               │                 │
                               │ viết            │
                               │                 │
                               │ 1               │ N
                    ┌──────────┴───────────┐     │
                    │      TACGIA          │     │
                    ├──────────────────────┤     │
                    │ MaTG (PK)            │     │ được mượn
                    │ TenTG                │     │
                    │ ChuyenMon            │     │
                    └──────────────────────┘     │
                                                 │
                                                 │
                                                 │ 1
                    ┌────────────────────────────┘
                    │
                    │
                    │
                    │ N
         ┌──────────▼───────────┐
         │       MUON           │
         ├──────────────────────┤
         │ MaDG (PK, FK)        │
         │ MaSach (PK, FK)      │
         │ NgayMuon (PK)        │
         │ NgayTra              │
         └──────────┬───────────┘
                    ▲
                    │
                    │ N
                    │
                    │ mượn
                    │
                    │ 1
         ┌──────────┴───────────┐
         │      DOCGIA          │
         ├──────────────────────┤
         │ MaDG (PK)            │
         │ TenDG                │
         │ DoiTuong             │
         └──────────────────────┘


RELATIONSHIPS (Chi tiết):

1. NHAXB --< SACH
   - One to Many (1:N)
   - Một nhà xuất bản xuất bản nhiều sách
   - FK: SACH.MaNXB → NHAXB.MaNXB
   - Cardinality: 1 nhà xuất bản có 0..* sách

2. TACGIA --< SACH
   - One to Many (1:N)
   - Một tác giả viết nhiều sách
   - FK: SACH.MaTG → TACGIA.MaTG
   - Cardinality: 1 tác giả có 1..* sách

3. SACH --< MUON
   - One to Many (1:N)
   - Một sách có thể được mượn nhiều lần
   - FK: MUON.MaSach → SACH.MaSach
   - Cardinality: 1 sách có 0..* lần mượn

4. DOCGIA --< MUON
   - One to Many (1:N)
   - Một độc giả có thể mượn nhiều sách
   - FK: MUON.MaDG → DOCGIA.MaDG
   - Cardinality: 1 độc giả có 0..* lần mượn

COMPOSITE PRIMARY KEY:
- MUON (MaDG, MaSach, NgayMuon)
  → Một độc giả có thể mượn cùng một sách nhiều lần
  → Nhưng mỗi lần mượn phải có ngày mượn khác nhau
```

---

## 6. NETWORK TOPOLOGY (LOCALHOST SIMULATION)

```
┌─────────────────────────────────────────────────────────────────────┐
│              NETWORK COMMUNICATION (TCP/IP on localhost)             │
└─────────────────────────────────────────────────────────────────────┘

        Application Layer
              │
              ▼
    ┌───────────────────┐
    │  Windows Forms    │
    │  Client Process   │
    │  PID: 12345       │
    └─────────┬─────────┘
              │ ADO.NET SqlClient
              │ Connection String
              │ Protocol: TCP/IP
              ▼
    ┌───────────────────────────┐
    │  Network Interface        │
    │  Loopback Adapter         │
    │  127.0.0.1 (localhost)    │
    └─────────┬─────────────────┘
              │
              │ TCP Port 1436
              ▼
    ┌───────────────────────────┐
    │  SQL Server Process 1     │
    │  sqlservr.exe (CENTRAL)   │
    │  PID: 45678               │
    │  Listen: 0.0.0.0:1436     │
    └─────────┬────────┬────────┘
              │        │
    ┌─────────┘        └─────────┐
    │ TCP 1437                   │ TCP 1438
    ▼                            ▼
┌─────────────────┐      ┌─────────────────┐
│ SQL Process 2   │      │ SQL Process 3   │
│ sqlservr.exe    │      │ sqlservr.exe    │
│ (SITE1)         │      │ (SITE2)         │
│ PID: 56789      │      │ PID: 67890      │
│ Listen:         │      │ Listen:         │
│ 0.0.0.0:1437    │      │ 0.0.0.0:1438    │
└─────────────────┘      └─────────────────┘

PORT MAPPING:
- 1436: Central Server (SQLEXPRESS06)
  - Role: Coordinator
  - Contains: Views, Stored Procedures, Linked Servers
  - Connections: FROM Client, TO Site1 (1437), TO Site2 (1438)

- 1437: Site1 Server (SQLEXPRESS07)
  - Role: Data Node 1
  - Contains: NhaXB_Site1, TacGia_Site1, DocGia_Site1, Sach_Site1, Muon_Site1
  - Connections: FROM Central (1436)

- 1438: Site2 Server (SQLEXPRESS08)
  - Role: Data Node 2
  - Contains: NhaXB_Site2, TacGia_Site2, DocGia_Site2, Sach_Site2, Muon_Site2
  - Connections: FROM Central (1436)

FIREWALL CONFIGURATION:
┌────────────────────────────────────┐
│ Windows Defender Firewall          │
├────────────────────────────────────┤
│ Inbound Rules:                     │
│ ✓ SQL Server 1436 (Enabled)        │
│ ✓ SQL Server 1437 (Enabled)        │
│ ✓ SQL Server 1438 (Enabled)        │
│                                    │
│ Protocols: TCP                     │
│ Action: Allow                      │
│ Scope: Local (127.0.0.1)           │
└────────────────────────────────────┘
```

---

## 7. TRANSPARENCY LAYERS (CÁC LỚP TRONG SUỐT)

```
┌─────────────────────────────────────────────────────────────────────┐
│                    TRANSPARENCY ARCHITECTURE                         │
└─────────────────────────────────────────────────────────────────────┘

CLIENT VIEW (Transparent to Client):
┌───────────────────────────────────────────────────────────────┐
│  Client chỉ thấy:                                              │
│  - Database: ThuVien_Central                                   │
│  - Tables: V_NhaXB, V_TacGia, V_DocGia, V_Sach, V_Muon        │
│  - Stored Procedures: SP_INSERT_*, SP_UPDATE_*, SP_DELETE_*   │
│                                                                │
│  Client KHÔNG biết:                                            │
│  - Site1, Site2 tồn tại                                        │
│  - Dữ liệu được phân mảnh như thế nào                          │
│  - Dữ liệu lưu ở đâu (Site1 hay Site2)                        │
└───────────────────────────────────────────────────────────────┘
                              │
                              │ All queries go through Central
                              ▼
┌───────────────────────────────────────────────────────────────┐
│  LAYER 1: FRAGMENTATION TRANSPARENCY                          │
│  ────────────────────────────────────────────────────────     │
│  Views (V_*) che giấu phân mảnh:                              │
│                                                                │
│  V_NhaXB = NhaXB_Site1 ∪ NhaXB_Site2                          │
│  V_TacGia = TacGia_Site1 ∪ TacGia_Site2                       │
│  V_DocGia = DocGia_Site1 ∪ DocGia_Site2                       │
│  V_Sach = Sach_Site1 ∪ Sach_Site2                             │
│  V_Muon = Muon_Site1 ∪ Muon_Site2                             │
│                                                                │
│  Client query: SELECT * FROM V_NhaXB                           │
│  → Tự động lấy dữ liệu từ cả Site1 và Site2                   │
│  → Client không cần biết có bao nhiêu sites                    │
└───────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌───────────────────────────────────────────────────────────────┐
│  LAYER 2: LOCATION TRANSPARENCY                               │
│  ────────────────────────────────────────────────────────     │
│  Linked Servers che giấu vị trí:                              │
│                                                                │
│  SITE1_SERVER → DESKTOP-4EOK9DU\SQLEXPRESS07,1437             │
│  SITE2_SERVER → DESKTOP-4EOK9DU\SQLEXPRESS08,1438             │
│                                                                │
│  View query:                                                   │
│  SELECT * FROM SITE1_SERVER.ThuVien_Site1.dbo.NhaXB_Site1     │
│                                                                │
│  → Client không cần biết:                                      │
│    - Server name (DESKTOP-4EOK9DU)                             │
│    - Instance name (SQLEXPRESS07)                              │
│    - Port (1437)                                               │
│    - IP address (127.0.0.1)                                    │
│                                                                │
│  Nếu Site1 di chuyển sang server khác, chỉ cần cập nhật       │
│  Linked Server config, không sửa Views hay SPs                │
└───────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌───────────────────────────────────────────────────────────────┐
│  LAYER 3: REPLICATION TRANSPARENCY (N/A)                      │
│  ────────────────────────────────────────────────────────     │
│  Hệ thống hiện tại KHÔNG có replication:                      │
│  - Mỗi row chỉ tồn tại tại 1 site duy nhất                    │
│  - Không có bản sao (copy) ở site khác                        │
│                                                                │
│  Nếu có replication (future enhancement):                     │
│  - Client query vẫn: SELECT * FROM V_NhaXB                    │
│  - View sẽ tự động chọn site nào có data (hoặc merge)         │
│  - Client không cần biết có replication hay không             │
└───────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌───────────────────────────────────────────────────────────────┐
│  ROUTING LOGIC (Stored Procedures)                            │
│  ────────────────────────────────────────────────────────     │
│  SP_INSERT_NHAXB:                                              │
│    IF @ThanhPho = 'T1' → INSERT vào Site1                     │
│    IF @ThanhPho = 'T2' → INSERT vào Site2                     │
│                                                                │
│  SP_UPDATE_NHAXB:                                              │
│    IF ThanhPho thay đổi (T1→T2):                              │
│      1. DELETE từ Site1                                        │
│      2. INSERT vào Site2                                       │
│                                                                │
│  SP_DELETE_NHAXB:                                              │
│    1. Check FK: SELECT COUNT(*) FROM V_Sach WHERE MaNXB=...   │
│    2. IF count = 0:                                            │
│       - Tìm site nào có row này (Site1 hoặc Site2)            │
│       - DELETE từ site đó                                      │
└───────────────────────────────────────────────────────────────┘
```

---

## 8. LEGEND (CHƯƠNG TRÌNH GIẢI THÍCH)

```
SYMBOLS:
│   : Vertical line (đường dọc)
─   : Horizontal line (đường ngang)
┌   : Top-left corner
┐   : Top-right corner
└   : Bottom-left corner
┘   : Bottom-right corner
├   : Left junction
┤   : Right junction
┬   : Top junction
┴   : Bottom junction
┼   : Cross junction
▼   : Arrow down
▲   : Arrow up
►   : Arrow right
◄   : Arrow left
→   : Arrow right (alternative)
←   : Arrow left (alternative)
∪   : Union (UNION ALL)
∈   : Element of (thuộc)
→   : Maps to (ánh xạ)

ABBREVIATIONS:
PK  : Primary Key (Khóa chính)
FK  : Foreign Key (Khóa ngoại)
ĐT  : Điện tử
MT  : Máy tính
HS  : Học sinh
SV  : Sinh viên
NXB : Nhà xuất bản
TG  : Tác giả
DG  : Độc giả
CB  : Cơ bản
ĐH QG: Đại học Quốc Gia
VĂ  : Văn A (Nguyễn Văn A)
TB  : Thị B (Trần Thị B)
VC  : Văn C (Lê Văn C)
TĐ  : Thị D (Phạm Thị D)
VX  : Văn X (Trần Văn X)
TY  : Thị Y (Nguyễn Thị Y)
VZ  : Văn Z (Lê Văn Z)
TW  : Thị W (Phạm Thị W)
```

**HẾT SƠ ĐỒ**

---

## HƯỚNG DẪN VẼ LẠI BẰNG DRAW.IO/VISIO

1. **Kiến trúc 3-tier**: Dùng rectangles (hình chữ nhật) cho mỗi tier, arrows (mũi tên) cho connections
2. **Phân mảnh**: Dùng cylinders (hình trụ) cho databases, rounded rectangles cho tables
3. **Data Flow**: Dùng flowchart shapes với numbered steps
4. **ER Diagram**: Dùng entity shapes (rectangles), diamond cho relationships, crows foot notation cho cardinality
5. **Network Topology**: Dùng cloud shapes cho network, server icons cho SQL instances

**Colors suggested**:

- Client (Presentation): Light Blue (#E3F2FD)
- Central (Business Logic): Light Green (#E8F5E9)
- Site1: Light Orange (#FFF3E0)
- Site2: Light Purple (#F3E5F5)
- Arrows: Dark Gray (#424242)
