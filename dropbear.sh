#!/bin/bash
kubali="\033[38;2;0;128;0m"
GREEN="\033[0;32m"
kataa="\033[31;1m"
siani="\033[0;36m"
mwisho="\033[0m"
teal_color="\033[38;2;100;182;172m"
orange="\033[0;33m"
PURPLE='\033[0;35m'
kidude="[+]"
kubali_kidude="${kubali}${kidude}${mwisho}"
kataa_kidude="${kataa}${kidude}"
# install badvpn
clear
echo -e "${kubali_kidude}${PURPLE}🚀Installing Dropbear..${mwisho}"
sleep 2
# setting port ssh
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config

#Dropbear is a lightweight SSH server and client software primarily designed for embedded systems and low-resource environments. It provides the functionality to securely connect to remote systems using the SSH (Secure Shell) protocol, allowing for secure remote administration, file transfer, and tunneling of network connections.
# install dropbear
apt -y install dropbear
cat > /etc/default/dropbear << EOF
NO_START=0
DROPBEAR_PORT=143
DROPBEAR_EXTRA_ARGS="-p 109"
DROPBEAR_BANNER="/etc/issue.net"
EOF

echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart
