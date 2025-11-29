-- ============================================================
-- Script: Bật Remote Access cho tất cả SQL Server Instances
-- Mục đích: Cho phép kết nối từ xa vào 3 servers
-- ============================================================

-- ============================================================
-- BƯỚC 1: Chạy trên SQLEXPRESS06 (Port 1436)
-- ============================================================
USE master;
GO

-- Enable remote access
EXEC sp_configure 'remote access', 1;
RECONFIGURE;
GO

-- Enable Mixed Mode Authentication
EXEC xp_instance_regread 
    N'HKEY_LOCAL_MACHINE', 
    N'Software\Microsoft\MSSQLServer\MSSQLServer',
    N'LoginMode';
-- Nếu kết quả = 1 → chỉ Windows Auth
-- Nếu kết quả = 2 → Mixed Mode (OK)
GO

-- Enable login 'sa'
ALTER LOGIN sa ENABLE;
ALTER LOGIN sa WITH PASSWORD = '123456';
GO

-- Cấp quyền cho sa trên ThuVien_Central
USE ThuVien_Central;
ALTER AUTHORIZATION ON DATABASE::ThuVien_Central TO sa;
GO

PRINT N'✅ SQLEXPRESS06 - Remote access đã bật';
GO


-- ============================================================
-- BƯỚC 2: Chạy trên SQLEXPRESS07 (Port 1437)
-- ============================================================
USE master;
GO

-- Enable remote access
EXEC sp_configure 'remote access', 1;
RECONFIGURE;
GO

-- Enable login 'sa'
ALTER LOGIN sa ENABLE;
ALTER LOGIN sa WITH PASSWORD = '123456';
GO

-- Cấp quyền cho sa trên ThuVien_Site1
USE ThuVien_Site1;
ALTER AUTHORIZATION ON DATABASE::ThuVien_Site1 TO sa;
GO

PRINT N'✅ SQLEXPRESS07 - Remote access đã bật';
GO


-- ============================================================
-- BƯỚC 3: Chạy trên SQLEXPRESS08 (Port 1438)
-- ============================================================
USE master;
GO

-- Enable remote access
EXEC sp_configure 'remote access', 1;
RECONFIGURE;
GO

-- Enable login 'sa'
ALTER LOGIN sa ENABLE;
ALTER LOGIN sa WITH PASSWORD = '123456';
GO

-- Cấp quyền cho sa trên ThuVien_Site2
USE ThuVien_Site2;
ALTER AUTHORIZATION ON DATABASE::ThuVien_Site2 TO sa;
GO

PRINT N'✅ SQLEXPRESS08 - Remote access đã bật';
GO


-- ============================================================
-- KIỂM TRA KẾT QUẢ
-- ============================================================
-- Chạy trên mỗi server để kiểm tra:

-- Kiểm tra Remote Access
EXEC sp_configure 'remote access';
GO

-- Kiểm tra Mixed Mode (phải = 2)
EXEC xp_instance_regread 
    N'HKEY_LOCAL_MACHINE', 
    N'Software\Microsoft\MSSQLServer\MSSQLServer',
    N'LoginMode';
GO

-- Kiểm tra user 'sa'
SELECT name, is_disabled FROM sys.sql_logins WHERE name = 'sa';
-- is_disabled phải = 0
GO
