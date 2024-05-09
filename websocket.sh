#!/bin/bash
kubali="\033[38;2;0;128;0m"
GREEN="\033[0;32m"
kataa="\033[31;1m"
siani="\033[0;36m"
mwisho="\033[0m"
teal_color="\033[38;2;100;182;172m"
orange="\033[0;33m"
kidude="[+]"
PURPLE='\033[0;35m'
kubali_kidude="${kubali}${kidude}${mwisho}"
kataa_kidude="${kataa}${kidude}${mwisho}"
clear
echo -e "${kubali_kidude}🚀${PURPLE}Installing Websocket Script....${mwisho}"
wget -q -O /usr/local/bin/websocket https://sc2.asle.me/websocket.py

chmod +x /usr/local/bin/websocket

# Installing Service
cat > /etc/systemd/system/websocket.service << END
[Unit]
Description=Websocket Proxy By Pixer Jason
Documentation=https://t.me/PixerJason
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python2 -O /usr/local/bin/websocket 3103
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable websocket
systemctl restart websocket
systemctl enable websocket
systemctl restart websocket
sleep 3
