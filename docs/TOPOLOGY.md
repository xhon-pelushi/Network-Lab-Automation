# Network Lab Topology

## Overview

This document describes the network topology for the virtual lab environment.

## Physical/Virtual Infrastructure

### Hypervisors
- **VMware ESXi**: Primary hypervisor for production workloads
- **Hyper-V**: Secondary hypervisor for development/testing

### Virtual Machines

#### Windows Server 2022
- **DC1 (Domain Controller)**: 192.168.10.10
  - Active Directory Domain Services
  - DNS Server
  - DHCP Server
  - File Services

- **FS1 (File Server)**: 192.168.10.20
  - File and Storage Services
  - Print Server

#### Ubuntu 22.04 LTS
- **Router/VPN**: 192.168.10.1
  - Routing and NAT
  - OpenVPN Server
  - WireGuard Server
  - Firewall (UFW)

- **Monitoring**: 192.168.10.30
  - Network monitoring tools
  - Log aggregation

## Network Segments

### Management Network (192.168.10.0/24)
- **Purpose**: Administrative access and management
- **Gateway**: 192.168.10.1
- **DNS**: 192.168.10.10
- **DHCP Range**: 192.168.10.100 - 192.168.10.200

### Production Network (192.168.20.0/24)
- **Purpose**: Production workloads and services
- **Gateway**: 192.168.20.1
- **VLAN ID**: 20

### DMZ Network (192.168.30.0/24)
- **Purpose**: Public-facing services
- **Gateway**: 192.168.30.1
- **VLAN ID**: 30
- **Web Server**: 192.168.30.10

## VPN Configuration

### OpenVPN
- **Port**: 1194/UDP
- **Network**: 10.8.0.0/24
- **Protocol**: UDP
- **Encryption**: AES-256-CBC

### WireGuard
- **Port**: 51820/UDP
- **Network**: 10.9.0.0/24
- **Protocol**: UDP
- **Encryption**: ChaCha20Poly1305

## Routing

### Static Routes
- Default route: 0.0.0.0/0 → Internet Gateway
- 192.168.10.0/24 → Direct
- 192.168.20.0/24 → Direct
- 192.168.30.0/24 → Direct

## Firewall Rules

### Inbound
- SSH: 22/TCP (Management network only)
- RDP: 3389/TCP (Management network only)
- OpenVPN: 1194/UDP (Public)
- WireGuard: 51820/UDP (Public)
- HTTP: 80/TCP (DMZ only)
- HTTPS: 443/TCP (DMZ only)

### Outbound
- All traffic allowed with NAT













































