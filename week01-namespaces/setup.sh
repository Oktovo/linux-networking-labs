#!/bin/bash

set -e

sudo ip netns add Client #cоздал namespace для отедльних клиентов
sudo ip netns add Server
sudo ip netns add Router

sudo ip link add veth-c type veth peer name veth-r1 #создал veth пару для топологии клиент -- роутер -- сервер
sudo ip link add veth-r2 type veth peer name veth-s 

sudo ip link set dev veth-c netns Client # переместил каждым клиентам veth пару
sudo ip link set dev veth-s netns Server
sudo ip link set dev veth-r1 netns Router
sudo ip link set dev veth-r2 netns Router

sudo ip netns exec Client ip addr add 10.0.1.1/24 dev veth-c  #открыл namespace и каждой veth паре переместил ip адресс
sudo ip netns exec Router ip addr add 10.0.1.2/24 dev veth-r1
sudo ip netns exec Router ip addr add 10.0.2.1/24 dev veth-r2
sudo ip netns exec Server ip addr add 10.0.2.2/24 dev veth-s

sudo ip netns exec Client ip link set dev veth-c up # вклбючил/поднял veth  пары и lo 
sudo ip netns exec Client ip link set dev lo up
sudo ip netns exec Router ip link set dev veth-r2 up
sudo ip netns exec Router ip link set dev lo up
sudo ip netns exec Server ip link set dev veth-s up
sudo ip netns exec Server ip link set dev lo up
sudo ip netns exec Router ip link set dev veth-r1 up

sudo ip netns exec Client ip route add default via 10.0.1.2 #добавил маршрут по умолчанию
sudo ip netns exec Server ip route add default via 10.0.2.1

sudo ip netns exec Router sysctl -w net.ipv4.ip_forward=1 #включил форвард чтобы роутер стал маршрутизатором
