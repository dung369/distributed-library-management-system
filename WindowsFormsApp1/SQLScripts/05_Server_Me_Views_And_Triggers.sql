-- =============================================
-- Script: Tạo Views Toàn Cục và Triggers
-- CHẠY TRÊN: DESKTOP-4EOK9DU\SQLEXPRESS06 (Port 1436)
-- =============================================

USE ThuVien_Central
GO

-- =============================================
-- VIEW 1: V_NhaXB - Tổng hợp tất cả nhà xuất bản
-- =============================================
IF OBJECT_ID('V_NhaXB', 'V') IS NOT NULL
    DROP VIEW V_NhaXB
GO

CREATE VIEW V_NhaXB
AS
    SELECT MaNXB, TenNXB, ThanhPho, 'SITE1' as SiteLocation
    FROM SITE1_SERVER.ThuVien_Site1.dbo.NhaXB_Site1
    UNION ALL
    SELECT MaNXB, TenNXB, ThanhPho, 'SITE2' as SiteLocation
    FROM SITE2_SERVER.ThuVien_Site2.dbo.NhaXB_Site2
GO

PRINT N'✓ Đã tạo View: V_NhaXB'
GO

-- =============================================
-- VIEW 2: V_TacGia - Tổng hợp tất cả tác giả
-- =============================================
IF OBJECT_ID('V_TacGia', 'V') IS NOT NULL
    DROP VIEW V_TacGia
GO

CREATE VIEW V_TacGia
AS
    SELECT MaTG, TenTG, ChuyenMon, 'SITE1' as SiteLocation
    FROM SITE1_SERVER.ThuVien_Site1.dbo.TacGia_Site1
    UNION ALL
    SELECT MaTG, TenTG, ChuyenMon, 'SITE2' as SiteLocation
    FROM SITE2_SERVER.ThuVien_Site2.dbo.TacGia_Site2
GO

PRINT N'✓ Đã tạo View: V_TacGia'
GO

-- =============================================
-- VIEW 3: V_Sach - Tổng hợp tất cả sách
-- =============================================
IF OBJECT_ID('V_Sach', 'V') IS NOT NULL
    DROP VIEW V_Sach
GO

CREATE VIEW V_Sach
AS
    SELECT MaSach, TenSach, NamXB, MaNXB, MaTG, 'SITE1' as SiteLocation
    FROM SITE1_SERVER.ThuVien_Site1.dbo.Sach_Site1
    UNION ALL
    SELECT MaSach, TenSach, NamXB, MaNXB, MaTG, 'SITE2' as SiteLocation
    FROM SITE2_SERVER.ThuVien_Site2.dbo.Sach_Site2
GO

PRINT N'✓ Đã tạo View: V_Sach'
GO

-- =============================================
-- VIEW 4: V_DocGia - Tổng hợp tất cả độc giả
-- =============================================
IF OBJECT_ID('V_DocGia', 'V') IS NOT NULL
    DROP VIEW V_DocGia
GO

CREATE VIEW V_DocGia
AS
    SELECT MaDG, TenDG, DoiTuong, 'SITE1' as SiteLocation
    FROM SITE1_SERVER.ThuVien_Site1.dbo.DocGia_Site1
    UNION ALL
    SELECT MaDG, TenDG, DoiTuong, 'SITE2' as SiteLocation
    FROM SITE2_SERVER.ThuVien_Site2.dbo.DocGia_Site2
GO

PRINT N'✓ Đã tạo View: V_DocGia'
GO

-- =============================================
-- VIEW 5: V_Muon - Tổng hợp tất cả phiếu mượn
-- =============================================
IF OBJECT_ID('V_Muon', 'V') IS NOT NULL
    DROP VIEW V_Muon
GO

CREATE VIEW V_Muon
AS
    SELECT MaDG, MaSach, NgayMuon, NgayTra, 'SITE1' as SiteLocation
    FROM SITE1_SERVER.ThuVien_Site1.dbo.Muon_Site1
    UNION ALL
    SELECT MaDG, MaSach, NgayMuon, NgayTra, 'SITE2' as SiteLocation
    FROM SITE2_SERVER.ThuVien_Site2.dbo.Muon_Site2
GO

PRINT N'✓ Đã tạo View: V_Muon'
GO

PRINT N''
PRINT N'========================================='
PRINT N'HOÀN THÀNH TẠO VIEWS TOÀN CỤC'
PRINT N'========================================='
GO
