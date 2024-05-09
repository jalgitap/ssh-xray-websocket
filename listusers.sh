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


echo -e "$siani╒════════════════════════════════════════════╕\033[0m"
echo -e " \033[0;41;36m\033[1mUSERNAME          EXP DATE        STATUS   \033[0m"
echo -e "$siani╘════════════════════════════════════════════╛\033[0m"

unlocked_count=0

while IFS=':' read -r user _ uid _; do
    if [[ $uid -ge 1000 && $user != "nobody" ]]; then
        exp=$(chage -l "$user" | grep "Account expires" | awk -F": " '{print $2}')
        status=$(passwd -S "$user" | awk '{print $2}')
        if [[ "$exp" != "never" ]]; then
            if [[ "$status" = "L" ]]; then
                printf "%-17s %2s %-17s %2s \n" "  $user" "$exp     " "LOCKED"
            else
                printf "%-17s %2s %-17s %2s \n" "  $user" "$exp     " "UNLOCKED"
                ((unlocked_count++))
            fi
        fi
    fi
done < /etc/passwd

echo -e "$siani╒═════════════════════════════════════════════╕\033[0m"
echo "           TOTAL: $unlocked_count  User(s)"
