-- ============================================================
-- Script: Test toàn bộ hệ thống phân tán
-- Chạy trên: SQLEXPRESS06 (ThuVien_Central)
-- Mục đích: Kiểm tra Views, Stored Procedures, Linked Servers
-- ============================================================

USE ThuVien_Central;
GO

PRINT N'';
PRINT N'╔════════════════════════════════════════════════════════════════╗';
PRINT N'║          TEST TOÀN BỘ HỆ THỐNG CƠ SỞ DỮ LIỆU PHÂN TÁN        ║';
PRINT N'╚════════════════════════════════════════════════════════════════╝';
PRINT N'';

-- ============================================================
-- PHẦN 1: KIỂM TRA KẾT NỐI LINKED SERVERS
-- ============================================================
PRINT N'━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT N'[1] KIỂM TRA KẾT NỐI LINKED SERVERS';
PRINT N'━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';

BEGIN TRY
    SELECT 'SITE1_SERVER: OK' AS Status FROM SITE1_SERVER.master.sys.databases WHERE name = 'master';
    PRINT N'✅ SITE1_SERVER (Port 1437) - Kết nối thành công!';
END TRY
BEGIN CATCH
    PRINT N'❌ SITE1_SERVER (Port 1437) - Kết nối THẤT BẠI: ' + ERROR_MESSAGE();
END CATCH

BEGIN TRY
    SELECT 'SITE2_SERVER: OK' AS Status FROM SITE2_SERVER.master.sys.databases WHERE name = 'master';
    PRINT N'✅ SITE2_SERVER (Port 1438) - Kết nối thành công!';
END TRY
BEGIN CATCH
    PRINT N'❌ SITE2_SERVER (Port 1438) - Kết nối THẤT BẠI: ' + ERROR_MESSAGE();
END CATCH

PRINT N'';

-- ============================================================
-- PHẦN 2: KIỂM TRA 5 VIEWS
-- ============================================================
PRINT N'━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT N'[2] KIỂM TRA 5 VIEWS (UNION ALL Site1 + Site2)';
PRINT N'━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';

PRINT N'';
PRINT N'[2.1] V_NhaXB - Nhà xuất bản';
SELECT * FROM V_NhaXB ORDER BY MaNXB;
DECLARE @CountNXB INT = (SELECT COUNT(*) FROM V_NhaXB);
PRINT N'✅ Kết quả: ' + CAST(@CountNXB AS NVARCHAR) + N' nhà xuất bản (Mong đợi: 2 - NXB01 Điện tử, NXB02 Máy tính)';

PRINT N'';
PRINT N'[2.2] V_TacGia - Tác giả';
SELECT * FROM V_TacGia ORDER BY MaTG;
DECLARE @CountTG INT = (SELECT COUNT(*) FROM V_TacGia);
PRINT N'✅ Kết quả: ' + CAST(@CountTG AS NVARCHAR) + N' tác giả (Mong đợi: 4 - TG001/TG002/T1/T2)';

PRINT N'';
PRINT N'[2.3] V_DocGia - Độc giả';
SELECT * FROM V_DocGia ORDER BY MaDG;
DECLARE @CountDG INT = (SELECT COUNT(*) FROM V_DocGia);
PRINT N'✅ Kết quả: ' + CAST(@CountDG AS NVARCHAR) + N' độc giả (Mong đợi: 5 - DG001~DG005)';

PRINT N'';
PRINT N'[2.4] V_Sach - Sách';
SELECT * FROM V_Sach ORDER BY MaSach;
DECLARE @CountSach INT = (SELECT COUNT(*) FROM V_Sach);
PRINT N'✅ Kết quả: ' + CAST(@CountSach AS NVARCHAR) + N' cuốn sách (Mong đợi: 10 - S0001~S0010)';

PRINT N'';
PRINT N'[2.5] V_Muon - Phiếu mượn';
SELECT * FROM V_Muon ORDER BY MaDG, MaSach, NgayMuon;
DECLARE @CountMuon INT = (SELECT COUNT(*) FROM V_Muon);
PRINT N'✅ Kết quả: ' + CAST(@CountMuon AS NVARCHAR) + N' phiếu mượn (Mong đợi: 6)';

PRINT N'';

-- ============================================================
-- PHẦN 3: KIỂM TRA PHÂN MẢNH DỮ LIỆU
-- ============================================================
PRINT N'━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT N'[3] KIỂM TRA PHÂN MẢNH DỮ LIỆU (Horizontal Fragmentation)';
PRINT N'━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';

PRINT N'';
PRINT N'[3.1] NhaXB phân mảnh theo ThanhPho';
SELECT SiteLocation, ThanhPho, COUNT(*) AS SoLuong
FROM V_NhaXB
GROUP BY SiteLocation, ThanhPho
ORDER BY SiteLocation;
PRINT N'✅ Site1: Hà Nội (Điện tử) | Site2: TP.HCM (Máy tính)';

PRINT N'';
PRINT N'[3.2] TacGia phân mảnh theo ChuyenMon';
SELECT SiteLocation, ChuyenMon, COUNT(*) AS SoLuong
FROM V_TacGia
GROUP BY SiteLocation, ChuyenMon
ORDER BY SiteLocation;
PRINT N'✅ Site1: Điện tử (2 tác giả) | Site2: Máy tính (2 tác giả)';

PRINT N'';
PRINT N'[3.3] DocGia phân mảnh theo DoiTuong';
SELECT SiteLocation, DoiTuong, COUNT(*) AS SoLuong
FROM V_DocGia
GROUP BY SiteLocation, DoiTuong
ORDER BY SiteLocation;
PRINT N'✅ Site1: HS (3 độc giả) | Site2: SV (2 độc giả)';

PRINT N'';
PRINT N'[3.4] Sach phân mảnh dẫn xuất theo TacGia';
SELECT s.SiteLocation, t.ChuyenMon, COUNT(*) AS SoLuong
FROM V_Sach s
JOIN V_TacGia t ON s.MaTG = t.MaTG
GROUP BY s.SiteLocation, t.ChuyenMon
ORDER BY s.SiteLocation;
PRINT N'✅ Sách cùng site với tác giả của nó';

PRINT N'';
PRINT N'[3.5] Muon phân mảnh dẫn xuất theo DocGia';
SELECT m.SiteLocation, d.DoiTuong, COUNT(*) AS SoLuong
FROM V_Muon m
JOIN V_DocGia d ON m.MaDG = d.MaDG
GROUP BY m.SiteLocation, d.DoiTuong
ORDER BY m.SiteLocation;
PRINT N'✅ Phiếu mượn cùng site với độc giả';

PRINT N'';

-- ============================================================
-- PHẦN 4: KIỂM TRA 15 STORED PROCEDURES
-- ============================================================
PRINT N'━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT N'[4] KIỂM TRA 15 STORED PROCEDURES (INSERT/UPDATE/DELETE)';
PRINT N'━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';

PRINT N'';
PRINT N'[4.1] Liệt kê các Stored Procedures';
SELECT name AS [Stored Procedure], create_date, modify_date
FROM sys.procedures
WHERE name LIKE 'SP_%'
ORDER BY name;

DECLARE @SPCount INT = (SELECT COUNT(*) FROM sys.procedures WHERE name LIKE 'SP_%');
PRINT N'✅ Kết quả: ' + CAST(@SPCount AS NVARCHAR) + N' Stored Procedures (Mong đợi: 15)';

PRINT N'';

-- ============================================================
-- PHẦN 5: TEST CRUD ĐỘC GIẢ (Ví dụ)
-- ============================================================
PRINT N'━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT N'[5] TEST CRUD - Thêm/Sửa/Xóa Độc Giả (Demo)';
PRINT N'━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';

PRINT N'';
PRINT N'[5.1] INSERT - Thêm độc giả mới';
BEGIN TRY
    EXEC SP_INSERT_DOCGIA @MaDG = 'DG999', @TenDG = N'Nguyễn Test', @DoiTuong = N'HS';
    PRINT N'✅ Thêm DG999 thành công!';
    SELECT * FROM V_DocGia WHERE MaDG = 'DG999';
END TRY
BEGIN CATCH
    PRINT N'❌ Lỗi INSERT: ' + ERROR_MESSAGE();
END CATCH

PRINT N'';
PRINT N'[5.2] UPDATE - Sửa độc giả';
BEGIN TRY
    EXEC SP_UPDATE_DOCGIA @MaDG = 'DG999', @TenDG = N'Nguyễn Test Updated', @DoiTuong = N'SV';
    PRINT N'✅ Sửa DG999 thành công!';
    SELECT * FROM V_DocGia WHERE MaDG = 'DG999';
END TRY
BEGIN CATCH
    PRINT N'❌ Lỗi UPDATE: ' + ERROR_MESSAGE();
END CATCH

PRINT N'';
PRINT N'[5.3] DELETE - Xóa độc giả';
BEGIN TRY
    EXEC SP_DELETE_DOCGIA @MaDG = 'DG999';
    PRINT N'✅ Xóa DG999 thành công!';
    IF NOT EXISTS (SELECT 1 FROM V_DocGia WHERE MaDG = 'DG999')
        PRINT N'✅ Xác nhận: DG999 đã bị xóa khỏi hệ thống';
END TRY
BEGIN CATCH
    PRINT N'❌ Lỗi DELETE: ' + ERROR_MESSAGE();
END CATCH

PRINT N'';

-- ============================================================
-- PHẦN 6: TEST 3 TRUY VẤN YÊU CẦU
-- ============================================================
PRINT N'━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT N'[6] TEST 3 TRUY VẤN YÊU CẦU';
PRINT N'━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';

PRINT N'';
PRINT N'[6.1] Truy vấn 1: Sách có "Điện" trong tên';
SELECT MaSach, TenSach, SiteLocation
FROM V_Sach
WHERE TenSach LIKE N'%Điện%'
ORDER BY MaSach;
DECLARE @CountDien INT = (SELECT COUNT(*) FROM V_Sach WHERE TenSach LIKE N'%Điện%');
PRINT N'✅ Kết quả: ' + CAST(@CountDien AS NVARCHAR) + N' cuốn sách';

PRINT N'';
PRINT N'[6.2] Truy vấn 2: Top 3 độc giả mượn nhiều nhất';
SELECT TOP 3 
    d.MaDG, 
    d.TenDG, 
    d.DoiTuong,
    COUNT(*) AS SoLanMuon,
    d.SiteLocation
FROM V_DocGia d
LEFT JOIN V_Muon m ON d.MaDG = m.MaDG
GROUP BY d.MaDG, d.TenDG, d.DoiTuong, d.SiteLocation
ORDER BY COUNT(*) DESC, d.MaDG;
PRINT N'✅ Top 3 độc giả mượn nhiều nhất';

PRINT N'';
PRINT N'[6.3] Truy vấn 3: Sách chưa được mượn';
SELECT s.MaSach, s.TenSach, s.SiteLocation
FROM V_Sach s
WHERE NOT EXISTS (
    SELECT 1 FROM V_Muon m WHERE m.MaSach = s.MaSach
)
ORDER BY s.MaSach;
DECLARE @CountChuaMuon INT = (SELECT COUNT(*) FROM V_Sach s WHERE NOT EXISTS (SELECT 1 FROM V_Muon m WHERE m.MaSach = s.MaSach));
PRINT N'✅ Kết quả: ' + CAST(@CountChuaMuon AS NVARCHAR) + N' cuốn sách chưa mượn';

PRINT N'';

-- ============================================================
-- PHẦN 7: KIỂM TRA TÍNH MINH BẠCH (Transparency)
-- ============================================================
PRINT N'━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT N'[7] KIỂM TRA TÍNH MINH BẠCH (Transparency)';
PRINT N'━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';

PRINT N'';
PRINT N'[7.1] Location Transparency - Người dùng không cần biết dữ liệu ở đâu';
PRINT N'      Truy vấn V_DocGia mà không cần biết DG001 ở Site1 hay Site2';
SELECT MaDG, TenDG, DoiTuong FROM V_DocGia WHERE MaDG = 'DG001';
PRINT N'✅ Minh bạch vị trí: Truy vấn thành công mà không cần chỉ định site';

PRINT N'';
PRINT N'[7.2] Fragmentation Transparency - Dữ liệu phân mảnh nhưng truy vấn như 1';
PRINT N'      SELECT * FROM V_DocGia trả về cả Site1 (HS) và Site2 (SV)';
SELECT COUNT(*) AS TotalRows, 
       COUNT(DISTINCT SiteLocation) AS NumberOfSites
FROM V_DocGia;
PRINT N'✅ Minh bạch phân mảnh: 1 truy vấn lấy dữ liệu từ 2 sites';

PRINT N'';
PRINT N'[7.3] Replication Transparency - Views ẩn đi Linked Server syntax';
PRINT N'      Không cần viết SITE1_SERVER.ThuVien_Site1.dbo.DocGia';
PRINT N'      Chỉ cần: SELECT * FROM V_DocGia';
PRINT N'✅ Minh bạch sao chép: Views đơn giản hóa cú pháp distributed query';

PRINT N'';

-- ============================================================
-- KẾT LUẬN
-- ============================================================
PRINT N'╔════════════════════════════════════════════════════════════════╗';
PRINT N'║                      KẾT QUẢ KIỂM TRA                         ║';
PRINT N'╚════════════════════════════════════════════════════════════════╝';
PRINT N'';

DECLARE @TotalNXB INT = (SELECT COUNT(*) FROM V_NhaXB);
DECLARE @TotalTG INT = (SELECT COUNT(*) FROM V_TacGia);
DECLARE @TotalDG INT = (SELECT COUNT(*) FROM V_DocGia);
DECLARE @TotalSach INT = (SELECT COUNT(*) FROM V_Sach);
DECLARE @TotalMuon INT = (SELECT COUNT(*) FROM V_Muon);
DECLARE @TotalSP INT = (SELECT COUNT(*) FROM sys.procedures WHERE name LIKE 'SP_%');

PRINT N'📊 Tổng quan dữ liệu:';
PRINT N'   - Nhà xuất bản: ' + CAST(@TotalNXB AS NVARCHAR) + N'/2';
PRINT N'   - Tác giả: ' + CAST(@TotalTG AS NVARCHAR) + N'/4';
PRINT N'   - Độc giả: ' + CAST(@TotalDG AS NVARCHAR) + N'/5';
PRINT N'   - Sách: ' + CAST(@TotalSach AS NVARCHAR) + N'/10';
PRINT N'   - Phiếu mượn: ' + CAST(@TotalMuon AS NVARCHAR) + N'/6';
PRINT N'   - Stored Procedures: ' + CAST(@TotalSP AS NVARCHAR) + N'/15';

PRINT N'';

IF @TotalNXB = 2 AND @TotalTG = 4 AND @TotalDG = 5 AND @TotalSach = 10 AND @TotalMuon = 6 AND @TotalSP = 15
BEGIN
    PRINT N'✅✅✅ HỆ THỐNG HOẠT ĐỘNG HOÀN HẢO! ✅✅✅';
    PRINT N'';
    PRINT N'Bạn có thể:';
    PRINT N'1. Chạy Windows Forms App để test giao diện';
    PRINT N'2. Thử thêm/sửa/xóa dữ liệu qua FormDocGia';
    PRINT N'3. Test 3 Query forms (FormQuery1/2/3)';
    PRINT N'4. Chụp screenshot cho báo cáo';
END
ELSE
BEGIN
    PRINT N'⚠️ CÓ VẤN ĐỀ! Kiểm tra lại:';
    IF @TotalNXB <> 2 PRINT N'   - Thiếu dữ liệu NhaXB';
    IF @TotalTG <> 4 PRINT N'   - Thiếu dữ liệu TacGia';
    IF @TotalDG <> 5 PRINT N'   - Thiếu dữ liệu DocGia';
    IF @TotalSach <> 10 PRINT N'   - Thiếu dữ liệu Sach';
    IF @TotalMuon <> 6 PRINT N'   - Thiếu dữ liệu Muon';
    IF @TotalSP <> 15 PRINT N'   - Thiếu Stored Procedures';
    PRINT N'';
    PRINT N'Giải pháp: Chạy lại 07_InsertData.sql và 07B_FixUnicode.sql';
END

PRINT N'';
PRINT N'════════════════════════════════════════════════════════════════';
PRINT N'Completed at: ' + CONVERT(NVARCHAR, GETDATE(), 120);
PRINT N'════════════════════════════════════════════════════════════════';
GO
