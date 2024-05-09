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
dark_blue="\033[38;2;0;0;128m"
orange_kidude="${orange}\033[1m[!]$mwisho"

clear
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

echo -e "${selected_color}
                   ┏•      
┏┓┏┓┏┓┏┓┓┏┏  ┏┏┓┏┓╋╋┓┏┏┓╋┏┓
┛ ┗ ┛┗┗ ┗┻┛  ┗┗ ┛ ┗┛┗┗┗┻┗┗ 
${mwisho}                           
"
echo -e "🚀${kubali_kidude}Polling New Certificate.."
systemctl stop nginx
domain=$(cat /etc/domain)
wget -q https://raw.githubusercontent.com/acmesh-official/acme.sh/master/acme.sh
bash acme.sh --install
rm acme.sh
cd .acme.sh
bash acme.sh --register-account -m senowahyu62@gmail.com
bash acme.sh --issue --standalone -d $domain --force
bash acme.sh --installcert -d $domain --fullchainpath /etc/certificates/main.crt --keypath /etc/certificates/main.key
