-- =============================================
-- Script: Tạo Database và Tables cho Server Con 1
-- CHẠY TRÊN: DESKTOP-4EOK9DU\SQLEXPRESS07 (Port 1437)
-- Database: ThuVien_Site1
-- Chứa: NhaXB (ThanhPho = 'T1'), Sách, TácGiả (ChuyenMon = 'Điện tử')
-- =============================================

USE master
GO

-- Xóa database nếu đã tồn tại
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'ThuVien_Site1')
BEGIN
    ALTER DATABASE ThuVien_Site1 SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE ThuVien_Site1
END
GO

-- Tạo database mới
CREATE DATABASE ThuVien_Site1
GO

USE ThuVien_Site1
GO

-- =============================================
-- Tạo bảng NhaXB_Site1 (Nhà xuất bản ở Thành phố T1)
-- =============================================
CREATE TABLE NhaXB_Site1 (
    MaNXB char(5) PRIMARY KEY,
    TenNXB nvarchar(50) NOT NULL,
    ThanhPho nvarchar(30) NOT NULL
)
GO

-- =============================================
-- Tạo bảng TacGia_Site1 (Tác giả chuyên môn Điện tử)
-- =============================================
CREATE TABLE TacGia_Site1 (
    MaTG char(5) PRIMARY KEY,
    TenTG nvarchar(50) NOT NULL,
    ChuyenMon nvarchar(30) NOT NULL
)
GO

-- =============================================
-- Tạo bảng Sach_Site1
-- =============================================
CREATE TABLE Sach_Site1 (
    MaSach char(5) PRIMARY KEY,
    TenSach nvarchar(100) NOT NULL,
    NamXB int NOT NULL,
    MaNXB char(5) NOT NULL,
    MaTG char(5) NOT NULL,
    CONSTRAINT FK_Sach1_NhaXB FOREIGN KEY (MaNXB) REFERENCES NhaXB_Site1(MaNXB),
    CONSTRAINT FK_Sach1_TacGia FOREIGN KEY (MaTG) REFERENCES TacGia_Site1(MaTG)
)
GO

-- =============================================
-- Tạo bảng DocGia_Site1 (Học sinh - HS)
-- =============================================
CREATE TABLE DocGia_Site1 (
    MaDG char(5) PRIMARY KEY,
    TenDG nvarchar(50) NOT NULL,
    DoiTuong nvarchar(10) NOT NULL
)
GO

-- =============================================
-- Tạo bảng Muon_Site1
-- =============================================
CREATE TABLE Muon_Site1 (
    MaDG char(5) NOT NULL,
    MaSach char(5) NOT NULL,
    NgayMuon datetime NOT NULL,
    NgayTra datetime NULL,
    PRIMARY KEY (MaDG, MaSach, NgayMuon),
    CONSTRAINT FK_Muon1_DocGia FOREIGN KEY (MaDG) REFERENCES DocGia_Site1(MaDG),
    CONSTRAINT FK_Muon1_Sach FOREIGN KEY (MaSach) REFERENCES Sach_Site1(MaSach)
)
GO

PRINT N'✓ Tạo Database ThuVien_Site1 trên Server Con 1 (Port 1437) thành công!'
PRINT N'✓ Đã tạo các bảng: NhaXB_Site1, TacGia_Site1, Sach_Site1, DocGia_Site1, Muon_Site1'
GO
