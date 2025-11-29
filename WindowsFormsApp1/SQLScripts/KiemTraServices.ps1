# =============================================
# Script PowerShell: Kiểm tra và Start SQL Server Services
# Chạy với quyền Administrator
# =============================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "KIEM TRA SQL SERVER SERVICES" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Kiểm tra quyền Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "[ERROR] Vui long chay PowerShell voi quyen Administrator!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Cach chay:" -ForegroundColor Yellow
    Write-Host "1. Right-click PowerShell" -ForegroundColor Yellow
    Write-Host "2. Chon 'Run as administrator'" -ForegroundColor Yellow
    Write-Host "3. Chay lai script nay" -ForegroundColor Yellow
    pause
    exit
}

# Danh sách services cần kiểm tra
$services = @(
    "MSSQL`$SQLEXPRESS06",
    "MSSQL`$SQLEXPRESS07",
    "MSSQL`$SQLEXPRESS08",
    "SQLBrowser"
)

Write-Host "1. TRANG THAI HIEN TAI" -ForegroundColor Yellow
Write-Host "-----------------------------------------" -ForegroundColor Yellow

foreach ($serviceName in $services) {
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    
    if ($service) {
        $status = $service.Status
        $displayName = $service.DisplayName
        
        if ($status -eq "Running") {
            Write-Host "[OK] $displayName : $status" -ForegroundColor Green
        } else {
            Write-Host "[!] $displayName : $status" -ForegroundColor Yellow
        }
    } else {
        Write-Host "[ERROR] Khong tim thay service: $serviceName" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "2. START SERVICES (neu can)" -ForegroundColor Yellow
Write-Host "-----------------------------------------" -ForegroundColor Yellow

foreach ($serviceName in $services) {
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    
    if ($service) {
        if ($service.Status -ne "Running") {
            Write-Host "Dang start: $($service.DisplayName)..." -ForegroundColor Cyan
            try {
                Start-Service -Name $serviceName
                Write-Host "[OK] $($service.DisplayName) da duoc start" -ForegroundColor Green
            } catch {
                Write-Host "[ERROR] Khong the start $($service.DisplayName): $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }
}

Write-Host ""
Write-Host "3. TRANG THAI SAU KHI START" -ForegroundColor Yellow
Write-Host "-----------------------------------------" -ForegroundColor Yellow

foreach ($serviceName in $services) {
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    
    if ($service) {
        $status = $service.Status
        $displayName = $service.DisplayName
        
        if ($status -eq "Running") {
            Write-Host "[OK] $displayName : $status" -ForegroundColor Green
        } else {
            Write-Host "[!] $displayName : $status" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "4. KIEM TRA KETS NOI" -ForegroundColor Yellow
Write-Host "-----------------------------------------" -ForegroundColor Yellow

# Lấy tên máy
$computerName = $env:COMPUTERNAME

Write-Host "Ten may: $computerName" -ForegroundColor Cyan
Write-Host ""
Write-Host "Cac connection string de ket noi:" -ForegroundColor Cyan
Write-Host ""
Write-Host "Server Me (Port 1436):" -ForegroundColor White
Write-Host "  $computerName\SQLEXPRESS06,1436" -ForegroundColor Gray
Write-Host ""
Write-Host "Server Con 1 (Port 1437):" -ForegroundColor White
Write-Host "  $computerName\SQLEXPRESS07,1437" -ForegroundColor Gray
Write-Host ""
Write-Host "Server Con 2 (Port 1438):" -ForegroundColor White
Write-Host "  $computerName\SQLEXPRESS08,1438" -ForegroundColor Gray
Write-Host ""

# Test kết nối port
Write-Host "5. TEST KET NOI PORT" -ForegroundColor Yellow
Write-Host "-----------------------------------------" -ForegroundColor Yellow

$ports = @(1436, 1437, 1438)

foreach ($port in $ports) {
    $result = Test-NetConnection -ComputerName "localhost" -Port $port -WarningAction SilentlyContinue
    
    if ($result.TcpTestSucceeded) {
        Write-Host "[OK] Port $port : OPEN" -ForegroundColor Green
    } else {
        Write-Host "[!] Port $port : CLOSED (kiem tra TCP/IP va Firewall)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "HOAN THANH KIEM TRA" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Luu y:" -ForegroundColor Yellow
Write-Host "- Neu service khong chay, kiem tra SQL Server Configuration Manager" -ForegroundColor Yellow
Write-Host "- Neu port dong, kiem tra Firewall va TCP/IP settings" -ForegroundColor Yellow
Write-Host ""

pause
