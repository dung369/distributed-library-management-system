-- =============================================
-- Script: Xóa toàn bộ dữ liệu cũ trước khi insert lại
-- CHẠY TRÊN: DESKTOP-4EOK9DU\SQLEXPRESS06 (Port 1436)
-- MỤC ĐÍCH: Clear dữ liệu để tránh lỗi PRIMARY KEY duplicate
-- =============================================

USE ThuVien_Central
GO

PRINT N'========================================='
PRINT N'BẮT ĐẦU XÓA DỮ LIỆU CŨ'
PRINT N'========================================='
GO

-- =============================================
-- Xóa theo thứ tự: Con trước, Cha sau (tránh lỗi FOREIGN KEY)
-- =============================================

-- 1. Xóa Phiếu mượn (không có con)
PRINT N'Đang xóa Phiếu mượn...'
GO

DELETE FROM SITE1_SERVER.ThuVien_Site1.dbo.Muon_Site1
DELETE FROM SITE2_SERVER.ThuVien_Site2.dbo.Muon_Site2
GO

PRINT N'✓ Đã xóa toàn bộ phiếu mượn'
GO

-- 2. Xóa Sách (có con là Muon)
PRINT N'Đang xóa Sách...'
GO

DELETE FROM SITE1_SERVER.ThuVien_Site1.dbo.Sach_Site1
DELETE FROM SITE2_SERVER.ThuVien_Site2.dbo.Sach_Site2
GO

PRINT N'✓ Đã xóa toàn bộ sách'
GO

-- 3. Xóa Nhà xuất bản (có con là Sach)
PRINT N'Đang xóa Nhà xuất bản...'
GO

DELETE FROM SITE1_SERVER.ThuVien_Site1.dbo.NhaXB_Site1
DELETE FROM SITE2_SERVER.ThuVien_Site2.dbo.NhaXB_Site2
GO

PRINT N'✓ Đã xóa toàn bộ nhà xuất bản'
GO

-- 4. Xóa Tác giả (có con là Sach)
PRINT N'Đang xóa Tác giả...'
GO

DELETE FROM SITE1_SERVER.ThuVien_Site1.dbo.TacGia_Site1
DELETE FROM SITE2_SERVER.ThuVien_Site2.dbo.TacGia_Site2
GO

PRINT N'✓ Đã xóa toàn bộ tác giả'
GO

-- 5. Xóa Độc giả (có con là Muon)
PRINT N'Đang xóa Độc giả...'
GO

DELETE FROM SITE1_SERVER.ThuVien_Site1.dbo.DocGia_Site1
DELETE FROM SITE2_SERVER.ThuVien_Site2.dbo.DocGia_Site2
GO

PRINT N'✓ Đã xóa toàn bộ độc giả'
GO

-- =============================================
-- Kiểm tra sau khi xóa (phải = 0 hết)
-- =============================================
PRINT N''
PRINT N'========================================='
PRINT N'KIỂM TRA SAU KHI XÓA'
PRINT N'========================================='
GO

PRINT N''
PRINT N'Số lượng dữ liệu còn lại (phải = 0):'
GO

SELECT 
    'Nhà xuất bản' AS BangDuLieu,
    (SELECT COUNT(*) FROM V_NhaXB) AS SoLuong
UNION ALL
SELECT 
    'Tác giả',
    (SELECT COUNT(*) FROM V_TacGia)
UNION ALL
SELECT 
    'Độc giả',
    (SELECT COUNT(*) FROM V_DocGia)
UNION ALL
SELECT 
    'Sách',
    (SELECT COUNT(*) FROM V_Sach)
UNION ALL
SELECT 
    'Phiếu mượn',
    (SELECT COUNT(*) FROM V_Muon)
GO

PRINT N''
PRINT N'========================================='
PRINT N'HOÀN THÀNH XÓA DỮ LIỆU CŨ'
PRINT N'Bây giờ có thể chạy 07_InsertData.sql'
PRINT N'========================================='
GO
