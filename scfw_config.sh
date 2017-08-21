#Use 'allowTCP' to open a TCP port without SYNPROXY protection
#Use 'alllowUDP' to open a UDP port without SYNPROXY protection
#Use 'protect' to open a TCP port with SYNPROXY protection

#Gitea/Gogs
#protect 2222 && protect 3000

#Kodi
#protect 8080 && protect 9000 && allowUDP 9777

#Mumble
#allowUDP 64738 && protect 64738

#Netdata
#protect 19999

#Prosody
#protect 5222 && protect 5269 && protect 5281 #C2S, S2S, HTTPS
#protect 5000 #mod_proxy65

#SSH
#protect 22

#Syncthing
#protect 22000 && allowUDP 21027

#Web
#protect 80 && protect 443
