# Network Lab Automation

A comprehensive virtual lab environment built with VMware & Hyper-V, featuring Windows Server 2022 and Ubuntu systems for network administration and automation.

## Overview

This project demonstrates advanced network infrastructure setup and automation capabilities, including:
- Virtual lab environment with VMware & Hyper-V
- DHCP, DNS, and VPN configuration (OpenVPN + WireGuard)
- Automated network diagnostics with PowerShell & Python
- Network topology documentation using Visio and Markdown

## Lab Architecture

### Virtual Infrastructure
- **Hypervisor**: VMware ESXi / Hyper-V
- **Windows Server 2022**: Domain Controller, DNS, DHCP Server
- **Ubuntu 22.04 LTS**: Router, VPN Server, Monitoring

### Network Topology
- **Subnet 1**: 192.168.10.0/24 - Management Network
- **Subnet 2**: 192.168.20.0/24 - Production Network
- **Subnet 3**: 192.168.30.0/24 - DMZ Network

## Features

### DHCP Configuration
- Automatic IP assignment across subnets
- Reserved IP addresses for critical services
- Scope configuration for multiple VLANs

### DNS Setup
- Active Directory Integrated DNS
- Forward and reverse lookup zones
- DNS forwarding configuration

### VPN Services
- **OpenVPN**: Site-to-site and remote access VPN
- **WireGuard**: High-performance VPN for mobile clients
- Access control and routing policies

### Automation Scripts
- PowerShell scripts for network diagnostics
- Python tools for topology discovery
- Automated health checks and reporting

## Documentation

See the `docs/` directory for detailed documentation:
- Network topology diagrams
- Configuration guides
- Troubleshooting procedures

## Requirements

- VMware vSphere or Hyper-V
- Windows Server 2022
- Ubuntu 22.04 LTS
- PowerShell 5.1+
- Python 3.8+

## License

MIT License












































