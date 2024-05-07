#!/bin/bash

# ============================================================ #
# ================== < STEWARD Parameters > ================== #
# ============================================================ #
# Path to directory containing the steward executable script.
readonly STEWARDPath=$(dirname $(readlink -f "$0"))

# Path to directory containing the steward library (scripts).
readonly STEWARDLibPath="$STEWARDPath/lib"

# # Path to the temp. directory available to steward & subscripts.
readonly STEWARDWorkspacePathLibPath="/tmp/fluxspace"
# readonly stewardIPTablesBackup="$STEWARDPath/iptables-rules"

readonly STEWARDVersion=1
readonly STEWARDRevision=2

# Declare window ration bigger = smaller windows
STEWARDWindowRatio=4

# Allow to skip dependencies if required, not recommended
STEWARDSkipDependencies=1



# ============================================================ #
# ================= < Script Sanity Checks > ================= #
# ============================================================ #
if [ $EUID -ne 0 ]; then # Super User Check
  echo -e "\\033[31mAborted, please execute the script as root.\\033[0m"; exit 1
fi

source "$STEWARDLibPath/installer/InstallerUtils-modified.sh"
source "$STEWARDLibPath/FormatUtils.sh"
source "$STEWARDLibPath/ColorUtils.sh"
source "$STEWARDLibPath/IOUtils.sh"

# Function to check if a package is installed
package_installed() {
    dpkg -l "$1" &>/dev/null
}

# Install Apache2 if not installed
if ! package_installed apache2; then
    echo "Apache2 is not installed. Installing..."
    sudo apt-get update
    sudo apt-get install -y apache2
    echo "Apache2 installed successfully."
else
    echo "Apache2 is already installed."
fi

# Install Cloudflared if not installed
if ! package_installed cloudflared; then
    echo "Cloudflared is not installed. Installing..."
    sudo apt-get update
    sudo wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
    sudo dpkg -i cloudflared-linux-amd64.deb
    sudo mkdir -p --mode=0755 /usr/share/keyrings
    curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null
    echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflared.list
    sudo apt-get update && sudo apt-get install cloudflared
    sudo cloudflared service install
    sudo mkdir /etc/cloudflared
    echo "Cloudflared installed successfully."
else
    echo "Cloudflared is already installed."
fi

    # Removing old tunnels named steward
    # sudo cloudflared tunnel cleanup steward
    # sudo cloudflared tunnel delete steward

    # Run cloudflared tunnel login
    echo -e "\n"
sudo cloudflared tunnel login

# Capture the output of the command
output=$(sudo cloudflared tunnel login)

# Check if output contains "https"
if [[ $output == *"https"* ]]; then
    # Print the output with "https" highlighted in yellow
    echo -e "\e[93m$output\e[0m"
fi

# Runtime variable to track the number of times the script is executed
RUNTIME_FILE="$STEWARDLibPath/cloudflared_runtime"
if [ ! -f "$RUNTIME_FILE" ]; then
    echo "1" > "$RUNTIME_FILE"
fi

# Read the current runtime value
RUNTIME=$(cat "$RUNTIME_FILE")

# Increment the runtime variable by 1
((RUNTIME++))
echo "$RUNTIME" > "$RUNTIME_FILE"

# Check if runtime variable is greater than 1
if [ "$RUNTIME" -gt 1 ]; then
    # Ask for confirmation
    echo -n -e "${CSRed}NOTE:$CClr ${CSYel}You may lose your previous configurations. Are you sure you want to continue? (Y/N):$CClr \e[0m" # Blue color, no newline
    read -r choice
    case "$choice" in
        y|Y )
            echo "Continuing..."
            ;;
        n|N )
            echo "Exiting."
            exit 0
            ;;
        * )
            echo "Invalid choice. Exiting."
            exit 1
            ;;
    esac
fi

# Function to create the steward tunnel
create_tunnel() {
    # Run sudo cloudflared tunnel create steward
    sudo cloudflared tunnel create steward
}

# Function to delete the steward tunnel
delete_tunnel() {
    # Run sudo cloudflared tunnel delete steward
    sudo cloudflared tunnel cleanup steward
    sudo cloudflared tunnel delete steward
}

# Function to handle tunnel creation and configuration
create_config() {
    # Attempt to create the tunnel
    output=$(sudo cloudflared tunnel create steward)

    # Check if there was an error during tunnel creation
    if [ $? -ne 0 ]; then
        echo "Error: Unable to create tunnel. Please check your configuration and try again."
        delete_tunnel
    fi

    output=$(sudo cloudflared tunnel create steward)

    # Check if there was an error during tunnel creation
    if [ $? -ne 0 ]; then
        echo "Error: Unable to create tunnel. Please check your configuration and try again."
        exit 1
    fi

    # Extract ID from the last line of the output
    id=$(echo "$output" | tail -n 1 | grep -oP 'id\s+\K\S+')

    # Create config.yml content with the ID
    config_content="tunnel: $id\ncredentials-file: /root/.cloudflared/$id.json\nlogfile: /etc/cloudflare/cloudflare_log_file\ningress:\n      \n  - service: http_status:404\n      "

    # Write config.yml
    echo -e "$config_content" | sudo tee /etc/cloudflared/config.yml > /dev/null
    echo "config.yml created successfully in /etc/cloudflared/ directory."
    # Function to install steward command
    sudo rm /usr/local/bin/steward
    sudo ln -s "$(pwd)/steward.sh" /usr/local/bin/steward
    sudo chmod +x /usr/local/bin/steward
    sudo cloudflared service install


    script_path="steward.sh"
    
# Check if the script exists
if [ -f "$script_path" ]; then
    # Use sed to find and replace "STEWARDInstall=1" with "STEWARDInstall=0"
    sed -i 's/STEWARDInstall=1/STEWARDInstall=0/' "$script_path"
    echo "Update successful: STEWARDInstall set to 0"
else
    echo "Error: Script not found at $script_path"
    exit 1
fi


    
    echo -e "\n"
    echo -e "${CGrn}Steward has been Installed Successfully \n"

}


create_config



