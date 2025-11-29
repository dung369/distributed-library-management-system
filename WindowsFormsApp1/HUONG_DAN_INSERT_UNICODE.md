# HƯỚNG DẪN INSERT DỮ LIỆU MẪU

## 🎯 Vấn đề Unicode trong SQL Server

Khi chạy script SQL qua `sqlcmd`, tiếng Việt có thể bị lỗi encoding do:

- SQL Server sử dụng collation mặc định
- Terminal encoding không khớp với SQL Server
- Các ký tự có dấu bị chuyển thành ký tự lạ

## ✅ Giải pháp: Chạy script trong SQL Server Management Studio

### Cách 1: Dùng SSMS (KHUYẾN NGHỊ)

**Bước 1: Xóa dữ liệu cũ**

1. Mở SQL Server Management Studio
2. Connect đến: `DESKTOP-4EOK9DU\SQLEXPRESS06,1436`
3. Mở file: `SQLScripts\07A_XoaDuLieuCu.sql`
4. Click **Execute** (F5)
5. Kiểm tra: Tất cả bảng phải có 0 records

**Bước 2: Insert dữ liệu mới**

1. Vẫn trong SSMS
2. Mở file: `SQLScripts\07_InsertData.sql`
3. Click **Execute** (F5)
4. Kiểm tra kết quả:
   - 4 Nhà xuất bản ✓
   - 4 Tác giả ✓
   - 4 Độc giả ✓
   - 5 Sách ✓
   - 5 Phiếu mượn ✓

**Ưu điểm:**

- ✅ Tiếng Việt hiển thị 100% chính xác
- ✅ Giao diện trực quan, dễ sử dụng
- ✅ Có syntax highlighting và IntelliSense
- ✅ Dễ debug khi có lỗi

---

### Cách 2: Dùng PowerShell với encoding UTF-8

**Chỉ dùng khi không có SSMS**

```powershell
# Bước 1: Xóa dữ liệu cũ
sqlcmd -S "DESKTOP-4EOK9DU\SQLEXPRESS06,1436" -i "SQLScripts\07A_XoaDuLieuCu.sql"

# Bước 2: Insert dữ liệu mới
sqlcmd -S "DESKTOP-4EOK9DU\SQLEXPRESS06,1436" -i "SQLScripts\07_InsertData.sql"
```

⚠️ **LƯU Ý:** Có thể vẫn gặp lỗi encoding. Nếu gặp lỗi, hãy dùng SSMS!

---

## 📊 Dữ liệu mẫu sau khi insert

### Nhà xuất bản (4 records)

| MaNXB | TenNXB           | ThanhPho | Site  |
| ----- | ---------------- | -------- | ----- |
| NXB01 | Giáo dục         | T1       | SITE1 |
| NXB02 | Trẻ              | T1       | SITE1 |
| NXB03 | KHKT             | T2       | SITE2 |
| NXB04 | Đại học Quốc Gia | T2       | SITE2 |

### Tác giả (4 records)

| MaTG  | TenTG        | ChuyenMon | Site  |
| ----- | ------------ | --------- | ----- |
| TG001 | Nguyễn Văn A | Điện tử   | SITE1 |
| TG002 | Trần Thị B   | Điện tử   | SITE1 |
| TG003 | Lê Văn C     | Máy tính  | SITE2 |
| TG004 | Phạm Thị D   | Máy tính  | SITE2 |

### Độc giả (4 records)

| MaDG  | TenDG         | DoiTuong | Site  |
| ----- | ------------- | -------- | ----- |
| DG001 | Hoàng Văn Nam | HS       | SITE1 |
| DG002 | Võ Thị Lan    | HS       | SITE1 |
| DG003 | Đặng Văn Hùng | SV       | SITE2 |
| DG004 | Bùi Thị Hoa   | SV       | SITE2 |

### Sách (5 records)

| MaSach | TenSach          | NamXB | MaNXB | MaTG  | Site  |
| ------ | ---------------- | ----- | ----- | ----- | ----- |
| S0001  | Cơ sở Điện tử    | 1998  | NXB01 | TG001 | SITE1 |
| S0002  | Mạch Điện tử     | 1998  | NXB02 | TG002 | SITE1 |
| S0003  | Lập trình C#     | 1999  | NXB03 | TG003 | SITE2 |
| S0004  | Cơ sở dữ liệu    | 2000  | NXB04 | TG004 | SITE2 |
| S0005  | Điện tử ứng dụng | 1998  | NXB01 | TG001 | SITE1 |

### Phiếu mượn (5 records)

| MaDG  | MaSach | NgayMuon   | NgayTra    | Site  |
| ----- | ------ | ---------- | ---------- | ----- |
| DG001 | S0001  | 15/01/1999 | 15/02/1999 | SITE1 |
| DG002 | S0002  | 20/01/1999 | 20/02/1999 | SITE1 |
| DG003 | S0003  | 10/02/1999 | 10/03/1999 | SITE2 |
| DG004 | S0004  | 05/03/1999 | 05/04/1999 | SITE2 |
| DG001 | S0005  | 15/06/1999 | 15/07/1999 | SITE1 |

---

## 🔧 Troubleshooting

### Lỗi: "Keyword not supported: 'charset'"

**Nguyên nhân:** Connection string không hỗ trợ tham số Charset

**Giải pháp:** Đã fix trong `DatabaseHelper.cs` - loại bỏ `;Charset=UTF8;`

### Lỗi: Chữ tiếng Việt hiển thị sai (Ã, Ä, â€¦, etc.)

**Nguyên nhân:** Dữ liệu được insert qua sqlcmd với encoding sai

**Giải pháp:**

1. Xóa dữ liệu cũ: Chạy `04A_XoaDuLieuCu.sql`
2. Insert lại qua menu ứng dụng: **Hệ thống → Insert dữ liệu mẫu**

### Lỗi: "Could not find server 'DESKTOP-4EOK9DU\SQLEXPRESS07,1437'"

**Nguyên nhân:** Tên Linked Server không đúng

**Giải pháp:** Đã fix - dùng `SITE1_SERVER` và `SITE2_SERVER` thay vì tên máy + port

---

## 📝 Lưu ý kỹ thuật

### Code C# insert Unicode đúng:

```csharp
SqlParameter[] parameters = {
    new SqlParameter("@TenNXB", "Giáo dục"),  // ✅ Unicode tự động
    new SqlParameter("@TenTG", "Nguyễn Văn A")  // ✅ Unicode tự động
};
DatabaseHelper.ExecuteStoredProcedure("SP_INSERT_NHAXB", parameters);
```

### SQL Script insert Unicode (KHÔNG khuyến nghị):

```sql
-- ❌ KHÔNG dùng cách này qua sqlcmd
EXEC SP_INSERT_NHAXB 'NXB01', N'Giáo dục', N'T1'
-- Dù có N'' prefix vẫn bị lỗi encoding qua sqlcmd

-- ✅ Dùng từ C# application thay thế
```

---

## 🎓 Kết luận

**LUÔN dùng menu ứng dụng** để insert dữ liệu mẫu thay vì chạy script SQL trực tiếp!

Điều này đảm bảo:

- ✅ Unicode hiển thị chính xác
- ✅ An toàn (SqlParameter tránh SQL Injection)
- ✅ Dễ sử dụng (không cần mở Terminal)
- ✅ Có validation và thông báo lỗi rõ ràng
