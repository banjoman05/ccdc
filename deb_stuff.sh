#!/bin/bash

crontab -r

/bin/mv /etc/apt/sources.list /etc/apt/sources.list.old

echo "deb http://archive.debian.org/debian-archive/debian/ lenny main contrib non-free" >> /etc/apt/sources.list
echo "deb http://archive.debian.org/debian-security/ lenny/updates main contrib non-free" >> /etc/apt/sources.list

apt-get update
apt-get install -y --force-yes vim htop sudo fail2ban unzip screen

/sbin/iptables -P INPUT DROP
/sbin/iptables -F
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 25 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

chsh -s /bin/false daemon
chsh -s /bin/false bin
chsh -s /bin/false sys
chsh -s /bin/false games
chsh -s /bin/false man
chsh -s /bin/false mail
chsh -s /bin/false news
chsh -s /bin/false uucp
chsh -s /bin/false proxy
chsh -s /bin/false www-data
chsh -s /bin/false backup
chsh -s /bin/false list
chsh -s /bin/false irc
chsh -s /bin/false gnats
chsh -s /bin/false nobody
chsh -s /bin/false libuuid
chsh -s /bin/false mailserver



















