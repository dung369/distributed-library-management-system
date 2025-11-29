-- =============================================
-- Script: Fix Unicode cho dữ liệu bị lỗi encoding
-- CHẠY TRONG SSMS (KHÔNG DÙNG SQLCMD!)
-- =============================================

USE ThuVien_Central
GO

PRINT N'========================================='
PRINT N'BẮT ĐẦU FIX UNICODE'
PRINT N'========================================='
GO

-- =============================================
-- Fix TacGia - ChuyenMon
-- =============================================
PRINT N'Đang fix TacGia...'
GO

-- Site1: Điện tử
UPDATE SITE1_SERVER.ThuVien_Site1.dbo.TacGia_Site1
SET ChuyenMon = N'Điện tử'
WHERE MaTG IN ('TG001', 'TG003')

-- Site2: Máy tính  
UPDATE SITE2_SERVER.ThuVien_Site2.dbo.TacGia_Site2
SET ChuyenMon = N'Máy tính'
WHERE MaTG IN ('TG002', 'TG004')

PRINT N'✓ Đã fix ChuyenMon cho 4 tác giả'
GO

-- =============================================
-- Fix TacGia - TenTG
-- =============================================
UPDATE SITE1_SERVER.ThuVien_Site1.dbo.TacGia_Site1
SET TenTG = N'Nguyễn Văn A'
WHERE MaTG = 'TG001'

UPDATE SITE1_SERVER.ThuVien_Site1.dbo.TacGia_Site1
SET TenTG = N'Lê Văn C'
WHERE MaTG = 'TG003'

UPDATE SITE2_SERVER.ThuVien_Site2.dbo.TacGia_Site2
SET TenTG = N'Trần Thị B'
WHERE MaTG = 'TG002'

UPDATE SITE2_SERVER.ThuVien_Site2.dbo.TacGia_Site2
SET TenTG = N'Phạm Thị D'
WHERE MaTG = 'TG004'

PRINT N'✓ Đã fix TenTG cho 4 tác giả'
GO

-- =============================================
-- Fix NhaXB
-- =============================================
PRINT N'Đang fix NhaXB...'
GO

UPDATE SITE1_SERVER.ThuVien_Site1.dbo.NhaXB_Site1
SET TenNXB = N'Giáo dục'
WHERE MaNXB = 'NXB01'

UPDATE SITE1_SERVER.ThuVien_Site1.dbo.NhaXB_Site1
SET TenNXB = N'Trẻ'
WHERE MaNXB = 'NXB02'

UPDATE SITE2_SERVER.ThuVien_Site2.dbo.NhaXB_Site2
SET TenNXB = N'KHKT'
WHERE MaNXB = 'NXB03'

UPDATE SITE2_SERVER.ThuVien_Site2.dbo.NhaXB_Site2
SET TenNXB = N'Đại học Quốc Gia'
WHERE MaNXB = 'NXB04'

PRINT N'✓ Đã fix TenNXB cho 4 nhà xuất bản'
GO

-- =============================================
-- Fix DocGia
-- =============================================
PRINT N'Đang fix DocGia...'
GO

UPDATE SITE1_SERVER.ThuVien_Site1.dbo.DocGia_Site1
SET TenDG = N'Hoàng Văn Nam'
WHERE MaDG = 'DG001'

UPDATE SITE1_SERVER.ThuVien_Site1.dbo.DocGia_Site1
SET TenDG = N'Võ Thị Lan'
WHERE MaDG = 'DG002'

UPDATE SITE2_SERVER.ThuVien_Site2.dbo.DocGia_Site2
SET TenDG = N'Đặng Văn Hùng'
WHERE MaDG = 'DG003'

UPDATE SITE2_SERVER.ThuVien_Site2.dbo.DocGia_Site2
SET TenDG = N'Bùi Thị Hoa'
WHERE MaDG = 'DG004'

PRINT N'✓ Đã fix TenDG cho 4 độc giả'
GO

-- =============================================
-- Fix Sach
-- =============================================
PRINT N'Đang fix Sach...'
GO

-- Site1
UPDATE SITE1_SERVER.ThuVien_Site1.dbo.Sach_Site1
SET TenSach = N'Cơ sở Điện tử'
WHERE MaSach = 'S0001'

UPDATE SITE1_SERVER.ThuVien_Site1.dbo.Sach_Site1
SET TenSach = N'Mạch số'
WHERE MaSach = 'S0003'

UPDATE SITE1_SERVER.ThuVien_Site1.dbo.Sach_Site1
SET TenSach = N'Vi xử lý'
WHERE MaSach = 'S0005'

-- Site2
UPDATE SITE2_SERVER.ThuVien_Site2.dbo.Sach_Site2
SET TenSach = N'Lập trình C++'
WHERE MaSach = 'S0002'

UPDATE SITE2_SERVER.ThuVien_Site2.dbo.Sach_Site2
SET TenSach = N'Cơ sở dữ liệu'
WHERE MaSach = 'S0004'

PRINT N'✓ Đã fix TenSach cho 5 sách'
GO

-- =============================================
-- VERIFICATION
-- =============================================
PRINT N''
PRINT N'========================================='
PRINT N'KIỂM TRA KẾT QUẢ SAU KHI FIX'
PRINT N'========================================='
GO

PRINT N'--- TÁC GIẢ ---'
SELECT MaTG, TenTG, ChuyenMon, SiteLocation 
FROM V_TacGia 
ORDER BY SiteLocation, MaTG
GO

PRINT N'--- NHÀ XUẤT BẢN ---'
SELECT MaNXB, TenNXB, ThanhPho, SiteLocation 
FROM V_NhaXB 
ORDER BY SiteLocation, MaNXB
GO

PRINT N'--- ĐỘC GIẢ ---'
SELECT MaDG, TenDG, DoiTuong, SiteLocation 
FROM V_DocGia 
ORDER BY SiteLocation, MaDG
GO

PRINT N'--- SÁCH ---'
SELECT MaSach, TenSach, NamXB, SiteLocation 
FROM V_Sach 
ORDER BY MaSach
GO

PRINT N'========================================='
PRINT N'HOÀN THÀNH FIX UNICODE'
PRINT N'========================================='
