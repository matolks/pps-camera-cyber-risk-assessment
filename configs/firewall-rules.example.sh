#!/bin/bash

# Firewall rules for forcing camera traffic through the proxy
# Replace interface names and IPs before running

set -e

CAMERA_IF="CAMERA_INTERFACE"
NVR_IF="NVR_INTERFACE"
CAMERA_IP="CAMERA_PRIVATE_IP"

# Start from a clean FORWARD
sudo iptables -F FORWARD

# Do not allow this host to route traffic directly between subnets
sudo iptables -P FORWARD DROP

# Allow NVR/client traffic to reach the proxy
sudo iptables -A INPUT \
  -i "$NVR_IF" \
  -p tcp \
  --dport 80 \
  -j ACCEPT

# Allow the proxy host to connect to the camera over HTTP
sudo iptables -A OUTPUT \
  -o "$CAMERA_IF" \
  -p tcp \
  -d "$CAMERA_IP" \
  --dport 80 \
  -j ACCEPT

# Allow return traffic for connections already approved
sudo iptables -A INPUT \
  -m conntrack --ctstate ESTABLISHED,RELATED \
  -j ACCEPT

sudo iptables -A OUTPUT \
  -m conntrack --ctstate ESTABLISHED,RELATED \
  -j ACCEPT

# Block direct routed traffic between the NVR/client side and camera side
sudo iptables -A FORWARD \
  -i "$NVR_IF" \
  -o "$CAMERA_IF" \
  -j DROP

sudo iptables -A FORWARD \
  -i "$CAMERA_IF" \
  -o "$NVR_IF" \
  -j DROP

# Save rules so they survive reboot.
sudo apt install iptables-persistent -y
sudo netfilter-persistent save