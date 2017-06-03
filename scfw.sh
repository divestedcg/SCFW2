#/bin/bash
#Copyright (c) 2017 Spot Communications, Inc.

#
#Start of necessary sysctls
#
sysctl -w net/ipv4/tcp_syncookies=1
sysctl -w net/ipv4/tcp_timestamps=1
sysctl -w net/netfilter/nf_conntrack_tcp_loose=0
#
#End of necessary sysctls
#


#
#Start of helper functions
#
allowTCP() {
	iptables46 -A INPUT -p tcp --dport $1 -j ACCEPT;
}
export allowTCP;

allowUDP() {
	iptables46 -A INPUT -p udp --dport $1 -j ACCEPT;
}
export allowUDP;

protect() {
	allowTCP $1;
	iptables46 -t raw -I PREROUTING -p tcp -m tcp --syn -j CT --notrack --dport $1;
	iptables46 -I INPUT -p tcp -m tcp -m state --state INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460 --dport $1;
}
export protect;
#
#End of helper functions
#


#Logging
iptables46 -N LOGDROP
iptables46 -N LOGDROPBAD
iptables46 -t mangle -N LOGDROPBAD
iptables46 -N LOGDROPSCAN
iptables46 -N LOGDROPSYN


#
#Start of default policies
#
#Drop incoming, drop routed, and allow outgoing
iptables46 -P INPUT DROP
iptables46 -P FORWARD DROP
iptables46 -P OUTPUT ACCEPT
#
#End of default policies
#


#
#Start of protection rules
#Credit: https://javapipe.com/iptables46-ddos-protection #Deleted? Because of me? Don't know. Weird.
#Readme: https://security.stackexchange.com/a/4745
#
#Drop invalid packets, Broken?
#iptables46 -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j LOGDROPBAD

#Drop TCP packets that are new and are not SYN
iptables46 -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j LOGDROPBAD

#Drop SYN packets with suspicious MSS value
iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j LOGDROPBAD
ip6tables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 1220:65535 -j LOGDROPBAD

#Block packets with bogus TCP flags
iptables46 -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j LOGDROPBAD
iptables46 -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j LOGDROPBAD
iptables46 -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j LOGDROPBAD
iptables46 -t mangle -A PREROUTING -p tcp --tcp-flags SYN,FIN SYN,FIN -j LOGDROPBAD
iptables46 -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j LOGDROPBAD
iptables46 -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j LOGDROPBAD
iptables46 -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j LOGDROPBAD
iptables46 -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j LOGDROPBAD
iptables46 -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j LOGDROPBAD
iptables46 -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j LOGDROPBAD
iptables46 -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j LOGDROPBAD
iptables46 -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j LOGDROPBAD
iptables46 -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j LOGDROPBAD
iptables46 -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j LOGDROPBAD

#Block spoofed packets
#iptables -t mangle -A PREROUTING -s 224.0.0.0/3 -j LOGDROPBAD
#iptables -t mangle -A PREROUTING -s 172.16.0.0/12 -j LOGDROPBAD
#iptables -t mangle -A PREROUTING -s 192.168.0.0/16 -j LOGDROPBAD
#iptables -t mangle -A PREROUTING -s 10.0.0.0/8 -j LOGDROPBAD
iptables -t mangle -A PREROUTING -s 169.254.0.0/16 -j LOGDROPBAD
iptables -t mangle -A PREROUTING -s 192.0.2.0/24 -j LOGDROPBAD
iptables -t mangle -A PREROUTING -s 0.0.0.0/8 -j LOGDROPBAD
iptables -t mangle -A PREROUTING -s 240.0.0.0/5 -j LOGDROPBAD
iptables -t mangle -A PREROUTING -s 127.0.0.0/8 ! -i lo -j LOGDROPBAD

#Drop fragments in all chains
iptables -t mangle -A PREROUTING -f -j LOGDROPBAD

#Limit connections per source IP
iptables46 -A INPUT -p tcp -m connlimit --connlimit-above 32 ! -i lo -j REJECT --reject-with tcp-reset

#Limit RST packets
iptables46 -A INPUT -p tcp --tcp-flags RST RST -m limit --limit 2/s --limit-burst 2 -j ACCEPT
iptables46 -A INPUT -p tcp --tcp-flags RST RST -j LOGDROPBAD

#Prevent port-scanning
iptables46 -N port-scanning
iptables46 -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURN
iptables46 -A port-scanning -j LOGDROPSCAN
#
#End of protection rules
#


#
#Start of user configuration
#
source /etc/scfw_config.sh
#
#End of user configuration
#


#Drop SYNPROXY invalid
iptables46 -A INPUT -m state --state INVALID -j LOGDROPSYN


#
#Start of accepting ICMP
#Credit: https://gist.github.com/jirutka/3742890
#
iptables46 -N ICMPFLOOD
iptables46 -A ICMPFLOOD -m recent --set --name ICMP --rsource
iptables46 -A ICMPFLOOD -m recent --update --seconds 1 --hitcount 6 --name ICMP --rsource --rttl -m limit --limit 1/sec --limit-burst 1 -j LOG --log-prefix "[SCFW DROP (ICMP)] "
iptables46 -A ICMPFLOOD -m recent --update --seconds 1 --hitcount 6 --name ICMP --rsource --rttl -j LOGDROP
iptables46 -A ICMPFLOOD -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 0  -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 3  -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 11 -m conntrack --ctstate NEW -j ACCEPT
ip6tables -A INPUT              -p ipv6-icmp --icmpv6-type 1   -j ACCEPT
ip6tables -A INPUT              -p ipv6-icmp --icmpv6-type 2   -j ACCEPT
ip6tables -A INPUT              -p ipv6-icmp --icmpv6-type 3   -j ACCEPT
ip6tables -A INPUT              -p ipv6-icmp --icmpv6-type 4   -j ACCEPT
ip6tables -A INPUT              -p ipv6-icmp --icmpv6-type 133 -j ACCEPT
ip6tables -A INPUT              -p ipv6-icmp --icmpv6-type 134 -j ACCEPT
ip6tables -A INPUT              -p ipv6-icmp --icmpv6-type 135 -j ACCEPT
ip6tables -A INPUT              -p ipv6-icmp --icmpv6-type 136 -j ACCEPT
ip6tables -A INPUT              -p ipv6-icmp --icmpv6-type 137 -j ACCEPT
ip6tables -A INPUT              -p ipv6-icmp --icmpv6-type 141 -j ACCEPT
ip6tables -A INPUT              -p ipv6-icmp --icmpv6-type 142 -j ACCEPT
ip6tables -A INPUT -s fe80::/10 -p ipv6-icmp --icmpv6-type 130 -j ACCEPT
ip6tables -A INPUT -s fe80::/10 -p ipv6-icmp --icmpv6-type 131 -j ACCEPT
ip6tables -A INPUT -s fe80::/10 -p ipv6-icmp --icmpv6-type 132 -j ACCEPT
ip6tables -A INPUT -s fe80::/10 -p ipv6-icmp --icmpv6-type 143 -j ACCEPT
ip6tables -A INPUT              -p ipv6-icmp --icmpv6-type 148 -j ACCEPT
ip6tables -A INPUT              -p ipv6-icmp --icmpv6-type 149 -j ACCEPT
ip6tables -A INPUT -s fe80::/10 -p ipv6-icmp --icmpv6-type 151 -j ACCEPT
ip6tables -A INPUT -s fe80::/10 -p ipv6-icmp --icmpv6-type 152 -j ACCEPT
ip6tables -A INPUT -s fe80::/10 -p ipv6-icmp --icmpv6-type 153 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 8  -m conntrack --ctstate NEW -j ICMPFLOOD
ip6tables -A INPUT -p ipv6-icmp --icmpv6-type 128 -j ICMPFLOOD
#
#End of accepting ICMP
#


#Allow related packets
iptables46 -A INPUT -i lo -j ACCEPT
iptables46 -A OUTPUT -o lo -j ACCEPT
iptables46 -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables46 -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT


#Logging
iptables46 -A LOGDROP -m limit --limit 2/s -j LOG --log-prefix "[SCFW DROP] " --log-level 4
iptables46 -A LOGDROP -j DROP
iptables46 -A LOGDROPBAD -m limit --limit 1/s -j LOG --log-prefix "[SCFW DROP (BAD)] " --log-level 4
iptables46 -A LOGDROPBAD -j DROP
iptables46 -t mangle -A LOGDROPBAD -m limit --limit 1/s -j LOG --log-prefix "[SCFW DROP (BAD)] " --log-level 4
iptables46 -t mangle -A LOGDROPBAD -j DROP
iptables46 -A LOGDROPSCAN -m limit --limit 1/s -j LOG --log-prefix "[SCFW DROP (SCAN)] " --log-level 4
iptables46 -A LOGDROPSCAN -j DROP
iptables46 -A LOGDROPSYN -m limit --limit 10/m -j LOG --log-prefix "[SCFW DROP (SYN)] " --log-level 4
iptables46 -A LOGDROPSYN -j DROP


#More sysctls
sysctl -w net/netfilter/nf_conntrack_tcp_loose=0
