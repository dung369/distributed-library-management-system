-- =============================================
-- Script: Cấu hình Linked Servers trên Server Mẹ
-- CHẠY TRÊN: DESKTOP-4EOK9DU\SQLEXPRESS06 (Port 1436)
-- =============================================

USE master
GO

-- =============================================
-- Xóa Linked Servers cũ nếu tồn tại
-- =============================================
IF EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = 'SITE1_SERVER')
    EXEC sp_dropserver 'SITE1_SERVER', 'droplogins'
GO

IF EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = 'SITE2_SERVER')
    EXEC sp_dropserver 'SITE2_SERVER', 'droplogins'
GO

-- =============================================
-- Tạo Linked Server -> SQLEXPRESS07 (Port 1437) - Site 1
-- =============================================
EXEC sp_addlinkedserver   
    @server='SITE1_SERVER',
    @srvproduct='',
    @provider='SQLNCLI',
    @datasrc='DESKTOP-4EOK9DU\SQLEXPRESS07,1437'
GO

EXEC sp_addlinkedsrvlogin 
    @rmtsrvname='SITE1_SERVER',
    @useself='false',
    @rmtuser='sa',
    @rmtpassword='123456'  -- Thay bằng mật khẩu sa của bạn
GO

-- Bật RPC cho SITE1_SERVER
EXEC sp_serveroption 'SITE1_SERVER', 'rpc', 'true'
EXEC sp_serveroption 'SITE1_SERVER', 'rpc out', 'true'
EXEC sp_serveroption 'SITE1_SERVER', 'data access', 'true'
GO

PRINT N'✓ Đã tạo Linked Server: SITE1_SERVER -> SQLEXPRESS07 (Port 1437)'
GO

-- =============================================
-- Tạo Linked Server -> SQLEXPRESS08 (Port 1438) - Site 2
-- =============================================
EXEC sp_addlinkedserver   
    @server='SITE2_SERVER',
    @srvproduct='',
    @provider='SQLNCLI',
    @datasrc='DESKTOP-4EOK9DU\SQLEXPRESS08,1438'
GO

EXEC sp_addlinkedsrvlogin 
    @rmtsrvname='SITE2_SERVER',
    @useself='false',
    @rmtuser='sa',
    @rmtpassword='123456'  -- Thay bằng mật khẩu sa của bạn
GO

-- Bật RPC cho SITE2_SERVER
EXEC sp_serveroption 'SITE2_SERVER', 'rpc', 'true'
EXEC sp_serveroption 'SITE2_SERVER', 'rpc out', 'true'
EXEC sp_serveroption 'SITE2_SERVER', 'data access', 'true'
GO

PRINT N'✓ Đã tạo Linked Server: SITE2_SERVER -> SQLEXPRESS08 (Port 1438)'
GO

-- =============================================
-- Kiểm tra kết nối Linked Servers
-- =============================================
PRINT N''
PRINT N'========================================='
PRINT N'KIỂM TRA KẾT NỐI LINKED SERVERS'
PRINT N'========================================='
GO

BEGIN TRY
    SELECT 'SITE1_SERVER: OK' AS Status FROM SITE1_SERVER.master.sys.databases WHERE name = 'master'
    PRINT N'✓ SITE1_SERVER (Port 1437) - Kết nối thành công!'
END TRY
BEGIN CATCH
    PRINT N'✗ SITE1_SERVER (Port 1437) - Kết nối THẤT BẠI: ' + ERROR_MESSAGE()
END CATCH
GO

BEGIN TRY
    SELECT 'SITE2_SERVER: OK' AS Status FROM SITE2_SERVER.master.sys.databases WHERE name = 'master'
    PRINT N'✓ SITE2_SERVER (Port 1438) - Kết nối thành công!'
END TRY
BEGIN CATCH
    PRINT N'✗ SITE2_SERVER (Port 1438) - Kết nối THẤT BẠI: ' + ERROR_MESSAGE()
END CATCH
GO

PRINT N''
PRINT N'========================================='
PRINT N'HOÀN THÀNH CẤU HÌNH LINKED SERVERS'
PRINT N'========================================='
GO
