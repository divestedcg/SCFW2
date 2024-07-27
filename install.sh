#!/bin/sh
#Copyright (c) 2017 Divested Computing Group
#License: AGPL-3.0-or-later

install -Dm700 iptables46 /usr/bin/iptables46
install -Dm700 restartscfw /usr/bin/restartscfw
install -Dm600 scfw.service /usr/lib/systemd/system/scfw.service
install -Dm700 scfw.sh /usr/lib/scfw.sh
install -Dm700 scfw_config.sh /etc/scfw_config.sh
