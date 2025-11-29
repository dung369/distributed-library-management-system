-- =============================================
-- Script: Tạo Stored Procedures cho CRUD và Truy vấn
-- CHẠY TRÊN: DESKTOP-4EOK9DU\SQLEXPRESS06 (Port 1436)
-- =============================================

USE ThuVien_Central
GO

-- =============================================
-- SP_INSERT_NHAXB: Thêm nhà xuất bản
-- Phân mảnh theo ThanhPho: T1 -> Site1, T2 -> Site2
-- =============================================
IF OBJECT_ID('SP_INSERT_NHAXB', 'P') IS NOT NULL
    DROP PROCEDURE SP_INSERT_NHAXB
GO

CREATE PROCEDURE SP_INSERT_NHAXB
    @MaNXB char(5),
    @TenNXB nvarchar(50),
    @ThanhPho nvarchar(30)
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @ThanhPho = N'T1'
    BEGIN
        INSERT INTO SITE1_SERVER.ThuVien_Site1.dbo.NhaXB_Site1(MaNXB, TenNXB, ThanhPho)
        VALUES(@MaNXB, @TenNXB, @ThanhPho)
    END
    ELSE IF @ThanhPho = N'T2'
    BEGIN
        INSERT INTO SITE2_SERVER.ThuVien_Site2.dbo.NhaXB_Site2(MaNXB, TenNXB, ThanhPho)
        VALUES(@MaNXB, @TenNXB, @ThanhPho)
    END
    ELSE
    BEGIN
        RAISERROR(N'Thành phố phải là T1 hoặc T2', 16, 1)
    END
END
GO

-- =============================================
-- SP_UPDATE_NHAXB: Cập nhật nhà xuất bản
-- =============================================
IF OBJECT_ID('SP_UPDATE_NHAXB', 'P') IS NOT NULL
    DROP PROCEDURE SP_UPDATE_NHAXB
GO

CREATE PROCEDURE SP_UPDATE_NHAXB
    @MaNXB char(5),
    @TenNXB nvarchar(50),
    @ThanhPho nvarchar(30)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra ở Site1
    IF EXISTS (SELECT 1 FROM SITE1_SERVER.ThuVien_Site1.dbo.NhaXB_Site1 WHERE MaNXB = @MaNXB)
    BEGIN
        UPDATE SITE1_SERVER.ThuVien_Site1.dbo.NhaXB_Site1
        SET TenNXB = @TenNXB, ThanhPho = @ThanhPho
        WHERE MaNXB = @MaNXB
    END
    -- Kiểm tra ở Site2
    ELSE IF EXISTS (SELECT 1 FROM SITE2_SERVER.ThuVien_Site2.dbo.NhaXB_Site2 WHERE MaNXB = @MaNXB)
    BEGIN
        UPDATE SITE2_SERVER.ThuVien_Site2.dbo.NhaXB_Site2
        SET TenNXB = @TenNXB, ThanhPho = @ThanhPho
        WHERE MaNXB = @MaNXB
    END
END
GO

-- =============================================
-- SP_DELETE_NHAXB: Xóa nhà xuất bản (theo MaNXB và ThanhPho)
-- =============================================
IF OBJECT_ID('SP_DELETE_NHAXB', 'P') IS NOT NULL
    DROP PROCEDURE SP_DELETE_NHAXB
GO

CREATE PROCEDURE SP_DELETE_NHAXB
    @MaNXB char(5),
    @ThanhPho nvarchar(30) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Nếu không truyền ThanhPho, lấy từ DB
        IF @ThanhPho IS NULL
        BEGIN
            SELECT TOP 1 @ThanhPho = ThanhPho 
            FROM (
                SELECT ThanhPho FROM SITE1_SERVER.ThuVien_Site1.dbo.NhaXB_Site1 WHERE MaNXB = @MaNXB
                UNION ALL
                SELECT ThanhPho FROM SITE2_SERVER.ThuVien_Site2.dbo.NhaXB_Site2 WHERE MaNXB = @MaNXB
            ) AS NXB
        END
        
        -- Xóa theo site tương ứng với thành phố
        IF @ThanhPho = 'T1'
        BEGIN
            -- Xóa các sách liên quan ở Site1 trước
            DELETE FROM SITE1_SERVER.ThuVien_Site1.dbo.Muon_Site1 
            WHERE MaSach IN (SELECT MaSach FROM SITE1_SERVER.ThuVien_Site1.dbo.Sach_Site1 WHERE MaNXB = @MaNXB)
            
            DELETE FROM SITE1_SERVER.ThuVien_Site1.dbo.Sach_Site1 WHERE MaNXB = @MaNXB
            
            -- Sau đó xóa NXB
            DELETE FROM SITE1_SERVER.ThuVien_Site1.dbo.NhaXB_Site1 WHERE MaNXB = @MaNXB
        END
        ELSE IF @ThanhPho = 'T2'
        BEGIN
            -- Xóa các sách liên quan ở Site2 trước
            DELETE FROM SITE2_SERVER.ThuVien_Site2.dbo.Muon_Site2 
            WHERE MaSach IN (SELECT MaSach FROM SITE2_SERVER.ThuVien_Site2.dbo.Sach_Site2 WHERE MaNXB = @MaNXB)
            
            DELETE FROM SITE2_SERVER.ThuVien_Site2.dbo.Sach_Site2 WHERE MaNXB = @MaNXB
            
            -- Sau đó xóa NXB
            DELETE FROM SITE2_SERVER.ThuVien_Site2.dbo.NhaXB_Site2 WHERE MaNXB = @MaNXB
        END
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

-- =============================================
-- SP_INSERT_TACGIA: Thêm tác giả
-- Phân mảnh theo ChuyenMon: Điện tử -> Site1, Máy tính -> Site2
-- =============================================
IF OBJECT_ID('SP_INSERT_TACGIA', 'P') IS NOT NULL
    DROP PROCEDURE SP_INSERT_TACGIA
GO

CREATE PROCEDURE SP_INSERT_TACGIA
    @MaTG char(5),
    @TenTG nvarchar(50),
    @ChuyenMon nvarchar(30)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Loại bỏ khoảng trắng thừa và chuẩn hóa
    SET @ChuyenMon = LTRIM(RTRIM(@ChuyenMon))
    
    IF @ChuyenMon LIKE N'%i%n%t%' OR @ChuyenMon LIKE N'Di%n%t%' -- "Điện tử"
    BEGIN
        INSERT INTO SITE1_SERVER.ThuVien_Site1.dbo.TacGia_Site1(MaTG, TenTG, ChuyenMon)
        VALUES(@MaTG, @TenTG, N'Điện tử')
    END
    ELSE IF @ChuyenMon LIKE N'%y%t%nh' OR @ChuyenMon LIKE N'Ma%' -- "Máy tính"
    BEGIN
        INSERT INTO SITE2_SERVER.ThuVien_Site2.dbo.TacGia_Site2(MaTG, TenTG, ChuyenMon)
        VALUES(@MaTG, @TenTG, N'Máy tính')
    END
    ELSE
    BEGIN
        RAISERROR(N'Chuyên môn phải là "Điện tử" hoặc "Máy tính"', 16, 1)
    END
END
GO

-- =============================================
-- SP_UPDATE_TACGIA: Cập nhật tác giả
-- =============================================
IF OBJECT_ID('SP_UPDATE_TACGIA', 'P') IS NOT NULL
    DROP PROCEDURE SP_UPDATE_TACGIA
GO

CREATE PROCEDURE SP_UPDATE_TACGIA
    @MaTG char(5),
    @TenTG nvarchar(50),
    @ChuyenMon nvarchar(30)
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT 1 FROM SITE1_SERVER.ThuVien_Site1.dbo.TacGia_Site1 WHERE MaTG = @MaTG)
    BEGIN
        UPDATE SITE1_SERVER.ThuVien_Site1.dbo.TacGia_Site1
        SET TenTG = @TenTG, ChuyenMon = @ChuyenMon
        WHERE MaTG = @MaTG
    END
    ELSE IF EXISTS (SELECT 1 FROM SITE2_SERVER.ThuVien_Site2.dbo.TacGia_Site2 WHERE MaTG = @MaTG)
    BEGIN
        UPDATE SITE2_SERVER.ThuVien_Site2.dbo.TacGia_Site2
        SET TenTG = @TenTG, ChuyenMon = @ChuyenMon
        WHERE MaTG = @MaTG
    END
END
GO

-- =============================================
-- SP_DELETE_TACGIA: Xóa tác giả
-- =============================================
IF OBJECT_ID('SP_DELETE_TACGIA', 'P') IS NOT NULL
    DROP PROCEDURE SP_DELETE_TACGIA
GO

CREATE PROCEDURE SP_DELETE_TACGIA
    @MaTG char(5)
AS
BEGIN
    SET NOCOUNT ON;
    
    DELETE FROM SITE1_SERVER.ThuVien_Site1.dbo.TacGia_Site1 WHERE MaTG = @MaTG
    DELETE FROM SITE2_SERVER.ThuVien_Site2.dbo.TacGia_Site2 WHERE MaTG = @MaTG
END
GO

-- =============================================
-- SP_INSERT_DOCGIA: Thêm độc giả
-- Phân mảnh theo DoiTuong: HS -> Site1, SV -> Site2
-- =============================================
IF OBJECT_ID('SP_INSERT_DOCGIA', 'P') IS NOT NULL
    DROP PROCEDURE SP_INSERT_DOCGIA
GO

CREATE PROCEDURE SP_INSERT_DOCGIA
    @MaDG char(5),
    @TenDG nvarchar(50),
    @DoiTuong nvarchar(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @DoiTuong = N'HS'
    BEGIN
        INSERT INTO SITE1_SERVER.ThuVien_Site1.dbo.DocGia_Site1(MaDG, TenDG, DoiTuong)
        VALUES(@MaDG, @TenDG, @DoiTuong)
    END
    ELSE IF @DoiTuong = N'SV'
    BEGIN
        INSERT INTO SITE2_SERVER.ThuVien_Site2.dbo.DocGia_Site2(MaDG, TenDG, DoiTuong)
        VALUES(@MaDG, @TenDG, @DoiTuong)
    END
    ELSE
    BEGIN
        RAISERROR(N'Đối tượng phải là HS hoặc SV', 16, 1)
    END
END
GO

-- =============================================
-- SP_UPDATE_DOCGIA: Cập nhật độc giả
-- =============================================
IF OBJECT_ID('SP_UPDATE_DOCGIA', 'P') IS NOT NULL
    DROP PROCEDURE SP_UPDATE_DOCGIA
GO

CREATE PROCEDURE SP_UPDATE_DOCGIA
    @MaDG char(5),
    @TenDG nvarchar(50),
    @DoiTuong nvarchar(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT 1 FROM SITE1_SERVER.ThuVien_Site1.dbo.DocGia_Site1 WHERE MaDG = @MaDG)
    BEGIN
        UPDATE SITE1_SERVER.ThuVien_Site1.dbo.DocGia_Site1
        SET TenDG = @TenDG, DoiTuong = @DoiTuong
        WHERE MaDG = @MaDG
    END
    ELSE IF EXISTS (SELECT 1 FROM SITE2_SERVER.ThuVien_Site2.dbo.DocGia_Site2 WHERE MaDG = @MaDG)
    BEGIN
        UPDATE SITE2_SERVER.ThuVien_Site2.dbo.DocGia_Site2
        SET TenDG = @TenDG, DoiTuong = @DoiTuong
        WHERE MaDG = @MaDG
    END
END
GO

-- =============================================
-- SP_DELETE_DOCGIA: Xóa độc giả
-- =============================================
IF OBJECT_ID('SP_DELETE_DOCGIA', 'P') IS NOT NULL
    DROP PROCEDURE SP_DELETE_DOCGIA
GO

CREATE PROCEDURE SP_DELETE_DOCGIA
    @MaDG char(5)
AS
BEGIN
    SET NOCOUNT ON;
    
    DELETE FROM SITE1_SERVER.ThuVien_Site1.dbo.DocGia_Site1 WHERE MaDG = @MaDG
    DELETE FROM SITE2_SERVER.ThuVien_Site2.dbo.DocGia_Site2 WHERE MaDG = @MaDG
END
GO

-- =============================================
-- SP_INSERT_SACH: Thêm sách (theo site của Tác giả)
-- =============================================
IF OBJECT_ID('SP_INSERT_SACH', 'P') IS NOT NULL
    DROP PROCEDURE SP_INSERT_SACH
GO

CREATE PROCEDURE SP_INSERT_SACH
    @MaSach char(5),
    @TenSach nvarchar(100),
    @NamXB int,
    @MaNXB char(5),
    @MaTG char(5)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Tìm site của tác giả
    IF EXISTS (SELECT 1 FROM SITE1_SERVER.ThuVien_Site1.dbo.TacGia_Site1 WHERE MaTG = @MaTG)
    BEGIN
        INSERT INTO SITE1_SERVER.ThuVien_Site1.dbo.Sach_Site1(MaSach, TenSach, NamXB, MaNXB, MaTG)
        VALUES(@MaSach, @TenSach, @NamXB, @MaNXB, @MaTG)
    END
    ELSE IF EXISTS (SELECT 1 FROM SITE2_SERVER.ThuVien_Site2.dbo.TacGia_Site2 WHERE MaTG = @MaTG)
    BEGIN
        INSERT INTO SITE2_SERVER.ThuVien_Site2.dbo.Sach_Site2(MaSach, TenSach, NamXB, MaNXB, MaTG)
        VALUES(@MaSach, @TenSach, @NamXB, @MaNXB, @MaTG)
    END
END
GO

-- =============================================
-- SP_UPDATE_SACH: Cập nhật sách
-- =============================================
IF OBJECT_ID('SP_UPDATE_SACH', 'P') IS NOT NULL
    DROP PROCEDURE SP_UPDATE_SACH
GO

CREATE PROCEDURE SP_UPDATE_SACH
    @MaSach char(5),
    @TenSach nvarchar(100),
    @NamXB int,
    @MaNXB char(5),
    @MaTG char(5)
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT 1 FROM SITE1_SERVER.ThuVien_Site1.dbo.Sach_Site1 WHERE MaSach = @MaSach)
    BEGIN
        UPDATE SITE1_SERVER.ThuVien_Site1.dbo.Sach_Site1
        SET TenSach = @TenSach, NamXB = @NamXB, MaNXB = @MaNXB, MaTG = @MaTG
        WHERE MaSach = @MaSach
    END
    ELSE IF EXISTS (SELECT 1 FROM SITE2_SERVER.ThuVien_Site2.dbo.Sach_Site2 WHERE MaSach = @MaSach)
    BEGIN
        UPDATE SITE2_SERVER.ThuVien_Site2.dbo.Sach_Site2
        SET TenSach = @TenSach, NamXB = @NamXB, MaNXB = @MaNXB, MaTG = @MaTG
        WHERE MaSach = @MaSach
    END
END
GO

-- =============================================
-- SP_DELETE_SACH: Xóa sách
-- =============================================
IF OBJECT_ID('SP_DELETE_SACH', 'P') IS NOT NULL
    DROP PROCEDURE SP_DELETE_SACH
GO

CREATE PROCEDURE SP_DELETE_SACH
    @MaSach char(5)
AS
BEGIN
    SET NOCOUNT ON;
    
    DELETE FROM SITE1_SERVER.ThuVien_Site1.dbo.Sach_Site1 WHERE MaSach = @MaSach
    DELETE FROM SITE2_SERVER.ThuVien_Site2.dbo.Sach_Site2 WHERE MaSach = @MaSach
END
GO

-- =============================================
-- SP_INSERT_MUON: Thêm phiếu mượn (theo site của độc giả)
-- =============================================
IF OBJECT_ID('SP_INSERT_MUON', 'P') IS NOT NULL
    DROP PROCEDURE SP_INSERT_MUON
GO

CREATE PROCEDURE SP_INSERT_MUON
    @MaDG char(5),
    @MaSach char(5),
    @NgayMuon datetime,
    @NgayTra datetime
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Tìm site của độc giả
    IF EXISTS (SELECT 1 FROM SITE1_SERVER.ThuVien_Site1.dbo.DocGia_Site1 WHERE MaDG = @MaDG)
    BEGIN
        INSERT INTO SITE1_SERVER.ThuVien_Site1.dbo.Muon_Site1(MaDG, MaSach, NgayMuon, NgayTra)
        VALUES(@MaDG, @MaSach, @NgayMuon, @NgayTra)
    END
    ELSE IF EXISTS (SELECT 1 FROM SITE2_SERVER.ThuVien_Site2.dbo.DocGia_Site2 WHERE MaDG = @MaDG)
    BEGIN
        INSERT INTO SITE2_SERVER.ThuVien_Site2.dbo.Muon_Site2(MaDG, MaSach, NgayMuon, NgayTra)
        VALUES(@MaDG, @MaSach, @NgayMuon, @NgayTra)
    END
END
GO

-- =============================================
-- SP_UPDATE_MUON: Cập nhật phiếu mượn
-- =============================================
IF OBJECT_ID('SP_UPDATE_MUON', 'P') IS NOT NULL
    DROP PROCEDURE SP_UPDATE_MUON
GO

CREATE PROCEDURE SP_UPDATE_MUON
    @MaDG char(5),
    @MaSach char(5),
    @NgayMuon datetime,
    @NgayTra datetime
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT 1 FROM SITE1_SERVER.ThuVien_Site1.dbo.Muon_Site1 WHERE MaDG = @MaDG AND MaSach = @MaSach AND NgayMuon = @NgayMuon)
    BEGIN
        UPDATE SITE1_SERVER.ThuVien_Site1.dbo.Muon_Site1
        SET NgayTra = @NgayTra
        WHERE MaDG = @MaDG AND MaSach = @MaSach AND NgayMuon = @NgayMuon
    END
    ELSE IF EXISTS (SELECT 1 FROM SITE2_SERVER.ThuVien_Site2.dbo.Muon_Site2 WHERE MaDG = @MaDG AND MaSach = @MaSach AND NgayMuon = @NgayMuon)
    BEGIN
        UPDATE SITE2_SERVER.ThuVien_Site2.dbo.Muon_Site2
        SET NgayTra = @NgayTra
        WHERE MaDG = @MaDG AND MaSach = @MaSach AND NgayMuon = @NgayMuon
    END
END
GO

-- =============================================
-- SP_DELETE_MUON: Xóa phiếu mượn
-- =============================================
IF OBJECT_ID('SP_DELETE_MUON', 'P') IS NOT NULL
    DROP PROCEDURE SP_DELETE_MUON
GO

CREATE PROCEDURE SP_DELETE_MUON
    @MaDG char(5),
    @MaSach char(5),
    @NgayMuon datetime
AS
BEGIN
    SET NOCOUNT ON;
    
    DELETE FROM SITE1_SERVER.ThuVien_Site1.dbo.Muon_Site1 
    WHERE MaDG = @MaDG AND MaSach = @MaSach AND NgayMuon = @NgayMuon
    
    DELETE FROM SITE2_SERVER.ThuVien_Site2.dbo.Muon_Site2 
    WHERE MaDG = @MaDG AND MaSach = @MaSach AND NgayMuon = @NgayMuon
END
GO

-- =============================================
-- TRUY VẤN 1: Số lượng sách xuất bản năm 1998 theo nhà xuất bản
-- =============================================
IF OBJECT_ID('SP_Query1_SachNam1998', 'P') IS NOT NULL
    DROP PROCEDURE SP_Query1_SachNam1998
GO

CREATE PROCEDURE SP_Query1_SachNam1998
    @TenNXB nvarchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT COUNT(DISTINCT s.TenSach) AS SoLuongSach
    FROM V_Sach s
    JOIN V_NhaXB n ON s.MaNXB = n.MaNXB
    WHERE n.TenNXB = @TenNXB AND s.NamXB = 1998
END
GO

-- =============================================
-- TRUY VẤN 2: Sách của tác giả được mượn trong khoảng thời gian
-- =============================================
IF OBJECT_ID('SP_Query2_SachTacGiaMuon', 'P') IS NOT NULL
    DROP PROCEDURE SP_Query2_SachTacGiaMuon
GO

CREATE PROCEDURE SP_Query2_SachTacGiaMuon
    @MaTG char(5)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT DISTINCT s.MaSach, s.TenSach
    FROM V_Sach s
    JOIN V_Muon m ON s.MaSach = m.MaSach
    WHERE s.MaTG = @MaTG 
      AND m.NgayMuon BETWEEN '1999-01-01' AND '1999-06-30'
END
GO

-- =============================================
-- TRUY VẤN 3: Cập nhật thành phố nhà xuất bản KHKT từ T2 sang T1
-- =============================================
IF OBJECT_ID('SP_Query3_UpdateThanhPhoKHKT', 'P') IS NOT NULL
    DROP PROCEDURE SP_Query3_UpdateThanhPhoKHKT
GO

CREATE PROCEDURE SP_Query3_UpdateThanhPhoKHKT
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE SITE2_SERVER.ThuVien_Site2.dbo.NhaXB_Site2
    SET ThanhPho = N'T1'
    WHERE TenNXB = N'KHKT' AND ThanhPho = N'T2'
    
    SELECT @@ROWCOUNT AS SoDongCapNhat
END
GO

PRINT N''
PRINT N'========================================='
PRINT N'HOÀN THÀNH TẠO STORED PROCEDURES'
PRINT N'========================================='
GO
