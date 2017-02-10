#!/bin/bash

/bin/mv /etc/apt/sources.list /etc/apt/sources.list.old

echo "deb http://archive.debian.org/debian-archive/debian/ lenny main contrib non-free" >> /etc/apt/sources.list
echo "deb http://archive.debian.org/debian-security/ lenny/updates main contrib non-free" >> /etc/apt/sources.list

apt-get update
apt-get install -y --force-yes vim htop sudo fail2ban unzip screen

/sbin/iptables -P INPUT DROP
/sbin/iptables -P FORWARD DROP
/sbin/iptables -P OUTPUT ACCEPT
/sbin/iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A INPUT -i lo -j ACCEPT
/sbin/iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
/sbin/iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT
/sbin/iptables -A INPUT -p udp -m conntrack --ctstate NEW -j UDP
/sbin/iptables -A INPUT -p tcp --syn -m conntrack --ctstate NEW -j TCP
/sbin/iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable
/sbin/iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset
/sbin/iptables -A INPUT -j REJECT --reject-with icmp-proto-unreachable
#/sbin/iptables -A TCP -p tcp --dport 22 -j ACCEPT
/sbin/iptables -A TCP -p tcp --dport 25 -j ACCEPT
/sbin/iptables -A TCP -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A TCP -p tcp --dport 443 -j ACCEPT

