#Use 'allowTCP' to open a TCP port without SYNPROXY protection
#Use 'alllowUDP' to open a UDP port without SYNPROXY protection
#Use 'protect' to open a TCP port with SYNPROXY protection

#Gogs
#protect 2222 && protect 3000 && protect 8888

#Mumble
#allowUDP 64738 && protect 64738

#Netdata
#protect 19999

#Prosody
#protect 5000 && protect 5222 && protect 5269 && protect 5280 && protect 5281

#SSH
#protect 22

#Syncthing
#protect 21027 && allowUDP 22000

#Web
#protect 80 && protect 443