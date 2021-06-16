#!/bin/bash
# OpenVPN Setup Script for Ubuntu Server
# Configures OpenVPN server with TLS authentication

set -e

OPENVPN_DIR="/etc/openvpn"
CA_DIR="/etc/openvpn/easy-rsa"

echo "Installing OpenVPN and Easy-RSA..."
apt-get update
apt-get install -y openvpn easy-rsa

# Create CA directory
if [ ! -d "$CA_DIR" ]; then
    make-cadir $CA_DIR
fi

cd $CA_DIR

# Initialize PKI
if [ ! -f "$CA_DIR/vars" ]; then
    ./easyrsa init-pki
    ./easyrsa build-ca nopass
fi

# Generate server certificate
if [ ! -f "$CA_DIR/pki/issued/server.crt" ]; then
    ./easyrsa gen-req server nopass
    ./easyrsa sign-req server server
    ./easyrsa gen-dh
fi

# Copy certificates to OpenVPN directory
cp $CA_DIR/pki/ca.crt $OPENVPN_DIR/
cp $CA_DIR/pki/issued/server.crt $OPENVPN_DIR/
cp $CA_DIR/pki/private/server.key $OPENVPN_DIR/
cp $CA_DIR/pki/dh.pem $OPENVPN_DIR/

# Create server configuration
cat > $OPENVPN_DIR/server.conf << EOF
port 1194
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist /var/log/openvpn/ipp.txt
push "route 192.168.10.0 255.255.255.0"
push "route 192.168.20.0 255.255.255.0"
push "dhcp-option DNS 192.168.10.10"
keepalive 10 120
cipher AES-256-CBC
user nobody
group nogroup
persist-key
persist-tun
status /var/log/openvpn/openvpn-status.log
verb 3
EOF

# Enable IP forwarding
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# Configure firewall rules
ufw allow 1194/udp
ufw route allow in on tun0 out on eth0

# Start and enable OpenVPN
systemctl enable openvpn@server
systemctl start openvpn@server

echo "OpenVPN server configured successfully!"
echo "Server IP: $(hostname -I | awk '{print $1}')"
echo "Port: 1194/UDP"











































