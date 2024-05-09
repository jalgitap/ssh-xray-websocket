#!/bin/bash

kubali="\033[38;2;0;128;0m"
GREEN="\033[0;32m"
kataa="\033[31;1m"
#siani="\033[0;36m"
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
siani=$(choose_random_color)
## system
domain=$(cat /etc/domain)
serverip=$(curl -s ifconfig.me)
timezone=$(timedatectl | grep "Time zone" | awk '{print $3}')
uptimevps=$(uptime -p | awk '{print $2" "$3 $4" "$5}')
city=$(curl -s ipinfo.io/city)
org=$(curl -s ipinfo.io/org | awk '{print $2""$3""$4""$5}')
country=$(curl -s ipinfo.io/country)

##hardware
diskfull=$(df -BG -x tmpfs -x devtmpfs | awk 'NR==2 {print $2}')
diskused=$(df -BG -x tmpfs -x devtmpfs | awk 'NR==2 {print $3}')
diskremain=$(df -BG -x tmpfs -x devtmpfs | awk 'NR==2 {print $4}')

function check_status(){
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

}


while true; do
    check_status
    clear
    echo -e "$siani╭════════════════════════════════════════════╮\033[0m"
    echo -e " \033[0;41;36m             \033[1mSystem Info                    \033[0m"
    echo -e "$siani╰════════════════════════════════════════════╯\033[0m"
    echo -e "  $orange_kidude Server Uptime =  \033[1m$uptimevps $mwisho                                            "
    echo -e "  $orange_kidude Server ip     =  \033[1m$serverip  $mwisho                                 "
    echo -e "  $orange_kidude City          =  \033[1m$city $mwisho                             "
    echo -e "  $orange_kidude Organization  =  \033[1m$org   $mwisho                                   "
    echo -e "  $orange_kidude Country       =  \033[1m$country $mwisho                                "
    echo -e "  $orange_kidude Domain        =  \033[1m$domain  $mwisho                               "
    echo -e "  $orange_kidude TimeZone      =  \033[1m$timezone  $mwisho                               "
    echo -e "$siani╰════════════════════════════════════════════╯\033[0m"
    echo -e "    ------>[\033[1mHardware Storage]<------                "
    echo -e "            FullDisk : $orange \033[1m$diskfull $mwisho                                                              "
    echo -e "            \033[1mDiskUsed : $orange \033[1m$diskused $mwisho                                                              "
    echo -e "            \033[1mRemain   : $orange \033[1m$diskremain $mwisho                                                                                       "
    echo -e "$siani╰════════════════════════════════════════════╯\033[0m"
    echo -e "      $siani------>$mwisho[\033[1mPackage Status]$siani<------$mwisho                "
    echo -e " Nginx:$nginxstatus               Dropbear:$dropbearstatus                                                 "
    echo -e " Websocket:$websocketstatus           Xray Core:$vmtlsstatus                                                      "
    echo -e "$siani╭════════════════════════════════════════════╮\033[0m"
    echo -e " $orange[1]$mwisho.\033[1mSSH Menu$mwisho            $orange[2]$mwisho.\033[1mVmess Menu$mwisho                       "
    echo -e " $orange[3]$mwisho.\033[1mVless Menu$mwisho          $orange[4]$mwisho.\033[1mTrojan Menu$mwisho                   "
    echo -e " $orange[5]$mwisho.\033[1mAdd/Change Domain$mwisho   $orange[6]$mwisho.\033[1mRenew Certificate$mwisho                "
    echo -e " $orange[7]$mwisho.\033[1mRestart Services$mwisho    $orange[8]$mwisho.\033[1mCheck Service Status$mwisho                    "
    echo -e " $orange[9]$mwisho.\033[1mCheck System Status$mwisho $orange[10]$mwisho.\033[1mBlack Listed Sites$mwisho                     "
    echo -e " $orange[11]$mwisho.\033[1mBackup BOT$mwisho         $orange[12]$mwisho.\033[1mReboot$mwisho                           "
    echo -e "$siani╰════════════════════════════════════════════╯\033[0m"
    echo -e "$siani╭════════════════════════════════════════════╮\033[0m"
    echo -e "   Version        :    $orange \033[1mWebsocket v 2.0   $mwisho                                            "
    echo -e "   AutoScript By  :    $orange \033[1mPixer Jason $mwisho                                           "
    echo -e "   License        :    $orange \033[1mGhostcraker $mwisho                                                "
    echo -e "$siani╰════════════════════════════════════════════╯\033[0m"
    read -p "$kidude Enter Option (1-12) " option


    if [[ $option == 1 ]]; then
        clear
        SSH-MENU
        read -rp "[*]Press Any key To Continue.."
    elif [[ $option == 2 ]]; then
        clear
        vmessmenu
        read -rp "[*]Press Any key To Continue.."
    elif [[ $option == 3 ]]; then
        clear
        vlessmenu
        read -rp "[*]Press Any key To Continue.."
    elif [[ $option == 4 ]]; then
        clear
        trojanmenu
        read -rp "[*]Press Any key To Continue.."
    elif [[ $option == 5 ]]; then
        clear
        changedomain
        read -rp "[*]Press Any key To Continue.."
    elif [[ $option == 6 ]]; then
        clear
        renewcertificate             
        read -rp "[*]Press Any key To Continue.."
    elif [[ $option == 7 ]]; then
        clear
        restartservices
        read -rp "[*]Press Any key To Continue.."
    elif [[ $option == 8 ]]; then
        clear
        serviceactivities
        read -rp "[*]Press Any key To Continue.."
    elif [[ $option == 9 ]]; then
        clear
        systemstatus
        read -rp "[*]Press Any key To Continue.."
    elif [[ $option == 10 ]]; then
        clear
        listblockeddomains
        read -rp "[*]Press Any key To Continue.." 
    
    elif [[ $option == 11 ]]; then
        clear
        bot
        read -rp "[*]Press Any key To Continue.." 
    elif [[ $option == 12 ]]; then
        clear
        echo -e "${kubali}Rebooting system...${mwisho}"
        sleep 2
        reboot 
        
    else
        echo -e "${kataa_kidude}Invalid Input!${mwisho}"
        sleep 1
        clear
    fi  
done    
