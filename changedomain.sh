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
ipvps=$(curl -s ifconfig.me)
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
clear
function check_domain(){
    read -rp "🌐Enter Domain Name: " newdomain
    if [[ $newdomain = "" ]]; then
    	echo -e "${kataa}Error: Domain Name Not verified Or A record Is Not Published.${mwisho}"
    	exit
    fi
    ipdomain=$(host -t A $newdomain | awk '{print $4}')
    if [[ $ipdomain != $ipvps ]]; then
        echo -e "${kataa}Error: Domain Name Not verified Or A record Is Not Published.${mwisho}"
        sleep 3
        exit
    else
        clear
        sleep 2
        echo -e "${kubali}Good!${mwisho}Domain Verified Successfuly!"
        echo "$domain" > /etc/domain
        export newdomain=$newdomain
    fi    
}


domain=$(cat /etc/domain)
echo -e "${selected_color}
 ┓       •     ┓           
┏┫┏┓┏┳┓┏┓┓┏┓  ┏┣┓┏┓┏┓┏┓┏┓┏┓
┗┻┗┛┛┗┗┗┻┗┛┗  ┗┛┗┗┻┛┗┗┫┗ ┛ 
                      ┛   
${mwisho}                       
"
echo -e "$selected_color╒═════════════════════════════════════════════╕\033[0m"
echo -e "     [-Date-]     [-Day-]     [-Time-]     "
echo -e "     $(date +%Y-%m-%d)   $(date +%A)   $(date +%T)     "
echo -e "$selected_color╘═════════════════════════════════════════════╛\033[0m"
echo ""
echo -e "Current Domain: \033[1m${kubali}$domain${mwisho}       "
check_domain
sleep 2
echo -e "${kubali_kidude}✅Adding New Domain"
echo "${newdomain}" > /etc/domain
echo ""
systemctl stop nginx
wget -q https://raw.githubusercontent.com/acmesh-official/acme.sh/master/acme.sh
bash acme.sh --install
rm acme.sh
cd .acme.sh
bash acme.sh --register-account -m senowahyu62@gmail.com
bash acme.sh --issue --standalone -d $newdomain --force
bash acme.sh --installcert -d $newdomain --fullchainpath /etc/certificates/main.crt --keypath /etc/certificates/main.key
