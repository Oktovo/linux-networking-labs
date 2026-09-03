#!/bin/bash

set -e

# === Проверка namespaces ===
sudo ip netns

# === Проверка Client ===
sudo ip netns exec Client ip addr show veth-c
sudo ip netns exec Client ip link show veth-c
sudo ip netns exec Client ip link show lo
sudo ip netns exec Client ip route
# === Проверка Server ===
sudo ip netns exec Server ip addr show veth-s
sudo ip netns exec Server ip link show veth-s
sudo ip netns exec Server ip link show lo
sudo ip netns exec Server ip route
# === Проверка Router ===
sudo ip netns exec Router ip addr show veth-r1
sudo ip netns exec Router ip addr show veth-r2
sudo ip netns exec Router ip link show veth-r1
sudo ip netns exec Router ip link show veth-r2
sudo ip netns exec Router ip link show lo
# === Проверка Router ip_fotward 1 или 0 ===
sudo sysctl net.ipv4.ip_forward
# === Проверка связности ===
sudo ip netns exec Client ping -c 2 10.0.2.2

sudo ip netns exec Client traceroute  -n -I  -q 2 10.0.2.2
