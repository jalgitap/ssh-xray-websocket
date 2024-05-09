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

# Xray Configuration File
CONFIG_FILE="/usr/local/etc/xray/vltls.json"
CONFIG_FILE2="/usr/local/etc/xray/vlntls.json"

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

function banner(){
  echo -e "${selected_color}
╔═╗┬┌┬┐┌─┐  ╔╗ ┬  ┌─┐┌─┐┬┌─┌─┐┬─┐
╚═╗│ │ ├┤   ╠╩╗│  │ ││  ├┴┐├┤ ├┬┘
╚═╝┴ ┴ └─┘  ╚═╝┴─┘└─┘└─┘┴ ┴└─┘┴└─
          (Vless)
  ${mwisho}
  "
}
# Function to add a domain to be blocked
add_blocked_domain() {
  domain=$1
  if [[ -z "$domain" ]]; then
    echo -e "${kataa}Error: Domain cannot be empty.${mwisho}"
  elif grep -q "\"domain\": \[\"$domain\"\]" "$CONFIG_FILE"; then
    echo -e "${kataa}Domain '$domain' is already blocked.${mwisho}"
  else
    echo -e "${kubali}Adding domain '$domain' to be blocked...${mwisho}"
    sed -i "/\"rules\": \[/a \\\t{ \"type\": \"field\", \"domain\": [\"$domain\"], \"outboundTag\": \"blocked\" }," "$CONFIG_FILE"
    sed -i "/\"rules\": \[/a \\\t{ \"type\": \"field\", \"domain\": [\"$domain\"], \"outboundTag\": \"blocked\" }," "$CONFIG_FILE2"
    echo -e "${kubali}Domain '$domain' added to be blocked.${mwisho}"
    systemctl restart vltls
    systemctl restart vlntls
  fi
}

# Function to list blocked domains
list_blocked_domains() {
  clear
  echo -e "${kubali_kidude}Blocked Domains:${mwisho}"
  grep -oP '(?<=domain": \[")[^"]*' "$CONFIG_FILE" | nl -w2 -s". "
}

# Function to remove a blocked domain
remove_blocked_domain() {
  index=$1
  domain=$(grep -oP '(?<=domain": \[")[^"]*' "$CONFIG_FILE" | sed -n "${index}p")
  if [ -z "$domain" ]; then
    echo -e "${kataa}Invalid selection.${mwisho}"
  else
    echo -e "Removing domain '$domain' from blocked list..."
    sed -i "/\"domain\": \[\"$domain\"\],/d" "$CONFIG_FILE"
    sed -i "/\"domain\": \[\"$domain\"\],/d" "$CONFIG_FILE2"
    echo -e "${kubali_kidude}Domain '$domain' removed from blocked list."
    systemctl restart vltls
    systemctl restart vlntls
  fi
}

# Main function
main() {
  while true; do
    clear
    banner
    echo ""
    echo "[1]. Add a domain to be blocked"
    echo "[2]. List blocked domains"
    echo "[3]. Remove a domain from blocked list"
    echo "[4]. Exit"
    read -p "Choose an option (1-4): " choice

    case $choice in
      1)
        read -p "[!]Enter domain to be blocked (e.g., example.com): " domain
        add_blocked_domain "$domain"
        read -rp "press any key to continue"
        ;;
      2)
        list_blocked_domains
        read -rp "press any key to continue"
        ;;
      3)
        list_blocked_domains
        read -p "[!]Enter the number of the domain to be removed from the blocked list: " index
        remove_blocked_domain "$index"
        read -rp "press any key to continue"
        ;;
      4)
        echo -e "Exiting..."
        break
        ;;
      *)
        echo -e "${kataa}Invalid choice. Please try again${mwisho}."
        ;;
    esac

    echo
  done
}

main
