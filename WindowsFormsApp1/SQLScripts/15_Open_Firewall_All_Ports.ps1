# ============================================================
# Script: Mở Firewall cho tất cả SQL Server Ports
# Chạy: PowerShell as Administrator
# ============================================================

Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "   MỞ FIREWALL CHO SQL SERVER (3 INSTANCES)        " -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# ============================================================
# Bước 1: Mở Port 1436 (SQLEXPRESS06 - Central)
# ============================================================
Write-Host "[1/4] Mở port 1436 cho SQLEXPRESS06..." -ForegroundColor Yellow

New-NetFirewallRule `
    -DisplayName "SQL Server SQLEXPRESS06 Port 1436" `
    -Direction Inbound `
    -Protocol TCP `
    -LocalPort 1436 `
    -Action Allow `
    -ErrorAction SilentlyContinue

Write-Host "✅ Đã mở port 1436" -ForegroundColor Green
Write-Host ""

# ============================================================
# Bước 2: Mở Port 1437 (SQLEXPRESS07 - Site1)
# ============================================================
Write-Host "[2/4] Mở port 1437 cho SQLEXPRESS07..." -ForegroundColor Yellow

New-NetFirewallRule `
    -DisplayName "SQL Server SQLEXPRESS07 Port 1437" `
    -Direction Inbound `
    -Protocol TCP `
    -LocalPort 1437 `
    -Action Allow `
    -ErrorAction SilentlyContinue

Write-Host "✅ Đã mở port 1437" -ForegroundColor Green
Write-Host ""

# ============================================================
# Bước 3: Mở Port 1438 (SQLEXPRESS08 - Site2)
# ============================================================
Write-Host "[3/4] Mở port 1438 cho SQLEXPRESS08..." -ForegroundColor Yellow

New-NetFirewallRule `
    -DisplayName "SQL Server SQLEXPRESS08 Port 1438" `
    -Direction Inbound `
    -Protocol TCP `
    -LocalPort 1438 `
    -Action Allow `
    -ErrorAction SilentlyContinue

Write-Host "✅ Đã mở port 1438" -ForegroundColor Green
Write-Host ""

# ============================================================
# Bước 4: Mở Port 1434 (SQL Server Browser)
# ============================================================
Write-Host "[4/4] Mở port 1434 cho SQL Server Browser..." -ForegroundColor Yellow

New-NetFirewallRule `
    -DisplayName "SQL Server Browser UDP 1434" `
    -Direction Inbound `
    -Protocol UDP `
    -LocalPort 1434 `
    -Action Allow `
    -ErrorAction SilentlyContinue

Write-Host "✅ Đã mở port 1434 (SQL Browser)" -ForegroundColor Green
Write-Host ""

# ============================================================
# Bước 5: Bật và chạy SQL Server Browser Service
# ============================================================
Write-Host "[5/5] Bật SQL Server Browser Service..." -ForegroundColor Yellow

Set-Service -Name 'SQLBrowser' -StartupType Automatic -ErrorAction SilentlyContinue
Start-Service -Name 'SQLBrowser' -ErrorAction SilentlyContinue

$browserStatus = Get-Service -Name 'SQLBrowser' -ErrorAction SilentlyContinue
if ($browserStatus.Status -eq 'Running') {
    Write-Host "✅ SQL Server Browser đang chạy" -ForegroundColor Green
} else {
    Write-Host "⚠️ SQL Server Browser chưa chạy" -ForegroundColor Red
}
Write-Host ""

# ============================================================
# Kiểm tra kết quả
# ============================================================
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "            KIỂM TRA KẾT QUẢ                      " -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

Write-Host "Danh sách Firewall Rules đã tạo:" -ForegroundColor White
Get-NetFirewallRule | Where-Object {$_.DisplayName -like '*SQL*'} | 
    Select-Object DisplayName, Enabled, Direction, Action | 
    Format-Table -AutoSize

Write-Host ""
Write-Host "Danh sách Port đang LISTENING:" -ForegroundColor White
netstat -an | findstr "1436 1437 1438 1434"

Write-Host ""
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "                HOÀN TẤT!                         " -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Bạn có thể kết nối từ máy khác bằng:" -ForegroundColor Yellow
Write-Host "  Server 06: YOUR_IP,1436 | Login: sa | Password: 123456" -ForegroundColor White
Write-Host "  Server 07: YOUR_IP,1437 | Login: sa | Password: 123456" -ForegroundColor White
Write-Host "  Server 08: YOUR_IP,1438 | Login: sa | Password: 123456" -ForegroundColor White
Write-Host ""
Write-Host "Lấy IP máy bạn: ipconfig" -ForegroundColor Cyan
Write-Host ""
