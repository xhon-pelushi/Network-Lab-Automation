# DNS Configuration Script for Windows Server 2022
# Configures DNS zones and records

param(
    [string]$ZoneName = "lab.local",
    [string]$ReverseZone = "10.168.192.in-addr.arpa"
)

# Import DNS Server module
Import-Module DnsServer

Write-Host "Configuring DNS zones..." -ForegroundColor Green

try {
    # Create forward lookup zone
    $forwardZone = Get-DnsServerZone -Name $ZoneName -ErrorAction SilentlyContinue
    if (-not $forwardZone) {
        Add-DnsServerPrimaryZone -Name $ZoneName -ZoneFile "$ZoneName.dns"
        Write-Host "Forward lookup zone created: $ZoneName" -ForegroundColor Green
    } else {
        Write-Host "Forward lookup zone already exists: $ZoneName" -ForegroundColor Yellow
    }
    
    # Create reverse lookup zone
    $reverseZone = Get-DnsServerZone -Name $ReverseZone -ErrorAction SilentlyContinue
    if (-not $reverseZone) {
        Add-DnsServerPrimaryZone -Name $ReverseZone -ZoneFile "$ReverseZone.dns"
        Write-Host "Reverse lookup zone created: $ReverseZone" -ForegroundColor Green
    } else {
        Write-Host "Reverse lookup zone already exists: $ReverseZone" -ForegroundColor Yellow
    }
    
    # Add common DNS records
    $records = @(
        @{Name="dc1"; IP="192.168.10.10"; Type="A"},
        @{Name="router"; IP="192.168.10.1"; Type="A"},
        @{Name="fileserver"; IP="192.168.10.20"; Type="A"},
        @{Name="webserver"; IP="192.168.30.10"; Type="A"}
    )
    
    foreach ($record in $records) {
        $existing = Get-DnsServerResourceRecord -ZoneName $ZoneName -Name $record.Name -ErrorAction SilentlyContinue
        if (-not $existing) {
            Add-DnsServerResourceRecordA -ZoneName $ZoneName `
                -Name $record.Name `
                -IPv4Address $record.IP
            Write-Host "Added DNS record: $($record.Name) -> $($record.IP)" -ForegroundColor Green
        }
    }
    
    Write-Host "DNS configuration completed successfully" -ForegroundColor Green
    
} catch {
    Write-Host "Error configuring DNS: $_" -ForegroundColor Red
    exit 1
}

# Display zone information
Get-DnsServerZone | Format-Table ZoneName, ZoneType, IsAutoCreated



















































