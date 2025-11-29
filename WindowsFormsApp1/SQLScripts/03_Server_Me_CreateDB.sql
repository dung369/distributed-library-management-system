-- =============================================
-- Script: Tạo Database cho Server Mẹ
-- CHẠY TRÊN: DESKTOP-4EOK9DU\SQLEXPRESS06 (Port 1436)
-- Database: ThuVien_Central
-- Đây là nơi chứa Views toàn cục và Triggers
-- =============================================

USE master
GO

-- Xóa database nếu đã tồn tại
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'ThuVien_Central')
BEGIN
    ALTER DATABASE ThuVien_Central SET SINGLE_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE ThuVien_Central
END
GO

-- Tạo database mới
CREATE DATABASE ThuVien_Central
GO

USE ThuVien_Central
GO

PRINT N'✓ Tạo Database ThuVien_Central trên Server Mẹ (Port 1436) thành công!'
PRINT N'✓ Database này sẽ chứa Views toàn cục, Triggers và Stored Procedures'
GO
