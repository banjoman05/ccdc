#!/bin/bash

# Clear out the backdoor
crontab -r

# Backup the old repo lists
/bin/mv /etc/apt/sources.list /etc/apt/sources.list.old

# Create new repo lists with archived location
echo "deb http://archive.debian.org/debian-archive/debian/ lenny main contrib non-free" >> /etc/apt/sources.list
echo "deb http://archive.debian.org/debian-security/ lenny/updates main contrib non-free" >> /etc/apt/sources.list

# Jhu Li, do the thing!
apt-get update
apt-get install -y --force-yes vim htop fail2ban unzip build-essential libssl-dev

# Configure IPTABLES
/sbin/iptables -P INPUT DROP
/sbin/iptables -F
/sbin/iptables -A INPUT -i lo -j ACCEPT
/sbin/iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport 25 -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport 443 -j ACCEPT
/sbin/iptables -P FORWARD DROP
/sbin/iptables -P OUTPUT ACCEPT
/sbin/iptables -A INPUT -p icmp -m limit -limit 1/second -j ACCEPT
/sbin/iptables -A INPUT --in-interface ! lo --source 127.0.0.0/8 -j DROP

# Disable shells for these service accounts
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
chsh -s /bin/false lp

# More local account stuff
chmod 400 /etc/shadow

# Disable services we don't need
/etc/init.d/ssh stop
/etc/init.d/portmap stop
/etc/init.d/cups stop
















