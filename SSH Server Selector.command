#!/bin/bash

# ANSI color codes
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
RESET='\033[0m'

# Configuration file location
CONFIG_FILE="$HOME/.config/ssh-server-selector/servers"

# Check if configuration file exists
if [[ ! -f $CONFIG_FILE ]]; then
    echo -e "${YELLOW}Configuration file not found at ${CONFIG_FILE}.${RESET}"
    echo "Please create the file with the format: user:host:port:label"
    exit 1
fi

# Load servers from configuration file into an array
SERVERS=()
while IFS= read -r line; do
    SERVERS+=("$line")
done < "$CONFIG_FILE"

# Display server list
echo -e "${CYAN}Select a server to connect to:${RESET}"
for i in "${!SERVERS[@]}"; do
    IFS=':' read -r user host port label <<< "${SERVERS[i]}"
    echo -e "${YELLOW}$((i+1)). ${label} ${RESET}(${user}@${host}:${port})"
done

# Get user selection
echo -ne "\n${CYAN}Enter the number of the server: ${RESET}"
read -r selection
if [[ $selection -lt 1 || $selection -gt ${#SERVERS[@]} ]]; then
    echo -e "${YELLOW}Invalid selection.${RESET}"
    exit 1
fi

# Extract selected server details
selected_server="${SERVERS[selection-1]}"
IFS=':' read -r user host port label <<< "$selected_server"

# Connect to the selected server
echo -e "${GREEN}Connecting to $label...${RESET}\n"

ssh -p "$port" "$user@$host"
