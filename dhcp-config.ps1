# DHCP Configuration Script for Windows Server 2022
# Configures DHCP scopes for multiple subnets

param(
    [string]$ScopeName = "Lab-Subnet-1",
    [string]$StartRange = "192.168.10.100",
    [string]$EndRange = "192.168.10.200",
    [string]$SubnetMask = "255.255.255.0",
    [string]$Router = "192.168.10.1",
    [string]$DNSServer = "192.168.10.10"
)

# Import DHCP Server module
Import-Module DHCPServer

# Create DHCP scope
Write-Host "Creating DHCP scope: $ScopeName" -ForegroundColor Green

try {
    # Check if scope already exists
    $existingScope = Get-DhcpServerv4Scope -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq $ScopeName }
    
    if ($existingScope) {
        Write-Host "Scope $ScopeName already exists" -ForegroundColor Yellow
    } else {
        # Create new scope
        $scopeID = [System.Net.IPAddress]::Parse($StartRange).GetAddressBytes()[3]
        Add-DhcpServerv4Scope -Name $ScopeName `
            -StartRange $StartRange `
            -EndRange $EndRange `
            -SubnetMask $SubnetMask `
            -State Active
        
        Write-Host "DHCP scope created successfully" -ForegroundColor Green
        
        # Set scope options
        Set-DhcpServerv4OptionValue -ScopeId $scopeID `
            -Router $Router `
            -DnsServer $DNSServer
        
        # Set lease duration (7 days)
        Set-DhcpServerv4Scope -ScopeId $scopeID -LeaseDuration (New-TimeSpan -Days 7)
        
        Write-Host "DHCP scope options configured" -ForegroundColor Green
    }
} catch {
    Write-Host "Error configuring DHCP: $_" -ForegroundColor Red
    exit 1
}

# Display scope information
Get-DhcpServerv4Scope | Format-Table Name, ScopeId, StartRange, EndRange, SubnetMask, State

















































