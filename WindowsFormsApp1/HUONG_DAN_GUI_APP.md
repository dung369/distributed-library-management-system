# HƯỚNG DẪN GỬI WINDOWS FORMS APP CHO BẠN

## 📦 CHUẨN BỊ FILE GỬI

### Bước 1: Build Release Version

1. Mở Visual Studio
2. Chọn **Build** → **Configuration Manager**
3. Chọn **Release** (thay vì Debug)
4. **Build** → **Rebuild Solution**
5. Kiểm tra folder: `bin\Release\` sẽ có file `.exe`

### Bước 2: Nén toàn bộ folder bin\Release

```powershell
# Nén folder Release
Compress-Archive -Path "d:\New folder (11)\WindowsFormsApp1\bin\Release\*" -DestinationPath "d:\ThuVien_WinForms_App.zip" -Force
```

---

## ⚙️ HƯỚNG DẪN BẠN CÀI ĐẶT

### Bước 1: Giải nén file ZIP

Giải nén `ThuVien_WinForms_App.zip` vào thư mục bất kỳ (ví dụ: `C:\ThuVien_App\`)

### Bước 2: Sửa file App.config

Mở file **WindowsFormsApp1.exe.config** bằng Notepad, tìm dòng:

```xml
<add key="ServerIP" value="localhost" />
```

Sửa thành IP của server (máy bạn):

```xml
<add key="ServerIP" value="172.20.10.6" />
```

**LƯU Ý:** File config có tên đầy đủ là `WindowsFormsApp1.exe.config` (không phải `App.config`)

### Bước 3: Chạy ứng dụng

Double-click file **WindowsFormsApp1.exe**

Nếu thiếu .NET Framework 4.7.2, tải tại:
https://dotnet.microsoft.com/download/dotnet-framework/net472

---

## 🔥 YÊU CẦU TRÊN SERVER (Máy bạn - 172.20.10.6)

**Phải chạy các lệnh sau để mở firewall:**

```powershell
# Mở PowerShell as Administrator và chạy:

# 1. Mở port 1436 (SQLEXPRESS06 - Central)
New-NetFirewallRule -DisplayName "SQL Server Central Port 1436" -Direction Inbound -Protocol TCP -LocalPort 1436 -Action Allow

# 2. Mở port SQL Browser
New-NetFirewallRule -DisplayName "SQL Browser" -Direction Inbound -Protocol UDP -LocalPort 1434 -Action Allow

# 3. Bật SQL Browser Service
Set-Service -Name 'SQLBrowser' -StartupType Automatic
Start-Service -Name 'SQLBrowser'

# 4. Kiểm tra port đang lắng nghe
netstat -an | findstr 1436
```

**Nếu thấy `0.0.0.0:1436` là OK!**

---

## 🐛 XỬ LÝ LỖI

### Lỗi 1: "A network-related error occurred"

**Nguyên nhân:** Firewall chặn hoặc SQL Server chưa bật remote connections

**Giải pháp:**

1. Kiểm tra firewall đã mở chưa (xem phần trên)
2. Test kết nối bằng SSMS từ máy bạn tôi:
   - Server: `172.20.10.6,1436`
   - Login: `sa` / `123456`
   - Nếu SSMS kết nối được → WinForms cũng OK

### Lỗi 2: "Login failed for user 'sa'"

**Nguyên nhân:** SQL Server chưa bật Mixed Mode Authentication

**Giải pháp (trên server):**

1. SSMS → Chuột phải Server → Properties
2. Security → Chọn "SQL Server and Windows Authentication mode"
3. Restart SQL Server:
   ```powershell
   Restart-Service -Name 'MSSQL$SQLEXPRESS06' -Force
   ```

### Lỗi 3: App không hiển thị Unicode đúng

**Nguyên nhân:** Database chưa chạy script fix Unicode

**Giải pháp (trên server):**
Chạy file `07B_FixUnicode.sql` trong SSMS trên SQLEXPRESS06

---

## ✅ CHECKLIST HOÀN THÀNH

**Trên Server (172.20.10.6):**

- [ ] Firewall đã mở port 1436
- [ ] SQL Browser đã chạy
- [ ] SQL Server đã bật Mixed Mode
- [ ] Database ThuVien_Central đã có đầy đủ dữ liệu

**Trên Client (máy bạn tôi):**

- [ ] Đã giải nén file ZIP
- [ ] Đã sửa `WindowsFormsApp1.exe.config` (ServerIP = 172.20.10.6)
- [ ] Đã cài .NET Framework 4.7.2
- [ ] Test SSMS kết nối thành công

---

## 📁 CẤU TRÚC FILE GỬI

```
ThuVien_WinForms_App.zip
├── WindowsFormsApp1.exe              ← File chạy chính
├── WindowsFormsApp1.exe.config       ← Sửa ServerIP ở đây!
├── System.Data.SqlClient.dll
└── (các file DLL khác)
```

---

## 🎯 LƯU Ý QUAN TRỌNG

1. **KHÔNG gửi folder SQLScripts** - Bạn tôi không cần (database đã có sẵn trên server)
2. **CHỈ gửi folder bin\Release** - Nhỏ gọn, đủ để chạy
3. **Nhắc bạn sửa file .config** - Nếu không sửa sẽ lỗi ngay

---

## 🚀 CÁCH KHÁC: Dùng ClickOnce Deployment

Nếu muốn chuyên nghiệp hơn, có thể publish bằng ClickOnce:

1. Visual Studio → **Build** → **Publish WindowsFormsApp1**
2. Chọn **Folder** → Chọn đường dẫn
3. **Publish**
4. Gửi folder publish cho bạn
5. Bạn chạy file `setup.exe`

Nhưng cách đơn giản nhất vẫn là nén `bin\Release\`! 📦
