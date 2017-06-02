#/bin/bash
#Copyright (c) 2017 Spot Communications, Inc.

#
#START OF NECESSARY SYSCTLS
#
sysctl -w net/ipv4/tcp_syncookies=1
sysctl -w net/ipv4/tcp_timestamps=1
sysctl -w net/netfilter/nf_conntrack_tcp_loose=0
#
#END OF NECESSARY SYSCTLS
#


#
#START OF HELPER FUNCTIONS
#
allowTCP() {
	iptables -A INPUT -p tcp --dport $1 -j ACCEPT;
}
export allowTCP;

allowUDP() {
	iptables -A INPUT -p udp --dport $1 -j ACCEPT;
}
export allowUDP;

protect() {
	allowTCP $1;
	iptables -t raw -I PREROUTING -p tcp -m tcp --syn -j CT --notrack --dport $1;
	iptables -I INPUT -p tcp -m tcp -m state --state INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460 --dport $1;
}
export protect;
#
#END OF HELPER FUNCTIONS
#


#
#START OF PROTECTION RULES
#Credit: https://javapipe.com/iptables-ddos-protection
#
#Drop routed, and allow outgoing
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

#Drop invalid packets
iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP

#Drop TCP packets that are new and are not SYN
iptables -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP

#Drop SYN packets with suspicious MSS value
iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP
ip6tables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 1220:65535 -j DROP

#Block packets with bogus TCP flags
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP

#Block spoofed packets
#iptables -t mangle -A PREROUTING -s 224.0.0.0/3 -j DROP
#iptables -t mangle -A PREROUTING -s 172.16.0.0/12 -j DROP
#iptables -t mangle -A PREROUTING -s 192.168.0.0/16 -j DROP
#iptables -t mangle -A PREROUTING -s 10.0.0.0/8 -j DROP
iptables -t mangle -A PREROUTING -s 169.254.0.0/16 -j DROP
iptables -t mangle -A PREROUTING -s 192.0.2.0/24 -j DROP
iptables -t mangle -A PREROUTING -s 0.0.0.0/8 -j DROP
iptables -t mangle -A PREROUTING -s 240.0.0.0/5 -j DROP
iptables -t mangle -A PREROUTING -s 127.0.0.0/8 ! -i lo -j DROP

#Drop ICMP
#iptables -t mangle -A PREROUTING -p icmp -j DROP

#Drop fragments in all chains
iptables -t mangle -A PREROUTING -f -j DROP

#Limit connections per source IP
iptables -A INPUT -p tcp -m connlimit --connlimit-above 32 -j REJECT --reject-with tcp-reset

#Limit RST packets
iptables -A INPUT -p tcp --tcp-flags RST RST -m limit --limit 2/s --limit-burst 2 -j ACCEPT
iptables -A INPUT -p tcp --tcp-flags RST RST -j DROP
#
#END OF RULES
#


#
#START OF USER CONFIGURATION
#
source /etc/scfw_config.sh
#
#END OF USER CONFIGURATION
#


#
#FINISHING TOUCHES
#
#Drop incomming
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -P INPUT DROP
#Drop SYNPROXY invalid
iptables -A INPUT -m state --state INVALID -j DROP
#More sysctls
sysctl -w net/netfilter/nf_conntrack_tcp_loose=0
