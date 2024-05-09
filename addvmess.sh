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

banner(){
    echo -e "${selected_color}
   ┓ ┓           
┏┓┏┫┏┫  ┓┏┏┳┓┏┓┏┏
┗┻┗┻┗┻  ┗┛┛┗┗┗ ┛┛
    ${mwisho}
    "
}


domain=$(cat /etc/domain)
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${exist} == '0' ]]; do ##ikiwa true loop inaisha
        echo -e "${kubali}${kidude}${mwisho}White Space Are not allowed"
        clear
        banner
		read -rp "[+]Username : " -e user
		exist=$(grep -w $user /usr/local/etc/xray/vmtls.json | wc -l)

		if [[ ${exist} -ge '2' ]]; then
			echo ""
			echo -e "${kataa_kidude}User ${user} Is Already Regestered!${mwisho}"
			sleep 2
      clear
		fi
done

read -p "[+]Exipration Date (in days): " expiration_days
if ! [[ $expiration_days =~ ^[0-9]+$ ]]; then
    echo -e "${kataa_kidude}Invald Number Of Days${mwisho}"
    exit 1
fi
current_date=`date -d "0 days" +"%Y-%m-%d"`
exp=`date -d "$expiration_days days" +"%Y-%m-%d"`
userid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#vmtls$/a\### '"$user $exp"'\
},{"id": "'""$userid""'","alterId": '"32"',"email": "'""$user""'"' /usr/local/etc/xray/vmtls.json 
sed -i '/#vmntls$/a\### '"$user $exp"'\
},{"id": "'""$userid""'","alterId": '"32"',"email": "'""$user""'"' /usr/local/etc/xray/vmntls.json


cat>/usr/local/etc/xray/users/vmess/$user-tls.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "443",
      "id": "${userid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmtls",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF
cat>/usr/local/etc/xray/users/vmess/$user-nontls.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "80",
      "id": "${userid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmntls",
      "type": "none",
      "host": "",
      "tls": "none"
}
EOF
sleep 1
clear
echo -e "${kubali}User Created Sucessfully!${mwisho}"
hashed="vmess://$(base64 -w 0 /usr/local/etc/xray/users/vmess/$user-tls.json)"
hashed2="vmess://$(base64 -w 0 /usr/local/etc/xray/users/vmess/$user-nontls.json)"
systemctl restart vmtls
systemctl restart vmntls
systemctl restart nginx
echo -e "$selected_color╒════════════════════════════════════════════╕\033[0m" | tee -a /usr/local/etc/xray/backup/vmess/$user-tls.txt
echo -e "         ------>[USER DETAILS]<------                      "  | tee -a /usr/local/etc/xray/backup/vmess/$user-tls.txt
echo -e "$selected_color╘════════════════════════════════════════════╛\033[0m" | tee -a /usr/local/etc/xray/backup/vmess/$user-tls.txt
echo -e "$selected_color╒═════════════════════════════════════════════╕\033[0m"| tee -a /usr/local/etc/xray/backup/vmess/$user-tls.txt
echo -e "      ${orange}remarks${mwisho} : \033[1m${user}${mwisho}      "  | tee -a /usr/local/etc/xray/backup/vmess/$user-tls.txt
echo -e "      ${orange}Host${mwisho}    : \033[1m$domain${mwisho} "       | tee -a /usr/local/etc/xray/backup/vmess/$user-tls.txt
echo -e "      ${orange}Address${mwisho} : \033[1m$domain${mwisho}   "   | tee -a /usr/local/etc/xray/backup/vmess/$user-tls.txt
echo -e "      ${orange}Port${mwisho}    : \033[1m443${mwisho}    "   | tee -a /usr/local/etc/xray/backup/vmess/$user-tls.txt
echo -e "      ${orange}Uuid${mwisho}    : \033[1m${userid}${mwisho} "  | tee -a /usr/local/etc/xray/backup/vmess/$user-tls.txt
echo -e "      ${orange}AlterId${mwisho} : \033[1m32${mwisho}   "   | tee -a /usr/local/etc/xray/backup/vmess/$user-tls.txt
echo -e "      ${orange}Security${mwisho}: \033[1mauto${mwisho}   "  | tee -a /usr/local/etc/xray/backup/vmess/$user-tls.txt
echo -e "      ${orange}Network${mwisho} : \033[1mws${mwisho}  "   | tee -a /usr/local/etc/xray/backup/vmess/$user-tls.txt
echo -e "      ${orange}Path${mwisho}    : \033[1m/vmtls${mwisho}  "  | tee -a /usr/local/etc/xray/backup/vmess/$user-tls.txt
echo -e "      ${orange}Created${mwisho} : \033[1m${current_date}${mwisho} " | tee -a /usr/local/etc/xray/backup/vmess/$user-tls.txt
echo -e "      ${orange}Expired${mwisho} : \033[1m${exp}${mwisho}  " | tee -a /usr/local/etc/xray/backup/vmess/$user-tls.txt
echo -e "$selected_color╘════════════════════════════════════════════╛\033[0m" | tee -a /usr/local/etc/xray/backup/vmess/$user-tls.txt
echo ""                                                                    | tee -a /usr/local/etc/xray/backup/vmess/$user-tls.txt
echo -e "\033[1mLink TLS    : ${hashed}${mwisho}"  | tee -a /usr/local/etc/xray/backup/vmess/$user-tls.txt
echo  ""                                           | tee -a /usr/local/etc/xray/backup/vmess/$user-tls.txt
