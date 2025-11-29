@echo off
REM =============================================
REM Script tự động cấu hình Firewall cho SQL Server
REM Chạy với quyền Administrator
REM =============================================

echo ========================================
echo CAU HINH FIREWALL CHO SQL SERVER
echo ========================================
echo.

REM Kiểm tra quyền Administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Vui long chay script voi quyen Administrator!
    echo.
    echo Cach chay:
    echo 1. Right-click file nay
    echo 2. Chon "Run as administrator"
    pause
    exit /b 1
)

echo [INFO] Dang cau hinh Firewall...
echo.

REM Xóa rules cũ nếu tồn tại
netsh advfirewall firewall delete rule name="SQL Server 1436" >nul 2>&1
netsh advfirewall firewall delete rule name="SQL Server 1437" >nul 2>&1
netsh advfirewall firewall delete rule name="SQL Server 1438" >nul 2>&1
netsh advfirewall firewall delete rule name="SQL Browser" >nul 2>&1

REM Tạo rules mới
echo [1/4] Mo port 1436 (Server me)...
netsh advfirewall firewall add rule name="SQL Server 1436" dir=in action=allow protocol=TCP localport=1436
if %errorLevel% equ 0 (
    echo       [OK] Port 1436 da duoc mo
) else (
    echo       [ERROR] Khong the mo port 1436
)

echo [2/4] Mo port 1437 (Server con 1)...
netsh advfirewall firewall add rule name="SQL Server 1437" dir=in action=allow protocol=TCP localport=1437
if %errorLevel% equ 0 (
    echo       [OK] Port 1437 da duoc mo
) else (
    echo       [ERROR] Khong the mo port 1437
)

echo [3/4] Mo port 1438 (Server con 2)...
netsh advfirewall firewall add rule name="SQL Server 1438" dir=in action=allow protocol=TCP localport=1438
if %errorLevel% equ 0 (
    echo       [OK] Port 1438 da duoc mo
) else (
    echo       [ERROR] Khong the mo port 1438
)

echo [4/4] Mo port cho SQL Browser (UDP 1434)...
netsh advfirewall firewall add rule name="SQL Browser" dir=in action=allow protocol=UDP localport=1434
if %errorLevel% equ 0 (
    echo       [OK] SQL Browser da duoc mo
) else (
    echo       [ERROR] Khong the mo SQL Browser
)

echo.
echo ========================================
echo HOAN THANH CAU HINH FIREWALL
echo ========================================
echo.
echo Cac port da duoc mo:
echo - TCP 1436: Server me (SQLEXPRESS06)
echo - TCP 1437: Server con 1 (SQLEXPRESS07)
echo - TCP 1438: Server con 2 (SQLEXPRESS08)
echo - UDP 1434: SQL Browser
echo.
echo Ban co the kiem tra trong Windows Defender Firewall
echo - Control Panel ^> Windows Defender Firewall ^> Advanced settings
echo.
pause
