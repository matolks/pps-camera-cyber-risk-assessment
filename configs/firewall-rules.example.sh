#!/bin/bash

# Firewall example for enforcing proxy-based access to a PPS camera.
#
# Replace these placeholders before use:
# - CAMERA_INTERFACE
# - NVR_INTERFACE
# - CAMERA_PRIVATE_IP
#
# Example meaning:
# - CAMERA_INTERFACE: interface connected toward the camera subnet
# - NVR_INTERFACE: interface connected toward the NVR/client subnet
# - CAMERA_PRIVATE_IP: private IP address of the protected camera
#
# This file is not a complete production hardening guide.

set -e

# Clear existing forwarding rules.
sudo iptables -F FORWARD

# Default denying routed traffic between interfaces.
# This prevents the proxy host from acting as an open router.
sudo iptables -P FORWARD DROP

# Allow trusted NVR/client-side devices to reach the local proxy service.
sudo iptables -A INPUT \
  -i NVR_INTERFACE \
  -p tcp \
  --dport 80 \
  -j ACCEPT

# Allow the proxy host itself to initiate HTTP connections to the camera.
# This supports reverse-proxy traffic without allowing direct subnet forwarding.
sudo iptables -A OUTPUT \
  -o CAMERA_INTERFACE \
  -p tcp \
  -d CAMERA_PRIVATE_IP \
  --dport 80 \
  -j ACCEPT

# Allow established and related return traffic.
sudo iptables -A INPUT \
  -m state --state ESTABLISHED,RELATED \
  -j ACCEPT

sudo iptables -A OUTPUT \
  -m state --state ESTABLISHED,RELATED \
  -j ACCEPT

# Explicitly block direct routed traffic from the NVR/client subnet to the camera subnet.
sudo iptables -A FORWARD \
  -i NVR_INTERFACE \
  -o CAMERA_INTERFACE \
  -j DROP

# Explicitly block direct routed traffic from the camera subnet to the NVR/client subnet.
sudo iptables -A FORWARD \
  -i CAMERA_INTERFACE \
  -o NVR_INTERFACE \
  -j DROP

# Persist firewall rules.
sudo apt install iptables-persistent -y
sudo netfilter-persistent save