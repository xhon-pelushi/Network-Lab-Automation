#!/bin/bash
# WireGuard Setup Script for Ubuntu Server
# Configures WireGuard VPN server

set -e

WG_DIR="/etc/wireguard"
WG_INTERFACE="wg0"

echo "Installing WireGuard..."
apt-get update
apt-get install -y wireguard wireguard-tools

# Generate server keys
if [ ! -f "$WG_DIR/server_private.key" ]; then
    wg genkey | tee $WG_DIR/server_private.key | wg pubkey > $WG_DIR/server_public.key
    chmod 600 $WG_DIR/server_private.key
    chmod 644 $WG_DIR/server_public.key
fi

# Get server IP
SERVER_IP=$(hostname -I | awk '{print $1}')

# Create WireGuard configuration
cat > $WG_DIR/$WG_INTERFACE.conf << EOF
[Interface]
Address = 10.9.0.1/24
ListenPort = 51820
PrivateKey = $(cat $WG_DIR/server_private.key)
PostUp = iptables -A FORWARD -i $WG_INTERFACE -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i $WG_INTERFACE -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

# Client configuration template
# [Peer]
# PublicKey = <client-public-key>
# AllowedIPs = 10.9.0.2/32
EOF

# Enable IP forwarding
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# Configure firewall
ufw allow 51820/udp

# Start WireGuard
systemctl enable wg-quick@$WG_INTERFACE
systemctl start wg-quick@$WG_INTERFACE

echo "WireGuard server configured successfully!"
echo "Server Public Key: $(cat $WG_DIR/server_public.key)"
echo "Server IP: $SERVER_IP"
echo "Port: 51820/UDP"













































