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
╔╗ ┌─┐┌─┐┬┌─┬ ┬┌─┐  ╔╗ ┌─┐┌┬┐
╠╩╗├─┤│  ├┴┐│ │├─┘  ╠╩╗│ │ │ 
╚═╝┴ ┴└─┘┴ ┴└─┘┴    ╚═╝└─┘ ┴ 
        (Telegram BOT)    
    ${mwisho}    
    "
}
function get_bot_credentials() {
    read -p "Enter your Telegram Bot Token: " BOT_TOKEN
    read -p "Enter your Telegram Chat ID: " CHAT_ID

    # Save the credentials in a config file
    echo "BOT_TOKEN=$BOT_TOKEN" > "$CONFIG_FILE"
    echo "CHAT_ID=$CHAT_ID" >> "$CONFIG_FILE"
}

# Function to prompt user for Telegram backup password
function get_backup_password() {
    read -p "Enter your backup password: " -s BACKUP_PASSWORD
    echo

    # Encrypt the backup password and save it in the config file
    ENCRYPTED_PASSWORD=$(echo "$BACKUP_PASSWORD" | openssl aes-256-cbc -a -salt -pass pass:"$BOT_TOKEN" 2>/dev/null)
    echo "BACKUP_PASSWORD=$ENCRYPTED_PASSWORD" >> "$CONFIG_FILE"
}

# Function to change bot credentials
function change_bot_credentials() {
    echo "Current Bot Token: $BOT_TOKEN"
    echo "Current Chat ID: $CHAT_ID"
    read -p "Enter new Bot Token: " BOT_TOKEN
    read -p "Enter new Chat ID: " CHAT_ID

    # Update the config file with new credentials
    sed -i "s/BOT_TOKEN=.*/BOT_TOKEN=$BOT_TOKEN/" "$CONFIG_FILE"
    sed -i "s/CHAT_ID=.*/CHAT_ID=$CHAT_ID/" "$CONFIG_FILE"

    echo "Bot credentials updated successfully!"
}

# Function to change backup password
function change_backup_password() {
    read -p "Enter your current backup password: " -s CURRENT_PASSWORD
    echo

    # Decrypt the stored password
    SAVED_PASSWORD=$(grep "BACKUP_PASSWORD=" "$CONFIG_FILE" | cut -d'=' -f2)
    DECRYPTED_PASSWORD=$(echo "$SAVED_PASSWORD" | openssl aes-256-cbc -d -a -salt -pass pass:"$BOT_TOKEN" 2>/dev/null)

    if [ "$DECRYPTED_PASSWORD" == "$CURRENT_PASSWORD" ]; then
        get_backup_password
        echo -e "${kubali_kidude}Backup password updated successfully!${mwisho}"
    else
        echo -e "${kataa}Incorrect password. Backup password remains unchanged.${mwisho}"
    fi
}

# Function to compress files in the backup directory to ZIP format
function compress_files() {
    BACKUP_DIR="/usr/local/etc/xray/backup"
    OUTPUT_FILE="/tmp/backup.zip"

    zip -r "$OUTPUT_FILE" "$BACKUP_DIR"
}

# Function to send the compressed file to Telegram bot
function send_to_telegram() {
    BOT_TOKEN="$1"
    CHAT_ID="$2"
    FILE_PATH="$3"

    curl -s -F document=@"$FILE_PATH" "https://api.telegram.org/bot$BOT_TOKEN/sendDocument" -F chat_id="$CHAT_ID" > /dev/null
}

# Main function
function main() {
    clear
    banner

    # Check if config file exists, if not, prompt user for bot credentials and backup password
    CONFIG_FILE="config.txt"
    if [ ! -f "$CONFIG_FILE" ]; then
        get_bot_credentials
        get_backup_password
    fi

    # Read bot credentials and backup password from the config file
    . "$CONFIG_FILE"

    while true; do
        clear
        banner
        echo ""
        echo "Please select an option:"
        echo "[1]. Change Telegram Bot Credentials"
        echo "[2]. Change Backup Password"
        echo "[3]. Backup and Send to Telegram"
        echo "[4]. Exit"

        read -p "Enter option number (1-4): " choice

        case $choice in
            1)
                change_bot_credentials
                read -rp "press any key to continue"
                ;;
            2)
                change_backup_password
                read -rp "press any key to continue"
                ;;
            3)
                compress_files
                send_to_telegram "$BOT_TOKEN" "$CHAT_ID" "/tmp/backup.zip"
                rm -f "/tmp/backup.zip"
                echo -e "${kubali}Backup sent successfully to Telegram bot!${mwisho}"
                sleep 2
                ;;
            4)
                echo -e "${kataa_kidude}Exiting...${mwisho}"
                break
                ;;
            *)
                echo -e "${kataa}Invalid option. Please try again.${mwisho}"
                sleep 2
                ;;
        esac
    done
}

main
