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

clear
MYIP=$(wget -qO- ipinfo.io/ip)
domain=$(cat /etc/domain)

echo -e "$siani╒════════════════════════════════════════════╕\033[0m"
echo -e " \033[0;41;36m                   \033[1mADD SSH                 \033[0m"
echo -e "$siani╘════════════════════════════════════════════╛\033[0m"
read -p "[+]Enter User name: " username
read -p "[+]Enter Password: " password
read -p "[+]Enter Expiration Day(s): " days
#check user if exist
exist="$(cat /etc/passwd | grep /bin/false | grep ${username} | cut -d: -f1 | sed 's/ //g')"

if [[ "${exist}" == "${username}" ]]; then
	echo ""
	echo -e "${kataa_kidude}Error${mwisho}: \033[1mUser $username Exist ${mwisho}"
	exit 0
else
	useradd -e `date -d "${days} days" +"%Y-%m-%d"` -s /bin/false -M $username
	echo -e "$password\n$password\n" | passwd $username &> /dev/null
	echo -e "${kubali_kidude}User Created Successfully!"
	sleep 2
fi	
clear
hariini=`date -d "0 days" +"%Y-%m-%d"`
expi=`date -d "${days} days" +"%Y-%m-%d"`

echo -e "${PURPLE}----------=[ User Information ]=------------${mwisho}";
echo -e "$siani╭═══════════════════════════════════════════╮\033[0m"
echo -e "|	\033[0;33mIP/Host\033[0m       : \033[1m$MYIP\033[0m "
echo -e "|	\033[0;33mDomain\033[0m        : \033[1m${domain}\033[0m"
echo -e "|	\033[0;33mUsername\033[0m      : \033[1m$username\033[0m"
echo -e "|	\033[0;33mPassword\033[0m      : \033[1m$password\033[0m"
echo -e "|"
echo -e "$siani╭════════════════════════════════════════════╮\033[0m"
echo -e "|	\033[0;33mOpenSsh\033[0m       : \033[1m22\033[0m"
echo -e "|	\033[0;33mDropbear\033[0m      : \033[1m109, 143\033[0m"
echo -e "|	\033[0;33mSSL/TLS\033[0m       : \033[1m8000,443\033[0m"
echo -e "|	\033[0;33mSSH WS SSL\033[0m    : \033[1m443, 8000, 9090\033[0m"
echo -e "|	\033[0;33mSSH WS No SSL\033[0m : \033[1m80,8080,8880\033[0m"
echo -e "|	\033[0;33mPort SSL\033[0m      : \033[1m990\033[0m"
echo -e "|"
echo -e "$siani╭════════════════════════════════════════════╮\033[0m"
echo -e "|	\033[0;33mBadVpn\033[0m     : \033[1m7100-7200-7300\033[0m"
echo -e "|	\033[0;33mCreated\033[0m    : \033[1m$hariini\033[0m"
echo -e "|	\033[0;33mExpired\033[0m    : \033[1m$expi\033[0m"
echo -e "|"
echo -e "$siani╰═════════════════════════════════════════════╯\033[0m"
echo -e "${PURPLE}----------=[ Payloads Information ]=------------${mwisho}";
echo -e "GET wss://bug.com [protocol][crlf]Host: ${domain}[crlf]Connection: Upgrade[crlf]Upgrade: websocket[crlf][crlf] \n"
echo -e ""
echo -e ""
