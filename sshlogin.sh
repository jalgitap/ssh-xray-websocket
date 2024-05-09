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

if [ -e "/var/log/auth.log" ]; then
        LOG="/var/log/auth.log";
fi
if [ -e "/var/log/secure" ]; then
        LOG="/var/log/secure";
fi
                
data=( `ps aux | grep -i dropbear | awk '{print $2}'`);
#echo "----------=[ Dropbear User Login ]=-----------";
#echo " Username  |  IP Address";
#echo "----------------------------------------------";
echo -e "${siani}----------=[ Dropbear User Login ]=------------${mwisho}";
echo -e "$siani╒════════════════════════════════════════════╕\033[0m"
echo -e " \033[0;41;36m\033[1m      USERNAME               IP             \033[0m"
echo -e "$siani╘════════════════════════════════════════════╛\033[0m"
cat $LOG | grep -i dropbear | grep -i "Password auth succeeded" > /tmp/login-db.txt;
for PID in "${data[@]}"
do
        cat /tmp/login-db.txt | grep "dropbear\[$PID\]" > /tmp/login-db-pid.txt;
        NUM=`cat /tmp/login-db-pid.txt | wc -l`;
        USER=`cat /tmp/login-db-pid.txt | awk '{print $10}'`;
        IP=`cat /tmp/login-db-pid.txt | awk '{print $12}'`;
        if [ $NUM -eq 1 ]; then
                echo "        $USER           |     $IP";
                fi
done
echo -e "$siani╘════════════════════════════════════════════╛\033[0m"
echo -e ""
echo -e "${siani}----------=[ OpenSsh User Login ]=------------${mwisho}";
echo -e "$siani╒════════════════════════════════════════════╕\033[0m"
echo -e " \033[0;41;36m\033[1m      USERNAME               IP             \033[0m"
echo -e "$siani╘════════════════════════════════════════════╛\033[0m"
cat $LOG | grep -i sshd | grep -i "Accepted password for" > /tmp/login-db.txt
data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);

for PID in "${data[@]}"
do
        cat /tmp/login-db.txt | grep "sshd\[$PID\]" > /tmp/login-db-pid.txt;
        NUM=`cat /tmp/login-db-pid.txt | wc -l`;
        USER=`cat /tmp/login-db-pid.txt | awk '{print $9}'`;
        IP=`cat /tmp/login-db-pid.txt | awk '{print $11}'`;
        if [ $NUM -eq 1 ]; then
                echo "        $USER           |     $IP";
        fi
done
echo -e "$siani╘════════════════════════════════════════════╛\033[0m"
