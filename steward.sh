#!/usr/bin/env bash

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

readonly STEWARDVersion=2
readonly STEWARDRevision=6

STEWARDInstall=1

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
# source "loading.sh"

# ============================================================ #
# ================== < Load Configurables > ================== #
# ============================================================ #

steward_startup() {
  if [ "$STEWARDDebug" ]; then return 1; fi

  # Make sure that we save the iptable files
  local banner=()

  format_center_literals \
    "███████╗████████╗███████╗██╗    ██╗ █████╗ ██████╗ ██████╗"
  banner+=("$FormatCenterLiterals")
  format_center_literals \
    " ██╔════╝╚══██╔══╝██╔════╝██║    ██║██╔══██╗██╔══██╗██╔══██╗"
  banner+=("$FormatCenterLiterals")
  format_center_literals \
    " ███████╗   ██║   █████╗  ██║ █╗ ██║███████║██████╔╝██║  ██║"
  banner+=("$FormatCenterLiterals")
  format_center_literals \
    " ╚════██║   ██║   ██╔══╝  ██║███╗██║██╔══██║██╔══██╗██║  ██║"
  banner+=("$FormatCenterLiterals")
  format_center_literals \
    " ███████║   ██║   ███████╗╚███╔███╔╝██║  ██║██║  ██║██████╔╝"
  banner+=("$FormatCenterLiterals")
  format_center_literals \
    " ╚══════╝   ╚═╝   ╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ "
  banner+=("$FormatCenterLiterals")
  format_center_literals \
    "¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯"
  banner+=("$FormatCenterLiterals")

  clear

  if [ "$STEWARDAuto" ]; then echo -e "$CBlu"; else echo -e "$CRed"; fi

  for line in "${banner[@]}"; do
    echo "$line"; sleep 0.05
  done

  echo # Do not remove.

  sleep 0.1
  local -r stewardRepository="github.com/ServerCS32/Steward"
  format_center_literals "${CGrn}Site: ${CRed}$stewardRepository$CClr"
  echo -e "$FormatCenterLiterals \n"

  sleep 0.5

  sleep 0.1
  local -r versionInfo="${CSRed}STEWARD $STEWARDVersion$CClr"
  local -r revisionInfo="(rev. $CSBlu$STEWARDRevision$CClr)"
  local -r credits="by$CCyn Sameer$CClr"
  format_center_literals "$versionInfo $revisionInfo $credits"
  echo -e "$FormatCenterLiterals"

# Check if STEWARDInstall is set to 1
if [ "$STEWARDInstall" -eq 1 ]; then
    echo -e "\n"
    # Display a message in red color
    format_center_literals "${CSRed}{ Please run setup.sh to install the Steward }$CClr"
    echo -e "$FormatCenterLiterals"
    exit 1
fi


  echo -e "\n"

  show_menu


}

check_services() {
    # Function to print a larger dot
    print_larger_dot() {
        echo -n "●"
    }

    # Check if cloudflared is running
    if pgrep -x "cloudflared" > /dev/null; then
        cloudflared_status="Running"
    else
        cloudflared_status="Not running"
    fi

    # Check if apache2 is running
    if pgrep -x "apache2" > /dev/null; then
        apache2_status="Running"
    else
        apache2_status="Not running"
    fi

    # Check if both services are running
    if [ "$cloudflared_status" = "Running" ] && [ "$apache2_status" = "Running" ]; then
        format_center_literals "[ ${CSYel}Server Status: ${CSGrn}$(print_larger_dot) Server is Active$CClr ]"
        echo -e "$FormatCenterLiterals";
    else
        format_center_literals "[ ${CSYel}Server Status: ${CSRed}$(print_larger_dot) Server is not Active$CClr ]"
        echo -e "$FormatCenterLiterals";
    fi

    echo -e "\n\n"
}

show_menu() {


 local -r stewardRepository="TO BE CREATED"

 check_services


echo -e "$CSRed----------------$CClr $CSYel Main Menu $CClr $CSRed----------------$CClr \n \n"


    echo -e "${CRed}[${CSYel}1$CClr${CRed}]$CClr ${CCyn} Start Server$CClr"
    sleep 0.1
    echo -e "${CRed}[${CSYel}2$CClr${CRed}]$CClr ${CCyn} Stop Server$CClr"
    sleep 0.1
    echo -e "${CRed}[${CSYel}3$CClr${CRed}]$CClr ${CCyn} Restart Server$CClr"
    sleep 0.1
    echo -e "${CRed}[${CSYel}4$CClr${CRed}]$CClr ${CCyn} Add a Website$CClr"
    sleep 0.1
    echo -e "${CRed}[${CSYel}5$CClr${CRed}]$CClr ${CCyn} Edit a Website$CClr"
    sleep 0.1
    echo -e "${CRed}[${CSYel}6$CClr${CRed}]$CClr ${CCyn} Show all Websites$CClr"
    sleep 0.1
    echo -e "${CRed}[${CSYel}7$CClr${CRed}]$CClr ${CCyn} Disable a Website$CClr"
    sleep 0.1
    echo -e "${CRed}[${CSYel}8$CClr${CRed}]$CClr ${CCyn} Enable a Website$CClr"
    sleep 0.1
    echo -e "${CRed}[${CSYel}9$CClr${CRed}]$CClr ${CCyn} Enable Server$CClr"
    sleep 0.1
    echo -e "${CRed}[${CSYel}10$CClr${CRed}]$CClr ${CCyn}Disable Server$CClr"
    sleep 0.1
    echo -e "${CRed}[${CSYel}0$CClr${CRed}]$CClr ${CCyn} Exit$CClr"
    echo -e "\n"

    while true; do

    echo -n -e "\e[34mEnter your choice: \e[0m" # Blue color, no newline
    read -r choice
    case $choice in
        1) start_server ;;
        2) stop_server ;;
        3) restart_server ;;
        4) add_domain ;;
        5) edit_website ;;
        6) show_websites ;;
        7) disable_website ;;
        8) enable_website ;;
        9) enable_server ;;
        10) disable_server ;;
        0) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done

}

enable_website() {
   check_website_status
    echo -e "\n"
   echo -n -e "\e[34mEnter the website's URL to Enable: \e[0m" # Blue color, no newline
    read -r enable_url
uncomment_next_two_lines "$enable_url"
    check_website_status
    echo -e "\n"
    exit 0
}

disable_website() {
  check_website_status
  echo -e "\n"
  echo -n -e "\e[34mEnter the website's URL to Disable: \e[0m" # Blue color, no newline
    read -r disable_url
comment_out_next_two_lines "$disable_url"
  check_website_status
  echo -e "\n"
  exit 0
}

start_server() {
    echo -e "\n"
    echo -e "${CRed}[${CSYel}*$CClr${CRed}]$CClr Starting Apache2 service.... \n"
    sudo service apache2 start
    if [ $? -eq 0 ]; then
        echo -e "${CGrn}[${CGrn}*$CClr${CGrn}]$CClr Apache2 service started successfully. \n"
    else
        echo -e "Failed to start Apache2 service. \n"
    fi

    echo -e "${CRed}[${CSYel}*$CClr${CRed}]$CClr Starting Cloudflared service.... \n"
    sudo service cloudflared start
    if [ $? -eq 0 ]; then
        echo -e "${CGrn}[${CGrn}*$CClr${CGrn}]$CClr Cloudflared service started successfully. \n"
    else
        echo -e "${CSRed}Failed to start Cloudflared service. $CClr \n"
    fi

    show_menu
}


stop_server() {
    echo -e "\n"
    echo -e "${CRed}[${CSYel}*$CClr${CRed}]$CClr Stopping Apache2 service.... \n"
    sudo service apache2 stop
    if [ $? -eq 0 ]; then
        echo -e "${CGrn}[${CGrn}*$CClr${CGrn}]$CClr Apache2 service stopped successfully. \n"
    else
        echo -e "Failed to stop Apache2 service. \n"
    fi

    echo -e "${CRed}[${CSYel}*$CClr${CRed}]$CClr Stopping Cloudflared service.... \n"
    sudo service cloudflared stop
    if [ $? -eq 0 ]; then
        echo -e "${CGrn}[${CGrn}*$CClr${CGrn}]$CClr Cloudflared service stopped successfully. \n"
    else
        echo -e "${CSRed}Failed to stopped Cloudflared service. $CClr \n"
    fi

    show_menu
}


restart_server() {
    echo -e "\n"
    echo -e "${CRed}[${CSYel}*$CClr${CRed}]$CClr Restarting Apache2 service.... \n"
    sudo service apache2 restart
    if [ $? -eq 0 ]; then
        echo -e "${CGrn}[${CGrn}*$CClr${CGrn}]$CClr Apache2 service restarted successfully. \n"
    else
        echo -e "Failed to restart Apache2 service. \n"
    fi

    echo -e "${CRed}[${CSYel}*$CClr${CRed}]$CClr Restarting Cloudflared service.... \n"
    sudo service cloudflared restart
    if [ $? -eq 0 ]; then
        echo -e "${CGrn}[${CGrn}*$CClr${CGrn}]$CClr Cloudflared service restarted successfully. \n"
    else
        echo -e "${CSRed}Failed to restart Cloudflared service. $CClr \n"
    fi

    show_menu
}


add_domain() {

  echo -e "\n"

    echo -e "${CRed}[${CSYel}1$CClr${CRed}]$CClr ${CCyn}HTTPS$CClr"
    sleep 0.1
    echo -e "${CRed}[${CSYel}2$CClr${CRed}]$CClr ${CCyn}TCP$CClr"
    sleep 0.1
    echo -e "${CRed}[${CSYel}3$CClr${CRed}]$CClr ${CCyn}SSH$CClr"
    sleep 0.1
    echo -e "${CRed}[${CSYel}4$CClr${CRed}]$CClr ${CCyn}RDP$CClr"
    sleep 0.1
    echo -e "${CRed}[${CSYel}5$CClr${CRed}]$CClr ${CCyn}Main Menu$CClr"
    sleep 0.1
    echo -e "${CRed}[${CSYel}0$CClr${CRed}]$CClr ${CCyn}Exit$CClr"
    echo -e "\n"

  while true; do

    echo -n -e "\e[34mChoose the Protocol you want to use: \e[0m" # Blue color, no newline
    read -r choice
    echo -e "\n"
    case $choice in
        1) add_https;;
        2) add_tcp ;;
        3) add_ssh ;;
        4) add_rdp ;;
        5) show_menu ;;
        0) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done
}

add_https() {

  echo -e "\n"
  echo -e "$CSRed-----$CClr $CSYel Want to use your own port ? $CClr $CSRed-----$CClr \n \n"

    echo -e "${CRed}[${CSYel}1$CClr${CRed}]$CClr ${CCyn}Yes, Want to use my own port$CClr"
    sleep 0.1
    echo -e "${CRed}[${CSYel}2$CClr${CRed}]$CClr ${CCyn}NO, Let the Steward manage your website$CClr"
    sleep 0.1
    echo -e "${CRed}[${CSYel}5$CClr${CRed}]$CClr ${CCyn}Main Menu$CClr"
    sleep 0.1
    echo -e "${CRed}[${CSYel}0$CClr${CRed}]$CClr ${CCyn}Exit$CClr"
    echo -e "\n"

  while true; do

    echo -n -e "\e[34mChoose the Option you want to use: \e[0m" # Blue color, no newline
    read -r choice
    echo -e "\n"
    case $choice in
        1) add_https_local;;
        2) add_https_steward ;;
        5) show_menu ;;
        0) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done
}

add_https_steward() {
    # echo -e "\n"
    echo -e "${CRed}NOTE: $CClr ${CSYel}Only use those Domains which are pointing towards your cloudflare's DNS $CClr"
    echo -e "\n"
    echo -n -e "\e[34mEnter the Domain name: \e[0m" # Blue color, no newline
    read -r domain_name
    echo -e "\n"
    echo -e "${CRed}[${CSYel}*$CClr${CRed}]$CClr Adding a webiste... \n"
    sudo cloudflared tunnel route dns steward "$domain_name"
    echo -e "\n"
    sleep 0.5

    if [ "$(id -u)" != "0" ]; then
        echo "This script must be run with sudo"
        exit 1
    fi

    next_port=$(get_next_port_number)

    # Call append_hostname_to_config function
    append_hostname_to_config "$domain_name" "http://localhost:$next_port"
    echo -e "\n"
    generate_apache_conf "$domain_name" "$next_port"
    echo -e "\n"
    sudo service apache2 restart
    echo -e "\n"
    sudo service cloudflared restart
    echo -e "\n"
    echo -e "${CGrn}[${CGrn}*$CClr${CGrn}]$CClr Website has been Added successfully. \n"
    # Add your command to add a website here
    exit 0
}

add_https_local() {
  # echo -e "\n"
  echo -e "${CRed}NOTE: $CClr ${CSYel}Only use those Domains which are pointing towards your cloudflare's DNS $CClr"
    echo -e "\n"
    echo -n -e "\e[34mEnter the Domain name: \e[0m" # Blue color, no newline
    read -r domain_name
    echo -e "\n"
    sudo cloudflared tunnel route dns steward "$domain_name"
    echo -e "\n"
    sleep 0.5

    if [ "$(id -u)" != "0" ]; then
        echo "This script must be run with sudo"
        exit 1
    fi
    echo -n -e "\e[34mEnter your port: \e[0m" # Blue color, no newline
    read -r choice_port
    
    echo -e "\n"
    # Call append_hostname_to_config function
    append_hostname_to_config "$domain_name" "http://localhost:$choice_port"
    echo -e "\n"
    sudo service apache2 restart
    echo -e "\n"
    sudo service cloudflared restart
    echo -e "\n"
    echo -e "${CGrn}[${CGrn}*$CClr${CGrn}]$CClr Website has been Added successfully. \n"
    echo -e "\n"
    # Add your command to add a website here
    exit 0
}

add_tcp() {
  # echo -e "\n"
  echo -e "${CRed}NOTE: $CClr ${CSYel}Only use those Domains which are pointing towards your cloudflare's DNS $CClr"
    echo -e "\n"
    echo -n -e "\e[34mEnter the Domain name: \e[0m" # Blue color, no newline
    read -r domain_name
    echo -e "\n"
    sudo cloudflared tunnel route dns steward "$domain_name"
    echo -e "\n"
    sleep 0.5

    if [ "$(id -u)" != "0" ]; then
        echo "This script must be run with sudo"
        exit 1
    fi
    echo -n -e "\e[34mEnter your TCP port: \e[0m" # Blue color, no newline
    read -r choice_port
    
    echo -e "\n"
    # Call append_hostname_to_config function
    append_hostname_to_config "$domain_name" "tcp://localhost:$choice_port"
    echo -e "\n"
    sudo service apache2 restart
    echo -e "\n"
    sudo service cloudflared restart
    echo -e "\n"
    echo -e "${CGrn}[${CGrn}*$CClr${CGrn}]$CClr TCP Tunnel Added successfully. \n"
    echo -e "\n"

    echo -e "${CGrn}Here is You TCP connection Diagram :- $CClr"
    echo -e "${CSYel}tcp://localhost:$choice_port =>=>=>=>=>=>=>=> tcp://$domain_name:443"
    echo -e "\n"
    # Add your command to add a website here
    exit 0
}

add_ssh() {
  # echo -e "\n"
  echo -e "${CRed}NOTE: $CClr ${CSYel}Only use those Domains which are pointing towards your cloudflare's DNS $CClr"
    echo -e "\n"
    echo -n -e "\e[34mEnter the Domain name: \e[0m" # Blue color, no newline
    read -r domain_name
    echo -e "\n"
    sudo cloudflared tunnel route dns steward "$domain_name"
    echo -e "\n"
    sleep 0.5

    if [ "$(id -u)" != "0" ]; then
        echo "This script must be run with sudo"
        exit 1
    fi
    
    echo -e "\n"
    # Call append_hostname_to_config function
    append_hostname_to_config "$domain_name" "ssh://localhost:22"
    echo -e "\n"
    sudo service apache2 restart
    echo -e "\n"
    sudo service cloudflared restart
    echo -e "\n"
    echo -e "${CGrn}[${CGrn}*$CClr${CGrn}]$CClr SSH Tunnel Added successfully. \n"
    echo -e "\n"

    echo -e "${CGrn}Here is You TCP connection Diagram :- $CClr"
    echo -e "${CSYel}ssh://localhost:22 =>=>=>=>=>=>=>=> ssh://$domain_name:443"
    echo -e "\n"
    # Add your command to add a website here
    exit 0
}

add_rdp() {
  echo -e "${CRed}NOTE: $CClr ${CSYel}Only use those Domains which are pointing towards your cloudflare's DNS $CClr"
    echo -e "\n"
    echo -n -e "\e[34mEnter the Domain name: \e[0m" # Blue color, no newline
    read -r domain_name
    echo -e "\n"
    sudo cloudflared tunnel route dns steward "$domain_name"
    echo -e "\n"
    sleep 0.5

    if [ "$(id -u)" != "0" ]; then
        echo "This script must be run with sudo"
        exit 1
    fi
    echo -e "\n"
    # Call append_hostname_to_config function
    append_hostname_to_config "$domain_name" "rdp://localhost:3389"
    echo -e "\n"
    sudo service apache2 restart
    echo -e "\n"
    sudo service cloudflared restart
    echo -e "\n"
    echo -e "${CGrn}[${CGrn}*$CClr${CGrn}]$CClr RDP Tunnel Added successfully. \n"
    echo -e "\n"

    echo -e "${CGrn}Here is You TCP connection Diagram :- $CClr"
    echo -e "${CSYel}rdp://localhost:3389 =>=>=>=>=>=>=>=> rdp://$domain_name:443"
    echo -e "\n"
    # Add your command to add a website here
    exit 0
}

edit_website() {
    echo -e "\n"
    read_config
    echo -e "\n"
    
    # Calling the function
    replace_service
}

show_websites() {
    echo -e "\n"
    echo -e "${CRed}[${CSYel}*$CClr${CRed}]$CClr Showing all websites... \n"
    read_config
    echo -e "\n"
    echo -e "${CRed}[${CSYel}*$CClr${CRed}]$CClr Showing status of all websites... \n"
    check_website_status
    echo -e "\n"
    exit 0
}

delete_website() {
    echo "Deleting a website..."
    # Add your command to delete a website here
}

enable_server() {
    echo -e "\n"
    echo -e "${CRed}[${CSYel}*$CClr${CRed}]$CClr Enabling server..."
    echo -e "\n"
    sudo systemctl enable apache2
    sudo systemctl enable cloudflared
    sleep 0.5
    echo -e "\n"
    echo -e "${CGrn}Server Enabled successfully $CClr"
    echo -e "\n"
    echo -e "${CSYel}This will automatically start your server on every boot $CClr"
    echo -e "\n"

    show_menu
}

disable_server() {
    echo -e "\n"
    echo -e "${CRed}[${CSYel}*$CClr${CRed}]$CClr Disabling server..."
    echo -e "\n"
    sudo systemctl disable apache2
    sudo systemctl disable cloudflared
    sleep 0.5
    echo -e "\n"
    echo -e "${CGrn}Server Disabled successfully $CClr"
    echo -e "\n"
    echo -e "${CSYel}This will not automatically start your server on every boot $CClr"
    echo -e "\n"

    show_menu
}

# Disable website
comment_out_next_two_lines() {
    local input_to_find
    input_to_find="$1"

    # Check if the file exists
    if [ ! -f "/etc/cloudflared/config.yml" ]; then
        echo "Config file not found: /etc/cloudflared/config.yml"
        return 1
    fi

    # Check if input is provided
    if [ -z "$input_to_find" ]; then
        echo "Error: Input is required."
        return 1
    fi

    # Search for matching lines in the config file
    matching_lines=$(grep -n "# $input_to_find" /etc/cloudflared/config.yml)

    # Check if any matching lines were found
    if [ -z "$matching_lines" ]; then
        echo "No matching lines found for '$input_to_find'"
        return 1
    fi

    # Extract line numbers from matching lines
    line_numbers=$(echo "$matching_lines" | cut -d ':' -f 1)

    # Comment out the next two lines after each match
    while read -r line_number; do
        for ((i=0; i<2; i++)); do
            next_line=$((line_number + i + 1))
            sed -i "${next_line}s/^/# /" /etc/cloudflared/config.yml
        done
    done <<< "$line_numbers"
    sudo service cloudflared restart
    echo -e "\n"
    echo -e "${CGrn}Website Disbaled Successfully $CClr"

}


# Enable website 
uncomment_next_two_lines() {
    local input_to_find
    input_to_find="$1"

    # Check if the file exists
    if [ ! -f "/etc/cloudflared/config.yml" ]; then
        echo "Config file not found: /etc/cloudflared/config.yml"
        return 1
    fi

    # Check if input is provided
    if [ -z "$input_to_find" ]; then
        echo "Error: Input is required."
        return 1
    fi

    # Search for matching lines in the config file
    matching_lines=$(grep -n "# $input_to_find" /etc/cloudflared/config.yml)

    # Check if any matching lines were found
    if [ -z "$matching_lines" ]; then
        echo "No matching lines found for '$input_to_find'"
        return 1
    fi

    # Extract line numbers from matching lines
    line_numbers=$(echo "$matching_lines" | cut -d ':' -f 1)

    # Uncomment the next two lines after each match
    while read -r line_number; do
        for ((i=0; i<2; i++)); do
            next_line=$((line_number + i + 1))
            sed -i "${next_line}s/^# //" /etc/cloudflared/config.yml
        done
    done <<< "$line_numbers"
    sudo service cloudflared restart
    echo -e "\n"
    echo "Website Enabled successfully"
    exit 0
}


install_dependencies() {
    # Check if Apache2 is installed
    if ! dpkg -l | grep -q apache2; then
        echo "Apache2 is not installed, installing..."
        sudo apt-get update
        sudo apt-get install apache2 -y
        echo "Apache2 installed successfully."
    else
        echo "Apache2 is already installed."
    fi

    # Check if Cloudflared is installed
    if ! command -v cloudflared &> /dev/null; then
        echo "Cloudflared is not installed, installing..."
        sudo apt-get update
        sudo apt-get install -y wget
        wget -qO - https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-amd64.deb | sudo dpkg -i -
        echo "Cloudflared installed successfully."
    else
        echo "Cloudflared is already installed."
    fi
}



# Check website status
check_website_status() {
    config_file="/etc/cloudflared/config.yml"
    enabled_websites=()

    # Check if the config file exists
    if [ ! -f "$config_file" ]; then
        echo "Config file not found: $config_file"
        return 1
    fi

    # Read the config file line by line
    while IFS= read -r line; do
        # Check if the line contains 'hostname'
        if [[ $line =~ ^[[:space:]]*-[\[:space:]]+hostname:[[:space:]]+([^#]+) ]]; then
            # Extract the enabled website name
            enabled_website="${BASH_REMATCH[1]}"
            enabled_website="${enabled_website//[[:blank:]]/}" # Remove leading/trailing whitespace
            enabled_websites+=("$enabled_website")
        fi
    done < "$config_file"

    # Print disabled website (if commented out)
    echo -e "\n"
        echo -e "\e[31m  Disabled websites: \n"
    grep -oP '^[[:space:]]*#[[:space:]]*-[[:space:]]+hostname:[[:space:]]+\K.*' "$config_file" | while IFS= read -r disabled_website; do
        echo -e "\e[31m●\e[0m Disabled website: $disabled_website"
    done
    echo -e "\n"
    # Print enabled websites
    echo -e "\e[32m  Enabled websites: \n"
    for website in "${enabled_websites[@]}"; do
        echo -e "\e[32m●\e[0m Enabled Website: $website"
    done
}

# Edit website's Data
replace_service() {
    local input_to_find
    local input_to_replace

    # Prompt user for input to find
    echo -n -e "\e[34mEnter the Domain name: \e[0m" # Blue color, no newline
    read -r input_to_find
    # read -p "Enter your new localhost service: " input_to_find
    echo -e "\n"
    # Prompt user for input to replace
    echo -n -e "\e[34mEnter your new localhost service: \e[0m" # Blue color, no newline
    read -r input_to_replace
    # read -p "Enter text to replace with: " input_to_replace
    
    # Check if the file exists
    if [ ! -f "/etc/cloudflared/config.yml" ]; then
        echo "Config file not found: /etc/cloudflared/config.yml"
        return 1
    fi

    # Check if inputs are provided
    if [ -z "$input_to_find" ] || [ -z "$input_to_replace" ]; then
        echo "Error: Both inputs are required."
        return 1
    fi

    # Search for matching lines in the config file
    matching_lines=$(grep -n "# $input_to_find" /etc/cloudflared/config.yml)

    # Check if any matching lines were found
    if [ -z "$matching_lines" ]; then
        echo "No matching lines found for '$input_to_find'"
        return 1
    fi

    # Extract line numbers from matching lines
    line_numbers=$(echo "$matching_lines" | cut -d ':' -f 1)

    # Replace the content in the second line after each match
    while read -r line_number; do
        next_line=$((line_number + 2))
        sed -i "${next_line}s#^\(.*\)#    service: $input_to_replace#" /etc/cloudflared/config.yml
        echo -e "\n"
        sudo service cloudflared restart
        echo -e "${CGrn}You Data has been modified Successfully $CClr \n"
    done <<< "$line_numbers"

    exit 0
}


# Showing all websites List

read_config() {
    # Check if the config file exists
    if [ ! -f "/etc/cloudflared/config.yml" ]; then
        echo "Config file not found."
        exit 1
    fi
    
    # Read the lines of the config file starting from the line after the last read
    while read -r line; do
        # Check if the line contains the website name
        if [[ $line =~ ^\s*# ]]; then
            # Extract the website name
            website_name=$(echo "$line" | cut -d '#' -f 2)
        fi
        
        # Check if the line contains the service name
        if [[ $line =~ ^\s*service:\ (.+) ]]; then
            # Extract the service name
            service_name="${BASH_REMATCH[1]}"
            # Output the results
            echo -e "${CSYel}Website URL:      $CClr${CCyn}$website_name $CClr"
            echo -e "${CSYel}Localhost Service: $CClr${CCyn}$service_name $CClr"
            echo "============================="
        fi
    done < <(sed -n "/^[^#]/,+5p" /etc/cloudflared/config.yml)
}

# Function to get the next consecutive port number
get_next_port_number() {
    local config_file="/etc/cloudflared/config.yml"
    local last_port_number=0

    # Check if the config file exists
    if [ ! -f "$config_file" ]; then
        echo "Config file not found: $config_file"
        return 1
    fi

    # Get the third last line
    local third_last_line=$(tail -n 4 "$config_file" | head -n 1)

    # Extract port number from the third last line
    if grep -qE 'service:.*:[0-9]+' <<< "$third_last_line"; then
        last_port_number=$(grep -Eo 'service:.*:[0-9]+' <<< "$third_last_line" | awk -F ':' '{print $NF}')
    fi

    # If no port number found, set default port to 81
    if [ "$last_port_number" -eq 0 ]; then
        echo "81"
    else
        # Calculate the next consecutive port number
        echo "$((last_port_number + 1))"
    fi
}

# Function to append hostname data to the second last line of config.yml
append_hostname_to_config() {
    local hostname="$1"
    local service="$2"
    local config_file="/etc/cloudflared/config.yml"

    # Checking if the file exists
    if [ ! -f "$config_file" ]; then
        echo "Config file not found: $config_file"
        return 1
    fi

    # Getting the line number of the second last line
    local second_last_line=$(awk '{line[NR]=$0} END {print NR-2}' "$config_file")

    # Add an empty line before appending the hostname data
    # sed -i "${second_last_line}a " "$config_file"

    # Appending the domain_name data to the second last line of the file
    # sed -i "${second_last_line}i \\# $hostname" "$config_file"
    sed -i "${second_last_line}i \\# $domain_name\n  - hostname: $domain_name\n    service: $service" "$config_file"

    echo "Hostname data appended to $config_file"
}

# Function to generate Apache configuration file
generate_apache_conf() {
    local domain_name="$1"
    local next_port="$2"
    local conf_file="/etc/apache2/sites-available/${domain_name//-/.}.conf"
    local domain_directory="/var/www/${domain_name//-/.}"

    # Check if Apache config directory exists
    if [ ! -d "/etc/apache2/sites-available" ]; then
        echo "Apache config directory not found."
        return 1
    fi

    # Check if the config file already exists
    if [ -f "$conf_file" ]; then
        echo "Configuration file already exists: $conf_file"
        return 1
    fi

    # Check if the domain directory already exists
    if [ -d "$domain_directory" ]; then
        echo "Domain directory already exists: $domain_directory"
        return 1
    fi

    # Create the domain directory
    sudo mkdir -p "$domain_directory"
    sudo chown -R www-data:www-data "$domain_directory"

    # Create a sample index.html file in the domain directory
    echo "<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Website is Up and Running</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            text-align: center;
        }
        .container {
            max-width: 600px;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
	h1 {
	    color: #90EE90;
	}
        h2 {
            color: #007bff;
            font-family: cursive, sans-serif;
        }
        p {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
	<h1>Your Website is UP & Running</h1>
	<p>Congratulations! Your website is now live and accessible to the world.</p>
        <h2>Steward</h2>
    </div>
</body>
</html>
" | sudo tee "$domain_directory/index.html" > /dev/null

    # Set permissions for all files and directories within the domain directory
    sudo chmod -R 755 "$domain_directory"

    # Add Listen directive to ports.conf
    sudo sed -i "1i\Listen $next_port" /etc/apache2/ports.conf

    # Create the Apache configuration file
    cat > "$conf_file" <<EOF
<VirtualHost *:$next_port>
    ServerAdmin webmaster@$domain_name
    ServerName $domain_name
    ServerAlias www.$domain_name
    DocumentRoot $domain_directory
    ErrorLog \${APACHE_LOG_DIR}/$domain_name-error.log
    CustomLog \${APACHE_LOG_DIR}/$domain_name-access.log combined
    <Directory $domain_directory>
        Options FollowSymlinks Includes ExecCGI
        AllowOverride All
        Require all granted
        Order allow,deny
        allow from all
    </Directory>
</VirtualHost>
EOF

    echo "Apache configuration file generated: $conf_file"
    echo -e "\n"    

    # Enable the site
    sudo a2ensite "$(basename "$conf_file")"
    # echo -e "\n"
    # Restart Cloudflared service
    sudo service cloudflared restart
    # Restart Apache service
    sudo service apache2 restart
    echo -e "Apache2 service restarted"
    echo -e "\n"
    echo -e "${CGrn}Congratulations Your Website has been Added"
    echo -e "${CGrn}Your website's public_html path is:$CClr ${CSYel}$domain_directory $CClr"
    echo -e "\n"
    exit 0
}


steward_shutdown() {
  if [ $STEWARDDebug ]; then return 1; fi

  # Show the header if the subroutine has already been loaded.
  if type -t steward_header &> /dev/null; then
    steward_header
  fi

  echo -e "$CWht[$CRed-$CWht]$CRed $STEWARDCleanupAndClosingNotice$CClr"


  echo -e "$CWht[$CGrn+$CWht] $CGrn$STEWARDCleanupSuccessNotice$CClr"
  echo -e "$CWht[$CGrn+$CWht] $CGry$STEWARDThanksSupportersNotice$CClr"

  sleep 2

  clear

  exit 0
}





# In case of unexpected termination, run steward_shutdown.
trap steward_handle_exit SIGINT SIGHUP




# ============================================================ #
# =============== < Resolution & Positioning > =============== #
# ============================================================ #
steward_set_resolution() { # Windows + Resolution

  SCREEN_SIZE=$(xdpyinfo | grep dimension | awk '{print $4}' | tr -d "(")
  SCREEN_SIZE_X=$(printf '%.*f\n' 0 $(echo $SCREEN_SIZE | sed -e s'/x/ /'g | awk '{print $1}'))
  SCREEN_SIZE_Y=$(printf '%.*f\n' 0 $(echo $SCREEN_SIZE | sed -e s'/x/ /'g | awk '{print $2}'))

  # Calculate proportional windows
  if hash bc ;then
    PROPOTION=$(echo $(awk "BEGIN {print $SCREEN_SIZE_X/$SCREEN_SIZE_Y}")/1 | bc)
    NEW_SCREEN_SIZE_X=$(echo $(awk "BEGIN {print $SCREEN_SIZE_X/$STEWARDWindowRatio}")/1 | bc)
    NEW_SCREEN_SIZE_Y=$(echo $(awk "BEGIN {print $SCREEN_SIZE_Y/$STEWARDWindowRatio}")/1 | bc)

    NEW_SCREEN_SIZE_BIG_X=$(echo $(awk "BEGIN {print 1.5*$SCREEN_SIZE_X/$STEWARDWindowRatio}")/1 | bc)
    NEW_SCREEN_SIZE_BIG_Y=$(echo $(awk "BEGIN {print 1.5*$SCREEN_SIZE_Y/$STEWARDWindowRatio}")/1 | bc)

    SCREEN_SIZE_MID_X=$(echo $(($SCREEN_SIZE_X + ($SCREEN_SIZE_X - 2 * $NEW_SCREEN_SIZE_X) / 2)))
    SCREEN_SIZE_MID_Y=$(echo $(($SCREEN_SIZE_Y + ($SCREEN_SIZE_Y - 2 * $NEW_SCREEN_SIZE_Y) / 2)))

    # Upper windows
    TOPLEFT="-geometry $NEW_SCREEN_SIZE_Xx$NEW_SCREEN_SIZE_Y+0+0"
    TOPRIGHT="-geometry $NEW_SCREEN_SIZE_Xx$NEW_SCREEN_SIZE_Y-0+0"
    TOP="-geometry $NEW_SCREEN_SIZE_Xx$NEW_SCREEN_SIZE_Y+$SCREEN_SIZE_MID_X+0"

    # Lower windows
    BOTTOMLEFT="-geometry $NEW_SCREEN_SIZE_Xx$NEW_SCREEN_SIZE_Y+0-0"
    BOTTOMRIGHT="-geometry $NEW_SCREEN_SIZE_Xx$NEW_SCREEN_SIZE_Y-0-0"
    BOTTOM="-geometry $NEW_SCREEN_SIZE_Xx$NEW_SCREEN_SIZE_Y+$SCREEN_SIZE_MID_X-0"

    # Y mid
    LEFT="-geometry $NEW_SCREEN_SIZE_Xx$NEW_SCREEN_SIZE_Y+0-$SCREEN_SIZE_MID_Y"
    RIGHT="-geometry $NEW_SCREEN_SIZE_Xx$NEW_SCREEN_SIZE_Y-0+$SCREEN_SIZE_MID_Y"

    # Big
    TOPLEFTBIG="-geometry $NEW_SCREEN_SIZE_BIG_Xx$NEW_SCREEN_SIZE_BIG_Y+0+0"
    TOPRIGHTBIG="-geometry $NEW_SCREEN_SIZE_BIG_Xx$NEW_SCREEN_SIZE_BIG_Y-0+0"
  fi
}




# ============================================================ #
# ================= < Load All Subroutines > ================= #
# ============================================================ #
steward_header() {
  format_apply_autosize "[%*s]\n"
  local verticalBorder=$FormatApplyAutosize

  format_apply_autosize "[%*s${CSRed}steward $STEWARDVersion${CSWht}.${CSBlu}$STEWARDRevision$CSRed    ${CSRed}<${CIYel} Thanks for using Steward$CClr$CSRed >%*s$CSBlu]\n"
  local headerTextFormat="$FormatApplyAutosize"


  echo -e "$(printf "$CSRed$verticalBorder" "" | sed -r "s/ /~/g")"
  printf "$CSRed$verticalBorder" ""
  printf "$headerTextFormat" "" ""
  printf "$CSBlu$verticalBorder" ""
  echo -e "$(printf "$CSBlu$verticalBorder" "" | sed -r "s/ /~/g")$CClr"
  echo
  echo
}

steward_shutdown() {
  echo -e "\n"
  echo -e "${CSRed}Exiting Steward....$CClr"
  sleep 0.7
  echo -e "\n"
  exit 0
}
steward_handle_exit() {
  steward_shutdown
  exit 1
}

# ============================================================ #
# ===================== < Steward Loop > ===================== #
# ============================================================ #
steward_main() {

  if [[ $1 == "-i" ]]; then
    install_dependencies
    exit 0  # Exit after installing dependencies
fi

# If -i is not given, run the rest of the program
echo "Running the rest of the program..."

  steward_startup

  steward_set_resolution

  steward_shutdown
}

steward_main # Start steward

# STEWARDSCRIPT END
