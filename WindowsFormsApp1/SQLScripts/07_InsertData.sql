-- =============================================
-- Script: Insert dữ liệu mẫu vào hệ thống phân tán
-- CHẠY TRÊN: DESKTOP-4EOK9DU\SQLEXPRESS06 (Port 1436)
-- LƯU Ý: File này đã được mã hóa UTF-8 với BOM
-- =============================================

USE ThuVien_Central
GO

SET DATEFORMAT DMY
GO

PRINT N'========================================='
PRINT N'BẮT ĐẦU INSERT DỮ LIỆU MẪU'
PRINT N'========================================='
GO

-- =============================================
-- Insert Nhà xuất bản
-- =============================================
PRINT N'Đang insert Nhà xuất bản...'
GO

EXEC SP_INSERT_NHAXB 'NXB01', N'Giáo dục', N'T1'
EXEC SP_INSERT_NHAXB 'NXB02', N'Trẻ', N'T1'
EXEC SP_INSERT_NHAXB 'NXB03', N'KHKT', N'T2'
EXEC SP_INSERT_NHAXB 'NXB04', N'Đại học Quốc Gia', N'T2'
GO

PRINT N'✓ Đã insert 4 nhà xuất bản'
GO

-- =============================================
-- Insert Tác giả
-- =============================================
PRINT N'Đang insert Tác giả...'
GO

EXEC SP_INSERT_TACGIA 'TG001', N'Nguyễn Văn A', N'Điện tử'
EXEC SP_INSERT_TACGIA 'TG002', N'Trần Thị B', N'Máy tính'
EXEC SP_INSERT_TACGIA 'TG003', N'Lê Văn C', N'Điện tử'
EXEC SP_INSERT_TACGIA 'TG004', N'Phạm Thị D', N'Máy tính'
GO

PRINT N'✓ Đã insert 4 tác giả'
GO

-- =============================================
-- Insert Độc giả
-- =============================================
PRINT N'Đang insert Độc giả...'
GO

EXEC SP_INSERT_DOCGIA 'DG001', N'Hoàng Văn Nam', N'HS'
EXEC SP_INSERT_DOCGIA 'DG002', N'Võ Thị Lan', N'HS'
EXEC SP_INSERT_DOCGIA 'DG003', N'Đặng Văn Hùng', N'SV'
EXEC SP_INSERT_DOCGIA 'DG004', N'Bùi Thị Hoa', N'SV'
GO

PRINT N'✓ Đã insert 4 độc giả'
GO

-- =============================================
-- Insert Sách
-- =============================================
PRINT N'Đang insert Sách...'
GO

-- S0001: TG001(Điện tử-Site1) + NXB01(T1-Site1) ✓
EXEC SP_INSERT_SACH 'S0001', N'Cơ sở Điện tử', 1998, 'NXB01', 'TG001'

-- S0002: TG002(Máy tính-Site2) + NXB03(T2-Site2) ✓ (đổi từ NXB02→NXB03)
EXEC SP_INSERT_SACH 'S0002', N'Lập trình C++', 2000, 'NXB03', 'TG002'

-- S0003: TG003(Điện tử-Site1) + NXB02(T1-Site1) ✓ (đổi từ NXB03→NXB02)
EXEC SP_INSERT_SACH 'S0003', N'Mạch số', 1998, 'NXB02', 'TG003'

-- S0004: TG004(Máy tính-Site2) + NXB04(T2-Site2) ✓
EXEC SP_INSERT_SACH 'S0004', N'Cơ sở dữ liệu', 2005, 'NXB04', 'TG004'

-- S0005: TG001(Điện tử-Site1) + NXB01(T1-Site1) ✓
EXEC SP_INSERT_SACH 'S0005', N'Vi xử lý', 2010, 'NXB01', 'TG001'
GO

PRINT N'✓ Đã insert 5 sách'
GO

-- =============================================
-- Insert Phiếu mượn
-- =============================================
PRINT N'Đang insert Phiếu mượn...'
GO

-- DG001(HS-Site1) mượn S0001(Site1) ✓
EXEC SP_INSERT_MUON 'DG001', 'S0001', '15/01/1999', '15/02/1999'

-- DG002(HS-Site1) mượn S0003(Site1) ✓ (đổi từ S0002→S0003)
EXEC SP_INSERT_MUON 'DG002', 'S0003', '20/01/1999', '20/02/1999'

-- DG003(SV-Site2) mượn S0002(Site2) ✓ (đổi từ S0003→S0002)
EXEC SP_INSERT_MUON 'DG003', 'S0002', '10/02/1999', '10/03/1999'

-- DG004(SV-Site2) mượn S0004(Site2) ✓
EXEC SP_INSERT_MUON 'DG004', 'S0004', '05/03/1999', '05/04/1999'

-- DG001(HS-Site1) mượn S0005(Site1) ✓
EXEC SP_INSERT_MUON 'DG001', 'S0005', '15/06/1999', '15/07/1999'
GO

PRINT N'✓ Đã insert 5 phiếu mượn'
GO

-- =============================================
-- Kiểm tra dữ liệu vừa insert
-- =============================================
PRINT N''
PRINT N'========================================='
PRINT N'KIỂM TRA DỮ LIỆU VỪA INSERT'
PRINT N'========================================='
GO

PRINT N''
PRINT N'--- Nhà xuất bản ---'
SELECT * FROM V_NhaXB ORDER BY SiteLocation, MaNXB
GO

PRINT N''
PRINT N'--- Tác giả ---'
SELECT * FROM V_TacGia ORDER BY SiteLocation, MaTG
GO

PRINT N''
PRINT N'--- Độc giả ---'
SELECT * FROM V_DocGia ORDER BY SiteLocation, MaDG
GO

PRINT N''
PRINT N'--- Sách ---'
SELECT * FROM V_Sach ORDER BY SiteLocation, MaSach
GO

PRINT N''
PRINT N'--- Phiếu mượn ---'
SELECT * FROM V_Muon ORDER BY SiteLocation, MaDG, MaSach
GO

PRINT N''
PRINT N'========================================='
PRINT N'HOÀN THÀNH INSERT DỮ LIỆU MẪU'
PRINT N'========================================='
GO
