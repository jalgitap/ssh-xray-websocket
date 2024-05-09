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
clear

echo -e "${selected_color}
╔╗ ┬  ┌─┐┌─┐┬┌─┌─┐┌┬┐  ╔╦╗┌─┐┌┬┐┌─┐┬┌┐┌┌─┐
╠╩╗│  │ ││  ├┴┐├┤  ││   ║║│ ││││├─┤││││└─┐
╚═╝┴─┘└─┘└─┘┴ ┴└─┘─┴┘  ═╩╝└─┘┴ ┴┴ ┴┴┘└┘└─┘
${mwisho}
"
CONFIG_FILE="/usr/local/etc/xray/vmtls.json"
CONFIG_FILE2="/usr/local/etc/xray/vltls.json"
CONFIG_FILE3="/usr/local/etc/xray/trtls.json"
list_blocked_domains() {
  echo -e "${kubali_kidude}Blocked Domains:${mwisho}"
  echo -e "$selected_color╭═══════════════════════════════════════════════════╮\033[0m"
  grep -oP '(?<=domain": \[")[^"]*' "$CONFIG_FILE" | nl -w2 -s". "
  grep -oP '(?<=domain": \[")[^"]*' "$CONFIG_FILE2" | nl -w2 -s". "
  grep -oP '(?<=domain": \[")[^"]*' "$CONFIG_FILE3" | nl -w2 -s". "
  echo -e "$selected_color╰═══════════════════════════════════════════════════╯\033[0m"
}

