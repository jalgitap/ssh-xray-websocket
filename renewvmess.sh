#!/bin/bash

kubali="\033[38;2;0;128;0m"
GREEN="\033[0;32m"
kataa="\033[31;1m"
siani="\033[0;36m"
BOLD="\033[1m"
mwisho="\033[0m"
teal_color="\033[38;2;100;182;172m"
orange="\033[0;33m"
PURPLE='\033[0;35m'
kidude="[+]"
kubali_kidude="${kubali}${kidude}${mwisho}"
kataa_kidude="${kataa}${kidude}"

#!/bin/bash

# Define the list of colors
colors=(
  "\033[0;31m"  # Red
  "\033[0;32m"  # Green
  "\033[0;33m"  # Yellow
  "\033[0;34m"  # Blue
  "\033[0;35m"  # Purple
  "\033[0;36m"  # Cyan
  "\033[0;91m"  # Light Red
  "\033[0;92m"  # Light Green
  "\033[0;93m"  # Light Yellow
  "\033[0;94m"  # Light Blue
  "\033[0;95m"  # Light Purple
  "\033[0;96m"  # Light Cyan
)

# Function to choose a random color
function choose_random_color() {
  local num_colors=${#colors[@]}
  local random_index=$((RANDOM % num_colors))
  echo -e "${colors[random_index]}"
}

selected_color=$(choose_random_color)

NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/usr/local/etc/xray/vmtls.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
    clear
    echo -e "${kataa}You have no existing clients!${mwisho}"
    exit 1
fi

clear

echo -e "${selected_color}
╦═╗┌─┐┌┐┌┌─┐┬ ┬  ╦  ╦╔╦╗┌─┐┌─┐┌─┐
╠╦╝├┤ │││├┤ │││  ╚╗╔╝║║║├┤ └─┐└─┐
╩╚═└─┘┘└┘└─┘└┴┘   ╚╝ ╩ ╩└─┘└─┘└─┘
${mwisho}
"
# Print the current date and time
echo -e "$selected_color╒═════════════════════════════════════════════╕\033[0m"
echo -e "     ${orange}[-Date-]${mwisho}     ${orange}[-Day-]${mwisho}     ${orange}[-Time-]${mwisho}     "
echo -e "     $(date +%Y-%m-%d)   $(date +%A)   $(date +%T)     "
echo -e "$selected_color╘═════════════════════════════════════════════╛\033[0m"

# Print the client list
echo -e "$selected_color╒═════════════════════════════════════════════╕\033[0m"
printf "%-5s %-15s %-15s\n" "No" "Username" "Expiration Date"

grep -E "^### " "/usr/local/etc/xray/vmtls.json" | cut -d ' ' -f 2-3 | nl -w 5 -s ') ' | while IFS= read -r line; do
    no=$(echo "$line" | awk '{print $1}')
    username=$(echo "$line" | awk '{print $2}')
    expiration=$(echo "$line" | awk '{print $3}')
    printf "%-5s %-15s %-15s\n" "$no" "$username" "$expiration"
done

echo -e "$selected_color╘═════════════════════════════════════════════╛\033[0m"

until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
    if [[ ${CLIENT_NUMBER} == '1' ]]; then
        read -rp "Select client Number [1]: " CLIENT_NUMBER
    else
        read -rp "Select client Number [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
    fi
done

read -p "New Expired Days: " masaaktif
user=$(grep -E "^### " "/usr/local/etc/xray/vmtls.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/usr/local/etc/xray/vmtls.json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
sed -i "s/### $user $exp/### $user $exp4/g" /usr/local/etc/xray/vmtls.json
sed -i "s/### $user $exp/### $user $exp4/g" /usr/local/etc/xray/vmntls.json

sleep 1
clear
echo -e "${kubali_kidude}User \033[1m${user} Days Extended Sucessfully!"

echo -e "$teal_color╒═════════════════════════════════════════════╕\033[0m"
echo -e "       ------>[User Details]<------                    "
echo -e "            Username : $orange \033[1m$user $mwisho                                                                        "
echo -e "            Created  : $orange \033[1m$exp $mwisho                                                                 "
echo -e "            Expired  : $orange \033[1m$exp4 $mwisho                                                                  "
