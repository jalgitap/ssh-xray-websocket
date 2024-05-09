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
if systemctl is-active --quiet  nginx; then
    nginxstatus="${kubali}\033[1mON✅${mwisho}"
else
    nginxstatus="${kataa}\033[1mOFF❌${mwisho}"
fi        

if systemctl is-active --quiet  websocket; then
    websocketstatus="${kubali}\033[1mON✅${mwisho}"
else
    websocketstatus="${kataa}\033[1mOFF❌${mwisho}"
fi

if systemctl is-active --quiet  dropbear; then
    dropbearstatus="${kubali}\033[1mON✅${mwisho}"
else
    dropbearstatus="${kataa}\033[1mOFF❌${mwisho}"
fi

if systemctl is-active --quiet  vmtls; then
    vmtlsstatus="${kubali}\033[1mON✅${mwisho}"
else
    vmtlsstatus="${kataa}\033[1mOFF❌${mwisho}"
fi

if systemctl is-active --quiet  vmntls; then
    vmntlsstatus="${kubali}\033[1mON✅${mwisho}"
else
    vmntlsstatus="${kataa}\033[1mOFF❌${mwisho}"
fi

if systemctl is-active --quiet  vltls; then
    vltlsstatus="${kubali}\033[1mON✅${mwisho}"
else
    vltlsstatus="${kataa}\033[1mOFF❌${mwisho}"
fi

if systemctl is-active --quiet  vlntls; then
    vlntlsstatus="${kubali}\033[1mON✅${mwisho}"
else
    vlntlsstatus="${kataa}\033[1mOFF❌${mwisho}"
fi

if systemctl is-active --quiet  trtls; then
    trtlsstatus="${kubali}\033[1mON✅${mwisho}"
else
    trtlsstatus="${kataa}\033[1mOFF❌${mwisho}"
fi

if systemctl is-active --quiet  trntls; then
    trntlsstatus="${kubali}\033[1mON✅${mwisho}"
else
    trntlsstatus="${kataa}\033[1mOFF❌${mwisho}"
fi

if systemctl is-active --quiet cron; then
    cronstatus="${kubali}\033[1mON✅${mwisho}"
else
    cronstatus="${kataa}\033[1mOFF❌${mwisho}"
fi

clear
echo -e "${selected_color}
╔═╗┌─┐┬─┐┬  ┬┬┌─┐┌─┐  ╔═╗┌─┐┌┬┐┬┬  ┬┬┌┬┐┬┌─┐┌─┐
╚═╗├┤ ├┬┘└┐┌┘││  ├┤   ╠═╣│   │ │└┐┌┘│ │ │├┤ └─┐
╚═╝└─┘┴└─ └┘ ┴└─┘└─┘  ╩ ╩└─┘ ┴ ┴ └┘ ┴ ┴ ┴└─┘└─┘
${mwisho}
"
echo -e "$selected_color╭═══════════════════════════════════════════════════╮\033[0m"
    echo -e " \033[0;41;36m                   \033[1mService Info                    \033[0m"
    echo -e "$selected_color╭═══════════════════════════════════════════════════╮\033[0m"
    echo -e "    \033[1mService\033[0m                            \033[1mStatus\033[0m                                       "
    echo -e "$selected_color╰═══════════════════════════════════════════════════╯\033[0m"
    echo -e "    Nginx                               ${nginxstatus}                               "
    echo -e "    Dropbear                            ${dropbearstatus}                                     "
    echo -e "    Cron                                ${cronstatus}                                  "
    echo -e "    Websocket                           ${websocketstatus}                                       "
    echo -e "    Vmess TLS                           ${vmtlsstatus}                                       "
    echo -e "    Vless TLS                           ${vltlsstatus}                                       "
    echo -e "    Trojan TLS                          ${trtlsstatus}                                        "
    echo -e "    Vmess NON TLS                       ${vmntlsstatus}                                           "
    echo -e "    Vless NON TLS                       ${vlntlsstatus}                                           "
    echo -e "    Trojan NON TLS                      ${trntlsstatus}                                              "
