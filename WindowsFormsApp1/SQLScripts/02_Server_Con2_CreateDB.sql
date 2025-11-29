-- =============================================
-- Script: Tạo Database và Tables cho Server Con 2
-- CHẠY TRÊN: DESKTOP-4EOK9DU\SQLEXPRESS08 (Port 1438)
-- Database: ThuVien_Site2
-- Chứa: NhaXB (ThanhPho = 'T2'), Sách, TácGiả (ChuyenMon = 'Máy tính')
-- =============================================

USE master
GO

-- Xóa database nếu đã tồn tại
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'ThuVien_Site2')
BEGIN
    ALTER DATABASE ThuVien_Site2 SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE ThuVien_Site2
END
GO

-- Tạo database mới
CREATE DATABASE ThuVien_Site2
GO

USE ThuVien_Site2
GO

-- =============================================
-- Tạo bảng NhaXB_Site2 (Nhà xuất bản ở Thành phố T2)
-- =============================================
CREATE TABLE NhaXB_Site2 (
    MaNXB char(5) PRIMARY KEY,
    TenNXB nvarchar(50) NOT NULL,
    ThanhPho nvarchar(30) NOT NULL
)
GO

-- =============================================
-- Tạo bảng TacGia_Site2 (Tác giả chuyên môn Máy tính)
-- =============================================
CREATE TABLE TacGia_Site2 (
    MaTG char(5) PRIMARY KEY,
    TenTG nvarchar(50) NOT NULL,
    ChuyenMon nvarchar(30) NOT NULL
)
GO

-- =============================================
-- Tạo bảng Sach_Site2
-- =============================================
CREATE TABLE Sach_Site2 (
    MaSach char(5) PRIMARY KEY,
    TenSach nvarchar(100) NOT NULL,
    NamXB int NOT NULL,
    MaNXB char(5) NOT NULL,
    MaTG char(5) NOT NULL,
    CONSTRAINT FK_Sach2_NhaXB FOREIGN KEY (MaNXB) REFERENCES NhaXB_Site2(MaNXB),
    CONSTRAINT FK_Sach2_TacGia FOREIGN KEY (MaTG) REFERENCES TacGia_Site2(MaTG)
)
GO

-- =============================================
-- Tạo bảng DocGia_Site2 (Sinh viên - SV)
-- =============================================
CREATE TABLE DocGia_Site2 (
    MaDG char(5) PRIMARY KEY,
    TenDG nvarchar(50) NOT NULL,
    DoiTuong nvarchar(10) NOT NULL
)
GO

-- =============================================
-- Tạo bảng Muon_Site2
-- =============================================
CREATE TABLE Muon_Site2 (
    MaDG char(5) NOT NULL,
    MaSach char(5) NOT NULL,
    NgayMuon datetime NOT NULL,
    NgayTra datetime NULL,
    PRIMARY KEY (MaDG, MaSach, NgayMuon),
    CONSTRAINT FK_Muon2_DocGia FOREIGN KEY (MaDG) REFERENCES DocGia_Site2(MaDG),
    CONSTRAINT FK_Muon2_Sach FOREIGN KEY (MaSach) REFERENCES Sach_Site2(MaSach)
)
GO

PRINT N'✓ Tạo Database ThuVien_Site2 trên Server Con 2 (Port 1438) thành công!'
PRINT N'✓ Đã tạo các bảng: NhaXB_Site2, TacGia_Site2, Sach_Site2, DocGia_Site2, Muon_Site2'
GO
