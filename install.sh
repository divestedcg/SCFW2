#/bin/bash
#Copyright (c) 2017 Divested Computing, Inc.

install -Dm700 iptables46 /usr/bin/iptables46
install -Dm700 restartscfw /usr/bin/restartscfw
install -Dm600 scfw.service /usr/lib/systemd/system/scfw.service
install -Dm700 scfw.sh /usr/lib/scfw.sh
install -Dm700 scfw_config.sh /etc/scfw_config.sh
