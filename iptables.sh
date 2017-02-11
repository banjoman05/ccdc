#!/bin/bash

# Should be good
iptables -P INPUT DROP
iptables -F
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 25 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
iptables -A INPUT -p icmp -m limit -limit 1/second -j ACCEPT

# Maybe
iptables -A INPUT --in-interface ! lo --source 127.0.0.0/8 -j DROP

# Fancy crap
iptables -N LOGNDROP
iptables -A LOGNDROP -m limit --limit 10/second -j LOG --log-prefix "IPT_LOGNDROP"
iptables -A LOGNDROP -j DROP

iptables -N SYNLIMIT
iptables -A SYNLIMIT -p tcp --syn -m limit --limit 5/second -j ACCEPT

iptables -N BADFLAGDROP
iptables -A BADFLAGDROP -j LOG --log-prefix "IPT_BADFLAGS"
iptables -A BADFLAGDROP -j DROP

# Prevent synfloods maybe

# HTTP
iptables -A INPUT -p tcp --dport 80 --syn -m state --state NEW -j SYNLIMIT
iptables -A OUTPUT -p tcp --dport 80 --syn -m state --state NEW -j ACCEPT
iptables -A INPUT -p tcp --dport 443 --syn -m state --state NEW -j SYNLIMIT
iptables -A OUTPUT -p tcp --dport 443 --syn -m state --state NEW -j ACCEPT

# SMTP
iptables -A INPUT -p tcp --dport 25 --syn -m state --state NEW -j SYNLIMIT
iptables -A OUTPUT -p tcp --dport 25 --syn -m state --state NEW -j ACCEPT

##IMAP/IMAPS
#iptables -A INPUT -p tcp --dport 143 --syn -m state --state NEW -j SYNLIMIT
#iptables -A OUTPUT -p tcp --dport 143 --syn -m state --state NEW -j ACCEPT
#iptables -A INPUT -p tcp --dport 993 --syn -m state --state NEW -j SYNLIMIT
#iptables -A OUTPUT -p tcp --dport 993 --syn -m state --state NEW -j ACCEPT

##POP3/POP3S
#iptables -A INPUT -p tcp --dport 110 --syn -m state --state NEW -j SYNLIMIT
#iptables -A OUTPUT -p tcp --dport 110 --syn -m state --state NEW -j ACCEPT
#iptables -A INPUT -p tcp --dport 995 --syn -m state --state NEW -j SYNLIMIT
#iptables -A OUTPUT -p tcp --dport 995 --syn -m state --state NEW -j ACCEPT

# Invalid/malformed
iptables -A INPUT -m state --state INVALID -j DROP
iptables -A OUTPUT -m state --state INVALID -j DROP
iptables -A INPUT -p tcp -m tcp UNCLEAN -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags ALL NONE -j BADFLAGDROP
iptables -A INPUT -p tcp -m tcp --tcp-flags ALL ALL -j BADFLAGDROP
iptables -A INPUT -p tcp -m tcp --tcp-flags FIN FIN -j BADFLAGDROP
iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN FIN,SYN -j BADFLAGDROP
iptables -A INPUT -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -j BADFLAGDROP
iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,RST FIN,RST -j BADFLAGDROP
iptables -A INPUT -p tcp -m tcp --tcp-flags ALL FIN,URG,PSH -j BADFLAGDROP
iptables -A INPUT -p tcp -m tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j BADFLAGDROP

