# CÁC BƯỚC CHUẨN BỊ APP ĐỂ GỬI CHO BẠN

## ✅ Bước 1: Thêm Reference System.Configuration

1. Mở **Visual Studio**
2. Trong **Solution Explorer**, chuột phải **References** → **Add Reference**
3. Tìm và tick ✅ **System.Configuration**
4. Click **OK**

## ✅ Bước 2: Build Release

```
Visual Studio → Build → Configuration Manager → Chọn "Release" → OK
Visual Studio → Build → Rebuild Solution
```

## ✅ Bước 3: Nén folder bin\Release

```powershell
Compress-Archive -Path "d:\New folder (11)\WindowsFormsApp1\bin\Release\*" -DestinationPath "d:\ThuVien_App.zip" -Force
```

## ✅ Bước 4: Mở Firewall trên máy bạn

```powershell
# Mở PowerShell as Administrator:
New-NetFirewallRule -DisplayName "SQL Central 1436" -Direction Inbound -Protocol TCP -LocalPort 1436 -Action Allow
New-NetFirewallRule -DisplayName "SQL Browser" -Direction Inbound -Protocol UDP -LocalPort 1434 -Action Allow
Start-Service -Name 'SQLBrowser'
```

## 📧 Gửi cho bạn:

1. File `ThuVien_App.zip`
2. File `HUONG_DAN_GUI_APP.md`

## 🔧 Bạn tôi làm gì:

1. Giải nén `ThuVien_App.zip`
2. Mở file `WindowsFormsApp1.exe.config` bằng Notepad
3. Sửa dòng:
   ```xml
   <add key="ServerIP" value="localhost" />
   ```
   Thành:
   ```xml
   <add key="ServerIP" value="172.20.10.6" />
   ```
4. Chạy `WindowsFormsApp1.exe`

XONG! 🎉
