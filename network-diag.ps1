# Network Diagnostics Script
# Performs comprehensive network health checks

param(
    [string[]]$TargetHosts = @("192.168.10.1", "192.168.10.10", "192.168.20.1"),
    [int]$Timeout = 3000
)

$results = @()

Write-Host "Starting network diagnostics..." -ForegroundColor Green
Write-Host "Testing connectivity to $($TargetHosts.Count) hosts" -ForegroundColor Cyan

foreach ($host in $TargetHosts) {
    Write-Host "`nTesting: $host" -ForegroundColor Yellow
    
    $result = [PSCustomObject]@{
        Host = $host
        Ping = $false
        DNS = $false
        Port80 = $false
        Port443 = $false
        ResponseTime = $null
        Timestamp = Get-Date
    }
    
    # Ping test
    try {
        $ping = Test-Connection -ComputerName $host -Count 1 -TimeoutSeconds 2 -ErrorAction Stop
        $result.Ping = $true
        $result.ResponseTime = $ping.ResponseTime
        Write-Host "  ✓ Ping: SUCCESS ($($ping.ResponseTime)ms)" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Ping: FAILED" -ForegroundColor Red
    }
    
    # DNS resolution test
    try {
        $dns = Resolve-DnsName -Name $host -ErrorAction Stop
        $result.DNS = $true
        Write-Host "  ✓ DNS: SUCCESS" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ DNS: FAILED or not resolvable" -ForegroundColor Yellow
    }
    
    # Port connectivity test
    try {
        $tcp80 = Test-NetConnection -ComputerName $host -Port 80 -WarningAction SilentlyContinue -ErrorAction Stop
        $result.Port80 = $tcp80.TcpTestSucceeded
        if ($result.Port80) {
            Write-Host "  ✓ Port 80: OPEN" -ForegroundColor Green
        } else {
            Write-Host "  ✗ Port 80: CLOSED" -ForegroundColor Red
        }
    } catch {
        Write-Host "  ✗ Port 80: ERROR" -ForegroundColor Red
    }
    
    try {
        $tcp443 = Test-NetConnection -ComputerName $host -Port 443 -WarningAction SilentlyContinue -ErrorAction Stop
        $result.Port443 = $tcp443.TcpTestSucceeded
        if ($result.Port443) {
            Write-Host "  ✓ Port 443: OPEN" -ForegroundColor Green
        } else {
            Write-Host "  ✗ Port 443: CLOSED" -ForegroundColor Red
        }
    } catch {
        Write-Host "  ✗ Port 443: ERROR" -ForegroundColor Red
    }
    
    $results += $result
}

# Summary report
Write-Host "`n" -NoNewline
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "Network Diagnostics Summary" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan

$results | Format-Table -AutoSize

# Export results
$exportPath = "network-diagnostics-$(Get-Date -Format 'yyyyMMdd-HHmmss').csv"
$results | Export-Csv -Path $exportPath -NoTypeInformation
Write-Host "`nResults exported to: $exportPath" -ForegroundColor Green

return $results




















































