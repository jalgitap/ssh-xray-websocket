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
todayday=$(date +%A)
todaydate=$(date +%Y-%m-%d)
todaytime=$(date +%H:%M:%S)

_APISERVER=127.0.0.1:10085
_XRAY=/usr/local/bin/xray

apidata () {
    local ARGS=
    if [[ $1 == "reset" ]]; then
      ARGS="reset: true"
    fi
    $_XRAY api statsquery --server=$_APISERVER "${ARGS}" \
    | awk '{
        if (match($1, /"name":/)) {
            f=1; gsub(/^"|link"|,$/, "", $2);
            split($2, p,  ">>>");
            printf "%s:%s->%s\t", p[1],p[2],p[4];
        }
        else if (match($1, /"value":/) && f){
          f = 0;
          gsub(/"/, "", $2);
          printf "%.0f\n", $2;
        }
        else if (match($0, /}/) && f) { f = 0; print 0; }
    }'
}

format_bytes() {
    local bytes=$1
    local unit=""
    if (( bytes >= 1024 )); then
        local units=("KB" "MB" "GB")
        local i=0
        while (( bytes >= 1024 && i < ${#units[@]} )); do
            bytes=$(( bytes / 1024 ))
            unit=${units[i]}
            ((i++))
        done
    fi
    echo "${bytes}${unit}"
}

print_sum() {
    local DATA="$1"
    local PREFIX="$2"
    local SORTED=$(echo "$DATA" | grep "^${PREFIX}" | sort -r)
    local SUM=$(echo "$SORTED" | awk -v fbytes=format_bytes '
        /->up/{us+=$2}
        /->down/{ds+=$2}
        END{
            printf "SUM->up:\t%s\nSUM->down:\t%s\nSUM->TOTAL:\t%s\n", fbytes(us), fbytes(ds), fbytes(us+ds);
        }')
    echo -e "${SORTED}\n${SUM}" \
    | column -t
}

print_user_traffic() {
    local DATA="$1"
    local USER_DATA=$(echo "$DATA" | grep "^user")
    local USERS=$(echo "$USER_DATA" | awk '{print $1}' | cut -d':' -f2 | sort)
    local USER_TRAFFIC=$(echo "$USER_DATA" | awk '{print $1,$2}' OFS='\t' | sort)

    echo -e " \033[1mUsername\t\tTraffic\033[0m"
    echo -e "$teal_color╒═════════════════════════════════════════════╕\033[0m"    
    local first_user=true
    while read -r line; do
        local USERNAME=$(echo "$line" | awk '{print $1}' | cut -d':' -f2)
        local UPLINK=$(format_bytes $(echo "$line" | awk '{print $2}'))
        local DOWNLINK=$(format_bytes $(echo "$line" | awk '{print $3}'))
        if [ "$first_user" = false ]; then
            echo -e "$PURPLE+════════════════════════════════════════════+\033[0m"
        else
            first_user=false
        fi
        echo -e "  $USERNAME\t\t$UPLINK\t$DOWNLINK"
    done <<< "$USER_TRAFFIC"
    echo -e "$teal_color╘════════════════════════════════════════════╛\033[0m"
}

echo -e "$PURPLE╒════════════════════════════════════════════╕\033[0m"
echo -e " \033[0;41;36m                \033[1mTraffic Controller\033[0m"
echo -e "$PURPLE╘════════════════════════════════════════════╛\033[0m"
echo -e "$teal_color╒═════════════════════════════════════════════╕\033[0m"
echo -e "     \033[1m[-Date-]     \033[1m[-Day-]     \033[1m[-Time-]$mwisho                   "
echo -e "     \033[1m$orange$todaydate$mwisho   \033[1m$orange$todayday$mwisho   \033[1m$orange$todaytime$mwisho              "
echo -e "$teal_color╘════════════════════════════════════════════╛\033[0m"


DATA=$(apidata $1)
echo
